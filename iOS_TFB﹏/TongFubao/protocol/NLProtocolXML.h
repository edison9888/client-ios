//
//  NLProtocolXML.h
//  TongFubao
//
//  Created by MD313 on 13-8-16.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NLProtocolData;

@interface NLProtocolXML : NSObject

+(id)shareProtocolXML;

/***
 用户注册短信校验码获取
 */
-(NLProtocolData*)getSmsCodeXML:(NSString*)mobile;

/***
 用户注册短信校验成功后注册资料登记
 */
-(NLProtocolData*)authorRegXML:(NSString*)mobile password:(NSString*)password name:(NSString*)name idCard:(NSString*)idCard email:(NSString*)email;

/***
 用户密码修改V2
 */
-(NLProtocolData*)authorPwdModifyXML:(NSString*)oldPW newPW:(NSString*)newPW type:(NSString*)type reset:(NSString*)reset;

/***
 用户意见反馈
 */
-(NLProtocolData*)authorFeedbckXML:(NSString*)content contact:(NSString*)contact;

/***
 版本更新
 */
-(NLProtocolData*)checkAppVersionXML:(NSString*)type version:(NSString*)version;

/***
 读取用户信息
 */
-(NLProtocolData*)readAuthorInfoXML;

/***
 修改用户信息
 */
-(NLProtocolData*)modifyAuthorInfoXML:(NSString*)name idCard:(NSString*)idCard email:(NSString*)email agentcompany:(NSString*)agentcompany agentarea:(NSString*)agentarea  agentaddress:(NSString*)agentaddress agentmanphone:(NSString*)agentmanphone agentfax:(NSString*)agentfax;

/***
 用户身份证图片上传
 */
-(NLProtocolData*)uploadAuthorPicXML:(NSString*)picid picpath:(NSString*)picpath uploadmethod:(NSString*)uploadmethod uploadpictype:(NSString*)uploadpictype uploadmark:(NSString*)uploadmark;

/***
 登录管理
 */
-(NLProtocolData*)checkAuthorLoginXML:(NSString*)userName password:(NSString*)password auloginmethod:(NSString*)auloginmethod mpmodel:(NSString*)mpmodel;

/***
 忘记密码短信校验码获取
 */
-(NLProtocolData*)getSmsCodeInfoXML:(NSString*)mobile;

/***
 忘记密码修改
 */
-(NLProtocolData*)forgetPwdModifyXML:(NSString*)aumobile aunewpwd:(NSString*)aunewpwd aurenewpwd:(NSString*)aurenewpwd  aumoditype:(NSString*)aumoditype;

/***
 帮助中心列表显示
 */
-(NLProtocolData*)readHelpListXML:(NSString*)start display:(NSString*)display;

/***
我的钱包
*/
-(NLProtocolData*)readMyAccountXML;

/***
 我的钱包收支明细
 */
-(NLProtocolData*)readAccglistXML:(NSString*)acctypeid;

/***
 我的钱包收支详情
 */
-(NLProtocolData*)readAccglistdetailXML:(NSString*)acctypeid month:(NSString*)month;

/***
 短信校验码获取
 */
-(NLProtocolData*)getSmsVerifyCodeXML:(NSString*)mobile;

/***
 信用卡还款
 */
-(NLProtocolData*)readCreditCardfeeXML:(NSString*)type amount:(NSString*)amount bankID:(NSString*)bankID cardID:(NSString*)cardID;

/***
 信用卡还款支付成功
 */
-(NLProtocolData*)insertcreditCardMoneyXML:(NSString*)bkntno result:(NSString*)result;

/***
 读取信用卡还款记录
 */
-(NLProtocolData*)readCreditCardglistXML:(NSString*)paytype msgstart:(NSString*)msgstart msgdisplay:(NSString*)msgdisplay;

/***
 信用卡还款请求
 */
-(NLProtocolData*)creditCardMoneyRqXML:(NSString*)paytype paymoney:(NSString*)paymoney shoucardno:(NSString*)shoucardno shoucardmobile:(NSString*)shoucardmobile shoucardman:(NSString*)shoucardman shoucardbank:(NSString*)shoucardbank fucardno:(NSString*)fucardno fucardbank:(NSString*)fucardbank fucardmobile:(NSString*)fucardmobile fucardman:(NSString*)fucardman current:(NSString*)current paycardid:(NSString*)paycardid merReserved:(NSString*)merReserved;

