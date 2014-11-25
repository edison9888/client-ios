//
//  NLLoginView.m
//  TongFubao
//
//  Created by  俊   on 14-10-22.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "NLLoginView.h"

@interface NLLoginView ()
{
    NLProgressHUD* _hud;
    NSString* _ispaypwd;
}
@end

@implementation NLLoginView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [IQKeyboardManager enableKeyboardManger];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self viewinmain];
}

-(void)viewinmain
{
    [self addRightButtonItemWithTitle:@"切换账户"];
//    [self addleftButtonItemWithTitle:@"通付宝" useEnabled:YES];
//    [IQKeyboardManager disableKeyboardManager];
    
    NSArray * DLArr = [[NSUserDefaults standardUserDefaults]objectForKey:@"DLarray"];
    if (_flagOn==YES) {
        _lablePhone.text= _mobile;
    }else if (_flagChange == YES || _flagdenchu == YES)
    {
        _lablePhone.text= [NLUtils getRegisterMobile];
    }else{
          _lablePhone.text=  [[DLArr valueForKey:@"phonetextfiledDL"] objectAtIndex:0];
    }
}

- (IBAction)BtnOnClick:(UIButton *)sender {
    if (sender.tag==3) {
        /*登陆密码*/
        if ([self checkData]) {
             [self loginUrl];
        }
    }else if (sender.tag==4){
        id thisClass = [[NSClassFromString(@"NewLoginView") alloc] initWithNibName:@"NewLoginView" bundle:nil];
        [NLUtils presentModalViewController:self newViewController:thisClass];
    }else{
        NLRegisterViewController *vl = [[NLRegisterViewController alloc] initWithNibName:@"NLRegisterViewController" bundle:nil];
        vl.myViewControllerType = sender.tag == 1 ? TFBRegisterVCRegister:TFBRegisterVCFind;
        [NLUtils presentModalViewController:self newViewController:vl];
    }
}

-(BOOL)checkData
{
    BOOL check = YES;
    check = [NLUtils checkPassword:_passwordTF.text];
    if (!check)
    {
        [self showErrorInfo:@"请填入正确的密码" status:NLHUDState_Error];
        check = NO;
        return check;
    }
    if (_passwordTF.text.length < 6)
    {
        [self showErrorInfo:@"请填入正确位数的密码" status:NLHUDState_Error];
        check = NO;
        return check;
    }
    return check;
}

-(void)loginUrl{
    NSString *gestureStr= @"";
    NSString* name = [NLUtils getNameForRequest:Notify_ApiAuthorInfoV2Gesture];
    REGISTER_NOTIFY_OBSERVER(self, checkAuthorLoginNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApiAuthorInfoV2gesturepasswd:gestureStr paypasswd:_passwordTF.text mobile:_lablePhone.text];
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
}

-(void)checkAuthorLoginNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    if (RSP_NO_ERROR == error)
    {
        [self docheckAuthorLoginNotify:response];
    }
    else
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

-(void)docheckAuthorLoginNotify:(NLProtocolResponse*)response
{
    [_hud hide:YES];
    [NLUtils setAuthorid:[response.data find:@"msgbody/authorid" index:0].value];
    [NLUtils set_req_token:[response.data find:@"msgbody/req_token" index:0].value];
    /*** madfrog add 6.20***/
    [NLUtils setAgentid:[response.data find:@"msgbody/agentid" index:0].value];
    /*relateAgent字段*/
    [NLUtils setRelateAgent:[response.data find:@"msgbody/relateAgent" index:0].value];
    /*Agenttypeid字段 0/1/2 */
    [NLUtils setAgenttypeid:[response.data find:@"msgbody/agenttypeid" index:0].value];
    /*Agenttypeid*/

    [NLUtils setLogonDate];
    [NLUtils setLogonPassword:_passwordTF.text];
    [NLUtils get_req_token];//加密后获取的数据
    [NLUtils setRegisterMobile:_lablePhone.text];
    [NLUtils setIspaypwd:[response.data find:@"msgbody/ispaypwd" index:0].value];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PhoneNoFlag"];
    
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
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"NLLoginView"]!=nil) {
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"NLLoginView"];
        }
        
        NSMutableArray *array= [NSMutableArray array];
        [array addObject:@{ @"Mobile" : _lablePhone.text, @"gesturepasswd" : [response.data find:@"msgbody/gesturepasswd" index:0].value , @"authorid" : [response.data find:@"msgbody/authorid" index:0].value , @"agentid" : [response.data find:@"msgbody/agentid" index:0].value , @"agenttypeid" : [response.data find:@"msgbody/agenttypeid" index:0].value, @"passwd" : _passwordTF.text}];
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"NLLoginView"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        /*忘记手势密码界面来的*/
        if ( _flagOn == YES) {
            GestureToLogin *ges= [[GestureToLogin alloc]init];
            [NLUtils presentModalViewController:self newViewController:ges];
            
        }else{
     
            /*0 未设置 1已设置 未设置 判断后台手势密码来的*/
            if ([[response.data find:@"msgbody/gesturepasswd" index:0].value isEqualToString:@"0"])
            {
                GestureToLogin *ges= [[GestureToLogin alloc]init];
                [NLUtils presentModalViewController:self newViewController:ges];
                //            [NLUtils showAlertView:nil message:@"是否设置手势密码" delegate:self tag:2 cancelBtn:@"取消" other:@"确定"];
            }else
            {
                
                NLAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
                
                /*** 代理商 or 普通 ***/
                if ([[NLUtils getAgenttypeid] isEqualToString:@"0"])
                {
                    [delegate backToMain];
                }else
                {
                    [delegate backToTFAgent];
                }

            }
            
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 1 ) {
        GestureToLogin *ges= [[GestureToLogin alloc]init];
        [NLUtils presentModalViewController:self newViewController:ges];
    }
}

-(void)rightItemClick:(UIBarButtonItem *)sender
{
    id thisClass = [[NSClassFromString(@"NewLoginView") alloc] initWithNibName:@"NewLoginView" bundle:nil];
    [NLUtils presentModalViewController:self newViewController:thisClass];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showErrorInfo:(NSString*)detail status:(NLHUDState)status
{
    //    [self oneFingerTwoTaps];
    [_hud hide:YES];
    _hud = [[NLProgressHUD alloc] initWithParentView:self.view];
    switch (status)
    {
        case NLHUDState_Error:
        {
            _hud.detailsLabelText = detail;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unCheckmark.png"]] ;
            _hud.mode = MBProgressHUDModeCustomView;
            [_hud show:YES];
            [_hud hide:YES afterDelay:2];
            
        }
            break;
            
        case NLHUDState_NoError:
        {
            _hud.labelText = detail;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.png"]] ;
            _hud.mode = MBProgressHUDModeCustomView;
            [_hud show:YES];
            [_hud hide:YES afterDelay:2];
            
        }
            break;
            
        case NLHUDState_None:
        {
            _hud.labelText = detail;
            [_hud show:YES];
        }
            
        default:
            break;
    }
    return;
}


@end
