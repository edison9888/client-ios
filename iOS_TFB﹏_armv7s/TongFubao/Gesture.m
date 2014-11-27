//
//  Gesture.m
//  TongFubao
//
//  Created by  俊   on 14-5-28.
//  Copyright (c) 2014年 MD313. All rights reserved.
//二次登录的


#import "Gesture.h"
#import "MJPassword.h"
#import "NLProgressHUD.h"
#import "NLContants.h"
#import "FeedController.h"
#import "NLRegisterViewController.h"
#import "NLLogonPWManagerViewController.h"
#import "NLLoginView.h"

@interface Gesture ()
{
    int num;
    bool flag;
    double     IOS7IPHONE4;
    NLProgressHUD* _hud;
    NSString *gestureStr;
    NSString *JumpType;
    NSString *mobile;
    NSArray *DLArr ;
    UILabel *lablePeople;
    
}
@property (nonatomic,copy) NSString* password;

@property (nonatomic,retain) UIButton* clearButton;
@property (nonatomic,retain) UIButton* OtherButton;
@property (nonatomic,retain) UILabel* infoLabel;

@property (nonatomic,retain) MJPassword* passwordView;
@property (nonatomic,strong)NLProgressHUD* myHUD;

@end

@implementation Gesture

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
   
    }
    return self;
}

#pragma 用户登录接口
- (void)LoginViewIsGestureURL{
    
    NSString *payStr= [[DLArr valueForKey:@"passwordConfirmFieldDL"]objectAtIndex:0];
    
    [NLUtils setPaypasswd:self.payPasswd];
    [NLUtils setLogonDate];
    
    /*登陆界面 直接使用手势登陆*/
    if (_changeFlage != YES && _loginFlage!=YES)
    {
        [NLUtils setRegisterMobile:[[DLArr valueForKey:@"phonetextfiledDL"] objectAtIndex:0]];
        [NLUtils setLogonPassword:[[DLArr valueForKey:@"passwordConfirmFieldDL"]objectAtIndex:0]];
        [NLUtils set_req_token:nil];
    }
   
    NSString* name = [NLUtils getNameForRequest:Notify_ApiAuthorInfoV2GestureToHander];
    
    REGISTER_NOTIFY_OBSERVER(self, GestureNotifyOther, name);
    
    if (_changeFlage==YES)
    {
        /*切换账户界面 使用手势密码登陆*/
        [[[NLProtocolRequest alloc] initWithRegister:YES]getApiAuthorInfoV2gesturepasswdTohander:gestureStr paypasswd:payStr mobile:_loginMobile];
        
    }else if (_loginFlage==YES)
    {
        /*其他情况登陆 填写密码手机号的*/
        [[[NLProtocolRequest alloc] initWithRegister:YES]getApiAuthorInfoV2gesturepasswdTohander:gestureStr paypasswd:payStr mobile:[[DLArr valueForKey:@"phonetextfiledDL"] objectAtIndex:0]];
        [NLUtils setRegisterMobile:[[DLArr valueForKey:@"phonetextfiledDL"] objectAtIndex:0]];
    }else
    {
        /*直接手势密码*/
        [[[NLProtocolRequest alloc] initWithRegister:YES]getApiAuthorInfoV2gesturepasswdTohander:gestureStr paypasswd:payStr mobile:[NLUtils getRegisterMobile]];
    }
    
    //    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    
}

