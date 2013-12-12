//
//  SimpleQueSceneHandle.m
//  TongDao
//
//  Created by sunyong on 13-12-9.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "SimpleQueSceneHandle.h"
#import "LoadZipFileNet.h"
#import "AllVariable.h"
#import "ViewController.h"
#import "LoaderViewController.h"

#import "SimpleQueHumeHandle.h"
#import "SimpleQueStoryHandle.h"
#import "SimpleQueCommunHandle.h"
#import "SimpleQueMusicHandle.h"
#import "SimpleQueVideoHandle.h"
@implementation SimpleQueSceneHandle

static __strong NSMutableArray *allTaskAry;
static long allSize;
static long lenghtP;
static UILabel *impLyLB;
static BOOL Loading;

+ (void)clear
{
    if (Loading)
    {
        LoadZipFileNet *tempProNet = [allTaskAry lastObject];
        [tempProNet cancelLoad];
        [SimpleQueHumeHandle startTask];
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
        LoadZipFileNet *tempProNet = [allTaskAry lastObject];
        [tempProNet cancelLoad];
        Loading = NO;
    }
}

+ (void)setSize:(long)size
{
    if (!Loading)
        allSize = size;
}

+ (long)getSize
{
    return allSize;
}

+ (BOOL)getLoadingStatus
{
    return Loading;
}

+ (void)setCurrentLenght:(int)lenght
{
    lenghtP += lenght;
    if (impLyLB)
    {
        impLyLB.textColor = BlackBGColor;
        impLyLB.text = [NSString stringWithFormat:@"%0.2f %@", lenghtP*100.0/allSize, @"%"];
    }
}

+ (BOOL)getStatus
{
    return allTaskAry.count;
}

+ (void)setImplyLb:(UILabel*)implyLb
{
    impLyLB = implyLb;
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
    if (Loading || [SimpleQueSceneHandle otherLoadingStatus]) return;
    lenghtP = 0;
    if (allTaskAry.count > 0)
    {
        Loading = YES;
        LoadZipFileNet *tempProNet = [allTaskAry lastObject];
        [tempProNet loadMenuFromUrl];
    }
    else
    {
        //finish
        [AllLoaderViewContr FinishLoad:TaskScence];
        [SimpleQueHumeHandle startTask];
        Loading = NO;
        NSLog(@"SceneHandle Finish!");
    }
}

+ (BOOL)otherLoadingStatus
{
    if ([SimpleQueHumeHandle getLoadingStatus] || [SimpleQueStoryHandle getLoadingStatus] ||[SimpleQueCommunHandle getLoadingStatus] || [SimpleQueMusicHandle getLoadingStatus]|| [SimpleQueVideoHandle getLoadingStatus])
    {
        return YES;
    }
    return NO;
}
                                                                                                
static int position;
+ (void)addTarget:(id)target
{
    if (![SimpleQueSceneHandle isEixstInAry:allTaskAry zipNet:target])
    {
        [allTaskAry addObject:target];
    }
}

+ (BOOL)isEixstInAry:(NSArray*)initAry zipNet:(LoadZipFileNet*)target
{
    NSArray *array = [NSArray arrayWithArray:initAry];
    for (int i = 0; i < array.count; i++)
    {
        LoadZipFileNet *zipNet = [array objectAtIndex:i];
        if ([zipNet.urlStr isEqualToString:target.urlStr])
        {
            position = i;
            zipNet.delegate = target.delegate;
            return YES;
        }
    }
    return NO;
}

+ (void)taskFinish:(id)target
{
    [allTaskAry removeObject:target];
    if (allTaskAry.count > 0)
    {
        LoadZipFileNet *tempProNet = (LoadZipFileNet*)[allTaskAry lastObject];
        [tempProNet loadMenuFromUrl];
    }
    else
    {
        //finish
        [AllLoaderViewContr FinishLoad:TaskScence];
        [SimpleQueHumeHandle startTask];
        Loading = NO;
        NSLog(@"SceneHandle Finish!");
    };
}

@end
