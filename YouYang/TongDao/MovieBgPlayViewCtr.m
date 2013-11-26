//
//  MovieBgPlayViewCtr.m
//  TongDao
//
//  Created by sunyong on 13-9-22.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "MovieBgPlayViewCtr.h"

@interface MovieBgPlayViewCtr ()

@end

@implementation MovieBgPlayViewCtr

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ForegroundMode) name:@"ForegroundMode" object:nil];
    
    activeView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activeView setCenter:CGPointMake(512, 374)];
    [activeView startAnimating];
    [movie.view addSubview:activeView];
    
    [self moviePlay];
    
    [super viewDidLoad];
    
}

- (void)ForegroundMode
{
    if (movie)
    {
        [movie play];
    }
}

- (id)initwithURL:(NSString*)URLStr
{
    self = [super initWithNibName:@"MovieBgPlayViewCtr" bundle:nil];
    if (self) {
        urlStr = [URLStr retain];
    }
    return self;
}

- (void)moviePlay
{
    movie = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:urlStr]];
    movie.controlStyle = MPMovieControlStyleNone;
    movie.scalingMode  = MPMovieScalingModeAspectFill;
    movie.repeatMode = MPMovieRepeatModeOne;
    [movie.view setFrame:self.view.bounds];
    
    [self.view addSubview:movie.view];
    
    [movie play];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (movie)
    {
        [movie play];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)dealloc
{
    [activeView release];
    [movie      release];
    [urlStr     release];
    [super dealloc];
}

@end
