//
//  LoadMenuInfoNet.m
//  GYSJ
//
//  Created by sunyong on 13-7-23.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "LoadMenuInfoNet.h"
#import "JSONKit.h"
@implementation LoadMenuInfoNet

@synthesize delegate;

- (void)loadMenuFromUrl
{
  //  @"http://localhost/xinjiang-bundle-app/dataUpdate.json?category=1&lastUpdateDate=0";
   // @"http://lotusprize.com/travel/dataUpdate?category=1&lastUpdateDate=0"
    NSString *urlStr = nil;
    NSString *timestampLast = [[NSUserDefaults standardUserDefaults] objectForKey:@"timestamp"];
    if (timestampLast.length > 0)
        urlStr = [NSString stringWithFormat:@"http://comdesignlab.com/travel/dataUpdate.json?category=6&lastUpdateDate=%@", timestampLast];
    else
        urlStr = [NSString stringWithFormat:@"http://comdesignlab.com/travel/dataUpdate.json?category=6&lastUpdateDate=0"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0f];
    [request setHTTPMethod:@"GET"];
    
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
