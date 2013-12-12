//
//  AllVariable.h
//  TongDao
//
//  Created by sunyong on 13-9-17.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#ifndef TongDao_AllVariable_h
#define TongDao_AllVariable_h
#import "QueueZipHandle.h"
#import "QueueProHanle.h"

@class ViewController;
@class SCGIFImageView;
@class ActionView;
@class AudioPlayerViewCtr;
@class LoaderViewController;

ViewController *RootViewContr;
UIScrollView *AllScrollView;
AudioPlayerViewCtr *AllAudioPlayViewCtr;
int AllOnlyShowPresentOne;  // 只能同时展开一个详细内容
SCGIFImageView* gifImageView;
UIImageView *playMusicImageV;
BOOL playing; /// music status
BOOL AllLoad;
BOOL AllOnceLoad;

NSMutableArray *AllMusicQueAry;
NSMutableDictionary *AllMovieInfoDict;
long AllZipSize;
long AllLoadLenght;

long AllVideoSize;
long AllLoadVideoLenght;

LoaderViewController *AllLoaderViewContr;   //
NSMutableArray *AllGroupInfoArray;  // 存放所有区下载的任务相关的数据，但视频数据临时计算
BOOL AllMusicListLoadOver;

#endif
