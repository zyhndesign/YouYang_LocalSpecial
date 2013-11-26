//
//  LoadMusicQue.m
//  TongDao
//
//  Created by sunyong on 13-9-18.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "LoadMusicQue.h"
#import "JSONKit.h"

@implementation LoadMusicQue
@synthesize delegate;

- (void)loadMusicFromUrl
{
    //  @"http://localhost/xinjiang-bundle-app/dataUpdate.json?category=1&lastUpdateDate=0";
    // @"http://lotusprize.com/travel/dataUpdate?category=1&lastUpdateDate=0"
    NSString *urlStr = [NSString stringWithFormat:@"http://comdesignlab.com/travel/wp-admin/admin-ajax.php"];
    ///NSString *urlStr = [NSString stringWithFormat:@"http://lotusprize.com/travel/wp-admin/admin-ajax.php?programId=1&action=zy_get_music"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:6.0f];
    NSString *bodyStr = [NSString stringWithFormat:@"action=zy_get_music&programId=6"];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connect = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connect)
    {
        backData = [[NSMutableData alloc] init];
    }
    else
    {
        backData = nil;
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [delegate didReceiveErrorCode:error];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [backData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSDictionary *backDict = [backData objectFromJSONDataWithParseOptions:JKParseOptionValidFlags error:nil];
    [delegate didReceiveData:backDict];
}

- (void)dealloc
{
    backData = nil;
}

@end
