//
//  NLProtocolRequest.m
//  TongFubao
//
//  Created by MD313 on 13-8-16.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLProtocolRequest.h"
#import "NLProtocolXML.h"
#import "NLProtocolNotify.h"
#import "NLProtocolRegister.h"
#import "NLProtocolData.h"
#import "ProtocolRequest.h"
#import "ProtocolDefine.h"
#import "NLContants.h"

//static NLProtocolRequest* gProtocolRequest = nil;

@interface NLProtocolRequest ()
{
    ProtocolRequest* _request;
}

@property (nonatomic,assign)BOOL myRegister;

@end

@implementation NLProtocolRequest

-(id)initWithRegister:(BOOL)reg
{
    self=[super init];
    if (self)
    {
        _request = [[ProtocolRequest alloc] init];
        self.myRegister = reg;
    }
    return self;
}

-(id)initWithURL:(NSString *)url content:(NSData *)content
{
    self=[super init];
    if (self)
    {
        _request = [[ProtocolRequest alloc] init];
        [_request setPostType:NLProtocolRequestPost_Picture];
        [_request setMyLength:[content length]];
        [_request startRequestWithURL:url content:content];
    }
    return self;
}

//+(id)shareProtocolRequestWithRegister:(BOOL)reg
//{
//    if (gProtocolRequest == nil)
//    {
//        gProtocolRequest = [[NLProtocolRequest alloc] init];
//    }
//    gProtocolRequest.myRegister = reg;
//    return gProtocolRequest;
//}

-(void)stopRequest:(NSString*)flag
{
    [_request/*[[ProtocolRequest alloc] init]*/ stopRequest:flag];
}

#pragma mark - NLProtocolRequest
-(BOOL)preRequest:(NLProtocolRequestType)type name:(NSString*)name
{
    BOOL send = NO;
    
    if (self.myRegister/*gProtocolRequest.myRegister*/)
    {
        send = [[NLProtocolRegister shareProtocolRegister] registRequest:type];
    }
    
    [[NLProtocolNotify shareProtocolNotify] addNotify:type];
    
    if (send)
    {
        [_request/*[[ProtocolRequest alloc] init]*/ startRequestError:name];
    }
    
    return send;
}

/***
 用户注册短信校验码获取
 */
-(void)getSmsCode:(NSString*)mobile
{
    BOOL send = [self preRequest:NLProtocolRequest_getSmsCode name:Notify_getSmsCode];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] getSmsCodeXML:mobile];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_getSmsCode];
    }
}

/***
 用户注册短信校验成功后注册资料登记
 */
-(void)authorReg:(NSString*)mobile password:(NSString*)password name:(NSString*)name idCard:(NSString*)idCard email:(NSString*)email
{
    BOOL send = [self preRequest:NLProtocolRequest_authorReg name:Notify_authorReg];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] authorRegXML:mobile password:password name:name idCard:idCard email:email];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_authorReg];
    }
}

/***
 用户密码修改
 */
-(void)authorPwdModify:(NSString*)oldPW newPW:(NSString*)newPW type:(NSString*)type reset:(NSString*)reset
{
    BOOL send = [self preRequest:NLProtocolRequest_authorPwdModify name:Notify_authorPwdModify];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] authorPwdModifyXML:oldPW newPW:newPW type:type reset:reset];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_authorPwdModify];
    }
}

/***
 用户意见反馈
 */
-(void)authorFeedbck:(NSString*)content contact:(NSString*)contact
{
    BOOL send = [self preRequest:NLProtocolRequest_authorFeedbck name:Notify_authorFeedbck];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] authorFeedbckXML:content contact:contact];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_authorFeedbck];
    }
}

/***
 版本更新
 */
-(void)checkAppVersion:(NSString*)type version:(NSString*)version
{
    BOOL send = [self preRequest:NLProtocolRequest_checkAppVersion name:Notify_checkAppVersion];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] checkAppVersionXML:type version:version];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_checkAppVersion];
    }
}

/***
 读取用户信息 (代理商信息)
 */
-(void)readAuthorInfo
{
    BOOL send = [self preRequest:NLProtocolRequest_readAuthorInfo name:Notify_readAuthorInfo];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] readAuthorInfoXML];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_readAuthorInfo];
    }
}

/***
 用户身份证图片上传
 */
-(void)uploadAuthorPic:(NSString*)picid picpath:(NSString*)picpath uploadmethod:(NSString*)uploadmethod uploadpictype:(NSString*)uploadpictype uploadmark:(NSString*)uploadmark
{
    BOOL send = [self preRequest:NLProtocolRequest_uploadAuthorPic name:Notify_uploadAuthorPic];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] uploadAuthorPicXML:picid picpath:picpath uploadmethod:uploadmethod uploadpictype:uploadpictype uploadmark:uploadmark];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_uploadAuthorPic];
    }
}

/***
 修改用户信息(代理商)
 */
-(void)modifyAuthorInfo:(NSString*)name idCard:(NSString*)idCard email:(NSString*)email agentcompany:(NSString*)agentcompany agentarea:(NSString*)agentarea  agentaddress:(NSString*)agentaddress agentmanphone:(NSString*)agentmanphone agentfax:(NSString*)agentfax
{
    BOOL send = [self preRequest:NLProtocolRequest_modifyAuthorInfo name:Notify_modifyAuthorInfo];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] modifyAuthorInfoXML:name idCard:idCard email:email agentcompany:agentcompany agentarea:agentarea agentaddress:agentaddress agentmanphone:agentmanphone agentfax:agentfax];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_modifyAuthorInfo];
    }
}

/***
 登录管理
 */
-(void)checkAuthorLogin:(NSString*)userName password:(NSString*)password auloginmethod:(NSString*)auloginmethod mpmodel:(NSString*)mpmodel
{
    BOOL send = [self preRequest:NLProtocolRequest_checkAuthorLogin name:Notify_checkAuthorLogin];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] checkAuthorLoginXML:userName password:password auloginmethod:auloginmethod mpmodel:mpmodel];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_checkAuthorLogin];
    }
}

/***
 忘记密码短信校验码获取
 */
-(void)getSmsCodeInfo:(NSString*)mobile
{
    BOOL send = [self preRequest:NLProtocolRequest_getSmsCodeInfo name:Notify_getSmsCodeInfo];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] getSmsCodeInfoXML:mobile];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_getSmsCodeInfo];
    }
}

/***
 忘记密码修改
 */
-(void)forgetPwdModify:(NSString*)aumobile aunewpwd:(NSString*)aunewpwd aurenewpwd:(NSString*)aurenewpwd  aumoditype:(NSString*)aumoditype
{
    BOOL send = [self preRequest:NLProtocolRequest_forgetPwdModify name:Notify_forgetPwdModify];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] forgetPwdModifyXML:aumobile aunewpwd:aunewpwd aurenewpwd:aurenewpwd  aumoditype:aumoditype];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_forgetPwdModify];
    }
}

/***
 帮助中心列表显示
 */
-(void)readHelpList:(NSString*)start display:(NSString*)display
{
    BOOL send = [self preRequest:NLProtocolRequest_readHelpList name:Notify_readHelpList];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] readHelpListXML:start display:display];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_readHelpList];
    }
}

/***
 我的钱包
 */
-(void)readMyAccount
{
    BOOL send = [self preRequest:NLProtocolRequest_readMyAccount name:Notify_readMyAccount];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] readMyAccountXML];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_readMyAccount];
    }
}

/***
 我的钱包收支明细
 */
-(void)readAccglist:(NSString*)acctypeid
{
    BOOL send = [self preRequest:NLProtocolRequest_readAccglist name:Notify_readAccglist];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] readAccglistXML:acctypeid];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_readAccglist];
    }
}

/***
 我的钱包收支详情
 */
-(void)readAccglistdetail:(NSString*)acctypeid month:(NSString*)month
{
    BOOL send = [self preRequest:NLProtocolRequest_readAccglistdetail name:Notify_readAccglistdetail];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] readAccglistdetailXML:acctypeid month:month];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_readAccglistdetail];
    }
}

/***
 短信校验码获取
 */
-(void)getSmsVerifyCode:(NSString*)mobile
{
    BOOL send = [self preRequest:NLProtocolRequest_getSmsVerifyCode name:Notify_getSmsVerifyCode];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] getSmsVerifyCodeXML:mobile];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_getSmsVerifyCode];
    }
}

/***
 信用卡还款
 */
-(void)readCreditCardfee:(NSString*)type amount:(NSString*)amount bankID:(NSString*)bankID cardID:(NSString*)cardID
{
    BOOL send = [self preRequest:NLProtocolRequest_readCreditCardfee name:Notify_readCreditCardfee];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] readCreditCardfeeXML:type amount:amount bankID:bankID cardID:cardID];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_readCreditCardfee];
    }
}

/***
 信用卡还款支付成功
 */
-(void)insertcreditCardMoney:(NSString*)bkntno result:(NSString*)result
{
    BOOL send = [self preRequest:NLProtocolRequest_insertcreditCardMoney name:Notify_insertcreditCardMoney];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] insertcreditCardMoneyXML:bkntno result:result];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_insertcreditCardMoney];
    }
}

/***
 读取信用卡还款记录
 */
-(void)readCreditCardglist:(NSString*)paytype msgstart:(NSString*)msgstart msgdisplay:(NSString*)msgdisplay
{
    BOOL send = [self preRequest:NLProtocolRequest_readCreditCardglist name:Notify_readCreditCardglist];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] readCreditCardglistXML:paytype msgstart:msgstart msgdisplay:msgdisplay];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_readCreditCardglist];
    }
}

/***
 信用卡还款请求
 */
-(void)creditCardMoneyRq:(NSString*)paytype paymoney:(NSString*)paymoney shoucardno:(NSString*)shoucardno shoucardmobile:(NSString*)shoucardmobile shoucardman:(NSString*)shoucardman shoucardbank:(NSString*)shoucardbank fucardno:(NSString*)fucardno fucardbank:(NSString*)fucardbank fucardmobile:(NSString*)fucardmobile fucardman:(NSString*)fucardman current:(NSString*)current paycardid:(NSString*)paycardid merReserved:(NSString*)merReserved
{
    BOOL send = [self preRequest:NLProtocolRequest_creditCardMoneyRq name:Notify_creditCardMoneyRq];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] creditCardMoneyRqXML:paytype paymoney:paymoney shoucardno:shoucardno shoucardmobile:shoucardmobile shoucardman:shoucardman shoucardbank:shoucardbank fucardno:fucardno fucardbank:fucardbank fucardmobile:fucardmobile fucardman:fucardman current:current paycardid:paycardid merReserved:merReserved];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_creditCardMoneyRq];
    }
}

/***
 转账汇款
 */
-(void)readTransferMoneyfee:(NSString*)paytype paymoney:(NSString*)paymoney paybankid:(NSString*)paybankid paycardid:(NSString*)paycardid
{
    BOOL send = [self preRequest:NLProtocolRequest_readTransferMoneyfee name:Notify_readTransferMoneyfee];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] readTransferMoneyfeeXML:paytype paymoney:paymoney paybankid:paybankid paycardid:paycardid];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_readTransferMoneyfee];
    }
}

/***
 转账汇款支付成功反馈
 */
