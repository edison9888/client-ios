//
//  NLProtocolRequest.h
//  TongFubao
//
//  Created by MD313 on 13-8-16.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NLContants.h"
#import "ProtocolDefine.h"
#import "NLProtocolResponse.h"

@interface NLProtocolRequest : NSObject


/***
 初始化
 */
//+(id)shareProtocolRequestWithRegister:(BOOL)reg;

-(id)initWithRegister:(BOOL)reg;

-(id)initWithURL:(NSString *)url content:(NSData *)content;

/***
 停止请求
 flag 停止原因
 */
-(void)stopRequest:(NSString*)flag;

/***
 用户注册短信校验码获取
 */
-(void)getSmsCode:(NSString*)mobile;

/***
 用户注册短信校验成功后注册资料登记
 */
-(void)authorReg:(NSString*)mobile password:(NSString*)password name:(NSString*)name idCard:(NSString*)idCard email:(NSString*)email;

/***
 用户密码修改V2
 */
-(void)authorPwdModify:(NSString*)oldPW newPW:(NSString*)newPW type:(NSString*)type reset:(NSString*)reset;

/***
 用户意见反馈
 */
-(void)authorFeedbck:(NSString*)content contact:(NSString*)contact;

/***
 版本更新
 */
-(void)checkAppVersion:(NSString*)type version:(NSString*)version;

/***
 读取用户信息
 */
-(void)readAuthorInfo;

/***
 用户身份证图片上传
 */
-(void)uploadAuthorPic:(NSString*)picid picpath:(NSString*)picpath uploadmethod:(NSString*)uploadmethod uploadpictype:(NSString*)uploadpictype uploadmark:(NSString*)uploadmark;

/***
 修改用户信息
 */
-(void)modifyAuthorInfo:(NSString*)name idCard:(NSString*)idCard email:(NSString*)email agentcompany:(NSString*)agentcompany agentarea:(NSString*)agentarea  agentaddress:(NSString*)agentaddress agentmanphone:(NSString*)agentmanphone agentfax:(NSString*)agentfax;

/***
 登录管理
 */
-(void)checkAuthorLogin:(NSString*)userName password:(NSString*)password auloginmethod:(NSString*)auloginmethod mpmodel:(NSString*)mpmodel;

/***
 忘记密码短信校验码获取
 */
-(void)getSmsCodeInfo:(NSString*)mobile;

/***
 忘记密码修改
 */
-(void)forgetPwdModify:(NSString*)aumobile aunewpwd:(NSString*)aunewpwd aurenewpwd:(NSString*)aurenewpwd  aumoditype:(NSString*)aumoditype;

/***
 帮助中心列表显示
 */
-(void)readHelpList:(NSString*)start display:(NSString*)display;

/***
 我的钱包
 */
-(void)readMyAccount;

/***
 我的钱包收支明细
 */
-(void)readAccglist:(NSString*)acctypeid;

/***
 我的钱包收支详情
 */
-(void)readAccglistdetail:(NSString*)acctypeid month:(NSString*)month;

/***
 短信校验码获取
 */
-(void)getSmsVerifyCode:(NSString*)mobile;

/***
 信用卡还款
 */
-(void)readCreditCardfee:(NSString*)type amount:(NSString*)amount bankID:(NSString*)bankID cardID:(NSString*)cardID;

/***
 信用卡还款支付成功
 */
-(void)insertcreditCardMoney:(NSString*)bkntno result:(NSString*)result;

/***
 读取信用卡还款记录
 */
-(void)readCreditCardglist:(NSString*)paytype msgstart:(NSString*)msgstart msgdisplay:(NSString*)msgdisplay;

/***
 信用卡还款请求
 */
-(void)creditCardMoneyRq:(NSString*)paytype paymoney:(NSString*)paymoney shoucardno:(NSString*)shoucardno shoucardmobile:(NSString*)shoucardmobile shoucardman:(NSString*)shoucardman shoucardbank:(NSString*)shoucardbank fucardno:(NSString*)fucardno fucardbank:(NSString*)fucardbank fucardmobile:(NSString*)fucardmobile fucardman:(NSString*)fucardman current:(NSString*)current paycardid:(NSString*)paycardid merReserved:(NSString*)merReserved;

/***
 转账汇款
 */
