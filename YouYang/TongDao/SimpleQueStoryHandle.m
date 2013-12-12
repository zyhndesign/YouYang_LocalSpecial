//
//  SimpleQueStoryHandle.m
//  TongDao
//
//  Created by sunyong on 13-12-10.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "SimpleQueStoryHandle.h"
#import "LoadZipFileNet.h"
#import "AllVariable.h"
#import "ViewController.h"
#import "LoaderViewController.h"
#import "SimpleQueCommunHandle.h"

@implementation SimpleQueStoryHandle

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
        [SimpleQueCommunHandle startTask];
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

+ (BOOL)getLoadingStatus
{
    return Loading;
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

+ (void)setCurrentLenght:(int)lenght
{
    lenghtP += lenght;
    if (impLyLB)
    {
        impLyLB.textColor =  BlackBGColor;;
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
    NSLog(@"taskCount:%d", [allTaskAry count]);
    if (Loading) return;
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
        [AllLoaderViewContr FinishLoad:TaskStory];
        [SimpleQueCommunHandle startTask];
        Loading = NO;
        NSLog(@"Story Finish!");
    }
}

static int position;
+ (void)addTarget:(id)target
{
    if (![SimpleQueStoryHandle isEixstInAry:allTaskAry zipNet:target])
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
    NSLog(@"finish-->");
    if (allTaskAry.count > 0)
    {
        LoadZipFileNet *tempProNet = (LoadZipFileNet*)[allTaskAry lastObject];
        [tempProNet loadMenuFromUrl];
    }
    else
    {
        //finish
        Loading = NO;
        [AllLoaderViewContr FinishLoad:TaskStory];
        [SimpleQueCommunHandle startTask];
        NSLog(@"Story Finish!");
    };
}


@end
