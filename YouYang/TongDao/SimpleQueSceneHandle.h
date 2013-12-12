//
//  SimpleQueSceneHandle.h
//  TongDao
//
//  Created by sunyong on 13-12-9.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SimpleQueSceneHandle : NSObject
{
    
}
+ (void)setSize:(long)size;
+ (long)getSize;
+ (void)setCurrentLenght:(int)lenght;
+ (void)setImplyLb:(UILabel*)implyLb;
+ (void)init;
+ (void)addTarget:(id)target;
+ (void)taskFinish:(id)target;
+ (BOOL)isHaveTask;
+ (void)startTask;
+ (BOOL)getStatus;
+ (void)clear;
+ (BOOL)getLoadingStatus;
+ (void)stopTask;
@end
