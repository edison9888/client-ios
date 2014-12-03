//
//  FlightData.m
//  TongFubao
//
//  Created by kin on 14-8-22.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "FlightData.h"
@implementation FlightData

@synthesize HotCityArray,logoString,CityName,buttonTeger,cityCodeArray,cityIdArray;

-(id)init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}
-(void)CitytToFindTheNetworkRequest:(NSString *)newfirstLetter requestCityName:(NSString *)newCityName buttonTag:(NSInteger)newTag
{
//    NSLog(@"====newfirstLetter=====%@",newfirstLetter);
    self.CityName  = newCityName;
    self.logoString = newfirstLetter;
    self.buttonTeger = newTag;
    
    NSString *_notifyName = [NLUtils getNameForRequest:Notify_ApiAirticket];
    REGISTER_NOTIFY_OBSERVER(self, getCitytRequest, _notifyName);
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApiAirticket:newfirstLetter cityName:newCityName];
}

-(void)getCitytRequest:(NSNotification *)senderFication
{
    NLProtocolResponse *response = (NLProtocolResponse *)senderFication.object;
    int error = response.errcode;
    
    if (error == RSP_NO_ERROR)
    {
        [self getDataWithCity:response];
        
    }
    else if (error == RSP_TIMEOUT)
    {
        return ;
    }
    else
    {
        NSString *string = response.detail;
//        NSLog(@"====string=====%@",string);
        
    }
}

- (void)getDataWithCity:(NLProtocolResponse *)response
{
    //获取数据标记，判断是否请求成功
    NLProtocolData *data = [response.data find:@"msgbody/result" index:0];
    NSString *result = data.value;
    NSRange range = [result rangeOfString:@"succ"];
    
    if (range.length <= 0)
    {
        //获取错误信息
        NLProtocolData *errorData = [response.data find:@"msgbody/message" index:0];
        NSLog(@"errorData = %@",errorData);
    }
    else
    {
        self.HotCityArray = [response.data find:@"msgbody/msgchild/cityNameCh"];
        self.cityCodeArray = [response.data find:@"msgbody/msgchild/cityCode"];
        self.cityIdArray = [response.data find:@"msgbody/msgchild/cityId"];
        
        
        
        [self.flightDataDelegate getDataWithArray:self.HotCityArray oldLogoString:self.logoString requestCityName:self.CityName buttonTag:self.buttonTeger cityCodeArray:self.cityCodeArray   cityIdArray:self.cityIdArray];
        
        
        //        NSLog(@"===========%@========",self.cityCodeArray);
        //        for (NLProtocolData *da in self.cityCodeArray)
        //        {
        //            NSLog(@"================da======== %@",da.value);
        //        }
        
    }
    
}






@end





















