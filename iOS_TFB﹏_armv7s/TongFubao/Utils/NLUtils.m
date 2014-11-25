//
//  NLUtils.m
//  TongFubao
//
//  Created by〝Cow﹏. on 14-8-2.
//  Copyright (c) 2014年〝Cow﹏.. All rights reserved.
//

#import "NLUtils.h"
#import "NLAppDelegate.h"
#import "FeedController.h"
#import "NLContants.h"
#import "NLSlideBroadsideController.h"
#import "NLLogOnViewController.h"
#import "NLMoreViewController.h"
#import "NLPushViewIntoNav.h"
#import "NLPlistOper.h"
#import "ProtocolDefine.h"
#import <UIKit/UIKit.h>
#import <math.h>
#import <net/if.h>
#import <net/if_dl.h>
#import <mach/mach.h>
#import <mach/mach_host.h>
#import <sys/socket.h> // Per msqr
#import <sys/sysctl.h>
#import <sys/types.h>
#import <ifaddrs.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <net/if.h>
#include <ifaddrs.h>
#import <dlfcn.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "AESAdditions.h"
#import "NLProgressHUD.h"
#import "SvUDIDTools.h"

#define MAX_PIC_BYTES           110000.0
#define TAG_TEXT_FIELD_PHONE_NUM        1000

static NSString* gAuthorid       = @"";
static NSString* gAgentid        = @"";
static NSString* gRelateAgent    = @"";
static NSString* gAgenttypeid    = @"";
static NSString* gBossAuthorid   = @"";
static NSString* gWagelistid     = @"";
static NSString* gGesturepasswd  = @"";
static NSString* gleaderbool     = @"";

static NSString* gRegisterMobile = @"";
static NSString* g_req_token     = @"";
static NSString* g_au_token      = @"";
static NSString* g_appnewversion = @"";
static NSString* g_req_bkenv     = @"";
static NSString* gLogonDate      = @"";
static NSString* gLogonPassword  = @"";
static NSString* gIspaypwd       = @"";
static NSString* gPaypasswd      = @"";

@implementation NLUtils

+(NSString*)createUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef uuid = CFUUIDCreateString(NULL, theUUID);
    NSString* s=(__bridge NSString*)uuid;
    CFRelease(theUUID);
    return  s;
}

//返回
+ (UIButton *)createNavigationLeftBarButtonBack
{
    UIButton* backButton= [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 50, 30);
  
    [backButton setBackgroundImage:[UIImage imageNamed:@"navigationLeftBtnBack.png"] forState:UIControlStateNormal];
    
    [[backButton titleLabel] setFont:[UIFont boldSystemFontOfSize:14]];
    [backButton setTitle:@" 返回" forState:UIControlStateNormal];
     return backButton;
}

//返回
+ (UIButton *)createNavigationLeftBarButtonImage
{
    UIButton* backButton= [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 30, 30);
    
    [[backButton titleLabel] setFont:[UIFont boldSystemFontOfSize:14]];
   
    return backButton;
}

