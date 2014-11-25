//
//  NLProtocolRegister.h
//  TongFubao
//
//  Created by MD313 on 13-8-17.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProtocolDefine.h"
#import "NLProtocolRequest.h"

@interface NLProtocolRegister : NSObject

+(id)shareProtocolRegister;
-(BOOL)registRequest:(NLProtocolRequestType)type;
-(BOOL)unRegistRequest:(NLProtocolRequestType)type;

@end
