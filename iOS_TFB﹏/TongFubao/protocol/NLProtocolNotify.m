//
//  NLProtocolNotify.m
//  TongFubao
//
//  Created by MD313 on 13-8-16.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLProtocolNotify.h"
#import "NLProtocolRequest.h"
#import "NLProtocolRegister.h"
#import "NLProtocolData.h"
#import "NLProtocolResponse.h"
#import "NLContants.h"
#import "NLToast.h"
#import "NLPlistOper.h"
#import "NLDataBase.h"
#import "NLSandboxFile.h"
#import "NLDoSomeNotifyEvents.h"
#import "NLUtils.h"

static NLProtocolNotify* gProtocolNotify = nil;

@interface NLProtocolNotify ()

@property (strong, nonatomic) NSString *msgbody_message;

-(void)getSmsCodeNotify:(NSNotification*)notify;
-(void)authorRegNotify:(NSNotification*)notify;
-(void)authorPwdModifyNotify:(NSNotification*)notify;
-(void)authorFeedbckNotify:(NSNotification*)notify;
-(void)checkAppVersionNotify:(NSNotification*)notify;
-(void)readAuthorInfoNotify:(NSNotification*)notify;
-(void)modifyAuthorInfoNotify:(NSNotification*)notify;
-(void)uploadAuthorPicNotify:(NSNotification*)notify;
-(void)checkAuthorLoginNotify:(NSNotification*)notify;
-(void)getSmsCodeInfoNotify:(NSNotification*)notify;
-(void)forgetPwdModifyNotify:(NSNotification*)notify;
-(void)readHelpListNotify:(NSNotification*)notify;
-(void)readMyAccountNotify:(NSNotification*)notify;
-(void)readAccglistNotify:(NSNotification*)notify;
-(void)readAccglistdetailNotify:(NSNotification*)notify;
-(void)getSmsVerifyCodeNotify:(NSNotification*)notify;
-(void)readCreditCardfeeNotify:(NSNotification*)notify;
-(void)insertcreditCardMoneyNotify:(NSNotification*)notify;
-(void)readCreditCardglistNotify:(NSNotification*)notify;
-(void)creditCardMoneyRqNotify:(NSNotification*)notify;
-(void)readTransferMoneyfeeNotify:(NSNotification*)notify;
-(void)insertTransferMoneyNotify:(NSNotification*)notify;
-(void)readTransferMoneyglistNotify:(NSNotification*)notify;
-(void)transferMoneyRqNotify:(NSNotification*)notify;
-(void)readRepayMoneyfeeNotify:(NSNotification*)notify;
-(void)insertRepayMoneyNotify:(NSNotification*)notify;
-(void)readRepayMoneyglistNotify:(NSNotification*)notify;
-(void)rechargeglistNotify:(NSNotification*)notify;
-(void)rechargeReqNotify:(NSNotification*)notify;
-(void)couponSaleNotify:(NSNotification*)notify;
-(void)couponRebuylistNotify:(NSNotification*)notify;
-(void)couponRebuyNotify:(NSNotification*)notify;
-(void)readBankListNotify:(NSNotification*)notify;
-(void)readIndexAdListNotify:(NSNotification*)notify;
-(void)activePayCardNotify:(NSNotification*)notify;
-(void)readQueryCardMoneyNotify:(NSNotification*)notify;
-(void)getTransferPayfeeNotify:(NSNotification*)notify;
-(void)getRepayMoneyPayfeeNotify:(NSNotification*)notify;
-(void)RepayMoneyRqNotify:(NSNotification*)notify;
-(void)readcouponinfoNotify:(NSNotification*)notify;
-(void)couponSalePayNotify:(NSNotification*)notify;
-(void)couponSalelistNotify:(NSNotification*)notify;
-(void)payCardCheckNotify:(NSNotification*)notify;
-(void)readAppruleListNotify:(NSNotification*)notify;
-(void)readMenuModuleNotify:(NSNotification*)notify;
-(void)kuaiStateNotify:(NSNotification*)notify;

-(void)readKuaiDicmpListNotify:(NSNotification*)notify;
-(void)chaxunKuaiDiNoNotify:(NSNotification*)notify;
-(void)readOrderListNotify:(NSNotification*)notify;
-(void)orderPayReqNotify:(NSNotification*)notify;
-(void)orderPayFeedbackNotify:(NSNotification*)notify;
-(void)orderPayBankCardStarNotify:(NSNotification*)notify;
-(void)readAuBkCardInfoNotify:(NSNotification*)notify;
-(void)modifyAuBkCardInfoNotify:(NSNotification*)notify;
-(void)readshoucardListNotify:(NSNotification*)notify;
-(void)getSupTransferPayfeeNotify:(NSNotification*)notify;
-(void)SuptransferMoneyRqNotify:(NSNotification*)notify;
-(void)insertSupTransferMoneyNotify:(NSNotification*)notify;
-(void)readSupTransferMoneyglistNotify:(NSNotification*)notify;

-(void)readRechaMoneyinfoNotify:(NSNotification*)notify;
-(void)phoneMoneyRechaNotify:(NSNotification*)notify;
-(void)checkRechaMoneyStatusNotify:(NSNotification*)notify;
-(void)readMobileRechangelistNotify:(NSNotification*)notify;

-(void)readRechaQQMoneyinfoNotify:(NSNotification*)notify;
-(void)qqMoneyRechaNotify:(NSNotification*)notify;
-(void)checkRechaQQMoneyStatusNotify:(NSNotification*)notify;
-(void)readRechangeQQlistNotify:(NSNotification*)notify;

-(void)readOrderProinfoNotify:(NSNotification*)notify;
-(void)readShaddressinfoNotify:(NSNotification*)notify;
-(void)shaddressAddNotify:(NSNotification*)notify;

-(void)shaddressDeleteNotify:(NSNotification*)notify;
-(void)payOrderRqNotify:(NSNotification*)notify;
-(void)orderPayrqStatusNotify:(NSNotification*)notify;
-(void)readSKQOrderlistNotify:(NSNotification*)notify;
-(void)waterEleGetProductListNotify:(NSNotification *)notify;
-(void)waterElecreateOrderNotify:(NSNotification *)notify;
-(void)waterElesubmitOrderNotify:(NSNotification *)notify;
-(void)waterElecompleteOrderNotify:(NSNotification *)notify;
-(void)waterElegetOrderHistoryNotify:(NSNotification *)notify;

-(void)gameChargeGetGamelistNotify:(NSNotification*)notify;
-(void)gameChargeGetPlatformNotify:(NSNotification*)notify;
-(void)gameChargeGetChildGameNotify:(NSNotification*)notify;
-(void)gameChargeGetGameDetailNotify:(NSNotification*)notify;
-(void)gameChargeCreateOrderNotify:(NSNotification*)notify;
-(void)gameChargeCompleteOrderNotify:(NSNotification*)notify;
-(void)gameChargeGetOrderHistoryNotify:(NSNotification*)notify;

-(void)readagentinfoNotify:(NSNotification*)notify;
-(void)readagentorderlistNotify:(NSNotification*)notify;
-(void)agentorderstaterqNotify:(NSNotification*)notify;
-(void)payagentOrderRqNotify:(NSNotification*)notify;
-(void)agentorderPayrqStatusNotify:(NSNotification*)notify;
-(void)payagentfenrunlistNotify:(NSNotification*)notify;

-(void)ApiAuthorInfoV2Notify:(NSNotification*)notify;
-(void)ApiAuthorInfoV2IsOnMainNotify:(NSNotification*)notify;
- (void)ApiAuthorInfoV2GestureNotify:(NSNotification*)notify;
- (void)ApiAuthorInfoV2GestureToHanderNotify:(NSNotification*)notify;
- (void)ApiAuthorInfoPasswordToChageNotify:(NSNotification*)notify;
-(void)ApiSafeGuardNotify:(NSNotification*)notify;
-(void)ApiSafeGuardMsgchildNotify:(NSNotification*)notify;
-(void)ApiSafeGuardUserNotify:(NSNotification*)notify;
-(void)ApiAuthorInfoV2ChangeLoginPasswordNotify:(NSNotification*)notify;
-(void)ApiAuthorInfoV2modifyAuthorInfoNotify:(NSNotification*)notify;
-(void)ApiSafeGuardLoginUpNotify:(NSNotification*)notify;

-(void)ApiAirticketNotify:(NSNotification*)notify;
-(void)ApigetAirlineNotify:(NSNotification*)notify;
-(void)ApireadMenuModuleNotify:(NSNotification*)notify;
-(void)ApiauthorMenuCountNotify:(NSNotification*)notify;

- (void)ApiAgentInfoNotify:(NSNotification *)notify;
- (void)ApiAgentApplyProvNotify:(NSNotification *)notify;
- (void)ApiAgentApplyCityNotify:(NSNotification *)notify;
- (void)ApiAgentApplyTownNotify:(NSNotification *)notify;
- (void)ApiAgentApplyBasinfoNotify:(NSNotification *)notify;
- (void)ApiAgentApplyAddNotify:(NSNotification *)notify;
- (void)ApiAgentInfoBindNotify:(NSNotification *)notify;
- (void)ApiAgentApplyInsertParttNotify:(NSNotification *)notify;

//读取新的信息
- (void)ApiAppInfoNotify:(NSNotification *)notify;

/*我的银行卡*/
//读取用户银行卡列表
- (void)ApiApiAuthorKuaibkcardInfoListsNotify:(NSNotification *)notify;
//添加新的银行卡
- (void)ApiAuthorKuaibkcardInfoAddNotify:(NSNotification *)notify;
//修改银行卡
- (void)ApiAuthorKuaibkcardInfoEditNotify:(NSNotification *)notify;
//移除银行卡
- (void)ApiAuthorKuaibkcardInfoDeleteNotify:(NSNotification *)notify;
//绑定银行卡
- (void)ApiAuthorKuaibkcardInfoDefaultNotify:(NSNotification *)notify;

/*易宝充值*/
- (void)ApiYiBaoPhonePayNotify:(NSNotification *)notify;
- (void)ApiYiBaoVerifyCodeNotify:(NSNotification *)notify;
/*易宝转账*/
- (void)ApiTransferWithCreditCard:(NSNotification *)notify;
- (void)ApiPayWithVerifyCode:(NSNotification *)notify;
/*易宝游戏*/
- (void)ApiGamePayWithCreditCard:(NSNotification *)notify;
- (void)ApiGamePayWithVerifyCode:(NSNotification *)notify;
/*话费是否可以充值*/
- (void)ApiCanRecharge:(NSNotification *)notify;
/*读取快捷支付默认信用卡*/
- (void)ApiPaychannelInfo:(NSNotification *)notify;

@end

@implementation NLProtocolNotify

+(id)shareProtocolNotify
{
    if (gProtocolNotify == nil)
    {
        gProtocolNotify=[[NLProtocolNotify alloc] init];
    }
    return gProtocolNotify;
}

-(void)plistOperation:(NSString*)filePath key:(NSString*)key value:(NSString*)value
{
    [NLPlistOper writeValue:value key:key path:filePath];
}

#pragma mark - notify