-(void)insertTransferMoney:(NSString*)bkntno result:(NSString*)result
{
    BOOL send = [self preRequest:NLProtocolRequest_insertTransferMoney name:Notify_insertTransferMoney];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] insertTransferMoneyXML:bkntno result:result];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_insertTransferMoney];
    }
}

/***
 读取转账汇款记录
 */
-(void)readTransferMoneyglist:(NSString*)paytype msgstart:(NSString*)msgstart msgdisplay:(NSString*)msgdisplay
{
    BOOL send = [self preRequest:NLProtocolRequest_readTransferMoneyglist name:Notify_readTransferMoneyglist];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] readTransferMoneyglistXML:paytype msgstart:msgstart msgdisplay:msgdisplay];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_readTransferMoneyglist];
    }
}

/***
 转账汇款请求获得银行交易流水号
 */
-(void)transferMoneyRq:(NSString*)paycardid fucardno:(NSString*)fucardno fucardbank:(NSString*)fucardbank fucardman:(NSString*)fucardman fucardmobile:(NSString*)fucardmobile shoucardno:(NSString*)shoucardno shoucardbank:(NSString*)shoucardbank current:(NSString*)current paymoney:(NSString*)paymoney payfee:(NSString*)payfee money:(NSString*)money shoucardmobile:(NSString*)shoucardmobile shoucardman:(NSString*)shoucardman arriveid:(NSString*)arriveid shoucardmemo:(NSString*)shoucardmemo sendsms:(NSString*)sendsms merReserved:(NSString*)merReserved
{
    BOOL send = [self preRequest:NLProtocolRequest_transferMoneyRq name:Notify_transferMoneyRq];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] transferMoneyRqXML:paycardid fucardno:fucardno fucardbank:fucardbank fucardman:fucardman fucardmobile:fucardmobile shoucardno:shoucardno shoucardbank:shoucardbank current:current paymoney:paymoney payfee:payfee money:money shoucardmobile:shoucardmobile shoucardman:shoucardman arriveid:arriveid shoucardmemo:shoucardmemo sendsms:sendsms merReserved:merReserved];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_transferMoneyRq];
    }
}

/***
 转账汇款手续费计算
 */
-(void)getTransferPayfee:(NSString*)bankid money:(NSString*)money arriveid:(NSString*)arriveid
{
    BOOL send = [self preRequest:NLProtocolRequest_getTransferPayfee name:Notify_getTransferPayfee];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] getTransferPayfeeXML:bankid money:money arriveid:arriveid];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_getTransferPayfee];
    }
}

/***
 信贷还款
 */
-(void)readRepayMoneyfee:(NSString*)paytype paymoney:(NSString*)paymoney paybankid:(NSString*)paybankid paycardid:(NSString*)paycardid
{
    BOOL send = [self preRequest:NLProtocolRequest_readRepayMoneyfee name:Notify_readRepayMoneyfee];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] readRepayMoneyfeeXML:paytype paymoney:paymoney paybankid:paybankid paycardid:paycardid];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_readRepayMoneyfee];
    }
}

/***
 插入信贷还款记录
 */
-(void)insertRepayMoney:(NSString*)bkntno result:(NSString *)result
{
    BOOL send = [self preRequest:NLProtocolRequest_insertRepayMoney name:Notify_insertRepayMoney];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] insertRepayMoneyXML:bkntno result:result];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_insertRepayMoney];
    }
}

/***
 读取信贷还款历史记录
 */
-(void)readRepayMoneyglist:(NSString*)paytype msgstart:(NSString*)msgstart msgdisplay:(NSString*)msgdisplay
{
    BOOL send = [self preRequest:NLProtocolRequest_readRepayMoneyglist name:Notify_readRepayMoneyglist];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] readRepayMoneyglistXML:paytype msgstart:msgstart msgdisplay:msgdisplay];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_readRepayMoneyglist];
    }
}

/***
 充值接口 银联交易成功后反馈交易状态
 */
-(void)rechargeglist:(NSString*)banktype bankname:(NSString*)bankname bankno:(NSString*)bankno paymoney:(NSString*)paymoney
{
    BOOL send = [self preRequest:NLProtocolRequest_rechargeglist name:Notify_rechargeglist];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] rechargeglistXML:banktype bankname:bankname bankno:bankno paymoney:paymoney];
        NSLog(@"");
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_rechargeglist];
    }
}

/***
 充值接口请求获得交易流水号
 */
-(void)rechargeReq:(NSString*)banktype bankname:(NSString*)bankname cardno:(NSString*)cardno paymoney:(NSString*)paymoney cardmobile:(NSString*)cardmobile cardman:(NSString*)cardman sendsms:(NSString*)sendsms paycardid:(NSString*)paycardid merReserved:(NSString*)merReserved
{
    BOOL send = [self preRequest:NLProtocolRequest_rechargeReq name:Notify_rechargeReq];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] rechargeReqXML:banktype bankname:bankname cardno:cardno paymoney:paymoney cardmobile:cardmobile cardman:cardman sendsms:sendsms paycardid:paycardid merReserved:merReserved];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_rechargeReq];
    }
}

/***
 充值接口交易成功反馈
 */
-(void)rechargePay:(NSString*)bkntno result:(NSString*)result
{
    BOOL send = [self preRequest:NLProtocolRequest_rechargePay name:Notify_rechargePay];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] rechargePayXML:bkntno result:result];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_rechargePay];
    }
}

/***
 购买抵用券获得银行交易流水号
 */
-(void)couponSale:(NSString*)couponid couponmoney:(NSString*)couponmoney paycardid:(NSString*)paycardid creditcardno:(NSString*)creditcardno creditbank:(NSString*)creditbank creditcardman:(NSString*)creditcardman creditcardphone:(NSString*)creditcardphone merReserved:(NSString*)merReserved
{
    BOOL send = [self preRequest:NLProtocolRequest_couponSale name:Notify_couponSale];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] couponSaleXML:couponid couponmoney:couponmoney paycardid:paycardid creditcardno:creditcardno creditbank:creditbank creditcardman:creditcardman creditcardphone:creditcardphone merReserved:merReserved];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_couponSale];
    }
}

/***
 回购优惠券列表
 */
-(void)couponRebuylist
{
    BOOL send = [self preRequest:NLProtocolRequest_couponRebuylist name:Notify_couponRebuylist];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] couponRebuylistXML];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_couponRebuylist];
    }
}

/***
 回购优惠券操作
 */
-(void)couponRebuy:(NSString*)couponid couponno:(NSString*)couponno bankid:(NSString*)bankid banksub:(NSString*)banksub bankcardno:(NSString*)bankcardno cardname:(NSString*)cardname cardphone:(NSString*)cardphone couponfee:(NSString*)couponfee sxfmoney:(NSString*)sxfmoney getmoney:(NSString*)getmoney
{
    BOOL send = [self preRequest:NLProtocolRequest_couponRebuy name:Notify_couponRebuy];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] couponRebuyXML:couponid couponno:couponno bankid:bankid banksub:banksub bankcardno:bankcardno cardname:cardname cardphone:cardphone couponfee:couponfee sxfmoney:sxfmoney getmoney:getmoney];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_couponRebuy];
    }
}

/***
 读取银行列表
 */
-(void)readBankList:(NSString*)activemobilesms
{
    BOOL send = [self preRequest:NLProtocolRequest_readBankList name:Notify_readBankList];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] readBankListXML:activemobilesms];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_readBankList];
    }
}

/***
 读取银行列表(New分页显示)
 */
-(void)readBankListByPaging:(NSString*)activemobilesms msgstart :(NSString*)msgstart msgdisplay:(NSString*)msgdisplay querywhere:(NSString*)querywhere banktype:(NSString*)banktype  returnReadmode:(NSString *)newReturnReadmode;
{
    BOOL send = [self preRequest:NLProtocolRequest_readBankList name:Notify_readBankList];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] readBankListByPagingXML:activemobilesms msgstart:msgstart msgdisplay:msgdisplay querywhere:querywhere banktype:banktype readmode:newReturnReadmode];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_readBankList];
    }
}


/***
 读取首页广告列表
 */
-(void)readIndexAdList:(NSString*)msgadtype
{
    BOOL send = [self preRequest:NLProtocolRequest_readIndexAdList name:Notify_readIndexAdList];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] readIndexAdListXML:msgadtype];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_readIndexAdList];
    }
}

/***
 激活插卡器
 */
-(void)activePayCard:(NSString*)paycardkey
{
    BOOL send = [self preRequest:NLProtocolRequest_activePayCard name:Notify_activePayCard];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] activePayCardXML:paycardkey];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_activePayCard];
    }
}

/***
 余额查询
 */
-(void)readQueryCardMoney:(NSString*)bankcardno bankid:(NSString*)bankid bankname:(NSString*)bankname;
{
    BOOL send = [self preRequest:NLProtocolRequest_readQueryCardMoney name:Notify_readQueryCardMoney];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] readQueryCardMoneyXML:bankcardno bankid:bankid bankname:bankname];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_readQueryCardMoney];
    }
}

/***
 还贷款手续费计算
 */
-(void)getRepayMoneyPayfee:(NSString*)bankid money:(NSString*)money
{
    BOOL send = [self preRequest:NLProtocolRequest_getRepayMoneyPayfee name:Notify_getRepayMoneyPayfee];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] getRepayMoneyPayfeeXML:bankid money:money];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_getRepayMoneyPayfee];
    }
}

/***
 还贷款请求银行交易流水号
 */
-(void)RepayMoneyRq:(NSString*)paycardid fucardno:(NSString*)fucardno fucardmobile:(NSString*)fucardmobile fucardman:(NSString*)fucardman fucardbank:(NSString*)fucardbank shoucardno:(NSString*)shoucardno shoucardmobile:(NSString*)shoucardmobile shoucardman:(NSString*)shoucardman shoucardbank:(NSString*)shoucardbank current:(NSString*)current paymoney:(NSString*)paymoney payfee:(NSString*)payfee money:(NSString*)money
{
    BOOL send = [self preRequest:NLProtocolRequest_RepayMoneyRq name:Notify_RepayMoneyRq];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] RepayMoneyRqXML:paycardid fucardno:fucardno fucardmobile:fucardmobile fucardman:fucardman fucardbank:fucardbank shoucardno:shoucardno shoucardmobile:shoucardmobile shoucardman:shoucardman shoucardbank:shoucardbank current:current paymoney:paymoney payfee:payfee money:money];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_RepayMoneyRq];
    }
}

/***
 读取抵用券选项
 */
-(void)readcouponinfo
{
    BOOL send = [self preRequest:NLProtocolRequest_readcouponinfo name:Notify_readcouponinfo];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] readcouponinfoXML];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_readcouponinfo];
    }
}

/***
 购买抵用券支付成功
 */
-(void)couponSalePay:(NSString*)bkntno result:(NSString*)result
{
    BOOL send = [self preRequest:NLProtocolRequest_couponSalePay name:Notify_couponSalePay];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] couponSalePayXML:bkntno result:result];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_couponSalePay];
    }
}

/***
 抵用券历史列表
 */
-(void)couponSalelist:(NSString*)msgstart msgdisplay:(NSString*)msgdisplay
{
    BOOL send = [self preRequest:NLProtocolRequest_couponSalelist name:Notify_couponSalelist];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] couponSalelistXML:msgstart msgdisplay:msgdisplay];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_couponSalelist];
    }
}

