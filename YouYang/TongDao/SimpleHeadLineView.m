//
//  SimpleHeadLineView.m
//  TongDao
//
//  Created by sunyong on 13-9-26.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "SimpleHeadLineView.h"
#import "HeadProImageNet.h"
#import "AllVariable.h"
#import "ViewController.h"

@implementation SimpleHeadLineView

- (id)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(frame.origin.x, frame.origin.y, 210, 410);
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addView];
    }
    return self;
}

- (id)initWithInfoDict:(NSDictionary*)infoDict
{
    self = [super initWithFrame:CGRectMake(0, 0, 210, 410)];
    if (self)
    {
        _infoDict = [[NSDictionary alloc] initWithDictionary:infoDict];
        [self addView];
    }
    return self;
}

- (void)addView
{
    self.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tapGestureR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView)];
    [self addGestureRecognizer:tapGestureR];
    
    /////defultbg-210.png
    proImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 210, 210)];
    [self addSubview:proImageV];
    
    UIImageView *videoImageV = [[UIImageView alloc] initWithFrame:CGRectMake(proImageV.frame.size.width - 40, 0, 40, 35)];
    [proImageV addSubview:videoImageV];
    if ([[_infoDict objectForKey:@"hasVideo"] isEqualToString:@"true"])
        [videoImageV setImage:[UIImage imageNamed:@"video.png"]];
    
    titleLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 225, 210, 35)];
    titleLb.backgroundColor = [UIColor clearColor];
    titleLb.textAlignment = NSTextAlignmentCenter;
    titleLb.textColor       = [UIColor blackColor];
    titleLb.font = [UIFont boldSystemFontOfSize:18];
    titleLb.text = [_infoDict objectForKey:@"name"];
    [self addSubview:titleLb];
    
    UILabel *midLineLb = [[UILabel alloc] initWithFrame:CGRectMake(14, 278, 180, 1)];
    midLineLb.backgroundColor = [UIColor grayColor];
    [self addSubview:midLineLb];
    if (ios7)
        detailTextV = [[TextLayoutView alloc] initWithFrame:CGRectMake(14, 295, 180, 70)];
    else
        detailTextV = [[TextLayoutView alloc] initWithFrame:CGRectMake(14, 295, 180, 70)];
    
    detailTextV.backgroundColor = [UIColor clearColor];
    detailTextV.textColor       = [UIColor blackColor];
    detailTextV.font = [UIFont systemFontOfSize:13];
    detailTextV.text = [_infoDict objectForKey:@"description"];
    detailTextV.linesSpacing = 6;
    [self addSubview:detailTextV];
    
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineSpacing = 6.0f;
//    paragraphStyle.firstLineHeadIndent = 13.0f;
//    NSString *string = [_infoDict objectForKey:@"description"];
//    NSDictionary *ats = [NSDictionary dictionaryWithObjectsAndKeys:paragraphStyle, NSParagraphStyleAttributeName,[UIFont systemFontOfSize:14], NSFontAttributeName, nil];
//    NSAttributedString *atrriString = [[NSAttributedString alloc] initWithString:string attributes:ats];
//    detailTextV.attributedText = atrriString;
    
    //////////
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
            [proImageV setImage:[UIImage imageNamed:@"defultbg-210.png"]];
    }
    else
    {
        [proImageV setImage:[UIImage imageNamed:@"defultbg-210.png"]];
        HeadProImageNet *proImageLoadNet = [[HeadProImageNet alloc] initWithDict:_infoDict];
        proImageLoadNet.delegate = self;
        proImageLoadNet.imageUrl = [imageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [proImageLoadNet loadImageFromUrl];
    }
}

- (void)dealloc
{
    [proImageV removeFromSuperview];
    proImageV   = nil;
    [titleLb removeFromSuperview];
    titleLb     = nil;
    [detailTextV removeFromSuperview];
    detailTextV = nil;
    _infoDict   = nil;
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