-(void)addNotify:(NLProtocolRequestType)type
{
    switch (type)
    {
        case NLProtocolRequest_getSmsCode:
        {
            REGISTER_NOTIFY_OBSERVER(self, getSmsCodeNotify, Notify_getSmsCode);
        }
            break;
        case NLProtocolRequest_authorReg:
        {
            REGISTER_NOTIFY_OBSERVER(self, authorRegNotify, Notify_authorReg);
        }
            break;
            
        case NLProtocolRequest_authorPwdModify:
        {
            REGISTER_NOTIFY_OBSERVER(self, authorPwdModifyNotify, Notify_authorPwdModify);
        }
            break;
            
        case NLProtocolRequest_authorFeedbck:
        {
            REGISTER_NOTIFY_OBSERVER(self, authorFeedbckNotify, Notify_authorFeedbck);
        }
            break;
            
        case NLProtocolRequest_checkAppVersion:
        {
            REGISTER_NOTIFY_OBSERVER(self, checkAppVersionNotify, Notify_checkAppVersion);
        }
            break;
            
        case NLProtocolRequest_readAuthorInfo:
        {
            REGISTER_NOTIFY_OBSERVER(self, readAuthorInfoNotify, Notify_readAuthorInfo);
        }
            break;
            
        case NLProtocolRequest_modifyAuthorInfo:
        {
            REGISTER_NOTIFY_OBSERVER(self, modifyAuthorInfoNotify, Notify_modifyAuthorInfo);
        }
            break;
            
        case NLProtocolRequest_uploadAuthorPic:
        {
            REGISTER_NOTIFY_OBSERVER(self, uploadAuthorPicNotify, Notify_uploadAuthorPic);
        }
            break;
            
        case NLProtocolRequest_checkAuthorLogin:
        {
            REGISTER_NOTIFY_OBSERVER(self, checkAuthorLoginNotify, Notify_checkAuthorLogin);
        }
            break;
            
        case NLProtocolRequest_getSmsCodeInfo:
        {
            REGISTER_NOTIFY_OBSERVER(self, getSmsCodeInfoNotify, Notify_getSmsCodeInfo);
        }
            break;
            
        case NLProtocolRequest_forgetPwdModify:
        {
            REGISTER_NOTIFY_OBSERVER(self, forgetPwdModifyNotify, Notify_forgetPwdModify);
        }
            break;
            
        case NLProtocolRequest_readHelpList:
        {
            REGISTER_NOTIFY_OBSERVER(self, readHelpListNotify, Notify_readHelpList);
        }
            break;
         
        case NLProtocolRequest_readMyAccount:
        {
            REGISTER_NOTIFY_OBSERVER(self, readMyAccountNotify, Notify_readMyAccount);
        }
            break;
            
        case NLProtocolRequest_readAccglist:
        {
            REGISTER_NOTIFY_OBSERVER(self, readAccglistNotify, Notify_readAccglist);
        }
            break;
            
        case NLProtocolRequest_readAccglistdetail:
        {
            REGISTER_NOTIFY_OBSERVER(self, readAccglistdetailNotify, Notify_readAccglistdetail);
        }
            break;
            
        case NLProtocolRequest_transferMoneyRq:
        {
            REGISTER_NOTIFY_OBSERVER(self, transferMoneyRqNotify, Notify_transferMoneyRq);
        }
            break;
            
        case NLProtocolRequest_getSmsVerifyCode:
        {
            REGISTER_NOTIFY_OBSERVER(self, getSmsVerifyCodeNotify, Notify_getSmsVerifyCode);
        }
            break;
            
        case NLProtocolRequest_readCreditCardfee:
        {
            REGISTER_NOTIFY_OBSERVER(self, readCreditCardfeeNotify, Notify_readCreditCardfee);
        }
            break;
            
        case NLProtocolRequest_creditCardMoneyRq:
        {
            REGISTER_NOTIFY_OBSERVER(self, creditCardMoneyRqNotify, Notify_creditCardMoneyRq);
        }
            break;
            
        case NLProtocolRequest_insertcreditCardMoney:
        {
            REGISTER_NOTIFY_OBSERVER(self, insertcreditCardMoneyNotify, Notify_insertcreditCardMoney);
        }
            break;
    
        case NLProtocolRequest_readCreditCardglist:
        {
            REGISTER_NOTIFY_OBSERVER(self, readCreditCardglistNotify, Notify_readCreditCardglist);
        }
            break;
            
        case NLProtocolRequest_readTransferMoneyfee:
        {
            REGISTER_NOTIFY_OBSERVER(self, readTransferMoneyfeeNotify, Notify_readTransferMoneyfee);
        }
            break;
            
        case NLProtocolRequest_insertTransferMoney:
        {
            REGISTER_NOTIFY_OBSERVER(self, insertTransferMoneyNotify, Notify_insertTransferMoney);
        }
            break;
            
        case NLProtocolRequest_readTransferMoneyglist:
        {
            REGISTER_NOTIFY_OBSERVER(self, readTransferMoneyglistNotify, Notify_readTransferMoneyglist);
        }
            break;
            
        case NLProtocolRequest_readRepayMoneyfee:
        {
            REGISTER_NOTIFY_OBSERVER(self, readRepayMoneyfeeNotify, Notify_readRepayMoneyfee);
        }
            break;
            
        case NLProtocolRequest_insertRepayMoney:
        {
            REGISTER_NOTIFY_OBSERVER(self, insertRepayMoneyNotify, Notify_insertRepayMoney);
        }
            break;
            
        case NLProtocolRequest_rechargeglist:
        {
            REGISTER_NOTIFY_OBSERVER(self, rechargeglistNotify, Notify_rechargeglist);
        }
            break;
            
        case NLProtocolRequest_rechargeReq:
        {
            REGISTER_NOTIFY_OBSERVER(self, rechargeReqNotify, Notify_rechargeReq);
        }
            break;
            
        case NLProtocolRequest_rechargePay:
        {
            REGISTER_NOTIFY_OBSERVER(self, rechargePayNotify, Notify_rechargePay);
        }
            break;
            
        case NLProtocolRequest_readRepayMoneyglist:
        {
            REGISTER_NOTIFY_OBSERVER(self, readRepayMoneyglistNotify, Notify_readRepayMoneyglist);
        }
            break;
            
        case NLProtocolRequest_couponSale:
        {
            REGISTER_NOTIFY_OBSERVER(self, couponSaleNotify, Notify_couponSale);
        }
            break;
            
        case NLProtocolRequest_couponRebuylist:
        {
            REGISTER_NOTIFY_OBSERVER(self, couponRebuylistNotify, Notify_couponRebuylist);
        }
            break;
            
        case NLProtocolRequest_couponRebuy:
        {
            REGISTER_NOTIFY_OBSERVER(self, couponRebuyNotify, Notify_couponRebuy);
        }
            break;
            
        case NLProtocolRequest_readBankList:
        {
            REGISTER_NOTIFY_OBSERVER(self, readBankListNotify, Notify_readBankList);
        }
            break;
            
        case NLProtocolRequest_readIndexAdList:
        {
            REGISTER_NOTIFY_OBSERVER(self, readIndexAdListNotify, Notify_readIndexAdList);
        }
            break;
            
        case NLProtocolRequest_activePayCard:
        {
            REGISTER_NOTIFY_OBSERVER(self, activePayCardNotify, Notify_activePayCard);
        }
            break;
            
        case NLProtocolRequest_readQueryCardMoney:
        {
            REGISTER_NOTIFY_OBSERVER(self, readQueryCardMoneyNotify, Notify_readQueryCardMoney);
        }
            break;
            
        case NLProtocolRequest_getTransferPayfee:
        {
            REGISTER_NOTIFY_OBSERVER(self, getTransferPayfeeNotify, Notify_getTransferPayfee);
        }
            break;
            
        case NLProtocolRequest_getRepayMoneyPayfee:
        {
            REGISTER_NOTIFY_OBSERVER(self, getRepayMoneyPayfeeNotify, Notify_getRepayMoneyPayfee);
        }
            break;
            
        case NLProtocolRequest_RepayMoneyRq:
        {
            REGISTER_NOTIFY_OBSERVER(self, RepayMoneyRqNotify, Notify_RepayMoneyRq);
        }
            break;
            
        case NLProtocolRequest_readcouponinfo:
        {
            REGISTER_NOTIFY_OBSERVER(self, readcouponinfoNotify, Notify_readcouponinfo);
        }
            break;
            
        case NLProtocolRequest_couponSalePay:
        {
            REGISTER_NOTIFY_OBSERVER(self, couponSalePayNotify, Notify_couponSalePay);
        }
            break;
            
        case NLProtocolRequest_couponSalelist:
        {
            REGISTER_NOTIFY_OBSERVER(self, couponSalelistNotify, Notify_couponSalelist);
        }
            break;
            
        case NLProtocolRequest_payCardCheck:
        {
            REGISTER_NOTIFY_OBSERVER(self, payCardCheckNotify, Notify_payCardCheck);
        }
            break;
            
        case NLProtocolRequest_readAppruleList:
        {
            REGISTER_NOTIFY_OBSERVER(self, readAppruleListNotify, Notify_readAppruleList);
        }
            break;
            
        case NLProtocolRequest_readMenuModule:
        {
            REGISTER_NOTIFY_OBSERVER(self, readMenuModuleNotify, Notify_readMenuModule);
        }
            break;
            
            //快递的接口
        case NLProtocolRequest_kuaiState:
        {
            //监听快递的接口进行数据的获取
            REGISTER_NOTIFY_OBSERVER(self, kuaiStateNotify, Notify_kuaiState);
        }
            break;
          
        //读取充值金额选项
        case NLProtocolRequest_readRechaMoneyinfo:
        {
            REGISTER_NOTIFY_OBSERVER(self, readRechaMoneyinfoNotify, Notify_readRechaMoneyinfo);
        }
            break;
          //话费充值接口
            case NLProtocolRequest_RechaMoneyRq:
        {
             REGISTER_NOTIFY_OBSERVER(self,phoneMoneyRechaNotify, Notify_RechaMoneyRq);
        }
            break;
        
          //手机充值支付成功反馈
        case NLProtocolRequest_checkRechaMoneyStatus:
        {
            REGISTER_NOTIFY_OBSERVER(self,checkRechaMoneyStatusNotify, Notify_checkRechaMoneyStatus);
        }
            break;
            
         //手机充值历史
        case NLProtocolRequest_readMobileRechangelist:
        {
            REGISTER_NOTIFY_OBSERVER(self, readMobileRechangelistNotify, Notify_readMobileRechangelist);
        }
            break;
          
         //读取qq充值金额选项
        case NLProtocolRequest_readRechaQQMoneyinfo:
        {
             REGISTER_NOTIFY_OBSERVER(self, readRechaQQMoneyinfoNotify, Notify_readRechaQQMoneyinfo);
        }
            break;
            
        //q币充值
        case NLProtocolRequest_RechaQQMoneyRq:
        {
            REGISTER_NOTIFY_OBSERVER(self, qqMoneyRechaNotify, Notify_RechaQQMoneyRq);
        }
            break;
            
        //Q币充值支付成功反馈
        case NLProtocolRequest_checkRechaQQMoneyStatus:
        {
            REGISTER_NOTIFY_OBSERVER(self,checkRechaQQMoneyStatusNotify, Notify_checkRechaQQMoneyStatus);
        }
            break;
        //读取qq充值历史
        case NLProtocolRequest_readRechangeQQlist:
        {
            REGISTER_NOTIFY_OBSERVER(self, readRechangeQQlistNotify, Notify_readRechangeQQlist);
        }
            break;
            
        case NLProtocolRequest_readKuaiDicmpList:
        {
            REGISTER_NOTIFY_OBSERVER(self, readKuaiDicmpListNotify, Notify_readKuaiDicmpList);
        }
            break;
            
        case NLProtocolRequest_chaxunKuaiDiNo:
        {
            REGISTER_NOTIFY_OBSERVER(self, chaxunKuaiDiNoNotify, Notify_chaxunKuaiDiNo);
        }
            break;
            
        case NLProtocolRequest_readOrderList:
        {
            REGISTER_NOTIFY_OBSERVER(self, readOrderListNotify, Notify_readOrderList);
        }
            break;
            
        case NLProtocolRequest_orderPayReq:
        {
            REGISTER_NOTIFY_OBSERVER(self, orderPayReqNotify, Notify_orderPayReq);
        }
            break;
            
        case NLProtocolRequest_orderPayFeedback:
        {
            REGISTER_NOTIFY_OBSERVER(self, orderPayFeedbackNotify, Notify_orderPayFeedback);
        }
            break;
            
        case NLProtocolRequest_orderPayBankCardStar:
        {
            REGISTER_NOTIFY_OBSERVER(self, orderPayBankCardStarNotify, Notify_orderPayBankCardStar);
        }
            break;
            
        case NLProtocolRequest_readAuBkCardInfo:
        {
            REGISTER_NOTIFY_OBSERVER(self, readAuBkCardInfoNotify, Notify_readAuBkCardInfo);
        }
            break;
            
        case NLProtocolRequest_modifyAuBkCardInfo:
        {
            REGISTER_NOTIFY_OBSERVER(self, modifyAuBkCardInfoNotify, Notify_modifyAuBkCardInfo);
        }
            break;
            
        case NLProtocolRequest_readshoucardList:
        {
            REGISTER_NOTIFY_OBSERVER(self, readshoucardListNotify, Notify_readshoucardList);
        }
            break;
            
        case NLProtocolRequest_getSupTransferPayfee:
        {
            REGISTER_NOTIFY_OBSERVER(self, getSupTransferPayfeeNotify, Notify_getSupTransferPayfee);
        }
            break;
            
        case NLProtocolRequest_SuptransferMoneyRq:
        {
            REGISTER_NOTIFY_OBSERVER(self, SuptransferMoneyRqNotify, Notify_SuptransferMoneyRq);
        }
            break;
            
        case NLProtocolRequest_insertSupTransferMoney:
        {
            REGISTER_NOTIFY_OBSERVER(self, insertSupTransferMoneyNotify, Notify_insertSupTransferMoney);
        }
            break;
            
        case NLProtocolRequest_readSupTransferMoneyglist:
        {
            REGISTER_NOTIFY_OBSERVER(self, readSupTransferMoneyglistNotify, Notify_readSupTransferMoneyglist);
        }
            break;
        case NLProtocolRequest_readOrderProinfo:
        {
            REGISTER_NOTIFY_OBSERVER(self, readOrderProinfoNotify, Notify_readOrderProinfo);
        }
            break;
        case NLProtocolRequest_readShaddressinfo:
        {
            REGISTER_NOTIFY_OBSERVER(self, readShaddressinfoNotify, Notify_readShaddressinfo);
        }
            break;
        case NLProtocolRequest_shaddressAdd:
        {
            REGISTER_NOTIFY_OBSERVER(self, shaddressAddNotify, Notify_shaddressAdd);
        }
            break;
        case NLProtocolRequest_shaddressDelete:
        {
            REGISTER_NOTIFY_OBSERVER(self, shaddressDeleteNotify, Notify_shaddressDelete);
        }
            break;
        case NLProtocolRequest_payOrderRq:
        {
            REGISTER_NOTIFY_OBSERVER(self, payOrderRqNotify, Notify_payOrderRq);
        }
            break;
        case NLProtocolRequest_orderPayrqStatus:
        {
            REGISTER_NOTIFY_OBSERVER(self, orderPayrqStatusNotify, Notify_orderPayrqStatus);
        }
            break;
        case NLProtocolRequest_readSKQOrderlist:
        {
            REGISTER_NOTIFY_OBSERVER(self, readSKQOrderlistNotify, Notify_readSKQOrderlist);
        }
            break;
        case NLProtocolRequest_waterEle_getProductList:
        {
            REGISTER_NOTIFY_OBSERVER(self, waterEleGetProductListNotify, Notify_waterEle_getProductList);
        }
            break;
        case NLProtocolRequest_waterEle_createOrder:
        {
            REGISTER_NOTIFY_OBSERVER(self, waterElecreateOrderNotify, Notify_waterEle_createOrder);
        }
            break;
        case NLProtocolRequest_waterEle_submitOrder:
        {
            REGISTER_NOTIFY_OBSERVER(self, waterElesubmitOrderNotify, Notify_waterEle_submitOrder);
        }
            break;
        case NLProtocolRequest_waterEle_completeOrder:
        {
            REGISTER_NOTIFY_OBSERVER(self, waterElecompleteOrderNotify, Notify_waterEle_completeOrder);
        }
            break;
        case NLProtocolRequest_waterEle_getOrderHistory:
        {
            REGISTER_NOTIFY_OBSERVER(self, waterElegetOrderHistoryNotify, Notify_waterEle_getOrderHistory);
        }
            break;
        case NLProtocolRequest_gameCharge_getGameList:
        {
            REGISTER_NOTIFY_OBSERVER(self, gameChargeGetGamelistNotify, Notify_gameCharge_getGameList);
        }
            break;
        case NLProtocolRequest_gameCharge_getplatformList:
        {
            REGISTER_NOTIFY_OBSERVER(self, gameChargeGetPlatformNotify, Notify_gameCharge_getplatformList);
        }
            break;
        case NLProtocolRequest_gameCharge_getChildGame:
        {
            REGISTER_NOTIFY_OBSERVER(self, gameChargeGetChildGameNotify, Notify_gameCharge_getChildGame);
        }
            break;
        case NLProtocolRequest_gameCharge_getGameDetail:
        {
            REGISTER_NOTIFY_OBSERVER(self, gameChargeGetGameDetailNotify, Notify_gameCharge_getGameDetail);
        }
            break;
        case NLProtocolRequest_gameCharge_createOrder:
        {
            REGISTER_NOTIFY_OBSERVER(self, gameChargeCreateOrderNotify, Notify_gameCharge_createOrder);
        }
            break;
        case NLProtocolRequest_gameCharge_completeOrder:
        {
            REGISTER_NOTIFY_OBSERVER(self, gameChargeCompleteOrderNotify, Notify_gameCharge_completeOrder);
        }
            break;
        case NLProtocolRequest_gameCharge_getOrderHistory:
        {
            REGISTER_NOTIFY_OBSERVER(self, gameChargeGetOrderHistoryNotify, Notify_gameCharge_getOrderHistory);
        }
            break;
        case NLProtocolRequest_readagentinfo:
        {
            REGISTER_NOTIFY_OBSERVER(self, readagentinfoNotify, Notify_readagentinfo);
        }
            break;
        case NLProtocolRequest_readagentorder:
        {
            REGISTER_NOTIFY_OBSERVER(self, readagentorderlistNotify, Notify_readagentorder);
        }
            break;
        case NLProtocolRequest_agentorderstaterq:
        {
            REGISTER_NOTIFY_OBSERVER(self, agentorderstaterqNotify, Notify_agentorderstaterq);
        }
            break;
        case NLProtocolRequest_payagentOrderRq:
        {
            REGISTER_NOTIFY_OBSERVER(self, payagentOrderRqNotify, Notify_payagentOrderRq);
        }
            break;
        case NLProtocolRequest_agentorderPayrqStatus:
        {
            REGISTER_NOTIFY_OBSERVER(self, agentorderPayrqStatusNotify, Notify_agentorderPayrqStatus);
        }
            break;
        case NLProtocolRequest_payagentfenrunlist:
        {
            REGISTER_NOTIFY_OBSERVER(self, payagentfenrunlistNotify, Notify_payagentfenrunlist);
        }
            break;
            /*绑定代理商*/
        case NLProtocolRequest_BindingAgentId:{
             REGISTER_NOTIFY_OBSERVER(self, BindingAgentIdNotify, Notify_BindingAgentId);
            
        }
            break;
            /*最新的注册接口*/
        case NLProtocolRequest_ApiAuthorInfoV2:{
             REGISTER_NOTIFY_OBSERVER(self, ApiAuthorInfoV2Notify, Notify_ApiAuthorInfoV2);
        }
            break;
            /*判断是否注册接口*/
        case NLProtocolRequest_ApiAuthorInfoV2IsOnMain:{
            REGISTER_NOTIFY_OBSERVER(self, ApiAuthorInfoV2IsOnMainNotify, Notify_ApiAuthorInfoV2IsOnMain);
        }
            break;
        case NLProtocolRequest_ApiAuthorInfoV2Gesture:{
            REGISTER_NOTIFY_OBSERVER(self, ApiAuthorInfoV2GestureNotify, Notify_ApiAuthorInfoV2Gesture);
        }
            break;
            /*用户手势登录*/
        case NLProtocolRequest_ApiAuthorInfoV2GestureToHander:{
            REGISTER_NOTIFY_OBSERVER(self, ApiAuthorInfoV2GestureToHanderNotify, Notify_ApiAuthorInfoV2GestureToHander);
        }
            break;
            /*用户密码修改*/
        case NLProtocolRequest_ApiAuthorInfoPasswordToChage:{
            REGISTER_NOTIFY_OBSERVER(self, ApiAuthorInfoPasswordToChageNotify, Notify_ApiAuthorInfoPasswordToChage);
        }
            break;
            /*用户login密码修改*/
        case NLProtocolRequest_ApiAuthorInfoV2ChangeLoginPassword:{
            REGISTER_NOTIFY_OBSERVER(self, ApiAuthorInfoV2ChangeLoginPasswordNotify, Notify_ApiAuthorInfoV2ChangeLoginPassword);
        }
            break;
            /*获取预设密保*/
        case NLProtocolRequest_ApiSafeGuardIsOn:
              REGISTER_NOTIFY_OBSERVER(self, ApiSafeGuardNotify, Notify_ApiSafeGuardIsOn);
            break;
            /*设置密保*/
        case NLProtocolRequest_ApiSafeGuardSetting:
             REGISTER_NOTIFY_OBSERVER(self,     ApiSafeGuardMsgchildNotify, Notify_ApiSafeGuardSetting);
            break;
        case NLProtocolRequest_ApiSafeGuardUser:
            REGISTER_NOTIFY_OBSERVER(self,     ApiSafeGuardUserNotify, Notify_ApiSafeGuardUser);
            break;
        case NLProtocolRequest_ApiSafeGuardLoginUp:
            REGISTER_NOTIFY_OBSERVER(self,     ApiSafeGuardLoginUpNotify, Notify_ApiSafeGuardLoginUp);
            break;
            /*修改信息*/
        case NLProtocolRequest_ApiAuthorInfoV2modifyAuthorInfo:
            REGISTER_NOTIFY_OBSERVER(self,     ApiAuthorInfoV2modifyAuthorInfoNotify, Notify_ApiAuthorInfoV2modifyAuthorInfo);
            break;
            /*机票信息查询*/
        case NLProtocolRequest_ApiAirticket:
            REGISTER_NOTIFY_OBSERVER(self,ApiAirticketNotify, Notify_ApiAirticket);
            break;
            /*查询航班*/
        case NLProtocolRequest_ApigetAirline:
            REGISTER_NOTIFY_OBSERVER(self,ApigetAirlineNotify, Notify_ApigetAirline);
            break;
            /*菜单模板读取*/
        case NLProtocolRequest_ApireadMenuModule:
            REGISTER_NOTIFY_OBSERVER(self,ApireadMenuModuleNotify, Notify_ApireadMenuModule);
            break;
            /*商户点击功能菜单累计使用次数*/
        case NLProtocolRequest_ApiauthorMenuCount:
            REGISTER_NOTIFY_OBSERVER(self,ApiauthorMenuCountNotify, Notify_ApiauthorMenuCount);
            break;
            /*商户读取代理商信息*/
        case NLProtocolRequest_ApiAgentInfo:
            REGISTER_NOTIFY_OBSERVER(self, ApiAgentInfoNotify, Notify_ApiAgentInfo);
            break;
            
            //代理商地区省
        case NLProtocolRequest_ApiAgentApplyProv:
            REGISTER_NOTIFY_OBSERVER(self, ApiAgentApplyProvNotify, Notify_ApiAgentApplyProv);
            break;
            //代理商地区市
        case NLProtocolRequest_ApiAgentApplyCity:
            REGISTER_NOTIFY_OBSERVER(self, ApiAgentApplyCityNotify, Notify_ApiAgentApplyCity);
            break;
            //代理商地区区
        case NLProtocolRequest_ApiAgentApplyTown:
            REGISTER_NOTIFY_OBSERVER(self, ApiAgentApplyTownNotify, Notify_ApiAgentApplyTown);
            break;
        case NLProtocolRequest_ApiAgentApplyBasinfo:
            REGISTER_NOTIFY_OBSERVER(self, ApiAgentApplyBasinfoNotify, Notify_ApiAgentApplyBasinfo);
            break;
            //代理商申请
        case NLProtocolRequest_ApiAgentApplyAdd:
            REGISTER_NOTIFY_OBSERVER(self, ApiAgentApplyAddNotify, Notify_ApiAgentApplyAdd);
            break;
            //绑定代理商
        case NLProtocolRequest_ApiAgentInfoBind:
            REGISTER_NOTIFY_OBSERVER(self, ApiAgentInfoBindNotify, Notify_ApiAgentInfoBind);
            break;
        case NLProtocolRequest_ApiAgentApplyInsertPartt:
            REGISTER_NOTIFY_OBSERVER(self, ApiAgentApplyInsertParttNotify, Notify_ApiAgentApplyInsertPartt);
            break;
            //读取新的信息
        case NLProtocolRequest_ApiAppInfo:
            REGISTER_NOTIFY_OBSERVER(self, ApiAppInfoNotify, Notify_ApiAppInfo);
            break;
        /*我的银行卡*/
        case NLProtocolRequest_ApiAuthorKuaibkcardInfoLists:
            REGISTER_NOTIFY_OBSERVER(self, ApiApiAuthorKuaibkcardInfoListsNotify, Notify_ApiAuthorKuaibkcardInfoLists);
            break;
        //添加新的银行卡
        case NLProtocolRequest_ApiAuthorKuaibkcardInfoAdd:
            REGISTER_NOTIFY_OBSERVER(self, ApiAuthorKuaibkcardInfoAddNotify, Notify_ApiAuthorKuaibkcardInfoAdd);
            break;
        //修改银行卡
        case NLProtocolRequest_ApiAuthorKuaibkcardInfoEdit:
            REGISTER_NOTIFY_OBSERVER(self, ApiAuthorKuaibkcardInfoEditNotify, Notify_ApiAuthorKuaibkcardInfoEdit);
            break;
        //移除银行卡
        case NLProtocolRequest_ApiAuthorKuaibkcardInfoDelete:
            REGISTER_NOTIFY_OBSERVER(self, ApiAuthorKuaibkcardInfoDeleteNotify, Notify_ApiAuthorKuaibkcardInfoDelete);
            break;
        //绑定银行卡
        case NLProtocolRequest_ApiAuthorKuaibkcardInfoDefault:
            REGISTER_NOTIFY_OBSERVER(self, ApiAuthorKuaibkcardInfoDefaultNotify, Notify_ApiAuthorKuaibkcardInfoDefault);
            break;
         /*易宝充值的*/
        case NLProtocolRequest_ApiYiBaoPhonePay:
            REGISTER_NOTIFY_OBSERVER(self, ApiYiBaoPhonePayNotify, Notify_ApiYiBaoPhonePay);
            break;
        /*易宝验证码*/
        case NLProtocolRequest_ApiYiBaoVerifyCode:
            REGISTER_NOTIFY_OBSERVER(self, ApiYiBaoVerifyCodeNotify, Notify_ApiYiBaoVerifyCode);
            break;
        /*易宝信用卡转账*/
        case NLProtocolRequest_ApiTransferWithCreditCard:
            REGISTER_NOTIFY_OBSERVER(self, ApiTransferWithCreditCard, Notify_ApiTransferWithCreditCard);
            break;
        /*易宝信用卡验证码*/
        case NLProtocolRequest_ApiPayWithVerifyCode:
            REGISTER_NOTIFY_OBSERVER(self, ApiPayWithVerifyCode, Notify_ApiPayWithVerifyCode);
            break;
        /*易宝游戏充值*/
        case NLProtocolRequest_ApiGamePayWithCreditCard:
            REGISTER_NOTIFY_OBSERVER(self, ApiGamePayWithCreditCard, Notify_ApiGamePayWithCreditCard);
            break;
        /*易宝游戏验证码*/
        case NLProtocolRequest_ApiGamePayWithVerifyCode:
            REGISTER_NOTIFY_OBSERVER(self, ApiGamePayWithVerifyCode, Notify_ApiGamePayWithVerifyCode);
            break;
        /*话费是否可以充值*/
        case NLProtocolRequest_ApiCanRecharge:
            REGISTER_NOTIFY_OBSERVER(self, ApiCanRecharge, Notify_ApiCanRecharge);
            break;
        /*读取快捷支付默认信用卡*/
        case NLProtocolRequest_ApiPaychannelInfo:
            REGISTER_NOTIFY_OBSERVER(self, ApiPaychannelInfo, Notify_ApiPaychannelInfo);
            break;
          
            
        default:
            break;
    }
}