- (void)GestureNotifyOther:(NSNotification*)notify{
    
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    
    [NLUtils setLogonDate];
    
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        [self doGestureNotify:response];
        
    }else
    {
        [_hud hide:YES];
        NSString *detail = response.detail;
        //本地存密码
        if (num>=1) {
            num--;
            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",num] forKey:KEY_RECORD_GESTURE_NUM];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            UILabel *lable= (UILabel *)([self.view viewWithTag:10011]);
            if (lable==nil) {
                lable =   [[UILabel alloc] initWithFrame:CGRectMake(20, 172*IOS7IPHONE4-IOS7IPHONE4/2.2, 280, 30)];
                lable.tag =10011;
                [lablePeople setHidden:YES];
            }
            lable.textAlignment= NSTextAlignmentCenter;
            lable.backgroundColor = [UIColor clearColor];
            lable.font= [UIFont systemFontOfSize:18];
            lable.textColor= [UIColor redColor];
            lable.text= [NSString stringWithFormat:@"密码错误,还可以输%d次",num];
            [self.view addSubview:lable];
            [self shakeView:lable];
            
        }else{
            if (_changeFlage==YES) {
                [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",5] forKey:KEY_RECORD_GESTURE_NUM];
                [[NSUserDefaults standardUserDefaults]synchronize];
                if (num==1) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }else{
                [self showErrorInfo:detail status:NLHUDState_Error];
                [_hud hide:YES afterDelay:2];
                [self performSelector:@selector(pushNew) withObject:nil afterDelay:2.01];
            }
        }
      
        if (!detail || detail.length <= 0)
        {
            detail = @"服务器繁忙，请稍候再试";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

-(void)pushNew
{
    NewLoginView *new= [[NewLoginView alloc]initWithNibName:@"NewLoginView" bundle:nil];
    [self presentViewController:new animated:YES completion:nil];
}


- (void)doGestureNotify:(NLProtocolResponse*)response{
    
    NLProtocolData* payPaawd = [response.data find:@"msgbody/paypasswd" index:0];
    self.payPasswd = payPaawd.value;
   
    NLProtocolData* data = [response.data find:@"msgbody/result" index:0];
    
    NSString *result = data.value;
    
    NSRange range = [result rangeOfString:@"succ"];
    
    if (range.length <= 0)
    {
        NLProtocolData* data = [response.data find:@"msgbody/message" index:0];
        NSString* value = data.value;
        [self showErrorInfo:value status:NLHUDState_Error];
        
    }
    else
    {
        /*** madfrog add 6.20***/
        [NLUtils setAgentid:[response.data find:@"msgbody/agentid" index:0].value];
        /*替换默认的authorid*/
        [NLUtils setAuthorid:[response.data find:@"msgbody/authorid" index:0].value];
        /*** madfrog add 6.20***/
        /*relateAgent字段 1绑定服务代理商的*/
        [NLUtils setRelateAgent:[response.data find:@"msgbody/relateAgent" index:0].value];
        /*agenttypeid字段 0普通/1正式/2虚拟 */
        [NLUtils setAgenttypeid:[response.data find:@"msgbody/agenttypeid" index:0].value];
        
        /*agenttypeid*/
        
        //手势判断次数 存本地
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",5] forKey:KEY_RECORD_GESTURE_NUM];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        
        if ([_timeOutType isEqualToString:@"timeOut"]) {
            //超时页面登陆成功
            [self dismissViewControllerAnimated:YES completion:^void{
                
                if (_ctrArr.count>0) {
                    [_currentVC.navigationController setViewControllers:_ctrArr animated:NO];
                }else{
                    //修补超时
                    NLAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
                    [delegate backToMain];
                }
            }];
        }else{
            
            //非超时登陆成功
            if ([JumpType isEqualToString:@"finish"] ) {
                
                if (_changeFlage==YES) {
                    //手势密码修改登陆密码
                    NLLogonPWManagerViewController* vc =  [[NLLogonPWManagerViewController alloc] init];
                    vc.gesturFlag =YES;
                    vc.mobile=[NLUtils getRegisterMobile];
                    [self.navigationController pushViewController:vc animated:YES];
                    return;
                }
                else{
                    
                    [TFData getTempData][MAIN_IS_ON_GESTURESE]=MAIN_IS_ON_GESTURESE;
                    
                    //用于判断重新注销登录的手势密码状态
                    [[TFData getTempData]removeObjectForKey:MAIN_IS_ON_NEWLOGINGESTURE];
                    
                    NLAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
                    
                    /*** madfrog mofify ***/
                    //增加一个判断，是代理商进入代理商界面，否则进入普通页面
                    if ([[NLUtils getAgenttypeid] isEqualToString:@"0"]) {
                        [delegate backToMain];
                    }else{
                        [delegate backToTFAgent];
                    }
                    /*** madfrog mofify ***/
                }
            }
        }
    }
}

- (void) doPush
{
    [_hud hide:YES];
    [NLUtils popToLogonVCByHTTPError:self feedOrLeft:1];
}

//检查版本号
-(void)checkAppVersion
{
    [[[NLProtocolRequest alloc] initWithRegister:YES] checkAppVersion:@"2" version:TFBVersion];
}
-(void)viewWillAppear:(BOOL)animated{
    //     [self checkAppVersion];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    IOS7IPHONE4=IOS7_OR_IPHONE4==YES?0.8:1;
    
    DLArr = [[NSUserDefaults standardUserDefaults]objectForKey:@"DLarray"];
    mobile= [[DLArr valueForKey:@"phonetextfiledDL"] objectAtIndex:0];
    
    //从本地取输入密码的次数
    NSString *numStr = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_RECORD_GESTURE_NUM];
    if (numStr.length==0) {
        num = 0;
    }else{
        num = [numStr intValue];
    }
    
    if ([mobile length]==11||[_loginMobile length]==11) {
        
        lablePeople= [[UILabel alloc]initWithFrame:CGRectMake(20, 172*IOS7IPHONE4-IOS7IPHONE4/2.2, 280, 30)];
        lablePeople.hidden=NO;
        lablePeople.tag= 101;
        lablePeople.textAlignment= NSTextAlignmentCenter;
        lablePeople.textColor= [UIColor whiteColor];
        lablePeople.backgroundColor= [UIColor clearColor];
      
        if (_changeFlage == YES) {
            
            lablePeople.text= [NLUtils getRegisterMobile];
        }else{
            
            NSString *phoneStr = _loginFlage ? _loginMobile : mobile;
            lablePeople.text= phoneStr;
            [NLUtils setRegisterMobile:phoneStr];
        }
      
        /* 空格的随便写 懒得看啥办法了
        NSString *phoneq1 = [phoneStr substringWithRange:NSMakeRange(0, 3)];
        NSString *phoneq2 = [phoneStr substringWithRange:NSMakeRange(3, 4)];
        NSString *phoneq3 = [phoneStr substringWithRange:NSMakeRange(8, 3)];
        NSString *phone= [NSString stringWithFormat:@"%@ %@ %@",phoneq1,phoneq2,phoneq3];
        lablePeople.text= phone;
         */
        
        [self.view addSubview:lablePeople];
    }
    [self ClearAndMorebtn];
}


- (void)ClearAndMorebtn{
    
    //渐变拉升
    self.view.backgroundColor= [UIColor colorWithPatternImage:[NLUtils stretchImage:[UIImage imageNamed:@"bg_gradients@2x"] edgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)]];
    
    CGRect frame = CGRectMake(0, 30, self.view.bounds.size.width, self.view.bounds.size.height);
    
    self.passwordView = [[MJPassword alloc] initWithFrame:frame];
    
    self.passwordView.delegate = self;
    
    [self updateInfoLabel];
    
    [self.view addSubview:self.passwordView];
    
    UILabel *lable= [[UILabel alloc]initWithFrame:CGRectMake(70, 44-IOS7IPHONE4/4, 180, 30)];
    
    lable.textAlignment= UITextAlignmentCenter;
    
    if (_changeFlage==YES) {
        
        self.title= @"修改密码";
        
        UIButton* backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.opaque = YES;
        backBtn.frame = CGRectMake(16, 40, 40, 40);
        [backBtn setBackgroundImage:[UIImage imageNamed:@"navigationLeftBtnBack2"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:backBtn];
        
//        lable.text= @"修改登录密码";
   
    }else{

        [self btnInGesture];
    }
    
    [self heardgesture];
    lable.backgroundColor= [UIColor clearColor];
    lable.font= [UIFont systemFontOfSize:20];
    lable.textColor= [UIColor whiteColor];
    [self.view addSubview:lable];
    
}

-(void)backBtn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)heardgesture
{
    UIImageView *viewlo= [[UIImageView alloc]init];
    if (IOSVERSion>=7.0)
    {
        if (IOS7_OR_SCREEN)
        {
            viewlo.frame= CGRectMake(95+16*IOS7IPHONE4, 30, 130*IOS7IPHONE4, 130*IOS7IPHONE4);
        }else
        {
            viewlo.frame= CGRectMake(95, 30, 130*IOS7IPHONE4, 130*IOS7IPHONE4);
        }
    }else
    {
        viewlo.frame= CGRectMake(95, 20, 130*IOS7IPHONE4, 130*IOS7IPHONE4);
    }
    viewlo.image= [UIImage imageNamed:@"gestlogin"];
    [self.view addSubview:viewlo];
}

-(void)btnInGesture{
    
    self.clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.clearButton.frame = CGRectMake(25, self.view.frame.size.height-40, 130, 30);
    [self.clearButton setTitle:@"忘记手势密码" forState:UIControlStateNormal];
    [self.clearButton setTintColor:[UIColor whiteColor]];
    [self.clearButton addTarget:self action:@selector(clearPasswordBtn) forControlEvents:UIControlEventTouchUpInside];
    self.clearButton.backgroundColor=[UIColor clearColor];
    [self.view addSubview:self.clearButton];
    
    self.OtherButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.OtherButton.frame = CGRectMake(180, self.view.frame.size.height-40, 120, 30);
    [self.OtherButton setTitle:@"登录其他账户" forState:UIControlStateNormal];
    [self.OtherButton setTintColor:[UIColor whiteColor]];
    [self.OtherButton addTarget:self action:@selector(OtherAction) forControlEvents:UIControlEventTouchUpInside];
    self.OtherButton.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.OtherButton];
}