-(void)readTransferMoneyfee:(NSString*)paytype paymoney:(NSString*)paymoney paybankid:(NSString*)paybankid paycardid:(NSString*)paycardid;

/***
 转账汇款支付成功反馈
 */
-(void)insertTransferMoney:(NSString*)bkntno result:(NSString*)result;

/***
 读取转账汇款记录
 */
-(void)readTransferMoneyglist:(NSString*)paytype msgstart:(NSString*)msgstart msgdisplay:(NSString*)msgdisplay;

/***
 转账汇款请求获得银行交易流水号
 */
-(void)transferMoneyRq:(NSString*)paycardid fucardno:(NSString*)fucardno fucardbank:(NSString*)fucardbank fucardman:(NSString*)fucardman fucardmobile:(NSString*)fucardmobile shoucardno:(NSString*)shoucardno shoucardbank:(NSString*)shoucardbank current:(NSString*)current paymoney:(NSString*)paymoney payfee:(NSString*)payfee money:(NSString*)money shoucardmobile:(NSString*)shoucardmobile shoucardman:(NSString*)shoucardman arriveid:(NSString*)arriveid shoucardmemo:(NSString*)shoucardmemo sendsms:(NSString*)sendsms merReserved:(NSString*)merReserved;

/***
 转账汇款手续费计算
 */
-(void)getTransferPayfee:(NSString*)bankid money:(NSString*)money arriveid:(NSString*)arriveid;

/***
 信贷还款
 */
-(void)readRepayMoneyfee:(NSString*)paytype paymoney:(NSString*)paymoney paybankid:(NSString*)paybankid paycardid:(NSString*)paycardid;

/***
 插入信贷还款记录
 */
-(void)insertRepayMoney:(NSString*)bkntno result:(NSString*)result;

/***
 读取信贷还款历史记录
 */
-(void)readRepayMoneyglist:(NSString*)paytype msgstart:(NSString*)msgstart msgdisplay:(NSString*)msgdisplay;

/***
 充值接口
 */
-(void)rechargeglist:(NSString*)banktype bankname:(NSString*)bankname bankno:(NSString*)bankno paymoney:(NSString*)paymoney;

/***
 充值接口请求获得交易流水号
 */
-(void)rechargeReq:(NSString*)banktype bankname:(NSString*)bankname cardno:(NSString*)cardno paymoney:(NSString*)paymoney cardmobile:(NSString*)cardmobile cardman:(NSString*)cardman sendsms:(NSString*)sendsms paycardid:(NSString*)paycardid merReserved:(NSString*)merReserved;

/***
 充值接口交易成功反馈
 */
-(void)rechargePay:(NSString*)bkntno result:(NSString*)result;

/***
 购买抵用券获得银行交易流水号
 */
-(void)couponSale:(NSString*)couponid couponmoney:(NSString*)couponmoney paycardid:(NSString*)paycardid creditcardno:(NSString*)creditcardno creditbank:(NSString*)creditbank creditcardman:(NSString*)creditcardman creditcardphone:(NSString*)creditcardphone merReserved:(NSString*)merReserved;

/***
 回购优惠券列表
 */
-(void)couponRebuylist;

/***
 回购优惠券操作
 */
-(void)couponRebuy:(NSString*)couponid couponno:(NSString*)couponno bankid:(NSString*)bankid banksub:(NSString*)banksub bankcardno:(NSString*)bankcardno cardname:(NSString*)cardname cardphone:(NSString*)cardphone couponfee:(NSString*)couponfee sxfmoney:(NSString*)sxfmoney getmoney:(NSString*)getmoney;

/***
 读取银行列表
 */
-(void)readBankList:(NSString*)activemobilesms;

/***
 读取银行列表(New分页显示)
 */
-(void)readBankListByPaging:(NSString*)activemobilesms msgstart :(NSString*)msgstart msgdisplay:(NSString*)msgdisplay querywhere:(NSString*)querywhere banktype:(NSString*)banktype returnReadmode:(NSString *)newReturnReadmode;

/***
 读取首页广告列表
 */
-(void)readIndexAdList:(NSString*)msgadtype;

/***
 激活插卡器
 */
-(void)activePayCard:(NSString*)paycardkey;

/***
 余额查询
 */
-(void)readQueryCardMoney:(NSString*)bankcardno bankid:(NSString*)bankid bankname:(NSString*)bankname;

