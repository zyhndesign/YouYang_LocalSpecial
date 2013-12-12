//
//  QueueOnceLoaderZip.h
//  TongDao
//
//  Created by sunyong on 13-11-28.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QueueOnceLoaderZip : NSObject
{
    
}
+ (void)init;
+ (void)addTarget:(id)target;
+ (void)taskFinish:(id)target;
@end
