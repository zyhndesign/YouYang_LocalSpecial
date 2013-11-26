//
//  MovieBgPlayViewCtr.h
//  TongDao
//
//  Created by sunyong on 13-9-22.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface MovieBgPlayViewCtr : UIViewController
{
    NSString *urlStr;
    UIActivityIndicatorView *activeView;
    MPMoviePlayerController *movie;
    BOOL isShow;
}

- (id)initwithURL:(NSString*)URLStr;
@end