-(void)removeNotify:(NLProtocolRequestType)type
{
    switch (type)
    {
        case NLProtocolRequest_getSmsCode:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_getSmsCode);
        }
            break;
        case NLProtocolRequest_authorReg:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_authorReg);
        }
            break;
            
        case NLProtocolRequest_authorPwdModify:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_authorPwdModify);
        }
            break;
            
        case NLProtocolRequest_authorFeedbck:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_authorFeedbck);
        }
            break;
            
        case NLProtocolRequest_checkAppVersion:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_checkAppVersion);
        }
            break;
            
        case NLProtocolRequest_readAuthorInfo:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_readAuthorInfo);
        }
            break;
            
        case NLProtocolRequest_transferMoneyRq:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_transferMoneyRq);
        }
            break;
            
        case NLProtocolRequest_modifyAuthorInfo:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_modifyAuthorInfo);
        }
            break;
            
        case NLProtocolRequest_uploadAuthorPic:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_modifyAuthorInfo);
        }
            break;
            
        case NLProtocolRequest_checkAuthorLogin:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_checkAuthorLogin);
        }
            break;
          
        case NLProtocolRequest_getSmsCodeInfo:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_getSmsCodeInfo);
        }
            break;
            
        case NLProtocolRequest_forgetPwdModify:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_forgetPwdModify);
        }
            break;
            
        case NLProtocolRequest_readHelpList:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_readHelpList);
        }
            break;
            
        case NLProtocolRequest_readMyAccount:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_readMyAccount);
        }
            break;
            
        case NLProtocolRequest_readAccglist:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_readAccglist);
        }
            break;
            
        case NLProtocolRequest_readAccglistdetail:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_readAccglistdetail);
        }
            break;
            
        case NLProtocolRequest_getSmsVerifyCode:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_getSmsVerifyCode);
        }
            break;
            
        case NLProtocolRequest_readCreditCardfee:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_readCreditCardfee);
        }
            break;
            
        case NLProtocolRequest_creditCardMoneyRq:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_creditCardMoneyRq);
        }
            break;
            
        case NLProtocolRequest_insertcreditCardMoney:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_insertcreditCardMoney);
        }
            break;
            
        case NLProtocolRequest_readCreditCardglist:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_readCreditCardglist);
        }
            break;
            
        case NLProtocolRequest_readTransferMoneyfee:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_readTransferMoneyfee);
        }
            break;
            
        case NLProtocolRequest_insertTransferMoney:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_insertTransferMoney);
        }
            break;
            
        case NLProtocolRequest_readTransferMoneyglist:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_readTransferMoneyglist);
        }
            break;
            
        case NLProtocolRequest_readRepayMoneyfee:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_readRepayMoneyfee);
        }
            break;
            
        case NLProtocolRequest_insertRepayMoney:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_insertRepayMoney);
        }
            break;
            
        case NLProtocolRequest_rechargeglist:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_rechargeglist);
        }
            break;
            
        case NLProtocolRequest_rechargeReq:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_rechargeReq);
        }
            break;
            
        case NLProtocolRequest_rechargePay:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_rechargePay);
        }
            break;
            
        case NLProtocolRequest_readRepayMoneyglist:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_readRepayMoneyglist);
        }
            break;
            
        case NLProtocolRequest_couponSale:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_couponSale);
        }
            break;
            
        case NLProtocolRequest_couponRebuylist:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_couponRebuylist);
        }
            break;
            
        case NLProtocolRequest_couponRebuy:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_couponRebuy);
        }
            break;
            
        case NLProtocolRequest_readBankList:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_readBankList);
        }
            break;
            
        case NLProtocolRequest_readIndexAdList:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_readIndexAdList);
        }
            break;
            
        case NLProtocolRequest_activePayCard:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_activePayCard);
        }
            break;
            
        case NLProtocolRequest_readQueryCardMoney:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_readQueryCardMoney);
        }
            break;
            
        case NLProtocolRequest_getTransferPayfee:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_getTransferPayfee);
        }
            break;
            
        case NLProtocolRequest_getRepayMoneyPayfee:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_getRepayMoneyPayfee);
        }
            break;
            
        case NLProtocolRequest_RepayMoneyRq:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_RepayMoneyRq);
        }
            break;
            
        case NLProtocolRequest_readcouponinfo:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_readcouponinfo);
        }
            break;
            
        case NLProtocolRequest_couponSalePay:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_couponSalePay);
        }
            break;
            
        case NLProtocolRequest_couponSalelist:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_couponSalelist);
        }
            break;
            
        case NLProtocolRequest_payCardCheck:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_payCardCheck);
        }
            break;
            
        case NLProtocolRequest_readAppruleList:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_readAppruleList);
        }
            break;
            
        case NLProtocolRequest_readMenuModule:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_readMenuModule);
        }
            break;
            
            //移除快递
        case NLProtocolRequest_kuaiState:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_kuaiState);
        }
            break;
            
            //移除充值支付选项
        case NLProtocolRequest_readRechaMoneyinfo:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_readRechaMoneyinfo);
        }
            break;
            
            //话费移除
        case NLProtocolRequest_RechaMoneyRq:{
             REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_RechaMoneyRq);
        }
            break;
            
            //手机充值支付成功反馈
        case NLProtocolRequest_checkRechaMoneyStatus:{
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_checkRechaMoneyStatus);
        }
            break;
            
        case NLProtocolRequest_readMobileRechangelist:{
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_readMobileRechangelist);
        }
            break;
        
        case NLProtocolRequest_readRechaQQMoneyinfo:{
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_readRechaQQMoneyinfo);
        }
            break;
            
        case NLProtocolRequest_RechaQQMoneyRq:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_RechaQQMoneyRq);
        }
            break;
            
        //Q币充值支付成功反馈
        case NLProtocolRequest_checkRechaQQMoneyStatus:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_checkRechaQQMoneyStatus);
        }
            break;
        
        case NLProtocolRequest_readRechangeQQlist:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_readRechangeQQlist);
        }
            break;
            
        case NLProtocolRequest_readKuaiDicmpList:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_readKuaiDicmpList);
        }
            break;
            
        case NLProtocolRequest_chaxunKuaiDiNo:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_chaxunKuaiDiNo);
        }
            break;
            
        case NLProtocolRequest_readOrderList:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_readOrderList);
        }
            break;
            
        case NLProtocolRequest_orderPayReq:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_orderPayReq);
        }
            break;
            
        case NLProtocolRequest_orderPayFeedback:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_orderPayFeedback);
        }
            break;
            
        case NLProtocolRequest_orderPayBankCardStar:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_orderPayBankCardStar);
        }
            break;
            
        case NLProtocolRequest_readAuBkCardInfo:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_readAuBkCardInfo);
        }
            break;
            
        case NLProtocolRequest_modifyAuBkCardInfo:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_modifyAuBkCardInfo);
        }
            break;
            
        case NLProtocolRequest_readshoucardList:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_readshoucardList);
        }
            break;
            
        case NLProtocolRequest_getSupTransferPayfee:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_getSupTransferPayfee);
        }
            break;
            
        case NLProtocolRequest_SuptransferMoneyRq:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_SuptransferMoneyRq);
        }
            break;
            
        case NLProtocolRequest_insertSupTransferMoney:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_insertSupTransferMoney);
        }
            break;
            
        case NLProtocolRequest_readSupTransferMoneyglist:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_readSupTransferMoneyglist);
        }
            break;
        case NLProtocolRequest_readOrderProinfo:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_readOrderProinfo);
        }
            break;
        case NLProtocolRequest_readShaddressinfo:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_readShaddressinfo);
        }
            break;
        case NLProtocolRequest_shaddressAdd:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_shaddressAdd);
        }
            break;
        case NLProtocolRequest_shaddressDelete:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_shaddressDelete);
        }
            break;
        case NLProtocolRequest_payOrderRq:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_payOrderRq);
        }
            break;
        case NLProtocolRequest_orderPayrqStatus:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_orderPayrqStatus);
        }
            break;
        case NLProtocolRequest_readSKQOrderlist:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_readSKQOrderlist);
        }
            break;
        case NLProtocolRequest_waterEle_getProductList:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_waterEle_getProductList);
        }
            break;
        case NLProtocolRequest_waterEle_createOrder:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_waterEle_createOrder);
        }
            break;
        case NLProtocolRequest_waterEle_submitOrder:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_waterEle_submitOrder);
        }
            break;
        case NLProtocolRequest_waterEle_completeOrder:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_waterEle_completeOrder);
        }
            break;
        case NLProtocolRequest_waterEle_getOrderHistory:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_waterEle_getOrderHistory);
            break;
        }
        case NLProtocolRequest_gameCharge_getGameList:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_gameCharge_getGameList);
        }
            break;
        case NLProtocolRequest_gameCharge_getplatformList:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_gameCharge_getplatformList);
        }
            break;
        case NLProtocolRequest_gameCharge_getChildGame:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_gameCharge_getChildGame);
        }
            break;
        case NLProtocolRequest_gameCharge_getGameDetail:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_gameCharge_getGameDetail);
        }
            break;
        case NLProtocolRequest_gameCharge_createOrder:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_gameCharge_createOrder);
        }
            break;
        case NLProtocolRequest_gameCharge_completeOrder:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_gameCharge_completeOrder);
        }
            break;
        case NLProtocolRequest_gameCharge_getOrderHistory:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_gameCharge_getOrderHistory);
        }
            break;
        case NLProtocolRequest_readagentinfo:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_readagentinfo);
        }
            break;
        case NLProtocolRequest_readagentorder:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_readagentorder);
        }
            break;
        case NLProtocolRequest_agentorderstaterq:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_agentorderstaterq);
        }
            break;
        case NLProtocolRequest_payagentOrderRq:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_payagentOrderRq);
        }
            break;
        case NLProtocolRequest_agentorderPayrqStatus:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_agentorderPayrqStatus);
        }
            break;
        case NLProtocolRequest_payagentfenrunlist:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_payagentfenrunlist);
        }
            break;
            //绑定代理商
        case NLProtocolRequest_BindingAgentId:
        {
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_BindingAgentId);
        }
            break;
        case NLProtocolRequest_ApiAuthorInfoV2:{
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_ApiAuthorInfoV2);
        }
            break;
        case NLProtocolRequest_ApiAuthorInfoV2IsOnMain:{
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_ApiAuthorInfoV2IsOnMain);
        }
            break;
        case NLProtocolRequest_ApiAuthorInfoV2Gesture:{
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_ApiAuthorInfoV2Gesture);
        }
            break;
        /*用户手势登录*/
        case NLProtocolRequest_ApiAuthorInfoV2GestureToHander:{
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_ApiAuthorInfoV2GestureToHander);
        }
            break;
        /*用户修改密码接口*/
        case NLProtocolRequest_ApiAuthorInfoPasswordToChage:{
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_ApiAuthorInfoPasswordToChage);
        }
            break;
        /*用户修改login密码接口*/
        case NLProtocolRequest_ApiAuthorInfoV2ChangeLoginPassword:{
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_ApiAuthorInfoV2ChangeLoginPassword);
        }
            break;
            
            /*用户获取密保问题*/
        case NLProtocolRequest_ApiSafeGuardIsOn:
              REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_ApiSafeGuardIsOn);
            break;
            /*设置密保问题*/
        case NLProtocolRequest_ApiSafeGuardSetting:
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_ApiSafeGuardSetting);
            break;
            /*获取密保问题*/
        case NLProtocolRequest_ApiSafeGuardUser:
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_ApiSafeGuardUser);
            break;
            /*注销后获取密保*/
        case NLProtocolRequest_ApiSafeGuardLoginUp:
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_ApiSafeGuardLoginUp);
            break;
            /*修改信息*/
        case NLProtocolRequest_ApiAuthorInfoV2modifyAuthorInfo:
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_ApiAuthorInfoV2modifyAuthorInfo);
            break;
            /*飞机票城市查询*/
        case NLProtocolRequest_ApiAirticket:
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_ApiAirticket);
            break;
            /*航班查询*/
        case NLProtocolRequest_ApigetAirline:
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_ApigetAirline);
            break;
            /*菜单模板读取*/
        case NLProtocolRequest_ApireadMenuModule:
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_ApireadMenuModule);
            break;
            /*商户点击功能菜单累计使用次数*/
        case NLProtocolRequest_ApiauthorMenuCount:
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_ApiauthorMenuCount);
            break;
            //商户读取代理商信息
        case NLProtocolRequest_ApiAgentInfo:
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_ApiAgentInfo);
            break;
            //代理商地区省
        case NLProtocolRequest_ApiAgentApplyProv:
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_ApiAgentApplyProv);
            break;
            //代理商地区市
        case NLProtocolRequest_ApiAgentApplyCity:
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_ApiAgentApplyCity);
            break;
            //代理商地区区
        case NLProtocolRequest_ApiAgentApplyTown:
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_ApiAgentApplyTown);
            break;
            //代理商申请信息
        case NLProtocolRequest_ApiAgentApplyBasinfo:
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_ApiAgentApplyBasinfo);
            break;
        case NLProtocolRequest_ApiAgentApplyAdd:
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_ApiAgentApplyAdd);
            break;
        case NLProtocolRequest_ApiAgentInfoBind:
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_ApiAgentInfoBind);
            break;
        case NLProtocolRequest_ApiAgentApplyInsertPartt:
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_ApiAgentApplyInsertPartt);
            break;
        //读取新的信息
        case NLProtocolRequest_ApiAppInfo:
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_ApiAppInfo);
            break;
        //添加新的银行卡
        case NLProtocolRequest_ApiAuthorKuaibkcardInfoAdd:
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_ApiAuthorKuaibkcardInfoAdd);
            break;
        //修改银行卡
        case NLProtocolRequest_ApiAuthorKuaibkcardInfoEdit:
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_ApiAuthorKuaibkcardInfoEdit);
            break;
        //移除银行卡
        case NLProtocolRequest_ApiAuthorKuaibkcardInfoDelete:
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_ApiAuthorKuaibkcardInfoDelete);
            break;
        /*我的银行卡*/
        case NLProtocolRequest_ApiAuthorKuaibkcardInfoLists:
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_ApiAuthorKuaibkcardInfoLists);
            break;
        //绑定银行卡
        case NLProtocolRequest_ApiAuthorKuaibkcardInfoDefault:
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_ApiAuthorKuaibkcardInfoDefault);
            break;
            /***  易宝接口  ***/
        case NLProtocolRequest_ApiYiBaoPhonePay:
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_ApiYiBaoPhonePay);
            break;
            /*易宝验证*/
        case NLProtocolRequest_ApiYiBaoVerifyCode:
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_ApiYiBaoVerifyCode);
            break;
            /*易宝信用卡转账*/
        case NLProtocolRequest_ApiTransferWithCreditCard:
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_ApiTransferWithCreditCard);
            break;
            /*易宝转账信用卡验证码*/
        case NLProtocolRequest_ApiPayWithVerifyCode:
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_ApiPayWithVerifyCode);
            break;
            /*易宝游戏充值*/
        case NLProtocolRequest_ApiGamePayWithCreditCard:
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_ApiGamePayWithCreditCard);
            break;
            /*易宝游戏验证码*/
        case NLProtocolRequest_ApiGamePayWithVerifyCode:
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_ApiGamePayWithVerifyCode);
            break;
            /*话费是否可以充值*/
        case NLProtocolRequest_ApiCanRecharge:
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_ApiCanRecharge);
            break;
            /*读取快捷支付默认信用卡*/
        case NLProtocolRequest_ApiPaychannelInfo:
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_ApiPaychannelInfo);
            break;
        default:
            break;
    }
}

