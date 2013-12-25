//
//  ViewController.m
//  TongDao
//
//  Created by sunyong on 13-9-15.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "LocalSQL.h"
#import "LoadMusicQue.h"
#import "ImageShowView.h"
#import "AllVariable.h"
#import "SCGIFImageView.h"
#import "ContentView.h"
#import "googleAnalytics/GAIDictionaryBuilder.h"
#import "XMLParser.h"
#import "LoadSimpleMovieNet.h"
#import "QueueVideoHandle.h"
#import "SimpleQueSceneHandle.h"
#import "LoaderViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize otherContentV;
@synthesize videoArray;
@synthesize implyLb;

- (void)viewDidLoad
{
    self.screenName = @"社区界面";
    
    [[GAI sharedInstance].defaultTracker set:self.screenName
                                       value:@"Main Screen"];
    
    // Send the screen view.
    [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createAppView] build]];
    
    [super viewDidLoad];
    [activeView startAnimating];
    AllScrollView = _scrollView;
    _scrollView.bounces  = YES;
    otherContentV.hidden = YES;
    stopAllView.hidden   = NO;
    
    [QueueProHanle  init];
    [QueueZipHandle init];
    
    AllOnceLoad = YES;
    
    AllMusicQueAry    = [[NSMutableArray alloc] init];
    videoArray        = [[NSMutableArray alloc] init];
    AllMovieInfoDict  = [[NSMutableDictionary alloc] init];
    allInfoArray      = [[NSMutableArray alloc] init];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[path stringByAppendingString:@"/music"] error:nil];
    NSArray *arrayT = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[path stringByAppendingString:@"/movie"] error:nil];
    [AllMusicQueAry addObjectsFromArray:array];
    [AllMusicQueAry removeObject:@".DS_Store"];
    
    _scrollView.bounces  = YES;
    otherContentV.hidden = YES;
    stopAllView.hidden   = NO;
    musicView.hidden     = YES;
    menuView.hidden      = YES;
    
    [self performSelector:@selector(MainViewLayerOut) withObject:nil afterDelay:0.3];
}


#define PageSize 768
#define RemainSize 90
- (void)MainViewLayerOut
{
    AllScrollView = _scrollView;
    _scrollView.backgroundColor = [UIColor blackColor];
    [_scrollView setContentSize:CGSizeMake(1024, PageSize*10 + 530)];
    
    UIImageView *lastBgImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_backgroud.jpg"]];
    [lastBgImageV setFrame:CGRectMake(0, PageSize*10 + 530, 1024, 550)];
    [_scrollView addSubview:lastBgImageV];

  //  _scrollView.pagingEnabled = YES;
    homePageViewCtr  = [[HomePageViewContr alloc] init];
    [homePageViewCtr.view setFrame:CGRectMake(0, 0, homePageViewCtr.view.frame.size.width, homePageViewCtr.view.frame.size.height)];
    
    landscapeViewCtr = [[LandscapeViewContr alloc] init];
    [landscapeViewCtr.view setFrame:CGRectMake(0, PageSize*2, landscapeViewCtr.view.frame.size.width, landscapeViewCtr.view.frame.size.height)];
    
    humanityViewCtr  = [[HumanityViewContr alloc] init];
    [humanityViewCtr.view setFrame:CGRectMake(0, PageSize*4, humanityViewCtr.view.frame.size.width, humanityViewCtr.view.frame.size.height)];
    
    storyViewCtr     = [[StoryViewContr alloc] init];
    [storyViewCtr.view setFrame:CGRectMake(0, PageSize*6, storyViewCtr.view.frame.size.width, storyViewCtr.view.frame.size.height)];
    
    communityViewCtr = [[CommunityViewContr alloc] init];
    [communityViewCtr.view setFrame:CGRectMake(0, PageSize*8, communityViewCtr.view.frame.size.width, communityViewCtr.view.frame.size.height)];
    
    versionViewCtr = [[VersionViewContr alloc] init];
    [versionViewCtr.view setFrame:CGRectMake(0, PageSize*10, versionViewCtr.view.frame.size.width, versionViewCtr.view.frame.size.height)];
    
    [_scrollView addSubview:homePageViewCtr.view];
    [_scrollView addSubview:landscapeViewCtr.view];
    [_scrollView addSubview:humanityViewCtr.view];
    [_scrollView addSubview:storyViewCtr.view];
    [_scrollView addSubview:communityViewCtr.view];
    [_scrollView addSubview:versionViewCtr.view];
    
    LoadMenuInfoNet *loadMenuInfoNet = [[LoadMenuInfoNet alloc] init];
    loadMenuInfoNet.delegate = self;
    [loadMenuInfoNet loadMenuFromUrl];
    
    audioPlayViewCtr = [[AudioPlayerViewCtr alloc] init];
    [audioPlayViewCtr.view setFrame:CGRectMake(0, 0, audioPlayViewCtr.view.frame.size.width, audioPlayViewCtr.view.frame.size.height)];
    [musicView addSubview:audioPlayViewCtr.view];
    AllAudioPlayViewCtr = audioPlayViewCtr;
    
    gifImageView = [[SCGIFImageView alloc] initWithGIFFile:[[NSBundle mainBundle] pathForResource:@"music_animation" ofType:@"gif"]];
    [gifImageView setFrame:CGRectMake(0, 0, 50, 48)];
    gifImageView.userInteractionEnabled = NO;
    [musicShowBt addSubview:gifImageView];
    [gifImageView stopAnimating];
    
    playMusicImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"music_defult.png"]];
    [playMusicImageV setFrame:CGRectMake(0, 0, 50, 48)];
    playMusicImageV.userInteractionEnabled = NO;
    [musicShowBt addSubview:playMusicImageV];
    
    implyLb.text = @"正在加载数据";
}

