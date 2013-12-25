//
//  LocalSQL.m
//  GYSJ
//
//  Created by sunyong on 13-7-23.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//
#import "LocalSQL.h"

sqlite3 *dataBase;

@implementation LocalSQL

+ (BOOL)openDataBase
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [path stringByAppendingPathComponent:@"Data.db"];
    if (sqlite3_open([fileName UTF8String], &dataBase) == SQLITE_OK)
        return YES;
    return NO;
}

+ (BOOL)closeDataBase
{
    if (sqlite3_close(dataBase) == SQLITE_OK)
        return YES;
    return NO;
}

+ (BOOL)createLocalTable
{
    NSString *sqlStr = [NSString stringWithFormat:@"create table if not exists myTable(id char primary key,md5 char,name char, timestamp char, url char,author char, category char, description char, headline char,postDate char,profile char, background char, hasVideo char, size char)"];
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(dataBase, [sqlStr UTF8String], -1, &stmt, 0) != SQLITE_OK)
    {
        sqlite3_finalize(stmt);
        return NO;
    }
    if (sqlite3_step(stmt) == SQLITE_DONE)
    {
        sqlite3_finalize(stmt);
        return YES;
    }
    sqlite3_finalize(stmt);
    return NO;
}

+ (NSArray*)getAll
{
    NSMutableArray *backAry = [NSMutableArray array];
    NSString *sqlStr = [NSString stringWithFormat:@"select * from mytable"];
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(dataBase, [sqlStr UTF8String], -1, &stmt, 0) == SQLITE_OK)
    {
        while (sqlite3_step(stmt) == SQLITE_ROW)
        {
            NSString *idStr   = [NSString stringWithFormat:@"%s", sqlite3_column_text(stmt, 0)];
            NSString *md5Str  = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 1) encoding:NSUTF8StringEncoding];
            NSString *nameStr  = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 2) encoding:NSUTF8StringEncoding];
            NSString *timeStampStr = [NSString stringWithFormat:@"%s", sqlite3_column_text(stmt, 3)];
            NSString *urlStr       = [NSString stringWithFormat:@"%s", sqlite3_column_text(stmt, 4)];
            NSString *authorStr = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 5) encoding:NSUTF8StringEncoding];
            NSString *categoryStr   = [NSString stringWithFormat:@"%s", sqlite3_column_text(stmt, 6)];
            NSString *descriStr     = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 7) encoding:NSUTF8StringEncoding];
            NSString *headlineStr   = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 8) encoding:NSUTF8StringEncoding];
            NSString *postDateStr   = [NSString stringWithFormat:@"%s", sqlite3_column_text(stmt, 9)];
            NSString *profileStr    = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 10) encoding:NSUTF8StringEncoding];
            NSString *backgroundStr = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 11) encoding:NSUTF8StringEncoding];
            NSString *hasVideoStr   = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 12) encoding:NSUTF8StringEncoding];
            NSString *sizeStr = [NSString stringWithFormat:@"%s", sqlite3_column_text(stmt, 13)];
            NSDictionary *subDict   = [NSDictionary dictionaryWithObjectsAndKeys:idStr,@"id",md5Str,@"md5",nameStr, @"name",timeStampStr,@"timestamp",urlStr,@"url",authorStr,@"author",categoryStr,@"category",descriStr,@"description",headlineStr,@"headline",postDateStr,@"postDate",profileStr,@"profile",backgroundStr,@"background", hasVideoStr, @"hasVideo", sizeStr, @"size", nil];
            [backAry addObject:subDict];
        }
        sqlite3_finalize(stmt);
        return backAry;
    }
    return nil;
}

+ (BOOL)getIsExistDataFromID:(NSString*)idstr
{
    NSString *sqlStr = [NSString stringWithFormat:@"select id from mytable where id = '%@'", idstr];
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(dataBase, [sqlStr UTF8String], -1, &stmt, 0) == SQLITE_OK)
    {
        while (sqlite3_step(stmt) == SQLITE_ROW)
        {
            sqlite3_finalize(stmt);
            return YES;
        }
        sqlite3_finalize(stmt);
    }
    return NO;
}

