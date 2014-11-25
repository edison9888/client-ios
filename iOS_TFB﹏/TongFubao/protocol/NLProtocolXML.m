//
//  NLProtocolXML.m
//  TongFubao
//
//  Created by MD313 on 13-8-16.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLProtocolXML.h"
#include "NLProtocolData.h"
#import "NLPlistOper.h"
#import "NLContants.h"
#import "NLUtils.h"

static NLProtocolXML* gProtocolXML = nil;

@implementation NLProtocolXML

+(id)shareProtocolXML
{
    if (gProtocolXML == nil)
    {
        gProtocolXML=[[NLProtocolXML alloc] init];
    }
    return gProtocolXML;
}

//数据每次请求都进来
-(NLProtocolData*)defaultMsgheader
{
    NLProtocolData* header = [[NLProtocolData alloc] initValue:nil
                                                    forKey:@"msgheader"
                                                      attr:TFBVersion
                                                  attrName:@"version"
                                                 valueType:NLProtocolDataValueNoCData];
    //NSLog(@"加密前的heard%@",header);
    [header addChild:[[NLProtocolData alloc] initValue:[NLUtils get_req_token]//加密数据传输
                      
                                              forKey:@"req_token"
                                                attr:nil
                                            attrName:nil
                                           valueType:NLProtocolDataValueNoCData]];
    [header addChild:[[NLProtocolData alloc] initValue:TFBVersion
                                                forKey:@"req_version"
                                                  attr:nil
                                              attrName:nil
                                             valueType:NLProtocolDataValueNoCData]];
    //NSLog(@"加密后的heard%@",header);
    [header addChild:[[NLProtocolData alloc] initValue:[NLUtils get_req_bkenv]
                                                forKey:@"req_bkenv"
                                                  attr:nil
                                              attrName:nil
                                             valueType:NLProtocolDataValueNoCData]];
    
    [header addChild:[[NLProtocolData alloc] initValue:[NLUtils get_au_token]
                                                forKey:@"au_token"
                                                  attr:nil
                                              attrName:nil
                                             valueType:NLProtocolDataValueNoCData]];
    [header addChild:[[NLProtocolData alloc] initValue:[NLUtils get_req_time]
                                              forKey:@"req_time"
                                                attr:nil
                                            attrName:nil
                                           valueType:NLProtocolDataValueNoCData]];
    [header addChild:[[NLProtocolData alloc] initValue:@"3"
                                                forKey:@"req_appenv"
                                                  attr:nil
                                              attrName:nil
                                             valueType:NLProtocolDataValueNoCData]];
    
    
    return header;
}

-(NLProtocolData*)defaultAuthorIDMsgheader
{
    NLProtocolData* header = [[NLProtocolData alloc] initValue:nil
                                                        forKey:@"msgheader"
                                                          attr:TFBVersion
                                                      attrName:@"version"
                                                     valueType:NLProtocolDataValueNoCData];
    //NSLog(@"加密前的heard%@",header);
    [header addChild:[[NLProtocolData alloc] initValue:[NLUtils get_req_token]//加密数据传输
                      
                                                forKey:@"req_token"
                                                  attr:nil
                                              attrName:nil
                                             valueType:NLProtocolDataValueNoCData]];
    [header addChild:[[NLProtocolData alloc] initValue:TFBVersion
                                                forKey:@"req_version"
                                                  attr:nil
                                              attrName:nil
                                             valueType:NLProtocolDataValueNoCData]];
    //NSLog(@"加密后的heard%@",header);
    [header addChild:[[NLProtocolData alloc] initValue:[NLUtils get_req_bkenv]
                                                forKey:@"req_bkenv"
                                                  attr:nil
                                              attrName:nil
                                             valueType:NLProtocolDataValueNoCData]];
    
    [header addChild:[[NLProtocolData alloc] initValue:[NLUtils get_au_token]
                                                forKey:@"au_token"
                                                  attr:nil
                                              attrName:nil
                                             valueType:NLProtocolDataValueNoCData]];
    
    [header addChild:[[NLProtocolData alloc] initValue:[NLUtils getAuthorid]
                                                forKey:@"authorid"
                                                  attr:nil
                                              attrName:nil
                                             valueType:NLProtocolDataValueNoCData]];
    
    [header addChild:[[NLProtocolData alloc] initValue:[NLUtils get_req_time]
                                                forKey:@"req_time"
                                                  attr:nil
                                              attrName:nil
                                             valueType:NLProtocolDataValueNoCData]];
    [header addChild:[[NLProtocolData alloc] initValue:@"3"
                                                forKey:@"req_appenv"
                                                  attr:nil
                                              attrName:nil
                                             valueType:NLProtocolDataValueNoCData]];
    
    
    return header;
}



-(NLProtocolData*)defaultChannelinfo:(BOOL)author
                       api_name_func:(NSString*)api_name_func
                            api_name:(NSString*)api_name
{
    NLProtocolData* info = [[NLProtocolData alloc] initValue:nil
                                                        forKey:@"channelinfo"
                                                          attr:nil
                                                      attrName:nil
                                                     valueType:NLProtocolDataValueNoCData];
    NSString* authorid = nil;
    if (author)
    {
        authorid = [NLUtils getAuthorid];
    }
    
    [info addChild:[[NLProtocolData alloc] initValue:authorid
                                                forKey:@"authorid"
                                                  attr:nil
                                              attrName:nil
                                             valueType:NLProtocolDataValueNoCData]];
    
    
    /*** madfrog add 6.20***/
    NSString *agentid = [NLUtils getAgentid];
    if (agentid.length>0&&![agentid  isEqualToString:@"0"]) {
        [info addChild:[[NLProtocolData alloc] initValue:agentid
                                                  forKey:@"agentid"
                                                    attr:nil
                                                attrName:nil
                                               valueType:NLProtocolDataValueNoCData]];

    }
    /*** madfrog add 6.20***/
    [info addChild:[[NLProtocolData alloc] initValue:api_name_func
                                                forKey:@"api_name_func"
                                                  attr:nil
                                              attrName:nil
                                             valueType:NLProtocolDataValueNoCData]];
    [info addChild:[[NLProtocolData alloc] initValue:api_name
                                                forKey:@"api_name"
                                                  attr:nil
                                              attrName:nil
                                             valueType:NLProtocolDataValueNoCData]];
    return info;
}

//用户注册短信校验码获取
-(NLProtocolData*)getSmsCodeXML:(NSString*)mobile
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:NO
                                api_name_func:@"getSmsCode"
                                     api_name:@"ApiAuthorReg"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                  forKey:@"msgbody"
                                                                    attr:nil
                                                                attrName:nil
                                                               valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:mobile
                                               forKey:@"smsmobile"
                                                 attr:nil
                                             attrName:nil
                                            valueType:NLProtocolDataValueNoCData]];
    return pd;

}

//用户注册短信校验成功后注册资料登记
-(NLProtocolData*)authorRegXML:(NSString*)mobile password:(NSString*)password name:(NSString*)name idCard:(NSString*)idCard email:(NSString*)email
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                  attr:nil
                                              attrName:nil
                                             valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"authorReg"
                                     api_name:@"ApiAuthorReg"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                  forKey:@"msgbody"
                                                                    attr:nil
                                                                attrName:nil
                                                               valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:mobile
                                              forKey:@"aumobile"
                                                attr:nil
                                            attrName:nil
                                           valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:password
                                              forKey:@"aupassword"
                                                attr:nil
                                            attrName:nil
                                           valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:name
                                              forKey:@"autruename"
                                                attr:nil
                                            attrName:nil
                                           valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:idCard
                                              forKey:@"auidcard"
                                                attr:nil
                                            attrName:nil
                                           valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:email
                                                forKey:@"auemail"
                                                  attr:nil
                                              attrName:nil
                                             valueType:NLProtocolDataValueNoCData]];
    
    return pd;

}

//用户密码修改
-(NLProtocolData*)authorPwdModifyXML:(NSString*)oldPW newPW:(NSString*)newPW type:(NSString*)type reset:(NSString*)reset
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                  attr:nil
                                              attrName:nil
                                             valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"authorPwdModify"
                                     api_name:@"ApiAuthorInfoV2"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                  forKey:@"msgbody"
                                                                    attr:nil
                                                                attrName:nil
                                                               valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:oldPW
                                               forKey:@"auoldpwd"
                                                 attr:nil
                                             attrName:nil
                                            valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:newPW
                                               forKey:@"aunewpwd"
                                                 attr:nil
                                             attrName:nil
                                            valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:type
                                               forKey:@"aumoditype"
                                                 attr:nil
                                             attrName:nil
                                            valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:reset
                                                 forKey:@"reset"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
 
}

//用户意见反馈
-(NLProtocolData*)authorFeedbckXML:(NSString*)content contact:(NSString*)contact
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"authorFeedbck"
                                     api_name:@"ApiAuthorfeedbck"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:content
                                                 forKey:@"fdcontent"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:contact
                                                 forKey:@"fdlinkmethod"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
}

// 版本更新
-(NLProtocolData*)checkAppVersionXML:(NSString*)type version:(NSString*)version
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"checkAppVersion"
                                     api_name:@"ApiAppInfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:type
                                                 forKey:@"apptype"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:version
                                                 forKey:@"appversion"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
}

// 读取用户信息
-(NLProtocolData*)readAuthorInfoXML
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"readAuthorInfo"
                                     api_name:@"ApiAuthorInfo"]];
    
    //operation_request/msgbody
    [pd addChild:[[NLProtocolData alloc] initValue:nil
                                            forKey:@"msgbody"
                                              attr:nil
                                          attrName:nil
                                         valueType:NLProtocolDataValueNoCData]];
    return pd;
}

-(NLProtocolData*)modifyAuthorInfoXML:(NSString*)name idCard:(NSString*)idCard email:(NSString*)email agentcompany:(NSString*)agentcompany agentarea:(NSString*)agentarea  agentaddress:(NSString*)agentaddress agentmanphone:(NSString*)agentmanphone agentfax:(NSString*)agentfax
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"modifyAuthorInfo"
                                     api_name:@"ApiAuthorInfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:name
                                                 forKey:@"autruename"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:idCard
                                                 forKey:@"auidcard"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:email
                                                 forKey:@"auemail"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    //代理商的
    [msgbody addChild:[[NLProtocolData alloc] initValue:agentcompany
                                                 forKey:@"agentcompany"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:agentarea
                                                 forKey:@"agentarea"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];

    [msgbody addChild:[[NLProtocolData alloc] initValue:agentaddress
                                                 forKey:@"agentaddress"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:agentmanphone
                                                 forKey:@"agentmanphone"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:agentfax
                                                 forKey:@"agentfax"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    return pd;
}

-(NLProtocolData*)uploadAuthorPicXML:(NSString*)picid picpath:(NSString*)picpath uploadmethod:(NSString*)uploadmethod uploadpictype:(NSString*)uploadpictype uploadmark:(NSString*)uploadmark
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"uploadAuthorPic"
                                     api_name:@"ApiAuthorInfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:picid
                                                 forKey:@"picid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:picpath
                                                 forKey:@"picpath"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:uploadmethod
                                                 forKey:@"uploadmethod"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:uploadpictype
                                                 forKey:@"uploadpictype"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:uploadmark
                                                 forKey:@"uploadmark"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
}

-(NLProtocolData*)checkAuthorLoginXML:(NSString*)userName password:(NSString*)password auloginmethod:(NSString*)auloginmethod mpmodel:(NSString*)mpmodel
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"checkAuthorLogin"
                                     api_name:@"ApiAuthorInfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:userName
                                                 forKey:@"aumobile"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:password
                                                 forKey:@"aupwd"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:auloginmethod
                                                 forKey:@"auloginmethod"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:mpmodel
                                                 forKey:@"mpmodel"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
}

-(NLProtocolData*)getSmsCodeInfoXML:(NSString*)mobile
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"getSmsCode"
                                     api_name:@"ApiAuthorInfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:mobile
                                                 forKey:@"smsmobile"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
}