/***
 还贷款手续费计算
 */
-(void)getRepayMoneyPayfee:(NSString*)bankid money:(NSString*)money;

/***
 还贷款请求银行交易流水号
 */
-(void)RepayMoneyRq:(NSString*)paycardid fucardno:(NSString*)fucardno fucardmobile:(NSString*)fucardmobile fucardman:(NSString*)fucardman fucardbank:(NSString*)fucardbank shoucardno:(NSString*)shoucardno shoucardmobile:(NSString*)shoucardmobile shoucardman:(NSString*)shoucardman shoucardbank:(NSString*)shoucardbank current:(NSString*)current paymoney:(NSString*)paymoney payfee:(NSString*)payfee money:(NSString*)money;

/***
 读取抵用券选项
 */
-(void)readcouponinfo;

/***
 购买抵用券支付成功
 */
-(void)couponSalePay:(NSString*)bkntno result:(NSString*)result;

/***
 抵用券历史列表
 */
-(void)couponSalelist:(NSString*)msgstart msgdisplay:(NSString*)msgdisplay;

/***
 刷卡器刷卡管理
 */
-(void)payCardCheck:(NSString*)paycardkey;

/***
 获取协议/服务条款/关于我们信息
 */
-(void)readAppruleList:(NSString*)appruleid;

/***
 功能模块菜单读取
 */
-(void)readMenuModule:(NSString*)paycardkey;

/***
 快递查询
 */
-(void)kuaiState:(NSString*)kdtype kdcode:(NSString*)kdcode;

/***
 读取快递公司列表
 */
-(void)readKuaiDicmpList;

/***
 查询快递公司订单号
 */
-(void)chaxunKuaiDiNo:(NSString*)com nu:(NSString*)nu;

/***
 获取订单信息
 */
-(void)readOrderList:(NSString*)msgstart msgdisplay:(NSString*)msgdisplay orderno:(NSString*)orderno orderstate:(NSString*)orderstate querywhere:(NSString*)querywhere;

/***
 支付订单获取银行卡获取银行流水号
 */
-(void)orderPayReq:(NSString*)orderid orderno:(NSString*)orderno paymoney:(NSString*)paymoney bankcardno:(NSString*)bankcardno bankname:(NSString*)bankname merReserved:(NSString*)merReserved;

/***
 支付订单成功后反馈
 */
//-(void)orderPayFeedback:(NSString*)bkntno;
-(void)orderPayFeedback:(NSString*)request bkntno:(NSString *)bkntno;

/***
 支付订单获取银行卡星级评价
 */
-(void)orderPayBankCardStar:(NSString*)orderid orderno:(NSString*)orderno paymoney:(NSString*)paymoney bankcardno:(NSString*)bankcardno bankname:(NSString*)bankname;

/***
 读取银行卡信息
 */
-(void)readAuBkCardInfo;

/***
 提交银行卡信息
 */
-(void)modifyAuBkCardInfo:(NSString*)aushoucardman aushoucardphone:(NSString*)aushoucardphone aushoucardno:(NSString*)aushoucardno aushoucardbank:(NSString*)aushoucardbank;

/***
 读取收款银行卡历史记录
 */
-(void)readshoucardList:(NSString*)paytype;

/***
 超级转账手续费计算
 */
-(void)getSupTransferPayfee:(NSString*)bankid money:(NSString*)money arriveid:(NSString*)arriveid;

/***
 超级转账请求获得银行交易流水号
 */
-(void)SuptransferMoneyRq:(NSString*)paycardid fucardno:(NSString*)fucardno fucardbank:(NSString*)fucardbank fucardman:(NSString*)fucardman fucardmobile:(NSString*)fucardmobile shoucardno:(NSString*)shoucardno shoucardbank:(NSString*)shoucardbank current:(NSString*)current paymoney:(NSString*)paymoney payfee:(NSString*)payfee money:(NSString*)money shoucardmobile:(NSString*)shoucardmobile shoucardman:(NSString*)shoucardman arriveid:(NSString*)arriveid shoucardmemo:(NSString*)shoucardmemo sendsms:(NSString*)sendsms merReserved:(NSString*)merReserved;

/***
 超级转账支付成功反馈
 */
-(void)insertSupTransferMoney:(NSString*)bkntno result:(NSString*)result;