/***
 刷卡器刷卡管理
 */
-(void)payCardCheck:(NSString*)paycardkey
{
    BOOL send = [self preRequest:NLProtocolRequest_payCardCheck name:Notify_payCardCheck];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] payCardCheckXML:paycardkey];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_payCardCheck];
        NSLog(@"刷卡器 PD%@",pd);
    }
}

/***
 获取协议/服务条款/关于我们信息
 */
-(void)readAppruleList:(NSString*)appruleid
{
    BOOL send = [self preRequest:NLProtocolRequest_readAppruleList name:Notify_readAppruleList];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] readAppruleListXML:appruleid];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_readAppruleList];
    }
}

/***
 功能模块菜单读取
 */
-(void)readMenuModule:(NSString*)paycardkey
{
    BOOL send = [self preRequest:NLProtocolRequest_readMenuModule name:Notify_readMenuModule];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] readMenuModuleXML:paycardkey];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_readMenuModule];
    }
}

/***
 快递查询
 */
-(void)kuaiState:(NSString*)kdtype kdcode:(NSString*)kdcode
{
    BOOL send = [self preRequest:NLProtocolRequest_kuaiState name:Notify_kuaiState];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] kuaiStateXML:kdtype kdcode:kdcode];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_kuaiState];
    }
}

/***
 读取快递公司列表
 */
-(void)readKuaiDicmpList
{
    BOOL send = [self preRequest:NLProtocolRequest_readKuaiDicmpList name:Notify_readKuaiDicmpList];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] readKuaiDicmpListXML];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_readKuaiDicmpList];
    }
}

/***
 查询快递公司订单号
 */
-(void)chaxunKuaiDiNo:(NSString*)com nu:(NSString*)nu
{
    BOOL send = [self preRequest:NLProtocolRequest_chaxunKuaiDiNo name:Notify_chaxunKuaiDiNo];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] chaxunKuaiDiNoXML:com nu:nu];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_chaxunKuaiDiNo];
    }
}

/***
 获取订单信息
 */
-(void)readOrderList:(NSString*)msgstart msgdisplay:(NSString*)msgdisplay orderno:(NSString*)orderno orderstate:(NSString*)orderstate querywhere:(NSString*)querywhere
{
    BOOL send = [self preRequest:NLProtocolRequest_readOrderList name:Notify_readOrderList];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] readOrderListXML:msgstart msgdisplay:msgdisplay orderno:orderno orderstate:orderstate querywhere:querywhere];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_readOrderList];
    }
}

/***
 支付订单获取银行卡获取银行流水号
 */
-(void)orderPayReq:(NSString*)orderid orderno:(NSString*)orderno paymoney:(NSString*)paymoney bankcardno:(NSString*)bankcardno bankname:(NSString*)bankname merReserved:(NSString*)merReserved
{
    BOOL send = [self preRequest:NLProtocolRequest_orderPayReq name:Notify_orderPayReq];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] orderPayReqXML:orderid orderno:orderno paymoney:paymoney bankcardno:bankcardno bankname:bankname merReserved:merReserved];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_orderPayReq];
    }
}

/***
 支付订单成功后反馈
 */
-(void)orderPayFeedback:(NSString*)request bkntno:(NSString *)bkntno
{
    BOOL send = [self preRequest:NLProtocolRequest_orderPayFeedback name:Notify_orderPayFeedback];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] orderPayFeedbackXML:request bkntno:bkntno];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_orderPayFeedback];
    }
}

/***
 支付订单获取银行卡星级评价
 */
-(void)orderPayBankCardStar:(NSString*)orderid orderno:(NSString*)orderno paymoney:(NSString*)paymoney bankcardno:(NSString*)bankcardno bankname:(NSString*)bankname
{
    BOOL send = [self preRequest:NLProtocolRequest_orderPayBankCardStar name:Notify_orderPayBankCardStar];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] orderPayBankCardStarXML:orderid orderno:orderno paymoney:paymoney bankcardno:bankcardno bankname:bankname];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_orderPayBankCardStar];
    }
}

/***
 读取银行卡信息
 */
-(void)readAuBkCardInfo
{
    BOOL send = [self preRequest:NLProtocolRequest_readAuBkCardInfo name:Notify_readAuBkCardInfo];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] readAuBkCardInfoXML];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_readAuBkCardInfo];
    }
}

/***
 提交银行卡信息
 */
-(void)modifyAuBkCardInfo:(NSString*)aushoucardman aushoucardphone:(NSString*)aushoucardphone aushoucardno:(NSString*)aushoucardno aushoucardbank:(NSString*)aushoucardbank;
{
    BOOL send = [self preRequest:NLProtocolRequest_modifyAuBkCardInfo name:Notify_modifyAuBkCardInfo];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] modifyAuBkCardInfoXML:aushoucardman aushoucardphone:aushoucardphone aushoucardno:aushoucardno aushoucardbank:aushoucardbank];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_modifyAuBkCardInfo];
    }
}

/***
 读取收款银行卡历史记录
 */
-(void)readshoucardList:(NSString*)paytype
{
    BOOL send = [self preRequest:NLProtocolRequest_readshoucardList name:Notify_readshoucardList];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] readshoucardListXML:paytype];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_readshoucardList];
    }
}

/***
 超级转账手续费计算
 */
-(void)getSupTransferPayfee:(NSString*)bankid money:(NSString*)money arriveid:(NSString*)arriveid
{
    BOOL send = [self preRequest:NLProtocolRequest_getSupTransferPayfee name:Notify_getSupTransferPayfee];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] getSupTransferPayfeeXML:bankid money:money arriveid:arriveid];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_getSupTransferPayfee];
    }
}

/***
 超级转账请求获得银行交易流水号
 */
-(void)SuptransferMoneyRq:(NSString*)paycardid fucardno:(NSString*)fucardno fucardbank:(NSString*)fucardbank fucardman:(NSString*)fucardman fucardmobile:(NSString*)fucardmobile shoucardno:(NSString*)shoucardno shoucardbank:(NSString*)shoucardbank current:(NSString*)current paymoney:(NSString*)paymoney payfee:(NSString*)payfee money:(NSString*)money shoucardmobile:(NSString*)shoucardmobile shoucardman:(NSString*)shoucardman arriveid:(NSString*)arriveid shoucardmemo:(NSString*)shoucardmemo sendsms:(NSString*)sendsms merReserved:(NSString*)merReserved
{
    BOOL send = [self preRequest:NLProtocolRequest_SuptransferMoneyRq name:Notify_SuptransferMoneyRq];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] SuptransferMoneyRqXML:paycardid fucardno:fucardno fucardbank:fucardbank fucardman:fucardman fucardmobile:fucardmobile shoucardno:shoucardno shoucardbank:shoucardbank current:current paymoney:paymoney payfee:payfee money:money shoucardmobile:shoucardmobile shoucardman:shoucardman arriveid:arriveid shoucardmemo:shoucardmemo sendsms:sendsms merReserved:merReserved];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_SuptransferMoneyRq];
    }
}

/***
 超级转账支付成功反馈
 */
-(void)insertSupTransferMoney:(NSString*)bkntno result:(NSString*)result
{
    BOOL send = [self preRequest:NLProtocolRequest_insertSupTransferMoney name:Notify_insertSupTransferMoney];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] insertSupTransferMoneyXML:bkntno result:result];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_insertSupTransferMoney];
    }
}

/***
 读取超级转账历史记录
 */
-(void)readSupTransferMoneyglist:(NSString*)paytype msgstart:(NSString*)msgstart msgdisplay:(NSString*)msgdisplay
{
    BOOL send = [self preRequest:NLProtocolRequest_readSupTransferMoneyglist name:Notify_readSupTransferMoneyglist];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] readSupTransferMoneyglistXML:paytype msgstart:msgstart msgdisplay:msgdisplay];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_readSupTransferMoneyglist];
    }
}

//读取充值金额选项
-(void)readRechaMoneyinfo
{
    BOOL send= [self preRequest:NLProtocolRequest_readRechaMoneyinfo name:Notify_readRechaMoneyinfo];
    if (!send) {
        
        NLProtocolData *pd = [[NLProtocolXML shareProtocolXML] readRechaMoneyinfoXML];
        
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_readRechaMoneyinfo];
    }
}

/***
 手机充值
 */
-(void)paycardIDRq:(NSString *)paycardid rechapaytypeid:(NSString *)rechapaytypeid rechamoney:(NSString *)rechamoney rechapaymoney:(NSString *)rechapaymoney rechamobile:(NSString *)rechamobile rechamobileprov:(NSString *)rechamobileprov rechabkcardno:(NSString *)rechabkcardno rechabkcardid:(NSString *)rechabkcardid merReserved:(NSString *)merReserved
{
    BOOL send= [self preRequest:NLProtocolRequest_RechaMoneyRq name:Notify_RechaMoneyRq];
    if (!send) {
        
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] paycardIDRqXML:paycardid rechapaytypeid:rechabkcardid rechamoney:rechamoney rechapaymoney:rechapaymoney rechamobile:rechamobile rechamobileprov:rechamobileprov rechabkcardno:rechabkcardno rechabkcardid:rechabkcardid merReserved:merReserved];
        
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_RechaMoneyRq];
        
    }
}

/***
 手机充值支付成功反馈
 */
-(void)checkRechaMoneyStatus:(NSString*)bkntno result:(NSString*)result
{
    BOOL send = [self preRequest:NLProtocolRequest_checkRechaMoneyStatus name:Notify_checkRechaMoneyStatus];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] checkRechaMoneyStatusXML:bkntno result:result];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_checkRechaMoneyStatus];
    }
}

/**
 读取手机充值历史记录
 */
-(void)readMobileRechangelist:(NSString*)paytype msgstart:(NSString*)msgstart msgdisplay:(NSString*)msgdisplay
{
    BOOL send = [self preRequest:NLProtocolRequest_readMobileRechangelist name:Notify_readMobileRechangelist];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] readMobileRechangelistXML:paytype msgstart:msgstart msgdisplay:msgdisplay];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_readMobileRechangelist];
    }
}

//读取Q币充值金额选项
-(void)readRechaQQMoneyinfo
{
    BOOL send= [self preRequest:NLProtocolRequest_readRechaQQMoneyinfo name:Notify_readRechaQQMoneyinfo];
    if (!send) {
        
        NLProtocolData *pd = [[NLProtocolXML shareProtocolXML] readRechaQQMoneyinfoXML];
        
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_readRechaQQMoneyinfo];
    }
    
}

/***
 Q币充值
 */
-(void)payQQcardIDRq:(NSString *)paycardid rechapaytypeid:(NSString *)rechapaytypeid rechamoney:(NSString *)rechamoney rechapaymoney:(NSString *)rechapaymoney rechaqq:(NSString *)rechaqq rechabkcardno:(NSString *)rechabkcardno rechabkcardid:(NSString *)rechabkcardid merReserved:(NSString *)merReserved
{
    BOOL send= [self preRequest:NLProtocolRequest_RechaQQMoneyRq name:Notify_RechaQQMoneyRq];
    if (!send) {
        
        NLProtocolData *pd = [[NLProtocolXML shareProtocolXML]payQQcardIDRqXML:paycardid rechapaytypeid:rechabkcardid rechamoney:rechamoney rechapaymoney:rechapaymoney rechaqq:rechaqq rechabkcardno:rechabkcardno rechabkcardid:rechapaytypeid merReserved:merReserved];
        
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_RechaQQMoneyRq];
    }
    
}

