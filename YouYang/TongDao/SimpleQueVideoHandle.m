//
//  SimpleQueVideoHandle.m
//  TongDao
//
//  Created by sunyong on 13-12-10.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "LoadSimpleMovieNet.h"
#import "AllVariable.h"
#import "ViewController.h"
#import "LoaderViewController.h"

#import "SimpleQueMusicHandle.h"
#import "SimpleQueSceneHandle.h"
#import "SimpleQueHumeHandle.h"
#import "SimpleQueStoryHandle.h"
#import "SimpleQueCommunHandle.h"
#import "SimpleQueVideoHandle.h"

@implementation SimpleQueVideoHandle
static __strong NSMutableArray *allTaskAry;
static long allSize;
static long lenghtP;
static UILabel *impLyLB;
static BOOL Loading;

+ (void)clear
{
    if (Loading)
    {
        LoadSimpleMovieNet *tempProNet = [allTaskAry lastObject];
        [tempProNet cancelLoad];
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
        LoadSimpleMovieNet *tempProNet = [allTaskAry lastObject];
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
    [AllLoaderViewContr caculateVedioLoadTask];
    lenghtP = 0;
    if (allTaskAry.count > 0)
    {
        Loading = YES;
        LoadSimpleMovieNet *tempProNet = [allTaskAry lastObject];
        [tempProNet loadMenuFromUrl];
    }
    else
    {
        //finish
        [AllLoaderViewContr FinishLoad:TaskVideo];
        [SimpleQueVideoHandle LastLoadingJudge];
        NSLog(@"Communite Finish!");
        Loading = NO;
    }
}

+ (void)addTarget:(id)target
{
    if (![SimpleQueVideoHandle isEixstInAry:allTaskAry zipNet:target])
    {
        [allTaskAry addObject:target];
    }
}

+ (BOOL)isEixstInAry:(NSArray*)initAry zipNet:(LoadSimpleMovieNet*)target
{
    NSArray *array = [NSArray arrayWithArray:initAry];
    for (int i = 0; i < array.count; i++)
    {
        LoadSimpleMovieNet *zipNet = [array objectAtIndex:i];
        if ([zipNet.urlStr isEqualToString:target.urlStr])
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
        LoadSimpleMovieNet *tempProNet = (LoadSimpleMovieNet*)[allTaskAry lastObject];
        [tempProNet loadMenuFromUrl];
    }
    else
    {
        //finish
        Loading = NO;
        [AllLoaderViewContr FinishLoad:TaskVideo];
        [SimpleQueVideoHandle LastLoadingJudge];
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
        NSLog(@"视频结束");
    };
}

@end