/***
 转账汇款
 */
-(NLProtocolData*)readTransferMoneyfeeXML:(NSString*)paytype paymoney:(NSString*)paymoney paybankid:(NSString*)paybankid paycardid:(NSString*)paycardid;

/***
 转账汇款支付成功反馈
 */
-(NLProtocolData*)insertTransferMoneyXML:(NSString*)bkntno result:(NSString*)result;

/***
 读取转账汇款记录
 */
-(NLProtocolData*)readTransferMoneyglistXML:(NSString*)paytype msgstart:(NSString*)msgstart msgdisplay:(NSString*)msgdisplay;

/***
 转账汇款请求获得银行交易流水号
 */
-(NLProtocolData*)transferMoneyRqXML:(NSString*)paycardid fucardno:(NSString*)fucardno fucardbank:(NSString*)fucardbank fucardman:(NSString*)fucardman fucardmobile:(NSString*)fucardmobile shoucardno:(NSString*)shoucardno shoucardbank:(NSString*)shoucardbank current:(NSString*)current paymoney:(NSString*)paymoney payfee:(NSString*)payfee money:(NSString*)money shoucardmobile:(NSString*)shoucardmobile shoucardman:(NSString*)shoucardman arriveid:(NSString*)arriveid shoucardmemo:(NSString*)shoucardmemo sendsms:(NSString*)sendsms merReserved:(NSString*)merReserved;

/***
 信贷还款
 */
-(NLProtocolData*)readRepayMoneyfeeXML:(NSString*)paytype paymoney:(NSString*)paymoney paybankid:(NSString*)paybankid paycardid:(NSString*)paycardid;

/***
 插入信贷还款记录
 */
-(NLProtocolData*)insertRepayMoneyXML:(NSString*)bkntno result:(NSString*)result;

/***
 读取信贷还款历史记录
 */
-(NLProtocolData*)readRepayMoneyglistXML:(NSString*)paytype msgstart:(NSString*)msgstart msgdisplay:(NSString*)msgdisplay;

/***
 充值接口
 */
-(NLProtocolData*)rechargeglistXML:(NSString*)banktype bankname:(NSString*)bankname bankno:(NSString*)bankno paymoney:(NSString*)paymoney;

/***
 充值接口请求获得交易流水号
 */
-(NLProtocolData*)rechargeReqXML:(NSString*)banktype bankname:(NSString*)bankname cardno:(NSString*)cardno paymoney:(NSString*)paymoney cardmobile:(NSString*)cardmobile cardman:(NSString*)cardman sendsms:(NSString*)sendsms paycardid:(NSString*)paycardid merReserved:(NSString*)merReserved;

/***
 充值接口交易成功反馈
 */
-(NLProtocolData*)rechargePayXML:(NSString*)bkntno result:(NSString*)result;

/***
 购买抵用券获得银行交易流水号
 */
-(NLProtocolData*)couponSaleXML:(NSString*)couponid couponmoney:(NSString*)couponmoney paycardid:(NSString*)paycardid creditcardno:(NSString*)creditcardno creditbank:(NSString*)creditbank creditcardman:(NSString*)creditcardman creditcardphone:(NSString*)creditcardphone merReserved:(NSString*)merReserved;

/***
 回购优惠券列表
 */
-(NLProtocolData*)couponRebuylistXML;

/***
 回购优惠券操作
 */
-(NLProtocolData*)couponRebuyXML:(NSString*)couponid couponno:(NSString*)couponno bankid:(NSString*)bankid banksub:(NSString*)banksub bankcardno:(NSString*)bankcardno cardname:(NSString*)cardname cardphone:(NSString*)cardphone couponfee:(NSString*)couponfee sxfmoney:(NSString*)sxfmoney getmoney:(NSString*)getmoney;

/***
 读取银行列表
 */
-(NLProtocolData*)readBankListXML:(NSString*)activemobilesms;

/***
 读取银行列表(New分页)
 */
-(NLProtocolData*)readBankListByPagingXML:(NSString*)activemobilesms msgstart :(NSString*)msgstart msgdisplay:(NSString*)msgdisplay querywhere:(NSString*)querywhere;

