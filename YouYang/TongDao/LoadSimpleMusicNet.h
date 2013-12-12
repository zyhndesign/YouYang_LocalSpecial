//
//  LoadSimpleMusicNet.h
//  TongDao
//
//  Created by sunyong on 13-11-26.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoadSimpleMusicNet : NSObject
{
    NSMutableData *backData;
    NSURLConnection *connect;
    Class TaskClass;
}
@property(nonatomic, strong)NSString *Name;
- (void)loadMusicData:(NSString*)url musicName:(NSString*)musicName;

/**
 *   verion 2.0
 */

@property(nonatomic, strong)NSString* musicUrl;
- (id)initWithClass:(Class)TClass;
- (void)loadMenuFromUrl;
- (void)cancelLoad;


@end