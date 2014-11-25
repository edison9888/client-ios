//
//  OrderInstance.h
//  TongFubao
//
//  Created by 〝Cow﹏. on 14-9-1.
//  Copyright (c) 2014年 〝Cow﹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Meal.h"
@interface OrderInstance : NSObject
@property(strong,nonatomic)NSMutableArray *orderArr;
+ (OrderInstance *) sharedInstance;
-(void)addOrder:(Meal *)meal;
-(void)deleOrder:(Meal *)meal;
-(void)addNum:(int)index;
-(void)subNum:(int)index;
-(int)gettotalMealCount;
-(BOOL)hasOredr:(int)mid;
-(float)getTotalPrice;
@end