/***
 读取超级转账历史记录
 */
-(void)readSupTransferMoneyglist:(NSString*)paytype msgstart:(NSString*)msgstart msgdisplay:(NSString*)msgdisplay;

//读取充值金额选项
-(void)readRechaMoneyinfo;

/***
 手机话费充值
 */
-(void)paycardIDRq:(NSString *)paycardid rechapaytypeid:(NSString *)rechapaytypeid rechamoney:(NSString *)rechamoney rechapaymoney:(NSString *)rechapaymoney rechamobile:(NSString *)rechamobile rechamobileprov:(NSString *)rechamobileprov rechabkcardno:(NSString *)rechabkcardno rechabkcardid:(NSString *)rechabkcardid merReserved:(NSString *)merReserved;

/***
 手机充值支付成功反馈
 */
-(void)checkRechaMoneyStatus:(NSString*)bkntno result:(NSString*)result;

/**
 读取手机充值历史记录
 */
-(void)readMobileRechangelist:(NSString*)paytype msgstart:(NSString*)msgstart msgdisplay:(NSString*)msgdisplay;

//读取QQ币充值金额选项
-(void)readRechaQQMoneyinfo;

/***
 Q币充值
 */
-(void)payQQcardIDRq:(NSString *)paycardid rechapaytypeid:(NSString *)rechapaytypeid rechamoney:(NSString *)rechamoney rechapaymoney:(NSString *)rechapaymoney rechaqq:(NSString *)rechaqq rechabkcardno:(NSString *)rechabkcardno rechabkcardid:(NSString *)rechabkcardid merReserved:(NSString *)merReserved;

/***
 Q币充值支付成功反馈
 */
-(void)checkRechaQQMoneyStatus:(NSString*)bkntno result:(NSString*)result;

/**
 读取Q币充值历史记录
 */
-(void)readMobileRechangeQQlist:(NSString*)paytype msgstart:(NSString*)msgstart msgdisplay:(NSString*)msgdisplay;

/**
 内部购买刷卡器-读取产品管理信息
 */
-(void)readSKQOrderInfo;

/**
 内部购买刷卡器-读取收货地址
 */
-(void)readSKQShaddressInfo;

/**
 内部购买刷卡器-新增收货地址
 */
-(void)addSKQShaddressProvince:(NSString *)province city:(NSString *)city county:(NSString *)county address:(NSString *)address man:(NSString *)man phone:(NSString *)phone defaultAdress:(NSString *)defaultAdress;

/**
 内部购买刷卡器-删除收货地址
 */
-(void)deleteSKQShaddressWithAddressId:(NSString *)addressId;

/**
 内部购买刷卡器-支付请求银联交易码
 */
-(void)paySKQcardIDRq:(NSString *)paycardid orderPaytypeid:(NSString *)orderPaytypeid orderprodureid:(NSString *)orderprodureid ordernum:(NSString *)ordernum orderprice:(NSString *)orderprice ordermoney:(NSString *)ordermoney ordershaddressid:(NSString *)ordershaddressid oredershaddress:(NSString *)oredershaddress ordershman:(NSString *)ordershman ordershphone:(NSString *)ordershphone orderfucardno:(NSString *)orderfucardno orderfucardbank:(NSString *)orderfucardbank ordermemo:(NSString *)ordermemo yunmoney:(NSString *)yunmoney yunprice:(NSString *)yunprice promoney:(NSString *)promoney produrename:(NSString *)produrename agentno:(NSString*)agentno;

/**
 内部购买刷卡器-银联支付成功反馈
 */
-(void)checkPaySKQStatus:(NSString*)bkntno result:(NSString*)result;

/**
 内部购买刷卡器-读取购买历史记录
 */
-(void)readPaySKQhistorylist:(NSString*)paytype msgstart:(NSString*)msgstart msgdisplay:(NSString*)msgdisplay;

/*
 读取水电煤服务列表
 */
-(void)readWaterEleProductList;

/*
 水电煤生成订单
 */
-(void)createWaterEleOrder:(NSString *)account productId:(NSString *)productId;

/*
 水电煤提交订单
 */
-(void)submitWaterEleOrder:(NSString *)orderId paycardid:(NSString *)paycardId rechabkcardno:(NSString *)rechabkcardno merReserved:(NSString *)merReserved;