//联网 确定是否密码一致
- (void)passwordView:(MJPassword *)passwordView withPassword:(NSString *)password{
    self.password= password;
    gestureStr= password;//当前设置的密码
    JumpType = @"finish";
    /*登陆*/
    [self LoginViewIsGestureURL];
    [self updateInfoLabel];
}

//忘记密
- (void)clearPasswordBtn
{
    /*
    NewLoginViewCow *ge= [[NewLoginViewCow alloc]initWithNibName:@"NewLoginViewCow" bundle:nil];
    [self presentModalViewController:ge animated:YES];

     NewLoginViewCow *vc= [[NewLoginViewCow alloc]initWithNibName:@"NewLoginViewCow" bundle:nil];
     [NLUtils presentModalViewController:self newViewController:vc];
       */
    [NLUtils showAlertView:nil
                   message:@"忘记手势密码，需重新登陆"
                  delegate:self
                       tag:1
                 cancelBtn:@"取消"
                     other:@"重新登陆",nil];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1 == buttonIndex)
    {
        /* 不带属性赋值 不行
        id thisClass = [[NSClassFromString(@"NLLoginView") alloc] initWithNibName:@"NLLoginView" bundle:nil];
        [NLUtils presentModalViewController:self newViewController:thisClass];*/
        
        NLLoginView *vl = [[NLLoginView alloc] initWithNibName:@"NLLoginView" bundle:nil];
        vl.flagOn= YES;
        vl.mobile= [NLUtils getRegisterMobile];
        [NLUtils presentModalViewController:self newViewController:vl];
    }
}

