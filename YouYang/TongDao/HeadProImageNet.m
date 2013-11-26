//
//  HeadProImageNet.m
//  TongDao
//
//  Created by sunyong on 13-10-12.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "HeadProImageNet.h"

@implementation HeadProImageNet
@synthesize delegate;
@synthesize _infoDict;
@synthesize imageUrl;

- (id)initWithDict:(NSDictionary*)infoDict
{
    self = [super init];
    if (self) {
        self._infoDict = infoDict;
    }
    return self;
}

- (void)loadImageFromUrl
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:imageUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120.0f];
    [request setHTTPMethod:@"GET"];
    [request setHTTPBody:nil];
    
    NSURLConnection *connectNet = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connectNet)
    {
        backData = [[NSMutableData alloc] init];
    }
    else
    {
        backData = nil;
        [delegate didReceiveErrorCode:nil];
    }
}

- (void)reloadUrlData
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:imageUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120.0f];
    [request setHTTPMethod:@"GET"];
    [request setHTTPBody:nil];
    
    NSURLConnection *connectNet = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connectNet)
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
    if (connectNum == 3)
    {
        [delegate didReceiveErrorCode:error];
    }
    else
    {
        connectNum++;
        [self reloadUrlData];
    }
}

- (NSInputStream *)connection:(NSURLConnection *)connection needNewBodyStream:(NSURLRequest *)request
{
    return nil;
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [backData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [connection cancel];
    if(_infoDict == nil)
    {
        [delegate didReciveImage:[UIImage imageWithData:backData]];
        return;
    }
    NSString *proUrlStr = [_infoDict objectForKey:@"profile"];
    NSString *proImgeFormat = [[proUrlStr componentsSeparatedByString:@"."] lastObject];
    
    NSString *pathProFile = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"ProImage/%@.%@", [_infoDict objectForKey:@"id"], proImgeFormat]];
    [backData writeToFile:pathProFile atomically:YES];
    if (delegate && [delegate respondsToSelector:@selector(didReciveImage:)])
    {
        [delegate didReciveImage:[UIImage imageWithData:backData]];
    }
}

- (void)dealloc
{
    delegate = nil;
    backData = nil;
    imageUrl = nil;
    _infoDict = nil;
}

@end
