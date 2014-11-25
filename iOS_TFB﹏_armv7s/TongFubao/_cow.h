//
//  _cow.h
//  〝Cow﹏.
//
//  Created by  俊   on 14-10-15.
//  Copyright (c) 2014年 Cow_豪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
//#import "PinYin4Objc.h"

#define RGBACOLOR(r,g,b,a)      [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:a]

#define SACOLOR(s,a)            [UIColor colorWithRed:(s) / 255.0 green:(s) / 255.0 blue:(s) / 255.0 alpha:a]

#define NAV_COLOR [UIColor colorWithRed:13.0/255.0 green:122.0/255.0 blue:185.0/255.0 alpha:1.0] /*tab背景色*/
#define IOS_7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)
#define IOS_7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)
#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )

#define IOS6_7_DELTA(V,X,Y,W,H) if (IOS_7) {CGRect f = V.frame;f.origin.x += X;f.origin.y += Y;f.size.width += W;f.size.height += H;V.frame=f;}

//IOS6_7_DELTA(view, 0, 20, 0, 0);


//根据相对文件名,生成绝对路径
#define FETCH_ABS_FILE_NAME(fileName)  [(NSString*)[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:(fileName)]

//发送一个通知
#define POST_NOTIFY(notify)  [[NSNotificationCenter defaultCenter] postNotification:(notify)]

#define POST_NOTIFY_FOR_NAME(name,obj)  [[NSNotificationCenter defaultCenter] postNotificationName:(name) object:(obj)]

//注册通知监听
#define REGISTER_NOTIFY_OBSERVER(obs, method, notify)  [[NSNotificationCenter defaultCenter] removeObserver:obs name:notify object:nil]; [[NSNotificationCenter defaultCenter] addObserver:(obs) selector:@selector(method:) name:(notify) object:nil]
//移除某个监听者针对某个通知的监听
#define REMOVE_NOTIFY_OBSERVER_FOR_NAME(obs,notify)  [[NSNotificationCenter defaultCenter] removeObserver:(obs) name:(notify) object:nil]

//移除某个监听者所有通知的监听
#define REMOVE_NOTIFY_OBSERVER(obs)  [[NSNotificationCenter defaultCenter] removeObserver:(obs)]

//日志记录,在Release版本中,不记录日志
#ifdef DEBUG
#define NLLog NSLog(@"File:%s, Line:%d",strrchr(__FILE__,'/'),__LINE__);NSLog
#define NLLogNoLocation(format, ...) NSLog(@"{%s:%d}:: %@", __PRETTY_FUNCTION__,__LINE__, [NSString stringWithFormat:format, ## __VA_ARGS__])
#define MARKNoLocation	NLLogNoLocation(@"%s", __PRETTY_FUNCTION__);
#define NLLogWithLocation(format, ...) NSLog(@"{%s} in {%s:%d} :: %@", __PRETTY_FUNCTION__, __FILE__, __LINE__, [NSString stringWithFormat:format, ## __VA_ARGS__])
#define MARKWithLocation	NLLogWithLocation(@"%s", __PRETTY_FUNCTION__);
#else
#define NLLog
#define NLLogNoLocation(format, ...)
#define MARKNoLocation
#define NLLogWithLocation(format, ...)
#define MARKWithLocation
#endif

@interface _cow : NSObject

+(NSString *)formatCardNumber:(NSString *)cardNumber;
/*bossauthorid*/
+(NSString *)getbossauthorid;
/*bossauthorid*/
+(void)setbossauthorid:(NSString*)bossauthorid;

/*iphone类型及适配*/
+(NSString *) simplePlatformString;
+(BOOL)isIOS7;
+(BOOL)isIphone5;
+(BOOL)isiPad;

/*pre跳转加nav*/
+(void)presentModalViewController:(UIViewController*)oldViewController
                newViewController:(UIViewController*)newViewController;

