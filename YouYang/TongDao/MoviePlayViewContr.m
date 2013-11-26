//
//  MoviePlayViewContr.m
//  GYSJ
//
//  Created by sunyong on 13-8-14.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "MoviePlayViewContr.h"
#import "AllVariable.h"
#import "AudioPlayerViewCtr.h"


@interface MoviePlayViewContr ()

@end

@implementation MoviePlayViewContr

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    isMusicPlaying = playing;
    if (isMusicPlaying) {
        [AllAudioPlayViewCtr play:nil];
    }
    [self moviePlay];
    
    activeView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activeView setCenter:CGPointMake(512, 374)];
    [activeView startAnimating];
    [movie.view addSubview:activeView];
    
    [super viewDidLoad];
    
}

- (id)initwithURL:(NSString*)URLStr
{
    self = [super init];
    if (self) {
        urlStr = [[URLStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] retain];
    }
    return self;
}

- (void)moviePlay
{
    movie = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:urlStr]];
    movie.controlStyle = MPMovieControlStyleFullscreen;
    movie.scalingMode  = MPMovieScalingModeAspectFill;
    [movie.view setFrame:self.view.bounds];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myMovieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:movie];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myMovieDidShow:)
                                                 name:MPMoviePlayerReadyForDisplayDidChangeNotification
                                               object:movie];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myMovieReadyShow:)
                                                 name:MPMoviePlayerLoadStateDidChangeNotification
                                               object:movie];
    
    [self.view addSubview:movie.view];
    [movie play];
    timerURL = [NSTimer scheduledTimerWithTimeInterval:8.0f target:self selector:@selector(movieURLValid) userInfo:nil repeats:NO];
}

- (void)movieURLValid
{
    if (timerURL)
    {
        [timerURL invalidate];
        timerURL = nil;
    }
    
    if (!isShow)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无法链接到视频，请检查网络设置。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    }
}

-(void)myMovieReadyShow:(NSNotification*)notify
{
    isShow = YES;
    MPMoviePlayerController* theMovie = [notify object];
    for(UIView *view in [theMovie.view subviews])
    {
        for(UIView *view1 in [view subviews])
        {
            for(UIView *view2 in [view1 subviews])
            {
                for(UIView *view3 in [view2 subviews])
                {
                    if ([view3 isKindOfClass:NSClassFromString(@"MPPadFullScreenNavigationBar")])
                    {
                        [view3 setFrame:CGRectMake(0, 0, view3.frame.size.width, view3.frame.size.height)];
                    }
                }
            }
        }
    }
}

-(void)myMovieDidShow:(NSNotification*)notify
{
    [activeView stopAnimating];
}

-(void)myMovieFinishedCallback:(NSNotification*)notify
{
    //视频播放对象
    [activeView stopAnimating];
    if (isMusicPlaying) {
        [AllAudioPlayViewCtr play:nil];
    }
    if (isShow)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    else
    {
        if (timerURL){
            [timerURL invalidate];
            timerURL = nil;
        }
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无法链接到视频，请检查网络设置。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerDidEnterFullscreenNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
    [activeView release];
    [movie      release];
    [urlStr     release];
    [super dealloc];
}

@end
