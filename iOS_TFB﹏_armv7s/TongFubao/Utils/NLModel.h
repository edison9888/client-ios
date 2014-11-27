//
//  NLModel.h
//  TongFubao
//
//  Created by 〝Cow﹏.   on 14-11-19.
//  Copyright (c) 2014年 〝Cow﹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NLModel : NSObject

/*代理商分润数据*/
/*总收益*/
+(void)settotalfenrun:(NSString*)totalfenrun;
/*功能id*/
+(void)setappfunid:(NSString*)appfunid;
/*收益功能名*/
+(void)setappfunname:(NSString*)appfunname;
/*收益金额*/
+(void)setallfenrun:(NSString*)allfenrun;

+(NSString*)gettotalfenrun;
+(NSString*)getappfunid;
+(NSString*)getappfunname;
+(NSString*)getallfenrun;

@end
