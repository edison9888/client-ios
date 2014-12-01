//
//  SecretText.m
//  TongFubao
//
//  Created by  俊   on 14-6-4.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "SecretText.h"
#import "MLTableAlert.h"
#import "NLFindPasswordViewController.h"
#import "NLLogonPWManagerViewController.h"

@interface SecretText ()
{
       int        IOS7HEIGHT;
       NLProgressHUD    * _hud;
       NSString         * msgallcount;
       NSString    *quecount;
       NSString    *btnTitle;
       UIButton    *BtnTag;
       UIImageView *queidicon1;
       UIImageView *queidicon2;
       UIImageView *queidicon3;
       UIImageView *image;
       NSString    *queid1;
       NSString    *queid2;
       NSString    *queid3;
       NSString    *queStr;
       NSString    *answerStr;
       NSDictionary *dicty;
       NSMutableArray *queArray;
    
      int rowCount;
    
}
@property (strong, nonatomic)  MLTableAlert *alert;
@property (nonatomic,strong)   NLProgressHUD* myHUD;
@property (nonatomic,copy)     NSString* authorid;
@property (nonatomic,strong)   UITableView *ddTableView;
@property(nonatomic, strong)   NSMutableArray    *myArray;
@property (strong, nonatomic)  UITextField *Answer2;
@property (strong, nonatomic)  UITextField *Answer3;
@property (strong, nonatomic)  UIButton *Btn2;
@property (strong, nonatomic)  UIButton *Btn3;
@property (strong, nonatomic)  UIImageView *Icon2;
@property (strong, nonatomic)  UIImageView *Icon3;
@property(nonatomic,getter=isOn) BOOL on;

@property (weak, nonatomic) IBOutlet UIImageView *Icon1;
@property (weak, nonatomic) IBOutlet UIButton *Btn1;
@property (weak, nonatomic) IBOutlet UIButton *SubmitBtn;
@property (weak, nonatomic) IBOutlet UILabel  *lableText;
@property (weak, nonatomic) IBOutlet UITextField *Answer1;
@property (weak, nonatomic) IBOutlet UISwitch *Switch;
@property (strong, nonatomic) IBOutlet UIScrollView *Scroller;

@property (nonatomic,strong) NSMutableDictionary *firstDict;
@property (nonatomic,strong) NSMutableDictionary *secondDict;
@property (nonatomic,strong) NSMutableDictionary *thirdDict;
@property (nonatomic,strong) NSMutableArray *pushArray;


@end

@implementation SecretText
@synthesize on=_on,Scroller,myArray,ddTableView,UserBool;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//接口
-(void)SafeGuardIsOn
{
    [NLUtils getAuthorid];
    NSString* name = [NLUtils getNameForRequest:Notify_ApiSafeGuardIsOn];
    REGISTER_NOTIFY_OBSERVER(self, SafeGuardIsOnNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApiSafeGuard];
   
}

