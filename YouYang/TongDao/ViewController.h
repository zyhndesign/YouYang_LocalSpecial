//
//  ViewController.h
//  TongDao
//
//  Created by sunyong on 13-9-15.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageViewContr.h"
#import "LandscapeViewContr.h"
#import "HumanityViewContr.h"
#import "StoryViewContr.h"
#import "CommunityViewContr.h"
#import "LoadMenuInfoNet.h"
#import "AudioPlayerViewCtr.h"
#import "VersionViewContr.h"
#import "AllVariable.h"

#import "GAITrackedViewController.h"
#import "GAI.h"

@class ContentViewContr;



@interface ViewController : GAITrackedViewController<NetworkDelegate, UIScrollViewDelegate>
{
    IBOutlet UIScrollView *_scrollView;
    HomePageViewContr *homePageViewCtr;
    LandscapeViewContr *landscapeViewCtr;
    HumanityViewContr *humanityViewCtr;
    StoryViewContr *storyViewCtr;
    CommunityViewContr *communityViewCtr;
    AudioPlayerViewCtr *audioPlayViewCtr;
    VersionViewContr *versionViewCtr;
    
    UIButton *CurrentBt;
    
    IBOutlet UIView *stopAllView;
    
    IBOutlet UIImageView *launchImageV;
    IBOutlet UIView *musicView;
    IBOutlet UIView *menuView;
    IBOutlet UIButton *musicShowBt;
    IBOutlet UIActivityIndicatorView *activeView;
    
    BOOL isCloseMenuScrol;
}
@property(nonatomic, assign)IBOutlet UIView *otherContentV;
- (IBAction)MenuShow:(UIButton*)sender;
- (IBAction)selectMenu:(UIButton*)sender;
- (IBAction)musicShow:(UIButton*)sender;
- (void)imageScaleShow:(NSString*)imageUrl;
- (void)presentViewContr:(NSDictionary*)_infoDict;
@end
