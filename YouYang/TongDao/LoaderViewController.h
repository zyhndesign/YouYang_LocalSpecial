//
//  LoaderViewController.h
//  TongDao
//
//  Created by sunyong on 13-12-9.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoaderViewController : UIViewController<UIScrollViewDelegate>
{
    IBOutlet UIView *subViewBg;
    IBOutlet UIView *menuView;
    IBOutlet UIView *loadProgresView;
    
    IBOutlet UILabel *backLb;
    IBOutlet UIButton *stopAllTaskBt;
    IBOutlet UIButton *hiddenTaskBt;
    
    UILabel *currentLoadProLb;
    
    UIScrollView *menuScrolV;
    UIScrollView *progresScrolV;
    NSMutableArray *menuAry;
    
    NSMutableArray *swViewAry;
    NSMutableArray *LocalFileNameArray;
}

@property(nonatomic, strong)IBOutlet UIView *blackBgView;

- (IBAction)changeView:(UIButton*)sender;
- (IBAction)hiddenView:(UIButton*)sender;
- (IBAction)stopAllTask:(UIButton*)sender;
- (IBAction)openAllTask:(UIButton*)sender;
- (IBAction)closeAllTask:(UIButton*)sender;

- (void)FinishLoad:(int)taskTag;
- (void)caculateVedioLoadTask;

- (void)checkVedioTask;

@end

