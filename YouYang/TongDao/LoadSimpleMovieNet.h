//
//  LoadSimpleMovieNet.h
//  TongDao
//
//  Created by sunyong on 13-11-26.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface LoadSimpleMovieNet : NSObject
{
    NSMutableData *backData;
    NSURLConnection *connect;
    Class TaskClass;
}
@property(nonatomic, strong)NSString *Name;
@property(nonatomic, strong)NSString *urlStr;
- (BOOL)loadMusicData:(NSString*)url musicName:(NSString*)musicName;
- (BOOL)loadMenuFromUrl;

- (id)initWithClass:(Class)TClass;
- (void)cancelLoad;
@end

