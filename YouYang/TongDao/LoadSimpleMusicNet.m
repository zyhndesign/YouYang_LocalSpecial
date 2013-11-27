//
//  LoadSimpleMusicNet.m
//  TongDao
//
//  Created by sunyong on 13-11-26.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "LoadSimpleMusicNet.h"
#import "AllVariable.h"

@implementation LoadSimpleMusicNet
@synthesize Name;

- (void)loadMusicData:(NSString*)url musicName:(NSString*)musicName
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"music/%@", musicName]];
    BOOL dirt = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&dirt])
    {
        BOOL isExist = NO;
        for (int i = 0; i < AllMusicQueAry.count; i++)
        {
            if ([[AllMusicQueAry objectAtIndex:i] isEqualToString:musicName])
            {
                isExist = YES;
                break;
            }
        }
        if (!isExist)
            [AllMusicQueAry addObject:musicName];
        return;
    }
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0f];
    [request setHTTPMethod:@"GET"];
    self.Name = musicName;
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


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [backData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"music/%@", Name]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createFileAtPath:filePath contents:backData attributes:nil];
    [AllMusicQueAry addObject:Name];
}

- (void)dealloc
{
    connect  = nil;
    backData = nil;
    Name     = nil;
}
@end