/***
 读取首页广告列表
 */
-(NLProtocolData*)readIndexAdListXML:(NSString*)msgadtype;

/***
 激活插卡器
 */
-(NLProtocolData*)activePayCardXML:(NSString*)paycardkey;

/***
 余额查询
 */
-(NLProtocolData*)readQueryCardMoneyXML:(NSString*)bankcardno bankid:(NSString*)bankid bankname:(NSString*)bankname;

/***
 转账汇款手续费计算
 */
-(NLProtocolData*)getTransferPayfeeXML:(NSString*)bankid money:(NSString*)money arriveid:(NSString*)arriveid;

/***
 还贷款手续费计算
 */
-(NLProtocolData*)getRepayMoneyPayfeeXML:(NSString*)bankid money:(NSString*)money;


/***
 还贷款请求银行交易流水号
 */
-(NLProtocolData*)RepayMoneyRqXML:(NSString*)paycardid fucardno:(NSString*)fucardno fucardmobile:(NSString*)fucardmobile fucardman:(NSString*)fucardman fucardbank:(NSString*)fucardbank shoucardno:(NSString*)shoucardno shoucardmobile:(NSString*)shoucardmobile shoucardman:(NSString*)shoucardman shoucardbank:(NSString*)shoucardbank current:(NSString*)current paymoney:(NSString*)paymoney payfee:(NSString*)payfee money:(NSString*)money;

/***
 读取抵用券选项
 */
-(NLProtocolData*)readcouponinfoXML;

/***
 购买抵用券支付成功
 */
-(NLProtocolData*)couponSalePayXML:(NSString*)bkntno result:(NSString*)result;

/***
 抵用券历史列表
 */
-(NLProtocolData*)couponSalelistXML:(NSString*)msgstart msgdisplay:(NSString*)msgdisplay;

/***
 刷卡器刷卡管理
 */
-(NLProtocolData*)payCardCheckXML:(NSString*)paycardkey;

/***
 获取协议/服务条款/关于我们信息
 */
-(NLProtocolData*)readAppruleListXML:(NSString*)appruleid;

/***
 功能模块菜单读取
 */
-(NLProtocolData*)readMenuModuleXML:(NSString*)paycardkey;

/***
 快递查询
 */
-(NLProtocolData*)kuaiStateXML:(NSString*)kdtype kdcode:(NSString*)kdcode;

/***
 读取快递公司列表
 */
-(NLProtocolData*)readKuaiDicmpListXML;

/***
 查询快递公司订单号
 */
-(NLProtocolData*)chaxunKuaiDiNoXML:(NSString*)com nu:(NSString*)nu;

/***
 获取订单信息
 */
-(NLProtocolData*)readOrderListXML:(NSString*)msgstart msgdisplay:(NSString*)msgdisplay orderno:(NSString*)orderno orderstate:(NSString*)orderstate querywhere:(NSString*)querywhere;

/***
 支付订单获取银行卡获取银行流水号
 */
-(NLProtocolData*)orderPayReqXML:(NSString*)orderid orderno:(NSString*)orderno paymoney:(NSString*)paymoney bankcardno:(NSString*)bankcardno bankname:(NSString*)bankname merReserved:(NSString*)merReserved;

/***
 支付订单成功后反馈
 */
//-(NLProtocolData*)orderPayFeedbackXML:(NSString*)bkntno;
-(NLProtocolData*)orderPayFeedbackXML:(NSString*)request bkntno:(NSString *)bkntno;

/***
 支付订单获取银行卡星级评价
 */
-(NLProtocolData*)orderPayBankCardStarXML:(NSString*)orderid orderno:(NSString*)orderno paymoney:(NSString*)paymoney bankcardno:(NSString*)bankcardno bankname:(NSString*)bankname;

/***
 读取银行卡信息
 */
-(NLProtocolData*)readAuBkCardInfoXML;

/***
 提交银行卡信息
 */
-(NLProtocolData*)modifyAuBkCardInfoXML:(NSString*)aushoucardman aushoucardphone:(NSString*)aushoucardphone aushoucardno:(NSString*)aushoucardno aushoucardbank:(NSString*)aushoucardbank;

/***
 读取收款银行卡历史记录
 */
