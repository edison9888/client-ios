//
//  OrderInstance.m
//  TongFubao
//
//  Created by 〝Cow﹏. on 14-9-1.
//  Copyright (c) 2014年 〝Cow﹏. All rights reserved.
//

#import "OrderInstance.h"

@implementation OrderInstance
static OrderInstance *instance=nil;
+ (OrderInstance *) sharedInstance  //第二步：实例构造检查静态实例是否为nil
{
    @synchronized (self)
    {
        if (instance == nil)
        {
            instance =[[OrderInstance alloc] init];
            instance.orderArr=[NSMutableArray arrayWithCapacity:0];
        }
    }
    return instance;
}
-(void)addOrder:(Meal *)meal
{
    
    if (instance)
    {
        BOOL has=NO;
        for (int i=0; i<[instance.orderArr count]; i++) {
            Meal *o=[instance.orderArr objectAtIndex:i];
            //若含有选择的订单 则数量加1
            if (o.mId==meal.mId) {
                [self addNum:i];
                has=YES;
            }
        }
        if (!has) {
            [instance.orderArr addObject:meal];
        }
        
    }
    
}
-(void)deleOrder:(Meal *)meal
{
    if (instance)
    {
        if ([instance.orderArr containsObject:meal]) {
            [instance.orderArr removeObject:meal];
        }
    
    }
    
    
}
-(void)addNum:(int)index{
    if (instance) {
        Meal *meal=[instance.orderArr objectAtIndex:index];
        meal.num++;
        [instance.orderArr replaceObjectAtIndex:index withObject:meal];
    }
    
}
-(void)subNum:(int)index{
    if (instance) {
        Meal *meal=[instance.orderArr objectAtIndex:index];
        meal.num--;
        if (meal.num<1) {
            meal.num=1;
        }
        [instance.orderArr replaceObjectAtIndex:index withObject:meal];
    }
    
}
-(int)gettotalMealCount{
    int num=0;
    for (int i=0; i<[instance.orderArr count]; i++) {
        Meal *o=[instance.orderArr objectAtIndex:i];
        num=num+o.num;
    }
    return num;
}
-(BOOL)hasOredr:(int)mid{
    BOOL has=NO;
    for (int i=0; i<[instance.orderArr count]; i++) {
        Meal *o=[instance.orderArr objectAtIndex:i];
        //若含有选择的订单 则数量加1
        if ([o.mId intValue]==mid) {
            has=YES;
        }
    }
    
    return has;
    
}
-(float)getTotalPrice{
    float price=0.0;
    for (int i=0; i<[instance.orderArr count]; i++) {
        Meal *order=[[OrderInstance sharedInstance].orderArr objectAtIndex:i];
        price=price+[order.price floatValue]*order.num;
    }
    return price;
}

@end