/***
 Q币充值支付成功反馈
 */
-(void)checkRechaQQMoneyStatus:(NSString*)bkntno result:(NSString*)result
{
    BOOL send = [self preRequest:NLProtocolRequest_checkRechaQQMoneyStatus name:Notify_checkRechaQQMoneyStatus];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] checkRechaQQMoneyStatusXML:bkntno result:result];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_checkRechaQQMoneyStatus];
    }
}

/**
 读取Q币充值历史记录
 */
-(void)readMobileRechangeQQlist:(NSString*)paytype msgstart:(NSString*)msgstart msgdisplay:(NSString*)msgdisplay
{
    BOOL send = [self preRequest:NLProtocolRequest_readRechangeQQlist name:Notify_readRechangeQQlist];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] readMobileRechangeQQlistXML:paytype msgstart:msgstart msgdisplay:msgdisplay];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_readRechangeQQlist];
    }
    
}

/**
 内部购买刷卡器-读取产品管理信息
 */
-(void)readSKQOrderInfo
{
    BOOL send = [self preRequest:NLProtocolRequest_readOrderProinfo name:Notify_readOrderProinfo];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] readSKQOrderInfoXML];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_readOrderProinfo];
    }
    
}

/**
 内部购买刷卡器-读取收货地址
 */
-(void)readSKQShaddressInfo
{
    BOOL send = [self preRequest:NLProtocolRequest_readShaddressinfo name:Notify_readShaddressinfo];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] readSKQShaddressInfoXML];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_readShaddressinfo];
    }
    
}

/**
 内部购买刷卡器-新增收货地址
 */
-(void)addSKQShaddressProvince:(NSString *)province city:(NSString *)city county:(NSString *)county address:(NSString *)address man:(NSString *)man phone:(NSString *)phone defaultAdress:(NSString *)defaultAdress
{
    BOOL send = [self preRequest:NLProtocolRequest_shaddressAdd name:Notify_shaddressAdd];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] addSKQShaddressProvinceXML:province city:city county:county address:address man:man phone:phone defaultAdress:defaultAdress];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_shaddressAdd];
    }
    
}

/**
 内部购买刷卡器-删除收货地址
 */
-(void)deleteSKQShaddressWithAddressId:(NSString *)addressId
{
    //    BOOL send = [self preRequest:NLProtocolRequest_shaddressDelete name:Notify_shaddressDelete];
    //    if (!send)
    //    {
    NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] deleteSKQShaddressWithAddressIdXML:addressId];
    [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_shaddressDelete];
    //    }
    
}

/**
 内部购买刷卡器-支付请求银联交易码
 */
-(void)paySKQcardIDRq:(NSString *)paycardid orderPaytypeid:(NSString *)orderPaytypeid orderprodureid:(NSString *)orderprodureid ordernum:(NSString *)ordernum orderprice:(NSString *)orderprice ordermoney:(NSString *)ordermoney ordershaddressid:(NSString *)ordershaddressid oredershaddress:(NSString *)oredershaddress ordershman:(NSString *)ordershman ordershphone:(NSString *)ordershphone orderfucardno:(NSString *)orderfucardno orderfucardbank:(NSString *)orderfucardbank ordermemo:(NSString *)ordermemo yunmoney:(NSString *)yunmoney yunprice:(NSString *)yunprice promoney:(NSString *)promoney produrename:(NSString *)produrename agentno:(NSString*)agentno
{
    BOOL send = [self preRequest:NLProtocolRequest_payOrderRq name:Notify_payOrderRq];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] paySKQcardIDRqXML:paycardid orderPaytypeid:orderPaytypeid orderprodureid:orderprodureid ordernum:ordernum orderprice:orderprice ordermoney:ordermoney ordershaddressid:ordershaddressid oredershaddress:oredershaddress ordershman:ordershman ordershphone:ordershphone orderfucardno:orderfucardno orderfucardbank:orderfucardbank ordermemo:ordermemo yunmoney:(NSString *)yunmoney yunprice:(NSString *)yunprice promoney:(NSString *)promoney produrename:(NSString *)produrename agentno:agentno];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_payOrderRq];
    }
    
}

/**
 内部购买刷卡器-银联支付成功反馈
 */
-(void)checkPaySKQStatus:(NSString*)bkntno result:(NSString*)result
{
    BOOL send = [self preRequest:NLProtocolRequest_orderPayrqStatus name:Notify_orderPayrqStatus];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] checkPaySKQStatusXML:bkntno result:result];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_orderPayrqStatus];
    }
    
}

/**
 内部购买刷卡器-读取购买历史记录
 */
-(void)readPaySKQhistorylist:(NSString*)paytype msgstart:(NSString*)msgstart msgdisplay:(NSString*)msgdisplay
{
    BOOL send = [self preRequest:NLProtocolRequest_readSKQOrderlist name:Notify_readSKQOrderlist];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] readPaySKQhistorylistXML:paytype msgstart:msgstart msgdisplay:msgdisplay];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_readSKQOrderlist];
    }
}

/*
 读取水电煤服务列表
 */
-(void)readWaterEleProductList
{
    BOOL send = [self preRequest:NLProtocolRequest_waterEle_getProductList name:Notify_waterEle_getProductList];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] readWaterEleProductListXML];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_waterEle_getProductList];
    }
}

/*
 水电煤生成订单
 */
-(void)createWaterEleOrder:(NSString *)account productId:(NSString *)productId
{
    BOOL send = [self preRequest:NLProtocolRequest_waterEle_createOrder name:Notify_waterEle_createOrder];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] createWaterEleOrderXML:account productId:productId];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_waterEle_createOrder];
    }
    
}

/*
 水电煤提交订单
 */
-(void)submitWaterEleOrder:(NSString *)orderId paycardid:(NSString *)paycardId rechabkcardno:(NSString *)rechabkcardno merReserved:(NSString *)merReserved
{
    BOOL send = [self preRequest:NLProtocolRequest_waterEle_submitOrder name:Notify_waterEle_submitOrder];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] submitWaterEleOrderXML:orderId paycardid:paycardId rechabkcardno:rechabkcardno merReserved:merReserved];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_waterEle_submitOrder];
    }
    
}

/*
 水电煤支付完订单反馈
 */
-(void)completeWaterEleOrder:(NSString *)orderid bkntno:(NSString *)bkntno
{
    BOOL send = [self preRequest:NLProtocolRequest_waterEle_completeOrder name:Notify_waterEle_completeOrder];
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] completeWaterEleOrderXML:orderid bkntno:bkntno];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_waterEle_completeOrder];
    }
    
}

/*
 水电煤查询历史订单
 */
-(void)getWaterEleOrderHistory:(NSString*)paytype msgstart:(NSString*)msgstart msgdisplay:(NSString*)msgdisplay
{
    BOOL send = [self preRequest:NLProtocolRequest_waterEle_getOrderHistory name:Notify_waterEle_getOrderHistory];
    if (!send)
    {
        NLProtocolData *pd = [[NLProtocolXML shareProtocolXML] getWaterEleOrderHistoryWithmsgStartXML:msgstart msgdisplay:msgdisplay];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_waterEle_getOrderHistory];
    }
    
}

/**** 游戏充值 ****/

//获取游戏列表
-(void)getGameChargeGameList
{
    BOOL send = [self preRequest:NLProtocolRequest_gameCharge_getGameList name:Notify_gameCharge_getGameList];
    if (!send)
    {
        NLProtocolData *pd = [[NLProtocolXML shareProtocolXML] getGameChargeGameListXML];
        [_request startRequest:pd action:Notify_gameCharge_getGameList];
    }
}

//获取平台
-(void)getGameChargeplatform
{
    BOOL send = [self preRequest:NLProtocolRequest_gameCharge_getplatformList name:Notify_gameCharge_getplatformList];
    if (!send)
    {
        NLProtocolData *pd = [[NLProtocolXML shareProtocolXML] getGameChargeplatformXML];
        [_request startRequest:pd action:Notify_gameCharge_getplatformList];
    }
}

//游戏小类列表
-(void)getGameChargeChildGame:(NSString *)gameId
{
    BOOL send = [self preRequest:NLProtocolRequest_gameCharge_getChildGame name:Notify_gameCharge_getChildGame];
    if (!send)
    {
        NLProtocolData *pd = [[NLProtocolXML shareProtocolXML] getGameChargeChildGameXML:gameId];
        [_request startRequest:pd action:Notify_gameCharge_getChildGame];
    }
}

//获取某一游戏详细信息
-(void)getGameChargeGameDetail:(NSString *)gameId
{
    BOOL send = [self preRequest:NLProtocolRequest_gameCharge_getGameDetail name:Notify_gameCharge_getGameDetail];
    if (!send)
    {
        NLProtocolData *pd = [[NLProtocolXML shareProtocolXML] getGameChargeGameDetailXML:gameId];
        [_request startRequest:pd action:Notify_gameCharge_getGameDetail];
    }
}

//生成订单
-(void)GameChargeCreateOrder:(NSString *)gameId gameName:(NSString *)gameName area:(NSString *)area server:(NSString *)server quantity:(NSString *)quantity price:(NSString *)price userCount:(NSString *)userCount paycardid:(NSString *)paycardid rechabkcardno:(NSString *)rechabkcardno cost:(NSString*)cost
{
    BOOL send = [self preRequest:NLProtocolRequest_gameCharge_createOrder name:Notify_gameCharge_createOrder];
    if (!send)
    {
        NLProtocolData *pd = [[NLProtocolXML shareProtocolXML] GameChargeCreateOrderXML:gameId gameName:gameName area:area server:server quantity:quantity price:price userCount:userCount paycardid:paycardid rechabkcardno:rechabkcardno cost:cost];
        [_request startRequest:pd action:Notify_gameCharge_createOrder];
    }
}

//支付完订单
-(void)completeGameChargeOrder:(NSString *)bkntno
{
    BOOL send = [self preRequest:NLProtocolRequest_gameCharge_completeOrder name:Notify_gameCharge_completeOrder];
    if (!send)
    {
        NLProtocolData *pd = [[NLProtocolXML shareProtocolXML] completeGameChargeOrderXML:bkntno];
        [_request startRequest:pd action:Notify_gameCharge_completeOrder];
    }
}

//查询历史订单
-(void)getGameChargeOrderHistoryWithmsgStart:(NSString*)msgstart msgdisplay:(NSString*)msgdisplay
{
    BOOL send = [self preRequest:NLProtocolRequest_gameCharge_getOrderHistory name:Notify_gameCharge_getOrderHistory];
    if (!send)
    {
        NLProtocolData *pd = [[NLProtocolXML shareProtocolXML] getGameChargeOrderHistoryWithmsgStartXML:msgstart msgdisplay:msgdisplay];
        [_request startRequest:pd action:Notify_gameCharge_getOrderHistory];
    }
}

//代理商读取基本信息
-(void)readagentinfo
{
    BOOL send = [self preRequest:NLProtocolRequest_readagentinfo name:Notify_readagentinfo];
    if (!send)
    {
        NLProtocolData *pd = [[NLProtocolXML shareProtocolXML] readagentinfoXML];
        [_request startRequest:pd action:Notify_readagentinfo];
    }
}

