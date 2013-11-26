//
//  SimpleLandscView.h
//  TongDao
//
//  Created by sunyong on 13-9-26.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkDelegate.h"
@interface SimpleLandscView : UIView<NetworkDelegate>
{
    UIImageView *proImageV;
    UILabel *titleLb;
    
    NSDictionary *_infoDict;
}

- (id)initWithInfoDict:(NSDictionary*)infoDict;
@end
