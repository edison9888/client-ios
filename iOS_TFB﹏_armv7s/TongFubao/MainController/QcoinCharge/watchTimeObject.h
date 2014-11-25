//
//  watchTimeObject.h
//  TongFubao
//
//  Created by kin on 14-8-15.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface watchTimeObject : NSObject

+(NSString *)changeTime;
+(NSString *)returnaddTime:(NSString *)newTime number:(int)newnumber;
+(NSString *)selectionTime:(NSString *)nowselectionTime;

@end

@interface watchMoneyTimeObject : NSObject

+(NSString *)changeTime;
+(NSString *)returnaddTime:(NSString *)newTime number:(int)newnumber;
+(NSString *)selectionTime:(NSString *)nowselectionTime;

@end