//代理商读取读取补货记录
-(void)readagentorderlist:(NSString*)paytype msgstart:(NSString*)msgstart msgdisplay:(NSString*)msgdisplay
{
    BOOL send = [self preRequest:NLProtocolRequest_readagentorder name:Notify_readagentorder];
    if (!send)
    {
        NLProtocolData *pd = [[NLProtocolXML shareProtocolXML] readagentorderlistXML:paytype msgstart:msgstart msgdisplay:msgdisplay];
        [_request startRequest:pd action:Notify_readagentorder];
    }
}

//代理商补货发货状态提交
-(void)agentorderstaterq:(NSString *)orderid
{
    BOOL send = [self preRequest:NLProtocolRequest_agentorderstaterq name:Notify_agentorderstaterq];
    if (!send)
    {
        NLProtocolData *pd = [[NLProtocolXML shareProtocolXML] agentorderstaterqXML:orderid];
        [_request startRequest:pd action:Notify_agentorderstaterq];
    }
}

//代理商补货请求银行交易码
-(void)payagentOrderRq:(NSString *)orderprodureid ordernum:(NSString *)ordernum orderprice:(NSString *)orderprice ordermoney:(NSString *)ordermoney rechabkcardno:(NSString *)rechabkcardno orderfucardbank:(NSString *)orderfucardbank ordermemo:(NSString *)ordermemo
{
    BOOL send = [self preRequest:NLProtocolRequest_payagentOrderRq name:Notify_payagentOrderRq];
    if (!send)
    {
        NLProtocolData *pd = [[NLProtocolXML shareProtocolXML] payagentOrderRqXML:orderprodureid ordernum:ordernum orderprice:orderprice ordermoney:ordermoney rechabkcardno:rechabkcardno orderfucardbank:orderfucardbank ordermemo:ordermemo];
        [_request startRequest:pd action:Notify_payagentOrderRq];
    }
}

//代理商银联支付成功反馈
-(void)agentorderPayrqStatus:(NSString*)bkntno result:(NSString*)result
{
    BOOL send = [self preRequest:NLProtocolRequest_agentorderPayrqStatus name:Notify_agentorderPayrqStatus];
    if (!send)
    {
        NLProtocolData *pd = [[NLProtocolXML shareProtocolXML] agentorderPayrqStatusXML:bkntno result:result];
        [_request startRequest:pd action:Notify_agentorderPayrqStatus];
    }
}

//代理商读取历史收益记录
-(void)payagentfenrunlist:(NSString *)querytype querywhere:(NSString *)querywhere
{
    BOOL send = [self preRequest:NLProtocolRequest_payagentfenrunlist name:Notify_payagentfenrunlist];
    if (!send)
    {
        NLProtocolData *pd = [[NLProtocolXML shareProtocolXML] payagentfenrunlistXML:querytype querywhere:querywhere];
        [_request startRequest:pd action:Notify_payagentfenrunlist];
    }
}

//绑定代理商
-(void)BindingAgentId:(NSString *)querytype agentno:(NSString *)agentno
{
    BOOL send = [self preRequest:NLProtocolRequest_BindingAgentId name:Notify_BindingAgentId];
    if (!send)
    {
        NLProtocolData *pd = [[NLProtocolXML shareProtocolXML] BindingAgentIdXML:querytype agentno:agentno];
        [_request startRequest:pd action:Notify_BindingAgentId];
    }
}

//最新的注册接口
-(void)getTheNewLoginApiAuthorInfoV2:(NSString *)Mac Phone:(NSString*)phone Password:(NSString*)Password{
    BOOL send= [self preRequest:NLProtocolRequest_ApiAuthorInfoV2 name:Notify_ApiAuthorInfoV2];
    if (!send) {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] getTheNewLoginApiAuthorInfoV2XML:Mac Phone:phone Password:Password];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_ApiAuthorInfoV2];
    }
    
}

//判断用户是否已经注册过
-(void)getApiAuthorInfoV2IsOnMain:(NSString *)Mac Phone:(NSString*)phone accountnumber:(NSString *)accountnumber Password:(NSString*)Password
{
    BOOL send= [self preRequest:NLProtocolRequest_ApiAuthorInfoV2IsOnMain name:Notify_ApiAuthorInfoV2IsOnMain];
    if (!send) {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML] getApiAuthorInfoV2IsOnMainXML:Mac Phone:phone accountnumber:accountnumber Password:Password];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_ApiAuthorInfoV2IsOnMain];
    }
}

//用户登录
- (void)getApiAuthorInfoV2gesturepasswd:(NSString *)password paypasswd:(NSString *)paypasswd mobile:(NSString*)mobile
{
    BOOL send = [self preRequest:NLProtocolRequest_ApiAuthorInfoV2Gesture name:Notify_ApiAuthorInfoV2Gesture];
    
    if (!send)
    {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML]getApiAuthorInfoV2gesturepasswdXML:password paypasswd:paypasswd mobile:mobile];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_ApiAuthorInfoV2Gesture];
    }
}
/*
 <?xml version="1.0" encoding="UTF-8"?>
 <operation_request>
 
 <msgbody>
 <paypasswd>123456</paypasswd>
 <mobile>13192368093</mobile>
 <gesturepasswd>03</gesturepasswd>
 </msgbody>
 
 <msgheader version="3.0.0"><req_bkenv>01</req_bkenv><au_token/><req_time>20141021110126</req_time><channelinfo><api_name>ApiAuthorInfoV2</api_name><api_name_func>login</api_name_func><authorid/></channelinfo><req_token/><req_version>3.0.0</req_version><req_appenv>3</req_appenv></msgheader></operation_request>
 */
//手势密码登录
- (void)getApiAuthorInfoV2gesturepasswdTohander:(NSString *)password paypasswd:(NSString *)paypasswd mobile:(NSString*)mobile
{
    BOOL send= [self preRequest:NLProtocolRequest_ApiAuthorInfoV2GestureToHander name:Notify_ApiAuthorInfoV2GestureToHander];
    if (!send) {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML]getApiAuthorInfoV2gesturepasswdXML:password paypasswd:paypasswd mobile:mobile];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_ApiAuthorInfoV2GestureToHander];
    }
}

//用户密码修改
- (void)getApiAuthorInfoPasswordToChage:(NSString *)oldpassword newpassword:(NSString *)newpassword aumoditype:(NSString *)aumoditype reset:(NSString *)reset{
    BOOL send= [self preRequest:NLProtocolRequest_ApiAuthorInfoPasswordToChage name:Notify_ApiAuthorInfoPasswordToChage];
    if (!send) {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML]getApiAuthorInfoPasswordToChageXML:oldpassword newpassword:newpassword aumoditype:aumoditype reset:reset];
        [_request/*[[ProtocolRequest alloc] init]*/ startRequest:pd action:Notify_ApiAuthorInfoPasswordToChage];
    }
}

//用户login密码修改
- (void)getApiAuthorInfoV2LoginPasswordToChage:(NSString *)oldpassword newpassword:(NSString *)newpassword aumoditype:(NSString *)aumoditype reset:(NSString *)reset{
    BOOL send= [self preRequest:NLProtocolRequest_ApiAuthorInfoV2ChangeLoginPassword name:Notify_ApiAuthorInfoV2ChangeLoginPassword];
    if (!send) {
        NLProtocolData* pd = [[NLProtocolXML shareProtocolXML]getApiAuthorInfoPasswordToChageXML:oldpassword newpassword:newpassword aumoditype:aumoditype reset:reset];
        [_request startRequest:pd action:Notify_ApiAuthorInfoV2ChangeLoginPassword];
    }
}


//获取所有密保问题
- (void)getApiSafeGuard{
    BOOL send= [self preRequest:NLProtocolRequest_ApiSafeGuardIsOn name:Notify_ApiSafeGuardIsOn];
    if (!send) {
        NLProtocolData *pd = [[NLProtocolXML shareProtocolXML]getApiSafeGuardXML];
        [_request startRequest:pd action:Notify_ApiSafeGuardIsOn];
    }
}

-(void)getApiSafeGuardMsgchild:(NSString*)quechild1 answer1:(NSString*)answer1 quechild2:(NSString*)quechild2 answer2:(NSString*)answer2 quechild3:(NSString*)quechild3 answer3:(NSString*)answer3{
    
    BOOL send= [self preRequest:NLProtocolRequest_ApiSafeGuardSetting name:Notify_ApiSafeGuardSetting];
    if (!send) {
        NLProtocolData *pd= [[NLProtocolXML shareProtocolXML]getApiSafeGuardMsgchildXML:quechild1 answer1:answer1  quechild2:quechild2 answer2:answer2 quechild3:quechild3 answer3:answer3];
        [_request startRequest:pd action:Notify_ApiSafeGuardSetting];
    }
    
}

//获取密保问题
- (void)getApiSafeGuardUser:(NSString*)PhoneNumber{
    
    BOOL send= [self preRequest:NLProtocolRequest_ApiSafeGuardUser name:Notify_ApiSafeGuardUser];
    
    if (!send) {
        NLProtocolData *pd= [[NLProtocolXML shareProtocolXML]getApiSafeGuardUserXML:PhoneNumber];
        
        [_request startRequest:pd action:Notify_ApiSafeGuardUser];
    }
}

//用于注销后的通知 判断是否设置密保问题的
- (void)getApiSafeGuardLoginUp:(NSString*)PhoneNumber{
    
    BOOL send= [self preRequest:NLProtocolRequest_ApiSafeGuardLoginUp name:Notify_ApiSafeGuardLoginUp];
    
    if (!send) {
        NLProtocolData *pd= [[NLProtocolXML shareProtocolXML]getApiSafeGuardUserXML:PhoneNumber];
        
        [_request startRequest:pd action:Notify_ApiSafeGuardLoginUp];
    }
}

//修改信息
- (void)getApiAuthorInfoV2modifyAuthorInfo:(NSString*)PhoneNumber accountnumber:(NSString*)accountnumber accountname:(NSString*)accountname bankname:(NSString*)bankname{
    
    BOOL send= [self preRequest:NLProtocolRequest_ApiAuthorInfoV2modifyAuthorInfo name:Notify_ApiAuthorInfoV2modifyAuthorInfo];
    
    if (!send) {
        NLProtocolData *pd= [[NLProtocolXML shareProtocolXML]getApiAuthorInfoV2modifyAuthorInfoXML:PhoneNumber accountnumber:accountnumber accountname:accountname bankname:bankname];
        
        [_request startRequest:pd action:Notify_ApiAuthorInfoV2modifyAuthorInfo];
    }
}
#pragma mark ---  飞机票
//飞机票的城市查询
- (void)getApiAirticket:(NSString*)firstLetter cityName:(NSString*)cityName
{
    BOOL send= [self preRequest:NLProtocolRequest_ApiAirticket name:Notify_ApiAirticket];
    
    if (!send)
    {
        NLProtocolData *pd= [[NLProtocolXML shareProtocolXML] getApiAirticketXML:firstLetter cityName:cityName];
        
        [_request startRequest:pd action:Notify_ApiAirticket];
    }
}