/*
 水电煤支付完订单反馈
 */
-(void)completeWaterEleOrder:(NSString *)orderid bkntno:(NSString *)bkntno;

/*
 水电煤查询历史订单
 */
-(void)getWaterEleOrderHistory:(NSString*)paytype msgstart:(NSString*)msgstart msgdisplay:(NSString*)msgdisplay;

/**** 游戏充值 ****/

//获取游戏列表
-(void)getGameChargeGameList;

//获取平台
-(void)getGameChargeplatform;

//游戏小类列表
-(void)getGameChargeChildGame:(NSString *)gameId;

//获取某一游戏详细信息
-(void)getGameChargeGameDetail:(NSString *)gameId;

//生成订单
-(void)GameChargeCreateOrder:(NSString *)gameId gameName:(NSString *)gameName area:(NSString *)area server:(NSString *)server quantity:(NSString *)quantity price:(NSString *)price userCount:(NSString *)userCount paycardid:(NSString *)paycardid rechabkcardno:(NSString *)rechabkcardno cost:(NSString*)cost;

//支付完订单
-(void)completeGameChargeOrder:(NSString *)bkntno;

//查询历史订单
-(void)getGameChargeOrderHistoryWithmsgStart:(NSString*)msgstart msgdisplay:(NSString*)msgdisplay;

//代理商读取基本信息
-(void)readagentinfo;

//代理商读取读取补货记录
-(void)readagentorderlist:(NSString*)paytype msgstart:(NSString*)msgstart msgdisplay:(NSString*)msgdisplay;

//代理商补货发货状态提交
-(void)agentorderstaterq:(NSString *)orderid;

//代理商补货请求银行交易码
-(void)payagentOrderRq:(NSString *)orderprodureid ordernum:(NSString *)ordernum orderprice:(NSString *)orderprice ordermoney:(NSString *)ordermoney rechabkcardno:(NSString *)rechabkcardno orderfucardbank:(NSString *)orderfucardbank ordermemo:(NSString *)ordermemo;

//代理商银联支付成功反馈
-(void)agentorderPayrqStatus:(NSString*)bkntno result:(NSString*)result;

//代理商读取历史收益记录
-(void)payagentfenrunlist:(NSString *)querytype querywhere:(NSString *)querywhere;

//绑定代理商
-(void)BindingAgentId:(NSString *)querytype agentno:(NSString *)agentno;

//新的注册信息接口
-(void)getTheNewLoginApiAuthorInfoV2:(NSString *)Mac Phone:(NSString*)phone Password:(NSString*)Password;

//判断用户是否注册
-(void)getApiAuthorInfoV2IsOnMain:(NSString *)Mac Phone:(NSString*)phone accountnumber:(NSString *)accountnumber Password:(NSString*)Password;

//用户登录
- (void)getApiAuthorInfoV2gesturepasswd:(NSString *)password paypasswd:(NSString *)paypasswd mobile:(NSString*)mobile;

//手势密码登录
- (void)getApiAuthorInfoV2gesturepasswdTohander:(NSString *)password paypasswd:(NSString *)paypasswd mobile:(NSString*)mobile;

//用户密码修改
- (void)getApiAuthorInfoPasswordToChage:(NSString *)oldpassword newpassword:(NSString *)newpassword aumoditype:(NSString *)aumoditype reset:(NSString *)reset;

//用户密码login修改
- (void)getApiAuthorInfoV2LoginPasswordToChage:(NSString *)oldpassword newpassword:(NSString *)newpassword aumoditype:(NSString *)aumoditype reset:(NSString *)reset;

//获取所有预设密保问题
- (void)getApiSafeGuard;

-(void)getApiSafeGuardMsgchild:(NSString*)quechild1 answer1:(NSString*)answer1 quechild2:(NSString*)quechild2 answer2:(NSString*)answer2 quechild3:(NSString*)quechild3 answer3:(NSString*)answer3;

//获取密保问题
- (void)getApiSafeGuardUser:(NSString*)PhoneNumber;

//用于注销后的通知 判断是否设置密保问题的
- (void)getApiSafeGuardLoginUp:(NSString*)PhoneNumber;

//判断账户是否有设置默认的银行卡
- (void)getApiAuthorInfoV2modifyAuthorInfo:(NSString*)PhoneNumber accountnumber:(NSString*)accountnumber accountname:(NSString*)accountname bankname:(NSString*)bankname;

