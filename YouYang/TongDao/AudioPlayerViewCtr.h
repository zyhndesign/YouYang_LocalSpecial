//
//  AudioPlayerViewCtr.h
//  TongDao
//
//  Created by sunyong on 13-9-17.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadMusicQue.h"
@class AudioStreamer;
@interface AudioPlayerViewCtr : UIViewController<NetworkDelegate>
{
    NSString *CurrentUrlStr;
    AudioStreamer *streamer;
	NSTimer *progressUpdateTimer;
    
	NSString *currentArtist;
	NSString *currentTitle;
    
    IBOutlet UILabel *titleLb;
    
    IBOutlet UIButton *playerBt;
    
    NSMutableArray *musicQueAry;
    
    int currentPosition;
    
    IBOutlet UIActivityIndicatorView *activeView;
    
    IBOutlet UIView *stopAllView;
    
}


- (IBAction)play:(UIButton*)sender;
- (IBAction)before:(UIButton*)sender;
- (IBAction)next:(UIButton*)sender;

@end