- (void)addLoadViewContr
{
    UIButton *showLoaderVBt = [UIButton buttonWithType:UIButtonTypeSystem];
    float scrolContentHeigh = AllScrollView.contentSize.height;
    [showLoaderVBt setFrame:CGRectMake((1024-150)/2 + 30, scrolContentHeigh-50, 150, 50)];
    [showLoaderVBt setBackgroundImage:[UIImage imageNamed:@"cache_btn.png"] forState:UIControlStateNormal];
    [showLoaderVBt addTarget:self action:@selector(showLoaderView:) forControlEvents:UIControlEventTouchDown];
    [AllScrollView addSubview:showLoaderVBt];
    
    AllLoaderViewContr = [[LoaderViewController alloc] init];
    [AllLoaderViewContr.view setFrame:CGRectMake(0, 768, AllLoaderViewContr.view.frame.size.width, AllLoaderViewContr.view.frame.size.height)];
    [self.view addSubview:AllLoaderViewContr.view];
    
    [self.view bringSubviewToFront:otherContentV];
}

- (void)addMaskView
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)showLoaderView:(UIButton*)sender
{
    
    [UIView animateWithDuration:0.4
                     animations:^(void){
                         AllLoaderViewContr.blackBgView.alpha = 0.2;
                         [AllLoaderViewContr.view setFrame:CGRectMake(0, 0, AllLoaderViewContr.view.frame.size.width, AllLoaderViewContr.view.frame.size.height)];
                     }
                     completion:^(BOOL finish){
                         [SimpleQueSceneHandle startTask];
                     }];
}
#pragma mark - scrollview delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int pointY = scrollView.contentOffset.y;
    int page = pointY/1536;
    UIButton *currentPageBt = (UIButton*)[menuView viewWithTag:page+1];
    if (currentPageBt)
    {
        if (CurrentBt)
            [CurrentBt setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        CurrentBt = currentPageBt;
        [currentPageBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    else
    {
        if (CurrentBt)
            [CurrentBt setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        CurrentBt = nil;
    }
    if (pointY < 768*2)
    {
        [homePageViewCtr rootscrollViewDidScrollToPointY:pointY];
    }
    else if (pointY >= 768*2 && pointY < 768*4)
    {
        [landscapeViewCtr rootscrollViewDidScrollToPointY:pointY%1536];
    }
    else if (pointY >= 768*4 && pointY < 768*6)
    {
        [humanityViewCtr rootscrollViewDidScrollToPointY:pointY%1536];
    }
    else if (pointY >= 768*6 && pointY < 768*8)
    {
        [storyViewCtr rootscrollViewDidScrollToPointY:pointY%1536];
    }
    else if (pointY >= 768*8 && pointY <= 768*10)
    {
        [communityViewCtr rootscrollViewDidScrollToPointY:pointY%1536];
    }
    else ;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    handleScrol = NO;
}

#pragma mark - Event
- (IBAction)MenuShow:(UIButton*)sender
{
    if (menuView.hidden)
    {
        menuView.hidden  = NO;
        musicView.hidden = YES;
    }
    else
        menuView.hidden = YES;
}

static BOOL handleScrol;
- (IBAction)selectMenu:(UIButton*)sender
{
    [_scrollView setContentOffset:CGPointMake(0, ((sender.tag-1)*2)*768) animated:YES];
    handleScrol = YES;
    if (CurrentBt)
        [CurrentBt setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    CurrentBt = sender;
    [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (IBAction)musicShow:(UIButton*)sender
{
    if (musicView.hidden)
    {
        musicView.hidden = NO;
        menuView.hidden  = YES;
    }
    else
    {
        musicView.hidden = YES;
    }
}

- (void)imageScaleShow:(NSString*)imageUrl
{
    stopAllView.hidden = NO;
    otherContentV.hidden = NO;
    ImageShowView *imageShowView = [[ImageShowView alloc] initwithURL:imageUrl];
    imageShowView.tag = 1010;
    [otherContentV addSubview:imageShowView];
    [imageShowView setFrame:CGRectMake(0, 768, 1024, 768)];
    [UIView animateWithDuration:0.3
                     animations:^(void){
                         [imageShowView setFrame:CGRectMake(0, 0, 1024, 768)];
                     }
                     completion:^(BOOL finish){
                         stopAllView.hidden = YES;
                     }];
}

- (void)presentViewContr:(NSDictionary*)_infoDict
{
    if (AllOnlyShowPresentOne == 1)
    {
        return;
    }
    AllOnlyShowPresentOne = 1;
    stopAllView.hidden    = NO;
    otherContentV.hidden  = NO;
    ContentView *contentV = [[ContentView alloc] initWithInfoDict:_infoDict];
    [contentV setFrame:CGRectMake(1024, 0, 1024, 768)];
    [otherContentV addSubview:contentV];
    [UIView animateWithDuration:0.3
                     animations:^(void){
                         [contentV setFrame:CGRectMake(0, 0, 1024, 768)];
                     }
                     completion:^(BOOL finish){
                         stopAllView.hidden = YES;
                     }];
    
}

#pragma mark - net delegate
- (void)didReceiveData:(NSDictionary *)dict
{
    [LocalSQL openDataBase];
    NSArray *backAry = (NSArray*)dict;
    for (int i = 0; i < backAry.count; i++)
    {
        [LocalSQL insertData:[backAry objectAtIndex:i]];
    }
    if (backAry.count > 0)
    {
        NSDictionary *tempDict  = [backAry lastObject];
        NSString *timestampLast = [tempDict objectForKey:@"timestamp"];
        if (timestampLast.length > 0)
        {
            [[NSUserDefaults standardUserDefaults] setObject:timestampLast forKey:@"timestamp"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    NSArray *cateOne = [LocalSQL getHeadline];
    NSArray *cateTwo = [LocalSQL getSectionData:@"6/10"];
    NSArray *cateThr = [LocalSQL getSectionData:@"6/7"];
    NSArray *cateFou = [LocalSQL getSectionData:@"6/8"];
    NSArray *cateFiv = [LocalSQL getSectionData:@"6/9"];
    [LocalSQL closeDataBase];
    
    [allInfoArray addObjectsFromArray:cateTwo];
    [allInfoArray addObjectsFromArray:cateThr];
    [allInfoArray addObjectsFromArray:cateFou];
    [allInfoArray addObjectsFromArray:cateFiv];
    
    [AllGroupInfoArray replaceObjectAtIndex:TaskScence withObject:cateTwo];
    [AllGroupInfoArray replaceObjectAtIndex:TaskHumanity withObject:cateThr];
    [AllGroupInfoArray replaceObjectAtIndex:TaskStory withObject:cateFou];
    [AllGroupInfoArray replaceObjectAtIndex:TaskCommunite withObject:cateFiv];
    
    [homePageViewCtr  loadSubview:cateOne];
    [landscapeViewCtr loadSubview:cateTwo];
    [humanityViewCtr  loadSubview:cateThr];
    [storyViewCtr     loadSubview:cateFou];
    [communityViewCtr loadSubview:cateFiv];
    menuLoadFinish = YES;
    
    [self caculateLoadTask];
    [self addLoadViewContr];
    if (AllMusicListLoadOver && menuLoadFinish)
    {
        [AllLoaderViewContr changeView:nil];
        [self showLoaderView:nil];
        [self finishLoad];
    }
}

- (void)didReceiveErrorCode:(NSError *)ErrorDict
{
    [LocalSQL openDataBase];
    NSArray *cateOne = [LocalSQL getHeadline];
    NSArray *cateTwo = [LocalSQL getSectionData:@"6/10"];
    NSArray *cateThr = [LocalSQL getSectionData:@"6/7"];
    NSArray *cateFou = [LocalSQL getSectionData:@"6/8"];
    NSArray *cateFiv = [LocalSQL getSectionData:@"6/9"];
    [LocalSQL closeDataBase];
    
    [allInfoArray addObjectsFromArray:cateTwo];
    [allInfoArray addObjectsFromArray:cateThr];
    [allInfoArray addObjectsFromArray:cateFou];
    [allInfoArray addObjectsFromArray:cateFiv];
    
    [homePageViewCtr  loadSubview:cateOne];
    [landscapeViewCtr loadSubview:cateTwo];
    [humanityViewCtr  loadSubview:cateThr];
    [storyViewCtr     loadSubview:cateFou];
    [communityViewCtr loadSubview:cateFiv];
    
    menuLoadFinish = YES;
    [self caculateLoadTask];  ///// 分析出 视频下载地址
    [self addLoadViewContr];
    if (AllMusicListLoadOver && menuLoadFinish)
    {
        [AllLoaderViewContr changeView:nil];
        [self showLoaderView:nil];
        [self finishLoad];
    }
    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络数据有误，请检查网络连接" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alerView show];
}

- (void)musicListLoadFinish
{
    if (AllMusicListLoadOver && menuLoadFinish)
    {
        [AllLoaderViewContr changeView:nil];
        [self showLoaderView:nil];
        [self finishLoad];
    }
}

- (void)caculateLoadTask
{
    AllLoad = YES;
    
    NSMutableArray *fileNameArray = [[NSMutableArray alloc] init];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    
    [fileNameArray addObjectsFromArray:array];
    [fileNameArray removeObject:@".DS_Store"];
    [fileNameArray removeObject:@"BigImage"];
    [fileNameArray removeObject:@"Data.db"];
    [fileNameArray removeObject:@"movie"];
    [fileNameArray removeObject:@"music"];
    [fileNameArray removeObject:@"ProImage"];
    
    AllZipSize = 0;
    AllLoadLenght = 0;
    for (int i = 0; i < allInfoArray.count; i++)
    {
        NSDictionary *infoDict = [allInfoArray objectAtIndex:i];
        NSString *idStr  = [infoDict objectForKey:@"id"];
        NSString *videoS = [infoDict objectForKey:@"hasVideo"];
        if (![self isEixstInArray:fileNameArray content:idStr])
        {
            int simpleSize = [[infoDict objectForKey:@"size"] intValue];
            AllZipSize += simpleSize;
            LoadZipFileNet *loadZipNet = [[LoadZipFileNet alloc] init];
            loadZipNet.delegate = nil;
            loadZipNet.urlStr   = [[infoDict objectForKey:@"url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            loadZipNet.md5Str   = [[infoDict objectForKey:@"md5"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            loadZipNet.zipStr = [infoDict objectForKey:@"id"];
            [QueueZipHandle addTarget:loadZipNet];
        }
        if([videoS isEqualToString:@"true"])
        {
            [videoArray addObject:infoDict];
        }
    }
    //[self caculateMovieLoad];
}

- (void)caculateMovieLoad
{
    AllVideoSize = 0;
    AllLoadVideoLenght = 0;
    [AllMovieInfoDict removeAllObjects];
    [QueueVideoHandle clear];
    [XMLParser clear];
    NSMutableArray *fileNameArray = [[NSMutableArray alloc] init];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[path stringByAppendingPathComponent:@"movie"] error:nil];
    [fileNameArray addObjectsFromArray:array];
    [fileNameArray removeObject:@".DS_Store"];
    for (int i = 0; i < videoArray.count; i++)
    {
        NSDictionary *initDict = [videoArray objectAtIndex:i];
        NSString *docXmlPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/doc.xml", [initDict objectForKey:@"id"]]];
        [[XMLParser alloc] initWithFilePath:docXmlPath];
    }
    [self performSelector:@selector(goOnCaculateMovieLoader) withObject:nil afterDelay:0.5f];
}

- (void)goOnCaculateMovieLoader
{
    NSArray *valueArray = [AllMovieInfoDict allValues];
    long existFileSize = 0;
    for (int i = 0; i < valueArray.count; i++)
    {
        NSString *urlStr = [valueArray objectAtIndex:i];
        NSArray *tempAry = [urlStr componentsSeparatedByString:@"/"];
        
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"movie/%@", [tempAry lastObject]]];
        BOOL dirt = NO;
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&dirt])
        {
            NSDictionary *infoDict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:Nil];
            long size = [infoDict fileSize];
            existFileSize += size;
        }
        else
        {
            LoadSimpleMovieNet *loadMoiveNet = [[LoadSimpleMovieNet alloc] init];
            loadMoiveNet.urlStr = urlStr;
            loadMoiveNet.Name = [tempAry lastObject];
            [QueueVideoHandle init];
            [QueueVideoHandle addTarget:loadMoiveNet];
        }
    }
    AllVideoSize -= existFileSize;
}

- (void)startLoadMovie
{
    NSString *implyStr = nil;
    if (AllVideoSize/1024/1024/1024 >= 1)
    {
        implyStr = [NSString stringWithFormat:@"%0.2fG", AllVideoSize/1024.0/1024.0/1024.0];
    }
    else if (AllVideoSize/1024/1024 >= 1)
    {
        implyStr = [NSString stringWithFormat:@"%0.2fMB", AllVideoSize/1024.0/1024.0];
    }
    else
    {
        implyStr = [NSString stringWithFormat:@"%0.2fKB", AllVideoSize/1024.0];
    }
    implyLb.text = [NSString stringWithFormat:@"正在下载新的视频数据，共有%@，请耐心等候!", implyStr];
    [QueueVideoHandle startTask];
}

- (BOOL)isEixstInArray:(NSArray*)initAry content:(NSString*)contentStr
{
    for (int i = 0; i < initAry.count; i++)
    {
        NSString *infoStr = [initAry objectAtIndex:i];
        if ([infoStr isEqualToString:contentStr])
        {
            return YES;
        }
    }
    return NO;
}

- (void)finishLoad
{
    AllOnceLoad = NO;
    musicShowBt.hidden = NO;
    [launchImageV removeFromSuperview];
    [activeView   removeFromSuperview];
    stopAllView.hidden = YES;
    [implyLb removeFromSuperview];
    implyLb = nil;
}

#pragma mark - alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
    }
    else
    {
        [self finishLoad];
    }
}

@end