#pragma mark ----飞机票

// 飞机票城市查询
- (void)getApiAirticket:(NSString*)firstLetter cityName:(NSString*)cityName;

// 航班查询
- (void)getApigetAirline:(NSString*)departCityCode arriveCityCode:(NSString*)arriveCityCode departDate:(NSString*)departDate returnDate:(NSString*)returnDate searchType:(NSString*)searchType;

// 航班详情
- (void)departCityCode:(NSString*)newDepartCityCode arriveCityCode:(NSString*)newArriveCityCode departTime:(NSString*)newDepartTime returnTime:(NSString*)newReturnTime searchType:(NSString*)newSearchType flight:(NSString *)newflight returnFlight:(NSString *)newreturnFlight;

// 添加乘机人
- (void)savePassengerName:(NSString*)newSavePassengerName savePassengerCardType:(NSString*)newSavePassengerCardType savePassengerCardId:(NSString*)newSavePassengerCardId savePassengerPhoneNumber:(NSString*)newsavePassengerPhoneNumber savePassengerPassengerType:(NSString *)newSavePassengerPassengerType birthday:(NSString *)newBirthDay;
// 添加联系人
- (void)savecontactName:(NSString*)newSavecontactName savecontactCardType:(NSString*)newSavecontactCardType savecontactCardId:(NSString*)newcontactCardId savecontactPhoneNumber:(NSString*)newcontactPhoneNumber savecontactType:(NSString *)newSavecontactPassengerType contactbirthday:(NSString *)newcontactBirthDay;


// 读取乘机人
- (void)getPassengerType:(NSString *)newPassengerType;
// 读取联系人
- (void)getContactType:(NSString *)newContactType;



// 删除乘机人
- (void)getdeletcetionPassengerId:(NSString *)newPassengerId  deletcetionPassengerType:(NSString *)newdeletcetionPassenger;

//确定支付
-(void)TicketBillId:(NSString *)newTicketBillId backTicketId:(NSString *)newBackTicketBillId  styGoBack:(NSString *)newStyGoBsack  perSonIdArray:(NSMutableArray *)newperSonIdArray ContactIdArray:(NSMutableArray *)newContactIdArray   payinfoCardInfoArray:(NSMutableArray *)newpayinfoCardInfoArray  validity:(NSString *)newValidity amount:(NSString *)newAmount;

// 历史查询
- (void)getOrderHistoryMsgstart:(NSString*)newMsgstart getOrderHistoryMsgdisplay:(NSString *)newmsgdisplay;

// 验证码
- (void)getApiPayverify:(NSString *)newApiPayverify OrderId:(NSString*)newOrderId;






//菜单模板读取
- (void)getApireadMenuModule:(NSString*)paycardkey appversion:(NSString*)appversion;

//菜单模板数量点击
- (void)getApireadMenutapCount:(NSString*)appmnuid agentno:(NSString*)agentno;

//商户读取代理商信息
- (void)getApiAgentInfo;

//代理商申请省
- (void)getApiAgentApplyWithProv;

//代理商申请市
- (void)getApiAgentApplyWithProv:(NSString *)prov;

//代理商申请区
- (void)getApiAgentApplyWithProv:(NSString *)prov city:(NSString *)city;

//代理商申请
- (void)getApiAgentApplyAddWith:(NSString *)custypeid name:(NSString *)name address:(NSString *)address prov:(NSString *)prov city:(NSString *)city town:(NSString *)town;

//代理商申请信息
- (void)getApiAgentApply;

//绑定代理商
- (void)getApiAgentInfoBind:(NSString *)agentNO;

//虚拟代理商
- (void)getApiAgentApplyInsertPartt;

//读取新的信息
- (void)getApiAppInfo;

/*我的银行卡*/
//读取用户银行卡列表
- (void)getApiAuthorKuaibkcardInfoLists;

//添加新的银行卡
- (void)getApiAuthorKuaibkcardInfoAdd:(NSString *)bkcardbankid bkcardbank:(NSString *)bkcardbank bkcardno:(NSString *)bkcardno bkcardbankman:(NSString *)bkcardbankman bkcardbankphone:(NSString *)bkcardbankphone bkcardyxmonth:(NSString *)bkcardyxmonth bkcardyxyear:(NSString *)bkcardyxyear bkcardcvv:(NSString *)bkcardcvv bkcardidcard:(NSString *)bkcardidcard bkcardcardtype:(NSString *)bkcardcardtype bkcardisdefault:(NSString *)bkcardisdefault bkcardisdefaultPayment:(NSString *)bkcardisdefaultPayment;

