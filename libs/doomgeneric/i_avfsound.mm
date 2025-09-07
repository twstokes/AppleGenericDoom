//
// Minimal AVFoundation-backed sound module scaffold for watchOS
// Provides DG_sound_module for FEATURE_SOUND builds on watchOS.
//

extern "C" {
#include "config.h"
#include "doomtype.h"
#include "i_sound.h"
#include "deh_str.h"
#include "m_misc.h"
#include "w_wad.h"
#include "z_zone.h"
}

#if defined(__APPLE__)
#import <TargetConditionals.h>
#endif

#if TARGET_OS_WATCH
#import <AVFoundation/AVFoundation.h>

static boolean avf_initialized = false;
static boolean use_sfx_prefix = true;
static const int AVF_NUM_CHANNELS = 16;

@interface DGAudio : NSObject
@property(nonatomic,strong) AVAudioEngine *engine;
@property(nonatomic,strong) AVAudioFormat *dstFormat;
@property(nonatomic,strong) NSArray<AVAudioPlayerNode*> *players;
@property(nonatomic,strong) NSMutableArray<NSNumber*> *channelActive; // BOOLs
@property(nonatomic,strong) dispatch_queue_t queue;
@property(nonatomic,strong) NSMutableArray *cache; // of DGSFXEntry*
@property(nonatomic,assign) NSUInteger cacheBytes;
@property(nonatomic,strong) NSMutableArray *channelEntry; // per-channel DGSFXEntry or NSNull
@end

@implementation DGAudio
@end

static DGAudio *g_audio = nil;

@interface DGSFXEntry : NSObject
@property(nonatomic, assign) sfxinfo_t *sfx;
@property(nonatomic, strong) AVAudioPCMBuffer *buffer;
@property(nonatomic, assign) NSUInteger sizeBytes;
@property(nonatomic, assign) int useCount;
@end

@implementation DGSFXEntry @end

static void GetSfxLumpName_AVF(sfxinfo_t *sfx, char *buf, size_t buf_len)
{
    if (sfx->link != NULL)
    {
        sfx = sfx->link;
    }

    if (use_sfx_prefix)
    {
        M_snprintf(buf, buf_len, "ds%s", DEH_String(sfx->name));
    }
    else
    {
        M_StringCopy(buf, DEH_String(sfx->name), buf_len);
    }
}

static boolean I_AVF_InitSound(boolean _use_sfx_prefix)
{
    use_sfx_prefix = _use_sfx_prefix;

    @autoreleasepool {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        NSError *error = nil;

        // Use playback to allow game audio output on watchOS
        if (![session setCategory:AVAudioSessionCategoryPlayback error:&error]) {
            // If this fails we still proceed; module can remain effectively silent
        }
        [session setActive:YES error:&error];

        g_audio = [DGAudio new];
        g_audio.engine = [AVAudioEngine new];
        g_audio.queue = dispatch_queue_create("doom.avf.audio", DISPATCH_QUEUE_SERIAL);

        // Determine output format (mono float32)
        AVAudioFormat *outFmt = [g_audio.engine.outputNode outputFormatForBus:0];
        double sr = outFmt.sampleRate > 0 ? outFmt.sampleRate : 22050.0;
        g_audio.dstFormat = [[AVAudioFormat alloc] initStandardFormatWithSampleRate:sr channels:1];

        // Create players
        NSMutableArray *players = [NSMutableArray arrayWithCapacity:AVF_NUM_CHANNELS];
        g_audio.channelActive = [NSMutableArray arrayWithCapacity:AVF_NUM_CHANNELS];
        g_audio.channelEntry = [NSMutableArray arrayWithCapacity:AVF_NUM_CHANNELS];
        for (int i = 0; i < AVF_NUM_CHANNELS; i++) {
            AVAudioPlayerNode *node = [AVAudioPlayerNode new];
            [g_audio.engine attachNode:node];
            [g_audio.engine connect:node to:g_audio.engine.mainMixerNode format:g_audio.dstFormat];
            [players addObject:node];
            [g_audio.channelActive addObject:@(NO)];
            [g_audio.channelEntry addObject:[NSNull null]];
        }
        g_audio.players = players;
        g_audio.cache = [NSMutableArray array];
        g_audio.cacheBytes = 0;

        // Start engine
        if (![g_audio.engine isRunning]) {
            [g_audio.engine prepare];
            [g_audio.engine startAndReturnError:&error];
        }
    }

    avf_initialized = true;
    return true;
}

