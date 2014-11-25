//
//  NLUtils.h
//  TongFubao
//
//  Created by MD313 on 13-8-2.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import "PinYin4Objc.h"

#define IPHONE5_HEIGHT              568
#define IPHONE4_HEIGHT              480
#define BATTERY_HEIGHT              20
#define NAVBAR_HEIGHT               44

@interface NLUtils : NSObject

+ (NLUtils *)updataManager;
+(NSString*)createUUID;
+(void)setPaypasswd:(NSString*)paypasswd;
+(UIButton*)createNavigationLeftBarButtonBack;
+(UIButton*)createNavigationLeftBarButtonImage;
+(void)presentModalViewController:(UIViewController*)oldViewController
                newViewController:(UIViewController*)newViewController;
+(void)enableSliderViewController:(BOOL)enable;
+(void)sliderSetRightController:(UIViewController *)rightViewCtr;
+ (void)sliderSetleftController:(UIViewController *)left;
+(bool)sendSms:(NSString*)content telephone:(NSArray*)tel controller:(UIViewController*)controller delegate:(id<MFMessageComposeViewControllerDelegate>)delegate;
+(void)callTel:(NSString*)tel;
+(BOOL)isUserRegister;
+(void)setAuthorid:(NSString*)authorid;
+(NSString*)getAuthorid;
+(void)setAgentid:(NSString*)agentid;
+(NSString*)getAgentid;
+(NSString*)getRegisterMobile;
+(NSString*)getRememberAccount;
+(void)setRememberAccount:(NSString*)mobile;
+(void)setRegisterMobile:(NSString*)mobile;
+(void)popToTheLogonVCFromMain:(UINavigationController*)nav mobile:(NSString*)mobile;
+(void)popToTheLogonVCFromMore:(UINavigationController*)nav;
+(void)popToTheMoreVC:(UINavigationController*)nav;
+(void)showAlertView:(NSString*)title
             message:(NSString*)message
            delegate:(id<UIAlertViewDelegate>)delegate
                 tag:(int)tag
           cancelBtn:(NSString*)cancel
               other:(NSString *)other, ...;
+(void)cleanLogonInfo;
+(NSString*)getProtocolRequestName:(NSString*)name;
+(NSString*) dataToString:(NSData*)data;
+(NSData*) stringToData:(NSString*)string;
+(NSString*) getNameForRequest:(NSString*)string;
+(BOOL)checkBankCard:(NSString*)bank;
+(BOOL)checkIdentity:(NSString*)identity;
+(BOOL)checkMobilePhone:(NSString*)mobilePhone;
+(BOOL)checkInterNum:(NSString*)num;
+(BOOL)checkName:(NSString*)name;
+(BOOL)checkPassword:(NSString*)password;
+(BOOL)checkEmail:(NSString*)email;
+(float)rand1:(int)max;
+(void)popToLogonVCByHTTPError:(UIViewController*)currentVC  feedOrLeft:(int)feedOrLeft;

/*存储基本信息--msgheard等*/
+(void)set_appnewversion:(NSString*)appnewcontent;
+(NSString*)get_appnewversion;
+(NSString*)get_req_time;
+(void)set_req_token:(NSString*)req_token;
+(NSString*)get_req_token;
+(void)set_au_token:(NSString*)au_token;
+(NSString*)get_au_token;
+(void)set_req_bkenv:(NSString*)req_bkenv;
+(NSString*)get_req_bkenv;
+(void)setIspaypwd:(NSString*)ispaypwd;
+(NSString*)getIspaypwd;
+(void)setLogonDate;
+(void)setLogonPassword:(NSString*)password;
+(void)setForceUpdate:(NSString*)force;
+(NSString*)getForceUpdate;

+(int)doTextFieldDelegate:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

+(NSString *) simplePlatformString;

+(NSString *)formatCardNumber:(NSString *)cardNumber;

//uicolor生成image
+(UIImage *)createImageWithColor:(UIColor *)color;

+(UIImage*)createImageWithColor:(UIColor*)color rect:(CGRect)frame;

//图片拉伸处理
+(UIImage*)stretchImage:(UIImage *)img edgeInsets:(UIEdgeInsets)inset;

+(BOOL)isIOS7;

+(BOOL)isIphone5;

+(BOOL)isiPad;

/*relateAgent  Agenttypeid*/
+ (void)setRelateAgent:(NSString *)relateAgent;

+ (NSString *)getRelateAgent;

+ (NSString *)getAgenttypeid;

+ (void)setAgenttypeid:(NSString *)Agenttypeid;

/*屏幕高度*/
+(int)getDeviceHeight;

/*获取控制器高度*/
+(CGFloat)getCtrHeight;

/*图片压缩*/
+(NSData *)scaleImage:(UIImage *)originalImage;

/*提示框*/
+(void)showTosatViewWithMessage:(NSString *)message inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay beIndeter:(BOOL)indeter;

/*移除提示框*/
+(void)hideTosatView:(UIView *)view;

/*根据内容取得首字母*/
+(NSString*)getNamePinYingWithName:(NSString*)name;

/*验证正则表达式*/
+ (BOOL)matchRegularExpressionPsy:(NSString*)text match:(NSString*)match;

/*时间转化*/
+ (NSDateComponents *)componentsOfDate:(NSDate *)date ;

@end
