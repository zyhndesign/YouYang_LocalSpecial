//
//  ProImageLoadNet.m
//  GYSJ
//
//  Created by sunyong on 13-9-12.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "ProImageLoadNet.h"
#import "AllVariable.h"

@implementation ProImageLoadNet
@synthesize delegate;
@synthesize imageUrl;
@synthesize _infoDict;

- (id)initWithDict:(NSDictionary*)infoDict
{
    self = [super init];
    if (self) {
        _infoDict = infoDict;
    }
    return self;
}

////// bug 推荐的pro有重合，没处理
- (void)loadImageFromUrl
{
   // NSString *testURL = [imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120.0f];
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
    if (connectNum == 2)
    {
        [QueueProHanle taskFinish];
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
    [QueueProHanle taskFinish];
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