static void I_AVF_ShutdownSound(void)
{
    if (!avf_initialized) {
        return;
    }
    @autoreleasepool {
        NSError *error = nil;
        [[AVAudioSession sharedInstance] setActive:NO error:&error];
        if (g_audio) {
            for (AVAudioPlayerNode *n in g_audio.players) {
                [n stop];
                [g_audio.engine detachNode:n];
            }
            [g_audio.engine stop];
            g_audio = nil;
        }
    }
    avf_initialized = false;
}

static int I_AVF_GetSfxLumpNum(sfxinfo_t *sfx)
{
    char namebuf[9];
    GetSfxLumpName_AVF(sfx, namebuf, sizeof(namebuf));
    return W_GetNumForName(namebuf);
}

static void I_AVF_UpdateSound(void)
{
    // no-op for now
}

static void I_AVF_UpdateSoundParams(int channel, int vol, int sep)
{
    if (!avf_initialized) { return; }
    if (channel < 0 || channel >= AVF_NUM_CHANNELS) { return; }
    AVAudioPlayerNode *node = g_audio.players[channel];
    float volume = (float)vol / 127.0f;
    float pan = ((float)sep - 127.0f) / 127.0f; // -1 .. +1
    node.volume = volume;
    node.pan = pan;
}

static int I_AVF_StartSound(sfxinfo_t *sfxinfo, int channel, int vol, int sep)
{
    if (!avf_initialized) { return -1; }
    if (channel < 0 || channel >= AVF_NUM_CHANNELS) { return -1; }

    __block DGSFXEntry *entryToUse = nil;
    // Check cache first
    dispatch_sync(g_audio.queue, ^{
        for (DGSFXEntry *e in g_audio.cache) {
            if (e.sfx == sfxinfo) {
                entryToUse = e;
                // MRU: move to front
                [g_audio.cache removeObject:e];
                [g_audio.cache insertObject:e atIndex:0];
                break;
            }
        }
    });

    if (!entryToUse) {
        // Lookup lump
        int lumpnum = sfxinfo->lumpnum;
        if (lumpnum <= 0) {
            lumpnum = I_AVF_GetSfxLumpNum(sfxinfo);
            if (lumpnum <= 0) { return -1; }
            sfxinfo->lumpnum = lumpnum;
        }

        byte *data = (byte *)W_CacheLumpNum(lumpnum, PU_STATIC);
        unsigned int lumplen = W_LumpLength(lumpnum);
        if (lumplen < 8 || data[0] != 0x03 || data[1] != 0x00) {
            W_ReleaseLumpNum(lumpnum);
            return -1;
        }

        int samplerate = (data[3] << 8) | data[2];
        unsigned int length = (data[7] << 24) | (data[6] << 16) | (data[5] << 8) | data[4];
        if (length > lumplen - 8 || length <= 48) {
            W_ReleaseLumpNum(lumpnum);
            return -1;
        }

        // DMX quirk: skip first 16 and last 16 bytes
        data += 16;
        length -= 32;
        if (length <= 8) {
            W_ReleaseLumpNum(lumpnum);
            return -1;
        }
        const byte *src = data + 8; // skip secondary 8-byte header
        unsigned int frames = length - 8; // 8-bit mono samples

        // Build source float32 buffer
        AVAudioFormat *srcFormat = [[AVAudioFormat alloc] initStandardFormatWithSampleRate:samplerate channels:1];
        AVAudioPCMBuffer *srcBuf = [[AVAudioPCMBuffer alloc] initWithPCMFormat:srcFormat frameCapacity:frames];
        srcBuf.frameLength = frames;
        float *dstCh0 = srcBuf.floatChannelData[0];
        for (unsigned int i = 0; i < frames; i++) {
            dstCh0[i] = ((float)src[i] - 128.0f) / 128.0f;
        }

        // Convert to engine format if needed
        AVAudioPCMBuffer *playBuf = nil;
        if (fabs(g_audio.dstFormat.sampleRate - srcFormat.sampleRate) > 0.5
            || g_audio.dstFormat.channelCount != srcFormat.channelCount
            || g_audio.dstFormat.commonFormat != srcFormat.commonFormat) {
            AVAudioConverter *conv = [[AVAudioConverter alloc] initFromFormat:srcFormat toFormat:g_audio.dstFormat];
            AVAudioFrameCount dstCapacity = (AVAudioFrameCount)((double)frames * g_audio.dstFormat.sampleRate / srcFormat.sampleRate + 16);
            AVAudioPCMBuffer *dstBuf = [[AVAudioPCMBuffer alloc] initWithPCMFormat:g_audio.dstFormat frameCapacity:dstCapacity];
            __block BOOL provided = NO;
            NSError *err = nil;
            AVAudioConverterInputBlock inblk = ^AVAudioBuffer * _Nullable(AVAudioPacketCount inNumberOfPackets, AVAudioConverterInputStatus *outStatus) {
                if (provided) {
                    *outStatus = AVAudioConverterInputStatus_NoDataNow;
                    return (AVAudioBuffer *)nil;
                }
                provided = YES;
                *outStatus = AVAudioConverterInputStatus_HaveData;
                return (AVAudioBuffer *)srcBuf;
            };
            [conv convertToBuffer:dstBuf error:&err withInputFromBlock:inblk];
            if (err) {
                W_ReleaseLumpNum(lumpnum);
                return -1;
            }
            playBuf = dstBuf;
        } else {
            playBuf = srcBuf;
        }

        // Build cache entry and insert
        DGSFXEntry *newEntry = [DGSFXEntry new];
        newEntry.sfx = sfxinfo;
        newEntry.buffer = playBuf;
        newEntry.useCount = 0;
        NSUInteger sizeBytes = (NSUInteger)playBuf.frameLength * playBuf.format.channelCount * sizeof(float);
        newEntry.sizeBytes = sizeBytes;

        dispatch_sync(g_audio.queue, ^{
            [g_audio.cache insertObject:newEntry atIndex:0];
            g_audio.cacheBytes += sizeBytes;
            // Evict if exceeding cache size
            while (g_audio.cacheBytes > (NSUInteger)snd_cachesize && g_audio.cache.count > 1) {
                BOOL evicted = NO;
                for (NSInteger i = g_audio.cache.count - 1; i >= 0; i--) {
                    DGSFXEntry *cand = g_audio.cache[i];
                    if (cand.useCount == 0) {
                        g_audio.cacheBytes -= cand.sizeBytes;
                        [g_audio.cache removeObjectAtIndex:i];
                        evicted = YES;
                        break;
                    }
                }
                if (!evicted) { break; }
            }
        });

        entryToUse = newEntry;
        W_ReleaseLumpNum(lumpnum);
    }

    AVAudioPlayerNode *node = g_audio.players[channel];
    // Apply initial params
    I_AVF_UpdateSoundParams(channel, vol, sep);

    // Schedule and play on queue to avoid threading issues
    dispatch_async(g_audio.queue, ^{
        if (node.isPlaying) {
            [node stop];
        }
        entryToUse.useCount += 1;
        [node scheduleBuffer:entryToUse.buffer atTime:nil options:0 completionHandler:^{
            if (entryToUse.useCount > 0) entryToUse.useCount -= 1;
            g_audio.channelActive[channel] = @(NO);
            g_audio.channelEntry[channel] = [NSNull null];
        }];
        if (!node.isPlaying) {
            [node play];
        }
        g_audio.channelActive[channel] = @(YES);
        g_audio.channelEntry[channel] = entryToUse;
    });

    return channel;
}