-(NLProtocolData*)readshoucardListXML:(NSString*)paytype;

/***
 超级转账手续费计算
 */
-(NLProtocolData*)getSupTransferPayfeeXML:(NSString*)bankid money:(NSString*)money arriveid:(NSString*)arriveid;

/***
 超级转账请求获得银行交易流水号
 */
-(NLProtocolData*)SuptransferMoneyRqXML:(NSString*)paycardid fucardno:(NSString*)fucardno fucardbank:(NSString*)fucardbank fucardman:(NSString*)fucardman fucardmobile:(NSString*)fucardmobile shoucardno:(NSString*)shoucardno shoucardbank:(NSString*)shoucardbank current:(NSString*)current paymoney:(NSString*)paymoney payfee:(NSString*)payfee money:(NSString*)money shoucardmobile:(NSString*)shoucardmobile shoucardman:(NSString*)shoucardman arriveid:(NSString*)arriveid shoucardmemo:(NSString*)shoucardmemo sendsms:(NSString*)sendsms merReserved:(NSString*)merReserved;

/***
 超级转账支付成功反馈
 */
-(NLProtocolData*)insertSupTransferMoneyXML:(NSString*)bkntno result:(NSString*)result;

/***
 读取超级转账历史记录
 */
-(NLProtocolData*)readSupTransferMoneyglistXML:(NSString*)paytype msgstart:(NSString*)msgstart msgdisplay:(NSString*)msgdisplay;

//读取充值金额选项
-(NLProtocolData *)readRechaMoneyinfoXML;

/***
 话费充值
 */
-(NLProtocolData*)paycardIDRqXML:(NSString *)paycardid rechapaytypeid:(NSString *)rechapaytypeid rechamoney:(NSString *)rechamoney rechapaymoney:(NSString *)rechapaymoney rechamobile:(NSString *)rechamobile rechamobileprov:(NSString *)rechamobileprov rechabkcardno:(NSString *)rechabkcardno rechabkcardid:(NSString *)rechabkcardid merReserved:(NSString *)merReserved;

/***
 手机充值支付成功反馈
 */
-(NLProtocolData*)checkRechaMoneyStatusXML:(NSString*)bkntno result:(NSString*)result;

/**
 读取手机充值历史记录
 */
-(NLProtocolData*)readMobileRechangelistXML:(NSString*)paytype msgstart:(NSString*)msgstart msgdisplay:(NSString*)msgdisplay;

//读取Q币充值金额选项
-(NLProtocolData *)readRechaQQMoneyinfoXML;

/***
 Q币充值
 */
-(NLProtocolData*)payQQcardIDRqXML:(NSString *)paycardid rechapaytypeid:(NSString *)rechapaytypeid rechamoney:(NSString *)rechamoney rechapaymoney:(NSString *)rechapaymoney rechaqq:(NSString *)qq rechabkcardno:(NSString *)rechabkcardno rechabkcardid:(NSString *)rechabkcardid merReserved:(NSString *)merReserved;

/***
 Q币充值支付成功反馈
 */
-(NLProtocolData*)checkRechaQQMoneyStatusXML:(NSString*)bkntno result:(NSString*)result;

/**
 读取Q币充值历史记录
 */
-(NLProtocolData*)readMobileRechangeQQlistXML:(NSString*)paytype msgstart:(NSString*)msgstart msgdisplay:(NSString*)msgdisplay;

/**
 内部购买刷卡器-读取产品管理信息
 */
-(NLProtocolData *)readSKQOrderInfoXML;

/**
 内部购买刷卡器-读取收货地址
 */
-(NLProtocolData *)readSKQShaddressInfoXML;

/**
 内部购买刷卡器-新增收货地址
*/
-(NLProtocolData *)addSKQShaddressProvinceXML:(NSString *)province city:(NSString *)city county:(NSString *)county address:(NSString *)address man:(NSString *)man phone:(NSString *)phone defaultAdress:(NSString *)defaultAdress;

/**
 内部购买刷卡器-删除收货地址
*/
-(NLProtocolData *)deleteSKQShaddressWithAddressIdXML:(NSString *)addressId;