#pragma mark - postNotify

//-(void)postNotify:(int)error detail:(NSString*)detail name:(NSString*)name
//{
//    NLProtocolResponse* pn = [[NLProtocolResponse alloc] initWithDetail:detail name:name error:error];
//    POST_NOTIFY_FOR_NAME(Notify_finished, pn);
//}

-(BOOL)doDefaultError:(int)error
{
    BOOL todo = YES;
    
    if (RSP_TIMEOUT == error)
    {
        [[[NLToast alloc] init] show:@"链接超时"
                             gravity:NLToastGravityBottom
                            duration:NLToastDurationNormal];
        todo = NO;
    }
    else if (RSP_CANCEL == error)
    {
        [[[NLToast alloc] init] show:@"链接被取消"
                             gravity:NLToastGravityBottom
                            duration:NLToastDurationNormal];
        todo = NO;
    }
    return todo;
}

//判断是否为整形：
- (BOOL)isPureInt:(NSString*)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形：
- (BOOL)isPureFloat:(NSString*)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

-(int)rettype:(NLProtocolData*)data
{
    int rettype = -1;
    if (data && [self isPureInt:data.value])
    {
        rettype = [data.value intValue];
    }
    return rettype;
}

//超时 retcode
-(int)retcode:(NLProtocolData*)data
{
    int retcode = -1;
    if (data && [self isPureInt:data.value])
    {
        retcode = [data.value intValue];
    }
    return retcode;
}

