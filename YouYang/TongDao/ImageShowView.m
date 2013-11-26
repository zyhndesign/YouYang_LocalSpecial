//
//  ImageShowView.m
//  YouYang
//
//  Created by sunyong on 13-10-11.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "ImageShowView.h"
#import "ProImageLoadNet.h"
#import "AllVariable.h"
#import "ViewController.h"

@implementation ImageShowView

- (id)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, 1024, 768);
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initwithURL:(NSString*)URLStr
{
    if ([super init])
    {
        URLStr = [URLStr stringByReplacingOccurrencesOfString:@"*_*" withString:@"/"];
        NSArray *tempAryOne = [URLStr componentsSeparatedByString:@"show_image"];
        if (tempAryOne.count < 2)
            return self;
        URLStr = [tempAryOne objectAtIndex:0];
        if (tempAryOne.count < 2)
            return self;
        
        URLStr = [NSString stringWithFormat:@"%@wp-content/uploads%@", URLStr, [tempAryOne objectAtIndex:1]];
        urlStr = [[NSString alloc] initWithString:URLStr];
        [self addMyView];
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)addMyView
{
    self.backgroundColor = [UIColor whiteColor];
    scrllview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, 1024, 718)];
    scrllview.userInteractionEnabled = YES;
    scrllview.multipleTouchEnabled   = YES;
    scrllview.delegate = self;
    [self addSubview:scrllview];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1024, 718)];
    [scrllview addSubview:imageView];
    
    bgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1024, 50)];
    bgLabel.backgroundColor = [UIColor blackColor];
    bgLabel.alpha = 0.7;
    [self addSubview:bgLabel];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(487, 0, 50, 50)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"close_defult.png"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"close_actived.png"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backPress:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:backButton];
    
    
    [scrllview setMaximumZoomScale:8];
    [scrllview setMinimumZoomScale:0.2];
    [imageView setCenter:CGPointMake(512, 359)];
    
    [scrllview addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
    myActivew = [[ActionView alloc] initWithFrame:CGRectZero];
    myActivew.center = CGPointMake(512, 400);
    [myActivew startAnimation];
    [self addSubview:myActivew];
    
    imageLoadNet = [[ProImageLoadNet alloc] initWithDict:nil];
    imageLoadNet.delegate = self;
    imageLoadNet.imageUrl = [[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [imageLoadNet loadImageFromUrl];
    
}

- (void)dealloc
{
    [scrllview removeObserver:self forKeyPath:@"contentSize" context:nil];
    
    [bgLabel removeFromSuperview];
    bgLabel = nil;
    
    [myActivew removeFromSuperview];
    myActivew = nil;
    
    [imageView removeFromSuperview];
    imageView = nil;
    
    [scrllview removeFromSuperview];
    scrllview = nil;
    
    urlStr = nil;
    imageLoadNet = nil;
}

- (void)backPress:(id)sender
{
    [imageLoadNet setDelegate:nil];
    [myActivew stopAnimation];
    [UIView animateWithDuration:0.3
                     animations:^(void){
                         [self setFrame:CGRectMake(0, 768, self.frame.size.width, self.frame.size.height)];
                     }
                     completion:^(BOOL finish){
                         [self removeFromSuperview];
                     }];
    
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ([keyPath isEqual:@"contentSize"])
    {
        if (scrllview.contentSize.height <= 748 && scrllview.contentSize.width <= 1024)
            [imageView setCenter:CGPointMake(512, 359)];
        else if (scrllview.contentSize.height <= 748 && scrllview.contentSize.width >= 1024)
            [imageView setCenter:CGPointMake(scrllview.contentSize.width/2, 339)];
        else if (scrllview.contentSize.height >= 748 && scrllview.contentSize.width <= 1024)
            [imageView setCenter:CGPointMake(512, scrllview.contentSize.height/2)];
        else
            [imageView setCenter:CGPointMake(scrllview.contentSize.width/2, scrllview.contentSize.height/2)];
	}
}

#pragma mark imageLoadDelegate

- (void)didReciveImage:(UIImage *)backImage
{
    if (backImage == nil)
    {
        [self didReceiveErrorCode:nil];
    }
    [myActivew stopAnimation];
    [myActivew removeFromSuperview];
    [imageView setImage:backImage];
    float W = CGImageGetWidth(backImage.CGImage);
    float H = CGImageGetHeight(backImage.CGImage);
    [imageView setFrame:CGRectMake(0, 0, W, H)];
    [imageView setCenter:CGPointMake(512, 359)];
    [scrllview setContentSize:CGSizeMake(W, H)];
}

- (void)didReceiveErrorCode:(NSError *)ErrorDict
{
    [myActivew stopAnimation];
    [myActivew removeFromSuperview];
    [imageView setImage:[UIImage imageNamed:@"404-1.png"]];
}


@end