/*信息的驗證*/
+ (float)rand1:(int)max;
+(BOOL)checkBankCard:(NSString*)bank;
+(BOOL)checkIdentity:(NSString*)identity;
+(BOOL)checkMobilePhone:(NSString*)mobilePhone;
+(BOOL)checkInterNum:(NSString*)num;
+(BOOL)checkName:(NSString*)name;
+(BOOL)checkPassword:(NSString*)password;
+(BOOL)checkEmail:(NSString*)email;

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

/*菊花显示 NLProgressHUD使用*/
//+ (void)addLoadingViewTo:(UIView*)targetV withFrame:(CGRect)frame andText:(NSString*)text;

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
/*实现按钮 空的 自己程序调用*/
-(void)backBtnClicked:(UIButton*)sender;
-(void)backBtnClickedOfRootCV:(UIButton*)sender;

/*类型转换*/
+(NSString*) dataToString:(NSData*)data;
+(NSData*) stringToData:(NSString*)string;

/*图片压缩*/
+(NSData *)scaleImage:(UIImage *)originalImage;

/*下侧提示框*/
//+(void)showTosatViewWithMessage:(NSString *)message inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay beIndeter:(BOOL)indeter;

/*移除提示框 隐藏了hud的提示框*/
//+(void)hideTosatView:(UIView *)view;

/*根据内容取得首字母 PinYin4Objc.h
 +(NSString*)getNamePinYingWithName:(NSString*)name;*/

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
+(NSInteger)doTextFieldDelegate:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

@end

/*导航类*/
@interface UIViewController (NavigationItem)

-(void)addBackButtonItemWithTitle:(NSString *)title;
-(void)addBackButtonItemWithImage:(UIImage *)img;
-(void)setNavBackItemByLastControllerBackTitle;
-(void)setNavBackItemByLastControllerTitle;
-(void)addRightButtonItemWithTitle:(NSString *)title;
-(void)addRightButtonItemWithImage:(UIImage *)img;
-(void)setNavRightArrowItemWithTitle:(NSString*)title;
-(void)setNavRightItemWithImage:(UIImage*)img;

-(void)RightBarItemClick;
@end


@interface UIImage (Tint)
- (UIImage *) imageWithTintColor:(UIColor *)tintColor;
@end

@interface UIColor (Art)
+(UIColor*)colorWithHex:(long)hex;
@end

@interface CowButton : UIButton
+(UIButton *)ButtonWithFrame:(CGRect)frame Target:(id)target Selector:(SEL)selector Image:(UIImage *)image Title:(NSString *)title TitleColor:(UIColor *)titleColor TitleColorSate:(UIControlState)titleColorSate;
@end

@interface CowLabelModel : UILabel
+ (UILabel *)LableTile:(NSString *)lableTitle TitleFrame:(CGRect)frame TitleNum:(int)titlenum titleColor:(UIColor *)titleColor BGColor:(UIColor *)bgColor fontSize:(float)fontSize boldSize:(float)boldSize;
@end


@interface CowUImage : UIImage
+(UIImage *)redraw:(UIImage*)_image frame:(CGRect)_frame;
@end

@interface CowTextFiledModel : UITextField
+ (UITextField *)textFiledFrame:(CGRect)frame  Placeholder:(NSString *)placeholder BGColor:(UIColor *)bgColor textColor: (UIColor *)textColor TextAlignment:(NSTextAlignment)TextAlignment contentAlignment:(UIControlContentVerticalAlignment )contentAlignment clearBtn:(BOOL)clearBtn  Delegate:(id)delegate Alpha:(CGFloat)alpha fontSize:(float)fontSize boldSize:(float)boldSize;
@end

@interface CowtextViewModel : UITextView
+ (UITextView *)textViewFrame:(CGRect)frame  BGColor:(UIColor *)bgColor textColor: (UIColor *)textColor TextAlignment:(NSTextAlignment)TextAlignment Delegate:(id)delegate Alpha:(CGFloat)alpha fontSize:(float)fontSize boldSize:(float)boldSize;
@end

@interface CowSwitchModel : UISwitch
-(UISwitch *)switchWithFrame:(CGRect)frame Onimage:(NSString*)onimage Offimage:(NSString*)offimage;
@end
