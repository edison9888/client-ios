

#ifndef Protocol_Define_h
#define Protocol_Define_h

//错误码定义
#define RSP_NO_ERROR 0
#define RSP_IS_NULL -1000
#define ACTION_IS_NULL -1001
#define RSP_TIMEOUT -1002
#define RSP_CANCEL -1003
#define RSP_HAS_EXIST -1004
#define RSP_XML_RETTYPE_FAILURE -1005
#define RSP_XML_RETCODE_FAILURE -1006
#define RSP_XML_RESULT_FAILURE -1007

//#define SERVER_URL @"http://14.18.207.56/mobilepay/sever/androidapi.php" //正式环境

//#define SERVER_URL  @"www.tfbpay.cn/mobilepay/sever/getapi.php"

//正式环境(新)
//#define SERVER_URL @"http://14.18.207.56/tfb_test/sever/androidapi.php" //测试环境

//#define SERVER_URL @"http://182.92.194.76/mobilepay/sever/getapi.php" //本地测试环境

//#define SERVER_URL @"http://14.18.207.56/tfb_test/sever/getapi.php" //Cow测试环境

/*短信测试通道*/
//#define SERVER_URL @"http://14.18.205.153/tfb_test/sever/getapi.php/"

//正式环境屏蔽这句话
#define TFB_LOCAL_ENVIROMENT   @"developer"

//#ifdef TFB_LOCAL_ENVIROMENT
//
//#define SERVER_URL @"http://182.92.194.76/mobilepay/sever/getapi.php"       //iphone新接口//酒店接口需要用

//#define SERVER_URL @"http://192.168.1.135/mobilepay/sever/androidapi.php"  //本地测试环境

////#define SERVER_URL @"http://192.168.1.135/mobilepay/sever/androidapi.php"  //本地测试环境
//
////#define SERVER_URL @"http://182.92.194.76/mobilepay/sever/getapi.php"       //iphone新接口
//
////#define SERVER_URL @"http://www.tfbpay.cn/mobilepay2/sever/getapi.php"//本地临时打包环境
//
////#define SERVER_URL @"http://www.tfbpay.cn/tfb_test/sever/getapi.php"     //测试环境

//#define SERVER_URL @"http://www.tfbpay.cn/mobilepay2/sever/getapi.php"     //本地临时打包环境

//#define SERVER_URL @"http://www.tfbpay.cn/tfb_test/sever/getapi.php"     //测试环境

/*本地模拟数据*/
//#define SERVER_URL @"http://192.168.0.128:8080/test/servlet/HelloWorldServlet"
//
//#else
//#define SERVER_URL  @"http://www.tfbpay.cn/mobilepay/sever/getapi.php"            //正式

#define SERVER_URL @"http://www.tfbpay.cn/tfb_test/sever/getapi.php"     //测试环境蔡玖兵

//#endif

#define ProtocolRequestNameLoc  27

#define ProtocolRequestCount  151

typedef enum
{
    NLProtocolRequestPost_Text = 0,
    NLProtocolRequestPost_Picture
}NLProtocolRequestPostType;

