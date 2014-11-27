//
//  NLModel.m
//  TongFubao
//
//  Created by 〝Cow﹏.   on 14-11-19.
//  Copyright (c) 2014年 〝Cow﹏. All rights reserved.
//

#import "NLModel.h"

/*代理商分润数据*/
static NSString* NLtotalfenrun      = @"";
static NSString* NLappfunid         = @"";
static NSString* NLappfunname       = @"";
static NSString* NLallfenrun        = @"";

@implementation NLModel

/*代理商分润数据*/
/*总收益*/
+(void)settotalfenrun:(NSString*)totalfenrun
{
    totalfenrun = NLtotalfenrun;
}
/*功能id*/
+(void)setappfunid:(NSString*)appfunid
{
    appfunid = NLappfunid;
}
/*收益功能名*/
+(void)setappfunname:(NSString*)appfunname
{
    appfunname= NLappfunname;
}
/*收益金额*/
+(void)setallfenrun:(NSString*)allfenrun{
    allfenrun = NLallfenrun;
}

+(NSString*)gettotalfenrun
{
    return NLtotalfenrun;
}
+(NSString*)getappfunid
{
    return NLappfunid;
}
+(NSString*)getappfunname
{
     return NLappfunname;
}
+(NSString*)getallfenrun
{
    return NLallfenrun;
}


@end
