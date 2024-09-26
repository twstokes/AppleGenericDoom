//
//  doomgeneric_objc.m
//  AppleGenericDoom
//
//  Created by Tanner W. Stokes on 7/9/23.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_WATCH
#import <AppleGenericDoomWatch_Watch_App-Swift.h>
#elif TARGET_OS_OSX
#import <AppleGenericDoom-Swift.h>
#endif

DoomGenericSwift *dgs;
CFAbsoluteTime timeInSeconds;

void DG_Init()
{
    dgs = [DoomGenericSwift shared];
    timeInSeconds = CFAbsoluteTimeGetCurrent();
}

void DG_DrawFrame()
{
    [dgs DG_DrawFrame];
}

void DG_SleepMs(uint32_t ms)
{
    [NSThread sleepForTimeInterval:ms/1000];
}

uint32_t DG_GetTicksMs()
{
    return (CFAbsoluteTimeGetCurrent() - timeInSeconds) * 1000;
}

int DG_GetKey(int* pressed, unsigned char* doomKey)
{
    #if TARGET_OS_WATCH
    if ([TouchToKeyManager getCurrentReadIndex] == [TouchToKeyManager getCurrentWriteIndex]) {
        return 0;
    } else {
        int key = [TouchToKeyManager getNextKey];

        *pressed = key >> 8;
        *doomKey = key & 0xFF;

        return 1;
    }
    #endif

    return 0;
}

void DG_SetWindowTitle(const char * title)
{
    printf("DG_SetWindowTitle called\n");
}