-(NLProtocolData*)forgetPwdModifyXML:(NSString*)aumobile aunewpwd:(NSString*)aunewpwd aurenewpwd:(NSString*)aurenewpwd  aumoditype:(NSString*)aumoditype
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"forgetPwdModify"
                                     api_name:@"ApiAuthorInfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:aumobile
                                                 forKey:@"aumobile"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:aunewpwd
                                                 forKey:@"aunewpwd"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:aurenewpwd
                                                 forKey:@"aurenewpwd"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:aumoditype
                                                 forKey:@"aumoditype"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
}

-(NLProtocolData*)readHelpListXML:(NSString*)start display:(NSString*)display
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"readHelpList"
                                     api_name:@"ApiAppHelpinfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:start
                                                 forKey:@"msgstart"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:display
                                                 forKey:@"msgdisplay"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
}

-(NLProtocolData*)readMyAccountXML
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"readMyAccount"
                                     api_name:@"ApiAppAccountInfo"]];
    
    //operation_request/msgbody
    [pd addChild:[[NLProtocolData alloc] initValue:nil
                                            forKey:@"msgbody"
                                              attr:nil
                                          attrName:nil
                                         valueType:NLProtocolDataValueNoCData]];
    return pd;

}

-(NLProtocolData*)readAccglistXML:(NSString*)acctypeid
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"readAccglist"
                                     api_name:@"ApiAppAccountInfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:acctypeid
                                                 forKey:@"acctypeid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
}

-(NLProtocolData*)readAccglistdetailXML:(NSString*)acctypeid month:(NSString*)month
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"readAccglistdetail"
                                     api_name:@"ApiAppAccountInfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:acctypeid
                                                 forKey:@"acctypeid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:month
                                                 forKey:@"accmonth"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
}

-(NLProtocolData*)getSmsVerifyCodeXML:(NSString*)mobile
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"getSmsCode"
                                     api_name:@"ApiSendSms"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:mobile
                                                 forKey:@"smsmobile"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
}

-(NLProtocolData*)readCreditCardfeeXML:(NSString*)type amount:(NSString*)amount bankID:(NSString*)bankID cardID:(NSString*)cardID
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"readCreditCardfee"
                                     api_name:@"ApiPayinfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:type
                                                 forKey:@"paytype"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:amount
                                                 forKey:@"paymoney"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:bankID
                                                 forKey:@"paybankid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:cardID
                                                 forKey:@"paycardid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
}

-(NLProtocolData*)insertcreditCardMoneyXML:(NSString*)bkntno result:(NSString*)result
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"insertcreditCardMoney"
                                     api_name:@"ApiPayinfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:bkntno
                                                 forKey:@"bkntno"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:result
                                                 forKey:@"result"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
}

-(NLProtocolData*)readCreditCardglistXML:(NSString*)paytype msgstart:(NSString*)msgstart msgdisplay:(NSString*)msgdisplay
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header = [self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"readCreditCardglist"
                                     api_name:@"ApiPayinfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:paytype
                                                 forKey:@"paytype"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:msgstart
                                                 forKey:@"msgstart"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:msgdisplay
                                                 forKey:@"msgdisplay"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;

}

-(NLProtocolData*)creditCardMoneyRqXML:(NSString*)paytype paymoney:(NSString*)paymoney shoucardno:(NSString*)shoucardno shoucardmobile:(NSString*)shoucardmobile shoucardman:(NSString*)shoucardman shoucardbank:(NSString*)shoucardbank fucardno:(NSString*)fucardno fucardbank:(NSString*)fucardbank fucardmobile:(NSString*)fucardmobile fucardman:(NSString*)fucardman current:(NSString*)current paycardid:(NSString*)paycardid merReserved:(NSString*)merReserved
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header = [self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"creditCardMoneyRq"
                                     api_name:@"ApiPayinfo"]];    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:paytype
                                                 forKey:@"paytype"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:paymoney
                                                 forKey:@"paymoney"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:shoucardno
                                                 forKey:@"shoucardno"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:shoucardmobile
                                                 forKey:@"shoucardmobile"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:shoucardman
                                                 forKey:@"shoucardman"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:shoucardbank
                                                 forKey:@"shoucardbank"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:fucardno
                                                 forKey:@"fucardno"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:fucardbank
                                                 forKey:@"fucardbank"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:fucardmobile
                                                 forKey:@"fucardmobile"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:fucardman
                                                 forKey:@"fucardman"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:current
                                                 forKey:@"current"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:paycardid
                                                 forKey:@"paycardid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:merReserved
                                                 forKey:@"merReserved"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
}

-(NLProtocolData*)readTransferMoneyfeeXML:(NSString*)paytype paymoney:(NSString*)paymoney paybankid:(NSString*)paybankid paycardid:(NSString*)paycardid
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"readTransferMoneyfee"
                                     api_name:@"ApiPayinfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:paytype
                                                 forKey:@"paytype"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:paymoney
                                                 forKey:@"paymoney"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:paybankid
                                                 forKey:@"paybankid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:paycardid
                                                 forKey:@"paycardid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
}

-(NLProtocolData*)insertTransferMoneyXML:(NSString*)bkntno result:(NSString*)result
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"insertTransferMoney"
                                     api_name:@"ApiPayinfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:bkntno
                                                 forKey:@"bkntno"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:result
                                                 forKey:@"result"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
}

-(NLProtocolData*)readTransferMoneyglistXML:(NSString*)paytype msgstart:(NSString*)msgstart msgdisplay:(NSString*)msgdisplay
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"readTransferMoneyglist"
                                     api_name:@"ApiPayinfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:paytype
                                                 forKey:@"paytype"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:msgstart
                                                 forKey:@"msgstart"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:msgdisplay
                                                 forKey:@"msgdisplay"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
}

-(NLProtocolData*)transferMoneyRqXML:(NSString*)paycardid fucardno:(NSString*)fucardno fucardbank:(NSString*)fucardbank fucardman:(NSString*)fucardman fucardmobile:(NSString*)fucardmobile shoucardno:(NSString*)shoucardno shoucardbank:(NSString*)shoucardbank current:(NSString*)current paymoney:(NSString*)paymoney payfee:(NSString*)payfee money:(NSString*)money shoucardmobile:(NSString*)shoucardmobile shoucardman:(NSString*)shoucardman arriveid:(NSString*)arriveid shoucardmemo:(NSString*)shoucardmemo sendsms:(NSString*)sendsms merReserved:(NSString*)merReserved
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"transferMoneyRq"
                                     api_name:@"ApiPayinfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:paycardid
                                                 forKey:@"paycardid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:fucardno
                                                 forKey:@"fucardno"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:fucardbank
                                                 forKey:@"fucardbank"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];    
    [msgbody addChild:[[NLProtocolData alloc] initValue:fucardman
                                                 forKey:@"fucardman"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:fucardmobile
                                                 forKey:@"fucardmobile"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:shoucardno
                                                 forKey:@"shoucardno"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:shoucardbank
                                                 forKey:@"shoucardbank"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:current
                                                 forKey:@"current"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:paymoney
                                                 forKey:@"paymoney"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:payfee
                                                 forKey:@"payfee"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:money
                                                 forKey:@"money"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:shoucardmobile
                                                 forKey:@"shoucardmobile"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:shoucardman
                                                 forKey:@"shoucardman"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:arriveid
                                                 forKey:@"arriveid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:shoucardmemo
                                                 forKey:@"shoucardmemo"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:sendsms
                                                 forKey:@"sendsms"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:merReserved
                                                 forKey:@"merReserved"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
}

-(NLProtocolData*)readRepayMoneyfeeXML:(NSString*)paytype paymoney:(NSString*)paymoney paybankid:(NSString*)paybankid paycardid:(NSString*)paycardid
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"readRepayMoneyfee"
                                     api_name:@"ApiPayinfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:paytype
                                                 forKey:@"paytype"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:paymoney
                                                 forKey:@"paymoney"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:paybankid
                                                 forKey:@"paybankid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:paycardid
                                                 forKey:@"paycardid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
}

-(NLProtocolData*)insertRepayMoneyXML:(NSString*)bkntno result:(NSString *)result
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"insertRepayMoney"
                                     api_name:@"ApiPayinfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:bkntno
                                                 forKey:@"bkntno"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:result
                                                 forKey:@"result"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];

    return pd;
}

-(NLProtocolData*)readRepayMoneyglistXML:(NSString*)paytype msgstart:(NSString*)msgstart msgdisplay:(NSString*)msgdisplay
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"readRepayMoneyglist"
                                     api_name:@"ApiPayinfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:paytype
                                                 forKey:@"paytype"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:msgstart
                                                 forKey:@"msgstart"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:msgdisplay
                                                 forKey:@"msgdisplay"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
}

-(NLProtocolData*)rechargeglistXML:(NSString*)banktype bankname:(NSString*)bankname bankno:(NSString*)bankno paymoney:(NSString*)paymoney
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"insertRepayMoney"
                                     api_name:@"ApiPayinfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:banktype
                                                 forKey:@"banktype"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:bankname
                                                 forKey:@"bankname"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:bankno
                                                 forKey:@"bankno"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:paymoney
                                                 forKey:@"paymoney"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
}

-(NLProtocolData*)rechargeReqXML:(NSString*)banktype bankname:(NSString*)bankname cardno:(NSString*)cardno paymoney:(NSString*)paymoney cardmobile:(NSString*)cardmobile cardman:(NSString*)cardman sendsms:(NSString*)sendsms paycardid:(NSString*)paycardid merReserved:(NSString*)merReserved;
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"rechargeReq"
                                     api_name:@"ApiPayinfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:banktype
                                                 forKey:@"banktype"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:bankname
                                                 forKey:@"bankname"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:cardno
                                                 forKey:@"cardno"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:paymoney
                                                 forKey:@"paymoney"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:cardmobile
                                                 forKey:@"cardmobile"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:cardman
                                                 forKey:@"cardman"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:sendsms
                                                 forKey:@"sendsms"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:paycardid
                                                 forKey:@"paycardid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:merReserved
                                                 forKey:@"merReserved"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
}

-(NLProtocolData*)rechargePayXML:(NSString*)bkntno result:(NSString*)result
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"rechargePay"
                                     api_name:@"ApiPayinfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:bkntno
                                                 forKey:@"bkntno"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:result
                                                 forKey:@"result"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
}

-(NLProtocolData*)couponSaleXML:(NSString*)couponid couponmoney:(NSString*)couponmoney paycardid:(NSString*)paycardid creditcardno:(NSString*)creditcardno creditbank:(NSString*)creditbank creditcardman:(NSString*)creditcardman creditcardphone:(NSString*)creditcardphone merReserved:(NSString*)merReserved
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"couponSale"
                                     api_name:@"ApiCouponInfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:couponid
                                                 forKey:@"couponid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:couponmoney
                                                 forKey:@"couponmoney"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:paycardid
                                                 forKey:@"paycardid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:creditcardno
                                                 forKey:@"creditcardno"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:creditbank
                                                 forKey:@"creditbank"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:creditcardman
                                                 forKey:@"creditcardman"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:creditcardphone
                                                 forKey:@"creditcardphone"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:merReserved
                                                 forKey:@"merReserved"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;

}

-(NLProtocolData*)couponRebuylistXML
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"couponRebuylist"
                                     api_name:@"ApiCouponInfo"]];
    
    //operation_request/msgbody
    [pd addChild:[[NLProtocolData alloc] initValue:nil
                                            forKey:@"msgbody"
                                              attr:nil
                                          attrName:nil
                                         valueType:NLProtocolDataValueNoCData]];
    return pd;
}

-(NLProtocolData*)couponRebuyXML:(NSString*)couponid couponno:(NSString*)couponno bankid:(NSString*)bankid banksub:(NSString*)banksub bankcardno:(NSString*)bankcardno cardname:(NSString*)cardname cardphone:(NSString*)cardphone couponfee:(NSString*)couponfee sxfmoney:(NSString*)sxfmoney getmoney:(NSString*)getmoney
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"couponRebuy"
                                     api_name:@"ApiCouponInfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:couponid
                                                 forKey:@"couponid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:couponno
                                                 forKey:@"couponno"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:bankid
                                                 forKey:@"bankid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];    
    [msgbody addChild:[[NLProtocolData alloc] initValue:banksub
                                                 forKey:@"banksub"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:bankcardno
                                                 forKey:@"bankcardno"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:cardname
                                                 forKey:@"cardname"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];    
    [msgbody addChild:[[NLProtocolData alloc] initValue:cardphone
                                                 forKey:@"cardphone"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:couponfee
                                                 forKey:@"couponfee"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:sxfmoney
                                                 forKey:@"sxfmoney"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:getmoney
                                                 forKey:@"getmoney"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];

    return pd;
}

-(NLProtocolData*)readBankListXML:(NSString*)activemobilesms
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"readBankList"
                                     api_name:@"ApiAppInfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                            forKey:@"msgbody"
                                              attr:nil
                                          attrName:nil
                                         valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:activemobilesms
                                                 forKey:@"activemobilesms"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
}

