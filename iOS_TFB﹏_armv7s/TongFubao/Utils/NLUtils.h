//
//  NLUtils.h
//  TongFubao
//
//  Created by 〝Cow﹏. on 14-8-2.
//  Copyright (c) 2014年〝Cow﹏.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import "PinYin4Objc.h"

#define IPHONE5_HEIGHT              568
#define IPHONE4_HEIGHT              480
#define BATTERY_HEIGHT              20
#define NAVBAR_HEIGHT               44

@interface NLUtils : NSObject

/*跳转及是否控制点击*/
+(BOOL)isUserRegister;
+(void)cleanLogonInfo;
+(void)setPaypasswd:(NSString*)paypasswd;
+(void)presentModalViewController:(UIViewController*)oldViewController
                newViewController:(UIViewController*)newViewController;
+(void)enableSliderViewController:(BOOL)enable;
+(void)sliderSetRightController:(UIViewController *)rightViewCtr;
+(void)sliderSetleftController:(UIViewController *)left;
+(void)popToTheLogonVCFromMain:(UINavigationController*)nav mobile:(NSString*)mobile;
+(void)popToTheLogonVCFromMore:(UINavigationController*)nav;
+(void)popToTheMoreVC:(UINavigationController*)nav;

/*存储基本信息--msgheard等*/
+(NLUtils *)updataManager;
+(NSString*)getForceUpdate;
+(NSString*)get_appnewversion;
+(NSString*)get_req_time;
+(NSString*)get_req_token;
+(NSString*)get_au_token;
+(NSString*)get_req_bkenv;
+(NSString*)getIspaypwd;
+(NSString*)createUUID;
+(NSString*)getAuthorid;
+(NSString*)getAgentid;
/*引导页面的值*/
+(NSString*)getleader;

/*bossauthorid*/
+(NSString*)getbossauthorid;
+(NSString*)getRegisterMobile;
+(NSString*)getRememberAccount;
+(NSString*)getProtocolRequestName:(NSString*)name;
+(NSString*)getNameForRequest:(NSString*)string;

+(void)setLogonDate;
+(void)set_req_token:(NSString*)req_token;
+(void)set_appnewversion:(NSString*)appnewcontent;
+(void)set_au_token:(NSString*)au_token;
+(void)set_req_bkenv:(NSString*)req_bkenv;
+(void)setIspaypwd:(NSString*)ispaypwd;
+(void)setLogonPassword:(NSString*)password;
+(void)setForceUpdate:(NSString*)force;
+(void)setAuthorid:(NSString*)authorid;
+(void)setAgentid:(NSString*)agentid;
/*判断是否进入引导页面*/
+(void)setleaderbool:(NSString*)leader;

/*bossauthorid*/
+(void)setbossauthorid:(NSString*)bossauthorid;
+(void)setRememberAccount:(NSString*)mobile;
+(void)setRegisterMobile:(NSString*)mobile;

/*wagelistid*/
+ (NSString *)getgWagelistid;
+ (void)setWagelistid:(NSString*)Wagelistid;

/*havegesture*/
+ (NSString *)getGesturepasswd;
+ (void)setGesturepasswd:(NSString*)gesturepasswd;

/*信息的驗證*/
+(float)rand1:(int)max;
+(BOOL)checkBankCard:(NSString*)bank;
+(BOOL)checkIdentity:(NSString*)identity;
+(BOOL)checkMobilePhone:(NSString*)mobilePhone;
+(BOOL)checkInterNum:(NSString*)num;
+(BOOL)checkName:(NSString*)name;
+(BOOL)checkPassword:(NSString*)password;
+(BOOL)checkEmail:(NSString*)email;
+(void)popToLogonVCByHTTPError:(UIViewController*)currentVC  feedOrLeft:(int)feedOrLeft;

/*relateAgent  Agenttypeid*/
+ (void)setRelateAgent:(NSString *)relateAgent;

+ (NSString *)getRelateAgent;

