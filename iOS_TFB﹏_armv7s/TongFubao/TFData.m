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
static NSMutableArray       *arrData;
static NSMutableDictionary  *dicData;

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

/*存个值 懒得写那么多代码*/
+(NSMutableArray*)setarr:(NSMutableArray*)arr
{
    if (!arrData) {
        arrData= [NSMutableArray array];
    }
    arrData= arr;
    NSLog(@"dictData 存一存%@",arrData);
    return arrData;
}

+(NSMutableArray*)getarr
{
    NSLog(@"dictData 取一取%@",arrData);
    return arrData;
}

+(NSMutableDictionary*)setdic:(NSMutableDictionary*)dic
{
    if (!dicData) {
        dicData= [[NSMutableDictionary alloc]init];
    }
    dicData= dic;
    NSLog(@"dictData 存一存%@",dicData);
    return dicData;
}

+(NSMutableDictionary*)getdic
{
    NSLog(@"dicData 取一取%@",dicData);
    return dicData;
}

@end