-(BOOL)result:(NLProtocolData*)data
{
    BOOL result = YES;
    if (data)
    {
        result = ([data.value isEqualToString:@"failure"]) ? NO :YES;
    }
    return result;
}

//错误状态
-(int)getErrorcode:(NLProtocolResponse*)response
{

    NLProtocolData* data = nil;
    int errorcode = response.errcode;
    if (RSP_NO_ERROR == errorcode)
    {
        data = [response.data find:@"msgheader/retinfo/rettype" index:0];
        int rettype = [self rettype:data];
        switch (rettype)
        {
            case 0:
            {
                data = [response.data find:@"msgheader/retinfo/retcode" index:0];
                int retcode = [self retcode:data];
                switch (retcode)
                {
                    case 0:
                    {
                        data = [response.data find:@"msgbody/result" index:0];
                        if (![self result:data])
                        {
                            errorcode = RSP_XML_RESULT_FAILURE;
                        }
                    }
                        break;        
                        
                    default:
                    {
                        errorcode = RSP_XML_RETCODE_FAILURE;
                    }
                        break;
                }
            }
                break;
            
            //超时
            case 300:
            {
                errorcode = RSP_TIMEOUT;
            }
                break;
        
            default:
            {
                errorcode = RSP_XML_RETTYPE_FAILURE;
            }
                break;
        }
    }
    response.errcode = errorcode;
    if (RSP_NO_ERROR != errorcode)
    {
        data = [response.data find:@"msgheader/retinfo/retmsg" index:0];
        self.msgbody_message = data.value;
        response.detail = self.msgbody_message;
    }

    return errorcode;
}

