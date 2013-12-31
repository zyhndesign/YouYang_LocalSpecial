//
//  LoaderViewController.m
//  TongDao
//
//  Created by sunyong on 13-12-9.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "LoaderViewController.h"
#import "ViewController.h"
#import "AllVariable.h"
#import "LoadZipFileNet.h"
#import "LoadSimpleMusicNet.h"
#import "LoadSimpleMovieNet.h"

#import "SimpleQueSceneHandle.h"
#import "SimpleQueHumeHandle.h"
#import "SimpleQueStoryHandle.h"
#import "SimpleQueCommunHandle.h"
#import "SimpleQueMusicHandle.h"
#import "SimpleQueVideoHandle.h"

#import "XMLParser.h"

@interface LoaderViewController ()

@end

@implementation LoaderViewController
@synthesize blackBgView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self getFileNameAry];
        
        [SimpleQueSceneHandle  init];
        [SimpleQueHumeHandle   init];
        [SimpleQueStoryHandle  init];
        [SimpleQueCommunHandle init];
        [SimpleQueMusicHandle  init];
        [SimpleQueVideoHandle  init];
    }
    return self;
}

- (void)getFileNameAry
{
    if (!LocalFileNameArray)
        LocalFileNameArray = [[NSMutableArray alloc] init];
    else
        [LocalFileNameArray removeAllObjects];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    
    [LocalFileNameArray addObjectsFromArray:array];
    [LocalFileNameArray removeObject:@".DS_Store"];
    [LocalFileNameArray removeObject:@"BigImage"];
    [LocalFileNameArray removeObject:@"Data.db"];
    [LocalFileNameArray removeObject:@"movie"];
    [LocalFileNameArray removeObject:@"music"];
    [LocalFileNameArray removeObject:@"ProImage"];
}

#define ScrolViewWidth 584
#define ScrolViewHeigh 582
#define ViewHeigh 60

- (void)viewDidLoad
{
    menuAry = [[NSMutableArray alloc] initWithObjects:@"风景", @"人文",@"物语",@"社区",@"音乐",@"视频",nil];
    swViewAry  = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor clearColor];
    menuScrolV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 46, ScrolViewWidth, ScrolViewHeigh)];
    for (int i = 0; i < menuAry.count; i++)
    {
        UIView *view = [self builtMenuView:i];
        [menuScrolV addSubview:view];
    }
    [menuView addSubview:menuScrolV];
    [menuScrolV setContentSize:CGSizeMake(584, 583)];
    
    progresScrolV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 46, ScrolViewWidth, ScrolViewHeigh)];
    [loadProgresView addSubview:progresScrolV];
    [progresScrolV setContentSize:CGSizeMake(584, 583)];
    
    [stopAllTaskBt setTitleColor:BlackBGColor forState:UIControlStateNormal];
    [hiddenTaskBt  setTitleColor:BlackBGColor forState:UIControlStateNormal];
    backLb.backgroundColor =  BlackBGColor;
    
    [super viewDidLoad];
}

//
#pragma mark - Data handle
#define BaseViewTag 100
#define BaseLabelTag 10000
#define BaseSwitchTag 10000
/**
 *  clear每个队列数据
 *
 *  @param tag 每个区的标记
 */
- (void)clearQueData:(int)tag
{
    Class taskClass;
    if (tag == TaskMusic)
    {
        taskClass = [SimpleQueMusicHandle class];
    }
    else if(tag == TaskScence)
    {
        taskClass = [SimpleQueSceneHandle class];
    }
    else if(tag == TaskHumanity)
    {
        taskClass = [SimpleQueHumeHandle class];
    }
    else if(tag == TaskStory)
    {
        taskClass = [SimpleQueStoryHandle class];
    }
    else if(tag == TaskCommunite)
    {
        taskClass = [SimpleQueCommunHandle class];
    }
    else if(tag == TaskVideo)
    {
        taskClass = [SimpleQueVideoHandle class];
    }
    else;
    [taskClass clear];
}