//密保问题
-(void)SafeGuardIsOnNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        
        [self doSafeGuardIsOnNotifyNotify:response];
    }
    else if (error == RSP_TIMEOUT)
    {
        [self showErrorInfo:@"请求超时,需要重新登录" status:NLHUDState_Error];
        [self performSelector:@selector(doPush) withObject:nil afterDelay:2.0f];
        return;
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


-(void)doSafeGuardIsOnNotifyNotify:(NLProtocolResponse*)response
{
    
    myArray = [NSMutableArray array];
    
    NLProtocolData* data = [response.data find:@"msgbody/result" index:0];
    
    NSString *result = data.value;
    
    NSRange range = [result rangeOfString:@"succ"];
    
    if (range.length <= 0)
    {
        NLProtocolData* data = [response.data find:@"msgbody/message" index:0];
        
        NSString* value = data.value;
        [self showErrorInfo:value status:NLHUDState_Error];
    }
    else{
        
        NSArray *queidArray= [response.data find:@"msgbody/msgchild/queid"];
        
        NSArray *quecontentArray= [response.data find:@"msgbody/msgchild/quecontent"];
        
        NLProtocolData* msgllcontArray = [response.data find:@"msgbody/msgallcount" index:0];
        
        NSString *queid= nil;
        
        NSString *quecontent= nil;
      
        msgallcount = msgllcontArray.value;
        
        for (int i=0; i< queidArray.count; i++) {
         
            NLProtocolData* data = [queidArray objectAtIndex:i];
    
            queid = data.value;
            
            data = [quecontentArray objectAtIndex:i];
            
            quecontent = data.value;
            
            NSDictionary *dict= [NSDictionary dictionaryWithObjectsAndKeys: queid,@"queid",quecontent,@"quecontent", nil];
            
             [myArray addObject:dict];
        }
    }
}


-(NSString *)checkInfo:(NSString *)str
{
    if (str == nil)
    {
        return @"未知";
    }
    else
    {
        return str;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (UserBool!=YES) {
        
        [self SafeGuardIsOn];
        
    }else{

    }
    [self MainView];
}


-(void)MainView{
    
    IOS7HEIGHT=IOS7_OR_LATER==YES?0:64;
    
    Scroller.contentSize= CGSizeMake(self.Scroller.frame.size.width, IOS7HEIGHT+630);
    
    UIButton* backButton = [NLUtils createNavigationLeftBarButtonImage];
    
    [backButton setBackgroundImage:[UIImage imageNamed:@"navigationLeftBtnBack2"] forState:UIControlStateNormal];
    
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.Scroller.backgroundColor= RGBACOLOR(246, 250, 251, 1);
    
    UITapGestureRecognizer *oneFingerTwoTaps = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(oneFingerTwoTaps)];
    // Set required taps and number of touches
    [oneFingerTwoTaps setNumberOfTapsRequired:2];
    
    [self.view addGestureRecognizer:oneFingerTwoTaps];
    
    //光标右移输入
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 11, 30)];
    
    self.Answer1.leftView = paddingView1;
    
    self.Answer1.leftViewMode = UITextFieldViewModeAlways;
    
    [self.Scroller addSubview:_Answer1];
    
    [_Btn1 addTarget:self action:@selector(Btn:) forControlEvents:UIControlEventTouchUpInside];
   
    _Switch.frame= CGRectMake(self.Switch.frame.origin.x, self.Switch.frame.origin.y, 78, 35);
    
    _Switch.onImage= [UIImage imageNamed:@"onside"];
    
    _Switch.offImage= [UIImage imageNamed:@"offside"];
    
    [_Switch addTarget:self action:@selector(setOn:animated:) forControlEvents:UIControlEventValueChanged];
    
    [self.Scroller addSubview:_Switch];
    
    if (UserBool==YES) {
        
        self.navigationController.topViewController.title= @"找回密码";
        
        UILabel *lable= [[UILabel alloc]initWithFrame:CGRectMake(16, 20, 220, 30)];
        
//        lable.text= [NSString stringWithFormat:@"账户：%@",_phoneNumber];
        
        lable.textColor= [UIColor blackColor];
        
        lable.font= [UIFont systemFontOfSize:18];
        
        [self.view addSubview:lable];
        
        _Answer1.frame= CGRectMake(self.Answer1.frame.origin.x, self.Answer1.frame.origin.y+55, self.Answer1.frame.size.width, self.Answer1.frame.size.height);
        
        _Btn1.frame= CGRectMake(self.Btn1.frame.origin.x, self.Btn1.frame.origin.y+45, self.Btn1.frame.size.width, self.Btn1.frame.size.height);
        
        _Icon1.frame= CGRectMake(self.Icon1.frame.origin.x, self.Icon1.frame.origin.y+45, self.Icon1.frame.size.width, self.Icon1.frame.size.height);
        
        self.Scroller.scrollEnabled= NO;
        
        _SubmitBtn.frame= CGRectMake(self.SubmitBtn.frame.origin.x, self.SubmitBtn.frame.origin.y, 288, 40);
        
        [_SubmitBtn setTitle:@"提交并重设密码" forState:UIControlStateNormal];
        
        [self.Scroller addSubview:_SubmitBtn];
        
        [_lableText setHidden:YES];
        
        [_Switch setHidden:YES];
        
        
    }else{
        
        self.navigationController.topViewController.title= @"设置密保问题";
        
        _SubmitBtn.frame= CGRectMake(self.SubmitBtn.frame.origin.x, self.SubmitBtn.frame.origin.y, 288, 40);
        
        [self.Scroller addSubview:_SubmitBtn];

    }
    
}


