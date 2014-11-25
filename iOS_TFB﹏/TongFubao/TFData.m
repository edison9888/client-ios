//
//  TFData.m
//  TongFubao
//
//  Created by ec on 14-5-20.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "TFData.h"

static TFData *dataManage = nil;
static NSMutableDictionary  *tempData;

@implementation TFData

+(TFData *)Instance{
    static dispatch_once_t dataManagerOnceToken;
    
    dispatch_once(&dataManagerOnceToken, ^{
        if (!dataManage) {
            dataManage = [[self alloc] init];
        }
    });
    return dataManage;
}

+(id)allocWithZone:(NSZone *)zone{
    @synchronized(self){
        if (!dataManage) {
            dataManage = [super allocWithZone:zone];
        }
    }
    return dataManage;
}

#pragma mark - 全局字典,用于内存数据缓存
+(NSMutableDictionary*)getTempData{
    if (!tempData) {
    tempData = [[NSMutableDictionary alloc] initWithCapacity:5];
    }
    return tempData;
    
}

@end