//航班查询
- (void)getApigetAirline:(NSString*)departCityCode arriveCityCode:(NSString*)arriveCityCode departDate:(NSString*)departDate returnDate:(NSString*)returnDate searchType:(NSString*)searchType{
    
    BOOL send= [self preRequest:NLProtocolRequest_ApigetAirline name:Notify_ApigetAirline];
    
    if (!send) {
        NLProtocolData *pd= [[NLProtocolXML shareProtocolXML]getApigetAirlineXML:departCityCode arriveCityCode:arriveCityCode departDate:departDate returnDate:returnDate searchType:searchType];
        
        [_request startRequest:pd action:Notify_ApigetAirline];
    }
}
//航班详情
- (void)departCityCode:(NSString*)newDepartCityCode arriveCityCode:(NSString*)newArriveCityCode departTime:(NSString*)newDepartTime returnTime:(NSString*)newReturnTime searchType:(NSString*)newSearchType flight:(NSString *)newflight returnFlight:(NSString *)newreturnFlight
{
    
    BOOL send= [self preRequest:NLProtocolRequest_GetAirlineDetail name:Notify_GetAirlineDetail];
    
    if (!send)
    {
        NLProtocolData *pd= [[NLProtocolXML shareProtocolXML]getDepartCityCode:newDepartCityCode arriveCityCode:newArriveCityCode departTime:newDepartTime returnTime:newReturnTime searchType:newSearchType fligth:newflight returnFlight:newreturnFlight];
        
        [_request startRequest:pd action:Notify_GetAirlineDetail];
    }
    
}
// 添加乘机人
- (void)savePassengerName:(NSString*)newSavePassengerName savePassengerCardType:(NSString*)newSavePassengerCardType savePassengerCardId:(NSString*)newSavePassengerCardId savePassengerPhoneNumber:(NSString*)newsavePassengerPhoneNumber savePassengerPassengerType:(NSString *)newSavePassengerPassengerType
{
    BOOL send= [self preRequest:NLProtocolRequest_SavePassenger name:Notify_SavePassenger];
    if (!send)
    {
        NLProtocolData *pd= [[NLProtocolXML shareProtocolXML]getSavePassengerNameXML:newSavePassengerName SavePassengerCardType:newSavePassengerCardType SavePassengerCardId:newSavePassengerCardId phoneNumber:newsavePassengerPhoneNumber passengerType:newSavePassengerPassengerType];
        
        [_request startRequest:pd action:Notify_SavePassenger];
    }
    
}
// 读取乘机人
- (void)getPassengerType:(NSString *)newPassengerType
{
    BOOL send= [self preRequest:NLProtocolRequest_getPassenger name:Notify_GetPassenger];
    
    if (!send)
    {
        NLProtocolData *pd= [[NLProtocolXML shareProtocolXML]getPlayPassengerInfo:newPassengerType];
        
        [_request startRequest:pd action:Notify_GetPassenger];
    }
}
// 删除乘机人
- (void)getdeletcetionPassengerId:(NSString *)newPassengerId  deletcetionPassengerType:(NSString *)newdeletcetionPassenger
{
    BOOL send= [self preRequest:NLProtocolRequest_deletePassenger name:Notify_deletePassenger];
    if (!send)
    {
        NLProtocolData *pd= [[NLProtocolXML shareProtocolXML] getdeletcetionPassengerIdXML:newPassengerId  deletcetionPassengerTypeXML:newdeletcetionPassenger];
        [_request startRequest:pd action:Notify_deletePassenger];
    }
}

// 历史查询
- (void)getOrderHistoryMsgstart:(NSString*)newMsgstart getOrderHistoryMsgdisplay:(NSString *)newmsgdisplay
{
    BOOL send= [self preRequest:NLProtocolRequest_OrderHistory name:Notify_getOrderHistory];
    if (!send)
    {
        NLProtocolData *pd= [[NLProtocolXML shareProtocolXML] getOrderHistoryMsgstartXML:newMsgstart getOrderHistoryMsgdisplayXML:newmsgdisplay];
        [_request startRequest:pd action:Notify_getOrderHistory];
    }

}
// 验证码
- (void)getApiPayverify:(NSString *)newApiPayverify OrderId:(NSString*)newOrderId
{
    BOOL send= [self preRequest:NLProtocolRequest_payWithCreditCard name:Notify_getpayWithCreditCard];
    if (!send)
    {
        NLProtocolData *pd= [[NLProtocolXML shareProtocolXML] getApiPayverifyXML:newApiPayverify OrderIdXML:newOrderId];
        [_request startRequest:pd action:Notify_getpayWithCreditCard];
    }

    
}




// 确信支付

-(void)TicketBillId:(NSString *)newTicketBillId backTicketId:(NSString *)newBackTicketBillId  styGoBack:(NSString *)newStyGoBsack  perSonIdArray:(NSMutableArray *)newperSonIdArray ContactIdArray:(NSMutableArray *)newContactIdArray   payinfoCardInfoArray:(NSMutableArray *)newpayinfoCardInfoArray;
{
    BOOL send= [self preRequest:NLProtocolRequest_createOrder name:Notify_createOrder];
    if (!send)
    {
        NLProtocolData *pd= [[NLProtocolXML shareProtocolXML] TicketBillIdXML:newTicketBillId  backTicketIdXML:newBackTicketBillId  styGoBack:newStyGoBsack perSonIdArrayXML:newperSonIdArray ContactIdArrayXML:newContactIdArray   payinfoCardInfoArrayXML:newpayinfoCardInfoArray];
        [_request startRequest:pd action:Notify_createOrder];
    }
}

//菜单模板读取
- (void)getApireadMenuModule:(NSString*)paycardkey appversion:(NSString*)appversion
{
    BOOL send= [self preRequest:NLProtocolRequest_ApireadMenuModule name:Notify_ApireadMenuModule];
    
    if (!send) {
        NLProtocolData *pd= [[NLProtocolXML shareProtocolXML]getApireadMenuModuleXML:paycardkey appversion:appversion];
        [_request startRequest:pd action:Notify_ApireadMenuModule];
    }
}

//菜单模板数量点击
- (void)getApireadMenutapCount:(NSString*)appmnuid agentno:(NSString*)agentno{
    
    BOOL send= [self preRequest:NLProtocolRequest_ApiauthorMenuCount name:Notify_ApiauthorMenuCount];
    if (!send) {
        NLProtocolData *pd= [[NLProtocolXML shareProtocolXML]getApireadMenutapCountXML:appmnuid agentno:agentno];
        [_request startRequest:pd action:Notify_ApiauthorMenuCount];
    }
}

//商户读取代理商信息
- (void)getApiAgentInfo
{
    BOOL send = [self preRequest:NLProtocolRequest_ApiAgentInfo name:Notify_ApiAgentInfo];
    
    if (!send)
    {
        NLProtocolData *pd = [[NLProtocolXML shareProtocolXML] getApiAgentInfoXML];
        [_request startRequest:pd action:Notify_ApiAgentInfo];
    }
}

//代理商地区省
- (void)getApiAgentApplyWithProv
{
    BOOL send = [self preRequest:NLProtocolRequest_ApiAgentApplyProv name:Notify_ApiAgentApplyProv];
    
    if (!send)
    {
        NLProtocolData *pd = [[NLProtocolXML shareProtocolXML] getApiAgentApplyWithProvXML];
        [_request startRequest:pd action:Notify_ApiAgentApplyProv];
    }
}

- (void)getApiAgentApplyWithProv:(NSString *)prov
{
    BOOL send = [self preRequest:NLProtocolRequest_ApiAgentApplyCity name:Notify_ApiAgentApplyCity];
    
    if (!send)
    {
        NLProtocolData *pd = [[NLProtocolXML shareProtocolXML] getApiAgentApplyWithCityXML:prov];
        
        [_request startRequest:pd action:Notify_ApiAgentApplyCity];
    }
}

- (void)getApiAgentApplyWithProv:(NSString *)prov city:(NSString *)city
{
    BOOL send = [self preRequest:NLProtocolRequest_ApiAgentApplyTown name:Notify_ApiAgentApplyTown];
    
    if (!send)
    {
        NLProtocolData *pd = [[NLProtocolXML shareProtocolXML] getApiAgentApplyWithTownXML:prov town:city];
        [_request startRequest:pd action:Notify_ApiAgentApplyTown];
    }
}

//代理商申请
- (void)getApiAgentApplyAddWith:(NSString *)custypeid name:(NSString *)name address:(NSString *)address prov:(NSString *)prov city:(NSString *)city town:(NSString *)town
{
    BOOL send = [self preRequest:NLProtocolRequest_ApiAgentApplyAdd name:Notify_ApiAgentApplyAdd];
    
    if (!send)
    {
        NLProtocolData *pd = [[NLProtocolXML shareProtocolXML] getApiAgentApplyAddWithXML:custypeid name:name address:address prov:prov city:city town:town];
        
        [_request startRequest:pd action:Notify_ApiAgentApplyAdd];
    }
}

//代理商申请信息
- (void)getApiAgentApply
{
    BOOL send = [self preRequest:NLProtocolRequest_ApiAgentApplyBasinfo name:Notify_ApiAgentApplyBasinfo];
    
    if (!send)
    {
        NLProtocolData *pd = [[NLProtocolXML shareProtocolXML] getApiAppInfoXML];
        
        [_request startRequest:pd action:Notify_ApiAgentApplyBasinfo];
    }
}

//绑定代理商
- (void)getApiAgentInfoBind:(NSString *)agentNO
{
    BOOL send = [self preRequest:NLProtocolRequest_ApiAgentInfoBind name:Notify_ApiAgentInfoBind];
    
    if (!send)
    {
        NLProtocolData *pd = [[NLProtocolXML shareProtocolXML] getApiAgentInfoBindXML:agentNO];
        
        [_request startRequest:pd action:Notify_ApiAgentInfoBind];
    }
}

//虚拟代理商
- (void)getApiAgentApplyInsertPartt
{
    BOOL send = [self preRequest:NLProtocolRequest_ApiAgentApplyInsertPartt name:Notify_ApiAgentApplyInsertPartt];
    
    if (!send)
    {
        NLProtocolData *pd = [[NLProtocolXML shareProtocolXML] getApiAgentApplyInsertParttXML];
        
        [_request startRequest:pd action:Notify_ApiAgentApplyInsertPartt];
    }
}

//读取新的信息
- (void)getApiAppInfo
{
    BOOL send = [self preRequest:NLProtocolRequest_ApiAppInfo name:Notify_ApiAppInfo];
    
    if (!send)
    {
        NLProtocolData *pd = [[NLProtocolXML shareProtocolXML] getApiAppInfoXML];
        
        [_request startRequest:pd action:Notify_ApiAppInfo];
    }
}

//读取用户银行卡列表
- (void)getApiAuthorKuaibkcardInfoLists
{
    BOOL send = [self preRequest:NLProtocolRequest_ApiAuthorKuaibkcardInfoLists name:Notify_ApiAuthorKuaibkcardInfoLists];
    
    if (!send)
    {
        NLProtocolData *pd = [[NLProtocolXML shareProtocolXML] getApiAuthorKuaibkcardInfoListsXML];
        
        [_request startRequest:pd action:Notify_ApiAuthorKuaibkcardInfoLists];
    }
}