//修改银行卡
- (void)getApiAuthorKuaibkcardInfoEdit:(NSString *)bkcardid bkcardbankid:(NSString *)bkcardbankid bkcardbank:(NSString *)bkcardbank bkcardno:(NSString *)bkcardno bkcardbankman:(NSString *)bkcardbankman bkcardbankphone:(NSString *)bkcardbankphone bkcardyxmonth:(NSString *)bkcardyxmonth bkcardyxyear:(NSString *)bkcardyxyear bkcardcvv:(NSString *)bkcardcvv bkcardidcard:(NSString *)bkcardidcard bkcardcardtype:(NSString *)bkcardcardtype bkcardisdefault:(NSString *)bkcardisdefault bkcardisdefaultPayment:(NSString *)bkcardisdefaultPayment;

//移除银行卡
- (void)getApiAuthorKuaibkcardInfoDelete:(NSString *)bkcardid;

//绑定银行卡
- (void)getApiAuthorKuaibkcardInfoDefault:(NSString *)bkcardid bkcardisdefault:(NSString *)bkcardisdefault;

/*易宝手机充值*/
- (void)getApiYiBaoPhonePay:(NSString *)rechargeMoney payMoney:(NSString *)payMoney rechargePhone:(NSString *)rechargePhone  bankCardId:(NSString *)bankCardId bankId:(NSString *)bankId manCardId:(NSString *)manCardId payPhone:(NSString *)payPhone manName:(NSString *)manName expireYear:(NSString *)expireYear expireMonth:(NSString *)expireMonth cvv:(NSString *)cvv mobileProvince:(NSString *)mobileProvince paycardid:(NSString*)paycardid;

/*易宝信用卡转账*/
- (void)ApiTransferWithCreditCard:(NSString *)payMoney transferMoney:(NSString *)transferMoney receiveBankCardId:(NSString *)receiveBankCardId  receiveBankName:(NSString *)receiveBankName receivePhone:(NSString *)receivePhone receivePersonName:(NSString *)receivePersonName cardReaderId:(NSString *)cardReaderId sendBankCardId:(NSString *)sendBankCardId sendBankCode:(NSString *)sendBankCode personCardId:(NSString *)personCardId sendPhone:(NSString *)sendPhone sendPersonName:(NSString *)sendPersonName  expireYear:(NSString *)expireYear expireMonth:(NSString *)expireMonth cvv:(NSString *)cvv transferType:(NSString *)transferType arriveid:(NSString*)arriveid sendBankName:(NSString*)sendBankName payType:(NSString*)payType paycardid:(NSString*)paycardid;

/*易宝游戏充值*/
- (void)ApiGamePayWithCreditCard:(NSString *)gameId gameName:(NSString *)gameName area:(NSString *)area  server:(NSString *)server quantity:(NSString *)quantity price:(NSString *)price cost:(NSString *)cost userCount:(NSString *)userCount paycardid:(NSString *)paycardid bankCardId:(NSString *)bankCardId bankId:(NSString *)bankId manCardId:(NSString *)manCardId  payPhone:(NSString *)payPhone manName:(NSString *)manName expireYear:(NSString *)expireYear expireMonth:(NSString *)expireMonth cvv:(NSString *)cvv;

/*手机充值验证码*/
- (void)getApiYiBaoVerifyCode:(NSString *)orderId verifyCode:(NSString*)verifyCode;

/*易宝信用卡验证码*/
- (void)getApiPayWithVerifyCode:(NSString *)orderId verifyCode:(NSString*)verifyCode;

/*易宝游戏验证码*/
- (void)getApiGamePayWithVerifyCode:(NSString *)orderId verifyCode:(NSString*)verifyCode;

