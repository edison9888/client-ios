//
//  TFBANetworkRequests.h
//  TongFubao
//
//  Created by kin on 14/12/2.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
@interface TFBANetworkRequests : NSObject<ASIHTTPRequestDelegate>


-(NSDictionary *)TongFuBaoNetworkRequestsAPIParametername:(NSString *)newAPIParametername;

@end