+ (NSString *)getAgenttypeid;

+ (void)setAgenttypeid:(NSString *)Agenttypeid;

/*
 Cow﹏.
 */

/*iphone类型及适配*/
+(NSString *) simplePlatformString;

+(NSString *)formatCardNumber:(NSString *)cardNumber;

+(BOOL)isIOS7;

+(BOOL)isIphone5;

+(BOOL)isiPad;

/*屏幕高度*/
+(int)getDeviceHeight;

/*获取控制器高度*/
+(CGFloat)getCtrHeight;

/*弹出alert提示*/
+(void)showAlertView:(NSString*)title
             message:(NSString*)message
            delegate:(id<UIAlertViewDelegate>)delegate
                 tag:(int)tag
           cancelBtn:(NSString*)cancel
               other:(NSString *)other, ...;

/*直接文字弹框*/
+ (void)alertWithTitle:(NSString*)title;

/*标题、文字弹框*/
+ (void)alertWithTitle:(NSString*)title andMSG:(NSString*)msg;

/*标题、文字、标签弹框*/
+ (void)alertWithTitle:(NSString*)title andMSG:(NSString*)msg delegate:(id)sender andTag:(NSInteger)tag;

/*标题、文字、代理对象、标签弹框*/
+ (void)alertWithTitle:(NSString*)title textFContent:(NSString*)text delegate:(id)sender andTag:(NSInteger)tag;

/*菊花显示*/
+ (void)addLoadingViewTo:(UIView*)targetV withFrame:(CGRect)frame andText:(NSString*)text;

/*拨打电话前的弹框*/
+ (void)alertWithMsg:(NSString*)msg delegate:(id)sender andTag:(NSInteger)tag;

/*撥打電話*/
+(void)callTel:(NSString*)tel;

/*發信息和默認內容的封裝*/
+(bool)sendSms:(NSString*)content telephone:(NSArray*)tel controller:(UIViewController*)controller delegate:(id<MFMessageComposeViewControllerDelegate>)delegate;

/* nav bar定制 背景图片、标题、目标对象*/
+ (UIView*)headerViewWithImage:(UIImage*)img title:(NSString*)title target:(id)sender viewImg:(NSString *)viewImg leftBtnImg:(NSString *)leftBtnImg rightBtnImg:(NSString *)rightBtnImg;

/*nav bar 二级定制 背景图片、标题、目标对象*/
+ (UIView*)headerViewWithTitle:(NSString*)title target:(id)sender viewImg:(NSString *)viewImg leftBtnImg:(NSString *)leftBtnImg rightBtnImg:(NSString *)rightBtnImg;

/*类型转换*/
+(NSString*) dataToString:(NSData*)data;
+(NSData*) stringToData:(NSString*)string;

/*图片压缩*/
+(NSData *)scaleImage:(UIImage *)originalImage;

/*下侧提示框*/
+(void)showTosatViewWithMessage:(NSString *)message inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay beIndeter:(BOOL)indeter;

/*移除提示框*/
+(void)hideTosatView:(UIView *)view;

/*根据内容取得首字母*/
+(NSString*)getNamePinYingWithName:(NSString*)name;

/*验证正则表达式*/
+ (BOOL)matchRegularExpressionPsy:(NSString*)text match:(NSString*)match;

/*时间转化*/
+ (NSDateComponents *)componentsOfDate:(NSDate *)date ;

/*添加返回导航栏*/
+(UIButton*)createNavigationLeftBarButtonBack;
+(UIButton*)createNavigationLeftBarButtonImage;


/*uicolor生成image*/
+(UIImage *)createImageWithColor:(UIColor *)color;
+(UIImage*)createImageWithColor:(UIColor*)color rect:(CGRect)frame;

/*图片拉伸处理*/
+(UIImage*)stretchImage:(UIImage *)img edgeInsets:(UIEdgeInsets)inset;

/*判断数字输入错误的集合*/
+(int)doTextFieldDelegate:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;



@end