/*跳转*/
+ (void)presentModalViewController:(UIViewController*)oldViewController
                newViewController:(UIViewController*)newViewController
{
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:newViewController];
    
    if (IOS_7)
    {
        [navController.navigationBar setBarTintColor:NAV_COLOR];

        navController.navigationBar.tintColor = [UIColor whiteColor];
        NSShadow *shadow = [[NSShadow alloc] init];
        
        shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
        shadow.shadowOffset = CGSizeMake(0, -0.5);
        [navController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                    [UIColor whiteColor], NSForegroundColorAttributeName,
                                                    shadow, NSShadowAttributeName,
                                                    [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
    }
    else
    {
        navController.navigationBar.tintColor = NAV_COLOR;
    }
    
    [oldViewController presentViewController:navController animated:YES completion:nil];
}

+(void)enableSliderViewController:(BOOL)enable
{
    NLAppDelegate* appDelegate = (NLAppDelegate*)[[UIApplication sharedApplication] delegate];
    NLSlideBroadsideController* slider = [[NLSlideBroadsideController alloc] init];
    [slider enableSliderViewController:appDelegate.feedController
                        viewController:appDelegate.leftController
                                  type:NLSlideBroadsideCenterControllerMenuLeft
                                enable:enable];
}

//设置禁止拖动
+(void)sliderSetRightController:(UIViewController *)rightViewCtr
{
    NLAppDelegate* appDelegate = (NLAppDelegate*)[[UIApplication sharedApplication] delegate];
    NLSlideBroadsideController* slider = [[NLSlideBroadsideController alloc] init];
    [slider sliderViewController:appDelegate.feedController setRightViewController:rightViewCtr];
}

+ (void)sliderSetleftController:(UIViewController *)left{
    NLAppDelegate* appDelegate = (NLAppDelegate*)[[UIApplication sharedApplication] delegate];
    NLSlideBroadsideController* slider = [[NLSlideBroadsideController alloc] init];
    [slider sliderViewController:appDelegate.feedController setleftViewController:left];
}

+(bool)sendSms:(NSString*)content telephone:(NSArray*)tel controller:(UIViewController*)controller delegate:(id<MFMessageComposeViewControllerDelegate>)delegate
{
    // Check whether the current device is configured for sending SMS messages
    if ([MFMessageComposeViewController canSendText])
    {
        MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
        
        picker.messageComposeDelegate= delegate;
        
        if (IOS_7)
        {
            [picker.navigationBar setBarTintColor:NAV_COLOR];
            picker.navigationBar.tintColor = [UIColor whiteColor];
            NSShadow *shadow = [[NSShadow alloc] init];
            shadow.shadowOffset = CGSizeMake(0, -0.5);
            [picker.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                  shadow, NSShadowAttributeName,
                                                                  [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
        }
        else
        {
            picker.navigationBar.tintColor = NAV_COLOR;
        }
        
        picker.body = content; // 默认信息内容
        picker.recipients=tel;

        [controller presentViewController:picker animated:YES completion:nil];
        
        return true;
    }
    else
    {
        UIAlertView* waitingDialog = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"您的手机不支持程序发送短信"
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
        [waitingDialog show];	
        return false;
    }
}

+(void)sendSms:(NSString*)tel
{
	NSMutableString * str=[[NSMutableString alloc] initWithCapacity:50];
	[str appendString:@"tel://"];
	[str appendString:tel];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

+(NSString*)getRegisterMobile
{
    return gRegisterMobile;
}

+(NSString*)getRememberAccount
{
    NSString* mobile = [NLPlistOper readValue:TFBC_RememberAccount
                                         path:FETCH_ABS_FILE_NAME(TFBConfigurator)];
    return mobile;
}

+(void)setRememberAccount:(NSString*)mobile
{
    if (mobile)
    {
        [NLPlistOper writeValue:mobile key:TFBC_RememberAccount path:FETCH_ABS_FILE_NAME(TFBConfigurator)];
    }
    else
    {
        [NLPlistOper writeValue:@"" key:TFBC_RememberAccount path:FETCH_ABS_FILE_NAME(TFBConfigurator)];
    }
}

+(void)setRegisterMobile:(NSString*)mobile
{
    gRegisterMobile = mobile;
}


+(void)setPaypasswd:(NSString*)paypasswd{
    
    gPaypasswd = paypasswd;
}

+ (void)setAgentid:(NSString *)agentid
{
    gAgentid = agentid;
}

+ (NSString *)getAgentid
{
    return gAgentid;
}

/*判断是否进入引导页面*/
+(void)setleaderbool:(NSString*)leader
{
    gleaderbool = leader;
}

+(NSString*)getleader
{
    return gleaderbool;
}

+(void)setAuthorid:(NSString*)authorid
{
    NSLog(@"set_author%@",authorid);
    gAuthorid = authorid;
}

+(NSString*)getAuthorid
{
    NSLog(@"GET_gAuthorid--%@",gAuthorid);
    return gAuthorid;
}

/*bossauthorid*/
+ (NSString *)getbossauthorid
{
    return gBossAuthorid;
}

+ (void)setbossauthorid:(NSString*)bossauthorid
{
    gBossAuthorid = bossauthorid;
}

/*wagelistid 区分财务和老板发工资的月份id*/
+ (NSString *)getgWagelistid
{
    return gWagelistid;
}

+ (void)setWagelistid:(NSString*)Wagelistid
{
    gWagelistid = Wagelistid;
}

/*0没设 1已设置*/
+ (NSString *)getGesturepasswd
{
    return gGesturepasswd;
}

+ (void)setGesturepasswd:(NSString*)gesturepasswd
{
    gGesturepasswd = gesturepasswd;
}

/*relateAgent*/
+ (void)setRelateAgent:(NSString *)relateAgent
{
    gRelateAgent = relateAgent;
}

+ (NSString *)getRelateAgent
{
    return gRelateAgent;
}

/*Agenttypeid 0/1/2*/
+ (void)setAgenttypeid:(NSString *)Agenttypeid
{
    gAgenttypeid = Agenttypeid;
}

+ (NSString *)getAgenttypeid
{
    return gAgenttypeid;
}

+(BOOL)isUserRegister
{
    if (gAuthorid.length > 0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)matchRegularExpression:(NSString*)text match:(NSString*)match
{
    NSError *error;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:match options:0 error:&error];
    
    if (regex != nil)
    {
        NSTextCheckingResult *firstMatch = [regex firstMatchInString:text options:0 range:NSMakeRange(0, [text length])];
        
        if (firstMatch)
        {
            return YES;
        }
    }
    
    return NO;
}

+ (void)popToTheLogonVCFromMain:(UINavigationController *)nav mobile:(NSString *)mobile
{
    for (UIViewController *controller in nav.viewControllers)
    {
        if ([controller isKindOfClass:[NLLogOnViewController class]])
        {
            [(NLLogOnViewController*)controller doSetRememberAccount:mobile];
            [(NLLogOnViewController*)controller setMyAccount:mobile];
            [[(NLLogOnViewController*)controller myTableView] reloadData];
            [nav popToViewController:controller animated:YES];
        }
    }
}

+ (void)popToTheLogonVCFromMore:(UINavigationController *)nav
{
    for (UIViewController *controller in nav.viewControllers)
    {
        if ([controller isKindOfClass:[NLMoreViewController class]])
        {
            [nav popToViewController:controller animated:NO];
        }
    }
    
    NewLoginView* vc = (NewLoginView*)[[NLPushViewIntoNav sharePushViewIntoNav] getPushViewIntoNavByType:NLPushViewType_Logon];
    
    [nav pushViewController:vc animated:YES];
}

+ (void)popToTheMoreVC:(UINavigationController *)nav
{
    for (UIViewController *controller in nav.viewControllers)
    {
        if ([controller isKindOfClass:[NLMoreViewController class]])
        {
            [nav popToViewController:controller animated:YES];
        }
    }
}

/*弹框*/
+(void)showAlertView:(NSString*)title
             message:(NSString*)message
            delegate:(id<UIAlertViewDelegate>)delegate
                 tag:(int)tag
           cancelBtn:(NSString*)cancel
               other:(NSString *)other, ...
            
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:delegate
                                              cancelButtonTitle:cancel
                                              otherButtonTitles:other, nil];
    alertView.tag = tag;
    [alertView show];
}

/*直接文字弹框*/
+ (void)alertWithTitle:(NSString*)title
{
    UIAlertView *view = [[UIAlertView alloc] init];
    view.title = @"温馨提示";
    view.message=title;
    [view addButtonWithTitle:@"确定"];
    [view show];
}

/*标题、文字弹框*/
+ (void)alertWithTitle:(NSString*)title andMSG:(NSString*)msg
{
    UIAlertView *view = [[UIAlertView alloc] init];
    view.title = title;
    view.message = msg;
    [view addButtonWithTitle:@"确定"];
    [view show];
}

/*标题、文字、标签弹框*/
+ (void)alertWithTitle:(NSString*)title andMSG:(NSString*)msg delegate:(id)sender andTag:(NSInteger)tag
{
    UIAlertView *view = [[UIAlertView alloc] init];
    view.title = title;
    view.message = msg;
    view.tag=tag;
    view.delegate=sender;
    [view addButtonWithTitle:@"取消"];
    [view addButtonWithTitle:@"确定"];
    [view show];
}

/*标题、文字、代理对象、标签弹框*/
+ (void)alertWithTitle:(NSString*)title textFContent:(NSString*)text delegate:(id)sender andTag:(NSInteger)tag
{
    UIAlertView *view = [[UIAlertView alloc] init];
    view.alertViewStyle = UIAlertViewStylePlainTextInput;
    [[view textFieldAtIndex:0] setText:text];
    [[view textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
    [[view textFieldAtIndex:0] setTag:TAG_TEXT_FIELD_PHONE_NUM];
    [[view textFieldAtIndex:0] setDelegate:sender];
    view.title = title;
    [view addButtonWithTitle:@"取消"];
    [view addButtonWithTitle:@"拨打"];
    view.delegate = sender;
    view.tag = tag;
    [view show];
}

/*拨打电话的弹框*/
+ (void)alertWithMsg:(NSString*)msg delegate:(id)sender andTag:(NSInteger)tag
{
    UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:msg delegate:sender cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
    view.tag = tag;
    [view show];
}

/*菊花显示 
 使用
 [NLUtils addLoadingViewTo:self.navigationController.view withFrame:self.navigationController.view.frame andText:@"正在获取菊花信息"];
 */
+ (void)addLoadingViewTo:(UIView*)targetV withFrame:(CGRect)frame andText:(NSString*)text
{
    NLProgressHUD *hud = [[NLProgressHUD alloc] initWithFrame:frame];
    [targetV addSubview:hud];
    hud.labelText = text;
    hud.removeFromSuperViewOnHide = YES;
    [hud show:YES];
}

/* nav bar定制 背景图片、标题、目标对象 */
+ (UIView *)headerViewWithImage:(UIImage *)img title:(NSString *)title target:(id)sender viewImg:(NSString *)viewImg leftBtnImg:(NSString *)leftBtnImg rightBtnImg:(NSString *)rightBtnImg
{
    /*没适配 用到时候再适配吧 图片也没*/
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    view.userInteractionEnabled = YES;
    [view setImage:[UIImage imageNamed:viewImg]];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:leftBtnImg] forState:UIControlStateNormal];
    [button addTarget:sender action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [[UILabel alloc] init];
    CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:20]];
    [button setFrame:CGRectMake(5, 5, 33, 33)];
    [label setFrame:CGRectMake((320 - size.width)/2, 5, size.width, (44 - 10))];

    /*nav 右边按钮*/
    UIButton *button_right = [UIButton buttonWithType:UIButtonTypeCustom];
    [button_right setImage:[UIImage imageNamed:rightBtnImg] forState:UIControlStateNormal];
    [button_right addTarget:sender action:@selector(backBtnClickedOfRootCV:) forControlEvents:UIControlEventTouchUpInside];
    button_right.frame=CGRectMake(282, 5, 33, 33);
    
    [view addSubview:button_right];
    [view addSubview:button];
    
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:20];
    label.text = title;
    label.textColor = [UIColor whiteColor];
    [view addSubview:label];
    return view;
}

