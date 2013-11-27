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
}
@property(nonatomic, strong)NSString *Name;
- (BOOL)loadMusicData:(NSString*)url musicName:(NSString*)musicName;

@end