typedef enum
{
    NLProtocolRequest_getSmsCode = 0,
    NLProtocolRequest_authorReg,
    NLProtocolRequest_authorPwdModify,
    NLProtocolRequest_authorFeedbck,
    NLProtocolRequest_checkAppVersion,
    NLProtocolRequest_readAuthorInfo,
    NLProtocolRequest_uploadAuthorPic,
    NLProtocolRequest_modifyAuthorInfo,
    NLProtocolRequest_checkAuthorLogin,
    NLProtocolRequest_getSmsCodeInfo,
    NLProtocolRequest_forgetPwdModify,
    NLProtocolRequest_readHelpList,
    NLProtocolRequest_readMyAccount,
    NLProtocolRequest_readAccglist,
    NLProtocolRequest_readAccglistdetail,
    NLProtocolRequest_getSmsVerifyCode,
    NLProtocolRequest_readCreditCardfee,
    NLProtocolRequest_insertcreditCardMoney,
    NLProtocolRequest_readCreditCardglist,
    NLProtocolRequest_creditCardMoneyRq,
    NLProtocolRequest_readTransferMoneyfee,
    NLProtocolRequest_insertTransferMoney,
    NLProtocolRequest_readTransferMoneyglist,
    NLProtocolRequest_transferMoneyRq,
    NLProtocolRequest_readRepayMoneyfee,
    NLProtocolRequest_insertRepayMoney,
    NLProtocolRequest_readRepayMoneyglist,
    NLProtocolRequest_rechargeglist,
    NLProtocolRequest_rechargeReq,
    NLProtocolRequest_rechargePay,
    NLProtocolRequest_couponSale,
    NLProtocolRequest_couponRebuylist,
    NLProtocolRequest_couponRebuy,
    NLProtocolRequest_readBankList,
    NLProtocolRequest_readIndexAdList,
    NLProtocolRequest_activePayCard,
    NLProtocolRequest_readQueryCardMoney,
    NLProtocolRequest_getTransferPayfee,
    NLProtocolRequest_getRepayMoneyPayfee,
    NLProtocolRequest_RepayMoneyRq,
    NLProtocolRequest_readcouponinfo,
    NLProtocolRequest_couponSalePay,
    NLProtocolRequest_couponSalelist,
    NLProtocolRequest_payCardCheck,
    NLProtocolRequest_readAppruleList,
    NLProtocolRequest_readMenuModule,
    NLProtocolRequest_kuaiState,
    NLProtocolRequest_readKuaiDicmpList,
    NLProtocolRequest_chaxunKuaiDiNo,
    NLProtocolRequest_readOrderList,
    NLProtocolRequest_orderPayReq,
    NLProtocolRequest_orderPayFeedback,
    NLProtocolRequest_orderPayBankCardStar,
    NLProtocolRequest_readAuBkCardInfo,
    NLProtocolRequest_modifyAuBkCardInfo,
    NLProtocolRequest_readshoucardList,
    NLProtocolRequest_getSupTransferPayfee,
    NLProtocolRequest_SuptransferMoneyRq,
    NLProtocolRequest_insertSupTransferMoney,
    NLProtocolRequest_readSupTransferMoneyglist,
    NLProtocolRequest_readRechaMoneyinfo,
    NLProtocolRequest_RechaMoneyRq,
    NLProtocolRequest_checkRechaMoneyStatus,
    NLProtocolRequest_readMobileRechangelist,
    NLProtocolRequest_readRechaQQMoneyinfo,
    NLProtocolRequest_RechaQQMoneyRq,
    NLProtocolRequest_checkRechaQQMoneyStatus,
    NLProtocolRequest_readRechangeQQlist,
    NLProtocolRequest_readOrderProinfo,
    NLProtocolRequest_readShaddressinfo,
    NLProtocolRequest_shaddressAdd,
    NLProtocolRequest_shaddressDelete,
    NLProtocolRequest_payOrderRq,
    NLProtocolRequest_orderPayrqStatus,
    NLProtocolRequest_readSKQOrderlist,
    
    
    /**** 水电煤 ****/
    /*获取服务列表*/
    NLProtocolRequest_waterEle_getProductList,
    /*生成订单*/
    NLProtocolRequest_waterEle_createOrder,
    /*提交订单*/
    NLProtocolRequest_waterEle_submitOrder,
    /*支付完订单反馈*/
    NLProtocolRequest_waterEle_completeOrder,
    /*查询历史订单记录*/
    NLProtocolRequest_waterEle_getOrderHistory,
    //80
    /**** 游戏充值 ****/
    /*获取游戏列表*/
    NLProtocolRequest_gameCharge_getGameList,
    /*获取平台*/
    NLProtocolRequest_gameCharge_getplatformList,
    /*游戏小类列表*/
    NLProtocolRequest_gameCharge_getChildGame,
    /*获取某一游戏详细信息*/
    NLProtocolRequest_gameCharge_getGameDetail,
    /*生成订单*/
    NLProtocolRequest_gameCharge_createOrder,
    /*支付完订单*/
    NLProtocolRequest_gameCharge_completeOrder,
    /*查询历史订单*/
    NLProtocolRequest_gameCharge_getOrderHistory,
    
    /**** 新注册登陆 ****/
    /*最新的注册接口*/
    NLProtocolRequest_ApiAuthorInfoV2,
    /*判断是否注册的接口*/
    NLProtocolRequest_ApiAuthorInfoV2IsOnMain,
    /*用户登录*/
    NLProtocolRequest_ApiAuthorInfoV2Gesture,
    /*用户手势登录*/
    NLProtocolRequest_ApiAuthorInfoV2GestureToHander,
    /*用户密码修改*/
    NLProtocolRequest_ApiAuthorInfoPasswordToChage,
    /*用户login密码修改 */

    NLProtocolRequest_ApiAuthorInfoV2ChangeLoginPassword,
    /*获取所有密保问题*/
    NLProtocolRequest_ApiSafeGuardIsOn,
    /*设置密保问题*/
    NLProtocolRequest_ApiSafeGuardSetting,
    /*获取已经设置过的密保问题*/
    NLProtocolRequest_ApiSafeGuardUser,
    /*用于注销后判断是否设置密保的参数名*/
    NLProtocolRequest_ApiSafeGuardLoginUp,
    NLProtocolRequest_ApiAuthorInfoV2modifyAuthorInfo,
    
    /**** 飞机票  ****/
    /*机票城市查询*/
    NLProtocolRequest_ApiAirticket,
    /*航班查询*/
    NLProtocolRequest_ApigetAirline,/*100*/
    /*航班详情*/
    NLProtocolRequest_GetAirlineDetail,/**/
    /*添加登机人*/
    NLProtocolRequest_SavePassenger,/**/
    /*读取登机人*/
    NLProtocolRequest_getPassenger,
    /*删除登机人*/
    NLProtocolRequest_deletePassenger,
    /*生成订单号*/
    NLProtocolRequest_createOrder,
    /*查询订单*/
    NLProtocolRequest_OrderHistory,
    /*验证码*/
    NLProtocolRequest_payWithCreditCard,
    
    /**** 首页菜单  ****/
    /*读取菜单模板*/
    NLProtocolRequest_ApireadMenuModule,
    /*商户点击功能菜单累计使用次数*/
    NLProtocolRequest_ApiauthorMenuCount,
    
    /**** 代理商  ****/
    
    //代理商读取基本信息
    NLProtocolRequest_readagentinfo,
    //代理商读取读取补货记录
    NLProtocolRequest_readagentorder,
    //代理商补货发货状态提交
    NLProtocolRequest_agentorderstaterq,
    //代理商补货请求银行交易码
    NLProtocolRequest_payagentOrderRq,
    //代理商银联支付成功反馈
    NLProtocolRequest_agentorderPayrqStatus,
    //代理商读取历史收益记录
    NLProtocolRequest_payagentfenrunlist,
    //绑定代理商
    NLProtocolRequest_BindingAgentId,
    
    //代理商地区省
    NLProtocolRequest_ApiAgentApplyProv,
    //代理商地区市
    NLProtocolRequest_ApiAgentApplyCity,
    //代理商地区区
    NLProtocolRequest_ApiAgentApplyTown,
    //代理商申请信息
    NLProtocolRequest_ApiAgentApplyBasinfo,
    //商户读取代理商信息
    NLProtocolRequest_ApiAgentInfo,
    //代理商申请
    NLProtocolRequest_ApiAgentApplyAdd,
    //绑定代理商
    NLProtocolRequest_ApiAgentInfoBind,
    //虚拟代理商
    NLProtocolRequest_ApiAgentApplyInsertPartt,
    //读取新的信息
    NLProtocolRequest_ApiAppInfo,
    
    /*我的银行卡*/
    //读取用户银行卡列表
    NLProtocolRequest_ApiAuthorKuaibkcardInfoLists,
    //添加新的银行卡
    NLProtocolRequest_ApiAuthorKuaibkcardInfoAdd,
    //修改银行卡
    NLProtocolRequest_ApiAuthorKuaibkcardInfoEdit,
    //移除银行卡
    NLProtocolRequest_ApiAuthorKuaibkcardInfoDelete,
    //绑定银行卡
    NLProtocolRequest_ApiAuthorKuaibkcardInfoDefault,
    
    /**** 易宝  ****/
    /*易宝接口*/
    NLProtocolRequest_ApiYiBaoPhonePay,
    /*易宝验证码*/
    NLProtocolRequest_ApiYiBaoVerifyCode,
    /*易宝信用卡转账*/
    NLProtocolRequest_ApiTransferWithCreditCard,
    /*易宝信用卡验证码*/
    NLProtocolRequest_ApiPayWithVerifyCode,
    /*易宝游戏充值*/
    NLProtocolRequest_ApiGamePayWithCreditCard,
    /*易宝游戏验证码*/
    NLProtocolRequest_ApiGamePayWithVerifyCode,
    /*易宝商户收款*/
    NLProtocolRequest_ApicouponPayReq,
    /*易宝商户验证码*/
    NLProtocolRequest_ApicouponPaySMSverify,
    //手续费计算
    NLProtocolRequest_ApigetcreditCardMoneyPayfee,
    //信用卡还款请求
    NLProtocolRequest_ApicreditCardMoneyRq,
    //信用卡还款短信验证码验证返回
    NLProtocolRequest_ApicreditCardMoneySMSverify,
    //刷卡器刷卡管理
    NLProtocolRequest_ApipayCardCheck,
    //易宝Q币充值
    NLProtocolRequest_ApiqqrechargeReq,
    //易宝QQ币充值短信验证码验证返回
    NLProtocolRequest_ApiqqrechargeSMSverify,
    
    /*话费是否可以充值*/
    NLProtocolRequest_ApiCanRecharge,
    /*读取快捷支付默认信用卡 */
    NLProtocolRequest_ApiPaychannelInfo,
    /*汇通宝-商户收款（抵用券）*/
    NLProtocolRequest_ApiExpresspayInfo,
    /*汇通宝-商户收款（抵用券）交易状态显示*/
    NLProtocolRequest_ApiExpresspayInfoToPay,
    
    /*酒店*/
    //获取城市
    NLProtocolRequest_ApiHotelGetCity,
    
    //获取商业区/行政区
    NLProtocolRequest_ApiHotelGetDistrict,
    
    /*读取发工资接口信息*/
    NLProtocolRequest_Apireadwagelists
    
} NLProtocolRequestType;

