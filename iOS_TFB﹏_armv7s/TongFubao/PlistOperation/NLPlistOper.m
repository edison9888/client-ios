//
//  PlistOper.m
//  kvpioneer
//
//  Created by Jiajun Xie on 13-5-6.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "NLPlistOper.h"

@implementation NLPlistOper

+(id)readValue:(NSString*)key path:(NSString*)path;
{
    NSDictionary* dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    id value = [dict objectForKey:key];
    return value;
}

+(BOOL)writeValue:(id)value key:(NSString*)key path:(NSString*)path
{
    BOOL result = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL find = [fileManager fileExistsAtPath:path];
    if (find)
    {
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        [dict setObject:value forKey:key];
        result = [dict writeToFile:path atomically:YES];
    }
    else
    {
        [fileManager createFileAtPath:path contents:nil attributes:nil];
        //创建一个dic，写到plist文件里
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:value,key,nil];
        result = [dic writeToFile:path atomically:YES];
    }
    return result;
}

@end
