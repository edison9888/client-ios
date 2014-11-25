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

-(void)nav{
    
    self.title= @"修改密码";
    
    UIButton* backButton = [NLUtils createNavigationLeftBarButtonImage];
    
    [backButton setBackgroundImage:[UIImage imageNamed:@"navigationLeftBtnBack2"] forState:UIControlStateNormal];
    
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    
}

-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma 用户登录接口
- (void)LoginViewIsGestureURL{
    
    NSString *payStr= [[DLArr valueForKey:@"passwordConfirmFieldDL"]objectAtIndex:0];
    /*
     self.authorid= [[DLArr valueForKey:@"authoridDL"]objectAtIndex:0];
     
     [NLUtils setAuthorid:self.authorid];*/
    
    NSString* name = [NLUtils getNameForRequest:Notify_ApiAuthorInfoV2GestureToHander];
    
    REGISTER_NOTIFY_OBSERVER(self, GestureNotifyOther, name);
    
    if (_loginFlage==YES) {
        
        [[[NLProtocolRequest alloc] initWithRegister:YES]getApiAuthorInfoV2gesturepasswdTohander:gestureStr paypasswd:payStr mobile:_loginMobile];
        
        [NLUtils setRegisterMobile:_loginMobile];
        
    }else{
        
        [[[NLProtocolRequest alloc] initWithRegister:YES]getApiAuthorInfoV2gesturepasswdTohander:gestureStr paypasswd:payStr mobile:mobile];
        [NLUtils setRegisterMobile:mobile];
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
        if (num>1) {
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
                
                NewLoginView *new= [[NewLoginView alloc]initWithNibName:@"NewLoginView" bundle:nil];
                [self presentViewController:new animated:YES completion:nil];
            }
        }
        
        if (!detail || detail.length <= 0)
        {
            detail = @"请求失败，请检查网络";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}


- (void)doGestureNotify:(NLProtocolResponse*)response{
    
    
    NLProtocolData* payPaawd = [response.data find:@"msgbody/paypasswd" index:0];
    
    self.payPasswd = payPaawd.value;
    
    [NLUtils setPaypasswd:self.payPasswd];
    
    [NLUtils setLogonDate];
    
    [NLUtils set_req_token:nil];//加密后获取的数据
    
    NLProtocolData* data = [response.data find:@"msgbody/result" index:0];
    
    NSString *result = data.value;
    
    NSRange range = [result rangeOfString:@"succ"];
    
    if (range.length <= 0)
    {
        NLProtocolData* data = [response.data find:@"msgbody/message" index:0];
        
        NSString* value = data.value;
        
        NSLog(@"value %@",value);
        
        [self showErrorInfo:value status:NLHUDState_Error];
        
    }
    else
    {
        /*** madfrog add 6.20***/
        NLProtocolData* agentidStr = [response.data find:@"msgbody/agentid" index:0];
        NSString  *agentid = agentidStr.value;
        [NLUtils setAgentid:agentid];
        
        NLProtocolData* authoridStr = [response.data find:@"msgbody/authorid" index:0];
        NSString  *authorid = authoridStr.value;
        [NLUtils setAuthorid:authorid];
        /*** madfrog add 6.20***/
        
        /*relateAgent字段*/
        NLProtocolData* relateAgent = [response.data find:@"msgbody/relateAgent" index:0];
        NSString  *relateAgentStr = relateAgent.value;
        [NLUtils setRelateAgent:relateAgentStr];
        
        /*relateAgent*/
        
        /*agenttypeid字段 0普通/1正式/2虚拟 */
        NLProtocolData* agenttypeid = [response.data find:@"msgbody/agenttypeid" index:0];
        NSString  *agenttypeidStr = agenttypeid.value;
        [NLUtils setAgenttypeid:agenttypeidStr];
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
                    NLLogonPWManagerViewController* vc =  [[NLLogonPWManagerViewController alloc] initWithNibName:@"NLLogonPWManagerViewController" bundle:nil];
                    vc.gesturFlag =YES;
                    vc.mobile=[NLUtils getRegisterMobile];
                    [NLUtils presentModalViewController:self newViewController:vc];
                }
                else{
                    
                    [TFData getTempData][MAIN_IS_ON_GESTURESE]=MAIN_IS_ON_GESTURESE;
                    
                    //用于判断重新注销登录的手势密码状态
                    [[TFData getTempData]removeObjectForKey:MAIN_IS_ON_NEWLOGINGESTURE];
                    
                    NLAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
                    
                    /*** madfrog mofify ***/
                    //增加一个判断，是代理商进入代理商界面，否则进入普通页面
                    NSString *agentId = [NLUtils getAgentid];
                    if (agentId.length<=0||[[NLUtils getAgentid] isEqualToString:@"0"]) {
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
        if (_loginFlage==YES) {
            
            lablePeople.text= [NSString stringWithFormat:@"%@",_loginMobile];
            
        }else{
            
            lablePeople.text= [NSString stringWithFormat:@"%@",mobile];
            
        }
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
        
        lable.text= @"修改登陆密码";
        
        [self nav];
        
        UIButton *btn= [UIButton buttonWithType:UIButtonTypeCustom];
        //        [btn setTitle:@"返回" forState:UIControlStateNormal];
        [btn setFrame:CGRectMake(10, 44, 30.5, 30.5)];
        
        [btn setBackgroundColor:[UIColor clearColor]];
        
        [btn setImage:[UIImage imageNamed:@"navigationLeftBtnBack2"] forState:UIControlStateNormal];
        
        //        [btn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
        
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        
    }else{
         UIImageView *viewlo= [[UIImageView alloc]init];
        if (IOSVERSion>=7.0) {
            if (IOS7_OR_SCREEN) {
                 viewlo.frame= CGRectMake(95+16*IOS7IPHONE4, 30, 130*IOS7IPHONE4, 130*IOS7IPHONE4);
            }else{
                 viewlo.frame= CGRectMake(95, 30, 130*IOS7IPHONE4, 130*IOS7IPHONE4);
            }
        }else{
             viewlo.frame= CGRectMake(95, 20, 130*IOS7IPHONE4, 130*IOS7IPHONE4);
        }
        viewlo.image= [UIImage imageNamed:@"gestlogin"];
        [self.view addSubview:viewlo];
        [self btnInGesture];
    }
    
    lable.backgroundColor= [UIColor clearColor];
    lable.font= [UIFont systemFontOfSize:20];
    lable.textColor= [UIColor whiteColor];
    [self.view addSubview:lable];
    
}

-(void)btnInGesture{
    
    self.clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.clearButton.frame = CGRectMake(25, self.view.frame.size.height-40, 120, 30);
    [self.clearButton setTitle:@"忘记手势密码" forState:UIControlStateNormal];
    [self.clearButton setTintColor:[UIColor whiteColor]];
    [self.clearButton addTarget:self action:@selector(clearPassword) forControlEvents:UIControlEventTouchUpInside];
    self.clearButton.backgroundColor=[UIColor clearColor];
    [self.view addSubview:self.clearButton];
    
    self.OtherButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.OtherButton.frame = CGRectMake(180, self.view.frame.size.height-40, 120, 30);
    [self.OtherButton setTitle:@"新注册用户" forState:UIControlStateNormal];
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
    [self LoginViewIsGestureURL];
    [self updateInfoLabel];
}

//忘记密
- (void)clearPassword
{
    
    NewLoginView *ge= [[NewLoginView alloc]initWithNibName:@"NewLoginView" bundle:nil];
    
    [self presentModalViewController:ge animated:YES];
}

- (void)OtherAction{
    
    NLRegisterViewController *vl = [[NLRegisterViewController alloc] initWithNibName:@"NLRegisterViewController" bundle:nil];
    vl.myViewControllerType = TFBRegisterVCRegister;
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