#define Notify_finished                   @"NLProtocolRequest_finished_"
#define Notify_getSmsCode                 @"getSmsCode"
#define Notify_authorReg                  @"authorReg"
#define Notify_authorPwdModify            @"authorPwdModify"
#define Notify_authorFeedbck              @"authorFeedbck"
#define Notify_checkAppVersion            @"checkAppVersion"
#define Notify_readAuthorInfo             @"readAuthorInfo"
#define Notify_uploadAuthorPic            @"uploadAuthorPic"
#define Notify_modifyAuthorInfo           @"modifyAuthorInfo"
#define Notify_checkAuthorLogin           @"checkAuthorLogin"
#define Notify_getSmsCodeInfo             @"getSmsCodeInfo"
#define Notify_forgetPwdModify            @"forgetPwdModify"
#define Notify_readHelpList               @"readHelpList"
#define Notify_readMyAccount              @"readMyAccount"
#define Notify_readAccglist               @"readAccglist"
#define Notify_readAccglistdetail         @"readAccglistdetail"
#define Notify_getSmsVerifyCode           @"getSmsVerifyCode"
#define Notify_readCreditCardfee          @"readCreditCardfee"
#define Notify_insertcreditCardMoney      @"insertcreditCardMoney"
#define Notify_readCreditCardglist        @"readCreditCardglist"
#define Notify_creditCardMoneyRq          @"creditCardMoneyRq"
#define Notify_readTransferMoneyfee       @"readTransferMoneyfee"
#define Notify_insertTransferMoney        @"insertTransferMoney"
#define Notify_readTransferMoneyglist     @"readTransferMoneyglist"
#define Notify_transferMoneyRq            @"transferMoneyRq"
#define Notify_getTransferPayfee          @"getTransferPayfee"
#define Notify_readRepayMoneyfee          @"readRepayMoneyfee"
#define Notify_insertRepayMoney           @"insertRepayMoney"
#define Notify_readRepayMoneyglist        @"readRepayMoneyglist"
#define Notify_rechargeglist              @"rechargeglist"
#define Notify_rechargeReq                @"rechargeReq"
#define Notify_rechargePay                @"rechargePay"
#define Notify_couponSale                 @"couponSale"
#define Notify_couponRebuylist            @"couponRebuylist"
#define Notify_couponRebuy                @"couponRebuy"
#define Notify_readBankList               @"readBankList"
#define Notify_readIndexAdList            @"readIndexAdList"
#define Notify_activePayCard              @"activePayCard"
#define Notify_readQueryCardMoney         @"readQueryCardMoney"
#define Notify_getRepayMoneyPayfee        @"getRepayMoneyPayfee"
#define Notify_RepayMoneyRq               @"RepayMoneyRq"
#define Notify_readcouponinfo             @"readcouponinfo"
#define Notify_couponSalePay              @"couponSalePay"
#define Notify_couponSalelist             @"couponSalelist"
#define Notify_payCardCheck               @"payCardCheck"
#define Notify_readAppruleList            @"readAppruleList"
#define Notify_readMenuModule             @"readMenuModule"
#define Notify_kuaiState                  @"kuaiState"
#define Notify_readKuaiDicmpList          @"readKuaiDicmpList"
#define Notify_chaxunKuaiDiNo             @"chaxunKuaiDiNo"
#define Notify_readOrderList              @"readOrderList"
#define Notify_orderPayReq                @"orderPayReq"
#define Notify_orderPayFeedback           @"orderPayFeedback"
#define Notify_orderPayBankCardStar       @"orderPayBankCardStar"
#define Notify_readAuBkCardInfo           @"readAuBkCardInfo"
#define Notify_modifyAuBkCardInfo         @"modifyAuBkCardInfo"
#define Notify_readshoucardList           @"readshoucardList"
#define Notify_getSupTransferPayfee       @"getSupTransferPayfee"
#define Notify_SuptransferMoneyRq         @"SuptransferMoneyRq"
#define Notify_insertSupTransferMoney     @"insertSupTransferMoney"
#define Notify_readSupTransferMoneyglist  @"readSupTransferMoneyglist"