-(NLProtocolData*)readBankListByPagingXML:(NSString*)activemobilesms msgstart :(NSString*)msgstart msgdisplay:(NSString*)msgdisplay querywhere:(NSString*)querywhere
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"readBankList"
                                     api_name:@"ApiAppInfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:activemobilesms
                                                 forKey:@"activemobilesms"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:msgstart
                                                 forKey:@"msgstart"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:msgdisplay
                                                 forKey:@"msgdisplay"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:querywhere
                                                 forKey:@"querywhere"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
}

-(NLProtocolData*)readIndexAdListXML:(NSString*)msgadtype
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"readIndexAdList"
                                     api_name:@"ApiAppInfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:msgadtype
                                                 forKey:@"msgadtype"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
}

-(NLProtocolData*)activePayCardXML:(NSString*)paycardkey
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"activePayCard"
                                     api_name:@"ApiAuthorInfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:paycardkey
                                                 forKey:@"paycardkey"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;

}

-(NLProtocolData*)readQueryCardMoneyXML:(NSString*)bankcardno bankid:(NSString*)bankid bankname:(NSString*)bankname;
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"readQueryCardMoney"
                                     api_name:@"ApiAppInfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:bankcardno
                                                 forKey:@"bankcardno"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];    
    [msgbody addChild:[[NLProtocolData alloc] initValue:bankid
                                                 forKey:@"bankid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:bankname
                                                 forKey:@"bankname"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
}

-(NLProtocolData*)getTransferPayfeeXML:(NSString*)bankid money:(NSString*)money arriveid:(NSString*)arriveid
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"getTransferPayfee"
                                     api_name:@"ApiPayinfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:bankid
                                                 forKey:@"bankid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:money
                                                 forKey:@"money"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:arriveid
                                                 forKey:@"arriveid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
}

-(NLProtocolData*)getRepayMoneyPayfeeXML:(NSString*)bankid money:(NSString*)money
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"getRepayMoneyPayfee"
                                     api_name:@"ApiPayinfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:bankid
                                                 forKey:@"bankid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:money
                                                 forKey:@"money"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
}

-(NLProtocolData*)RepayMoneyRqXML:(NSString*)paycardid fucardno:(NSString*)fucardno fucardmobile:(NSString*)fucardmobile fucardman:(NSString*)fucardman fucardbank:(NSString*)fucardbank shoucardno:(NSString*)shoucardno shoucardmobile:(NSString*)shoucardmobile shoucardman:(NSString*)shoucardman shoucardbank:(NSString*)shoucardbank current:(NSString*)current paymoney:(NSString*)paymoney payfee:(NSString*)payfee money:(NSString*)money
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"RepayMoneyRq"
                                     api_name:@"ApiPayinfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:paycardid
                                                 forKey:@"paycardid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:fucardno
                                                 forKey:@"fucardno"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:fucardmobile
                                                 forKey:@"fucardmobile"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:fucardman
                                                 forKey:@"fucardman"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:fucardbank
                                                 forKey:@"fucardbank"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:shoucardno
                                                 forKey:@"shoucardno"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:shoucardmobile
                                                 forKey:@"shoucardmobile"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:shoucardman
                                                 forKey:@"shoucardman"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:shoucardbank
                                                 forKey:@"shoucardbank"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:current
                                                 forKey:@"current"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:paymoney
                                                 forKey:@"paymoney"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:payfee
                                                 forKey:@"payfee"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:money
                                                 forKey:@"money"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
}

-(NLProtocolData*)readcouponinfoXML
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"readcouponinfo"
                                     api_name:@"ApiCouponInfo"]];
    
    //operation_request/msgbody
    [pd addChild:[[NLProtocolData alloc] initValue:nil
                                            forKey:@"msgbody"
                                              attr:nil
                                          attrName:nil
                                         valueType:NLProtocolDataValueNoCData]];
    return pd;
}

-(NLProtocolData*)couponSalePayXML:(NSString*)bkntno result:(NSString*)result
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"couponSalePay"
                                     api_name:@"ApiCouponInfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:bkntno
                                                 forKey:@"bkntno"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:result
                                                 forKey:@"result"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
}

-(NLProtocolData*)couponSalelistXML:(NSString*)msgstart msgdisplay:(NSString*)msgdisplay
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"couponSalelist"
                                     api_name:@"ApiCouponInfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                            forKey:@"msgbody"
                                              attr:nil
                                          attrName:nil
                                         valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:msgstart
                                                 forKey:@"msgstart"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:msgdisplay
                                                 forKey:@"msgdisplay"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
}

-(NLProtocolData*)payCardCheckXML:(NSString*)paycardkey
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"payCardCheck"
                                     api_name:@"ApiAuthorInfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:paycardkey
                                                 forKey:@"paycardkey"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
}

-(NLProtocolData*)readAppruleListXML:(NSString*)appruleid
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"readAppruleList"
                                     api_name:@"ApiAppInfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:appruleid
                                                 forKey:@"appruleid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
}

//请求
-(NLProtocolData*)readMenuModuleXML:(NSString*)paycardkey
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"readMenuModule"
                                     api_name:@"ApiAppInfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:paycardkey
                                                 forKey:@"paycardkey"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
}

//快递的接口
-(NLProtocolData*)kuaiStateXML:(NSString*)kdtype kdcode:(NSString*)kdcode
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"kuaiState"
                                     api_name:@"ApiKuaidiChaxun"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:kdtype
                                                 forKey:@"kdtype"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:kdcode
                                                 forKey:@"kdcode"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
}

//快递详细查询列表
-(NLProtocolData*)readKuaiDicmpListXML
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"readKuaiDicmpList"
                                     api_name:@"ApiKuaiDiinfo"]];
    
    //operation_request/msgbody
    /*NLProtocolData* msgbody = */[pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    return pd;
}

-(NLProtocolData*)chaxunKuaiDiNoXML:(NSString*)com nu:(NSString*)nu
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"chaxunKuaiDiNo"
                                     api_name:@"ApiKuaiDiinfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                          forKey:@"msgbody"
                                                                            attr:nil
                                                                        attrName:nil
                                                                       valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:com
                                                 forKey:@"com"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:nu
                                                 forKey:@"nu"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
}

-(NLProtocolData*)readOrderListXML:(NSString*)msgstart msgdisplay:(NSString*)msgdisplay orderno:(NSString*)orderno orderstate:(NSString*)orderstate querywhere:(NSString*)querywhere
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"readOrderList"
                                     api_name:@"ApiOrderInfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:msgstart
                                                 forKey:@"msgstart"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:msgdisplay
                                                 forKey:@"msgdisplay"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:orderno
                                                 forKey:@"orderno"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:orderstate
                                                 forKey:@"orderstate"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:querywhere
                                                 forKey:@"querywhere"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
}

-(NLProtocolData*)orderPayReqXML:(NSString*)orderid orderno:(NSString*)orderno paymoney:(NSString*)paymoney bankcardno:(NSString*)bankcardno bankname:(NSString*)bankname merReserved:(NSString*)merReserved;
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"orderPayReq"
                                     api_name:@"ApiOrderInfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:orderid
                                                 forKey:@"orderid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:orderno
                                                 forKey:@"orderno"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:paymoney
                                                 forKey:@"paymoney"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:bankcardno
                                                 forKey:@"bankcardno"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:bankname
                                                 forKey:@"bankname"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:merReserved
                                                 forKey:@"merReserved"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
}

-(NLProtocolData*)orderPayFeedbackXML:(NSString*)request bkntno:(NSString *)bkntno
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"orderPayFeedback"
                                     api_name:@"ApiOrderInfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:request
                                                 forKey:@"result"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:bkntno
                                                 forKey:@"bkntno"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
}

-(NLProtocolData*)orderPayBankCardStarXML:(NSString*)orderid orderno:(NSString*)orderno paymoney:(NSString*)paymoney bankcardno:(NSString*)bankcardno bankname:(NSString*)bankname
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"orderPayBankCardStar"
                                     api_name:@"ApiOrderInfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:orderid
                                                 forKey:@"orderid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:orderno
                                                 forKey:@"orderno"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:paymoney
                                                 forKey:@"paymoney"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:bankcardno
                                                 forKey:@"bankcardno"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:bankname
                                                 forKey:@"bankname"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
}

-(NLProtocolData*)readAuBkCardInfoXML
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"readAuBkCardInfo"
                                     api_name:@"ApiAuCardInfo"]];
    
    //operation_request/msgbody
    [pd addChild:[[NLProtocolData alloc] initValue:nil
                                            forKey:@"msgbody"
                                              attr:nil
                                          attrName:nil
                                         valueType:NLProtocolDataValueNoCData]];
    return pd;
}

-(NLProtocolData*)modifyAuBkCardInfoXML:(NSString*)aushoucardman aushoucardphone:(NSString*)aushoucardphone aushoucardno:(NSString*)aushoucardno aushoucardbank:(NSString*)aushoucardbank
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"modifyAuBkCardInfo"
                                     api_name:@"ApiAuCardInfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:aushoucardman
                                                 forKey:@"aushoucardman"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:aushoucardphone
                                                 forKey:@"aushoucardphone"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:aushoucardno
                                                 forKey:@"aushoucardno"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:aushoucardbank
                                                 forKey:@"aushoucardbank"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
}

-(NLProtocolData*)readshoucardListXML:(NSString*)paytype
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"readshoucardList"
                                     api_name:@"ApiPayinfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:paytype
                                                 forKey:@"paytype"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
}

-(NLProtocolData*)getSupTransferPayfeeXML:(NSString*)bankid money:(NSString*)money arriveid:(NSString*)arriveid
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"getSupTransferPayfee"
                                     api_name:@"ApiPayinfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:bankid
                                                 forKey:@"bankid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:money
                                                 forKey:@"money"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:arriveid
                                                 forKey:@"arriveid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
}

-(NLProtocolData*)SuptransferMoneyRqXML:(NSString*)paycardid fucardno:(NSString*)fucardno fucardbank:(NSString*)fucardbank fucardman:(NSString*)fucardman fucardmobile:(NSString*)fucardmobile shoucardno:(NSString*)shoucardno shoucardbank:(NSString*)shoucardbank current:(NSString*)current paymoney:(NSString*)paymoney payfee:(NSString*)payfee money:(NSString*)money shoucardmobile:(NSString*)shoucardmobile shoucardman:(NSString*)shoucardman arriveid:(NSString*)arriveid shoucardmemo:(NSString*)shoucardmemo sendsms:(NSString*)sendsms merReserved:(NSString*)merReserved
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"SuptransferMoneyRq"
                                     api_name:@"ApiPayinfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:paycardid
                                                 forKey:@"paycardid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:fucardno
                                                 forKey:@"fucardno"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:fucardbank
                                                 forKey:@"fucardbank"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:fucardman
                                                 forKey:@"fucardman"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:fucardmobile
                                                 forKey:@"fucardmobile"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:shoucardno
                                                 forKey:@"shoucardno"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:shoucardbank
                                                 forKey:@"shoucardbank"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:current
                                                 forKey:@"current"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:paymoney
                                                 forKey:@"paymoney"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:payfee
                                                 forKey:@"payfee"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:money
                                                 forKey:@"money"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:shoucardmobile
                                                 forKey:@"shoucardmobile"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:shoucardman
                                                 forKey:@"shoucardman"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:arriveid
                                                 forKey:@"arriveid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:shoucardmemo
                                                 forKey:@"shoucardmemo"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:sendsms
                                                 forKey:@"sendsms"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:merReserved
                                                 forKey:@"merReserved"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
}

