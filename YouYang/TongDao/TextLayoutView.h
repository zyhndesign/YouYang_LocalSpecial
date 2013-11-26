//
//  TextLayoutView.h
//  labelPragraphT
//
//  Created by sunyong on 13-10-14.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextLayoutView : UILabel
{
    CGFloat characterSpacing_;
    long linesSpacing_;
}

@property(nonatomic, assign)CGFloat characterSpacing;
@property(nonatomic, assign)long linesSpacing;

@end