/*读取 充值支付选项*/
#define Notify_readRechaMoneyinfo        @"readRechaMoneyinfo"
/*话费充值 成功反馈 历史*/
#define Notify_RechaMoneyRq              @"RechaMoneyRq"
#define Notify_checkRechaMoneyStatus     @"checkRechaMoneyStatus"
#define Notify_readMobileRechangelist     @"readMobileRechangelist"

/*读取qq 充值选项*/
#define Notify_readRechaQQMoneyinfo      @"readRechaQQMoneyinfo"

/*qq充值 成功反馈  历史*/
#define Notify_RechaQQMoneyRq            @"RechaQQMoneyRq"

#define Notify_checkRechaQQMoneyStatus   @"checkRechaQQMoneyStatus"

#define Notify_readRechangeQQlist        @"readRechangeQQlist"

/*内部购买刷卡器-读取产品管理信息*/
#define Notify_readOrderProinfo          @"readOrderProinfo"

/*内部购买刷卡器-读取收货地址*/
#define Notify_readShaddressinfo         @"readShaddressinfo"

/*内部购买刷卡器-新增收货地址*/
#define Notify_shaddressAdd              @"shaddressAdd"

/*内部购买刷卡器-删除收货地址*/
#define Notify_shaddressDelete           @"shaddressDelete"

