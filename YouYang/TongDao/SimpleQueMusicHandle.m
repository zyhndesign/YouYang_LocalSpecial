//
//  SimpleQueMusicHandle.m
//  TongDao
//
//  Created by sunyong on 13-12-10.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//


#import "LoadSimpleMusicNet.h"
#import "AllVariable.h"
#import "ViewController.h"
#import "LoaderViewController.h"

#import "SimpleQueMusicHandle.h"
#import "SimpleQueSceneHandle.h"
#import "SimpleQueHumeHandle.h"
#import "SimpleQueStoryHandle.h"
#import "SimpleQueCommunHandle.h"
#import "SimpleQueVideoHandle.h"

@implementation SimpleQueMusicHandle
static __strong NSMutableArray *allTaskAry;
static long allSize;
static long lenghtP;
static UILabel *impLyLB;
static BOOL Loading;

+ (void)clear
{
    if (Loading)
    {
        LoadSimpleMusicNet *tempProNet = [allTaskAry lastObject];
        [tempProNet cancelLoad];
        [SimpleQueVideoHandle startTask];
    }
    Loading = NO;
    [allTaskAry removeAllObjects];
    allSize = 0;
    lenghtP = 0;
    impLyLB = nil;
}

+ (void)stopTask
{
    if (Loading)
    {
        LoadSimpleMusicNet *tempProNet = [allTaskAry lastObject];
        [tempProNet cancelLoad];
        Loading = NO;
    }
}

+ (BOOL)getLoadingStatus
{
    return Loading;
}

+ (void)setSize:(long)size
{
    if(!Loading)
        allSize = size;
}

+ (long)getSize
{
    return allSize;
}

+ (void)setCurrentLenght:(int)lenght
{
    lenghtP += lenght;
    NSLog(@"%ld-->%ld", allSize, lenghtP);
    if (impLyLB)
    {
        impLyLB.textColor = BlackBGColor;
        impLyLB.text = [NSString stringWithFormat:@"%0.1f %@", lenghtP*100.0/allSize, @"%"];
    }
}

+ (BOOL)getStatus
{
    return allTaskAry.count;
}

+ (void)setImplyLb:(UILabel*)implyLb
{
    impLyLB = implyLb;
    if(Loading)
    {
        impLyLB.textColor = BlackBGColor;
        impLyLB.text = [NSString stringWithFormat:@"%0.1f %@", lenghtP*100.0/allSize, @"%"];
    }
}

+ (void)init
{
    if (!allTaskAry)
    {
        allTaskAry = [[NSMutableArray alloc] init];
    }
}

+ (BOOL)isHaveTask
{
    if (allTaskAry.count > 0) {
        return YES;
    }
    return NO;
}

+ (void)startTask
{
    NSLog(@"taskCount:%d", [allTaskAry count]);
    if(Loading) return;
    lenghtP = 0;
    if (allTaskAry.count > 0)
    {
        Loading = YES;
        [SimpleQueMusicHandle setCurrentLenght:0];
        LoadSimpleMusicNet *tempProNet = [allTaskAry lastObject];
        [tempProNet loadMenuFromUrl];
    }
    else
    {
        //finish
        [AllLoaderViewContr FinishLoad:TaskMusic];
        [SimpleQueMusicHandle LastLoadingJudge];
        NSLog(@"Communite Finish!");
        Loading = NO;
    }
}

+ (void)addTarget:(id)target
{
    if (![SimpleQueMusicHandle isEixstInAry:allTaskAry zipNet:target])
    {
        [allTaskAry addObject:target];
    }
}

+ (BOOL)isEixstInAry:(NSArray*)initAry zipNet:(LoadSimpleMusicNet*)target
{
    NSArray *array = [NSArray arrayWithArray:initAry];
    for (int i = 0; i < array.count; i++)
    {
        LoadSimpleMusicNet *zipNet = [array objectAtIndex:i];
        if ([zipNet.musicUrl isEqualToString:target.musicUrl])
        {
            return YES;
        }
    }
    return NO;
}

+ (void)taskFinish:(id)target
{
    [allTaskAry removeObject:target];
    NSLog(@"finish-->");
    if (allTaskAry.count > 0)
    {
        LoadSimpleMusicNet *tempProNet = (LoadSimpleMusicNet*)[allTaskAry lastObject];
        [tempProNet loadMenuFromUrl];
    }
    else
    {
        //finish
        Loading = NO;
        [AllLoaderViewContr FinishLoad:TaskMusic];
        [SimpleQueMusicHandle LastLoadingJudge];
        NSLog(@"Communite Finish!");
    };
}

+ (void)LastLoadingJudge
{
    if ([SimpleQueSceneHandle getStatus])
    {
        [SimpleQueSceneHandle startTask];
    }
    else if([SimpleQueHumeHandle getStatus])
    {
        [SimpleQueHumeHandle startTask];
    }
    else if([SimpleQueStoryHandle getStatus])
    {
        [SimpleQueStoryHandle startTask];
    }
    else if([SimpleQueCommunHandle getStatus])
    {
        [SimpleQueCommunHandle startTask];
    }
    else if([SimpleQueMusicHandle getStatus])
    {
        [SimpleQueMusicHandle startTask];
    }
    else
    {
        //////视频
        [SimpleQueVideoHandle startTask];
        NSLog(@"开始视频");
    };
}


@end
