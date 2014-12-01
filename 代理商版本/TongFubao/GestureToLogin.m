//
//  GestureToLogin.m
//  TongFubao
//
//  Created by  俊   on 14-5-6.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "GestureToLogin.h"
#import "MJPasswordView.h"
#import "NLProgressHUD.h"
#import "NLContants.h"
#import "FeedController.h"
#import "NLUtils.h"

@interface GestureToLogin ()<MJPasswordDelegate>
{
    NLProgressHUD* _hud;
    NSString *gestureStr;//手势密码的
    NSString *oldpasswd;
    NSString *newpasswd;
    NSString *aumoditype;
    NSString *reset;
    NSString *authorid;
    NSString *JumpType;
    int  IOS7IPHONE4;
    BOOL flagYes;
}
@property (nonatomic,copy) NSString* password;

@property (nonatomic,retain) UILabel* infoLabel;

@property (nonatomic,retain) MJPasswordView* passwordView;

@property (nonatomic,retain) NSMutableArray *markBtArr;

@property (nonatomic,strong)NLProgressHUD* myHUD;

@property(nonatomic,assign) NLPushViewType myNextType;
@end

@implementation GestureToLogin

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma 用户登录接口
- (void)LoginViewIsGestureTologin{

    oldpasswd  = @"";
    newpasswd  = self.password;
    aumoditype = @"1";
    reset      = @"1";
    NSString* name = [NLUtils getNameForRequest:Notify_ApiAuthorInfoPasswordToChage];
    REGISTER_NOTIFY_OBSERVER(self, GestureNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES]getApiAuthorInfoPasswordToChage:oldpasswd newpassword:newpasswd aumoditype:aumoditype reset:reset];
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
}

- (void)GestureNotify:(NSNotification*)notify{
    
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        [self doGestureNotify:response];
    }else
    {
        [_hud hide:YES];
        NSString *detail = response.detail;
        if (!detail || detail.length <= 0)
        {
            detail = @"服务器繁忙，请稍候再试";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

- (void)doGestureNotify:(NLProtocolResponse*)response{
    
    NLProtocolData* data = [response.data find:@"msgbody/result" index:0];
    NSString *result = data.value;
    NSRange range = [result rangeOfString:@"succ"];
    [self showErrorInfo:@"手势密码设置成功" status:NLHUDState_NoError];
    if (range.length <= 0)
    {
        NLProtocolData* data = [response.data find:@"msgbody/message" index:0];
        NSString* value = data.value;
        [self showErrorInfo:value status:NLHUDState_Error];
    }else{

        [self showErrorInfo:@"设置成功" status:NLHUDState_NoError];
  
        /*保存当前的账户 用户判断是否有设置手势密码*/
        NSMutableArray *havegesture= [NSMutableArray array];
        [havegesture addObject:@{ @"Mobile" : [[[[NSUserDefaults standardUserDefaults]objectForKey:@"DLarray"] valueForKey:@"phonetextfiledDL"] objectAtIndex:0], @"gesturepasswd" : @"1" }];
        
        [[NSUserDefaults standardUserDefaults] setObject:havegesture forKey:@"NLLoginView"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    
        //手势判断次数 存本地
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",5] forKey:KEY_RECORD_GESTURE_NUM];
        [[NSUserDefaults standardUserDefaults]synchronize];
  
        /*
    //更多注销设置判断值
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"LoginOut"];
    [[NSUserDefaults standardUserDefaults]synchronize];
        */
        if ([JumpType isEqualToString:@"finish"] ) {
            
            [TFData getTempData][MAIN_IS_ON_NEWLOGINGESTURE]=MAIN_IS_ON_NEWLOGINGESTURE;
            
            NLAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
            
            /*** madfrog mofify ***/
            //增加一个判断，是代理商进入代理商界面，否则进入普通页面
            if (_settingFlag==YES) {
                
                NLMoreViewController *vl = [[NLMoreViewController alloc] initWithNibName:@"NLMoreViewController" bundle:nil];
                vl.settingFlag= YES;
                /*agenttypeid字段 0普通/1正式/2虚拟 */
                NSString *agentID= [NLUtils getAgenttypeid];
                if (![agentID isEqualToString:@"0"]) {
                    vl.agentFlag= YES;
                }
                [NLUtils presentModalViewController:self newViewController:vl];
            }else{
                /*
                 NLRegisterViewController *vl = [[NLRegisterViewController alloc] initWithNibName:@"NLRegisterViewController" bundle:nil];
                 vl.myViewControllerType = TFBRegisterVCRegister;
                 [NLUtils presentModalViewController:self newViewController:vl];
                 */
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

//获取对应的case跳转前注册页面
- (void) doPush: (id) nc
{
    UIViewController* vc = [[NLPushViewIntoNav sharePushViewIntoNav] getPushViewIntoNavByType:self.myNextType];
    if (vc)
    {
        [nc pushViewController:vc animated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
//    
//    ViewControllerProperty;
//    
//#endif
    self.title= @"设置手势密码";
    [self addRightButtonItemWithTitle:@"跳过"];
    IOS7IPHONE4=IOS7_OR_LATER==YES?0:64;
    
    //渐变拉升
    self.view.backgroundColor= [UIColor colorWithPatternImage:[NLUtils stretchImage:[UIImage imageNamed:@"bg_gradients@2x"] edgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)]];
    
    self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 130, 300, 30)];
    self.infoLabel.backgroundColor = [UIColor clearColor];
    self.infoLabel.font= [UIFont systemFontOfSize:17];
    
    //记录密码
    UIView *tempView = [[UIView alloc]initWithFrame:CGRectMake(20, 20, 100, 100)];
    tempView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tempView];
    _markBtArr = [[NSMutableArray alloc]init];
    
    for (int i=0; i<9; i++) {
        UIImageView *singleImg = [[UIImageView alloc]initWithFrame:CGRectMake(125+12*(i%3), 70+12*(i/3)-IOS7IPHONE4/1.3, 9.5, 9.5)];
        singleImg.tag = i;
        singleImg.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"small_circle_normal"]];
        [tempView addSubview:singleImg];
        [_markBtArr addObject:singleImg];
        
        if ([[UIDevice currentDevice].systemVersion floatValue]>=6.0)
        {
            self.infoLabel.textAlignment =  NSTextAlignmentCenter;
        }
        else
        {
            self.infoLabel.textAlignment = UITextAlignmentCenter;
        }
        self.infoLabel.textColor = [UIColor whiteColor];
        [self.view addSubview:self.infoLabel];
        
        CGRect frame = CGRectMake(0, 120, self.view.bounds.size.width, self.view.bounds.size.height);
        self.passwordView = [[MJPasswordView alloc] initWithFrame:frame];
        self.passwordView.delegate = self;
        [self updateInfoLabel];
        [self.view addSubview:self.passwordView];
    }

    CGRect frame = CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.height);
    self.passwordView = [[MJPasswordView alloc] initWithFrame:frame];
    self.passwordView.delegate = self;
    [self updateInfoLabel];
    [self.view addSubview:self.passwordView];
}

//当前的类型 设置状态
- (void)updateInfoLabel
{
    
    NSString* infoText;
    switch (self.state)
    {
        case ePasswordUnset:
            infoText = @"绘制解锁图案";
            break;
        case ePasswordRepeat:
        {
            [self recordBt];
            self.infoLabel.textColor= [UIColor whiteColor];
            infoText = [NSString stringWithFormat:@"再次绘制解锁图案"];
            self.state= ePasswordExist;
            NSLog(@"密码%@",self.password);
        }
            break;
        case ePasswordExist:
        {
            //路径
            [self recordBt];
            if (flagYes != YES)
            {
                self.infoLabel.textColor= [UIColor redColor];
                _gestAgainBtn.hidden= NO;
                infoText = [NSString stringWithFormat:@"与上一次绘制不一致，请重新绘制"];
            }else
            {
                self.infoLabel.textColor= [UIColor whiteColor];
                infoText = [NSString stringWithFormat:@"再次绘制解锁图案"];
            }
        }
            break;
        default:
            break;
    }
    self.infoLabel.text = infoText;
}

-(void)rightItemClick:(id)sender
{
    /*保存当前的账户 用户判断是否有设置手势密码*/
    NSMutableArray *havegesture= [NSMutableArray array];
    [havegesture addObject:@{ @"Mobile" : [[[[NSUserDefaults standardUserDefaults]objectForKey:@"DLarray"] valueForKey:@"phonetextfiledDL"] objectAtIndex:0], @"gesturepasswd" : @"0" }];
    [[NSUserDefaults standardUserDefaults] setObject:havegesture forKey:@"NLLoginView"];
    [[NSUserDefaults standardUserDefaults]synchronize];

    NLAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate backToMain];
}

- (IBAction)btnAganin:(id)sender {
    
    self.state =ePasswordUnset;
    self.infoLabel.textColor= [UIColor whiteColor];
    self.infoLabel.text= @"绘制解锁图案";
    _gestAgainBtn.hidden =YES;
    for (int i =0; i<_markBtArr.count; i++) {
        UIImageView *singleImg = (UIImageView *)(_markBtArr[i]);
        singleImg.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"small_circle_normal"]];
    }

}