/**
 内部购买刷卡器-支付请求银联交易码
*/
-(NLProtocolData*)paySKQcardIDRqXML:(NSString *)paycardid orderPaytypeid:(NSString *)orderPaytypeid orderprodureid:(NSString *)orderprodureid ordernum:(NSString *)ordernum orderprice:(NSString *)orderprice ordermoney:(NSString *)ordermoney ordershaddressid:(NSString *)ordershaddressid oredershaddress:(NSString *)oredershaddress ordershman:(NSString *)ordershman ordershphone:(NSString *)ordershphone orderfucardno:(NSString *)orderfucardno orderfucardbank:(NSString *)orderfucardbank ordermemo:(NSString *)ordermemo yunmoney:(NSString *)yunmoney yunprice:(NSString *)yunprice promoney:(NSString *)promoney produrename:(NSString *)produrename agentno:(NSString*)agentno;

/**
 内部购买刷卡器-银联支付成功反馈
*/
-(NLProtocolData*)checkPaySKQStatusXML:(NSString*)bkntno result:(NSString*)result;

/**
 内部购买刷卡器-读取购买历史记录
 */
-(NLProtocolData*)readPaySKQhistorylistXML:(NSString*)paytype msgstart:(NSString*)msgstart msgdisplay:(NSString*)msgdisplay;

/*
 读取水电煤服务列表
 */
-(NLProtocolData*)readWaterEleProductListXML;

/*
水电煤生成订单
 */
-(NLProtocolData*)createWaterEleOrderXML:(NSString *)account productId:(NSString *)productId;

/*
 水电煤提交订单
 */
-(NLProtocolData*)submitWaterEleOrderXML:(NSString *)orderId paycardid:(NSString *)paycardId rechabkcardno:(NSString *)rechabkcardno merReserved:(NSString *)merReserved;

/*
 水电煤支付完订单反馈
 */
-(NLProtocolData*)completeWaterEleOrderXML:(NSString *)orderid bkntno:(NSString *)bkntno;

/*
 水电煤查询历史订单
 */
-(NLProtocolData*)getWaterEleOrderHistoryWithmsgStartXML:(NSString*)msgstart msgdisplay:(NSString*)msgdisplay;

/**** 游戏充值 ****/

//获取游戏列表
-(NLProtocolData*)getGameChargeGameListXML;

//获取平台
-(NLProtocolData*)getGameChargeplatformXML;

//游戏小类列表
-(NLProtocolData*)getGameChargeChildGameXML:(NSString *)gameId;

//获取某一游戏详细信息
-(NLProtocolData*)getGameChargeGameDetailXML:(NSString *)gameId;

//生成订单
-(NLProtocolData*)GameChargeCreateOrderXML:(NSString *)gameId gameName:(NSString *)gameName area:(NSString *)area server:(NSString *)server quantity:(NSString *)quantity price:(NSString *)price userCount:(NSString *)userCount paycardid:(NSString *)paycardid rechabkcardno:(NSString *)rechabkcardno cost:(NSString*)cost;

//支付完订单
-(NLProtocolData*)completeGameChargeOrderXML:(NSString *)bkntno;

//查询历史订单
-(NLProtocolData*)getGameChargeOrderHistoryWithmsgStartXML:(NSString*)msgstart msgdisplay:(NSString*)msgdisplay;

/*** 代理商 ****/

//代理商读取基本信息
-(NLProtocolData*)readagentinfoXML;

//代理商读取读取补货记录
-(NLProtocolData*)readagentorderlistXML:(NSString*)paytype msgstart:(NSString*)msgstart msgdisplay:(NSString*)msgdisplay;

//代理商补货发货状态提交
-(NLProtocolData*)agentorderstaterqXML:(NSString *)orderid;

//代理商补货请求银行交易码
-(NLProtocolData*)payagentOrderRqXML:(NSString *)orderprodureid ordernum:(NSString *)ordernum orderprice:(NSString *)orderprice ordermoney:(NSString *)ordermoney rechabkcardno:(NSString *)rechabkcardno orderfucardbank:(NSString *)orderfucardbank ordermemo:(NSString *)ordermemo;

//代理商银联支付成功反馈
-(NLProtocolData*)agentorderPayrqStatusXML:(NSString*)bkntno result:(NSString*)result;

//代理商读取历史收益记录
-(NLProtocolData*)payagentfenrunlistXML:(NSString *)querytype querywhere:(NSString *)querywhere;