static void I_AVF_StopSound(int channel)
{
    if (!avf_initialized) { return; }
    if (channel < 0 || channel >= AVF_NUM_CHANNELS) { return; }
    AVAudioPlayerNode *node = g_audio.players[channel];
    dispatch_async(g_audio.queue, ^{
        id ent = g_audio.channelEntry[channel];
        if (ent != (id)[NSNull null]) {
            DGSFXEntry *e = (DGSFXEntry *)ent;
            if (e.useCount > 0) e.useCount -= 1;
            g_audio.channelEntry[channel] = [NSNull null];
        }
        [node stop];
        g_audio.channelActive[channel] = @(NO);
    });
}

static boolean I_AVF_SoundIsPlaying(int channel)
{
    if (!avf_initialized) { return false; }
    if (channel < 0 || channel >= AVF_NUM_CHANNELS) { return false; }
    return [g_audio.channelActive[channel] boolValue];
}

static void I_AVF_PrecacheSounds(sfxinfo_t *sounds, int num_sounds)
{
    // Optional: Pre-decode sounds. For now, do nothing.
    (void)sounds; (void)num_sounds;
}

static snddevice_t sound_avf_devices[] = {
    SNDDEVICE_SB,
};

sound_module_t DG_sound_module =
{
    sound_avf_devices,
    (int)(sizeof(sound_avf_devices) / sizeof(sound_avf_devices[0])),
    I_AVF_InitSound,
    I_AVF_ShutdownSound,
    I_AVF_GetSfxLumpNum,
    I_AVF_UpdateSound,
    I_AVF_UpdateSoundParams,
    I_AVF_StartSound,
    I_AVF_StopSound,
    I_AVF_SoundIsPlaying,
    I_AVF_PrecacheSounds,
};

#endif // TARGET_OS_WATCH
