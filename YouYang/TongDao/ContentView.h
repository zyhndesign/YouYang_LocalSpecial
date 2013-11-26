//
//  ContentView.h
//  YouYang
//
//  Created by sunyong on 13-10-11.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkDelegate.h"
#import "LoadZipFileNet.h"
#import "ActionView.h"

@interface ContentView : UIView<UIWebViewDelegate, NSXMLParserDelegate, NetworkDelegate>
{
    UIWebView *_webView;
    UILabel *bgLabel;
    
    NSDictionary *initDict;
    NSMutableDictionary *infoDict;
    
    NSString *keyStr;
    BOOL StartKey;
    BOOL StartValue;
    LoadZipFileNet *loadZipNet;
}
@property(nonatomic, strong)UIProgressView *progressV;
@property(nonatomic, strong)UILabel *proValueLb;
@property(nonatomic, strong)UILabel *proMarkLb;

- (id)initWithInfoDict:(NSDictionary*)infoDict;
- (void)back:(UIButton*)sender;

@end
