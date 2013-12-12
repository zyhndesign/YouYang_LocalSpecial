//
//  LoadZipFileNet.m
//  GYSJ
//
//  Created by sunyong on 13-8-2.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "LoadZipFileNet.h"
#import "MFSP_MD5.h"
#import "ZipArchive.h"
#import "AllVariable.h"
#import "ContentView.h"
#import "ViewController.h"

#import "SimpleQueSceneHandle.h"
#import "SimpleQueHumeHandle.h"
#import "SimpleQueStoryHandle.h"
#import "SimpleQueCommunHandle.h"

@implementation LoadZipFileNet

@synthesize delegate;
@synthesize md5Str;
@synthesize urlStr;
@synthesize zipStr;
@synthesize zipSize;

- (id)initWithClass:(Class)TClass
{
    self = [super init];
    if (self) {
        TaskClass = TClass;
    }
    return self;
}
- (void)loadMenuFromUrl
{
    //http://lotusprize.com/travel/bundles/eae27d77ca20db309e056e3d2dcd7d69.zip
    connectNum = 0;
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", zipStr]];
    BOOL dirt = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&dirt])
    {
        [TaskClass taskFinish:self];
        return;
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0f];
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
}

- (void)cancelLoad
{
    if (connect)
        [connect cancel];
}

- (void)reloadUrlData
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0f];
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
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (connectNum >= 0)
    {
        [TaskClass taskFinish:self];
        if ([delegate respondsToSelector:@selector(didReceiveErrorCode:)])
            [delegate didReceiveErrorCode:error];
    }
    else
    {
        connectNum++;
        [self reloadUrlData];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [backData appendData:data];
    if (delegate)
    {
        ContentView *contentVC = (ContentView*)delegate;
        contentVC.progressV.progress = [backData length]/zipSize;
        int value = [backData length]*100.0/zipSize;
        contentVC.proValueLb.text = [NSString stringWithFormat:@"%d", value];
    }
    else
    {
        AllLoadLenght += [data length];
    }
    [TaskClass setCurrentLenght:[data length]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip", zipStr]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createFileAtPath:filePath contents:backData attributes:nil];
    
    if ([[MFSP_MD5 file_md5:filePath] isEqualToString:md5Str])
    {
        BOOL isResult = NO;
        //  NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *unZipPath = path;
        
        ZipArchive *zip = [[ZipArchive alloc] init];
        BOOL result;
        if ([zip UnzipOpenFile:filePath]) {
            result = [zip UnzipFileTo:unZipPath overWrite:YES];
            if (!result)
            {
                NSLog(@"解压失败");
                isResult = NO;
                [fileManager removeItemAtPath:filePath error:nil];
                [fileManager removeItemAtPath:unZipPath error:nil];
            }
            else
            {
                // NSLog(@"解压成功");
                isResult = YES;
            }
            [zip UnzipCloseFile];
        }
        // 解压成功后，删除zip包
        if (isResult)
        {
            [fileManager removeItemAtPath:filePath error:nil];
            if (delegate != nil && [delegate respondsToSelector:@selector(didReceiveZipResult:)])
                [delegate didReceiveZipResult:isResult];
        }
        
    }
    else
    {
        // NSLog(@"md5Error");
        [fileManager removeItemAtPath:filePath error:nil];
    }
    [TaskClass taskFinish:self];
}

- (void)dealloc
{
    delegate = nil;
    backData = nil;
    urlStr = nil;
    md5Str = nil;
    zipStr = nil;
    connect = nil;
}

@end

