//
//  CommunityViewContr.h
//  TongDao
//
//  Created by sunyong on 13-9-15.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllVariable.h"

@interface CommunityViewContr : UIViewController<UIScrollViewDelegate>
{
    IBOutlet UIScrollView *contentScrolV;
    IBOutlet UIImageView *mainImageV;
    
    IBOutlet UIImageView *animaImageViewOne;
    
    
    IBOutlet UIPageControl *pageControl;
    
    NSArray *initAry;
}

- (void)loadSubview:(NSArray*)ary;
- (IBAction)nextPage:(UIButton*)sender;
- (void)rootscrollViewDidScrollToPointY:(int)pointY;

@end
