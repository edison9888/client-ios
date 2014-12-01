//
//  AirPlayPaixuObject.h
//  TongFubao
//
//  Created by kin on 14-9-1.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AirPlayPaixuObject : NSObject

// 从早到晚，从晚到早升降序方法
-(NSMutableArray *)timePaiXiuDescending:(NSMutableArray *)newTimePaiXiu timeTager:(NSInteger)timeTager;

// 价格排序方法
-(NSMutableArray *)pricePaiXiuDescending:(NSMutableArray *)newPricePaiXiu priceTager:(NSInteger)newPriceTager;

// 航空公司
-(NSMutableArray *)airLineNamePaiXiuDescending:(NSMutableArray *)newairLineNamePaiXiu airCode:(NSString *)newairCode;

// 时间段排序
-(NSMutableArray *)pmTimePaiXiuDescending:(NSMutableArray *)newPmTimePaiXiu timeTager:(NSInteger)timeTager;




@end
