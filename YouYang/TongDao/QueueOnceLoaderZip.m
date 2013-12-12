//
//  QueueOnceLoaderZip.m
//  TongDao
//
//  Created by sunyong on 13-11-28.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "QueueOnceLoaderZip.h"
#import "LoadZipFileNet.h"

@implementation QueueOnceLoaderZip
static __strong NSMutableArray *allTaskAry;

+ (void)init
{
    if (!allTaskAry)
    {
        allTaskAry = [[NSMutableArray alloc] init];
    }
}

static int position;
+ (void)addTarget:(id)target
{
    if ([QueueOnceLoaderZip isEixstInAry:allTaskAry zipNet:target])
    {
        LoadZipFileNet *tempProNet = (LoadZipFileNet*)[allTaskAry lastObject];
        LoadZipFileNet *currentProNet = target;
        if ([tempProNet.urlStr isEqualToString:currentProNet.urlStr])
        {
            
        }
        else
        {
            LoadZipFileNet *tempProNet = (LoadZipFileNet*)[allTaskAry lastObject];
            [tempProNet cancelLoad];
            [allTaskAry exchangeObjectAtIndex:position withObjectAtIndex:allTaskAry.count-1];
            tempProNet = (LoadZipFileNet*)[allTaskAry lastObject];
            [tempProNet loadMenuFromUrl];
        }
        return;
    }
    if (allTaskAry.count == 0)
    {
        [allTaskAry addObject:target];
        LoadZipFileNet *tempProNet = (LoadZipFileNet*)target;
        [tempProNet loadMenuFromUrl];
    }
    else
    {
        LoadZipFileNet *tempProNet = (LoadZipFileNet*)[allTaskAry lastObject];
        [tempProNet cancelLoad];
        [allTaskAry addObject:target];
        LoadZipFileNet *tempCurrentProNet = (LoadZipFileNet*)target;
        [tempCurrentProNet loadMenuFromUrl];
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
    else;
}

@end