+ (BOOL)insertData:(NSDictionary*)infoDict
{
    if ([[infoDict objectForKey:@"op"] isEqual:@"d"]) // 删除操作
    {
        NSString *idStr = [infoDict objectForKey:@"id"];
        [LocalSQL deleteData:idStr];
        NSString *docPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:idStr];
        [[NSFileManager defaultManager] removeItemAtPath:docPath error:nil];
        return YES;
    }
    NSDictionary *subInfoDict = [infoDict objectForKey:@"info"];
    NSString *idStr     = [infoDict objectForKey:@"id"];
    NSString *md5Str    = [infoDict objectForKey:@"md5"];
    NSString *nameStr   = [infoDict objectForKey:@"name"];
    NSString *timestamp = [infoDict objectForKey:@"timestamp"];
    NSString *urlStr    = [infoDict objectForKey:@"url"];
    NSString *sizeStr   = [infoDict objectForKey:@"size"];
    
    NSString *authorStr      = [subInfoDict objectForKey:@"author"];
    NSString *categoryStr    = [subInfoDict objectForKey:@"category"];
    NSString *descriptionStr = [subInfoDict objectForKey:@"description"];
    if(descriptionStr.length < 1)
        descriptionStr = @"";
    NSString *headLine    = [subInfoDict objectForKey:@"headline"];
    NSString *postDateS   = [subInfoDict objectForKey:@"postDate"];
    NSString *backgroundS = [subInfoDict objectForKey:@"background"];
    NSString *hasVideoStr = [subInfoDict objectForKey:@"hasVideo"];
    if (postDateS.length > 0)
    {
        NSArray *tempDateAry = [postDateS componentsSeparatedByString:@"/"];
        postDateS = [tempDateAry objectAtIndex:0];
        for (int i = 1; i < tempDateAry.count; i++)
        {
            postDateS = [NSString stringWithFormat:@"%@%@", postDateS, [tempDateAry objectAtIndex:i]];
        }
    }
    else
        postDateS = [NSString stringWithFormat:@"00000000"];
    NSString *profileStr = [subInfoDict objectForKey:@"profile"];
    if(profileStr.length < 1)
        profileStr = @"";
    
    NSString *sqlStr = nil;
    if ([LocalSQL getIsExistDataFromID:idStr])
    {
        if (![profileStr isEqualToString:[LocalSQL getProImageUrl:idStr]])
        {
            NSString *ProImgeFormat = [[profileStr componentsSeparatedByString:@"."] lastObject];
            NSString *pathProFile = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"ProImage/%@.%@",idStr, ProImgeFormat]];
            [[NSFileManager defaultManager] removeItemAtPath:pathProFile error:nil];
        }
        sqlStr = [NSString stringWithFormat:@"update mytable set md5='%@',name='%@',timestamp='%@',url='%@',author='%@',category='%@',description='%@',headline='%@',postDate='%@',profile='%@',background='%@', hasVideo='%@', size='%@' where id = '%@'",md5Str, nameStr, timestamp, urlStr, authorStr, categoryStr, descriptionStr, headLine, postDateS, profileStr, backgroundS,hasVideoStr, sizeStr,idStr];
        NSString *docPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:idStr];
        [[NSFileManager defaultManager] removeItemAtPath:docPath error:nil];
    }
    else
    {
        sqlStr = [NSString stringWithFormat:@"insert into mytable values('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')", idStr, md5Str, nameStr, timestamp, urlStr, authorStr, categoryStr, descriptionStr, headLine, postDateS, profileStr, backgroundS,hasVideoStr,sizeStr];
    }
    //// testsunyong
//    sqlStr = [NSString stringWithFormat:@"insert into mytable values('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')", idStr, md5Str, nameStr, timestamp, urlStr, authorStr, categoryStr, descriptionStr, headLine, postDateS, profileStr, backgroundS];
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(dataBase, [sqlStr UTF8String], -1, &stmt, 0) != SQLITE_OK)
    {
        sqlite3_finalize(stmt);
        return NO;
    }
    if (sqlite3_step(stmt) == SQLITE_DONE)
    {
        sqlite3_finalize(stmt);
        return YES;
    }
    sqlite3_finalize(stmt);
    return NO;
}

+ (BOOL)deleteData:(NSString*)idStr
{
    NSString *sqlStr = [NSString stringWithFormat:@"delete from mytable where id = '%@'", idStr];
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(dataBase, [sqlStr UTF8String], -1, &stmt, 0) != SQLITE_OK)
    {
        sqlite3_finalize(stmt);
        return NO;
    }
    if (sqlite3_step(stmt) == SQLITE_DONE)
    {
        sqlite3_finalize(stmt);
        return YES;
    }
    sqlite3_finalize(stmt);
    return NO;
}

