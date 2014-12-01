//
//  watchTimeObject.m
//  TongFubao
//
//  Created by kin on 14-8-15.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "watchTimeObject.h"

@implementation watchTimeObject

+(NSString *)changeTime
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormat stringFromDate:[NSDate date]];
    return dateString;
}
+(NSString *)returnaddTime:(NSString *)newTime number:(int)newnumber;
{
    //天的时间
    NSTimeInterval secondsper=24*60*60*newnumber;
    //当前的时间 减去多少天的时间
    NSDate *shijian=[[NSDate alloc]initWithTimeIntervalSinceNow:+secondsper];

    //时间格式
    NSDateFormatter *dateformat=[[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"yyyy-MM-dd"];
    
//    NSDate *date =[dateformat dateFromString:newTime];
//    NSDate *shijian=[date initWithTimeIntervalSinceNow:+secondsper];
//    NSLog(@"====shijian====%@",shijian);


    //当前的时间格式
    NSString * newDateOne = [dateformat stringFromDate:shijian];
    NSLog(@"====newDateOne====%@",newDateOne);
    return newDateOne;
    
}

+(NSString *)selectionTime:(NSString *)nowselectionTime
{
    NSString *reurnday;
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式,这里可以设置成自己需要的格式
    NSDate *date =[dateFormat dateFromString:nowselectionTime];
    
    NSLog(@"+++++++++++++%@",date);
    NSTimeInterval terval=[date timeIntervalSince1970];
    NSCalendar *cal=[NSCalendar currentCalendar];
    NSDate *today=[NSDate dateWithTimeIntervalSince1970:terval];
    NSDate *todayt=[NSDate date];
    unsigned int uintFlag=NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit;
    NSDateComponents *gap=[cal components:uintFlag fromDate:todayt toDate:today options:0];
    NSLog(@"+++++===gap====+++++%@",gap);

    if (ABS([gap day])>0) {
        reurnday=[NSString stringWithFormat:@"%d",ABS([gap day])];
        NSLog(@"======day======%@",reurnday);
    }  else if (ABS([gap hour])>0) {
        NSString *hour=[NSString stringWithFormat:@"%d小时前",ABS([gap hour])];
        NSLog(@"======hour======%@",hour);
    }else{
        NSString *miuter=[NSString stringWithFormat:@"%d分钟",ABS([gap minute])];
        NSLog(@"======hour======%@",miuter);
    }
    return reurnday;
}

@end


@implementation watchMoneyTimeObject

+(NSString *)changeTime
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM"];
    NSString *dateString = [dateFormat stringFromDate:[NSDate date]];
    return dateString;
}

+(NSString *)returnaddTime:(NSString *)newTime number:(int)newnumber;
{
    //天的时间
    NSTimeInterval secondsper=24*60*newnumber;
    //当前的时间 减去多少天的时间
    NSDate *shijian=[[NSDate alloc]initWithTimeIntervalSinceNow:+secondsper];
    //时间格式
    NSDateFormatter *dateformat=[[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"yyyy-MM"];
    //当前的时间格式
    NSString * newDateOne = [dateformat stringFromDate:shijian];
    NSLog(@"====newDateOne====%@",newDateOne);
    return newDateOne;
    
}

+(NSString *)selectionTime:(NSString *)nowselectionTime
{
    NSString *reurnday;
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM"];//设定时间格式,这里可以设置成自己需要的格式
    NSDate *date =[dateFormat dateFromString:nowselectionTime];
    
    NSLog(@"+++++++++++++%@",date);
    NSTimeInterval terval=[date timeIntervalSince1970];
    NSCalendar *cal=[NSCalendar currentCalendar];
    NSDate *today=[NSDate dateWithTimeIntervalSince1970:terval];
    NSDate *todayt=[NSDate date];
    unsigned int uintFlag=NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit;
    NSDateComponents *gap=[cal components:uintFlag fromDate:todayt toDate:today options:0];
    if (ABS([gap day])>0) {
        reurnday=[NSString stringWithFormat:@"%d",ABS([gap day])];
        NSLog(@"======day======%@",reurnday);
    }  else if (ABS([gap hour])>0) {
        NSString *hour=[NSString stringWithFormat:@"%d小时前",ABS([gap hour])];
        NSLog(@"======hour======%@",hour);
    }else{
        NSString *miuter=[NSString stringWithFormat:@"%d分钟",ABS([gap minute])];
        NSLog(@"======hour======%@",miuter);
    }
    return reurnday;
}

@end