- (void)OtherAction{
    
    /*新用户注册
    NLRegisterViewController *vl = [[NLRegisterViewController alloc] initWithNibName:@"NLRegisterViewController" bundle:nil];
    vl.myViewControllerType = TFBRegisterVCRegister;
    [NLUtils presentModalViewController:self newViewController:vl];*/

    NewLoginView *vl = [[NewLoginView alloc] initWithNibName:@"NewLoginView" bundle:nil];
    [NLUtils presentModalViewController:self newViewController:vl];
}

//当前的类型 设置状态
- (void)updateInfoLabel
{
    
    NSString* infoText;
    self.infoLabel.text = infoText;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - readKuaiDicmpList
-(void)showErrorInfo:(NSString*)error status:(NLHUDState)status
{
    [self.myHUD hide:YES];
    self.myHUD = [[NLProgressHUD alloc] initWithParentView: self.view];
    
    switch (status)
    {
        case NLHUDState_Error:
        {
            self.myHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unCheckmark.png"]] ;
            self.myHUD.mode = MBProgressHUDModeCustomView;
            self.myHUD.detailsLabelText = error;
            [self.myHUD show:YES];
            [self.myHUD hide:YES afterDelay:2];
        }
            break;
            
        case NLHUDState_NoError:
        {
            self.myHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.png"]] ;
            self.myHUD.mode = MBProgressHUDModeCustomView;
            self.myHUD.labelText = error;
            [self.myHUD show:YES];
            [self.myHUD hide:YES afterDelay:2];
        }
            break;
            
        case NLHUDState_None:
        {
            self.myHUD.labelText = error;
            [self.myHUD show:YES];
        }
            break;
            
        default:
            break;
    }
    
    return;
}


-(void)shakeView:(UILabel*)viewToShake
{
    CGFloat t =4.0;
    CGAffineTransform translateRight  =CGAffineTransformTranslate(CGAffineTransformIdentity, t,0.0);
    CGAffineTransform translateLeft =CGAffineTransformTranslate(CGAffineTransformIdentity,-t,0.0);
    
    viewToShake.transform = translateLeft;
    
    [UIView animateWithDuration:0.08 delay:0.0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{
        [UIView setAnimationRepeatCount:2.0];
        viewToShake.transform = translateRight;
        
    } completion:^(BOOL finished){
        if(finished){
            [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                viewToShake.transform =CGAffineTransformIdentity;
            } completion:NULL];
        }
    }];
}

@end