- (void)setOn:(BOOL)on animated:(BOOL)animated{
    
    if (_Switch.on==YES) {
        
        [_Btn2 setHidden:YES];
        [_Btn3 setHidden:YES];
        [_Answer2 setHidden:YES];
        [_Answer3 setHidden:YES];
        
        
        _SubmitBtn.frame= CGRectMake(self.SubmitBtn.frame.origin.x, self.SubmitBtn.frame.origin.y-250-IOS7HEIGHT, 288, 40);
    }else{
        
        _Btn2= [UIButton buttonWithType:UIButtonTypeCustom];
        
        _Btn2.frame= CGRectMake(16, 175, 288, 40);
        
        _Btn2.tag= 102;
        
        [_Btn2 setBackgroundImage:[UIImage imageNamed:@"input_fieldside.png"] forState:UIControlStateNormal];
        
        [_Btn2 setTitle:@"请选择密保问题二" forState:UIControlStateNormal];
        
//        [_Btn2 setTitleEdgeInsets:UIEdgeInsetsMake( 0.0, -120.0, 0.0,0.0)];
        
        [_Btn2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        _Icon2 = [[UIImageView alloc]initWithFrame:CGRectMake(254, 5, 30, 30)];
        
        [_Icon2 setImage:[UIImage imageNamed:@"chosenside.png"]];
       
        [_Btn2 addSubview:_Icon2];
        
        [_Btn2 setBackgroundColor:[UIColor clearColor]];
        
        [_Btn2 addTarget:self action:@selector(Btn:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.Scroller addSubview:_Btn2];
    
        _Btn3= [UIButton buttonWithType:UIButtonTypeCustom];
        
        _Btn3.frame= CGRectMake(16, 285, 288, 40);
        
        _Btn3.tag= 103;
        
        [_Btn3 setBackgroundImage:[UIImage imageNamed:@"input_fieldside.png"] forState:UIControlStateNormal];
        
        [_Btn3 setTitle:@"请选择密保问题三" forState:UIControlStateNormal];
        
        [_Btn3 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        _Icon3 = [[UIImageView alloc]initWithFrame:CGRectMake(254, 5, 30, 30)];
        
        [_Icon3 setImage:[UIImage imageNamed:@"chosenside.png"]];
        
        [_Btn3 addSubview:_Icon3];
        
//        [_Btn3 setTitleEdgeInsets:UIEdgeInsetsMake( 0.0, -120.0, 0.0,0.0)];
        
        [_Btn3 setBackgroundColor:[UIColor clearColor]];
        
        [_Btn3 addTarget:self action:@selector(Btn:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.Scroller addSubview:_Btn3];
        
        _Answer2= [[UITextField alloc]init];
        
        [_Answer2 setBackground:[UIImage imageNamed:@"input_fieldside.png"]];
        
        _Answer2.placeholder= @"回答密保问题二";
        
        _Answer2.frame= CGRectMake(16, 230, 288, 40);
        
        _Answer3= [[UITextField alloc]init];
        
        [_Answer3 setBackground:[UIImage imageNamed:@"input_fieldside.png"]];
        
        _Answer3.placeholder= @"回答密保问题三";
        
        _Answer3.frame= CGRectMake(16, 340, 288, 40);

        
        UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 11, 30)];
        
        self.Answer2.leftView = paddingView2;
        
        self.Answer2.leftViewMode = UITextFieldViewModeAlways;
        
        UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 11, 30)];
        
        self.Answer3.leftView = paddingView3;
        
        self.Answer3.leftViewMode = UITextFieldViewModeAlways;
        
        [self.Scroller addSubview:_Answer2];
        
        [self.Scroller addSubview:_Answer3];
        
        _SubmitBtn.frame= CGRectMake(self.SubmitBtn.frame.origin.x, self.SubmitBtn.frame.origin.y+250+IOS7HEIGHT, 288, 40);
    }
    
}