/**
 *  数据刷选，把需要下载的任务存放到列表中
 *
 *  @param tag 每个区的标记
 */
- (void)dataFilter:(int)tag
{
    Class taskClass;
    if (tag == TaskMusic)
    {
        taskClass = [SimpleQueMusicHandle class];
    }
    else if(tag == TaskScence)
    {
        taskClass = [SimpleQueSceneHandle class];
    }
    else if(tag == TaskHumanity)
    {
        taskClass = [SimpleQueHumeHandle class];
    }
    else if(tag == TaskStory)
    {
        taskClass = [SimpleQueStoryHandle class];
    }
    else if(tag == TaskCommunite)
    {
        taskClass = [SimpleQueCommunHandle class];
    }
    else if(tag == TaskVideo)
    {
        taskClass = [SimpleQueVideoHandle class];
    }
    else;
    long long int allSimleSize = 0;
    if (tag == TaskMusic)
    {
        NSArray *arry = [AllGroupInfoArray objectAtIndex:tag];
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        for (int i = 0; i < [arry count]; i++)
        {
            NSDictionary *dict = [arry objectAtIndex:i];
            NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"music/%@", [dict objectForKey:@"music_name"]]];
            BOOL dirt = NO;
            if ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&dirt])
            {
                //// 音乐文件已经存在
            }
            else
            {
                LoadSimpleMusicNet *loadSimpleMisicNet = [[LoadSimpleMusicNet alloc] initWithClass:[taskClass class]];
                loadSimpleMisicNet.musicUrl = [dict objectForKey:@"music_path"];
                loadSimpleMisicNet.Name = [dict objectForKey:@"music_name"];
                [taskClass addTarget:loadSimpleMisicNet];
                allSimleSize++;
            }
        }
    }
    else if(tag == TaskVideo)
    {
        [self caculateVedioLoadTask];
    }
    else
    {
        NSArray *dataAry = [AllGroupInfoArray objectAtIndex:tag];
        for (int i = 0; i < [dataAry count]; i++)
        {
            NSDictionary *infoDict = [dataAry objectAtIndex:i];
            NSString *idStr  = [infoDict objectForKey:@"id"];
            if (![self isEixstInArray:LocalFileNameArray content:idStr])
            {
                long simpleSize = [[infoDict objectForKey:@"size"] intValue];
                allSimleSize += simpleSize;
                LoadZipFileNet *loadZipNet = [[LoadZipFileNet alloc] initWithClass:[taskClass class]];
                loadZipNet.delegate = nil;
                loadZipNet.urlStr   = [[infoDict objectForKey:@"url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                loadZipNet.md5Str   = [[infoDict objectForKey:@"md5"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                loadZipNet.zipStr   = [infoDict objectForKey:@"id"];
                [taskClass addTarget:loadZipNet];
            }
        }
    }
    UILabel *label = (UILabel *)[[progresScrolV viewWithTag:(tag+1)*BaseViewTag] viewWithTag:(tag+1)*BaseLabelTag];
    //下载任务里面没有下载量，即没有任务，就把状态改为已下载
    if (tag == TaskMusic)
    {
        [SimpleQueMusicHandle setSize:allSimleSize];
        [SimpleQueMusicHandle setImplyLb:label];
        if (allSimleSize == 0)
        {
            [self FinishLoad:TaskMusic];
        }
    }
    else if(tag == TaskScence)
    {
        [SimpleQueSceneHandle setSize:allSimleSize];
        [SimpleQueSceneHandle setImplyLb:label];
        if (allSimleSize == 0)
        {
            [self FinishLoad:TaskScence];
        }
    }
    else if(tag == TaskHumanity)
    {
        [SimpleQueHumeHandle setSize:allSimleSize];
        [SimpleQueHumeHandle setImplyLb:label];
        if (allSimleSize == 0)
        {
            [self FinishLoad:TaskHumanity];
        }
    }
    else if(tag == TaskStory)
    {
        [SimpleQueStoryHandle setSize:allSimleSize];
        [SimpleQueStoryHandle setImplyLb:label];
        if (allSimleSize == 0)
        {
            [self FinishLoad:TaskStory];
        }
    }
    else if(tag == TaskCommunite)
    {
        [SimpleQueCommunHandle setSize:allSimleSize];
        [SimpleQueCommunHandle setImplyLb:label];
        if (allSimleSize == 0)
        {
            [self FinishLoad:TaskCommunite];
        }
    }
    else if(tag == TaskVideo)
    {
        [SimpleQueVideoHandle setImplyLb:label];
    }
    else;
}

- (void)checkVedioTask
{
    [self performSelector:@selector(checkVedio) withObject:nil afterDelay:0.3f];
}

- (void)checkVedio
{
    if ([SimpleQueVideoHandle checkTask])
        [SimpleQueVideoHandle checkAfterStartTask];
    else
        [SimpleQueVideoHandle sureFinish];
}
/**
 *  计算视频的任务量
 */
- (void)caculateVedioLoadTask
{
    AllZipSize = 0;
    AllLoadLenght = 0;

    AllVideoSize = 0;
    AllLoadVideoLenght = 0;
    
    [XMLParser clear];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    for (int i = 0; i < RootViewContr.videoArray.count; i++)
    {
        NSDictionary *initDict = [RootViewContr.videoArray objectAtIndex:i];
        NSString *docXmlPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/doc.xml", [initDict objectForKey:@"id"]]];
        [[XMLParser alloc] initWithFilePath:docXmlPath];
    }
    // sunyongT [self goOnCaculateMovieLoader];
    [self performSelector:@selector(goOnCaculateMovieLoader) withObject:nil afterDelay:0.2f];
}

- (void)goOnCaculateMovieLoader
{
    NSMutableArray *fileNameArray = [[NSMutableArray alloc] init];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[path stringByAppendingPathComponent:@"movie"] error:nil];
    [fileNameArray addObjectsFromArray:array];
    [fileNameArray removeObject:@".DS_Store"];
    
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
            LoadSimpleMovieNet *loadMoiveNet = [[LoadSimpleMovieNet alloc] initWithClass:[SimpleQueVideoHandle class]];
            loadMoiveNet.urlStr = urlStr;
            loadMoiveNet.Name   = [tempAry lastObject];
            [SimpleQueVideoHandle addTarget:loadMoiveNet];
        }
    }
    AllVideoSize -= existFileSize;
    [SimpleQueVideoHandle setSize:AllVideoSize];
    if (AllVideoSize < 1000)
    {
       // [self FinishLoad:TaskVideo];
    }
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
/**
 *  区的下载任务完成
 *
 *  @param taskTag 区的标记
 */