+ (NSArray*)getSectionData:(NSString*)categoryStr
{
    NSMutableArray *backAry = [NSMutableArray array];
    NSString *sqlStr = [NSString stringWithFormat:@"select * from mytable where category='%@' order by postDate desc", categoryStr];
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(dataBase, [sqlStr UTF8String], -1, &stmt, 0) == SQLITE_OK)
    {
        while (sqlite3_step(stmt) == SQLITE_ROW)
        {
            NSString *idStr   = [NSString stringWithFormat:@"%s", sqlite3_column_text(stmt, 0)];
            NSString *md5Str = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 1) encoding:NSUTF8StringEncoding];
            NSString *nameStr  = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 2) encoding:NSUTF8StringEncoding];
            NSString *timeStampStr = [NSString stringWithFormat:@"%s", sqlite3_column_text(stmt, 3)];
            NSString *urlStr       = [NSString stringWithFormat:@"%s", sqlite3_column_text(stmt, 4)];
            NSString *authorStr = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 5) encoding:NSUTF8StringEncoding];
            NSString *categoryStr     = [NSString stringWithFormat:@"%s", sqlite3_column_text(stmt, 6)];
            NSString *descriStr     = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 7) encoding:NSUTF8StringEncoding];
            NSString *headlineStr = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 8) encoding:NSUTF8StringEncoding];
            NSString *postDateStr    = [NSString stringWithFormat:@"%s", sqlite3_column_text(stmt, 9)];
            NSString *profileStr    = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 10) encoding:NSUTF8StringEncoding];
            NSString *backgroundStr = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 11) encoding:NSUTF8StringEncoding];
            NSString *hasVideoStr   = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 12) encoding:NSUTF8StringEncoding];
            NSString *sizeStr = [NSString stringWithFormat:@"%s", sqlite3_column_text(stmt, 13)];
            NSDictionary *subDict = [NSDictionary dictionaryWithObjectsAndKeys:idStr,@"id",md5Str,@"md5",nameStr, @"name",timeStampStr,@"timestamp",urlStr,@"url",authorStr,@"author",categoryStr,@"category",descriStr,@"description",headlineStr,@"headline",postDateStr,@"postDate",profileStr,@"profile",backgroundStr,@"background",hasVideoStr, @"hasVideo", sizeStr, @"size",nil];
            [backAry addObject:subDict];
        }
        sqlite3_finalize(stmt);
    }
    return backAry;
}

+ (NSArray*)getHeadline
{
    NSMutableArray *backAry = [NSMutableArray array];
    NSString *sqlStr = [NSString stringWithFormat:@"select * from mytable where headline='true' order by postDate desc"];
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(dataBase, [sqlStr UTF8String], -1, &stmt, 0) == SQLITE_OK)
    {
        while (sqlite3_step(stmt) == SQLITE_ROW)
        {
            NSString *idStr     = [NSString stringWithFormat:@"%s", sqlite3_column_text(stmt, 0)];
            NSString *md5Str    = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 1) encoding:NSUTF8StringEncoding];
            NSString *nameStr   = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 2) encoding:NSUTF8StringEncoding];
            NSString *timeStampStr = [NSString stringWithFormat:@"%s", sqlite3_column_text(stmt, 3)];
            NSString *urlStr       = [NSString stringWithFormat:@"%s", sqlite3_column_text(stmt, 4)];
            NSString *authorStr    = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 5) encoding:NSUTF8StringEncoding];
            NSString *categoryStr  = [NSString stringWithFormat:@"%s", sqlite3_column_text(stmt, 6)];
            NSString *descriStr    = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 7) encoding:NSUTF8StringEncoding];
            NSString *headlineStr  = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 8) encoding:NSUTF8StringEncoding];
            NSString *postDateStr  = [NSString stringWithFormat:@"%s", sqlite3_column_text(stmt, 9)];
            NSString *profileStr   = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 10) encoding:NSUTF8StringEncoding];
            NSString *backgroundStr = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 11) encoding:NSUTF8StringEncoding];
            NSString *hasVideoStr = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 12) encoding:NSUTF8StringEncoding];
            NSString *sizeStr = [NSString stringWithFormat:@"%s", sqlite3_column_text(stmt, 13)];
            NSDictionary *subDict = [NSDictionary dictionaryWithObjectsAndKeys:idStr,@"id",md5Str,@"md5",nameStr, @"name",timeStampStr,@"timestamp",urlStr,@"url",authorStr,@"author",categoryStr,@"category",descriStr,@"description",headlineStr,@"headline",postDateStr,@"postDate",profileStr,@"profile",backgroundStr,@"background", hasVideoStr, @"hasVideo", sizeStr, @"size", nil];
            [backAry addObject:subDict];
        }
        sqlite3_finalize(stmt);
    }
    return backAry;
}

+ (NSString*)getProImageUrl:(NSString*)idstr
{
    NSString *sqlStr = [NSString stringWithFormat:@"select profile from mytable where id = '%@'", idstr];
    sqlite3_stmt *stmt;
    NSString *backStr = nil;
    if (sqlite3_prepare_v2(dataBase, [sqlStr UTF8String], -1, &stmt, 0) == SQLITE_OK)
    {
        while (sqlite3_step(stmt) == SQLITE_ROW)
        {
            backStr = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 0) encoding:NSUTF8StringEncoding];
        }
        sqlite3_finalize(stmt);
    }
    return backStr;
}

@end
