//
//  TFDataConfig.h
//  TongFubao
//
//  Created by ec on 14-5-5.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

//    HiraKakuProN-W3
//    HiraMinProN-W3

#ifndef TongFubao_TFDataConfig_h
#define TongFubao_TFDataConfig_h

#ifdef DEBUG
#define DLog(...) NSLog(__VA_ARGS__)
#else
#define DLog(...) /* */
#endif

#define RGBACOLOR(r,g,b,a)      [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:a]

#define SACOLOR(s,a)            [UIColor colorWithRed:(s) / 255.0 green:(s) / 255.0 blue:(s) / 255.0 alpha:a]

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 60000
#define LabelAlignmentCenter NSTextAlignmentCenter
#else
#define LabelAlignmentCenter UITextAlignmentCenter
#endif

#define TFB_FONT   @"HiraKakuProN-W3"

#define SELECT_CITY_FLAG @"selectCityflag"

//代理商查询列表Cell 字段
#define KEY_AGENT_SEARCH_SEX         @"sex"
#define KEY_AGENT_SEARCH_NAME        @"name"
#define KEY_AGENT_SEARCH_TIME        @"time"
#define KEY_AGENT_SEARCH_MONEY       @"money"

//刷卡器购买地址
#define KEY_SKQPAY_AddressPhone      @"shphone"
#define KEY_SKQPAY_AddressName       @"shman"
#define KEY_SKQPAY_AllAddress        @"shaddress"//详细地址

#define KEY_SKQPAY_ProvinceStr       @"ProvinceStr"
#define KEY_SKQPAY_CityStr           @"CityStr"
#define KEY_SKQPAY_AreaStr           @"AreaStr"
#define KEY_SKQPAY_PatientiaAddressStr      @"PatientiaAddressStr" //默认地址
#define KEY_SKQPAY_ZoneStr           @"ZoneStr" //默认地址

/*发工资的清单*/
#define PAY_PEOPLE_NAME              @"staname"  /*发工资员工名*/
#define PAY_PEOPLE_MONEY             @"wagemoney"/*工资*/
#define PAY_PEOPLE_PHONE             @"mobile"   /*电话号码*/

/*版本控制*/
#define UP_DATA_APPSTRUPDATA         @"updataArray"

/*存储密码输入次数*/
#define KEY_RECORD_GESTURE_NUM       @"record_gesture_num"

/*判断手势密码是否跳过*/
#define KEY_GESTURE_HAVEGESTURE       @"key_gesture_havehesture"

/*对应行用卡的mnuno字段 用于交易类型*/
#define BANK_PAYTYPE_CHECK       @"bank_paytype_check"

//代理商刷卡器订单列表 字段
#define KEY_AGENT_ORDER_TIME         @"time"
#define KEY_AGENT_ORDER_NUM          @"num"
#define KEY_AGENT_ORDER_SENDSTATE    @"sendstate"
#define KEY_AGENT_ORDER_RECEIVESTATE @"receivestate"
#define KEY_AGENT_ORDER_ID           @"productId"

//水电煤相关
#define LOCAL_CITY_DATA              @"localCityData"
#define LOCAL_CITY_HEAD_DATA         @"localCityHeadData"
#define LOCAL_CITY_SELECT_DATA       @"localCitySelectData"

/*游戏相关*/
#define LOCAL_GAME_DATA              @"localGameData"
#define LOCAL_GAME_HEAD_DATA         @"localGameHeadData"

/*飞机城市查询*/
#define LOCAL_Plane_DATA             @"localplaneData"
#define LOCAL_Plane_HEAD_DATA        @"localplaneHeadData"

#define RECORD_COM_FLAG              @"clickComflag"

/*数据库实体名*/
#define ENTITY_AGENT     @"Agent"
#define ENTITY_ADRESS    @"Adress"

/*主页的数据实例*/
#define MAIN_MNUTYPEID   @"mnutypeid"     /*功能分类id*/
#define MAIN_MNUANME     @"mnuname"       /*功能名*/
#define MAIN_MNUTYPENAME @"mnutypename"   /*功能分类名*/
#define MAIN_MNUISCONST  @"mnuisconst"    /*固定功能图标*/
#define MAIN_MNUID       @"mnuid"         /*固定id*/
#define MAIN_POINTNUM    @"pointnum"      /*使用次数*/
#define MAIN_MNUNO       @"mnuno"         /*编号*/
#define MAIN_MNUORDER    @"mnuorder"      /*排序*/
#define MAIN_DATA        @"maindata"      /*主界面功能图标*/
#define MAIN_MOREVIEW    @"moreviewdata"  /*功能列表功能图标*/
#define MAIN_COUNVWTDATA @"countViewdata" /*功能列表位数次数*/

/*历史记录类型*/
typedef enum
{
    MobileChargeType,
    QCoinChargeType,
    buySKQType,
    WaterEleType,
    GameType,
    payPeopleMoney,
}ChargeHistoryType;

/*超时限制*/
typedef enum
{
    NLReGetBtnState_Disable = 0,
    NLReGetBtnState_Enable,
    NLReGetBtnState_EnableTitle,
    NLReGetBtnState_DisableTitle
} NLReGetBtnState;



#endif