- (void)FinishLoad:(int)taskTag
{
    UILabel *implyLb = (UILabel *)[[progresScrolV viewWithTag:(taskTag+1)*BaseViewTag] viewWithTag:(taskTag+1)*BaseLabelTag];
    implyLb.hidden = YES;
    
    UIButton *implyBt = (UIButton *)[[progresScrolV viewWithTag:(taskTag+1)*BaseViewTag] viewWithTag:taskTag+1];
    [implyBt setTitle:@"" forState:UIControlStateNormal];
    [implyBt setBackgroundImage:[UIImage imageNamed:@"icon_tick_50.png"] forState:UIControlStateNormal];
    implyBt.titleLabel.font = [UIFont systemFontOfSize:17];
    [implyBt setFrame:CGRectMake(ScrolViewWidth-34-10, 13, 34, 34)];
}

#pragma mark - view handle
/**
 *  重新建下载界面, 重新安排下载任务
 */
- (void)rebuildProgressView
{
    [self removeAllChildView:progresScrolV];
    int pos = 0;
    UIView *newView = nil;
    for (int i = 0; i < swViewAry.count; i++)
    {
        UISwitch *switchView = [swViewAry objectAtIndex:i];
        if (switchView.on)
        {
            newView = [self builtProgressView:i position:pos];
            [progresScrolV addSubview:newView];
            [self getFileNameAry];
            [self dataFilter:i];
            pos++;
        }
        else
        {
            [self clearQueData:i];
        }
    }
    if (newView)
    {
        UILabel *bottomLineLb = [[UILabel alloc] initWithFrame:CGRectMake(0, ViewHeigh-1, ScrolViewWidth, 1)];
        bottomLineLb.backgroundColor = [UIColor lightGrayColor];
        [newView addSubview:bottomLineLb];
    }
    //////开始下载  /// 由于xml解析的原因，得延迟执行
    [self performSelector:@selector(startLoading) withObject:nil afterDelay:0.3f];
    
}
/**
 *  开始下载
 */
