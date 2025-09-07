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
}

#if defined(__APPLE__)
#import <TargetConditionals.h>
#endif

#if TARGET_OS_WATCH
#import <AVFoundation/AVFoundation.h>

static boolean avf_initialized = false;
static boolean use_sfx_prefix = true;

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
    // TODO: Map Doom volume/separation to AVAudioEngine node parameters
    (void)channel; (void)vol; (void)sep;
}

static int I_AVF_StartSound(sfxinfo_t *sfxinfo, int channel, int vol, int sep)
{
    // TODO: Decode lump to PCM, schedule on an AVAudioPlayerNode
    (void)sfxinfo; (void)channel; (void)vol; (void)sep;
    return -1;
}

static void I_AVF_StopSound(int channel)
{
    // TODO: Stop the node associated with this channel
    (void)channel;
}

static boolean I_AVF_SoundIsPlaying(int channel)
{
    // TODO: Query node playback state
    (void)channel;
    return false;
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