-(void)doDefaultEnd:(NLProtocolRequestType)type response:(NLProtocolResponse*)response
{
    [self removeNotify:type];
    [[NLProtocolRegister shareProtocolRegister] unRegistRequest:type];
    NLProtocolData* data = [response.data find:@"msgheader/au_token" index:0];
    NSString* au_token = data.value;
    if (au_token != nil|| au_token.length > 0)
    {
        [NLUtils set_au_token:au_token];
    }
    else if([au_token isEqualToString:@"0"])
    {
        [NLUtils set_au_token:@""];
    }
    data = [response.data find:@"msgheader/req_bkenv" index:0];
    NSString* req_bkenv = data.value;
    [NLUtils set_req_bkenv:req_bkenv];
    NSString* name = response.name;
    POST_NOTIFY_FOR_NAME(name/*Notify_finished*/, response);
}
#pragma mark - received notify

-(void)getSmsCodeNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_getSmsCode response:response];
        return;
    }
   
    [self doDefaultEnd:NLProtocolRequest_getSmsCode response:response];
}

-(void)authorRegNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_authorReg response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_authorReg response:response];
}

-(void)authorPwdModifyNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_authorPwdModify response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_authorPwdModify response:response];
}

-(void)authorFeedbckNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {        
//        [[[NLToast alloc] init] show:@"反馈失败"
//                             gravity:NLToastGravityBottom
//                            duration:NLToastDurationNormal];
        [self doDefaultEnd:NLProtocolRequest_authorFeedbck response:response];
        return;
    }
    
//    [[[NLToast alloc] init] show:@"反馈成功"
//                         gravity:NLToastGravityBottom
//                        duration:NLToastDurationNormal];
    
    [self doDefaultEnd:NLProtocolRequest_authorFeedbck response:response];
}

//版本的控制
-(void)checkAppVersionNotify:(NSNotification*)notify
{
    NSString *appdatacount;
    
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    
    NSString* appnewversion = [response.data find:@"msgbody/appnewversion" index:0].value;
    
    /*当前最新的版本号*/
    [NLUtils set_appnewversion:appnewversion];

    int errorcode = [self getErrorcode:response];
    
    if (RSP_NO_ERROR != errorcode)
    {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"qiangzhi"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self doDefaultEnd:NLProtocolRequest_checkAppVersion response:response];
        [self performSelector:@selector(doShowToast:) withObject:response afterDelay:1.0f];
        
        return;
        
    }else{
        
        NLProtocolData* data = [response.data find:@"msgbody/appisnew" index:0];
        
        NSString *appisnew = data.value;
        
        
        data = [response.data find:@"msgbody/appnewversion" index:0];
        
        NSString* appnewversion = data.value;
        
        if ([appisnew isEqualToString:@"1"] ||![appnewversion isEqualToString:TFBVersion])
        {
            
            data = [response.data find:@"msgbody/clearoldinfo" index:0];
            BOOL clearoldinfo = [data.value boolValue];
            
            data = [response.data find:@"msgbody/appdownurl" index:0];
            
            NSString* appdownurl = data.value;
            
            data = [response.data find:@"msgbody/appnewcontent" index:0];
            
            NSString* appnewcontent = data.value;
            
            data = [response.data find:@"msgbody/appstrupdate" index:0];
            
            BOOL appstrupdate = [data.value boolValue];
            
            if (appstrupdate)
            {
                appdatacount= @"1";
                
                [NLUtils setForceUpdate:appdatacount];
            }
            else
            {
                appdatacount= @"0";
                
                [NLUtils setForceUpdate:appdatacount];
            }
            
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"qiangzhi"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NLDoSomeNotifyEvents shareDoSomeNotifyEvents] doCheckAppVersionNotify:appnewversion
                                                                       clearoldinfo:clearoldinfo
                                                                         appdownurl:appdownurl
                                                                      appnewcontent:appnewcontent
                                                                       appstrupdate:appstrupdate];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"qiangzhi"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[[NLToast alloc] init] show:@"当前使用的是最新版本"
                                 gravity:NLToastGravityBottom
                                duration:NLToastDurationNormal];
        }
}
    
    
    [self doDefaultEnd:NLProtocolRequest_checkAppVersion response:response];
}

-(void)readAuthorInfoNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_readAuthorInfo response:response];
        return;
    }
    [self doDefaultEnd:NLProtocolRequest_readAuthorInfo response:response];
}

-(void)modifyAuthorInfoNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_modifyAuthorInfo response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_modifyAuthorInfo response:response];
}

-(void)uploadAuthorPicNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_uploadAuthorPic response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_uploadAuthorPic response:response];
}

-(void)checkAuthorLoginNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_checkAuthorLogin response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_checkAuthorLogin response:response];
}

-(void)getSmsCodeInfoNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_getSmsCodeInfo response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_getSmsCodeInfo response:response];
}

-(void)forgetPwdModifyNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_forgetPwdModify response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_forgetPwdModify response:response];
}

-(void)readHelpListNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_readHelpList response:response];
        return;
    }
    
//    NLProtocolData* data = [response.data find:@"msgbody/msgallcount" index:0];
//    int count = [data.value intValue];
//    [self plistOperation:FETCH_ABS_FILE_NAME(TFBConfigurator)
//                     key:TFBC_readHelpList_count
//                   value:[NSString stringWithFormat:@"%d",count]];
//    NSString* helpcontent = nil;
//    NSString* helpdate = nil;
//    NSString* helpname = nil;
//    for (int i=0; i<count; i++)
//    {
//        data = [response.data find:@"msgbody/msgchild/helpcontent" index:i];
//        helpcontent = data.value;
//        [self plistOperation:FETCH_ABS_FILE_NAME(TFBConfigurator)
//                         key:[NSString stringWithFormat:@"%@%d",TFBC_readHelpList_content,i]
//                       value:helpcontent];
//        
//        data = [response.data find:@"msgbody/msgchild/helpdate" index:i];
//        helpdate = data.value;
//        [self plistOperation:FETCH_ABS_FILE_NAME(TFBConfigurator)
//                         key:[NSString stringWithFormat:@"%@%d",TFBC_readHelpList_date,i]
//                       value:helpdate];
//
//
//        data = [response.data find:@"msgbody/msgchild/helpname" index:i];
//        helpname = data.value;
//        [self plistOperation:FETCH_ABS_FILE_NAME(TFBConfigurator)
//                         key:[NSString stringWithFormat:@"%@%d",TFBC_readHelpList_title,i]
//                       value:helpname];
//    }
    
    [self doDefaultEnd:NLProtocolRequest_readHelpList response:response];
}

-(void)readMyAccountNotify:(NSNotification*)notify  
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_readMyAccount response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_readMyAccount response:response];
}

-(void)readAccglistNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_readAccglist response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_readAccglist response:response];
}

-(void)readAccglistdetailNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_readAccglistdetail response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_readAccglistdetail response:response];
}

-(void)getSmsVerifyCodeNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_getSmsVerifyCode response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_getSmsVerifyCode response:response];
}

-(void)readCreditCardfeeNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_readCreditCardfee response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_readCreditCardfee response:response];
}

-(void)insertcreditCardMoneyNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_insertcreditCardMoney response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_insertcreditCardMoney response:response];
}

-(void)readCreditCardglistNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_readCreditCardglist response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_readCreditCardglist response:response];
}

-(void)creditCardMoneyRqNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_creditCardMoneyRq response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_creditCardMoneyRq response:response];
}

-(void)transferMoneyRqNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_transferMoneyRq response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_transferMoneyRq response:response];
}

-(void)readTransferMoneyfeeNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_readTransferMoneyfee response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_readTransferMoneyfee response:response];
}

-(void)insertTransferMoneyNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_insertTransferMoney response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_insertTransferMoney response:response];
}

-(void)readTransferMoneyglistNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_readTransferMoneyglist response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_readTransferMoneyglist response:response];
}

-(void)readRepayMoneyfeeNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_readRepayMoneyfee response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_readRepayMoneyfee response:response];
}

-(void)insertRepayMoneyNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_insertRepayMoney response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_insertRepayMoney response:response];
}

-(void)readRepayMoneyglistNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_readRepayMoneyglist response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_readRepayMoneyglist response:response];
}

-(void)rechargeglistNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_rechargeglist response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_rechargeglist response:response];
}

-(void)rechargeReqNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_rechargeReq response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_rechargeReq response:response];
}

-(void)rechargePayNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_rechargePay response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_rechargePay response:response];
}

-(void)couponSaleNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_couponSale response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_couponSale response:response];
}

-(void)couponRebuylistNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_couponRebuylist response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_couponRebuylist response:response];
}

-(void)couponRebuyNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_couponRebuy response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_couponRebuy response:response];
}

-(void)readBankListNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_readBankList response:response];
        return;
    }
    
    NLProtocolData* body = [response.data find:@"msgbody" index:0];
    [[NLDataBase shareNLDataBase] cleanDataBase:NLDataBaseTable_BlankList];
    NSArray* arr = [body find:@"msgchild"];
    NSString* bankid = nil;
    NSString* bankno = nil;
    NSString* bankname = nil;
    for (NLProtocolData* data in arr)
    {
        NLProtocolData* d = [data find:@"bankid" index:0];
        bankid = d.value;
        
        d = [data find:@"bankno" index:0];
        bankno = d.value;
        
        d = [data find:@"bankname" index:0];
        bankname = d.value;
        
        NLDataBase_bankListTable* node = [[NLDataBase_bankListTable alloc] initWithID:bankid
                                                                                  aNO:bankno
                                                                                 name:bankname
                                                                                memo1:nil
                                                                                memo2:nil
                                                                                memo3:nil];
        [[NLDataBase shareNLDataBase] addDataBase:NLDataBaseTable_BlankList object:node];
    }
    
    [self doDefaultEnd:NLProtocolRequest_readBankList response:response];
}

-(void)readIndexAdListNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_readIndexAdList response:response];
        return;
    }
    
    NLProtocolData* body = [response.data find:@"msgbody" index:0];
    NLProtocolData* data = [body getChild:@"adallcount" index:0];
    int count = [data.value intValue];
    [self plistOperation:FETCH_ABS_FILE_NAME(TFBConfigurator)
                     key:TFBC_MainAdImageCount
                   value:[NSString stringWithFormat:@"%d",count]];
    NSString* adno = nil;
    NSString* adpicurl = nil;
    NSString* adtitle = nil;
    for (int i=0; i<count; i++)
    {
        data = [body find:@"msgchild/adno" index:i];
        adno = data.value;
        
        data = [body find:@"msgchild/adpicurl" index:i];
        adpicurl = data.value;
        [self plistOperation:FETCH_ABS_FILE_NAME(TFBConfigurator)
                         key:[NSString stringWithFormat:@"%@%@",TFBC_MainAdImageURL,adno]
                       value:adpicurl];
        
        data = [body find:@"msgchild/adtitle" index:i];
        adtitle = data.value;
        [self plistOperation:FETCH_ABS_FILE_NAME(TFBConfigurator)
                         key:[NSString stringWithFormat:@"%@%@",TFBC_MainAdImageTitle,adno]
                       value:adtitle];
    }
    [self doDefaultEnd:NLProtocolRequest_readIndexAdList response:response];
}