-(NLProtocolData*)insertSupTransferMoneyXML:(NSString*)bkntno result:(NSString*)result
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"insertSupTransferMoney"
                                     api_name:@"ApiPayinfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:bkntno
                                                 forKey:@"bkntno"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:result
                                                 forKey:@"result"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
}

-(NLProtocolData*)readSupTransferMoneyglistXML:(NSString*)paytype msgstart:(NSString*)msgstart msgdisplay:(NSString*)msgdisplay
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"readSupTransferMoneyglist"
                                     api_name:@"ApiPayinfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:paytype
                                                 forKey:@"paytype"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:msgstart
                                                 forKey:@"msgstart"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:msgdisplay
                                                 forKey:@"msgdisplay"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
}

//读取充值金额选项
-(NLProtocolData *)readRechaMoneyinfoXML
{
    NLProtocolData *pd= [[NLProtocolData alloc]initValue:nil forKey:@"operation_request" attr:nil attrName:nil valueType:NLProtocolDataValueNoCData];

    //operation_request/msgheader
    NLProtocolData *hearder= [self defaultMsgheader];
    [pd addChild:hearder];
    
    //operation_request/ApiMoblieRechangeInfo/readRechaPayTypeinfo
    [hearder addChild:[self defaultChannelinfo:YES api_name_func:@"ReadPerValue" api_name:@"ApiMobileRechargeInfoV2"]];
    
    //operation_request/msgbody
    [pd addChild:[[NLProtocolData alloc] initValue:nil
                                            forKey:@"msgbody"
                                              attr:nil
                                          attrName:nil
                                         valueType:NLProtocolDataValueNoCData]];
    return pd;
}

