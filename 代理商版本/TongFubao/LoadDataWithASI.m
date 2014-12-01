//
//  LoadDataWithASI.m
//  TongFubao
//
//  Created by Delpan on 14-9-10.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "LoadDataWithASI.h"

@implementation LoadDataWithASI

+ (void)loadDataWithMsgbody:(NSDictionary *)msgbody apiName:(NSString *)apiName apiNameFunc:(NSString *)apiNameFunc  rolePath:(NSString *)rolePath type:(PublicType)type completionBlock:(void (^)(id, NSError *))completionBlock
{
    LoadDataWithASI *loadData = [[LoadDataWithASI alloc] init];
    loadData.completionBlock = completionBlock;
    loadData.rolePath = rolePath;
    loadData.currentType = type;
    
    //加密
    NLpublic *encrypt = [[NLpublic new] autorelease];
    //格式化
    NLpublic *format = [[NLpublic new] autorelease];
    
    NSData *bodyData = [encrypt encrypt:[format msgbody:msgbody api_name:apiName api_name_func:apiNameFunc]];
    
    //数据请求
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:SERVER_URL]];
    [request setDelegate:loadData];
    [request setNumberOfTimesToRetryOnTimeout:10];
    
    [request setRequestMethod:@"POST"];
    //加入body
    [request appendPostData: bodyData];
    [request startAsynchronous];
}

+ (void)loadDataWithMsgbody:(NSDictionary *)msgbody apiName:(NSString *)apiName apiNameFunc:(NSString *)apiNameFunc  rolePaths:(NSArray *)rolePaths types:(NSArray *)types completionBlock:(void (^)(id data, NSError *))completionBlock
{
    LoadDataWithASI *loadData = [[LoadDataWithASI alloc] init];
    loadData.completionBlock = completionBlock;
    loadData.paths = rolePaths;
    loadData.types = types;
    
    //加密
    NLpublic *encrypt = [[NLpublic new] autorelease];
    //格式化
    NLpublic *format = [[NLpublic new] autorelease];
    
    NSData *bodyData = [encrypt encrypt:[format msgbody:msgbody api_name:apiName api_name_func:apiNameFunc]];
    
    //数据请求
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:SERVER_URL]];
    [request setDelegate:loadData];
    [request setNumberOfTimesToRetryOnTimeout:10];
    
    [request setRequestMethod:@"POST"];
    //加入body
    [request appendPostData: bodyData];
    [request startAsynchronous];
}

#pragma mark - ASIHTTPRequestDelegate
//请求成功
- (void)requestFinished:(ASIHTTPRequest *)request
{
    id msg = nil;
    
    if (![[request responseString] isEqualToString:@""])
    {
        //解密
        NLpublic *decrypt = [[NLpublic new] autorelease];
        //解析
        NLpublic *analysis = [[NLpublic new] autorelease];
        
        NSString *temp3 = [[decrypt decrypt:[request responseString]] stringByReplacingOccurrencesOfString:@"&" withString:@""];
        
        if (self.paths)
        {
            NSMutableArray *msgs = [NSMutableArray array];
            
            for (int i = 0; i < self.paths.count; i++)
            {
                //当前类型
                PublicType currentType = [self.types[i] intValue];
                
                [msgs addObject:[analysis xml_TO_dictionary:[temp3 dataUsingEncoding:NSUTF8StringEncoding] rolePath:self.paths[i] type:currentType]];
            }
            
            msg = msgs;
        }
        else
        {
            msg = [analysis xml_TO_dictionary:[temp3 dataUsingEncoding: NSUTF8StringEncoding] rolePath:self.rolePath type:self.currentType];
        }
        
        NSLog(@"requestFinished  %@",temp3);
        NSLog(@"获取到的数据为：  %@",msg);
    }
    
    if (self.completionBlock)
    {
        self.completionBlock(msg, nil);
    }
    
    Release(self);
}

//请求失败
- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    
    if (self.completionBlock)
    {
        self.completionBlock(nil, error);
    }
    
    Release(self);
}

- (void)dealloc
{
    Release(self.completionBlock);
    self.rolePath = nil;
    
    [super dealloc];
}

@end












