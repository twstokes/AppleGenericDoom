//
//  doomgeneric_objc.m
//  AppleGenericDoom
//
//  Created by Tanner W. Stokes on 7/9/23.
//

#import <Foundation/Foundation.h>
#import <AppleGenericDoom-Swift.h>
#include "doomkeys.h"
//#include "m_argv.h"
#include "doomgeneric.h"

#include <stdio.h>
#include <unistd.h>

#include <stdbool.h>

#define KEYQUEUE_SIZE 16

static unsigned short s_KeyQueue[KEYQUEUE_SIZE];
static unsigned int s_KeyQueueWriteIndex = 0;
static unsigned int s_KeyQueueReadIndex = 0;
static DoomGenericSwift *dgs;
static uint32_t ticks = 0;


static unsigned char convertToDoomKey(unsigned int key){
    return 0;
}

static void addKeyToQueue(int pressed, unsigned int keyCode){
    unsigned char key = convertToDoomKey(keyCode);

    unsigned short keyData = (pressed << 8) | key;

    s_KeyQueue[s_KeyQueueWriteIndex] = keyData;
    s_KeyQueueWriteIndex++;
    s_KeyQueueWriteIndex %= KEYQUEUE_SIZE;
}

static void handleKeyInput(){
}

void DG_Init()
{
    dgs = [DoomGenericSwift shared];
}

void DG_DrawFrame()
{
    ticks++;
    [dgs DG_DrawFrame];
}

void DG_SleepMs(uint32_t ms)
{
    [NSThread sleepForTimeInterval:ms/1000];
}

uint32_t DG_GetTicksMs()
{
    return ticks;
}

int DG_GetKey(int* pressed, unsigned char* doomKey)
{
  if (s_KeyQueueReadIndex == s_KeyQueueWriteIndex){
    //key queue is empty
    return 0;
  }else{
    unsigned short keyData = s_KeyQueue[s_KeyQueueReadIndex];
    s_KeyQueueReadIndex++;
    s_KeyQueueReadIndex %= KEYQUEUE_SIZE;

    *pressed = keyData >> 8;
    *doomKey = keyData & 0xFF;

    return 1;
  }

  return 0;
}

void DG_SetWindowTitle(const char * title)
{
    printf("DG_SetWindowTitle called\n");
}
