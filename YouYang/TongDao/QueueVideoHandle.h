//
//  QueueVideoHandle.h
//  TongDao
//
//  Created by sunyong on 13-11-28.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QueueVideoHandle : NSObject
{
    
}
+ (void)init;
+ (void)clear;
+ (void)addTarget:(id)target;
+ (void)taskFinish:(id)target;
+ (BOOL)isHaveTask;
+ (void)startTask;
@end