-(void)Btn:(UIButton*)btn{
    BtnTag = [[UIButton alloc]init];
    BtnTag.tag=btn.tag;
    switch (btn.tag) {
        case 101:
        {
             [self showAlert];
        }
            break;
        case 102:
        {
            [self showAlert];
        }
          
            break;
        case 103:
        {
            [self showAlert];
                
        }
            break;
        default:
            break;
    }
    
}



-(void)showAlert{
   
    //找回密保问题
    if (UserBool==YES) {
        
        queArray= [NSMutableArray array];
        
        NSArray *queidArray= [_pushResponse.data find:@"msgbody/msgchild/que"];
        
        NSArray *quecontentArray= [_pushResponse.data find:@"msgbody/msgchild/answer"];
        
        NSString *que= nil;
        
        NSString *answer= nil;
        
        for (int i=0; i< queidArray.count; i++) {
            
            NLProtocolData* data = [queidArray objectAtIndex:i];
            
            que = data.value;
            
            data = [quecontentArray objectAtIndex:i];
            
            answer = data.value;
            
            NSMutableDictionary *dict= [NSMutableDictionary dictionaryWithObjectsAndKeys: que,@"que",answer,@"answer", nil];
            
            [queArray addObject:dict];
        }

        self.alert = [MLTableAlert tableAlertWithTitle:@"密保找回登陆密码" cancelButtonTitle:@"取消" numberOfRows:^NSInteger (NSInteger section)
                      {
                if ([queArray count]== 0 ){
                [self showErrorInfo:@"数据异常、请稍后再试" status:NLHUDState_Error];
                return 0;
                    }else
                return [queArray count];
                }
                andCells:^UITableViewCell* (MLTableAlert *anAlert, NSIndexPath *indexPath)
                    {
                          static NSString *CellIdentifier = @"CellIdentifier";
                          UITableViewCell *cell = [anAlert.table dequeueReusableCellWithIdentifier:CellIdentifier];
                          if (cell == nil){
                              
                              cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                          }
                          
                          cell.textLabel.text = [[queArray valueForKeyPath:@"que"] objectAtIndex:indexPath.row];
                          
                          return cell;
                      }];
        
        self.alert.height = 350;
        
        [self.alert configureSelectionBlock:^(NSIndexPath *selectedIndex){
            
            btnTitle= [NSString stringWithFormat:@"%@",[[queArray valueForKeyPath:@"que"] objectAtIndex:selectedIndex.row]];
            
            switch (BtnTag.tag) {
                case 101:
                    [self.Btn1 setTitle:btnTitle forState:UIControlStateNormal];
                    queid1= [[queArray valueForKeyPath:@"que"] objectAtIndex:selectedIndex.row];
                    _firstDict = [queArray objectAtIndex:selectedIndex.row];
                    
                    break;
                    default:
                    break;
            }
         
        } andCompletionBlock:^{
            
            [self showrror];
               }];
      
        [self.alert show];
        
        //设置密保问题的
    }else if (UserBool!=YES){
        
        self.alert = [MLTableAlert tableAlertWithTitle:@"设置密保" cancelButtonTitle:@"取消" numberOfRows:^NSInteger (NSInteger section)
                      {
                          if ([myArray count]== 0 ){
                              [self showErrorInfo:@"数据异常、请稍后再试" status:NLHUDState_Error];
                              return 0;
                          }else
                              return [myArray count];
                      }
                                              andCells:^UITableViewCell* (MLTableAlert *anAlert, NSIndexPath *indexPath)
                      {
                          static NSString *CellIdentifier = @"CellIdentifier";
                          UITableViewCell *cell = [anAlert.table dequeueReusableCellWithIdentifier:CellIdentifier];
                          if (cell == nil){
                              
                              cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                          }
                          
                          cell.textLabel.text = [[myArray valueForKeyPath:@"quecontent"] objectAtIndex:indexPath.row];
                          
                          return cell;
                      }];
        
        self.alert.height = 350;
        
        [self.alert configureSelectionBlock:^(NSIndexPath *selectedIndex){
            
            btnTitle= [NSString stringWithFormat:@"%@",[[myArray valueForKeyPath:@"quecontent"] objectAtIndex:selectedIndex.row]];
            
            switch (BtnTag.tag) {
                case 101:
                    [self.Btn1 setTitle:btnTitle forState:UIControlStateNormal];
                    queid1= [[myArray valueForKeyPath:@"queid"] objectAtIndex:selectedIndex.row];
                    _firstDict = [myArray objectAtIndex:selectedIndex.row];
                    
                    break;
                case 102:
                    [self.Btn2 setTitle:btnTitle forState:UIControlStateNormal];
                    queid2= [[myArray valueForKeyPath:@"queid"] objectAtIndex:selectedIndex.row];
                    _secondDict = [myArray objectAtIndex:selectedIndex.row];
                    
                    break;
                    
                case 103:
                    [self.Btn3 setTitle:btnTitle forState:UIControlStateNormal];
                    queid3= [[myArray valueForKeyPath:@"queid"] objectAtIndex:selectedIndex.row];
                    _thirdDict = [myArray objectAtIndex:selectedIndex.row];
                    
                    break;
                default:
                    break;
            }
            
            NSString *btn1text= _Btn1.titleLabel.text;
            NSString *btn2text= _Btn2.titleLabel.text;
            NSString *btn3text= _Btn3.titleLabel.text;
            
            if ([btn1text isEqualToString:btn2text]||
                    [btn1text isEqualToString:btn3text]||
                    [btn2text isEqualToString:btn3text]
                    )
                {
                    //                [myArray removeObjectAtIndex: selectedIndex.row];
                    [self showErrorInfo:@"您的密保已选择"];
                    [self showrror];
                }
           
        } andCompletionBlock:^{
            
            [self showrror];
            
        }];
        
        [self.alert show];
    }
}