/*易宝商户收款*/
- (void)getApicouponPayReq:(NSString *)couponid couponmoney:(NSString *)couponmoney paycardid:(NSString *)paycardid bkcardbank:(NSString *)bkcardbank bkCardno:(NSString *)bkCardno bkcardman:(NSString *)bkcardman bkcardexpireMonth:(NSString *)bkcardexpireMonth bkcardmanidcard:(NSString *)bkcardmanidcard bankid:(NSString *)bankid bkcardexpireYear:(NSString *)bkcardexpireYear bkcardPhone:(NSString *)bkcardPhone bkcardcvv:(NSString *)bkcardcvv paytype:(NSString *)paytype;

/*易宝商户验证码*/
- (void)getApicouponPaySMSverify:(NSString *)SMSCode bkordernumber:(NSString *)bkordernumber bkntno:(NSString *)bkntno verifytoken:(NSString *)verifytoken;

//手续费计算
- (void)getApigetcreditCardMoneyPayfee:(NSString *)bankid money:(NSString *)money;

//信用卡还款请求
- (void)getApicreditCardMoneyRq:(NSString *)paytype paymoney:(NSString *)paymoney shoucardno:(NSString *)shoucardno shoucardmobile:(NSString *)shoucardmobile shoucardman:(NSString *)shoucardman shoucardbank:(NSString *)shoucardbank current:(NSString *)current paycardid:(NSString *)paycardid merReserved:(NSString *)merReserved bkcardbank:(NSString *)bkcardbank bkCardno:(NSString *)bkCardno bkcardman:(NSString *)bkcardman bkcardexpireMonth:(NSString *)bkcardexpireMonth bkcardmanidcard:(NSString *)bkcardmanidcard bankid:(NSString *)bankid bkcardexpireYear:(NSString *)bkcardexpireYear bkcardPhone:(NSString *)bkcardPhone bkcardcvv:(NSString *)bkcardcvv allmoney:(NSString *)allmoney feemoney:(NSString *)feemoney;

//信用卡还款短信验证码验证返回
- (void)getApicreditCardMoneySMSverify:(NSString *)SMSCode bkordernumber:(NSString *)bkordernumber bkntno:(NSString *)bkntno verifytoken:(NSString *)verifytoken;

//刷卡器刷卡管理
- (void)getApipayCardCheck:(NSString *)paycardkey bkcardno:(NSString *)bkcardno paytype:(NSString *)paytype  readmode:(NSString *)cardReadmode;

//易宝Q币充值
- (void)getApiqqrechargeReq:(NSString *)payMoney rechargemoney:(NSString *)rechargemoney RechargeQQ:(NSString *)RechargeQQ bkCardno:(NSString *)bkCardno bkcardman:(NSString *)bkcardman bkcardexpireMonth:(NSString *)bkcardexpireMonth bkcardmanidcard:(NSString *)bkcardmanidcard bankid:(NSString *)bankid bkcardexpireYear:(NSString *)bkcardexpireYear bkcardPhone:(NSString *)bkcardPhone bkcardcvv:(NSString *)bkcardcvv paytype:(NSString *)paytype paycardid:(NSString *)paycardid;

//易宝QQ币充值短信验证码验证返回
- (void)getApiqqrechargeSMSverify:(NSString *)SMSCode bkordernumber:(NSString *)bkordernumber bkntno:(NSString *)bkntno verifytoken:(NSString *)verifytoken;


/*话费是否可以充值*/
- (void)getApiCanRecharge:(NSString *)money phone:(NSString*)phone;

/*读取快捷支付默认信用卡号*/
- (void)getApiPaychannelInfo:(NSString *)bkcardid bkcardisdefault:(NSString*)bkcardisdefault;

/*汇通宝-商户收款（抵用券）*/
- (void)getApiExpresspayInfo:(NSString *)couponid couponmoney:(NSString*)couponmoney paycardid:(NSString*)paycardid;

/*汇通宝-商户收款（抵用券）交易状态显示*/
- (void)getApiExpresspayInfoToPay:(NSString *)bkordernumber;

/*酒店*/
//获取城市
- (void)getApiHotelGetCity:(NSString *)firstLetter cityName:(NSString *)cityName;

//获取商业区/行政区
- (void)getApiHotelGetDistrict:(NSString *)cityID func:(NSString *)func;

/*读取发工资的信息119*/
- (void)getApireadwagelists:(NSString *)querytype querywhere:(NSString *)querywhere bossauthorid:(NSString*)bossauthorid func:(NSString*)func Apiame:(NSString*)Apiname;









@end









