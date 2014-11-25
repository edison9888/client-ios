//
//  DataBase.m
//  PhoneInfoTest
//
//  Created by wu wangchun on 12-6-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DataBase.h"
//#import "../AddHearderForJB.h"

@implementation DataBase

@synthesize isOpen;

-(id)initWithName:(NSString*)name
{
    if (self) 
    {
        if(![self openDataStore:name])
        {
            return nil;
        }
    }
    return self;
}

-(void)dealloc
{
    if (isOpen) 
    {
        [self closeDataStore];
    }
    [super dealloc];
}

-(bool) openDataStore:(NSString*)name
{
    isOpen=NO;
    NSString *path = name;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL find = [fileManager fileExistsAtPath:path];
	
    //找到数据库文件mydb.sql
    if (find) 
    {
		if(sqlite3_open([path UTF8String], &database_) != SQLITE_OK) 
        {
            sqlite3_close(database_);
            return false;
        }
		isOpen=YES;
        return true;
    }
    if(sqlite3_open([path UTF8String], &database_) == SQLITE_OK) 
    {
        if ([self createTable]) 
        {
            isOpen=YES;
            return true;
        }
        else 
        {
            return false;
        }
        
    } 
    else 
    {
        sqlite3_close(database_);
        return false;
    }
    return false;
}

-(void)closeDataStore
{
    if (isOpen) 
    {
        sqlite3_close(database_);
        isOpen=false;
    }
}

-(bool)createTable
{
    return false;
}
@end
