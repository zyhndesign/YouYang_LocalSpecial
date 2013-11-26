//
//  LocalSQL.h
//  GYSJ
//
//  Created by sunyong on 13-7-23.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>



@interface LocalSQL : NSObject


+ (BOOL)openDataBase;
+ (BOOL)closeDataBase;
+ (BOOL)createLocalTable;


+ (BOOL)getIsExistDataFromID:(NSString*)idstr;

+ (BOOL)insertData:(NSDictionary*)infoDict;

+ (NSMutableArray*)getAll;

+ (NSArray*)getSectionData:(NSString*)categoryStr;

+ (NSArray*)getHeadline;


@end