//话费充值接口
-(NLProtocolData*)paycardIDRqXML:(NSString *)paycardid rechapaytypeid:(NSString *)rechapaytypeid rechamoney:(NSString *)rechamoney rechapaymoney:(NSString *)rechapaymoney rechamobile:(NSString *)rechamobile rechamobileprov:(NSString *)rechamobileprov rechabkcardno:(NSString *)rechabkcardno rechabkcardid:(NSString *)rechabkcardid merReserved:(NSString *)merReserved{
    
    NLProtocolData *pd= [[NLProtocolData alloc]initValue:nil forKey:@"operation_request" attr:nil attrName:nil valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData *hearder= [self defaultMsgheader];
    [pd addChild:hearder];
    
    
    
    //operation_request/msgheader/channelinfo
    [hearder addChild:[self defaultChannelinfo:YES api_name_func:@"RequestTransNumber" api_name:@"ApiMobileRechargeInfoV2"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    //刷卡器
    [msgbody addChild:[[NLProtocolData alloc] initValue:paycardid
                                                 forKey:@"paycardid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    //支付类型id
    [msgbody addChild:[[NLProtocolData alloc] initValue:rechapaytypeid
                                                 forKey:@"rechapaytypeid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    //充值金额rechamoney
    [msgbody addChild:[[NLProtocolData alloc] initValue:rechamoney
                                                 forKey:@"rechamoney"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    //rechapaymoney 实际支付
    [msgbody addChild:[[NLProtocolData alloc] initValue:rechapaymoney
                                                 forKey:@"rechapaymoney"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    
    //rechamobile 充值手机号码
    [msgbody addChild:[[NLProtocolData alloc] initValue:rechamobile
                                                 forKey:@"rechamobile"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    //rechamobile 手机归属地
    [msgbody addChild:[[NLProtocolData alloc] initValue:rechamobileprov
                                                 forKey:@"rechamobileprov"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    //银行卡No
    [msgbody addChild:[[NLProtocolData alloc] initValue:rechabkcardno
                                                 forKey:@"rechabkcardno"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    //银行卡ID
    [msgbody addChild:[[NLProtocolData alloc] initValue:rechabkcardid
                                                 forKey:@"rechabkcardid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    //银行卡信息保留域
    [msgbody addChild:[[NLProtocolData alloc] initValue:merReserved
                                                 forKey:@"merReserved"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    return pd;
}

// 手机充值支付成功反馈
-(NLProtocolData*)checkRechaMoneyStatusXML:(NSString*)bkntno result:(NSString*)result
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"CheckOrderStatus"
                                     api_name:@"ApiMobileRechargeInfoV2"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:bkntno
                                                 forKey:@"bkntno"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:result
                                                 forKey:@"result"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
}

// 读取手机充值历史记录
-(NLProtocolData*)readMobileRechangelistXML:(NSString*)paytype msgstart:(NSString*)msgstart msgdisplay:(NSString*)msgdisplay
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"ReadMobileRechangeList"
                                     api_name:@"ApiMobileRechargeInfoV2"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:paytype
                                                 forKey:@"paytype"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:msgstart
                                                 forKey:@"msgstart"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:msgdisplay
                                                 forKey:@"msgdisplay"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
}

//读取Q币充值金额选项
-(NLProtocolData *)readRechaQQMoneyinfoXML
{
    NLProtocolData *pd= [[NLProtocolData alloc]initValue:nil forKey:@"operation_request" attr:nil attrName:nil valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData *hearder= [self defaultMsgheader];
    [pd addChild:hearder];
    
    //operation_request/ApiMoblieRechangeInfo/readRechaPayTypeinfo
    [hearder addChild:[self defaultChannelinfo:YES api_name_func:@"ReadPerValue" api_name:@"ApiMobileRechargeInfoV2"]];
    
    //operation_request/msgbody
    [pd addChild:[[NLProtocolData alloc] initValue:nil
                                            forKey:@"msgbody"
                                              attr:nil
                                          attrName:nil
                                         valueType:NLProtocolDataValueNoCData]];
    return pd;

}

/***
 Q币充值
 */
-(NLProtocolData*)payQQcardIDRqXML:(NSString *)paycardid rechapaytypeid:(NSString *)rechapaytypeid rechamoney:(NSString *)rechamoney rechapaymoney:(NSString *)rechapaymoney rechaqq:(NSString *)qq rechabkcardno:(NSString *)rechabkcardno rechabkcardid:(NSString *)rechabkcardid merReserved:(NSString *)merReserved
{
    NLProtocolData *pd= [[NLProtocolData alloc]initValue:nil forKey:@"operation_request" attr:nil attrName:nil valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData *hearder= [self defaultMsgheader];
    [pd addChild:hearder];
    
    
    
    //operation_request/msgheader/channelinfo
    [hearder addChild:[self defaultChannelinfo:YES api_name_func:@"RechaMoneyRq" api_name:@"ApiQQRechangeInfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    //刷卡器
    [msgbody addChild:[[NLProtocolData alloc] initValue:paycardid
                                                 forKey:@"paycardid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    //支付类型id
    [msgbody addChild:[[NLProtocolData alloc] initValue:rechapaytypeid
                                                 forKey:@"rechapaytypeid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    //充值金额rechamoney
    [msgbody addChild:[[NLProtocolData alloc] initValue:rechamoney
                                                 forKey:@"rechamoney"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    //rechapaymoney 实际支付
    [msgbody addChild:[[NLProtocolData alloc] initValue:rechapaymoney
                                                 forKey:@"rechapaymoney"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    
    //rechaqq 充值qq号码
    [msgbody addChild:[[NLProtocolData alloc] initValue:qq
                                                 forKey:@"rechaqq"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    //银行卡No
    [msgbody addChild:[[NLProtocolData alloc] initValue:rechabkcardno
                                                 forKey:@"rechabkcardno"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    //银行卡ID
    [msgbody addChild:[[NLProtocolData alloc] initValue:rechabkcardid
                                                 forKey:@"rechabkcardid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    //银行卡信息保留域
    [msgbody addChild:[[NLProtocolData alloc] initValue:merReserved
                                                 forKey:@"merReserved"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    return pd;
}

/***
 Q币充值支付成功反馈
 */
-(NLProtocolData*)checkRechaQQMoneyStatusXML:(NSString*)bkntno result:(NSString*)result
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"CheckTransStatus"
                                     api_name:@"ApiMobileRechargeInfoV2"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:bkntno
                                                 forKey:@"bkntno"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:result
                                                 forKey:@"result"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
}

/**
 读取Q币充值历史记录
 */
-(NLProtocolData*)readMobileRechangeQQlistXML:(NSString*)paytype msgstart:(NSString*)msgstart msgdisplay:(NSString*)msgdisplay
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"readQQRechangelist"
                                     api_name:@"ApiQQRechangeInfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:paytype
                                                 forKey:@"paytype"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:msgstart
                                                 forKey:@"msgstart"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:msgdisplay
                                                 forKey:@"msgdisplay"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
}

/**
 内部购买刷卡器-读取产品管理信息
 */
-(NLProtocolData *)readSKQOrderInfoXML
{
    NLProtocolData *pd= [[NLProtocolData alloc]initValue:nil forKey:@"operation_request" attr:nil attrName:nil valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData *hearder= [self defaultMsgheader];
    [pd addChild:hearder];
    
    [hearder addChild:[self defaultChannelinfo:YES api_name_func:@"readOrderProinfo" api_name:@"ApiBuyOderInfo"]];
    
    //operation_request/msgbody
    [pd addChild:[[NLProtocolData alloc] initValue:nil
                                            forKey:@"msgbody"
                                              attr:nil
                                          attrName:nil
                                         valueType:NLProtocolDataValueNoCData]];
    return pd;
}

//内部购买刷卡器-读取收货地址
-(NLProtocolData *)readSKQShaddressInfoXML
{
    NLProtocolData *pd= [[NLProtocolData alloc]initValue:nil forKey:@"operation_request" attr:nil attrName:nil valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData *hearder= [self defaultMsgheader];
    [pd addChild:hearder];
    
    [hearder addChild:[self defaultChannelinfo:YES api_name_func:@"readShaddressinfo" api_name:@"ApiBuyOderInfo"]];
    
    //operation_request/msgbody
    [pd addChild:[[NLProtocolData alloc] initValue:nil
                                            forKey:@"msgbody"
                                              attr:nil
                                          attrName:nil
                                         valueType:NLProtocolDataValueNoCData]];
    return pd;
}

/**
 内部购买刷卡器-新增收货地址
 */
-(NLProtocolData *)addSKQShaddressProvinceXML:(NSString *)province city:(NSString *)city county:(NSString *)county address:(NSString *)address man:(NSString *)man phone:(NSString *)phone defaultAdress:(NSString *)defaultAdress
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"shaddressAdd"
                                     api_name:@"ApiBuyOderInfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:province
                                                 forKey:@"shprovincecode"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:city
                                                 forKey:@"shcitycode"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];

    
    [msgbody addChild:[[NLProtocolData alloc] initValue:county
                                                 forKey:@"shcountycode"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];

    
    [msgbody addChild:[[NLProtocolData alloc] initValue:address
                                                 forKey:@"shaddress"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];

    
    [msgbody addChild:[[NLProtocolData alloc] initValue:man
                                                 forKey:@"shman"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:phone
                                                 forKey:@"shphone"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:defaultAdress
                                                 forKey:@"shdefault"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];

    
    return pd;
}

/**
 内部购买刷卡器-删除收货地址
 */
-(NLProtocolData *)deleteSKQShaddressWithAddressIdXML:(NSString *)addressId
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"shaddressDelete"
                                     api_name:@"ApiBuyOderInfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:addressId
                                                 forKey:@"shaddressid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
}

/**
 内部购买刷卡器-支付请求银联交易码
 */
-(NLProtocolData*)paySKQcardIDRqXML:(NSString *)paycardid orderPaytypeid:(NSString *)orderPaytypeid orderprodureid:(NSString *)orderprodureid ordernum:(NSString *)ordernum orderprice:(NSString *)orderprice ordermoney:(NSString *)ordermoney ordershaddressid:(NSString *)ordershaddressid oredershaddress:(NSString *)oredershaddress ordershman:(NSString *)ordershman ordershphone:(NSString *)ordershphone orderfucardno:(NSString *)orderfucardno orderfucardbank:(NSString *)orderfucardbank ordermemo:(NSString *)ordermemo yunmoney:(NSString *)yunmoney yunprice:(NSString *)yunprice promoney:(NSString *)promoney produrename:(NSString *)produrename agentno:(NSString*)agentno
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"payOrderRq"
                                     api_name:@"ApiBuyOderInfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:paycardid
                                                 forKey:@"paycardid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:orderPaytypeid
                                                 forKey:@"orderpaytypeid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:orderprodureid
                                                 forKey:@"orderprodureid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:ordernum
                                                 forKey:@"ordernum"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:orderprice
                                                 forKey:@"orderprice"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:ordermoney
                                                 forKey:@"ordermoney"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:ordershaddressid
                                                 forKey:@"ordershaddressid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:oredershaddress
                                                 forKey:@"oredershaddress"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:ordershman
                                                 forKey:@"ordershman"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:ordershphone
                                                 forKey:@"ordershphone"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:orderfucardno
                                                 forKey:@"orderfucardno"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:orderfucardbank
                                                 forKey:@"orderfucardbank"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:ordermemo
                                                 forKey:@"ordermemo"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:yunmoney
                                                 forKey:@"yunmoney"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:yunprice
                                                 forKey:@"yunprice"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:promoney
                                                 forKey:@"promoney"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:produrename
                                                 forKey:@"produrename"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
   
    [msgbody addChild:[[NLProtocolData alloc] initValue:agentno
                                                 forKey:@"agentno"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    
    
    return pd;

}

/**
 内部购买刷卡器-银联支付成功反馈
 */
-(NLProtocolData*)checkPaySKQStatusXML:(NSString*)bkntno result:(NSString*)result
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"orderPayrqStatus"
                                     api_name:@"ApiBuyOderInfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:bkntno
                                                 forKey:@"bkntno"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:result
                                                 forKey:@"result"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;

}

/**
 内部购买刷卡器-读取购买历史记录
 */
-(NLProtocolData*)readPaySKQhistorylistXML:(NSString*)paytype msgstart:(NSString*)msgstart msgdisplay:(NSString*)msgdisplay
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"readOrderlist"
                                     api_name:@"ApiBuyOderInfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:paytype
                                                 forKey:@"paytype"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:msgstart
                                                 forKey:@"msgstart"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:msgdisplay
                                                 forKey:@"msgdisplay"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
}

/*
 读取水电煤服务列表
 */
-(NLProtocolData*)readWaterEleProductListXML
{
    NLProtocolData *pd= [[NLProtocolData alloc]initValue:nil forKey:@"operation_request" attr:nil attrName:nil valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData *hearder= [self defaultMsgheader];
    [pd addChild:hearder];
    
    [hearder addChild:[self defaultChannelinfo:YES api_name_func:@"getProductList" api_name:@"ApiUtility"]];
    
    //operation_request/msgbody
    [pd addChild:[[NLProtocolData alloc] initValue:nil
                                            forKey:@"msgbody"
                                              attr:nil
                                          attrName:nil
                                         valueType:NLProtocolDataValueNoCData]];
    return pd;

}

/*
 水电煤生成订单
 */
-(NLProtocolData*)createWaterEleOrderXML:(NSString *)account productId:(NSString *)productId
{
    NLProtocolData *pd= [[NLProtocolData alloc]initValue:nil forKey:@"operation_request" attr:nil attrName:nil valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData *hearder= [self defaultMsgheader];
    [pd addChild:hearder];
    
    [hearder addChild:[self defaultChannelinfo:YES api_name_func:@"createOrder" api_name:@"ApiUtility"]];
    
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:account
                                                 forKey:@"account"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:productId
                                                 forKey:@"proId"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;

}

/*
 水电煤提交订单
 */
-(NLProtocolData*)submitWaterEleOrderXML:(NSString *)orderId paycardid:(NSString *)paycardId rechabkcardno:(NSString *)rechabkcardno merReserved:(NSString *)merReserved
{
    NLProtocolData *pd= [[NLProtocolData alloc]initValue:nil forKey:@"operation_request" attr:nil attrName:nil valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData *hearder= [self defaultMsgheader];
    [pd addChild:hearder];
    
    [hearder addChild:[self defaultChannelinfo:YES api_name_func:@"submitOrder" api_name:@"ApiUtility"]];
    
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:orderId
                                                 forKey:@"orderid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:paycardId
                                                 forKey:@"paycardid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:rechabkcardno
                                                 forKey:@"rechabkcardno"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:merReserved
                                                 forKey:@"merReserved"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;

}

/*
 水电煤支付完订单反馈
 */
-(NLProtocolData*)completeWaterEleOrderXML:(NSString *)orderid bkntno:(NSString *)bkntno
{
    NLProtocolData *pd= [[NLProtocolData alloc]initValue:nil forKey:@"operation_request" attr:nil attrName:nil valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData *hearder= [self defaultMsgheader];
    [pd addChild:hearder];
    
    [hearder addChild:[self defaultChannelinfo:YES api_name_func:@"completeOrder" api_name:@"ApiUtility"]];
    
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:orderid
                                                 forKey:@"orderid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:bkntno
                                                 forKey:@"bkntno"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
      return pd;

}

/*
 水电煤查询历史订单
 */
-(NLProtocolData*)getWaterEleOrderHistoryWithmsgStartXML:(NSString*)msgstart msgdisplay:(NSString*)msgdisplay
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"getOrderHistory"
                                     api_name:@"ApiUtility"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:msgstart
                                                 forKey:@"msgstart"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:msgdisplay
                                                 forKey:@"msgdisplay"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
}

/**** 游戏充值 ****/

//获取游戏列表
-(NLProtocolData*)getGameChargeGameListXML
{
    NLProtocolData *pd= [[NLProtocolData alloc]initValue:nil forKey:@"operation_request" attr:nil attrName:nil valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData *hearder= [self defaultMsgheader];
    [pd addChild:hearder];
    
    [hearder addChild:[self defaultChannelinfo:YES api_name_func:@"getGameList" api_name:@"ApiGameRecharge"]];
    
    //operation_request/msgbody
    [pd addChild:[[NLProtocolData alloc] initValue:nil
                                            forKey:@"msgbody"
                                              attr:nil
                                          attrName:nil
                                         valueType:NLProtocolDataValueNoCData]];
    return pd;
}

//获取平台
-(NLProtocolData*)getGameChargeplatformXML
{
    NLProtocolData *pd= [[NLProtocolData alloc]initValue:nil forKey:@"operation_request" attr:nil attrName:nil valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData *hearder= [self defaultMsgheader];
    [pd addChild:hearder];
    
    [hearder addChild:[self defaultChannelinfo:YES api_name_func:@"getplatformList" api_name:@"ApiGameRecharge"]];
    
    //operation_request/msgbody
    [pd addChild:[[NLProtocolData alloc] initValue:nil
                                            forKey:@"msgbody"
                                              attr:nil
                                          attrName:nil
                                         valueType:NLProtocolDataValueNoCData]];
    return pd;
}

//游戏小类列表
-(NLProtocolData*)getGameChargeChildGameXML:(NSString *)gameId
{
    NLProtocolData *pd= [[NLProtocolData alloc]initValue:nil forKey:@"operation_request" attr:nil attrName:nil valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData *hearder= [self defaultMsgheader];
    [pd addChild:hearder];
    
    [hearder addChild:[self defaultChannelinfo:YES api_name_func:@"getChildGame" api_name:@"ApiGameRecharge"]];
    
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:gameId
                                                 forKey:@"gameId"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
   
    return pd;

}

//获取某一游戏详细信息
-(NLProtocolData*)getGameChargeGameDetailXML:(NSString *)gameId
{
    NLProtocolData *pd= [[NLProtocolData alloc]initValue:nil forKey:@"operation_request" attr:nil attrName:nil valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData *hearder= [self defaultMsgheader];
    [pd addChild:hearder];
    
    [hearder addChild:[self defaultChannelinfo:YES api_name_func:@"getGameDetail" api_name:@"ApiGameRecharge"]];
    
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:gameId
                                                 forKey:@"gameId"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    return pd;
  
}

//生成订单
-(NLProtocolData*)GameChargeCreateOrderXML:(NSString *)gameId gameName:(NSString *)gameName area:(NSString *)area server:(NSString *)server quantity:(NSString *)quantity price:(NSString *)price userCount:(NSString *)userCount paycardid:(NSString *)paycardid rechabkcardno:(NSString *)rechabkcardno cost:(NSString*)cost;
{
    NLProtocolData *pd= [[NLProtocolData alloc]initValue:nil forKey:@"operation_request" attr:nil attrName:nil valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData *hearder= [self defaultMsgheader];
    [pd addChild:hearder];
    
    [hearder addChild:[self defaultChannelinfo:YES api_name_func:@"createOrder" api_name:@"ApiGameRecharge"]];
    
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:gameId
                                                 forKey:@"gameId"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:gameName
                                                 forKey:@"gameName"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:area
                                                 forKey:@"area"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:server
                                                 forKey:@"server"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:quantity
                                                 forKey:@"quantity"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:price
                                                 forKey:@"price"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:userCount
                                                 forKey:@"userCount"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:paycardid
                                                 forKey:@"paycardid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:rechabkcardno
                                                 forKey:@"rechabkcardno"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:cost
                                                 forKey:@"cost"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];

    return pd;

}

//支付完订单
-(NLProtocolData*)completeGameChargeOrderXML:(NSString *)bkntno
{
    NLProtocolData *pd= [[NLProtocolData alloc]initValue:nil forKey:@"operation_request" attr:nil attrName:nil valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData *hearder= [self defaultMsgheader];
    [pd addChild:hearder];
    
    [hearder addChild:[self defaultChannelinfo:YES api_name_func:@"completeOrder" api_name:@"ApiGameRecharge"]];
    
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:bkntno
                                                 forKey:@"bkntno"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
}

//查询历史订单
-(NLProtocolData*)getGameChargeOrderHistoryWithmsgStartXML:(NSString*)msgstart msgdisplay:(NSString*)msgdisplay
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"getOrderHistory"
                                     api_name:@"ApiGameRecharge"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:msgstart
                                                 forKey:@"msgstart"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:msgdisplay
                                                 forKey:@"msgdisplay"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;

}

//代理商读取基本信息
-(NLProtocolData*)readagentinfoXML
{
    NLProtocolData *pd= [[NLProtocolData alloc]initValue:nil forKey:@"operation_request" attr:nil attrName:nil valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData *hearder= [self defaultMsgheader];
    [pd addChild:hearder];
    
    [hearder addChild:[self defaultChannelinfo:YES api_name_func:@"readagentinfo" api_name:@"ApiAgentInfo"]];
    
    //operation_request/msgbody
    [pd addChild:[[NLProtocolData alloc] initValue:nil
                                            forKey:@"msgbody"
                                              attr:nil
                                          attrName:nil
                                         valueType:NLProtocolDataValueNoCData]];
    return pd;

}

//代理商读取读取补货记录
-(NLProtocolData*)readagentorderlistXML:(NSString*)paytype msgstart:(NSString*)msgstart msgdisplay:(NSString*)msgdisplay
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header = [self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"readagentorder"
                                     api_name:@"ApiAgentInfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:paytype
                                                 forKey:@"paytype"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:msgstart
                                                 forKey:@"msgstart"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:msgdisplay
                                                 forKey:@"msgdisplay"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;

}

//代理商补货发货状态提交
-(NLProtocolData*)agentorderstaterqXML:(NSString *)orderid
{
    NLProtocolData *pd= [[NLProtocolData alloc]initValue:nil forKey:@"operation_request" attr:nil attrName:nil valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData *hearder= [self defaultMsgheader];
    [pd addChild:hearder];
    
    [hearder addChild:[self defaultChannelinfo:YES api_name_func:@"agentorderstaterq" api_name:@"ApiAgentInfo"]];
    
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:orderid
                                                 forKey:@"orderid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    return pd;

}

//代理商补货请求银行交易码
-(NLProtocolData*)payagentOrderRqXML:(NSString *)orderprodureid ordernum:(NSString *)ordernum orderprice:(NSString *)orderprice ordermoney:(NSString *)ordermoney rechabkcardno:(NSString *)rechabkcardno orderfucardbank:(NSString *)orderfucardbank ordermemo:(NSString *)ordermemo
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header = [self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"payagentOrderRq"
                                     api_name:@"ApiAgentInfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:orderprodureid
                                                 forKey:@"orderprodureid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:ordernum
                                                 forKey:@"ordernum"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:orderprice
                                                 forKey:@"orderprice"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:ordermoney
                                                 forKey:@"ordermoney"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:rechabkcardno
                                                 forKey:@"rechabkcardno"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:orderfucardbank
                                                 forKey:@"orderfucardbank"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:ordermemo
                                                 forKey:@"ordermemo"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;

}

//代理商银联支付成功反馈
-(NLProtocolData*)agentorderPayrqStatusXML:(NSString*)bkntno result:(NSString*)result
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"agentorderPayrqStatus"
                                     api_name:@"ApiAgentInfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:bkntno
                                                 forKey:@"bkntno"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:result
                                                 forKey:@"result"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
}

//代理商读取历史收益记录
-(NLProtocolData*)payagentfenrunlistXML:(NSString *)querytype querywhere:(NSString *)querywhere
{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"payagentfenrunlist"
                                     api_name:@"ApiAgentInfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:querytype
                                                 forKey:@"querytype"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:querywhere
                                                 forKey:@"querywhere"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;

}

//绑定代理商
-(NLProtocolData*)BindingAgentIdXML:(NSString *)querytype agentno:(NSString *)agentno{
    
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"authorBindAgent"
                                     api_name:@"ApiAgentInfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:querytype
                                                 forKey:@"querytype"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:agentno
                                                 forKey:@"agentno"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;

}

//最新的注册接口
-(NLProtocolData*)getTheNewLoginApiAuthorInfoV2XML:(NSString *)Mac Phone:(NSString*)phone Password:(NSString*)Password{
    NLProtocolData *pd= [[NLProtocolData alloc]initValue:nil forKey:@"operation_request" attr:nil attrName:nil valueType:NLProtocolDataValueNoCData];
    
    NLProtocolData *header= [self defaultMsgheader];
    
    [pd addChild:header];
    
    [header addChild:[self defaultChannelinfo:YES api_name_func:@"register" api_name:@"ApiAuthorInfoV2"]];
   
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:Mac
                                                 forKey:@"macip"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:phone
                                                 forKey:@"phonenumber"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:Password
                                                 forKey:@"paypasswd"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    return pd;
}

//判断是否用户已经注册
-(NLProtocolData*)getApiAuthorInfoV2IsOnMainXML:(NSString *)Mac Phone:(NSString*)phone accountnumber:(NSString*)accountnumber Password:(NSString*)Password{
    
   
    NLProtocolData *pd= [[NLProtocolData alloc]initValue:nil forKey:@"operation_request" attr:nil attrName:nil valueType:NLProtocolDataValueNoCData];
    
    NLProtocolData *header= [self defaultMsgheader];
    
    [pd addChild:header];
    
    [header addChild:[self defaultChannelinfo:YES api_name_func:@"authorExists" api_name:@"ApiAuthorInfoV2"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:Mac
                                                 forKey:@"macip"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:phone
                                                 forKey:@"phonenumber"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:accountnumber
                                                 forKey:@"accountnumber"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:Password
                                                 forKey:@"paypasswd"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    return pd;
}

//用户登录
- (NLProtocolData*)getApiAuthorInfoV2gesturepasswdXML:(NSString *)password paypasswd:(NSString *)paypasswd mobile:(NSString*)mobile
{
    NLProtocolData *pd= [[NLProtocolData alloc]initValue:nil forKey:@"operation_request" attr:nil attrName:nil valueType:NLProtocolDataValueNoCData];
    
    NLProtocolData *header= [self defaultMsgheader];
    
    [pd addChild:header];
    
    [header addChild:[self defaultChannelinfo:YES api_name_func:@"login" api_name:@"ApiAuthorInfoV2"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:password
                                                 forKey:@"gesturepasswd"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:paypasswd
                                                 forKey:@"paypasswd"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:mobile
                                                 forKey:@"mobile"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    return pd;
}

//用户修改密码(login一样接口)
- (NLProtocolData*)getApiAuthorInfoPasswordToChageXML:(NSString *)oldpassword newpassword:(NSString *)newpassword aumoditype:(NSString *)aumoditype reset:(NSString *)reset{
   
    NLProtocolData *pd= [[NLProtocolData alloc]initValue:nil forKey:@"operation_request" attr:nil attrName:nil valueType:NLProtocolDataValueNoCData];
    
    NLProtocolData *header= [self defaultMsgheader];
    
    [pd addChild:header];
    
    [header addChild:[self defaultChannelinfo:YES api_name_func:@"authorPwdModify" api_name:@"ApiAuthorInfoV2"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:oldpassword
                                                 forKey:@"auoldpwd"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:newpassword
                                                forKey:@"aunewpwd"
                                                  attr:nil
                                              attrName:nil
                                             valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:aumoditype
                                                forKey:@"aumoditype"
                                                  attr:nil
                                              attrName:nil
                                             valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:reset
                                                forKey:@"reset"
                                                  attr:nil
                                              attrName:nil
                                             valueType:NLProtocolDataValueNoCData]];
    return pd;
}


//获取所有的预设密保问题
- (NLProtocolData*)getApiSafeGuardXML{
   
    NLProtocolData *pd= [[NLProtocolData alloc]initValue:nil forKey:@"operation_request" attr:nil attrName:nil valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData *hearder= [self defaultMsgheader];
    
    [pd addChild:hearder];
    
    [hearder addChild:[self defaultChannelinfo:YES api_name_func:@"getQueList" api_name:@"ApiSafeGuard"]];
    
    //operation_request/msgbody
    [pd addChild:[[NLProtocolData alloc] initValue:nil
                                            forKey:@"msgbody"
                                              attr:nil
                                          attrName:nil
                                         valueType:NLProtocolDataValueNoCData]];
    
     return pd;
}

//设置密保问题 
- (NLProtocolData *)getApiSafeGuardMsgchildXML:(NSString*)quechild1 answer1:(NSString*)answer1 quechild2:(NSString*)quechild2 answer2:(NSString*)answer2 quechild3:(NSString*)quechild3 answer3:(NSString*)answer3{
    
    NLProtocolData *pd= [[NLProtocolData alloc]initValue:nil forKey:@"operation_request" attr:nil attrName:nil valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData *hearder= [self defaultMsgheader];
    
    [pd addChild:hearder];
    
    [hearder addChild:[self defaultChannelinfo:YES api_name_func:@"setAnswer" api_name:@"ApiSafeGuard"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    
    NLProtocolData* msgchild1 = [[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgchild1"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData];
    
   
    
    [msgchild1 addChild:[[NLProtocolData alloc] initValue:quechild1
                                                 forKey:@"queid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgchild1 addChild:[[NLProtocolData alloc] initValue:answer1
                                                 forKey:@"answer"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    
    [msgbody addChild:msgchild1];
    
    NLProtocolData* msgchild2 = [[NLProtocolData alloc] initValue:nil
                                                                        forKey:@"msgchild2"
                                                                          attr:nil
                                                                      attrName:nil
                                                                     valueType:NLProtocolDataValueNoCData];
    
    
    [msgchild2 addChild:[[NLProtocolData alloc] initValue:quechild2
                                                 forKey:@"queid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgchild2 addChild:[[NLProtocolData alloc] initValue:answer2
                                                 forKey:@"answer"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];

    [msgbody addChild:msgchild2];
    NLProtocolData* msgchild3 = [[NLProtocolData alloc] initValue:nil
                                                                        forKey:@"msgchild3"
                                                                          attr:nil
                                                                      attrName:nil
                                                                     valueType:NLProtocolDataValueNoCData];
    
    [msgchild3 addChild:[[NLProtocolData alloc] initValue:quechild3
                                                 forKey:@"queid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgchild3 addChild:[[NLProtocolData alloc] initValue:answer3
                                                 forKey:@"answer"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    
    [msgbody addChild:msgchild3];

    return pd;
}



//获取是否设置密保问题
- (NLProtocolData *)getApiSafeGuardUserXML:(NSString*)PhoneNumber{
    
    
    NLProtocolData *pd= [[NLProtocolData alloc]initValue:nil forKey:@"operation_request" attr:nil attrName:nil valueType:NLProtocolDataValueNoCData];
    
    NLProtocolData *header= [self defaultMsgheader];
    
    [pd addChild:header];
    
    [header addChild:[self defaultChannelinfo:YES api_name_func:@"validateUser" api_name:@"ApiSafeGuard"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:PhoneNumber
                                                 forKey:@"phonenumber"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
    /*-[ProtocolRequest processResult:data:error:]:160}:: rspToXml=
     <?xml version='1.0' encoding='utf-8' standalone='yes' ?><operation_response><msgheader version = "1.0"><au_token>nHAVXZLErqbJlA/n8LB/0moJ</au_token><req_token></req_token><req_bkenv>00</req_bkenv><retinfo><rettype>200</rettype><retcode>200</retcode><retmsg>ÊÇ®ËøòÊú™ËÆæÁΩÆËøáÂØÜ‰øùÈóÆÈ¢ò</retmsg></retinfo></msgheader><msgbody><result>failure</result><message>ÊÇ®ËøòÊú™ËÆæÁΩÆËøáÂØÜ‰øùÈóÆÈ¢ò</message></msgbody></operation_response>0aM"0
*/
    
    
}

//用于判断是否有绑定默认的银行卡
- (NLProtocolData*)getApiAuthorInfoV2modifyAuthorInfoXML:(NSString*)PhoneNumber accountnumber:(NSString*)accountnumber accountname:(NSString*)accountname bankname:(NSString*)bankname{
    //operation_request
    NLProtocolData* pd = [[NLProtocolData alloc] initValue:nil forKey:@"operation_request"
                                                      attr:nil
                                                  attrName:nil
                                                 valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData* header =[self defaultMsgheader];
    [pd addChild:header];
    
    //operation_request/msgheader/channelinfo
    [header addChild:[self defaultChannelinfo:YES
                                api_name_func:@"modifyAuthorInfo"
                                     api_name:@"ApiAuthorInfoV2"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:PhoneNumber
                                                 forKey:@"phonenumber"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:accountnumber
                                                 forKey:@"accountnumber"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:accountname
                                                 forKey:@"accountname"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:bankname
                                                 forKey:@"bankname"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
}

//飞机票的城市查询
- (NLProtocolData*)getApiAirticketXML:(NSString*)firstLetter cityName:(NSString*)cityName
{
    NLProtocolData *pd= [[NLProtocolData alloc]initValue:nil forKey:@"operation_request" attr:nil attrName:nil valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData *hearder= [self defaultMsgheader];
    
    [pd addChild:hearder];
    
    [hearder addChild:[self defaultChannelinfo:YES api_name_func:@"getCity" api_name:@"ApiAirticket"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:firstLetter
                                                 forKey:@"firstLetter"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:cityName
                                                 forKey:@"cityName"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];

    
    return pd;
}

//航班查询
- (NLProtocolData*)getApigetAirlineXML:(NSString*)departCityCode arriveCityCode:(NSString*)arriveCityCode departDate:(NSString*)departDate returnDate:(NSString*)returnDate searchType:(NSString*)searchType{
    
    NLProtocolData *pd= [[NLProtocolData alloc]initValue:nil forKey:@"operation_request" attr:nil attrName:nil valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData *hearder= [self defaultMsgheader];
    
    [pd addChild:hearder];
    
    [hearder addChild:[self defaultChannelinfo:YES api_name_func:@"getAirline" api_name:@"ApiAirticket"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:departCityCode
                                                 forKey:@"departCityCode"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:arriveCityCode
                                                 forKey:@"arriveCityCode"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:departDate
                                                 forKey:@"departDate"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:returnDate
                                                 forKey:@"returnDate"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:searchType
                                                 forKey:@"searchType"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
}

//菜单模板读取
- (NLProtocolData*)getApireadMenuModuleXML:(NSString*)paycardkey appversion:(NSString*)appversion{
    
    NLProtocolData *pd= [[NLProtocolData alloc]initValue:nil forKey:@"operation_request" attr:nil attrName:nil valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData *hearder= [self defaultMsgheader];
    
    [pd addChild:hearder];
    
    [hearder addChild:[self defaultChannelinfo:YES api_name_func:@"readMenuModule" api_name:@"ApiAppInfo"]];
    
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:paycardkey
                                                forKey:@"paycardkey"
                                                  attr:nil
                                              attrName:nil
                                             valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:appversion
                                                 forKey:@"appversion"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;
  
}

//菜单模板点击次数
- (NLProtocolData*)getApireadMenutapCountXML:(NSString*)appmnuid agentno:(NSString*)agentno
{
    NLProtocolData *pd= [[NLProtocolData alloc]initValue:nil forKey:@"operation_request" attr:nil attrName:nil valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData *hearder= [self defaultMsgheader];
    
    [pd addChild:hearder];
    
    [hearder addChild:[self defaultChannelinfo:YES api_name_func:@"authorMenuCount" api_name:@"ApiAppInfo"]];
    
    //operation_request/msgbody
    NLProtocolData* msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:appmnuid
                                                 forKey:@"appmnuid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:agentno
                                                 forKey:@"agentno"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    return pd;

}

//商户读取代理商信息
- (NLProtocolData *)getApiAgentInfoXML
{
   NLProtocolData *pd= [[NLProtocolData alloc]initValue:nil forKey:@"operation_request" attr:nil attrName:nil valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData *hearder = [self defaultMsgheader];
    
    [pd addChild:hearder];
    
    [hearder addChild:[self defaultChannelinfo:YES api_name_func:@"readauthorareaagent" api_name:@"ApiAgentInfo"]];
    
    //operation_request/msgbody

    [pd addChild:[[NLProtocolData alloc] initValue:nil
                                            forKey:@"msgbody"
                                              attr:nil
                                          attrName:nil
                                         valueType:NLProtocolDataValueNoCData]];
    
    return pd;
}

//代理商申请省
- (NLProtocolData *)getApiAgentApplyWithProvXML
{
    NLProtocolData *pd = [[NLProtocolData alloc]initValue:nil forKey:@"operation_request" attr:nil attrName:nil valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData *hearder = [self defaultMsgheader];
    
    [pd addChild:hearder];
    
    [hearder addChild:[self defaultChannelinfo:YES api_name_func:@"readChinaProv" api_name:@"ApiAgentApply"]];
    
    //operation_request/msgbody
    [pd addChild:[[NLProtocolData alloc] initValue:nil
                                            forKey:@"msgbody"
                                              attr:nil
                                          attrName:nil
                                         valueType:NLProtocolDataValueNoCData]];
    
    return pd;
}

//代理商申请市
- (NLProtocolData *)getApiAgentApplyWithCityXML:(NSString *)city
{
    NSLog(@"city = %@",city);
    
    NLProtocolData *pd = [[NLProtocolData alloc]initValue:nil forKey:@"operation_request" attr:nil attrName:nil valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData *hearder = [self defaultMsgheader];
    
    [pd addChild:hearder];
    
    [hearder addChild:[self defaultChannelinfo:YES api_name_func:@"readChinaCity" api_name:@"ApiAgentApply"]];
    
    //operation_request/msgbody
    NLProtocolData *msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                            forKey:@"msgbody"
                                              attr:nil
                                          attrName:nil
                                         valueType:NLProtocolDataValueNoCData]];
    
    NLProtocolData *da =  [msgbody addChild:[[NLProtocolData alloc] initValue:city
                                                 forKey:@"prov"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    NSLog(@"da = %@",da.value);
    
    return pd;
}

//代理商申请区
- (NLProtocolData *)getApiAgentApplyWithTownXML:(NSString *)city town:(NSString *)town
{
    NLProtocolData *pd = [[NLProtocolData alloc]initValue:nil forKey:@"operation_request" attr:nil attrName:nil valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData *hearder = [self defaultMsgheader];
    
    [pd addChild:hearder];
    
    [hearder addChild:[self defaultChannelinfo:YES api_name_func:@"readChinaTown" api_name:@"ApiAgentApply"]];
    
    //operation_request/msgbody
    NLProtocolData *msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:city
                                                 forKey:@"prov"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:town
                                                 forKey:@"city"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    return pd;
}

//代理商申请
- (NLProtocolData *)getApiAgentApplyAddWithXML:(NSString *)custypeid name:(NSString *)name address:(NSString *)address prov:(NSString *)prov city:(NSString *)city town:(NSString *)town
{
    NLProtocolData *pd= [[NLProtocolData alloc]initValue:nil forKey:@"operation_request" attr:nil attrName:nil valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData *hearder = [self defaultMsgheader];
    
    [pd addChild:hearder];
    
    [hearder addChild:[self defaultChannelinfo:YES api_name_func:@"insertapplyAgent" api_name:@"ApiAgentApply"]];
    
    //operation_request/msgbody
    NLProtocolData *msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:custypeid
                                                 forKey:@"custypeid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:name
                                                 forKey:@"name"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:address
                                                 forKey:@"address"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:prov
                                                 forKey:@"prov"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:city
                                                 forKey:@"city"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:town
                                                 forKey:@"town"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    return pd;
}

//代理商申请信息
- (NLProtocolData *)getApiAgentApplyXML
{
    NLProtocolData *pd= [[NLProtocolData alloc]initValue:nil forKey:@"operation_request" attr:nil attrName:nil valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData *hearder = [self defaultMsgheader];
    
    [pd addChild:hearder];
    
    [hearder addChild:[self defaultChannelinfo:YES api_name_func:@"readAgentbasinfo" api_name:@"ApiAgentApply"]];
    
    //operation_request/msgbody
    NLProtocolData *msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:@""
                                                 forKey:@"prov"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    return pd;
}

//绑定代理商
- (NLProtocolData *)getApiAgentInfoBindXML:(NSString *)agentNo
{
    NLProtocolData *pd= [[NLProtocolData alloc]initValue:nil forKey:@"operation_request" attr:nil attrName:nil valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData *hearder = [self defaultMsgheader];
    
    [pd addChild:hearder];
    
    [hearder addChild:[self defaultChannelinfo:YES api_name_func:@"authorBindAgent" api_name:@"ApiAgentInfo"]];
    
    //operation_request/msgbody
    NLProtocolData *msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:@""
                                                 forKey:@"querytype"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:agentNo
                                                 forKey:@"agentno"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    return pd;
}

//虚拟代理商
- (NLProtocolData *)getApiAgentApplyInsertParttXML
{
    NLProtocolData *pd= [[NLProtocolData alloc]initValue:nil forKey:@"operation_request" attr:nil attrName:nil valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData *hearder = [self defaultMsgheader];
    
    [pd addChild:hearder];
    
    [hearder addChild:[self defaultChannelinfo:YES api_name_func:@"insertParttimeagent" api_name:@"ApiAgentApply"]];
    
    [pd addChild:[[NLProtocolData alloc] initValue:nil
                                            forKey:@"msgbody"
                                              attr:nil
                                          attrName:nil
                                         valueType:NLProtocolDataValueNoCData]];
    
    return pd;
}

//读取新的信息
- (NLProtocolData *)getApiAppInfoXML
{
    NLProtocolData *pd= [[NLProtocolData alloc]initValue:nil forKey:@"operation_request" attr:nil attrName:nil valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData *hearder = [self defaultMsgheader];
    
    [pd addChild:hearder];
    
    [hearder addChild:[self defaultChannelinfo:YES api_name_func:@"readNewNotice" api_name:@"ApiAppInfo"]];

    [pd addChild:[[NLProtocolData alloc] initValue:nil
                                            forKey:@"msgbody"
                                              attr:nil
                                          attrName:nil
                                         valueType:NLProtocolDataValueNoCData]];
    
    return pd;
}

//读取用户银行卡列表
- (NLProtocolData *)getApiAuthorKuaibkcardInfoListsXML
{
    NLProtocolData *pd= [[NLProtocolData alloc]initValue:nil forKey:@"operation_request" attr:nil attrName:nil valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData *hearder = [self defaultMsgheader];
    
    [pd addChild:hearder];
    
    [hearder addChild:[self defaultChannelinfo:YES api_name_func:@"readKuaibkcardLists" api_name:@"ApiAuthorKuaibkcardInfo"]];
    
    //operation_request/msgbody
    NLProtocolData *msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    
    return pd;
}

//添加新的银行卡
- (NLProtocolData *)getApiAuthorKuaibkcardInfoAddXML:(NSString *)bkcardbankid bkcardbank:(NSString *)bkcardbank bkcardno:(NSString *)bkcardno bkcardbankman:(NSString *)bkcardbankman bkcardbankphone:(NSString *)bkcardbankphone bkcardyxmonth:(NSString *)bkcardyxmonth bkcardyxyear:(NSString *)bkcardyxyear bkcardcvv:(NSString *)bkcardcvv bkcardidcard:(NSString *)bkcardidcard bkcardcardtype:(NSString *)bkcardcardtype bkcardisdefault:(NSString *)bkcardisdefault
{
    NLProtocolData *pd= [[NLProtocolData alloc]initValue:nil forKey:@"operation_request" attr:nil attrName:nil valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData *hearder = [self defaultMsgheader];
    
    [pd addChild:hearder];
    
    [hearder addChild:[self defaultChannelinfo:YES api_name_func:@"AddKuaibkcard" api_name:@"ApiAuthorKuaibkcardInfo"]];
    
    //operation_request/msgbody
    NLProtocolData *msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:bkcardbankid
                                                 forKey:@"bkcardbankid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:bkcardbank
                                                 forKey:@"bkcardbank"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:bkcardno
                                                 forKey:@"bkcardno"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:bkcardbankman
                                                 forKey:@"bkcardbankman"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:bkcardbankphone
                                                 forKey:@"bkcardbankphone"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:bkcardyxmonth
                                                 forKey:@"bkcardyxmonth"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:bkcardyxyear
                                                 forKey:@"bkcardyxyear"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:bkcardcvv
                                                 forKey:@"bkcardcvv"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:bkcardidcard
                                                 forKey:@"bkcardidcard"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:bkcardcardtype
                                                 forKey:@"bkcardcardtype"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:bkcardisdefault
                                                 forKey:@"bkcardisdefault"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    return pd;
}

//修改银行卡
- (NLProtocolData *)getApiAuthorKuaibkcardInfoEditXML:(NSString *)bkcardid bkcardbankid:(NSString *)bkcardbankid bkcardbank:(NSString *)bkcardbank bkcardno:(NSString *)bkcardno bkcardbankman:(NSString *)bkcardbankman bkcardbankphone:(NSString *)bkcardbankphone bkcardyxmonth:(NSString *)bkcardyxmonth bkcardyxyear:(NSString *)bkcardyxyear bkcardcvv:(NSString *)bkcardcvv bkcardidcard:(NSString *)bkcardidcard bkcardcardtype:(NSString *)bkcardcardtype bkcardisdefault:(NSString *)bkcardisdefault
{
    NLProtocolData *pd= [[NLProtocolData alloc]initValue:nil forKey:@"operation_request" attr:nil attrName:nil valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData *hearder = [self defaultMsgheader];
    
    [pd addChild:hearder];
    
    [hearder addChild:[self defaultChannelinfo:YES api_name_func:@"EditKuaibkcard" api_name:@"ApiAuthorKuaibkcardInfo"]];
    
    //operation_request/msgbody
    NLProtocolData *msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:bkcardid
                                                 forKey:@"bkcardid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:bkcardbankid
                                                 forKey:@"bkcardbankid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:bkcardbank
                                                 forKey:@"bkcardbank"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:bkcardno
                                                 forKey:@"bkcardno"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:bkcardbankman
                                                 forKey:@"bkcardbankman"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:bkcardbankphone
                                                 forKey:@"bkcardbankphone"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:bkcardyxmonth
                                                 forKey:@"bkcardyxmonth"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:bkcardyxyear
                                                 forKey:@"bkcardyxyear"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:bkcardcvv
                                                 forKey:@"bkcardcvv"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:bkcardidcard
                                                 forKey:@"bkcardidcard"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:bkcardcardtype
                                                 forKey:@"bkcardcardtype"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:bkcardisdefault
                                                 forKey:@"bkcardisdefault"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    return pd;

}

//移除银行卡
- (NLProtocolData *)getApiAuthorKuaibkcardInfoDeleteXML:(NSString *)bkcardid
{
    NLProtocolData *pd= [[NLProtocolData alloc]initValue:nil forKey:@"operation_request" attr:nil attrName:nil valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData *hearder = [self defaultMsgheader];
    
    [pd addChild:hearder];
    
    [hearder addChild:[self defaultChannelinfo:YES api_name_func:@"DeleteKuaibkcard" api_name:@"ApiAuthorKuaibkcardInfo"]];
    
    //operation_request/msgbody
    NLProtocolData *msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:bkcardid
                                                 forKey:@"bkcardid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    return pd;
}

//绑定银行卡
- (NLProtocolData *)getApiAuthorKuaibkcardInfoDefaultXML:(NSString *)bkcardid bkcardisdefault:(NSString *)bkcardisdefault
{
    NLProtocolData *pd= [[NLProtocolData alloc]initValue:nil forKey:@"operation_request" attr:nil attrName:nil valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData *hearder = [self defaultMsgheader];
    
    [pd addChild:hearder];
    
    [hearder addChild:[self defaultChannelinfo:YES api_name_func:@"DefaultKuaibkcard" api_name:@"ApiAuthorKuaibkcardInfo"]];
    
    //operation_request/msgbody
    NLProtocolData *msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:bkcardid
                                                 forKey:@"bkcardid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:bkcardisdefault
                                                 forKey:@"bkcardisdefault"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    return pd;
}

/*易宝手机充值*/
- (NLProtocolData *)getApiYiBaoPhonePayXML:(NSString *)rechargeMoney payMoney:(NSString *)payMoney rechargePhone:(NSString *)rechargePhone  bankCardId:(NSString *)bankCardId bankId:(NSString *)bankId manCardId:(NSString *)manCardId payPhone:(NSString *)payPhone manName:(NSString *)manName expireYear:(NSString *)expireYear expireMonth:(NSString *)expireMonth cvv:(NSString *)cvv mobileProvince:(NSString *)mobileProvince paycardid:(NSString *)paycardid
{
    NLProtocolData *pd = [[NLProtocolData alloc]initValue:nil forKey:@"operation_request" attr:nil attrName:nil valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData *hearder = [self defaultMsgheader];
    
    [pd addChild:hearder];
    
    [hearder addChild:[self defaultChannelinfo:YES api_name_func:@"PayWithCreditCard" api_name:@"ApiMobileRechargeInfoV2"]];
    
    //operation_request/msgbody
    NLProtocolData *msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
   
    [msgbody addChild:[[NLProtocolData alloc] initValue:rechargeMoney
                                                 forKey:@"rechargeMoney"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:payMoney
                                                 forKey:@"payMoney"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:rechargePhone
                                                 forKey:@"rechargePhone"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:bankCardId
                                                 forKey:@"bankCardId"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:bankId
                                                 forKey:@"bankId"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:manCardId
                                                 forKey:@"manCardId"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:payPhone
                                                 forKey:@"payPhone"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:manName
                                                 forKey:@"manName"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:expireYear
                                                 forKey:@"expireYear"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:expireMonth
                                                 forKey:@"expireMonth"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:cvv
                                                 forKey:@"cvv"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:mobileProvince
                                                 forKey:@"mobileProvince"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:paycardid
                                                 forKey:@"paycardid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];

    return pd;
}

/*易宝手机验证码接口*/
- (NLProtocolData *)getApiYiBaoVerifyCodeXML:(NSString *)orderId verifyCode:(NSString*)verifyCode
{
    NLProtocolData *pd= [[NLProtocolData alloc]initValue:nil forKey:@"operation_request" attr:nil attrName:nil valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData *hearder = [self defaultMsgheader];
    
    [pd addChild:hearder];
    
    [hearder addChild:[self defaultChannelinfo:YES api_name_func:@"PayWithVerifyCode" api_name:@"ApiMobileRechargeInfoV2"]];
    
    //operation_request/msgbody
    NLProtocolData *msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:orderId
                                                 forKey:@"orderId"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:verifyCode
                                                 forKey:@"verifyCode"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    return pd;
}

/*易宝信用卡转账 前面两个要double默认转string类型*/
- (NLProtocolData *)getApiTransferWithCreditCardXML:(NSString *)payMoney transferMoney:(NSString *)transferMoney receiveBankCardId:(NSString *)receiveBankCardId  receiveBankName:(NSString *)receiveBankName receivePhone:(NSString *)receivePhone receivePersonName:(NSString *)receivePersonName cardReaderId:(NSString *)cardReaderId sendBankCardId:(NSString *)sendBankCardId sendBankCode:(NSString *)sendBankCode personCardId:(NSString *)personCardId sendPhone:(NSString *)sendPhone sendPersonName:(NSString *)sendPersonName  expireYear:(NSString *)expireYear expireMonth:(NSString *)expireMonth cvv:(NSString *)cvv transferType:(NSString *)transferType arriveid:(NSString*)arriveid sendBankName:(NSString*)sendBankName payType:(NSString*)payType paycardid:(NSString*)paycardid
{

    NLProtocolData *pd = [[NLProtocolData alloc]initValue:nil forKey:@"operation_request" attr:nil attrName:nil valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData *hearder = [self defaultMsgheader];
    
    [pd addChild:hearder];
    
    [hearder addChild:[self defaultChannelinfo:YES api_name_func:@"TransferWithCreditCard" api_name:@"ApiTransferMoney"]];
    
    //operation_request/msgbody
    NLProtocolData *msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:payMoney
                                                 forKey:@"payMoney"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:transferMoney
                                                 forKey:@"transferMoney"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:receiveBankCardId
                                                 forKey:@"receiveBankCardId"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:receiveBankName
                                                 forKey:@"receiveBankName"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:receivePhone
                                                 forKey:@"receivePhone"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:receivePersonName
                                                 forKey:@"receivePersonName"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:cardReaderId
                                                 forKey:@"cardReaderId"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:sendBankCardId
                                                 forKey:@"sendBankCardId"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:sendBankCode
                                                 forKey:@"sendBankCode"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:personCardId
                                                 forKey:@"personCardId"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:sendPhone
                                                 forKey:@"sendPhone"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:sendPersonName
                                                 forKey:@"sendPersonName"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:expireYear
                                                 forKey:@"expireYear"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:expireMonth
                                                 forKey:@"expireMonth"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:cvv
                                                 forKey:@"cvv"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:transferType
                                                 forKey:@"transferType"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:arriveid
                                                 forKey:@"arriveid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:sendBankName
                                                 forKey:@"sendBankName"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:payType
                                                 forKey:@"payType"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:paycardid
                                                 forKey:@"paycardid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    return pd;
    
}

/*易宝转账验证码*/
- (NLProtocolData *)getApiPayWithVerifyCodeXML:(NSString *)orderId verifyCode:(NSString*)verifyCode
{
    NLProtocolData *pd= [[NLProtocolData alloc]initValue:nil forKey:@"operation_request" attr:nil attrName:nil valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData *hearder = [self defaultMsgheader];
    
    [pd addChild:hearder];
    
    [hearder addChild:[self defaultChannelinfo:YES api_name_func:@"TransferWithVerifyCode" api_name:@"ApiTransferMoney"]];
    
    //operation_request/msgbody
    NLProtocolData *msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:orderId
                                                 forKey:@"orderId"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:verifyCode
                                                 forKey:@"verifyCode"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    return pd;
}

/*易宝游戏充值*/
- (NLProtocolData *)ApiGamePayWithCreditCardXML:(NSString *)gameId gameName:(NSString *)gameName area:(NSString *)area  server:(NSString *)server quantity:(NSString *)quantity price:(NSString *)price cost:(NSString *)cost userCount:(NSString *)userCount paycardid:(NSString *)paycardid bankCardId:(NSString *)bankCardId bankId:(NSString *)bankId manCardId:(NSString *)manCardId  payPhone:(NSString *)payPhone manName:(NSString *)manName expireYear:(NSString *)expireYear expireMonth:(NSString *)expireMonth cvv:(NSString *)cvv

{
    NLProtocolData *pd= [[NLProtocolData alloc]initValue:nil forKey:@"operation_request" attr:nil attrName:nil valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData *hearder = [self defaultMsgheader];
    
    [pd addChild:hearder];
    
    [hearder addChild:[self defaultChannelinfo:YES api_name_func:@"PayWithCreditCard" api_name:@"ApiGameRecharge"]];
    
    //operation_request/msgbody
    NLProtocolData *msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:gameId
                                                 forKey:@"gameId"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:gameName
                                                 forKey:@"gameName"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:area
                                                 forKey:@"area"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:server
                                                 forKey:@"server"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:quantity
                                                 forKey:@"quantity"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:price
                                                 forKey:@"price"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:cost
                                                 forKey:@"cost"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:userCount
                                                 forKey:@"userCount"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:paycardid
                                                 forKey:@"paycardid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:bankCardId
                                                 forKey:@"bankCardId"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:bankId
                                                 forKey:@"bankId"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:manCardId
                                                 forKey:@"manCardId"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:payPhone
                                                 forKey:@"payPhone"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:manName
                                                 forKey:@"manName"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:expireYear
                                                 forKey:@"expireYear"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:expireMonth
                                                 forKey:@"expireMonth"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    [msgbody addChild:[[NLProtocolData alloc] initValue:cvv
                                                 forKey:@"cvv"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
      return pd;
    
}

/*易宝游戏验证码*/
- (NLProtocolData *)getApiGamePayWithVerifyCodeXML:(NSString *)orderId verifyCode:(NSString*)verifyCode
{
    NLProtocolData *pd= [[NLProtocolData alloc]initValue:nil forKey:@"operation_request" attr:nil attrName:nil valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData *hearder = [self defaultMsgheader];
    
    [pd addChild:hearder];
    
    [hearder addChild:[self defaultChannelinfo:YES api_name_func:@"PayWithVerifyCode" api_name:@"ApiGameRecharge"]];
    
    //operation_request/msgbody
    NLProtocolData *msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:orderId
                                                 forKey:@"orderId"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:verifyCode
                                                 forKey:@"verifyCode"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    return pd;
}


/*话费是否可以充值*/
- (NLProtocolData *)getApiCanRechargeXML:(NSString *)money phone:(NSString*)phone
{
    NLProtocolData *pd= [[NLProtocolData alloc]initValue:nil forKey:@"operation_request" attr:nil attrName:nil valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData *hearder = [self defaultMsgheader];
    
    [pd addChild:hearder];
    
    [hearder addChild:[self defaultChannelinfo:YES api_name_func:@"CanRecharge" api_name:@"ApiMobileRechargeInfoV2"]];
    
    //operation_request/msgbody
    NLProtocolData *msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:money
                                                 forKey:@"money"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:phone
                                                 forKey:@"phone"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    return pd;
    
}

/*读取快捷支付默认信用卡号*/
- (NLProtocolData *)getApiPaychannelInfoXML:(NSString *)bkcardid bkcardisdefault:(NSString*)bkcardisdefault
{
    NLProtocolData *pd= [[NLProtocolData alloc]initValue:nil forKey:@"operation_request" attr:nil attrName:nil valueType:NLProtocolDataValueNoCData];
    
    //operation_request/msgheader
    NLProtocolData *hearder = [self defaultMsgheader];
    
    [pd addChild:hearder];
    
    [hearder addChild:[self defaultChannelinfo:YES api_name_func:@"readKuaipaybkcardInfo" api_name:@"ApiPaychannelInfo"]];
    
    //operation_request/msgbody
    NLProtocolData *msgbody = [pd addChild:[[NLProtocolData alloc] initValue:nil
                                                                      forKey:@"msgbody"
                                                                        attr:nil
                                                                    attrName:nil
                                                                   valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:bkcardid
                                                 forKey:@"bkcardid"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    [msgbody addChild:[[NLProtocolData alloc] initValue:bkcardisdefault
                                                 forKey:@"bkcardisdefault"
                                                   attr:nil
                                               attrName:nil
                                              valueType:NLProtocolDataValueNoCData]];
    
    return pd;
    
}

@end















