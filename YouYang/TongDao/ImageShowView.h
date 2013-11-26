//
//  ImageShowView.h
//  YouYang
//
//  Created by sunyong on 13-10-11.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkDelegate.h"
#import "ActionView.h"

@class ProImageLoadNet;

@interface ImageShowView : UIView<NetworkDelegate, UIScrollViewDelegate>
{
    UIImageView  *imageView;
    UIScrollView *scrllview;
    UILabel *bgLabel;
    
    CGFloat lastDistance;
	
	CGFloat imgStartWidth;
	CGFloat imgStartHeight;
    
    NSString *urlStr;
	ActionView *myActivew;
    ProImageLoadNet *imageLoadNet;
}

- (id)initwithURL:(NSString*)URLStr;

@end