- (void)startLoading
{
    [SimpleQueSceneHandle startTask];
}

/**
 *  下载界面， 创建区相对应的进度条界面
 *
 *  @param viewTag 区的标记
 *  @param pos     区在下载界面的位置
 *
 *  @return 区的进度条界面
 */
- (UIView*)builtProgressView:(NSInteger)viewTag position:(int)pos
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, pos*60, ScrolViewWidth, ViewHeigh)];
    view.tag = (viewTag+1)*BaseViewTag;
    
    UILabel *lineLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScrolViewWidth, 1)];
    lineLb.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:lineLb];
    
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 60)];
    titleLb.font = [UIFont boldSystemFontOfSize:18];
    titleLb.backgroundColor = [UIColor clearColor];
    titleLb.textColor = [UIColor blackColor];
    titleLb.textAlignment = NSTextAlignmentLeft;
    titleLb.text = [menuAry objectAtIndex:viewTag];
    [view addSubview:titleLb];
    
    UILabel *implyLb = [[UILabel alloc] initWithFrame:CGRectMake(420, 0, 80, 60)];
    implyLb.tag = (viewTag+1)*BaseLabelTag;
    implyLb.textColor = [UIColor grayColor];
    implyLb.backgroundColor = [UIColor clearColor];
    implyLb.font = [UIFont systemFontOfSize:17];
    implyLb.text = @"等待中";
    [view addSubview:implyLb];
    
    UIButton *canleBt = [UIButton buttonWithType:UIButtonTypeCustom];
    canleBt.tag = (viewTag+1);
    [canleBt setBackgroundColor:[UIColor whiteColor]];
    [canleBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [canleBt setTitle:@"" forState:UIControlStateNormal];
    canleBt.titleLabel.font = [UIFont systemFontOfSize:14];
    [canleBt addTarget:self action:@selector(canleLoader:) forControlEvents:UIControlEventTouchDown];
    [canleBt setFrame:CGRectMake(ScrolViewWidth-40-10, 20, 40, 20)];
    [view addSubview:canleBt];
    return view;
}
/**
 *  创建选择区的Task界面
 */
- (UIView*)builtMenuView:(NSInteger)viewTag
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, viewTag*60, ScrolViewWidth, ViewHeigh)];
    view.tag = (viewTag+1)*BaseViewTag;
    
    UILabel *lineLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScrolViewWidth, 1)];
    lineLb.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:lineLb];
    
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 60)];
    titleLb.font = [UIFont boldSystemFontOfSize:18];
    titleLb.backgroundColor = [UIColor clearColor];
    titleLb.textColor = BlackBGColor;
    titleLb.textAlignment = NSTextAlignmentLeft;
    titleLb.text = [menuAry objectAtIndex:viewTag];
    [view addSubview:titleLb];
    
    UISwitch *swithV = [[UISwitch alloc] initWithFrame:CGRectMake(523, 15, 80, 27)];
    swithV.on = YES;
    swithV.onTintColor = [UIColor blueColor];
    swithV.thumbTintColor = [UIColor lightGrayColor];
    swithV.tag = (viewTag+1)*BaseSwitchTag;
    [view addSubview:swithV];
    
    [swViewAry addObject:swithV];
    
    if (viewTag == menuAry.count-1)
    {
        UILabel *bottomLineLb = [[UILabel alloc] initWithFrame:CGRectMake(0, ViewHeigh-1, ScrolViewWidth, 1)];
        bottomLineLb.backgroundColor = [UIColor lightGrayColor];
        [view addSubview:bottomLineLb];
    }
    return view;
}

