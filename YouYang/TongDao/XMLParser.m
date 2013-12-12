//
//  XMLParser.m
//  TongDao
//
//  Created by sunyong on 13-11-28.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "XMLParser.h"
#import "AllVariable.h"

@implementation XMLParser

- (void)initWithFilePath:(NSString*)filePath
{
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath]];
    xmlParser.delegate = self;
    [xmlParser parse];
}

+ (void)clear
{
    [AllMovieInfoDict removeAllObjects];
}
#pragma mark - xmlParser delegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"showUrl"])
    {
        StartKey = YES;
    }
    else if([elementName isEqualToString:@"videoUrl"])
    {
        StartValue = YES;
    }
    else if([elementName isEqualToString:@"size"])
    {
        StartSize = YES;
    }
    else ;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (StartKey)
    {
        keyStr = [[NSString alloc] initWithFormat:@"%@",string];
    }
    if (StartValue && string.length > 0)
    {
        NSString *str = [AllMovieInfoDict objectForKey:keyStr];
        if (str.length < 1)
            [AllMovieInfoDict setObject:string forKey:keyStr];
        else
            [AllMovieInfoDict setObject:[str stringByAppendingString:string] forKey:keyStr];
    }
    if (StartSize)
    {
        AllVideoSize += [string intValue];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    StartKey   = NO;
    StartValue = NO;
    StartSize  = NO;
}

@end
