//
//  ActionView.m
//  testAnima
//
//  Created by sunyong on 13-10-10.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "ActionView.h"
#import <QuartzCore/QuartzCore.h>
@implementation ActionView

- (id)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(frame.origin.x, frame.origin.y, 50, 50);
    self = [super initWithFrame:frame];
    if (self) {
        [self addMyView];
    }
    return self;
}

- (void)addMyView
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    imageView.image = [UIImage imageNamed:@"loading.png"];
    [self addSubview:imageView];
}

- (void)startAnimation
{
    self.hidden = NO;
    CABasicAnimation *basicAni = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    [basicAni setFromValue:[NSNumber numberWithFloat:0]];
    [basicAni setToValue:[NSNumber numberWithFloat:2*M_PI]];
    [basicAni setDuration:0.9f];
    [basicAni setRepeatCount:MAXFLOAT];
    [self.layer addAnimation:basicAni forKey:@"rotationZ"];
}

- (void)stopAnimation
{
    self.hidden = YES;
    [self.layer removeAnimationForKey:@"rotationZ"];
}

- (void)dealloc
{
    
}

@end
