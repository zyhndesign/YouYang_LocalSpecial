//
//  LoadMusicQue.h
//  TongDao
//
//  Created by sunyong on 13-9-18.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkDelegate.h"

@interface LoadMusicQue : NSObject
{
    NSMutableData *backData;
}
@property(nonatomic, assign)id<NetworkDelegate>delegate;

- (void)loadMusicFromUrl;

@end