-(void)activePayCardNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_activePayCard response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_activePayCard response:response];
}

-(void)readQueryCardMoneyNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_readQueryCardMoney response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_readQueryCardMoney response:response];
}

-(void)getTransferPayfeeNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_getTransferPayfee response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_getTransferPayfee response:response];
}

-(void)getRepayMoneyPayfeeNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_getRepayMoneyPayfee response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_getRepayMoneyPayfee response:response];
}

-(void)RepayMoneyRqNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_RepayMoneyRq response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_RepayMoneyRq response:response];
}

-(void)readcouponinfoNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_readcouponinfo response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_readcouponinfo response:response];
}

-(void)couponSalePayNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_couponSalePay response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_couponSalePay response:response];
}

-(void)couponSalelistNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_couponSalelist response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_couponSalelist response:response];
}

-(void)payCardCheckNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_payCardCheck response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_payCardCheck response:response];
}

-(void)readAppruleListNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_readAppruleList response:response];
        return;
    }
    NLProtocolData* data = [response.data find:@"msgbody/msgchild/appruletitle" index:0];
    NSString* appruletitle = data.value;
    
    data = [response.data find:@"msgbody/msgchild/apprulecontent" index:0];
    NSString* apprulecontent = data.value;
    NSString* document = [NLSandboxFile GetDocumentPath];
    NSString* path = [NSString stringWithFormat:@"%@/%@.txt",document,appruletitle];
    [self plistOperation:FETCH_ABS_FILE_NAME(TFBConfigurator) key:TFBC_readAppruleList_path value:path];
    [apprulecontent writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    //[apprulecontent writeToFile:path atomically:YES];
    
    [self doDefaultEnd:NLProtocolRequest_readAppruleList response:response];
}

-(void)readMenuModuleNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_readMenuModule response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_readMenuModule response:response];
}

//快递
-(void)kuaiStateNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_kuaiState response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_kuaiState response:response];
}

-(void)readKuaiDicmpListNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_readKuaiDicmpList response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_readKuaiDicmpList response:response];
}

-(void)chaxunKuaiDiNoNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_chaxunKuaiDiNo response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_chaxunKuaiDiNo response:response];
}

-(void)readOrderListNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_readOrderList response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_readOrderList response:response];
}

-(void)orderPayReqNotify:(NSNotification*)notify 
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_orderPayReq response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_orderPayReq response:response];
}

-(void)orderPayFeedbackNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_orderPayFeedback response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_orderPayFeedback response:response];
}

-(void)orderPayBankCardStarNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_orderPayBankCardStar response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_orderPayBankCardStar response:response];
}

-(void)readAuBkCardInfoNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_readAuBkCardInfo response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_readAuBkCardInfo response:response];
}

-(void)modifyAuBkCardInfoNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_modifyAuBkCardInfo response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_modifyAuBkCardInfo response:response];
}

-(void)readshoucardListNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_readshoucardList response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_readshoucardList response:response];
}

-(void)getSupTransferPayfeeNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_getSupTransferPayfee response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_getSupTransferPayfee response:response];
}

-(void)SuptransferMoneyRqNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_SuptransferMoneyRq response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_SuptransferMoneyRq response:response];
}

-(void)insertSupTransferMoneyNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_insertSupTransferMoney response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_insertSupTransferMoney response:response];
}

-(void)readSupTransferMoneyglistNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_readSupTransferMoneyglist response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_readSupTransferMoneyglist response:response];
}

-(void)phoneMoneyRechaNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_RechaMoneyRq response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_RechaMoneyRq response:response];
}

-(void)readRechaMoneyinfoNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_readRechaMoneyinfo response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_readRechaMoneyinfo response:response];
}

-(void)checkRechaMoneyStatusNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_checkRechaMoneyStatus response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_checkRechaMoneyStatus response:response];
}

-(void)readMobileRechangelistNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_readMobileRechangelist response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_readMobileRechangelist response:response];
}

-(void)readRechaQQMoneyinfoNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_readRechaQQMoneyinfo response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_readRechaQQMoneyinfo response:response];
}

-(void)qqMoneyRechaNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_RechaQQMoneyRq response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_RechaQQMoneyRq response:response];
}

-(void)checkRechaQQMoneyStatusNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_checkRechaQQMoneyStatus response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_checkRechaQQMoneyStatus response:response];
}

-(void)readRechangeQQlistNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_readRechangeQQlist response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_readRechangeQQlist response:response];
}

-(void)readOrderProinfoNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_readOrderProinfo response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_readOrderProinfo response:response];
}

-(void)readShaddressinfoNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_readShaddressinfo response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_readShaddressinfo response:response];
}

-(void)shaddressAddNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_shaddressAdd response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_shaddressAdd response:response];
}

-(void)shaddressDeleteNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_shaddressDelete response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_shaddressDelete response:response];
}

-(void)payOrderRqNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_payOrderRq response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_payOrderRq response:response];
}

-(void)orderPayrqStatusNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_orderPayrqStatus response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_orderPayrqStatus response:response];
}

-(void)readSKQOrderlistNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_readSKQOrderlist response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_readSKQOrderlist response:response];
}

-(void)waterEleGetProductListNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_waterEle_getProductList response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_waterEle_getProductList response:response];
}

-(void)waterElecreateOrderNotify:(NSNotification *)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_waterEle_createOrder response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_waterEle_createOrder response:response];
}

-(void)waterElesubmitOrderNotify:(NSNotification *)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_waterEle_submitOrder response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_waterEle_submitOrder response:response];
}

-(void)waterElecompleteOrderNotify:(NSNotification *)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_waterEle_completeOrder response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_waterEle_completeOrder response:response];
}

-(void)waterElegetOrderHistoryNotify:(NSNotification *)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_waterEle_getOrderHistory response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_waterEle_getOrderHistory response:response];
}

-(void)gameChargeGetGamelistNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_gameCharge_getGameList response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_gameCharge_getGameList response:response];
}

-(void)gameChargeGetPlatformNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_gameCharge_getplatformList response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_gameCharge_getplatformList response:response];
}

-(void)gameChargeGetChildGameNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_gameCharge_getChildGame response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_gameCharge_getChildGame response:response];
}

-(void)gameChargeGetGameDetailNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_gameCharge_getGameDetail response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_gameCharge_getGameDetail response:response];
}

-(void)gameChargeCreateOrderNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_gameCharge_createOrder response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_gameCharge_createOrder response:response];
}

-(void)gameChargeCompleteOrderNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_gameCharge_completeOrder response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_gameCharge_completeOrder response:response];
}

-(void)gameChargeGetOrderHistoryNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_gameCharge_getOrderHistory response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_gameCharge_getOrderHistory response:response];
}

-(void)readagentinfoNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_readagentinfo response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_readagentinfo response:response];
}

-(void)readagentorderlistNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_readagentorder response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_readagentorder response:response];
}

-(void)agentorderstaterqNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_agentorderstaterq response:response];
        return;
    }
    [self doDefaultEnd:NLProtocolRequest_agentorderstaterq response:response];
}

-(void)payagentOrderRqNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_payagentOrderRq response:response];
        return;
    }
    [self doDefaultEnd:NLProtocolRequest_payagentOrderRq response:response];
}

-(void)agentorderPayrqStatusNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_agentorderPayrqStatus response:response];
        return;
    }
    [self doDefaultEnd:NLProtocolRequest_agentorderPayrqStatus response:response];
}

-(void)payagentfenrunlistNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_payagentfenrunlist response:response];
        return;
    }
    [self doDefaultEnd:NLProtocolRequest_payagentfenrunlist response:response];
}

//绑定代理商
-(void)BindingAgentIdNotify:(NSNotification*)notify{
    
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_BindingAgentId response:response];
        return;
    }
    [self doDefaultEnd:NLProtocolRequest_BindingAgentId response:response];
    
}

/*反馈版本号*/
-(void)doShowToast:(NLProtocolResponse*)response
{
    [[[NLToast alloc] init] show:response.detail
                         gravity:NLToastGravityBottom
                        duration:NLToastDurationNormal];
}

//最新注册接口的
-(void)ApiAuthorInfoV2Notify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_ApiAuthorInfoV2 response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_ApiAuthorInfoV2 response:response];
    
}

//判断是否存在用户的注册接口
-(void)ApiAuthorInfoV2IsOnMainNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_ApiAuthorInfoV2IsOnMain response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_ApiAuthorInfoV2IsOnMain response:response];
    
}

//用户登录
- (void)ApiAuthorInfoV2GestureNotify:(NSNotification*)notify{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_ApiAuthorInfoV2Gesture response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_ApiAuthorInfoV2Gesture response:response];
    
}

//手势登录修改
- (void)ApiAuthorInfoV2GestureToHanderNotify:(NSNotification*)notify{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_ApiAuthorInfoV2GestureToHander response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_ApiAuthorInfoV2GestureToHander response:response];
    
}


//用户密码修改
- (void)ApiAuthorInfoPasswordToChageNotify:(NSNotification*)notify{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_ApiAuthorInfoPasswordToChage response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_ApiAuthorInfoPasswordToChage response:response];
}

//用户login密码修改
- (void)ApiAuthorInfoV2ChangeLoginPasswordNotify:(NSNotification*)notify{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_ApiAuthorInfoV2ChangeLoginPassword response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_ApiAuthorInfoV2ChangeLoginPassword response:response];
}


//获取预设密保问题
- (void)ApiSafeGuardNotify:(NSNotification*)notify{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_ApiSafeGuardIsOn response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_ApiSafeGuardIsOn response:response];
}

//设置密保问题
-(void)ApiSafeGuardMsgchildNotify:(NSNotification*)notify{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_ApiSafeGuardSetting response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_ApiSafeGuardSetting response:response];
}

//获取设置过的密保问题
-(void)ApiSafeGuardUserNotify:(NSNotification*)notify{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_ApiSafeGuardUser response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_ApiSafeGuardUser response:response];

    
}

//用于注销后再设置密保的通知

-(void)ApiSafeGuardLoginUpNotify:(NSNotification*)notify{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_ApiSafeGuardLoginUp response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_ApiSafeGuardLoginUp response:response];
    
}

//判断是否有绑定的银行卡
-(void)ApiAuthorInfoV2modifyAuthorInfoNotify:(NSNotification*)notify{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_ApiAuthorInfoV2modifyAuthorInfo response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_ApiAuthorInfoV2modifyAuthorInfo response:response];
    
}

//飞机票城市的查询
-(void)ApiAirticketNotify:(NSNotification*)notify{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_ApiAirticket response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_ApiAirticket response:response];
    
}

//航班查询
-(void)ApigetAirlineNotify:(NSNotification*)notify{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_ApigetAirline response:response];
        return;
    }
    
    [self doDefaultEnd:NLProtocolRequest_ApigetAirline response:response];
    
}

//菜单模板
-(void)ApireadMenuModuleNotify:(NSNotification*)notify{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
        [self doDefaultEnd:NLProtocolRequest_ApireadMenuModule response:response];
        return;
    }
    [self doDefaultEnd:NLProtocolRequest_ApireadMenuModule response:response];
    
}

//商户点击功能菜单累计使用次数
-(void)ApiauthorMenuCountNotify:(NSNotification*)notify{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int errorcode = [self getErrorcode:response];
    if (RSP_NO_ERROR != errorcode)
    {
    [self doDefaultEnd:NLProtocolRequest_ApiauthorMenuCount response:response];
        return;
    }
    [self doDefaultEnd:NLProtocolRequest_ApiauthorMenuCount response:response];
    
}