//添加新的银行卡
- (void)getApiAuthorKuaibkcardInfoAdd:(NSString *)bkcardbankid bkcardbank:(NSString *)bkcardbank bkcardno:(NSString *)bkcardno bkcardbankman:(NSString *)bkcardbankman bkcardbankphone:(NSString *)bkcardbankphone bkcardyxmonth:(NSString *)bkcardyxmonth bkcardyxyear:(NSString *)bkcardyxyear bkcardcvv:(NSString *)bkcardcvv bkcardidcard:(NSString *)bkcardidcard bkcardcardtype:(NSString *)bkcardcardtype bkcardisdefault:(NSString *)bkcardisdefault bkcardisdefaultPayment:(NSString *)bkcardisdefaultPayment
{
    BOOL send = [self preRequest:NLProtocolRequest_ApiAuthorKuaibkcardInfoAdd name:Notify_ApiAuthorKuaibkcardInfoAdd];
    
    if (!send)
    {
        NLProtocolData *pd = [[NLProtocolXML shareProtocolXML] getApiAuthorKuaibkcardInfoAddXML:bkcardbankid bkcardbank:bkcardbank bkcardno:bkcardno bkcardbankman:bkcardbankman bkcardbankphone:bkcardbankphone bkcardyxmonth:bkcardyxmonth bkcardyxyear:bkcardyxyear bkcardcvv:bkcardcvv bkcardidcard:bkcardidcard bkcardcardtype:bkcardcardtype bkcardisdefault:bkcardisdefault bkcardisdefaultPayment:bkcardisdefaultPayment];
        
        [_request startRequest:pd action:Notify_ApiAuthorKuaibkcardInfoAdd];
    }
}

//修改银行卡
- (void)getApiAuthorKuaibkcardInfoEdit:(NSString *)bkcardid bkcardbankid:(NSString *)bkcardbankid bkcardbank:(NSString *)bkcardbank bkcardno:(NSString *)bkcardno bkcardbankman:(NSString *)bkcardbankman bkcardbankphone:(NSString *)bkcardbankphone bkcardyxmonth:(NSString *)bkcardyxmonth bkcardyxyear:(NSString *)bkcardyxyear bkcardcvv:(NSString *)bkcardcvv bkcardidcard:(NSString *)bkcardidcard bkcardcardtype:(NSString *)bkcardcardtype bkcardisdefault:(NSString *)bkcardisdefault bkcardisdefaultPayment:(NSString *)bkcardisdefaultPayment
{
    BOOL send = [self preRequest:NLProtocolRequest_ApiAuthorKuaibkcardInfoEdit name:Notify_ApiAuthorKuaibkcardInfoEdit];
    
    if (!send)
    {
        NLProtocolData *pd = [[NLProtocolXML shareProtocolXML] getApiAuthorKuaibkcardInfoEditXML:bkcardid bkcardbankid:bkcardbankid bkcardbank:bkcardbank bkcardno:bkcardno bkcardbankman:bkcardbankman bkcardbankphone:bkcardbankphone bkcardyxmonth:bkcardyxmonth bkcardyxyear:bkcardyxyear bkcardcvv:bkcardcvv bkcardidcard:bkcardidcard bkcardcardtype:bkcardcardtype bkcardisdefault:bkcardisdefault bkcardisdefaultPayment:bkcardisdefaultPayment];

        [_request startRequest:pd action:Notify_ApiAuthorKuaibkcardInfoEdit];
    }
}

//移除银行卡
- (void)getApiAuthorKuaibkcardInfoDelete:(NSString *)bkcardid
{
    BOOL send = [self preRequest:NLProtocolRequest_ApiAuthorKuaibkcardInfoDelete name:Notify_ApiAuthorKuaibkcardInfoDelete];
    
    if (!send)
    {
        NLProtocolData *pd = [[NLProtocolXML shareProtocolXML] getApiAuthorKuaibkcardInfoDeleteXML:bkcardid];
        
        [_request startRequest:pd action:Notify_ApiAuthorKuaibkcardInfoDelete];
    }
}

//绑定银行卡
- (void)getApiAuthorKuaibkcardInfoDefault:(NSString *)bkcardid bkcardisdefault:(NSString *)bkcardisdefault
{
    BOOL send = [self preRequest:NLProtocolRequest_ApiAuthorKuaibkcardInfoDefault name:Notify_ApiAuthorKuaibkcardInfoDefault];
    
    if (!send)
    {
        NLProtocolData *pd = [[NLProtocolXML shareProtocolXML] getApiAuthorKuaibkcardInfoDefaultXML:bkcardid bkcardisdefault:bkcardisdefault];
        
        [_request startRequest:pd action:Notify_ApiAuthorKuaibkcardInfoDefault];
    }
}

/*易宝手机充值*/
- (void)getApiYiBaoPhonePay:(NSString *)rechargeMoney payMoney:(NSString *)payMoney rechargePhone:(NSString *)rechargePhone  bankCardId:(NSString *)bankCardId bankId:(NSString *)bankId manCardId:(NSString *)manCardId payPhone:(NSString *)payPhone manName:(NSString *)manName expireYear:(NSString *)expireYear expireMonth:(NSString *)expireMonth cvv:(NSString *)cvv mobileProvince:(NSString *)mobileProvince paycardid:(NSString*)paycardid
{
    BOOL send = [self preRequest:NLProtocolRequest_ApiYiBaoPhonePay name:Notify_ApiYiBaoPhonePay];
    if (!send)
    {
        NLProtocolData *pd = [[NLProtocolXML shareProtocolXML] getApiYiBaoPhonePayXML:rechargeMoney payMoney:payMoney rechargePhone:rechargePhone bankCardId:bankCardId bankId:bankId manCardId:manCardId payPhone:payPhone manName:manName expireYear:expireYear expireMonth:expireMonth cvv:cvv mobileProvince:mobileProvince paycardid:paycardid];
        [_request startRequest:pd action:Notify_ApiYiBaoPhonePay];
    }
}

/*易宝充值验证码*/
- (void)getApiYiBaoVerifyCode:(NSString *)orderId verifyCode:(NSString*)verifyCode
{
    BOOL send = [self preRequest:NLProtocolRequest_ApiYiBaoVerifyCode name:Notify_ApiYiBaoVerifyCode];
    if (!send)
    {
        NLProtocolData *pd = [[NLProtocolXML shareProtocolXML] getApiYiBaoVerifyCodeXML:orderId verifyCode:verifyCode];
        [_request startRequest:pd action:Notify_ApiYiBaoVerifyCode];
    }
}

/*易宝转账*/
- (void)ApiTransferWithCreditCard:(NSString *)payMoney transferMoney:(NSString *)transferMoney receiveBankCardId:(NSString *)receiveBankCardId  receiveBankName:(NSString *)receiveBankName receivePhone:(NSString *)receivePhone receivePersonName:(NSString *)receivePersonName cardReaderId:(NSString *)cardReaderId sendBankCardId:(NSString *)sendBankCardId sendBankCode:(NSString *)sendBankCode personCardId:(NSString *)personCardId sendPhone:(NSString *)sendPhone sendPersonName:(NSString *)sendPersonName  expireYear:(NSString *)expireYear expireMonth:(NSString *)expireMonth cvv:(NSString *)cvv transferType:(NSString *)transferType arriveid:(NSString*)arriveid sendBankName:(NSString*)sendBankName payType:(NSString*)payType paycardid:(NSString*)paycardid
{
    BOOL send = [self preRequest:NLProtocolRequest_ApiTransferWithCreditCard name:Notify_ApiTransferWithCreditCard];
    if (!send)
    {
        NLProtocolData *pd = [[NLProtocolXML shareProtocolXML]getApiTransferWithCreditCardXML:payMoney transferMoney:transferMoney receiveBankCardId:receiveBankCardId receiveBankName:receiveBankName receivePhone:receivePhone receivePersonName:receivePersonName cardReaderId:cardReaderId sendBankCardId:sendBankCardId sendBankCode:sendBankCode personCardId:personCardId sendPhone:sendPhone sendPersonName:sendPersonName expireYear:expireYear expireMonth:expireMonth cvv:cvv transferType:transferType arriveid:arriveid sendBankName:sendBankName payType:payType paycardid:paycardid];
        [_request startRequest:pd action:Notify_ApiTransferWithCreditCard];
    }
}

/*易宝转账验证码*/
- (void)getApiPayWithVerifyCode:(NSString *)orderId verifyCode:(NSString*)verifyCode
{
    BOOL send = [self preRequest:NLProtocolRequest_ApiPayWithVerifyCode name:Notify_ApiPayWithVerifyCode];
    if (!send)
    {
        NLProtocolData *pd = [[NLProtocolXML shareProtocolXML] getApiPayWithVerifyCodeXML:orderId verifyCode:verifyCode];
        [_request startRequest:pd action:Notify_ApiPayWithVerifyCode];
    }
}

/*易宝游戏充值*/
- (void)ApiGamePayWithCreditCard:(NSString *)gameId gameName:(NSString *)gameName area:(NSString *)area  server:(NSString *)server quantity:(NSString *)quantity price:(NSString *)price cost:(NSString *)cost userCount:(NSString *)userCount paycardid:(NSString *)paycardid bankCardId:(NSString *)bankCardId bankId:(NSString *)bankId manCardId:(NSString *)manCardId  payPhone:(NSString *)payPhone manName:(NSString *)manName expireYear:(NSString *)expireYear expireMonth:(NSString *)expireMonth cvv:(NSString *)cvv
{
    BOOL send = [self preRequest:NLProtocolRequest_ApiGamePayWithCreditCard name:Notify_ApiGamePayWithCreditCard];
    if (!send)
    {
        NLProtocolData *pd = [[NLProtocolXML shareProtocolXML]ApiGamePayWithCreditCardXML:gameId gameName:gameName area:area server:server quantity:quantity price:price cost:cost userCount:userCount paycardid:paycardid bankCardId:bankCardId bankId:bankId manCardId:manCardId payPhone:payPhone manName:manName expireYear:expireYear expireMonth:expireMonth cvv:cvv];
        [_request startRequest:pd action:Notify_ApiGamePayWithCreditCard];
    }
    
}

/*易宝游戏验证码*/
- (void)getApiGamePayWithVerifyCode:(NSString *)orderId verifyCode:(NSString*)verifyCode
{
    BOOL send = [self preRequest:NLProtocolRequest_ApiGamePayWithVerifyCode name:Notify_ApiGamePayWithVerifyCode];
    if (!send)
    {
        NLProtocolData *pd = [[NLProtocolXML shareProtocolXML] getApiGamePayWithVerifyCodeXML:orderId verifyCode:verifyCode];
        [_request startRequest:pd action:Notify_ApiGamePayWithVerifyCode];
    }
}

/*易宝商户收款*/
- (void)getApicouponPayReq:(NSString *)couponid couponmoney:(NSString *)couponmoney paycardid:(NSString *)paycardid bkcardbank:(NSString *)bkcardbank bkCardno:(NSString *)bkCardno bkcardman:(NSString *)bkcardman bkcardexpireMonth:(NSString *)bkcardexpireMonth bkcardmanidcard:(NSString *)bkcardmanidcard bankid:(NSString *)bankid bkcardexpireYear:(NSString *)bkcardexpireYear bkcardPhone:(NSString *)bkcardPhone bkcardcvv:(NSString *)bkcardcvv paytype:(NSString *)paytype
{
    BOOL send = [self preRequest:NLProtocolRequest_ApicouponPayReq name:Notify_ApicouponPayReq];
    
    if (!send)
    {
        NLProtocolData *pd = [[NLProtocolXML shareProtocolXML] getApicouponPayReqXML:couponid couponmoney:couponmoney paycardid:paycardid bkcardbank:bkcardbank bkCardno:bkCardno bkcardman:bkcardman bkcardexpireMonth:bkcardexpireMonth bkcardmanidcard:bkcardmanidcard bankid:bankid bkcardexpireYear:bkcardexpireYear bkcardPhone:bkcardPhone bkcardcvv:bkcardcvv paytype:paytype];
        
        [_request startRequest:pd action:Notify_ApicouponPayReq];
    }
}