/*nav bar 二级定制 背景图片、标题、目标对象*/
+ (UIView*)headerViewWithTitle:(NSString*)title target:(id)sender viewImg:(NSString *)viewImg leftBtnImg:(NSString *)leftBtnImg rightBtnImg:(NSString *)rightBtnImg
{
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    view.userInteractionEnabled = YES;
    [view setImage:[UIImage imageNamed:viewImg]];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:leftBtnImg] forState:UIControlStateNormal];
    [button addTarget:sender action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *label = [[UILabel alloc] init];
    CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:20]];
    [button setFrame:CGRectMake(5, 5, 33, 33)];
    [label setFrame:CGRectMake((320 - size.width)/2, 5, size.width, (44 - 10))];

    UIButton *button_right = [UIButton buttonWithType:UIButtonTypeCustom];
    [button_right setImage:[UIImage imageNamed:rightBtnImg] forState:UIControlStateNormal];
    [button_right addTarget:sender action:@selector(backBtnClickedOfRootCV:) forControlEvents:UIControlEventTouchUpInside];
    button_right.frame=CGRectMake(282, 5, 33, 33);
    
    [view addSubview:button_right];

    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:20];
    label.text = title;
    label.textColor = [UIColor whiteColor];
    [view addSubview:label];

    return view;
}

