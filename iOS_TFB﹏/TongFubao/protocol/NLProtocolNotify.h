//
//  NLProtocolNotify.h
//  TongFubao
//
//  Created by MD313 on 13-8-16.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProtocolDefine.h"

@protocol NLProtocolRequestDelegate;

@interface NLProtocolNotify : NSObject

+(id)shareProtocolNotify;
-(void)addNotify:(NLProtocolRequestType)type;

@end
