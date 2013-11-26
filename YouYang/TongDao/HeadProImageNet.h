//
//  HeadProImageNet.h
//  TongDao
//
//  Created by sunyong on 13-10-12.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NetworkDelegate.h"

@interface HeadProImageNet : NSObject
{
    NSMutableData *backData;
    int connectNum;
    NSDictionary *_infoDict;
    NSString *imageUrl;
}
@property(nonatomic, strong)id<NetworkDelegate>delegate;
@property(nonatomic, strong)NSDictionary *_infoDict;
@property(nonatomic, strong)NSString *imageUrl;

- (id)initWithDict:(NSDictionary*)infoDict;
- (void)loadImageFromUrl;
@end
