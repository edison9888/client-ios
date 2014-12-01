//
//  LoadDataWithASI.h
//  TongFubao
//
//  Created by Delpan on 14-9-10.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NLpublic.h"

typedef enum
{
    LoadDataWithASI_None = 0,
    LoadDataWithASI_msgchild,
}LoadDataWithASI_Type;

@interface LoadDataWithASI : NSObject <ASIHTTPRequestDelegate>

@property (nonatomic, copy) NSString *rolePath;
//路径数据
@property (nonatomic, copy) NSArray *paths;
//数据结构类型
@property (nonatomic, copy) NSArray *types;

@property (nonatomic, copy) void (^completionBlock)(id data, NSError *error);

@property (nonatomic, assign) PublicType currentType;

+ (void)loadDataWithMsgbody:(NSDictionary *)msgbody apiName:(NSString *)apiName apiNameFunc:(NSString *)apiNameFunc  rolePath:(NSString *)rolePath type:(PublicType)type completionBlock:(void (^)(id data, NSError *error))completionBlock;

+ (void)loadDataWithMsgbody:(NSDictionary *)msgbody apiName:(NSString *)apiName apiNameFunc:(NSString *)apiNameFunc  rolePaths:(NSArray *)rolePaths types:(NSArray *)types completionBlock:(void (^)(id data, NSError *error))completionBlock;

@end














