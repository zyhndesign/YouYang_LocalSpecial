//
//  NetworkDelegate.h
//  GYSJ
//
//  Created by sunyong on 13-7-23.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NetworkDelegate <NSObject>

@optional
- (void)didReceiveData:(NSDictionary *)dict;
- (void)didReceiveErrorCode:(NSError*)ErrorDict;

- (void)didReciveImage:(UIImage*)backImage;
- (void)didReceiveZipResult:(BOOL)success; // 用于下载zip
@end