/*易宝商户验证码*/
- (void)getApicouponPaySMSverify:(NSString *)SMSCode bkordernumber:(NSString *)bkordernumber bkntno:(NSString *)bkntno verifytoken:(NSString *)verifytoken
{
    BOOL send = [self preRequest:NLProtocolRequest_ApicouponPaySMSverify name:Notify_ApicouponPaySMSverify];
    if (!send)
    {
        NLProtocolData *pd = [[NLProtocolXML shareProtocolXML] getApicouponPaySMSverifyXML:SMSCode bkordernumber:bkordernumber bkntno:bkntno verifytoken:verifytoken];
        
        [_request startRequest:pd action:Notify_ApicouponPaySMSverify];
    }
}

//手续费计算
- (void)getApigetcreditCardMoneyPayfee:(NSString *)bankid money:(NSString *)money
{
    BOOL send = [self preRequest:NLProtocolRequest_ApigetcreditCardMoneyPayfee name:Notify_ApigetcreditCardMoneyPayfee];
    if (!send)
    {
        NLProtocolData *pd = [[NLProtocolXML shareProtocolXML] getApigetcreditCardMoneyPayfeeXML:bankid money:money];
        [_request startRequest:pd action:Notify_ApigetcreditCardMoneyPayfee];
    }
}

//信用卡还款请求
- (void)getApicreditCardMoneyRq:(NSString *)paytype paymoney:(NSString *)paymoney shoucardno:(NSString *)shoucardno shoucardmobile:(NSString *)shoucardmobile shoucardman:(NSString *)shoucardman shoucardbank:(NSString *)shoucardbank current:(NSString *)current paycardid:(NSString *)paycardid merReserved:(NSString *)merReserved bkcardbank:(NSString *)bkcardbank bkCardno:(NSString *)bkCardno bkcardman:(NSString *)bkcardman bkcardexpireMonth:(NSString *)bkcardexpireMonth bkcardmanidcard:(NSString *)bkcardmanidcard bankid:(NSString *)bankid bkcardexpireYear:(NSString *)bkcardexpireYear bkcardPhone:(NSString *)bkcardPhone bkcardcvv:(NSString *)bkcardcvv allmoney:(NSString *)allmoney feemoney:(NSString *)feemoney
{
    BOOL send = [self preRequest:NLProtocolRequest_ApicreditCardMoneyRq name:Notify_ApicreditCardMoneyRq];
    if (!send)
    {
        NLProtocolData *pd = [[NLProtocolXML shareProtocolXML] getApicreditCardMoneyRqXML:paytype paymoney:paymoney shoucardno:shoucardno shoucardmobile:shoucardmobile shoucardman:shoucardman shoucardbank:shoucardbank current:current paycardid:paycardid merReserved:merReserved bkcardbank:bkcardbank bkCardno:bkCardno bkcardman:bkcardman bkcardexpireMonth:bkcardexpireMonth bkcardmanidcard:bkcardmanidcard bankid:bankid bkcardexpireYear:bkcardexpireYear bkcardPhone:bkcardPhone bkcardcvv:bkcardcvv allmoney:allmoney feemoney:feemoney];
        [_request startRequest:pd action:Notify_ApicreditCardMoneyRq];
    }
}

//信用卡还款短信验证码验证返回
- (void)getApicreditCardMoneySMSverify:(NSString *)SMSCode bkordernumber:(NSString *)bkordernumber bkntno:(NSString *)bkntno verifytoken:(NSString *)verifytoken
{
    BOOL send = [self preRequest:NLProtocolRequest_ApicreditCardMoneySMSverify name:Notify_ApicreditCardMoneySMSverify];
    
    if (!send)
    {
        NLProtocolData *pd = [[NLProtocolXML shareProtocolXML] getApicreditCardMoneySMSverifyXML:SMSCode bkordernumber:bkordernumber bkntno:bkntno verifytoken:verifytoken];
        [_request startRequest:pd action:Notify_ApicreditCardMoneySMSverify];
    }
}

//刷卡器刷卡管理
- (void)getApipayCardCheck:(NSString *)paycardkey bkcardno:(NSString *)bkcardno paytype:(NSString *)paytype  readmode:(NSString *)cardReadmode
{
    BOOL send = [self preRequest:NLProtocolRequest_ApipayCardCheck name:Notify_ApipayCardCheck];
    
    if (!send)
    {
        NLProtocolData *pd = [[NLProtocolXML shareProtocolXML] getApipayCardCheckXML:paycardkey bkcardno:bkcardno paytype:paytype  readmode:cardReadmode];
        
        [_request startRequest:pd action:Notify_ApipayCardCheck];
    }
}

//易宝Q币充值
- (void)getApiqqrechargeReq:(NSString *)payMoney rechargemoney:(NSString *)rechargemoney RechargeQQ:(NSString *)RechargeQQ bkCardno:(NSString *)bkCardno bkcardman:(NSString *)bkcardman bkcardexpireMonth:(NSString *)bkcardexpireMonth bkcardmanidcard:(NSString *)bkcardmanidcard bankid:(NSString *)bankid bkcardexpireYear:(NSString *)bkcardexpireYear bkcardPhone:(NSString *)bkcardPhone bkcardcvv:(NSString *)bkcardcvv paytype:(NSString *)paytype paycardid:(NSString *)paycardid
{
    BOOL send = [self preRequest:NLProtocolRequest_ApiqqrechargeReq name:Notify_ApiqqrechargeReq];
    if (!send)
    {
        NLProtocolData *pd = [[NLProtocolXML shareProtocolXML] getApiqqrechargeReqXml:payMoney rechargemoney:rechargemoney RechargeQQ:RechargeQQ bkCardno:bkCardno bkcardman:bkcardman bkcardexpireMonth:bkcardexpireMonth bkcardmanidcard:bkcardmanidcard bankid:bankid bkcardexpireYear:bkcardexpireYear bkcardPhone:bkcardPhone bkcardcvv:bkcardcvv paytype:paytype paycardid:paycardid];
        [_request startRequest:pd action:Notify_ApiqqrechargeReq];
    }
}

//易宝QQ币充值短信验证码验证返回
- (void)getApiqqrechargeSMSverify:(NSString *)SMSCode bkordernumber:(NSString *)bkordernumber bkntno:(NSString *)bkntno verifytoken:(NSString *)verifytoken
{
    BOOL send = [self preRequest:NLProtocolRequest_ApiqqrechargeSMSverify name:Notify_ApiqqrechargeSMSverify];
    if (!send)
    {
        NLProtocolData *pd = [[NLProtocolXML shareProtocolXML] getApiqqrechargeSMSverifyXML:SMSCode bkordernumber:bkordernumber bkntno:bkntno verifytoken:verifytoken];
        [_request startRequest:pd action:Notify_ApiqqrechargeSMSverify];
    }
}

/*话费是否可以充值*/
- (void)getApiCanRecharge:(NSString *)money phone:(NSString*)phone
{
    BOOL send = [self preRequest:NLProtocolRequest_ApiCanRecharge name:Notify_ApiCanRecharge];
    if (!send)
    {
        NLProtocolData *pd = [[NLProtocolXML shareProtocolXML] getApiCanRechargeXML:money phone:phone];
        [_request startRequest:pd action:Notify_ApiCanRecharge];
    }
}

/*读取快捷支付默认信用卡号*/
- (void)getApiPaychannelInfo:(NSString *)bkcardid bkcardisdefault:(NSString*)bkcardisdefault
{
    BOOL send = [self preRequest:NLProtocolRequest_ApiPaychannelInfo name:Notify_ApiPaychannelInfo];
    if (!send)
    {
        NLProtocolData *pd = [[NLProtocolXML shareProtocolXML] getApiPaychannelInfoXML:bkcardid bkcardisdefault:bkcardisdefault];
        [_request startRequest:pd action:Notify_ApiPaychannelInfo];
    }
}

/*汇通宝-商户收款（抵用券）*/
- (void)getApiExpresspayInfo:(NSString *)couponid couponmoney:(NSString*)couponmoney paycardid:(NSString*)paycardid
{
    BOOL send = [self preRequest:NLProtocolRequest_ApiExpresspayInfo name:Notify_ApiExpresspayInfo];
    if (!send)
    {
        NLProtocolData *pd = [[NLProtocolXML shareProtocolXML] getApiExpresspayInfoXML:couponid couponmoney:couponmoney paycardid:paycardid];
        [_request startRequest:pd action:Notify_ApiExpresspayInfo];
    }
}

/*汇通宝-商户收款（抵用券）交易状态显示*/
- (void)getApiExpresspayInfoToPay:(NSString *)bkordernumber
{
    BOOL send = [self preRequest:NLProtocolRequest_ApiExpresspayInfoToPay name:Notify_ApiExpresspayInfoToPay];
    if (!send)
    {
        NLProtocolData *pd = [[NLProtocolXML shareProtocolXML] getApiExpresspayInfoToPayXML:bkordernumber];
        [_request startRequest:pd action:Notify_ApiExpresspayInfoToPay];
    }
}

/*酒店*/
//获取城市
- (void)getApiHotelGetCity:(NSString *)firstLetter cityName:(NSString *)cityName
{
    BOOL send = [self preRequest:NLProtocolRequest_ApiHotelGetCity name:Notify_ApiHotelGetCity];
    
    if (!send)
    {
        NLProtocolData *pd = [[NLProtocolXML shareProtocolXML] getApiHotelGetCityXML:firstLetter cityName:cityName];
        [_request startRequest:pd action:Notify_ApiHotelGetCity];
    }
}

//获取商业区/行政区
- (void)getApiHotelGetDistrict:(NSString *)cityID func:(NSString *)func
{
    BOOL send = [self preRequest:NLProtocolRequest_ApiHotelGetDistrict name:Notify_ApiHotelGetDistrict];
    
    if (!send)
    {
        NLProtocolData *pd = [[NLProtocolXML shareProtocolXML] getApiHotelGetDistrictXML:cityID func:func];
        [_request startRequest:pd action:Notify_ApiHotelGetDistrict];
    }
}

/*读取发工资的信息119*/
- (void)getApireadwagelists:(NSString *)querytype querywhere:(NSString *)querywhere bossauthorid:(NSString*)bossauthorid func:(NSString*)func Apiame:(NSString*)Apiname
{
    BOOL send = [self preRequest:NLProtocolRequest_Apireadwagelists name:Notify_Apireadwagelists];
    
    if (!send)
    {
        NLProtocolData *pd = [[NLProtocolXML shareProtocolXML] getApireadwagelistsXML:querytype querywhere:querywhere bossauthorid:bossauthorid func:func Apiame:Apiname];
        [_request startRequest:pd action:Notify_Apireadwagelists];
    }
}





@end









