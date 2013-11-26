//
//  AudioPlayerViewCtr.m
//  TongDao
//
//  Created by sunyong on 13-9-17.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "AudioPlayerViewCtr.h"
#import "AudioStreamer.h"
#import <QuartzCore/CoreAnimation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CFNetwork/CFNetwork.h>
#import "AllVariable.h"

@interface AudioPlayerViewCtr ()

@end

@implementation AudioPlayerViewCtr

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
    musicQueAry = [[NSMutableArray alloc] init];
    currentPosition = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackStateChanged:) name:ASStatusChangedNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(metadataChanged:) name:ASUpdateMetadataNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(errorMessage:) name:ASPresentAlertWithTitleNotification object:nil];
    
    // update the UI in case we were in the background
	NSNotification *notification = [NSNotification notificationWithName:ASStatusChangedNotification object:self];
	[[NSNotificationCenter defaultCenter] postNotification:notification];
    

    LoadMusicQue *loadMusicQNet = [[LoadMusicQue alloc] init];
    loadMusicQNet.delegate = self;
    [loadMusicQNet loadMusicFromUrl];
    [loadMusicQNet release];
    [super viewDidLoad];
    
   // [self createStreamer:@"http://qybkapp.gaiay.net.cn//uploadfile//upload//10017c13f8355a86e-7f5e//voice//file//2013-07-01//58adcb0e-4b7f-40e3-b9f4-25f76999f901.mp3"];
    
}

- (IBAction)play:(UIButton *)sender
{
    if (musicQueAry.count == 0)
    {
        stopAllView.hidden = NO;
        [activeView startAnimating];
        LoadMusicQue *loadMusicQNet = [[LoadMusicQue alloc] init];
        loadMusicQNet.delegate = self;
        [loadMusicQNet loadMusicFromUrl];
        [loadMusicQNet release];
        return;
    }
    if (!playing)
	{
        playing = YES;
        [playerBt setBackgroundImage:[UIImage imageNamed:@"music_purpose_defult.png"] forState:UIControlStateNormal];
        [playerBt setBackgroundImage:[UIImage imageNamed:@"music_purpose_actived.png"] forState:UIControlStateHighlighted];
        if (streamer.state == AS_INITIALIZED)
        {
            if (currentPosition < musicQueAry.count && currentPosition >= 0)
            {
                [self createStreamer:[[musicQueAry objectAtIndex:currentPosition] objectForKey:@"music_path"]];
                titleLb.text = [[musicQueAry objectAtIndex:currentPosition] objectForKey:@"music_title"];
            }
        }
		[streamer start];
	}
	else
	{
        playing = NO;
        [playerBt setBackgroundImage:[UIImage imageNamed:@"music_play_defult.png"] forState:UIControlStateNormal];
        [playerBt setBackgroundImage:[UIImage imageNamed:@"music_play_actived.png"] forState:UIControlStateHighlighted];
		[streamer pause];
	}
}

static BOOL presOpOver = YES;
- (IBAction)before:(UIButton*)sender
{
    if (!presOpOver)
        return;
    if (musicQueAry.count == 0)
    {
        stopAllView.hidden = NO;
        [activeView startAnimating];
        LoadMusicQue *loadMusicQNet = [[LoadMusicQue alloc] init];
        loadMusicQNet.delegate = self;
        [loadMusicQNet loadMusicFromUrl];
        [loadMusicQNet release];
        return;
    }
    presOpOver = NO;
    [streamer stop];
    currentPosition--;
    if (currentPosition < 0)
        currentPosition = musicQueAry.count - 1;
    if (currentPosition < musicQueAry.count && currentPosition >= 0)
    {
        [self createStreamer:[[musicQueAry objectAtIndex:currentPosition] objectForKey:@"music_path"]];
        titleLb.text = [[musicQueAry objectAtIndex:currentPosition] objectForKey:@"music_title"];
    }
    [streamer start];
    
    playing = YES;
    [playerBt setBackgroundImage:[UIImage imageNamed:@"music_purpose_defult.png"] forState:UIControlStateNormal];
    [playerBt setBackgroundImage:[UIImage imageNamed:@"music_purpose_actived.png"] forState:UIControlStateHighlighted];
    [self performSelector:@selector(delaysPreOpration) withObject:nil afterDelay:1.5];
    
}

- (void)delaysPreOpration
{
    presOpOver = YES;
}

static BOOL nextOpOver = YES;
- (IBAction)next:(UIButton*)sender
{
    if (musicQueAry.count == 0)
    {
        stopAllView.hidden = NO;
        [activeView startAnimating];
        LoadMusicQue *loadMusicQNet = [[LoadMusicQue alloc] init];
        loadMusicQNet.delegate = self;
        [loadMusicQNet loadMusicFromUrl];
        [loadMusicQNet release];
        return;
    }
    if (!nextOpOver)
        return;
    nextOpOver = NO;
    [streamer stop];
    currentPosition++;
    if (currentPosition >= musicQueAry.count)
        currentPosition = 0;
    if (currentPosition < musicQueAry.count && currentPosition >= 0)
    {
        [self createStreamer:[[musicQueAry objectAtIndex:currentPosition] objectForKey:@"music_path"]];
        titleLb.text = [[musicQueAry objectAtIndex:currentPosition] objectForKey:@"music_title"];
    }
    [streamer start];
    
     playing = YES;
    [playerBt setBackgroundImage:[UIImage imageNamed:@"music_purpose_defult.png"] forState:UIControlStateNormal];
    [playerBt setBackgroundImage:[UIImage imageNamed:@"music_purpose_actived.png"] forState:UIControlStateHighlighted];
    [self performSelector:@selector(delaysNextOpration) withObject:nil afterDelay:1.5];
}