-(void)showrror{
    
    switch (BtnTag.tag) {
        case 101:
            [self.Btn1 setTitle:@"请选择您的密保问题" forState:UIControlStateNormal];
            if (_firstDict!=nil) {
                [myArray addObject:_firstDict];
                _firstDict =nil;
            }
            break;
        case 102:
            [self.Btn2 setTitle:@"请选择您的密保问题" forState:UIControlStateNormal];
            if (_secondDict!=nil) {
                [myArray addObject:_secondDict];
                _secondDict =nil;
            }
            break;
            
        case 103:
            [self.Btn3 setTitle:@"请选择您的密保问题" forState:UIControlStateNormal];
            if (_thirdDict!=nil) {
                [myArray addObject:_thirdDict];
                _thirdDict =nil;
            }
            break;
        default:
            break;
    }

}

-(void)viewDidUnload{
    
    [self setOn:YES];
}

#pragma showError
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

//提示错误的
-(void)showErrorInfo:(NSString*)detail
{
    _hud = [[NLProgressHUD alloc] initWithParentView:self.view];
    if (detail)
    {
        _hud.detailsLabelText = detail;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unCheckmark.png"]] ;
        _hud.mode = MBProgressHUDModeCustomView;
        [_hud show:YES];
        [_hud hide:YES afterDelay:1];
    }
    else
    {
        [_hud show:YES];
    }
    return;
}


//提交
- (IBAction)OnclickBtn:(id)sender {
    
    if (_Answer1.text.length>=1) {
        
        if (UserBool!=YES) {
            
            [self SecretTextSettingURL];
            
        }else if(UserBool==YES){
            
            answerStr= [queArray valueForKeyPath:@"answer"];
            
            queStr= [queArray valueForKeyPath:@"que"];
            
            BOOL alertTag = YES;
            
            for (NSDictionary *answerQueDic in queArray) {
                
                if ([_Btn1.titleLabel.text isEqualToString:answerQueDic[@"que"]]) {
                    if ([_Answer1.text isEqualToString:answerQueDic[@"answer"]]) {
                        
                        //修改密码的
                        [self PushSecretPassWord];
                       
                        alertTag = NO;
                        
                        return;
                    }
                }
            }
            
            if (alertTag) {
                [self showErrorInfo:@"您的密保答案不正确" status:NLHUDState_Error];
            }
        }
        
    }else{
        [self showErrorInfo:@"请输入一个密保再确认提交"];
    }
}

