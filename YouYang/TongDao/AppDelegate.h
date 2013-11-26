//
//  AppDelegate.h
//  TongDao
//
//  Created by sunyong on 13-9-15.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetVersion.h"
#import "GAI.h"
#import <sys/xattr.h>

@class TAGManager;
@class TAGContainer;
@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,NetworkDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@property(nonatomic, strong) id<GAITracker> tracker;

@end
