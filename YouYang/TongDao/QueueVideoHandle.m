//
//  QueueVideoHandle.m
//  TongDao
//
//  Created by sunyong on 13-11-28.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "QueueVideoHandle.h"
#import "LoadZipFileNet.h"
#import "AllVariable.h"
#import "ViewController.h"
#import "LoadSimpleMovieNet.h"

@implementation QueueVideoHandle
static __strong NSMutableArray *allTaskAry;

+ (void)init
{
    if (!allTaskAry)
    {
        allTaskAry = [[NSMutableArray alloc] init];
    }
}

+ (void)clear
{
    [allTaskAry removeAllObjects];
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
    if (allTaskAry.count > 0)
    {
        LoadSimpleMovieNet *tempProNet = [allTaskAry lastObject];
        [tempProNet loadMenuFromUrl];
    }
    else
    {
        [RootViewContr finishLoad];
    }
}

+ (void)addTarget:(id)target
{
    if (AllOnceLoad)
    {
        [allTaskAry addObject:target];
        return;
    }
    if (allTaskAry.count == 0)
    {
        [allTaskAry addObject:target];
        LoadSimpleMovieNet *tempProNet = (LoadSimpleMovieNet*)target;
        [tempProNet loadMenuFromUrl];
    }
    else
    {
        [allTaskAry addObject:target];
    }
    
}

+ (void)taskFinish:(id)target
{
    [allTaskAry removeObject:target];
    if (allTaskAry.count > 0)
    {
        LoadSimpleMovieNet *tempProNet = (LoadSimpleMovieNet*)[allTaskAry lastObject];
        [tempProNet loadMenuFromUrl];
    }
    else
    {
        [RootViewContr finishLoad];
    };
}

@end
