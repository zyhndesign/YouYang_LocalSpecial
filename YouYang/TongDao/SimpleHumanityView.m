//
//  SimpleHumanityView.m
//  TongDao
//
//  Created by sunyong on 13-9-26.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "SimpleHumanityView.h"
#import "AllVariable.h"
#import "ProImageLoadNet.h"
#import "ViewController.h"

@implementation SimpleHumanityView
@synthesize midLineLb;

- (id)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(frame.origin.x, frame.origin.y, 200, 400);
    self = [super initWithFrame:frame];
    if (self) {
    
    }
    return self;
}

- (id)initWithInfoDict:(NSDictionary*)infoDict mode:(int)mode
{
    self = [super initWithFrame:CGRectMake(0, 0, 200, 400)];
    if (self) {
        Mode = mode;
        _infoDict = [[NSDictionary alloc] initWithDictionary:infoDict];
        
        [self addView];
    }
    return self;
}

- (void)addView
{
    UITapGestureRecognizer *tapGestureR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView)];
    [self addGestureRecognizer:tapGestureR];
    
    titleLb = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 160, 40)];
    titleLb.textColor = [UIColor whiteColor];
    titleLb.textAlignment = NSTextAlignmentCenter;
    titleLb.backgroundColor = [UIColor clearColor];
    titleLb.font = [UIFont boldSystemFontOfSize:19];
    [self addSubview:titleLb];
    
    midLineLb = [[UILabel alloc] initWithFrame:CGRectMake(20, 45, 160, 1)];
    midLineLb.backgroundColor = RedLineOneColor;
    [self addSubview:midLineLb];

    timeLb = [[UILabel alloc] initWithFrame:CGRectMake(20, 45, 160, 40)];
    timeLb.textColor = [UIColor whiteColor];
    timeLb.textAlignment = NSTextAlignmentCenter;
    timeLb.backgroundColor = [UIColor clearColor];
    timeLb.font = [UIFont systemFontOfSize:17];
    [self addSubview:timeLb];
    
    if (ios7)
        detailTextV = [[TextLayoutView alloc] initWithFrame:CGRectMake(20, 97, 160, 85)];
    else
        detailTextV = [[TextLayoutView alloc] initWithFrame:CGRectMake(20, 97, 160, 85)];
    
    detailTextV.font = [UIFont systemFontOfSize:14];
    detailTextV.textColor       = [UIColor whiteColor];
    detailTextV.backgroundColor = [UIColor clearColor];
    detailTextV.text = [_infoDict objectForKey:@"description"];
    detailTextV.linesSpacing = 6;
    [self addSubview:detailTextV];

    
    proImageV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 204, 160, 160)];
    [self addSubview:proImageV];
    
    UIImageView *videoImageV = [[UIImageView alloc] initWithFrame:CGRectMake(proImageV.frame.size.width - 40, 0, 40, 35)];
    [proImageV addSubview:videoImageV];
    if ([[_infoDict objectForKey:@"hasVideo"] isEqualToString:@"true"])
        [videoImageV setImage:[UIImage imageNamed:@"video.png"]];
    
    if (Mode == 0)
        [self modeTwo];
    
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineSpacing = 6.0f;
//    paragraphStyle.firstLineHeadIndent = 13.0f;
//    NSString *string = [_infoDict objectForKey:@"description"];
//    NSDictionary *ats = [NSDictionary dictionaryWithObjectsAndKeys:paragraphStyle, NSParagraphStyleAttributeName, [UIFont systemFontOfSize:14], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil];
//    NSAttributedString *atrriString = [[NSAttributedString alloc] initWithString:string attributes:ats];
//    detailTextV.attributedText = atrriString;
    
    NSString *timeStr = [_infoDict objectForKey:@"postDate"];
    if (timeStr.length >= 8)
    {
        NSString *yearStr = [timeStr substringToIndex:4];
        NSString *monthSt = [[timeStr substringFromIndex:4] substringToIndex:2];
        NSString *dayStr  = [timeStr substringFromIndex:6];
        timeLb.text = [NSString stringWithFormat:@"%@/%@/%@", yearStr, monthSt, dayStr];
    }
    titleLb.text       = [_infoDict objectForKey:@"name"];
    NSString *imageURL = [_infoDict objectForKey:@"profile"];
    NSArray *tempAry = [imageURL componentsSeparatedByString:@"."];
    imageURL = [tempAry objectAtIndex:0];
    for (int i = 1; i < tempAry.count; i++)
    {
        if (i == tempAry.count - 1)
        {
            imageURL = [NSString stringWithFormat:@"%@-200x200.%@", imageURL, [tempAry objectAtIndex:i]];
        }
        else
            imageURL = [NSString stringWithFormat:@"%@.%@", imageURL, [tempAry objectAtIndex:i]];
    }
    NSString *ProImgeFormat = [[imageURL componentsSeparatedByString:@"."] lastObject];
    NSString *pathProFile = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"ProImage/%@.%@",[_infoDict objectForKey:@"id"], ProImgeFormat]];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:pathProFile])
    {
        UIImage *image = [UIImage imageWithContentsOfFile:pathProFile];
        if(image)
            [proImageV setImage:[UIImage imageWithContentsOfFile:pathProFile]];
        else
            [proImageV setImage:[UIImage imageNamed:@"defultbg-180.png"]];
    }
    else
    {
        [proImageV setImage:[UIImage imageNamed:@"defultbg-180.png"]];
        ProImageLoadNet *proImageLoadNet = [[ProImageLoadNet alloc] initWithDict:_infoDict];
        proImageLoadNet.delegate = self;
        proImageLoadNet.imageUrl = imageURL;
        [QueueProHanle addTarget:proImageLoadNet];
    }
}

- (void)modeTwo
{
    [proImageV setFrame:CGRectMake(proImageV.frame.origin.x, titleLb.frame.origin.y + 10, proImageV.frame.size.width, proImageV.frame.size.height)];
    
    [titleLb setFrame:CGRectMake(titleLb.frame.origin.x, titleLb.frame.origin.y + proImageV.frame.size.height + 25, titleLb.frame.size.width, titleLb.frame.size.height)];
    [midLineLb setFrame:CGRectMake(midLineLb.frame.origin.x, midLineLb.frame.origin.y + proImageV.frame.size.height + 28, midLineLb.frame.size.width, midLineLb.frame.size.height)];
    [timeLb setFrame:CGRectMake(timeLb.frame.origin.x, timeLb.frame.origin.y + proImageV.frame.size.height + 30, timeLb.frame.size.width, timeLb.frame.size.height)];
    [detailTextV setFrame:CGRectMake(detailTextV.frame.origin.x, timeLb.frame.origin.y + timeLb.frame.size.height + 13, detailTextV.frame.size.width, detailTextV.frame.size.height)];
    
}

- (void)dealloc
{
    [proImageV removeFromSuperview];
    proImageV = nil;
    [timeLb removeFromSuperview];
    timeLb    = nil;
    [midLineLb removeFromSuperview];
    midLineLb = nil;
    [timeLb removeFromSuperview];
    timeLb    = nil;
    [detailTextV removeFromSuperview];
    detailTextV = nil;
    _infoDict = nil;
}

#pragma mark - tapGesture

- (void)tapView
{
    if (AllOnlyShowPresentOne == 1)
    {
        return;
    }
    [RootViewContr presentViewContr:_infoDict];
}

#pragma mark - net delegate
- (void)didReciveImage:(UIImage *)backImage
{
    [proImageV setImage:backImage];
}

- (void)didReceiveErrorCode:(NSError *)ErrorDict
{
    
}

@end
