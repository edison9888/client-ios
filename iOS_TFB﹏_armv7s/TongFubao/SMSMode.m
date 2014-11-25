//
//  SMSMode.m
//  TongFubao
//
//  Created by 湘郎 on 14-11-17.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "SMSMode.h"

@implementation SMSMode


+ (SMSMode*)useWithDictionary:(NSDictionary*)dic
{
    SMSMode *user;
    user = [[SMSMode alloc] initWithDictionary:dic];
    return user;
}



- (SMSMode*)initWithDictionary:(NSDictionary*)dic
{
	self = [super init];
    
    [self updateWithDictionary:dic];
	
	return self;
}

- (void)updateWithDictionary:(NSDictionary*)dic
{
    self.historyPhone = [dic objectForKey:@"fumobile"];
    self.historyDate = [dic objectForKey:@"smsrdate"];
    self.historyMoney = [dic objectForKey:@"money"];
    self.historyState = [dic objectForKey:@"smsrstate"];
    
}


@end