//设置密码管理 修改密码的
- (void)PushSecretPassWord{
    
    NLLogonPWManagerViewController* vc =  [[NLLogonPWManagerViewController alloc] initWithNibName:@"NLLogonPWManagerViewController" bundle:nil];
     vc.PushFlag =YES;
     vc.mobile=[NLUtils getRegisterMobile];
    [NLUtils presentModalViewController:self newViewController:vc];
    
}

- (void)SecretTextSettingURL{
   
    NSString *answer1= _Answer1.text;
    
    NSString *answer2;
    
    NSString *answer3;
    
    if (_Answer2.text.length<=0) {
         answer2= @" ";
    }else{
         answer2= _Answer2.text;
    }
    if (_Answer3.text.length<=0) {
         answer3= @" ";
    }else{
        answer3= _Answer3.text;
    }

    NSArray *DLArr = [[NSUserDefaults standardUserDefaults]objectForKey:@"DLarray"];
    
    NSString *authorid= [[DLArr valueForKey:@"authoridDL"]objectAtIndex:0];
    
    [NLUtils setAuthorid:authorid];
   
    NSString* name = [NLUtils getNameForRequest:Notify_ApiSafeGuardSetting];
    
    REGISTER_NOTIFY_OBSERVER(self, SecretTextSettingNotify, name);
    
    [[[NLProtocolRequest alloc] initWithRegister:YES]getApiSafeGuardMsgchild:queid1 answer1:answer1 quechild2:queid2 answer2:answer2  quechild3:queid3 answer3:answer3];
    
}

- (void)SecretTextSettingNotify:(NSNotification*)notify{
  
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        
        [self doSecretTextSettingNotify:response];
        
    }
    else if (error == RSP_TIMEOUT)
    {
        [self showErrorInfo:@"请求超时,需要重新登录" status:NLHUDState_Error];
        [self performSelector:@selector(dopush) withObject:nil afterDelay:2.0f];
        return;
    }
    else
    {
        [_hud hide:YES];
        NSString *detail = response.detail;
        if (!detail || detail.length <= 0)
        {
            detail = @"服务器繁忙，请稍候再试";
        }
    }
}

- (void) dopush
{
    [self.myHUD hide:YES afterDelay:2];
    [NLUtils popToLogonVCByHTTPError:self feedOrLeft:1];
}

- (void)doSecretTextSettingNotify:(NLProtocolResponse*)response{
    
    NLProtocolData* data = [response.data find:@"msgbody/result" index:0];
    
    NSString *result = data.value;
    
    NSRange range = [result rangeOfString:@"succ"];
    
    if (range.length <= 0)
    {
        NLProtocolData* data = [response.data find:@"msgbody/message" index:0];
        
        NSString* value = data.value;
      
        [self showErrorInfo:value status:NLHUDState_Error];
        
    }else{
        
       [self showErrorInfo:@"密保设置成功" status:NLHUDState_NoError];
        
       [self performSelector:@selector(dissmis) withObject:nil afterDelay:2.0f];
        
    }
    
}

-(void)dissmis{
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)even{
   
  [self oneFingerTwoTaps];
  [self.view endEditing:YES];

}

-(void)oneFingerTwoTaps
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UITextField *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    [firstResponder resignFirstResponder];
}

-(void)back
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField!=_Answer1) {
        [self registerForKeyboardNotifications];
    }
    
}

#pragma keyboard
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
}


-(void)keyboardWasShown:(NSNotification*)noti{
    [UIView beginAnimations:nil context:nil];
    self.view.frame= CGRectMake(0,self.view.frame.origin.y-160, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
}

-(void)keyboardWasHidden:(id)noti{
    [UIView beginAnimations:nil context:nil];
    self.view.frame= CGRectMake(0, 0, self.view.frame.size.width+160, self.view.frame.size.height);
    [UIView commitAnimations];
}

@end



