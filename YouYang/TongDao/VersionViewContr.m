//
//  VersionViewContr.m
//  TongDao
//
//  Created by sunyong on 13-9-17.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//
/*
 “酉歌行”设计与社会创新夏令营是在酉阳县委领导的支持下，由湖南大学、四川美术学院、米兰理工大学、美克美家等单位联合开展的跨学科联合设计与社会创新活动。活动以酉阳的国家级非物质文化遗产摆手舞、阳戏及原生态民歌为研究对象，通过数字化的影像记录与网络平台构建、可视化与交互设计、互动参与式的社区活动等方法，探索基于网络的、可持续、开放的文化生态保护与发展模式，为地域传统文化的传播、创新及产业化提供设计支持。活动保护和传播了酉阳非物质文化遗产，丰富了当地村民的文化生活，增进他们对本土文化的自豪感。
 */
#import "VersionViewContr.h"

@interface VersionViewContr ()

@end

@implementation VersionViewContr

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
    NSString *string = [NSString stringWithFormat:@"“酉歌行”设计与社会创新夏令营是在酉阳县委领导的支持下，由湖南大学、四川美术学院、米兰理工大学、美克美家等单位联合开展的跨学科联合设计与社会创新活动。活动以酉阳的国家级非物质文化遗产摆手舞、阳戏及原生态民歌为研究对象，通过数字化的影像记录与网络平台构建、可视化与交互设计、互动参与式的社区活动等方法，探索基于网络的、可持续、开放的文化生态保护与发展模式，为地域传统文化的传播、创新及产业化提供设计支持。活动保护和传播了酉阳非物质文化遗产，丰富了当地村民的文化生活，增进他们对本土文化的自豪感。"];
    self.view.backgroundColor = [UIColor colorWithRed:33/255.0 green:33/255.0 blue:33/255.0 alpha:1];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    detailTextV.text = string;
    detailTextV.linesSpacing = 6;
    
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineSpacing = 6.0f;
//    paragraphStyle.firstLineHeadIndent = 13.0f;
//    NSDictionary *ats = [NSDictionary dictionaryWithObjectsAndKeys:paragraphStyle, NSParagraphStyleAttributeName, [UIFont systemFontOfSize:14], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil];
//    NSAttributedString *atrriString = [[NSAttributedString alloc] initWithString:string attributes:ats];
//    detailTextV.attributedText = atrriString;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