/*内部购买刷卡器-支付请求银联交易码*/
#define Notify_payOrderRq                @"payOrderRq"

/*内部购买刷卡器-银联支付成功反馈*/
#define Notify_orderPayrqStatus          @"orderPayrqStatus"

/*内部购买刷卡器-读取购买历史记录*/
#define Notify_readSKQOrderlist          @"readSKQOrderlist"

/*水电煤*/
#define Notify_waterEle_getProductList             @"WaterEle_getProductList"
/*生成订单*/
#define Notify_waterEle_createOrder                @"WaterEle_createOrder"
/*提交订单*/
#define Notify_waterEle_submitOrder                @"WaterEle_submitOrder"
/*支付完订单反馈*/
#define Notify_waterEle_completeOrder              @"WaterEle_completeOrder"
/*查询历史订单记录*/
#define Notify_waterEle_getOrderHistory            @"WaterEle_getOrderHistory"

/**** 游戏充值 ****/
//获取游戏列表*/
#define Notify_gameCharge_getGameList              @"gameCharge_getGameList"
/*获取平台*/
#define Notify_gameCharge_getplatformList          @"gameCharge_getplatformList"
/*游戏小类列表*/
#define Notify_gameCharge_getChildGame             @"gameCharge_getChildGame"
/*获取某一游戏详细信息*/
#define Notify_gameCharge_getGameDetail            @"gameCharge_getGameDetail"
/*生成订单*/
#define Notify_gameCharge_createOrder              @"gameCharge_createOrder"
/*支付完订单*/
#define Notify_gameCharge_completeOrder            @"gameCharge_completeOrder"
/*查询历史订单*/
#define Notify_gameCharge_getOrderHistory          @"gameCharge_getOrderHistory"

