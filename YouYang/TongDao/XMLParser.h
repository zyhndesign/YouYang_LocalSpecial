//
//  XMLParser.h
//  TongDao
//
//  Created by sunyong on 13-11-28.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLParser : NSObject<NSXMLParserDelegate>
{
    NSString *keyStr;
    BOOL StartKey;
    BOOL StartValue;
    BOOL StartSize;
}

- (void)initWithFilePath:(NSString*)filePath;
+ (void)clear;
@end