//当设置手势完成之后的进入的第一个方法
- (void)passwordView:(MJPasswordView*)passwordView withPassword:(NSString*)password
{
    //确定当前的状态
    switch (self.state)
    {
        case ePasswordUnset://未设置
        {
            self.password = password;//当前设置的密码
            
            gestureStr= password;
            
            self.state = ePasswordRepeat;
            
            [self recoveryBt];
        }
            break;
            
        case ePasswordRepeat://重复输入
            
            [self recoveryBt];
            
            if ([password isEqualToString:self.password])
            {
                self.state = ePasswordExist;
                
                [self showErrorInfo:@"设 置 成 功" status:NLHUDState_Error];
            }else{
            
                [self shakeView:_infoLabel];
            }
                break;

            case ePasswordExist://密码设置成功
            
           
            if ([password isEqualToString:self.password])
            {
                flagYes= YES;
                JumpType = @"finish";
                [NLUtils setAgentid:_agentidLogin];
                [NLUtils setAgenttypeid:_agentidtypeLogin];
                [self performSelector:@selector(LoginViewIsGestureTologin) withObject:nil afterDelay:0.5];
            }
            else
            {
                [self shakeView:_infoLabel];
            }
            
            break;
            default:
            break;
      
    }
    [self updateInfoLabel];
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

/*
 - (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
 {
 [self dismissModalViewControllerAnimated:YES];
 
 }
 */
//按钮记录路径
-(void)recordBt
{
    
    for (int i =0; i<_markBtArr.count; i++) {
        UIImageView *singleImg = (UIImageView *)(_markBtArr[i]);
        NSRange range = [self.password rangeOfString:[NSString stringWithFormat:@"%d",singleImg.tag]];
        if (range.length > 0) {
            singleImg.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"small_circle_selected"]];
        }else{
            singleImg.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"small_circle_normal"]];
        }
    }
}

//应该放置确定密码那里
-(void)recoveryBt
{
    for (int i =0; i<_markBtArr.count; i++) {
        UIImageView *singleImg = (UIImageView *)(_markBtArr[i]);
        singleImg.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"small_circle_normal"]];
    }
}

@end