+(void)callTel:(NSString*)tel
{
	NSMutableString * str=[[NSMutableString alloc] initWithCapacity:50];
	[str appendString:@"tel://"];
	[str appendString:tel];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

+(void)cleanLogonInfo
{
//    [NLUtils setRegisterMobile:nil];
    [NLUtils setAuthorid:nil];
}

+(NSString*)getProtocolRequestName:(NSString*)name
{
    NSString* str = [name substringFromIndex:27];
    return str;
}

+(NSString*)dataToString:(NSData*)data
{
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

+(NSData*)stringToData:(NSString*)string
{
    return [string dataUsingEncoding: NSASCIIStringEncoding];
}

+(NSString*)getNameForRequest:(NSString*)string
{
    NSString* name = [NSString stringWithFormat:@"%@%@",Notify_finished,string];
    return name;
}

+(NSString*)reverseString:(NSString*)str
{
    NSUInteger len = [str length];
    NSMutableString *reverse  = [NSMutableString stringWithCapacity:len];
    while(len>0)
    {
        //从后取一个字符
        unichar c = [str characterAtIndex:--len];
        NSString *s = [NSString stringWithFormat:@"%C",c];
        [reverse appendString:s];
    }
    return reverse;
}

+(BOOL)luhn:(NSString*)bank//for checkBankCard
{
    int s1 = 0;
    int s2 = 0;
    
    NSString* reverse = [NLUtils reverseString:bank];
    int length = reverse.length;
    NSRange range;
    
    for (int i=0; i<length; i++)
    {
        range = NSMakeRange (i, 1);
        int digit = [[reverse substringWithRange:range] intValue];
        if(i % 2 == 0)//this is for odd digits, they are 1-indexed in the algorithm
        {
            s1 += digit;
        }
        else//add 2 * digit for 0-4, add 2 * digit - 9 for 5-9
        {
            s2 += 2 * digit;
            if(digit >= 5)
            {
                s2 -= 9;
            }
        }
    }
    
    return (s1 + s2) % 10 == 0;
}

/*银行卡号码验证*/
+(BOOL)checkBankCard:(NSString*)bank
{
    return YES;
    NSString* mach = @"^(^\\d{16}$|^\\d{19}$)$";
    
    if (bank.length <= 0 || ![NLUtils matchRegularExpression:bank match:mach])
    {
        return NO;
    }
    
    return [NLUtils luhn:bank];
}

+(int) checkCid:(NSString*)identity
{
    /**
     * 0：合法 1：非法格式 2：非法地区 3：非法生日 4：非法校验
     * */
    NSString* match = @"^(^\\d{15}$|^\\d{18}$|^\\d{17}(\\d|X|x))$";
    if (![NLUtils matchRegularExpression:identity match:match])
    {
        return 1;
    }
    
     //NSArray* areas = [NSArray arrayWithObjects:@"", @"安微",@"",nil];
    
    NSArray* areas = [NSArray arrayWithObjects:@"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"北京", @"天津", @"河北", @"山西", @"内蒙古", @"", @"",@"", @"", @"", @"辽宁", @"吉林", @"黑龙江", @"", @"", @"", @"", @"", @"", @"", @"上海", @"江苏", @"浙江", @"安微", @"福建", @"江西", @"山东", @"", @"",@"", @"河南", @"湖北", @"湖南", @"广东", @"广西", @"海南", @"", @"", @"", @"重庆", @"四川", @"贵州", @"云南", @"西藏", @"", @"", @"", @"", @"", @"", @"陕西",@"甘肃", @"青海", @"宁夏", @"新疆", @"", @"", @"", @"", @"", @"台湾", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"香港", @"澳门", @"",@"", @"", @"", @"", @"", @"", @"", @"国外", @"", @"", @"", @"", @"", @"", @"", @"", nil];
    
    // 地区
    NSRange range = NSMakeRange (0, 2);
    int areacode = [[identity substringWithRange:range] intValue];
    NSString* string = [areas objectAtIndex:areacode];
    
    if (string.length == 0)
    {
        return 2;
    }
    
    // 生日
    NSString* dateStrSrc = nil;
    
    if (identity.length == 18)
    {
        range = NSMakeRange (6, 8);
        dateStrSrc = [identity substringWithRange:range];
    }
    else
    {
        range = NSMakeRange (6, 6);
        dateStrSrc = [NSString stringWithFormat:@"%d%@",19,[identity substringWithRange:range]];
    }
    
    //range = NSMakeRange (0, 4);
   // NSString* str = [dateStrSrc substringWithRange:range];
    //range = NSMakeRange (4, 2);
    NSString* str1 = nil;//[dateStrSrc substringWithRange:range];
    //range = NSMakeRange (6, 2);
    NSString* str2 = nil;//[dateStrSrc substringWithRange:range];
    //NSString* dateStr = [NSString stringWithFormat:@"%@-%@-%@",str,str1,str2];
     // 校验位比对
    if (identity.length == 18)
    {
        NSMutableArray* wi = [NSMutableArray arrayWithCapacity:17];
        
        for (int i=0; i<17; i++)
        {
            int k = pow(2,(17-i));
            int v = k % 11;
            str2 = [NSString stringWithFormat:@"%d",v];
            [wi addObject:str2];
        }
        
        int sum = 0;
        int t = 0;
        int t2 = 0;
        
        // 进行加权求和
        for (int i = 0; i < 17; i++)
        {
            range = NSMakeRange (i, 1);
            t = [[identity substringWithRange:range] intValue];
            t2 = [[wi objectAtIndex:i] intValue];
            sum += t * t2;
        }
        
        // 取模运算，得到模值
        int code = sum % 11;
        NSString* checkCode = @"10X98765432";
        range = NSMakeRange (code, 1);
        NSString* check = [checkCode substringWithRange:range];
        range = NSMakeRange (17, 1);
        str1 = [identity substringWithRange:range];
        if (NSOrderedSame != [str1 compare:check options:NSCaseInsensitiveSearch])
        {
            return 4;
        }
    }
    // 男女
    if (identity.length == 18)
    {
        range = NSMakeRange (16, 1);
        str1 = [identity substringWithRange:range];
        
        if ([str1 intValue]%2 == 1)
        {
            //NSLog(@"sex = 男");
        }
        else
        {
            //NSLog(@"sex = 女");
        }
    }
    else
    {
        range = NSMakeRange (13, 1);
        str1 = [identity substringWithRange:range];
        
        if ([str1 intValue]%2 == 1)
        {
            //NSLog(@"sex = 男");
        }
        else
        {
            //NSLog(@"sex = 女");
        }
    }
    
    return 0;
}

/*身份证的判断*/
+(BOOL)checkIdentity:(NSString*)identity
{
    if (identity.length <= 0)
    {
        return false;
    }
    
    if([NLUtils checkCid:identity] == 0)
    {
        return true;
    }
    
    return false;
}

+(BOOL)checkMobilePhone:(NSString*) mobilePhone
{
    if (mobilePhone.length <= 0)
    {
        return NO;
    }
    
    NSArray* mobilePhoneStarts = [NSArray arrayWithObjects:@"106|移动", @"130|联通", @"131|联通", @"132|联通", @"133|电信", @"134|移动", @"135|移动", @"136|移动", @"137|移动", @"138|移动", @"139|移动",@"145|联通", @"147|移动", @"150|移动", @"152|移动", @"153|电信", @"155|联通", @"156|联通", @"157|移动", @"158|移动", @"159|移动",@"180|电信", @"181|电信", @"182|移动", @"183|移动",@"184|移动", @"185|联通", @"186|联通", @"187|移动", @"188|移动", @"189|电信",@"151|移动",@"177|电信",nil];
    
    NSString* regex1MobilePhone = @"^\\d{11}$";
    NSString* regex2MobilePhone = @"^(86)\\d{11}$";
    NSString* regex3MobilePhone = @"^(\\+86)\\d{11}$";
    
    NSRange range = NSMakeRange (0, 3);
    if ([NLUtils matchRegularExpression:mobilePhone match:regex1MobilePhone])
    {
        NSString* temp1 = nil;
        NSString* temp2 = nil;
        for (NSString* mobilePhoneStart in mobilePhoneStarts)
        {
            temp1 = [mobilePhoneStart substringWithRange:range];
            temp2 = [mobilePhone substringWithRange:range];
            if (NSOrderedSame == [temp1 compare:temp2 options:NSCaseInsensitiveSearch])
            {
                return YES;
            }
        }
    }
    
    if ([NLUtils matchRegularExpression:mobilePhone match:regex2MobilePhone])
    {
        NSString* temp1 = nil;
        NSString* temp2 = nil;
        for (NSString* mobilePhoneStart in mobilePhoneStarts)
        {
            temp1 = [mobilePhoneStart substringWithRange:range];
            range = NSMakeRange (2, 3);
            temp2 = [mobilePhone substringWithRange:range];
            
            if (NSOrderedSame == [temp1 compare:temp2 options:NSCaseInsensitiveSearch])
            {
                return YES;
            }
        }
    }
    
    if ([NLUtils matchRegularExpression:mobilePhone match:regex3MobilePhone])
    {
        NSString* temp1 = nil;
        NSString* temp2 = nil;
        
        for (NSString* mobilePhoneStart in mobilePhoneStarts)
        {
            temp1 = [mobilePhoneStart substringWithRange:range];
            range = NSMakeRange (3, 3);
            temp2 = [mobilePhone substringWithRange:range];
            
            if (NSOrderedSame == [temp1 compare:temp2 options:NSCaseInsensitiveSearch])
            {
                return YES;
            }
        }
    }
    
    return NO;
}

+ (BOOL)checkInterNum:(NSString *)num
{
    NSScanner* scan = [NSScanner scannerWithString:num];
    
    int val;
    
    return [scan scanInt:&val] && [scan isAtEnd];
}

/*检测中文*/
+ (BOOL)checkName:(NSString *)name
{
    if (name.length <= 0)
    {
        return NO;
    }
    
    NSString* mach = @"^[\u4e00-\u9fa5]([\u4e00-\u9fa5]){1,6}$";
    
    return [NLUtils matchRegularExpression:name match:mach];
}

+ (BOOL)checkPassword:(NSString *)password
{
    if (password.length <= 0)
    {
        return NO;
    }
    
    NSString* mach = @"^[a-zA-Z0-9]{6,20}$";
    
    return [NLUtils matchRegularExpression:password match:mach];
}

+ (BOOL)checkEmail:(NSString *)email
{
    if (email.length <= 0)
    {
        return NO;
    }
    
    NSString* mach = @"^\\s*\\w+(?:\\.{0,1}[\\w-]+)*@[a-zA-Z0-9]+(?:[-.][a-zA-Z0-9]+)*\\.[a-zA-Z]+\\s*$";
    
    return [NLUtils matchRegularExpression:email match:mach];
}

+ (float)rand1:(int)max
{
    srandom((unsigned)time(NULL));
    int a=(int)max*(rand()/(float)RAND_MAX);
    return a;
}

//重新登陆 超时
+ (void)popToLogonVCByHTTPError:(UIViewController*)currentVC  feedOrLeft:(int)feedOrLeft
{
//    [NLUtils setRememberAccount:@""];//这个会取消记住帐号
    [NLUtils setAuthorid:@""];
    g_req_token = @"";
    [NLUtils set_req_bkenv:@""];
    gLogonDate = @"";
    [NLUtils setLogonPassword:@""];
    
    Gesture *ges= [[Gesture alloc]init];
    ges.timeOutType = @"timeOut";
    
    NLAppDelegate* appDelegate = (NLAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSArray* arr = nil;
    
    if (1 == feedOrLeft)
    {
        arr = [NSArray arrayWithObjects:appDelegate.feedController, nil];
    }
    
    else if (0 == feedOrLeft)
    {
        NLMoreViewController* more = [[NLMoreViewController alloc]initWithNibName:@"NLMoreViewController"
                                                                           bundle:nil];
        arr = [NSArray arrayWithObjects:more, nil];
    }
    
    ges.ctrArr = arr;
    ges.currentVC = currentVC;
    [currentVC presentViewController:ges animated:YES completion:nil];
}

+ (NSString *) macAddress
{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0)
    {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0)
    {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL)
    {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0)<0)
    {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    //  NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    return [outstring uppercaseString];
}

+ (void)setLogonDate
{
    NSTimeInterval curTime = [[NSDate date] timeIntervalSince1970];
    double dtime = (double)curTime;
    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyyMMddHHmmss"];
    NSString* string = [format stringFromDate:[NSDate dateWithTimeIntervalSince1970:dtime]];
    gLogonDate = string;
}

+ (void)setLogonPassword:(NSString *)password
{
    gLogonPassword = password;
}

+ (NSString *)get_req_time
{
    NSTimeInterval curTime = [[NSDate date] timeIntervalSince1970];
    double dtime = (double)curTime;
    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyyMMddHHmmss"];
    NSString* string = [format stringFromDate:[NSDate dateWithTimeIntervalSince1970:dtime]];
    return string;
}

+ (NSString *)create_req_token
{
    NSString* str = @"";
    if (gLogonPassword.length>0 && gLogonDate.length>0 && gRegisterMobile.length>0)
    {
//        NSString* mac = [NLUtils macAddress];
        NSString *deviceId = [SvUDIDTools UDID];
        NSString *mac = [deviceId stringByReplacingOccurrencesOfString:@"-" withString:@""];
        NSLog(@"去掉 - 符号 deviceId=%@",mac);
        str = [NSString stringWithFormat:@"%@@@%@@@%@@@%@",mac,gLogonDate,gRegisterMobile,gLogonPassword];
        NSLog(@"加密前获取登陆的数据 ret_token%@",str);
        str = [AESAdditions encryptString:str];//加密数据
        NSLog(@"加密后获取登陆的数据%@",str);
    }
    return str;
}

+ (void)set_req_token:(NSString *)req_token
{
    if (req_token.length > 0)
    {
        g_req_token = req_token;
    }
    else
    {
        g_req_token = [NLUtils create_req_token];//加密数据
    }
}

+ (NSString *)get_req_token
{
    if (g_req_token.length <= 0)
    {
        g_req_token = [NLUtils create_req_token];//加密数据
    }
    return g_req_token;
}

+ (void)set_au_token:(NSString *)au_token
{
    g_au_token = au_token;
}

+ (NSString *)get_au_token
{
    return g_au_token;
}

/*当前最新版本号*/
+ (void)set_appnewversion:(NSString *)appnewversion
{
    g_appnewversion = appnewversion;
}

+ (NSString *)get_appnewversion
{
    return g_appnewversion;
}

+ (void)set_req_bkenv:(NSString *)req_bkenv
{
    g_req_bkenv = req_bkenv;
}

+ (NSString *)get_req_bkenv
{
    #ifdef TFB_LOCAL_ENVIROMENT
    return @"01";
    #else
    return g_req_bkenv;
    #endif
}

+ (void)setIspaypwd:(NSString *)ispaypwd
{
    gIspaypwd = ispaypwd;
}

+ (NSString *)getIspaypwd
{
    return gIspaypwd;
}

+ (void)setForceUpdate:(NSString *)force
{
   [NLPlistOper writeValue:force
                       key:TFBC_readHelpList_forceUpdate
                      path:FETCH_ABS_FILE_NAME(TFBConfigurator)];
}

//是否强制更新
+ (NSString *)getForceUpdate
{
    
    NSString* force = [NLPlistOper readValue:TFBC_readHelpList_forceUpdate
                                        path:FETCH_ABS_FILE_NAME(TFBConfigurator)];
    return force;
}

+ (int)doTextFieldDelegate:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    int result = 0;
    int length = [textField.text length] + [string length];
    
    if (range.length > 0)
    {
        length--;
    }
    
    if (length > 0)
    {
        if (textField.text.length <=0)
        {
            if (string.length >=2)
            {
                if ([[string substringToIndex:1] isEqualToString:@"0"])
                {
                    result = 6;
                }
            }
        }
        
        if ([textField.text isEqualToString:@"0"])
        {
            if (![string isEqualToString:@"."])
            {
                result = 5;
            }
        }
        
        if(length > 8)//大于八位数
        {
            result = 3;
        }
        else
        {
            NSRange textRange = [textField.text rangeOfString:@"."];
            NSArray* textArr = [textField.text componentsSeparatedByString:@"."];
            
            if (textRange.length > 0)//如果已经有小数点时
            {
                if ([[textArr objectAtIndex:1] length]>=2 && string.length>0)//只能保留二位小数
                {
                    result = 1;
                }
            }
            else //如果还没有小数点时
            {
                if ([string isEqualToString:@"."])//输入小数点时
                {
                    if ([textField.text length] <= 0)//第一位不能输入小数点
                    {
                        result = 2;
                    }
                }
            }
        }
    }
    
    return result;
}

+ (NSString *) getSysInfoByName:(char *)typeSpecifier
{
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
    free(answer);
    return results;
}

+ (NSString *) platform
{
    return [NLUtils getSysInfoByName:"hw.machine"];
}

+ (NSString *) simplePlatformString
{
    NSString *platform = [NLUtils platform];
    
    //    iPhone         (iPhone1,1)
    //    iPhone3G       (iPhone1,2)
    //    iPhone3GS      (iPhone2,1)
    //    iPhone4        (iPhone3,1)
    //    iPhone4(vz)    (iPhone3,3)iPhone4 CDMA版
    //    iPhone4S       (iPhone4,1)
    //    iPodTouch(1G)  (iPod1,1)
    //    iPodTouch(2G)  (iPod2,1)
    //    iPodTouch(3G)  (iPod3,1)
    //    iPodTouch(4G)  (iPod4,1)
    
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iP1";
    
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone3";
    
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone3S";
    
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"iPhone4C";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone4S";
    
    
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPT1";
    
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPT2";
    
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPT3";
    
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPT4";
    
    //    iPad2,1        (iPad2,1)Wifi版
    //    iPad2,2        (iPad2,2)GSM3G版
    //    iPad2,3        (iPad2,3)CDMA3G版
    
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad1";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad2";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad2S";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad2C";
    
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    
    return @"iP";
}

+ (NSString *)formatCardNumber:(NSString *)cardNumber
{
    if (cardNumber.length > 9)
    {
        NSString *strLeft = [cardNumber substringToIndex:6];
        NSString *strRight = [cardNumber substringFromIndex:(cardNumber.length - 4)];
        return [NSString stringWithFormat:@"%@***%@",strLeft,strRight];
    }
    else
    {
        return cardNumber;
    }
}

/*封装的Button*/
+ (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 10.0f, 10.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (UIImage *)createImageWithColor:(UIColor *)color rect:(CGRect)frame
{
    UIGraphicsBeginImageContext(frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, frame);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

+ (UIImage *)stretchImage:(UIImage *)img edgeInsets:(UIEdgeInsets)inset
{
    if ([img respondsToSelector:@selector(resizableImageWithCapInsets:resizingMode:)])
    {
        img = [img resizableImageWithCapInsets:inset resizingMode:UIImageResizingModeStretch];
    }
    else if ([img respondsToSelector:@selector(resizableImageWithCapInsets:)])
    {
        img = [img resizableImageWithCapInsets:inset];
    }
    
    return img;
}

+ (BOOL)isIOS7
{
    NSString *strSystemVersion = [[UIDevice currentDevice] systemVersion];
    
    if ([[strSystemVersion substringToIndex:1] intValue] >= 7) {
        return YES;
    }else{
        return NO;
    }
}

+ (BOOL) isiPad
{
    BOOL isIpad = NO;
    if(UI_USER_INTERFACE_IDIOM())
        isIpad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
    return  isIpad;
}

+ (BOOL)isIphone5
{
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    //横屏和竖屏
    if (IPHONE5_HEIGHT == screenHeight || IPHONE5_HEIGHT == screenWidth)
    {
        return YES;
    }
    
    return NO;
}

/*当前手机尺寸*/
+ (int)getDeviceHeight
{
    if ([self isIphone5])
    {
        return IPHONE5_HEIGHT;
    }
    else
    {
        return IPHONE4_HEIGHT;
    }
}

//获取控制器高度
+ (CGFloat)getCtrHeight
{
    if ([self isIOS7]) {
        return [self getDeviceHeight];
    }else{
        return [self getDeviceHeight] - BATTERY_HEIGHT - NAVBAR_HEIGHT;
    }
}

/*图片压缩*/
+ (NSData *)scaleImage:(UIImage *)originalImage
{
    NSData *BigImageData = UIImageJPEGRepresentation(originalImage, 1.0);
    int length = [BigImageData length];
    
    if (MAX_PIC_BYTES < length)
    {
        float scale = MAX_PIC_BYTES / length;
        BigImageData = UIImageJPEGRepresentation(originalImage, scale);
    }
    
    NSData *smallImageData = UIImageJPEGRepresentation(originalImage, 1.0);
    length = [smallImageData length];
    
    if (MAX_PIC_BYTES < length)
    {
        smallImageData = UIImageJPEGRepresentation(originalImage, 0.5);
    }
    
    return BigImageData;
}

//下侧提示框
+ (void)showTosatViewWithMessage:(NSString *)message inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay beIndeter:(BOOL)indeter{
    [self hideTosatView:view];
    
    NLProgressHUD *hud = [NLProgressHUD showHUDAddedTo:view animated:YES];
	// Configure for text only and offset down
    
    if (indeter)
    {
        hud.mode = NLProgressHUDModeIndeterminate;
    }
    else
    {
        hud.mode = NLProgressHUDModeText;
    }
	
	hud.labelText = message;
    hud.labelFont = [UIFont fontWithName:@"BanglaSangamMN" size:15];
	hud.margin = 10.f;
    //	hud.yOffset = 150.f;
	hud.removeFromSuperViewOnHide = YES;
    
	if (delay > 0)
    {
        [hud hide:YES afterDelay:delay];
    }
}

//移除提示框
+(void)hideTosatView:(UIView *)view{
    [NLProgressHUD hideAllHUDsForView:view animated:NO];
}

+(NSString*)getNamePinYingWithName:(NSString *)name
{
    if (0 == [name length])
    {
        return nil;
    }
    
    HanyuPinyinOutputFormat *outputFormat = [[HanyuPinyinOutputFormat alloc] init];
    [outputFormat setToneType:ToneTypeWithoutTone];
    [outputFormat setVCharType:VCharTypeWithV];
    [outputFormat setCaseType:CaseTypeUppercase];
    
    NSString *strPinYin = [PinyinHelper toHanyuPinyinStringWithNSString:name withHanyuPinyinOutputFormat:outputFormat withNSString:@" "];
    
    if ([strPinYin isEqualToString:@"ZHONG QING"]) {
        strPinYin = @"CHONG QING";
    }
    else if([strPinYin isEqualToString:@"YUE SHAN"])
    {
        strPinYin = @"LE SHAN";
    }
    else if([strPinYin isEqualToString:@"JUN XIAN"])
    {
        strPinYin = @"XUN XIAN";
    }
    else if([strPinYin isEqualToString:@"SHA MEN"])
    {
        strPinYin = @"XIA MEN";
    }
    else if([strPinYin isEqualToString:@"ZHANG SHA"])
    {
        strPinYin = @"CHANG SHA";
    }
    else if([strPinYin isEqualToString:@"WEI LI"])
    {
        strPinYin = @"YU LI";
    }
    else if([strPinYin isEqualToString:@"ZHAO YANG"])
    {
        strPinYin = @"CHAO YANG";
    }
    else if([strPinYin isEqualToString:@"DAN XIAN"])
    {
        strPinYin = @"SHAN XIAN";
    }
    if ([strPinYin length] > 0)
    {
        return [strPinYin substringToIndex:1];
    }
    else
    {
        return nil;
    }
}

//验证正则表达式
+ (BOOL)matchRegularExpressionPsy:(NSString *)text match:(NSString *)match
{
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:match options:0 error:&error];
    
    if (regex != nil)
    {
        NSTextCheckingResult *firstMatch = [regex firstMatchInString:text options:0 range:NSMakeRange(0, [text length])];
        
        if (firstMatch)
        {
            return YES;
        }
    }
    
    return NO;
}

//转化
+ (NSDateComponents *)componentsOfDate:(NSDate *)date
{
    NSDate *aDate = date ? date : [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    
    return [calendar components:unitFlags fromDate:aDate];
}

@end
