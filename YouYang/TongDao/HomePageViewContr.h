//
//  HomePageViewContr.h
//  TongDao
//
//  Created by sunyong on 13-9-15.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkDelegate.h"
#import "AllVariable.h"
@class MovieBgPlayViewCtr;

@interface HomePageViewContr : UIViewController<NetworkDelegate>
{
    IBOutlet UIScrollView *contentScrolV;
    IBOutlet UIImageView *mainImageV;
    IBOutlet UILabel *titleLb;
    IBOutlet UILabel *timeLb;
    IBOutlet UIView *movieView;
    
    IBOutlet UIImageView *animaImageViewOne;
    IBOutlet UIImageView *animaImageViewTwo;
    
    NSArray *initAry;
    
    MovieBgPlayViewCtr *movieBgPlayVC;
    
    BOOL closeMenuScrol;
}
- (IBAction)nextPage:(UIButton*)sender;
- (void)loadSubview:(NSArray*)ary;
- (void)rootscrollViewDidScrollToPointY:(int)pointY;
@end