//代理商读取基本信息
#define Notify_readagentinfo                @"agent_readagentinfo"
//代理商读取读取补货记录
#define Notify_readagentorder               @"agent_readagentorder"
//代理商补货发货状态提交
#define Notify_agentorderstaterq            @"agent_agentorderstaterq"
//代理商补货请求银行交易码
#define Notify_payagentOrderRq              @"agent_payagentOrderRq"
//代理商银联支付成功反馈
#define Notify_agentorderPayrqStatus        @"agent_agentorderPayrqStatus"
//代理商读取历史收益记录
#define Notify_payagentfenrunlist           @"agent_payagentfenrunlist"
//绑定代理商
#define Notify_BindingAgentId           @"BindingAgentId"

/*客户列表(本地测试)*/
#define Notify_getAgentClientList        @"getAgentClientList"

/*最新的注册接口*/
#define Notify_ApiAuthorInfoV2           @"ApiAuthorInfoV2"

/*判断用户是否已注册过*/
#define Notify_ApiAuthorInfoV2IsOnMain           @"ApiAuthorInfoV2IsOnMain"

/*用户手机登录*/
#define Notify_ApiAuthorInfoV2Gesture    @"ApiAuthorInfoV2Gesture"

/*手势密码登录*/
#define Notify_ApiAuthorInfoV2GestureToHander    @"ApiAuthorInfoV2GestureToHander"

/*用户密码修改*/
#define Notify_ApiAuthorInfoPasswordToChage    @"ApiAuthorInfoPasswordToChage"

/*用户密码login修改*/
#define Notify_ApiAuthorInfoV2ChangeLoginPassword    @"ApiAuthorInfoV2ChangeLoginPassword"

/*获取密保问题*/
#define Notify_ApiSafeGuardIsOn    @"ApiSafeGuardIsOn"

/*设置密保问题()*/
#define Notify_ApiSafeGuardSetting    @"ApiSafeGuardSetting"

/*获取已经设置的密保问题*/
#define Notify_ApiSafeGuardUser    @"ApiSafeGuardUser"

/*注销后再获取密保的通知*/
#define Notify_ApiSafeGuardLoginUp    @"ApiSafeGuardLoginUp"

/*修改信息*/
#define Notify_ApiAuthorInfoV2modifyAuthorInfo    @"ApiAuthorInfoV2modifyAuthorInfo"

/*机票城市查询======================================================================*/
#define Notify_ApiAirticket   @"ApiAirticket"

/*机票航班查询*/
#define Notify_ApigetAirline   @"ApigetAirline"

/*航班详情*/
#define Notify_GetAirlineDetail   @"getAirlineDetail"

/*添加乘机人*/
#define Notify_SavePassenger   @"savePassenger"

/*读取乘机人信息*/
#define Notify_GetPassenger   @"getPassenger"

/*删除乘机人信息*/
#define Notify_deletePassenger   @"deletePassenger"

/*生成订单号*/
#define Notify_createOrder   @"createOrder"

/*历史记录*/
#define Notify_getOrderHistory   @"getOrderHistory"

/*输入验证码*/
#define Notify_getpayWithCreditCard   @"payWithCreditCard"




//APP功能模块菜单读取
#define Notify_ApireadMenuModule   @"Notify_ApireadMenuModule"

//商户点击功能菜单累计使用次数
#define Notify_ApiauthorMenuCount   @"ApiauthorMenuCount"

//代理商申请省
#define Notify_ApiAgentApplyProv        @"ApiAgentApplyProv"

//代理商申请市
#define Notify_ApiAgentApplyCity       @"ApiAgentApplyCity"

//代理商申请区
#define Notify_ApiAgentApplyTown        @"ApiAgentApplyTown"

