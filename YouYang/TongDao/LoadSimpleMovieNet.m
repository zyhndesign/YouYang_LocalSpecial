//
//  LoadSimpleMovieNet.m
//  TongDao
//
//  Created by sunyong on 13-11-26.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "LoadSimpleMovieNet.h"
#import "QueueVideoHandle.h"
#import "AllVariable.h"
#import "ViewController.h"
#import "SimpleQueVideoHandle.h"

@implementation LoadSimpleMovieNet
@synthesize Name;
@synthesize urlStr;

/**
 * version 2.0
 */
- (id)initWithClass:(Class)TClass
{
    self = [super init];
    if (self) {
        TaskClass = TClass;
    }
    return self;
}

- (void)cancelLoad
{
    if (connect)
        [connect cancel];
}

////////////////////////////////////////////////

- (BOOL)loadMenuFromUrl
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"movie/%@", Name]];
    BOOL dirt = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&dirt])
    {
        [TaskClass taskFinish:self];
        return YES;
    }
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0f];
    [request setHTTPMethod:@"GET"];
    connect = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connect)
    {
        backData = [[NSMutableData alloc] init];
    }
    else
    {
        backData = nil;
    }
    return NO;
}

- (BOOL)loadMusicData:(NSString*)url musicName:(NSString*)musicName
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"movie/%@", musicName]];
    NSString *filePathEncode = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"movie/%@", [musicName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    BOOL dirt = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&dirt])
    {
        return YES;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePathEncode isDirectory:&dirt])
    {
        return YES;
    }
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0f];
    [request setHTTPMethod:@"GET"];
    Name = musicName;
    connect = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connect)
    {
        backData = [[NSMutableData alloc] init];
    }
    else
    {
        backData = nil;
    }
    return NO;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [backData appendData:data];
    [TaskClass setCurrentLenght:[data length]];
    //    if (AllOnceLoad)
    //    {
    //        AllLoadVideoLenght += [data length];
    //        RootViewContr.valueLb.text = [NSString stringWithFormat:@"%0.2f", AllLoadVideoLenght*100.0/AllVideoSize];
    //        RootViewContr.progressView.progress = AllLoadVideoLenght*1.0/AllVideoSize;
    //    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"movie/%@", Name]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createFileAtPath:filePath contents:backData attributes:nil];
    
    [TaskClass taskFinish:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [TaskClass taskFinish:self];
}

- (void)dealloc
{
    connect  = nil;
    backData = nil;
    Name     = nil;
    urlStr   = nil;
}

@end