- (void)delaysNextOpration
{
     nextOpOver = YES;
}
#pragma mark - streame
// Creates or recreates the AudioStreamer object.
- (void)createStreamer:(NSString*)audioUrlStr
{
    if (!streamer)
    {
        streamer = [[AudioStreamer alloc] init];
    }
	[self destroyStreamer];
    audioUrlStr = [audioUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *escapedValue =
    [(NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                         nil,
                                                         (CFStringRef)audioUrlStr,
                                                         NULL,
                                                         NULL,
                                                         kCFStringEncodingUTF8)
     autorelease];
    
	NSURL *url = [NSURL URLWithString:escapedValue];
    
    [streamer reloadURL:url];
	[self createTimers:YES];
    
#ifdef SHOUTCAST_METADATA
#endif
}

// Removes the streamer, the UI update timer and the change notification
//
- (void)destroyStreamer
{
	if (streamer)
	{
		[self createTimers:NO];
//		[streamer stop];
//		[streamer release];
//		streamer = nil;
	}
}

- (void)updateProgress:(id)time
{
    if (streamer.bitRate != 0.0)
	{
		//double progress = streamer.progress;
		double duration = streamer.duration;
		//  [NSString stringWithFormat:@"Time Played: %.1f/%.1f seconds",progress,duration]];
		if (duration > 0)
		{
            
		}
		else
		{
            //			[progressSlider setEnabled:NO];
		}
	}
	else
	{
		
	}
}

// Creates or destoys the timers
//
-(void)createTimers:(BOOL)create
{
	if (create)
    {
		if (streamer)
        {
            [self createTimers:NO];
            progressUpdateTimer =
            [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateProgress:) userInfo:nil repeats:YES];
		}
	}
	else
    {
		if (progressUpdateTimer)
		{
			[progressUpdateTimer invalidate];
			progressUpdateTimer = nil;
		}
	}
}

// reports that its playback status has changed.
//

- (void)metadataChanged:(NSNotification *)aNotification
{

}



- (void)playbackStateChanged:(NSNotification *)aNotification
{
	if ([streamer isWaiting])
	{
        [activeView startAnimating];
        [gifImageView stopAnimating];
        playMusicImageV.hidden = YES;
	}
	else if ([streamer isPlaying])
	{
        playing = YES;
        playMusicImageV.hidden = YES;
        [gifImageView startAnimating];
        [activeView stopAnimating];
	}
	else if ([streamer isPaused])
    {
        [gifImageView stopAnimating];
        [activeView stopAnimating];
        playMusicImageV.hidden = NO;
        playing = NO;
	}
	else if ([streamer isIdle])
	{
        [gifImageView stopAnimating];
        playMusicImageV.hidden = NO;
        playing = NO;
        [activeView stopAnimating];
        [playerBt setBackgroundImage:[UIImage imageNamed:@"music_play_defult.png"] forState:UIControlStateNormal];
        [playerBt setBackgroundImage:[UIImage imageNamed:@"music_play_actived.png"] forState:UIControlStateHighlighted];
		[self destroyStreamer];
	}
}

- (void)errorMessage:(NSNotification*)notification
{
    NSDictionary *infoDict = [notification userInfo];
    [playerBt setBackgroundImage:[UIImage imageNamed:@"music_btn_play_normal.png"] forState:UIControlStateNormal];
    [playerBt setBackgroundImage:[UIImage imageNamed:@"music_btn_play_pressed.png"] forState:UIControlStateHighlighted];
    [streamer pause];
    if ([[infoDict objectForKey:@"title"] isEqualToString:@"File Error"])
    {
        [self performSelector:@selector(imply:) onThread:[NSThread mainThread] withObject:@"获取不到音乐数据" waitUntilDone:NO];
    }
}

- (void)imply:(NSString*)infoStr
{
    @autoreleasepool {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:infoStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    }
    
}

#pragma mark Remote Control Events
- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
	switch (event.subtype) {
		case UIEventSubtypeRemoteControlTogglePlayPause:
			[streamer pause];
			break;
		case UIEventSubtypeRemoteControlPlay:
			[streamer start];
			break;
		case UIEventSubtypeRemoteControlPause:
			[streamer pause];
			break;
		case UIEventSubtypeRemoteControlStop:
			[streamer stop];
			break;
		default:
			break;
	}
}


#pragma mark - net delegate
- (void)didReceiveData:(NSDictionary *)dict
{
    stopAllView.hidden = YES;
    [activeView stopAnimating];
    if ([dict objectForKey:@"success"])
    {
        NSArray *arry = [dict objectForKey:@"data"];
        if (arry.count > 0)
            [musicQueAry addObjectsFromArray:arry];
    }
    if (musicQueAry.count > 0) 
        titleLb.text = [[musicQueAry objectAtIndex:0] objectForKey:@"music_title"];
    if (musicQueAry.count == 0)
        [self performSelector:@selector(imply:) onThread:[NSThread mainThread] withObject:@"暂无音乐数据" waitUntilDone:NO];
}

static BOOL onlyFirst;
- (void)didReceiveErrorCode:(NSError *)ErrorDict
{
    stopAllView.hidden = YES;
    [activeView stopAnimating];
    if ([ErrorDict code] == -1009)
    {
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络数据连接失败，请检查网络设置。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alerView show];
        [alerView release];
    }
    else // ([[[ErrorDict userInfo] objectForKey:NSLocalizedDescriptionKey] isEqual:@"bad URL"])
    {
        if (!onlyFirst)
        {
            onlyFirst = YES;
            return;
        }
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"音乐文件不存在" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alerView show];
        [alerView release];
    }
}

- (void)dealloc
{
    [self destroyStreamer];
	[self createTimers:NO];
    [super dealloc];
}

@end
