//
//  TFBANetworkRequests.m
//  TongFubao
//
//  Created by kin on 14/12/2.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "TFBANetworkRequests.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
static TFBANetworkRequests *NetworkRequests = nil;
@implementation TFBANetworkRequests

+ (TFBANetworkRequests *)stardowlop
{
    @synchronized(self)
    {
        if (nil == NetworkRequests)
        {
            NetworkRequests = [[TFBANetworkRequests allocWithZone:NULL] init];
        }
    }
    return NetworkRequests;
}
+(id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (NetworkRequests==nil)
        {
            NetworkRequests=[super allocWithZone:zone];
        }
    }
    return NetworkRequests;
}
-(id)copy{
    return self;
}
-(id)init{
    @synchronized(self)
    {
        self = [super init];
        if (self) {
    
            [[TFBANetworkRequests stardowlop] TongFuBaoNetworkRequestsAPIParametername:            [NSString stringWithFormat:@"ProjectNewList?OrderType=%@&PageIndex=%@&IsFnc=%@&PageSize=%@&AppId=%@",@"1",@"1",@"true",@"5",@"WHAN"]];
        }

        return self;
    }
}

-(NSDictionary *)TongFuBaoNetworkRequestsAPIParametername:(NSString *)newAPIParametername
{
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:SERVER_URL]];
    request.delegate=self;
    [request startAsynchronous];
    while (request != nil && ![request isFinished])
    {
        
    }
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:nil];
//    NSData *jsonSerData = [NSJSONSerialization dataWithJSONObject:[request responseString] options:NSJSONWritingPrettyPrinted error:nil];
//    NSString *jsonString =[[NSString alloc] initWithData:jsonSerData encoding:NSUTF8StringEncoding];
//    NSArray * jsonArray = [[request responseString] JSONValue];
//    NSLog(@"=====jsonArray=====%@",jsonArray);
    
    return jsonDic;
}

@end
