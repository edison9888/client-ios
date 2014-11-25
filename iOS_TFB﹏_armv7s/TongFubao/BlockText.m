//
//  BlockText.m
//  TongFubao
//
//  Created by  俊   on 14-6-26.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "BlockText.h"

#define text1block 1
#define text2block 2

@implementation BlockText

-(void)textFailWithError:(NSString*)error tag:(long)tag{
    
    switch (tag) {
        case text1block:
            if (_blocktextinthetfb) {
                _blocktextinthetfb(nil,error);
            }
            break;
        case text2block:
            if (_blocktextinthetfb) {
                _blocktextinthetfb(nil,error);
            }
            break;
        default:
            break;
    }
    
}

-(void)readAuthorInfoPeople
{
    NSString* name = [NLUtils getNameForRequest:Notify_readAuthorInfo];
    REGISTER_NOTIFY_OBSERVER(self, readAuthorInfoPeopleNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] readAuthorInfo];
}

-(void)readAuthorInfoPeopleNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
              [self doreadAuthorInfoPeopleNotify:response];
    }
}

-(void)doreadAuthorInfoPeopleNotify:(NLProtocolResponse*)response
{
    NLProtocolData* data = [response.data find:@"msgbody/result" index:0];
    
    NSString *result = data.value;
    
    NSRange range = [result rangeOfString:@"succ"];
    
    if (range.length <= 0)
    {
        NLProtocolData* data = [response.data find:@"msgbody/message" index:0];
        
        NSString* value = data.value;
        
        if ([self respondsToSelector:@selector(textFailWithError:tag:)]) {
            [self textFailWithError:value tag:1];
        }
    }
    else
    {
        
    }
}




@end