//代理商申请信息
#define Notify_ApiAgentApplyBasinfo       @"ApiAgentApplyBasinfo"

//代理商申请
#define Notify_ApiAgentApplyAdd       @"ApiAgentApplyAdd"

//商户读取代理商信息
#define  Notify_ApiAgentInfo        @"ApiAgentInfo"

//绑定代理商
#define  Notify_ApiAgentInfoBind    @"ApiAgentInfoBind"

//虚拟代理商
#define  Notify_ApiAgentApplyInsertPartt     @"ApiAgentApplyInsertPartt"

//读取新的信息
#define  Notify_ApiAppInfo     @"Notify_ApiAppInfo"

//读取用户银行卡列表
#define  Notify_ApiAuthorKuaibkcardInfoLists     @"ApiAuthorKuaibkcardInfoLists"

//添加新的银行卡
#define  Notify_ApiAuthorKuaibkcardInfoAdd     @"ApiAuthorKuaibkcardInfoAdd"

//修改银行卡
#define  Notify_ApiAuthorKuaibkcardInfoEdit     @"ApiAuthorKuaibkcardInfoEdit"

//移除银行卡
#define  Notify_ApiAuthorKuaibkcardInfoDelete     @"ApiAuthorKuaibkcardInfoDelete"

//绑定银行卡
#define  Notify_ApiAuthorKuaibkcardInfoDefault     @"ApiAuthorKuaibkcardInfoDefault"

/*易宝充值手机接口*/
#define  Notify_ApiYiBaoPhonePay     @"ApiYiBaoPhonePay"

/*易宝充值验证码*/
#define  Notify_ApiYiBaoVerifyCode     @"ApiYiBaoVerifyCode"

/*易宝信用卡转账*/
#define  Notify_ApiTransferWithCreditCard     @"ApiTransferWithCreditCard"

/*易宝转账付款验证码*/
#define  Notify_ApiPayWithVerifyCode     @"ApiPayWithVerifyCode"

/*易宝游戏充值*/
#define  Notify_ApiGamePayWithCreditCard     @"ApiGamePayWithCreditCard"

/*易宝游戏充值验证码*/
#define  Notify_ApiGamePayWithVerifyCode     @"ApiGamePayWithVerifyCode"

/*易宝商户收款*/
#define  Notify_ApicouponPayReq     @"ApicouponPayReq"

/*易宝商户验证码*/
#define  Notify_ApicouponPaySMSverify     @"ApicouponPaySMSverify"

//手续费计算
#define  Notify_ApigetcreditCardMoneyPayfee    @"ApigetcreditCardMoneyPayfee"

//信用卡还款请求
#define  Notify_ApicreditCardMoneyRq    @"ApicreditCardMoneyRq"

//信用卡还款短信验证码验证返回
#define  Notify_ApicreditCardMoneySMSverify    @"ApicreditCardMoneySMSverify"

//刷卡器刷卡管理
#define  Notify_ApipayCardCheck     @"ApipayCardCheck"

//易宝Q币充值
#define  Notify_ApiqqrechargeReq    @"ApiqqrechargeReq"

//易宝QQ币充值短信验证码验证返回
#define  Notify_ApiqqrechargeSMSverify    @"ApiqqrechargeSMSverify"

/*话费是否可以充值*/
#define  Notify_ApiCanRecharge     @"ApiCanRecharge"

/*读取快捷支付默认信用卡*/
#define  Notify_ApiPaychannelInfo      @"ApiPaychannelInfo"

/*汇通宝-商户收款（抵用券）*/
#define Notify_ApiExpresspayInfo      @"ApiExpresspayInfo"

/*汇通宝-商户收款（抵用券）交易状态显示*/
#define Notify_ApiExpresspayInfoToPay      @"ApiExpresspayInfoToPay"

/*酒店*/
//获取城市
#define Notify_ApiHotelGetCity      @"ApiHotelGetCity"

//获取商业区/行政区
#define Notify_ApiHotelGetDistrict      @"ApiHotelGetDistrict"

/*读取发工资接口信息*/
#define Notify_Apireadwagelists      @"readwagelists"

/*短信收款*/
#define Notify_ApiSMSReceiptInfo      @"ApiSMSReceiptInfo"


#endif

