- (void)removeAllChildView:(UIView*)view
{
    NSArray *subViewAry = view.subviews;
    for (int i = 0; i < subViewAry.count; i++)
    {
        UIView *subView = [subViewAry objectAtIndex:i];
        [subView removeFromSuperview];
        subView = nil;
    }
}
#pragma mark - Bt Event
// canle loader
- (void)canleLoader:(UIButton*)sender
{
    return;
    if ([sender.titleLabel.text isEqualToString:@""])
        return;
    if ([sender.titleLabel.text isEqualToString:@"已完成"])
        return;
    [sender setTitle:@"已取消" forState:UIControlStateNormal];
    [sender setBackgroundColor:[UIColor whiteColor]];
    sender.titleLabel.font = [UIFont systemFontOfSize:17];
    [sender setFrame:CGRectMake(ScrolViewWidth-60-10, 10, 60, 40)];
    
    UIView  *view = [progresScrolV viewWithTag:sender.tag*100];
    UILabel *implyLb = (UILabel*)[view viewWithTag:sender.tag*10000];
    implyLb.hidden = YES;
    
    [self clearQueData:sender.tag-1];
}

//切换界面，重新安排下载任务
- (IBAction)changeView:(UIButton*)sender
{
    [self rebuildProgressView];
    return;
    
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.7;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"oglFlip";
    animation.subtype = kCATransitionFromLeft;
    NSUInteger beforeV = [[subViewBg subviews] indexOfObject:menuView];
    NSUInteger afterV  = [[subViewBg subviews] indexOfObject:loadProgresView];
    if (sender.tag == 1)  //// 完成
    {
        [self rebuildProgressView];
    }
    else  ///// 设置
    {
        beforeV = [[subViewBg subviews] indexOfObject:loadProgresView];
        afterV  = [[subViewBg subviews] indexOfObject:menuView];
    }
    
    [subViewBg exchangeSubviewAtIndex:beforeV withSubviewAtIndex:afterV];
    [[subViewBg layer] addAnimation:animation forKey:@"animation"];
}

- (IBAction)hiddenView:(UIButton*)sender
{
    
    [UIView animateWithDuration:0.4
                     animations:^(void){
                         self.blackBgView.alpha = 0;
                         [self.view setFrame:CGRectMake(0, 768, self.view.frame.size.width, self.view.frame.size.height)];
                     }
                     completion:^(BOOL finish){
                     }];
}

// 停止下载所有任务
- (IBAction)stopAllTask:(UIButton*)sender
{
    [SimpleQueSceneHandle  stopTask];
    [SimpleQueHumeHandle   stopTask];
    [SimpleQueStoryHandle  stopTask];
    [SimpleQueCommunHandle stopTask];
    [SimpleQueMusicHandle  stopTask];
    [SimpleQueVideoHandle  stopTask];
    [self hiddenView:nil];
}
// 打开所有任务
- (IBAction)openAllTask:(UIButton*)sender
{
    for (int i = 0; i < swViewAry.count; i++)
    {
        UISwitch *swView = [swViewAry objectAtIndex:i];
        [swView setOn:YES animated:YES];
    }
}
//关闭所有任务
- (IBAction)closeAllTask:(UIButton*)sender
{
    for (int i = 0; i < swViewAry.count; i++)
    {
        UISwitch *swView = [swViewAry objectAtIndex:i];
        [swView setOn:NO animated:YES];
    }
}
@end