//绑定代理
-(NLProtocolData*)BindingAgentIdXML:(NSString *)querytype agentno:(NSString *)agentno;

//新注册页面
-(NLProtocolData*)getTheNewLoginApiAuthorInfoV2XML:(NSString *)Mac Phone:(NSString*)phone Password:(NSString*)Password;

//判断用户是否已经注册
-(NLProtocolData*)getApiAuthorInfoV2IsOnMainXML:(NSString *)Mac Phone:(NSString*)phone accountnumber:(NSString*)accountnumber Password:(NSString*)Password;

//用户登录
- (NLProtocolData*)getApiAuthorInfoV2gesturepasswdXML:(NSString *)password paypasswd:(NSString *)paypasswd mobile:(NSString*)mobile;

//用户修改密码(login密码修改的)
- (NLProtocolData*)getApiAuthorInfoPasswordToChageXML:(NSString *)oldpassword newpassword:(NSString *)newpassword aumoditype:(NSString *)aumoditype reset:(NSString *)reset;

//获取所有预设密保问题
- (NLProtocolData*)getApiSafeGuardXML;

//设置密保问题
- (NLProtocolData *)getApiSafeGuardMsgchildXML:(NSString*)quechild1 answer1:(NSString*)answer1 quechild2:(NSString*)quechild2 answer2:(NSString*)answer2 quechild3:(NSString*)quechild3 answer3:(NSString*)answer3;


//获取密保问题
- (NLProtocolData *)getApiSafeGuardUserXML:(NSString*)PhoneNumber;

//判断是否有默认绑定账户
- (NLProtocolData*)getApiAuthorInfoV2modifyAuthorInfoXML:(NSString*)PhoneNumber accountnumber:(NSString*)accountnumber accountname:(NSString*)accountname bankname:(NSString*)bankname;

//飞机票城市的查询
- (NLProtocolData*)getApiAirticketXML:(NSString*)firstLetter cityName:(NSString*)cityName;

//航班查询
- (NLProtocolData*)getApigetAirlineXML:(NSString*)departCityCode arriveCityCode:(NSString*)arriveCityCode departDate:(NSString*)departDate returnDate:(NSString*)returnDate searchType:(NSString*)searchType;

//菜单模板读取
- (NLProtocolData*)getApireadMenuModuleXML:(NSString*)paycardkey appversion:(NSString*)appversion;

//菜单模板点击
- (NLProtocolData*)getApireadMenutapCountXML:(NSString*)appmnuid agentno:(NSString*)agentno;

//商户读取代理商信息
- (NLProtocolData *)getApiAgentInfoXML;

//代理商申请省
- (NLProtocolData *)getApiAgentApplyWithProvXML;

//代理商申请市
- (NLProtocolData *)getApiAgentApplyWithCityXML:(NSString *)city;

//代理商申请区
- (NLProtocolData *)getApiAgentApplyWithTownXML:(NSString *)city town:(NSString *)town;

//代理商申请
- (NLProtocolData *)getApiAgentApplyAddWithXML:(NSString *)custypeid name:(NSString *)name address:(NSString *)address prov:(NSString *)prov city:(NSString *)city town:(NSString *)town;

//代理商申请信息
- (NLProtocolData *)getApiAgentApplyXML;

//绑定代理商
- (NLProtocolData *)getApiAgentInfoBindXML:(NSString *)agentNo;

//虚拟代理商
- (NLProtocolData *)getApiAgentApplyInsertParttXML;

//读取新的信息
- (NLProtocolData *)getApiAppInfoXML;

/*我的银行卡*/
//读取用户银行卡列表
- (NLProtocolData *)getApiAuthorKuaibkcardInfoListsXML;

//添加新的银行卡
- (NLProtocolData *)getApiAuthorKuaibkcardInfoAddXML:(NSString *)bkcardbankid bkcardbank:(NSString *)bkcardbank bkcardno:(NSString *)bkcardno bkcardbankman:(NSString *)bkcardbankman bkcardbankphone:(NSString *)bkcardbankphone bkcardyxmonth:(NSString *)bkcardyxmonth bkcardyxyear:(NSString *)bkcardyxyear bkcardcvv:(NSString *)bkcardcvv bkcardidcard:(NSString *)bkcardidcard bkcardcardtype:(NSString *)bkcardcardtype bkcardisdefault:(NSString *)bkcardisdefault;