//商户读取代理商信息
- (void)ApiAgentInfoNotify:(NSNotification *)notify
{
    NLProtocolResponse *response = (NLProtocolResponse *)notify.object;
    int errorCode = [self getErrorcode:response];
    
    
    if (errorCode != RSP_NO_ERROR)
    {
        [self doDefaultEnd:NLProtocolRequest_ApiAgentInfo response:response];
        
        return ;
    }
    
    [self doDefaultEnd:NLProtocolRequest_ApiAgentInfo response:response];
}

//代理商地区申请
- (void)ApiAgentApplyProvNotify:(NSNotification *)notify
{
    NLProtocolResponse *response = (NLProtocolResponse *)notify.object;
    int errorCode = [self getErrorcode:response];
    
    if (errorCode != RSP_NO_ERROR)
    {
        [self doDefaultEnd:NLProtocolRequest_ApiAgentApplyProv response:response];
        return ;
    }
    
    [self doDefaultEnd:NLProtocolRequest_ApiAgentApplyProv response:response];
}

- (void)ApiAgentApplyCityNotify:(NSNotification *)notify
{
    NLProtocolResponse *response = (NLProtocolResponse *)notify.object;
    int errorCode = [self getErrorcode:response];
    
    if (errorCode != RSP_NO_ERROR)
    {
        [self doDefaultEnd:NLProtocolRequest_ApiAgentApplyCity response:response];
        return ;
    }
    
    [self doDefaultEnd:NLProtocolRequest_ApiAgentApplyCity response:response];
}

- (void)ApiAgentApplyTownNotify:(NSNotification *)notify
{
    NLProtocolResponse *response = (NLProtocolResponse *)notify.object;
    int errorCode = [self getErrorcode:response];
    
    if (errorCode != RSP_NO_ERROR)
    {
        [self doDefaultEnd:NLProtocolRequest_ApiAgentApplyTown response:response];
        return ;
    }
    
    [self doDefaultEnd:NLProtocolRequest_ApiAgentApplyTown response:response];
}

//代理商申请信息
- (void)ApiAgentApplyBasinfoNotify:(NSNotification *)notify
{
    NLProtocolResponse *response = (NLProtocolResponse *)notify.object;
    int errorCode = [self getErrorcode:response];
    
    if (errorCode != RSP_NO_ERROR)
    {
        [self doDefaultEnd:NLProtocolRequest_ApiAgentApplyBasinfo response:response];
        
        return ;
    }
    
    [self doDefaultEnd:NLProtocolRequest_ApiAgentApplyBasinfo response:response];
}

//代理商申请
- (void)ApiAgentApplyAddNotify:(NSNotification *)notify
{
    NLProtocolResponse *response = (NLProtocolResponse *)notify.object;
    int errorCode = [self getErrorcode:response];
    
    if (errorCode != RSP_NO_ERROR)
    {
        [self doDefaultEnd:NLProtocolRequest_ApiAgentApplyAdd response:response];
        
        return ;
    }
    
    [self doDefaultEnd:NLProtocolRequest_ApiAgentApplyAdd response:response];
}

//绑定代理商
- (void)ApiAgentInfoBindNotify:(NSNotification *)notify
{
    NLProtocolResponse *response = (NLProtocolResponse *)notify.object;
    int errorCode = [self getErrorcode:response];
    
    if (errorCode != RSP_NO_ERROR)
    {
        [self doDefaultEnd:NLProtocolRequest_ApiAgentInfoBind response:response];
        
        return ;
    }
    
    [self doDefaultEnd:NLProtocolRequest_ApiAgentInfoBind response:response];
}

//虚拟代理商
- (void)ApiAgentApplyInsertParttNotify:(NSNotification *)notify
{
    NLProtocolResponse *response = (NLProtocolResponse *)notify.object;
    int errorCode = [self getErrorcode:response];
    
    if (errorCode != RSP_NO_ERROR)
    {
        [self doDefaultEnd:NLProtocolRequest_ApiAgentApplyInsertPartt response:response];
        
        return ;
    }
    
    [self doDefaultEnd:NLProtocolRequest_ApiAgentApplyInsertPartt response:response];
}

//读取新的信息
- (void)ApiAppInfoNotify:(NSNotification *)notify
{
    NLProtocolResponse *response = (NLProtocolResponse *)notify.object;
    int errorCode = [self getErrorcode:response];
    
    if (errorCode != RSP_NO_ERROR)
    {
        [self doDefaultEnd:NLProtocolRequest_ApiAppInfo response:response];
        
        return ;
    }
    
    [self doDefaultEnd:NLProtocolRequest_ApiAppInfo response:response];
}

/*我的银行卡*/
//读取用户银行卡列表
- (void)ApiApiAuthorKuaibkcardInfoListsNotify:(NSNotification *)notify
{
    NLProtocolResponse *response = (NLProtocolResponse *)notify.object;
    int errorCode = [self getErrorcode:response];
    
    if (errorCode != RSP_NO_ERROR)
    {
        [self doDefaultEnd:NLProtocolRequest_ApiAuthorKuaibkcardInfoLists response:response];
        
        return ;
    }
    
    [self doDefaultEnd:NLProtocolRequest_ApiAuthorKuaibkcardInfoLists response:response];
}

//添加新的银行卡
- (void)ApiAuthorKuaibkcardInfoAddNotify:(NSNotification *)notify
{
    NLProtocolResponse *response = (NLProtocolResponse *)notify.object;
    int errorCode = [self getErrorcode:response];
    if (errorCode != RSP_NO_ERROR)
    {
        [self doDefaultEnd:NLProtocolRequest_ApiAuthorKuaibkcardInfoAdd response:response];
        return ;
    }
    [self doDefaultEnd:NLProtocolRequest_ApiAuthorKuaibkcardInfoAdd response:response];
}

//修改银行卡
- (void)ApiAuthorKuaibkcardInfoEditNotify:(NSNotification *)notify
{
    NLProtocolResponse *response = (NLProtocolResponse *)notify.object;
    int errorCode = [self getErrorcode:response];
    
    if (errorCode != RSP_NO_ERROR)
    {
        [self doDefaultEnd:NLProtocolRequest_ApiAuthorKuaibkcardInfoEdit response:response];
        return ;
    }
    
    [self doDefaultEnd:NLProtocolRequest_ApiAuthorKuaibkcardInfoEdit response:response];
}

//移除银行卡
- (void)ApiAuthorKuaibkcardInfoDeleteNotify:(NSNotification *)notify
{
    NLProtocolResponse *response = (NLProtocolResponse *)notify.object;
    int errorCode = [self getErrorcode:response];
    
    if (errorCode != RSP_NO_ERROR)
    {
        [self doDefaultEnd:NLProtocolRequest_ApiAuthorKuaibkcardInfoDelete response:response];
        
        return ;
    }
    
    [self doDefaultEnd:NLProtocolRequest_ApiAuthorKuaibkcardInfoDelete response:response];
}

//绑定银行卡
- (void)ApiAuthorKuaibkcardInfoDefaultNotify:(NSNotification *)notify
{
    NLProtocolResponse *response = (NLProtocolResponse *)notify.object;
    int errorCode = [self getErrorcode:response];
    
    if (errorCode != RSP_NO_ERROR)
    {
        [self doDefaultEnd:NLProtocolRequest_ApiAuthorKuaibkcardInfoDefault response:response];
        
        return ;
    }
    
    [self doDefaultEnd:NLProtocolRequest_ApiAuthorKuaibkcardInfoDefault response:response];
}

/*易宝充值*/
- (void)ApiYiBaoPhonePayNotify:(NSNotification *)notify{
    
    NLProtocolResponse *response = (NLProtocolResponse *)notify.object;
    int errorCode = [self getErrorcode:response];
    if (errorCode != RSP_NO_ERROR)
    {
        [self doDefaultEnd:NLProtocolRequest_ApiYiBaoPhonePay response:response];
        return ;
    }
    [self doDefaultEnd:NLProtocolRequest_ApiYiBaoPhonePay response:response];
}

/*易宝充值验证*/
- (void)ApiYiBaoVerifyCodeNotify:(NSNotification *)notify{
    
    NLProtocolResponse *response = (NLProtocolResponse *)notify.object;
    int errorCode = [self getErrorcode:response];
    if (errorCode != RSP_NO_ERROR)
    {
        [self doDefaultEnd:NLProtocolRequest_ApiYiBaoVerifyCode response:response];
        return ;
    }
    [self doDefaultEnd:NLProtocolRequest_ApiYiBaoVerifyCode response:response];
}

/*易宝转账*/
- (void)ApiTransferWithCreditCard:(NSNotification *)notify
{
    NLProtocolResponse *response = (NLProtocolResponse *)notify.object;
    int errorCode = [self getErrorcode:response];
    if (errorCode != RSP_NO_ERROR)
    {
        [self doDefaultEnd:NLProtocolRequest_ApiTransferWithCreditCard response:response];
        return ;
    }
    [self doDefaultEnd:NLProtocolRequest_ApiTransferWithCreditCard response:response];
}

/*易宝信用卡验证*/
- (void)ApiPayWithVerifyCode:(NSNotification *)notify
{
    NLProtocolResponse *response = (NLProtocolResponse *)notify.object;
    int errorCode = [self getErrorcode:response];
    if (errorCode != RSP_NO_ERROR)
    {
        [self doDefaultEnd:NLProtocolRequest_ApiPayWithVerifyCode response:response];
        return ;
    }
    [self doDefaultEnd:NLProtocolRequest_ApiPayWithVerifyCode response:response];
}

/*易宝游戏充值*/
- (void)ApiGamePayWithCreditCard:(NSNotification *)notify
{
    NLProtocolResponse *response = (NLProtocolResponse *)notify.object;
    int errorCode = [self getErrorcode:response];
    if (errorCode != RSP_NO_ERROR)
    {
        [self doDefaultEnd:NLProtocolRequest_ApiGamePayWithCreditCard response:response];
        return ;
    }
    [self doDefaultEnd:NLProtocolRequest_ApiGamePayWithCreditCard response:response];
}

/*易宝游戏验证码*/
- (void)ApiGamePayWithVerifyCode:(NSNotification *)notify
{
    NLProtocolResponse *response = (NLProtocolResponse *)notify.object;
    int errorCode = [self getErrorcode:response];
    if (errorCode != RSP_NO_ERROR)
    {
        [self doDefaultEnd:NLProtocolRequest_ApiGamePayWithVerifyCode response:response];
        return ;
    }
    [self doDefaultEnd:NLProtocolRequest_ApiGamePayWithVerifyCode response:response];
}

/*话费是否可以充值*/
- (void)ApiCanRecharge:(NSNotification *)notify
{
    NLProtocolResponse *response = (NLProtocolResponse *)notify.object;
    int errorCode = [self getErrorcode:response];
    if (errorCode != RSP_NO_ERROR)
    {
        [self doDefaultEnd:NLProtocolRequest_ApiCanRecharge response:response];
        return ;
    }
    [self doDefaultEnd:NLProtocolRequest_ApiCanRecharge response:response];
}

/*读取快捷支付默认信用卡号*/
- (void)ApiPaychannelInfo:(NSNotification *)notify
{
    NLProtocolResponse *response = (NLProtocolResponse *)notify.object;
    int errorCode = [self getErrorcode:response];
    if (errorCode != RSP_NO_ERROR)
    {
        [self doDefaultEnd:NLProtocolRequest_ApiPaychannelInfo response:response];
        return ;
    }
    [self doDefaultEnd:NLProtocolRequest_ApiPaychannelInfo response:response];
}


@end






