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

#include "doomkeys.h"
#include "doomgeneric.h"

#include <stdio.h>
#include <unistd.h>

#include <stdbool.h>

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
    return 0;
}

void DG_SetWindowTitle(const char * title)
{
    printf("DG_SetWindowTitle called\n");
}