//修改银行卡
- (NLProtocolData *)getApiAuthorKuaibkcardInfoEditXML:(NSString *)bkcardid bkcardbankid:(NSString *)bkcardbankid bkcardbank:(NSString *)bkcardbank bkcardno:(NSString *)bkcardno bkcardbankman:(NSString *)bkcardbankman bkcardbankphone:(NSString *)bkcardbankphone bkcardyxmonth:(NSString *)bkcardyxmonth bkcardyxyear:(NSString *)bkcardyxyear bkcardcvv:(NSString *)bkcardcvv bkcardidcard:(NSString *)bkcardidcard bkcardcardtype:(NSString *)bkcardcardtype bkcardisdefault:(NSString *)bkcardisdefault;

//移除银行卡
- (NLProtocolData *)getApiAuthorKuaibkcardInfoDeleteXML:(NSString *)bkcardid;

//绑定银行卡
- (NLProtocolData *)getApiAuthorKuaibkcardInfoDefaultXML:(NSString *)bkcardid bkcardisdefault:(NSString *)bkcardisdefault;

/*易宝手机充值*/
- (NLProtocolData *)getApiYiBaoPhonePayXML:(NSString *)rechargeMoney payMoney:(NSString *)payMoney rechargePhone:(NSString *)rechargePhone  bankCardId:(NSString *)bankCardId bankId:(NSString *)bankId manCardId:(NSString *)manCardId payPhone:(NSString *)payPhone manName:(NSString *)manName expireYear:(NSString *)expireYear expireMonth:(NSString *)expireMonth cvv:(NSString *)cvv mobileProvince:(NSString *)mobileProvince  paycardid:(NSString *)paycardid;

/*易宝验证码*/
- (NLProtocolData *)getApiYiBaoVerifyCodeXML:(NSString *)orderId verifyCode:(NSString*)verifyCode;

/*易宝信用转账*/
- (NLProtocolData *)getApiTransferWithCreditCardXML:(NSString *)payMoney transferMoney:(NSString *)transferMoney receiveBankCardId:(NSString *)receiveBankCardId  receiveBankName:(NSString *)receiveBankName receivePhone:(NSString *)receivePhone receivePersonName:(NSString *)receivePersonName cardReaderId:(NSString *)cardReaderId sendBankCardId:(NSString *)sendBankCardId sendBankCode:(NSString *)sendBankCode personCardId:(NSString *)personCardId sendPhone:(NSString *)sendPhone sendPersonName:(NSString *)sendPersonName  expireYear:(NSString *)expireYear expireMonth:(NSString *)expireMonth cvv:(NSString *)cvv transferType:(NSString *)transferType arriveid:(NSString*)arriveid sendBankName:(NSString*)sendBankName payType:(NSString*)payType paycardid:(NSString*)paycardid;

/*易宝转账验证码*/
- (NLProtocolData *)getApiPayWithVerifyCodeXML:(NSString *)orderId verifyCode:(NSString*)verifyCode;

/*易宝游戏充值*/
- (NLProtocolData *)ApiGamePayWithCreditCardXML:(NSString *)gameId gameName:(NSString *)gameName area:(NSString *)area  server:(NSString *)server quantity:(NSString *)quantity price:(NSString *)price cost:(NSString *)cost userCount:(NSString *)userCount paycardid:(NSString *)paycardid bankCardId:(NSString *)bankCardId bankId:(NSString *)bankId manCardId:(NSString *)manCardId  payPhone:(NSString *)payPhone manName:(NSString *)manName expireYear:(NSString *)expireYear expireMonth:(NSString *)expireMonth cvv:(NSString *)cvv;

/*易宝游戏验证码*/
- (NLProtocolData *)getApiGamePayWithVerifyCodeXML:(NSString *)orderId verifyCode:(NSString*)verifyCode;

/*话费是否可以充值*/
- (NLProtocolData *)getApiCanRechargeXML:(NSString *)money phone:(NSString*)phone;

/*读取快捷支付默认信用卡号*/
- (NLProtocolData *)getApiPaychannelInfoXML:(NSString *)bkcardid bkcardisdefault:(NSString*)bkcardisdefault;

@end











