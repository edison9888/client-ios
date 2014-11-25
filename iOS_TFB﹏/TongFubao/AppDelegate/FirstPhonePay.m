//
//  FirstPhonePay.m
//  TongFubao
//
//  Created by  俊   on 14-6-15.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "FirstPhonePay.h"
#import "NewLoginView.h"
#import "NLProgressHUD.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBookUI/ABPeoplePickerNavigationController.h>
#import "PhoneMoneyGive.h"
#import "UITextField+Shake.h"
#import "NLLogOnViewController.h"
#import "NLUtils.h"
#import "SecretText.h"

#import "planeAdd.h"
#import "planeMain.h"

#define MaxPhoneNum 11

typedef enum
{
    NLLogOnInfoType_Logon = 0,
    NLLogOnInfoType_Mobile,
    NLLogOnInfoType_Password,
    NLLogOnInfoType_ProtocolFailure,
    NLLogOnInfoType_ProtocolSuccess
}NLLogOnInfoType;


@interface FirstPhonePay ()<ABPeoplePickerNavigationControllerDelegate>
{
    int            ios7Height;
    BOOL           Nilflag;
    BOOL           popflag;
    NLProgressHUD  * _hud;
    UILabel        *lable;
    NSDictionary   *dictOK;
    UIButton       *basebtn;
    UILabel        *nilLabne;
    UIButton       *select;
    NSString       *rechamoneyStr;
    NSString       *rechapaymoneyStr;
    NSString       *PhoneMoneyStr;
    NSString       *PhoneMoneyStrMore;
    NSArray        *PhoneMoneyMoreArray;
}

@property (nonatomic) BOOL  ABPeoplePickerFlag;  //选择了通讯录的标示

@property (retain) NSMutableString *arrayfortabview;
@property (strong, nonatomic)  UIButton         *BtnPhoneMoneyOn;
@property(nonatomic, strong)   NSMutableArray   *myArray;
@property (nonatomic,strong)   UIScrollView     *btnScrollView;

@property (weak, nonatomic) IBOutlet UILabel     *Address;
@property (weak, nonatomic) IBOutlet UITextField *TextFiled;
@property (weak, nonatomic) IBOutlet UIButton    *TextBtn;
@property (weak, nonatomic) IBOutlet UIButton *Gesture;
@property (weak, nonatomic) IBOutlet UILabel *lable1;
@property (weak, nonatomic) IBOutlet UIImageView *Line;
@property (weak, nonatomic) IBOutlet UILabel *lable2;

@end

@implementation FirstPhonePay

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)iphone4Or5
{
    
    _TextFiled.frame= CGRectMake(self.TextFiled.frame.origin.x, self.TextFiled.frame.origin.y+ios7Height, self.TextFiled.frame.size.width,  self.TextFiled.frame.size.height);
    
    _TextBtn.frame= CGRectMake(self.TextBtn.frame.origin.x, self.TextBtn.frame.origin.y+ios7Height, self.TextBtn.frame.size.width,  self.TextBtn.frame.size.height);
    
    _lable1.frame= CGRectMake(self.lable1.frame.origin.x, self.lable1.frame.origin.y+ios7Height, self.lable1.frame.size.width,  self.lable1.frame.size.height);
    
    _lable2.frame= CGRectMake(self.lable2.frame.origin.x, self.lable2.frame.origin.y+ios7Height, self.lable2.frame.size.width,  self.lable2.frame.size.height);

    _Line.frame= CGRectMake(self.Line.frame.origin.x, self.Line.frame.origin.y+ios7Height, self.Line.frame.size.width,  self.Line.frame.size.height);
    
    _Address.frame= CGRectMake(self.Address.frame.origin.x, self.Address.frame.origin.y+ios7Height, self.Address.frame.size.width,  self.Address.frame.size.height);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self ViewMain];
    
    _ABPeoplePickerFlag = NO;
    
    _TextFiled.text = @"";
    
    ios7Height = [UIScreen mainScreen].bounds.size.height;
    
    ios7Height = [UIScreen mainScreen].bounds.size.height== 568?40:0;
    
    [self iphone4Or5];
    
    //TEXT
    if (ios7Height)
    {
        NSLog(@"568尺寸");
    }
    else if (ios7Height)
    {
        NSLog(@"480尺寸");
    }
}

#pragma 默认登陆
-(void)loginUrl
{
    
    NSString* name = [NLUtils getNameForRequest:Notify_ApiAuthorInfoV2Gesture];
    REGISTER_NOTIFY_OBSERVER(self, checkAuthorLoginNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApiAuthorInfoV2gesturepasswd:@"" paypasswd:@"123456" mobile:@"18102786610"];
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
        NSString* detail = response.detail;
        if (!detail || detail.length <= 0)
        {
           [self alertNotoBtn];
          
        }
        
        if (basebtn==nil) {
           
            [self BtnOnDock:YES];
            
        }else{
            
            [self BtnOnDock:NO];
        }
        
//        [self showErrorInfo:NLLogOnInfoType_ProtocolFailure detail:detail];
        
    }
}

-(void)docheckAuthorLoginNotify:(NLProtocolResponse*)response
{
    NLProtocolData *authoridStr = [response.data find:@"msgbody/authorid" index:0];
    
    NSString *authorid = authoridStr.value;
    
    [NLUtils setAuthorid:authorid];
    
    NLProtocolData *data = [response.data find:@"msgbody/result" index:0];
    
    NSString *result = data.value;
    
    NSRange range = [result rangeOfString:@"succ"];
    if (range.length <= 0)
    {
        NLProtocolData *data = [response.data find:@"msgbody/message" index:0];
        
        NSString* value = data.value;
        
        NSLog(@"value %@",value);
        
        [self showErrorInfo:value status:NLHUDState_Error];
    }
    else
    {
        Nilflag = YES;
        
        [self readRechaPayTypeinfo];
        
        if (basebtn==nil) {
            
            [self BtnOnDock:YES];
            
        }else{
            
            [self BtnOnDock:NO];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    if (_ABPeoplePickerFlag) {
        _TextFiled.text= _arrayfortabview;
        _ABPeoplePickerFlag = NO;
    }

    //判断是否有数据
    if (popflag!=YES)
    {
        [self loginUrl];
        
//        [self checkAppVersion];
    }
   
}
-(void)ViewMain{
    
    self.view.backgroundColor = RGBACOLOR(245, 245, 245, 1.0);

    [@[_TextFiled] enumerateObjectsUsingBlock:^(UITextField* obj, NSUInteger idx, BOOL *stop) {
        
		[obj.layer setBorderWidth:2];
        
		[obj.layer setBorderColor:(__bridge CGColorRef)[UIColor colorWithPatternImage:[UIImage imageNamed:@"input_fieldside.png"]]];
        
		[obj setDelegate:self];
	}];
    
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 11, 30)];
    
    self.TextFiled.leftView = paddingView1;
    
    self.TextFiled.leftViewMode = UITextFieldViewModeAlways;

}

#pragma mark-
#pragma phonenumber
-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person{
    
    NSMutableString *number;
    
    NSMutableArray *temparray = [[NSMutableArray alloc] initWithCapacity:1];
    
    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    NSUInteger num = [(__bridge NSMutableArray *)ABMultiValueCopyArrayOfAllValues(phone) count];
    
    if (num >0) {
        for (int i = 0; i<num; i++) {
            number = (__bridge NSMutableString *)ABMultiValueCopyValueAtIndex(phone, i);
            
            [temparray addObject:number];
        }
    }
    //去除电话符
    NSString *originalString = [temparray objectAtIndex:0];
    
    NSMutableString *strippedString = [NSMutableString
                                       stringWithCapacity:originalString.length];
    
    NSScanner *scanner = [NSScanner scannerWithString:originalString];
    NSCharacterSet *numbers = [NSCharacterSet
                               characterSetWithCharactersInString:@"0123456789"];
    while ([scanner isAtEnd] == NO) {
        NSString *buffer;
        if ([scanner scanCharactersFromSet:numbers intoString:&buffer]) {
            [strippedString appendString:buffer];
        }
        else {
            [scanner setScanLocation:([scanner scanLocation] + 1)];
        }
    }
    _arrayfortabview = strippedString;
    
    _ABPeoplePickerFlag = YES;
    
    [self dismissModalViewControllerAnimated:YES];
    
    [self PhoneNumMore];//跳转的时候执行请求
    return NO;
}


-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    return NO;
}

-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark IQKeyBoardManager delegate
-(void)doneClicked:(UIBarButtonItem*)barButton
{
    [self.view.subviews enumerateObjectsUsingBlock:^(UIView* obj, NSUInteger idx, BOOL *stop) {
		if ([obj isKindOfClass:[UITextField class]]) {
			[obj resignFirstResponder];
		}
	}];
    if ([_TextFiled.text length]==11) {
        [self PhoneNumMore];
    }
}

#pragma PhoneNumTextUrl
- (void)PhoneNumMore{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSURL *url= [NSURL URLWithString:[NSString stringWithFormat:@"http://api.k780.com:88/?app=phone.get&phone=%@&appkey=10832&sign=d885f6d5d27f8166e026dbb42d6c8213&form=json",_TextFiled.text]];
        
        NSLog(@"%@ ",_TextFiled.text);
        
        //通过url连接创建一个请求
        NSMutableURLRequest*request=[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
        
        NSHTTPURLResponse*response=nil;
        
        NSError*error=nil;
        
        //发送同步连接,得到请求数据
        NSData*data=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
     
        dispatch_async(dispatch_get_main_queue(), ^{
            //将得到的数据转码
            NSError*error=nil;
            
            if (data!=nil) {
                dictOK= [[NSDictionary alloc]init];
                
                dictOK= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                
                NSArray *array= [dictOK objectForKey:@"result"];
                
                [[NSUserDefaults standardUserDefaults]setObject:array forKey:@"dict_array"];
                
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
            
            if (PhoneMoneyStrMore.length<=0) {
                
                PhoneMoneyMoreArray= [NSMutableArray array];
                
                PhoneMoneyMoreArray= [[[NSUserDefaults standardUserDefaults] objectForKey:@"_myArrayIsOn"] valueForKey:@"rechapaymoney"];
                
                PhoneMoneyStrMore= @"";
             
                PhoneMoneyStrMore =[PhoneMoneyMoreArray objectAtIndex:0];
                
            }else{
            //这里
            lable.text= [NSString stringWithFormat:@"实际支付金额: %@",PhoneMoneyStrMore];
            
            [self.view addSubview:lable];
            }
            _Address.text= [[[NSUserDefaults standardUserDefaults]objectForKey:@"dict_array"]valueForKey:@"att" ];
            
        });
    });
    
   
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL retValue = YES;
    
    if([[textField text] length] - range.length + string.length > MaxPhoneNum)
    {
        retValue=NO;
    }
    return retValue;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField != _TextFiled) {
        
		[textField resignFirstResponder];
	} else {
		[self shake];
	}
	
	return YES;
}

#pragma BtnOnDock

-(void)BtnOnDock:(BOOL)first{
    
    NSArray *arrayBtn;
    
    PhoneMoneyMoreArray= [NSMutableArray array];
    
    if (first) {
        
        _btnScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 190+ios7Height, 320, 38)];
        
        arrayBtn= _myArray;
        
        PhoneMoneyMoreArray= [[[NSUserDefaults standardUserDefaults] objectForKey:@"_myArrayIsOn"] valueForKey:@"rechapaymoney"];
        
    }else{
        
        PhoneMoneyMoreArray= [[[NSUserDefaults standardUserDefaults] objectForKey:@"_myArrayIsOn"] valueForKey:@"rechapaymoney"];
        
        arrayBtn= [[NSUserDefaults standardUserDefaults] objectForKey:@"_myArrayIsOn"];
        
        if (_btnScrollView==nil) {
            
            _btnScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 190+ios7Height, 320, 38)];
        }
    }
    
    _btnScrollView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagScroll)];
    
    [_btnScrollView addGestureRecognizer:tap];
    
    _btnScrollView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_btnScrollView];
    
    if (arrayBtn.count>3) {
        
        _btnScrollView.frame = CGRectMake(0, 190+ios7Height, 320, 108);
        
        _btnScrollView.contentSize = CGSizeMake(320, ((arrayBtn.count/3)+1)*54);
        
        _btnScrollView.showsVerticalScrollIndicator = YES;
        [_btnScrollView flashScrollIndicators];
    }
    
    CGRect frame;
    
    for (int i=0; i<arrayBtn.count; i++) {
        
        frame.size.width= 82;
        
        frame.size.height= 40;
        
        frame.origin.x= (i%3)*(95)+25;
        
        frame.origin.y= floor(i/3)*(50);
        
        basebtn= [BaseButton ButtonWithFrame:frame Target:self Selector:@selector(PhoneyMoney:) Image:nil Title:[NSString stringWithFormat:@"￥%@",[[arrayBtn objectAtIndex:i] valueForKey:@"rechamoney"]] TitleColor:[UIColor lightGrayColor] TitleColorSate:UIControlStateNormal];
        
        basebtn.tag=200+i;
        
        basebtn.titleLabel.font= [UIFont systemFontOfSize:16];
        
        [basebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        [basebtn setBackgroundImage:[UIImage imageNamed:@"1btn_normal"] forState:UIControlStateNormal];
        
        [basebtn setBackgroundImage:[UIImage imageNamed:@"1btn_selected"] forState:UIControlStateSelected];
        
        if (basebtn.tag == 201) {
            
            basebtn.selected = YES;
            
            PhoneMoneyStr = basebtn.titleLabel.text;
            
            /*默认充值选项*/
            if (PhoneMoneyMoreArray.count>1&&popflag!=YES) {
                
                PhoneMoneyStrMore =[PhoneMoneyMoreArray objectAtIndex:1];

            }
            
            select = basebtn;
        }
        
        [_btnScrollView addSubview:basebtn];

    }
    
    if (lable==nil) {
        
        [nilLabne setHidden:YES];
        
        lable= [[UILabel alloc]init];
    }
    
    lable.textColor= [UIColor orangeColor];
    
    lable.font= [UIFont systemFontOfSize:17];
    
    lable.backgroundColor= [UIColor clearColor];
    
    if (arrayBtn.count<=3) {
        
        lable.frame= CGRectMake(16, 290+ios7Height, 180, 30);
        
    }
    else if (arrayBtn.count>3){
        
        lable.frame= CGRectMake(16, 290+ios7Height, 180, 30);
        
    }
    
    /*无数据不显示并重刷界面*/
    if (basebtn!=nil) {
        
        [self OnClickBtn];
        
    }
    
}

-(void)todoSomething
{
  
    
}

-(void)alertNotoBtn
{
    [NLUtils showAlertView:@"当前数据未响应，是否重新获取？"
                   message:nil
                  delegate:self
                       tag:0
                 cancelBtn:@"确定"
                     other:@"取消",nil];
    
   
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex)
    {
        [self showErrorInfo:@"正在重新获取数据" status:NLHUDState_None];
        [self loginUrl];
    }
}

-(void)OnClickBtn{
    
    _Gesture.frame= CGRectMake(self.Gesture.frame.origin.x, 430, self.Gesture.frame.size.width,  self.Gesture.frame.size.height);
    
    _BtnPhoneMoneyOn= [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_BtnPhoneMoneyOn setBackgroundImage:[UIImage imageNamed:@"next_press.png"] forState:UIControlStateNormal];
    
    [_BtnPhoneMoneyOn setBackgroundImage:[UIImage  imageNamed:@"next_press.png"] forState:UIControlStateHighlighted];
    
    [_BtnPhoneMoneyOn setTitle:@"立即充值" forState:UIControlStateNormal];
    
    [_BtnPhoneMoneyOn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_BtnPhoneMoneyOn addTarget:self action:@selector(PhonePay:) forControlEvents:UIControlEventTouchUpInside];
    
    _BtnPhoneMoneyOn.frame= CGRectMake(16, 335+ios7Height, 288, 39);
    
    [self.view addSubview:_BtnPhoneMoneyOn];
}

//检查版本号
-(void)checkAppVersion
{
    [[[NLProtocolRequest alloc] initWithRegister:YES] checkAppVersion:@"2" version:TFBVersion];
}

#pragma 动画
-(void)clickBack
{
    [CATransaction begin];
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromBottom;
    transition.duration=0.8f;
    transition.fillMode=kCAFillModeForwards;
    transition.removedOnCompletion=YES;
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:transition forKey:@"transition"];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [CATransaction setCompletionBlock: ^ {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(transition.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^ {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        });
        NLAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        
        [delegate firstPhonePayView];
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
    [CATransaction commit];
}

- (IBAction)AddressPeople:(id)sender {
    ABPeoplePickerNavigationController *ppnc = [[ABPeoplePickerNavigationController alloc] init];
    ppnc.peoplePickerDelegate = self;
    [self presentModalViewController:ppnc animated:YES];
}

- (IBAction)MyPhone:(id)sender {
    
    [NLUtils setAuthorid:nil];
    
    [self clickBack];
    
}


#pragma 支付
- (void)PhonePay:(id)sender {
   
    [self shake];
}

//点击按钮scrollview
-(void)tagScroll
{
    [self.view.subviews enumerateObjectsUsingBlock:^(UIView* obj, NSUInteger idx, BOOL *stop) {
        
		if ([obj isKindOfClass:[UITextField class]]) {
			[obj resignFirstResponder];
		}
	}];
    if ([_TextFiled.text length]==11) {
        [self PhoneNumMore];
    }
    
}

#pragma  PayPhoneMoney
- (void)PhoneyMoney:(id)sender {
    
    if (_TextFiled.text.length<10) {
        
        [self showErrorInfo:@"请输入您需要充值的手机号码"];
        
    }else{
    
    UIButton *btn= (UIButton*)sender;
    
    select.selected= !select.selected;
    
    btn.selected=YES;
    
    select =btn;
        
    int Num;
        
    Num= btn.tag-200;
    
    PhoneMoneyMoreArray= [NSMutableArray array];
        
    PhoneMoneyMoreArray= [[[NSUserDefaults standardUserDefaults] objectForKey:@"_myArrayIsOn"] valueForKey:@"rechapaymoney"];
        
    PhoneMoneyStrMore =[PhoneMoneyMoreArray objectAtIndex:Num];
        
    if (btn.selected) {
        
        PhoneMoneyStr= btn.titleLabel.text;
        
    }
        lable.text= [NSString stringWithFormat:@"实际支付金额: %@",PhoneMoneyStrMore];
        [self.view addSubview:lable];
  }
}

#pragma PhoneNum
- (void)shake{
    
    BOOL result = [NLUtils checkMobilePhone:_TextFiled.text];
    
    if (!result)
    {
        [_hud hide:YES afterDelay:1];
        
        [self.TextFiled shake:10
                   withDelta:5
                    andSpeed:0.04];
        
        [self showErrorInfo:@"请输入正确的手机号码"];
    }
    else if(result){
        
        PhoneMoneyGive *phone= [[PhoneMoneyGive alloc]initWithNibName:@"PhoneMoneyGive" bundle:nil];
        phone.PhoneGiveStr= PhoneMoneyStr;
        phone.myNotifySMS= YES;
        phone.PhoneGiveStr2=PhoneMoneyStrMore;
        phone.PhoneAddress= [[[NSUserDefaults standardUserDefaults]objectForKey:@"dict_array"]valueForKey:@"att" ];
        phone.PhoneNum= _TextFiled.text;
        popflag=YES;
        [NLUtils presentModalViewController:self newViewController:phone];
    }
}

#pragma mark 充值支付选项
-(void)readRechaPayTypeinfo
{
   
    NSString* name = [NLUtils getNameForRequest:Notify_readRechaMoneyinfo];
    REGISTER_NOTIFY_OBSERVER(self, readRechaMoneyinfoNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] readRechaMoneyinfo];
}

//支付金额的读取选项
-(void)readRechaMoneyinfoNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        
        [self doReadRechaMoneyinfoNotify:response];
    }
        else
    {
        NSString* detail = response.detail;
        if (!detail || detail.length <= 0)
        {
            [_hud hide:YES];
            
            [self alertNotoBtn];
        }
//        [self showErrorInfo:NLLogOnInfoType_ProtocolFailure detail:detail];
    }
}

//获取到的本地充值信息选项
-(void)doReadRechaMoneyinfoNotify:(NLProtocolResponse*)response
{
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
        _myArray= [NSMutableArray array];
        
        NSArray* rechamoney = [response.data find:@"msgbody/msgchild/rechamoney"];
        
        NSArray* rechapaymoney = [response.data find:@"msgbody/msgchild/rechapaymoney"];
        
        for (int i =0 ; i<rechamoney.count; i++) {
            
            NLProtocolData* data = [rechamoney objectAtIndex:i];
            
            rechamoneyStr = data.value;
            
            data = [rechapaymoney objectAtIndex:i];
            
            rechapaymoneyStr = data.value;
            
            [_myArray addObject:@{@"rechamoney": rechamoneyStr,@"rechapaymoney":rechapaymoneyStr}];
            
        }
        
        //第一次刷新界面
        NSArray *localArr = [[NSUserDefaults standardUserDefaults]objectForKey:@"_myArrayIsOn"];
        
        if (localArr.count==0) {
            //刷新界面
            [self BtnOnDock:YES];
        }
        
        if (_myArray.count!=0) {
            
            [[NSUserDefaults standardUserDefaults]setObject:_myArray forKey:@"_myArrayIsOn"];
            
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        
        if (basebtn==nil) {
            
            [_hud hide:YES];
          
            [self BtnOnDock:YES];
            
        }
    }
    
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

//登陆的进入页面
-(void)showErrorInfo:(NLLogOnInfoType)error detail:(NSString*)detail
{
    [_hud hide:YES];
    _hud = [[NLProgressHUD alloc] initWithParentView: self.view];
    
    switch (error)
    {
        case NLLogOnInfoType_Logon:
        {
            _hud.labelText = @"正在登录";
            [_hud show:YES];
        }
            break;
        case NLLogOnInfoType_Mobile:
        {
            _hud.labelText = @"请输入正确的手机号码";
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unCheckmark.png"]] ;
            _hud.mode = MBProgressHUDModeCustomView;
            [_hud show:YES];
            [_hud hide:YES afterDelay:2];
        }
            break;
        case NLLogOnInfoType_Password:
        {
            _hud.labelText = @"请输入6-20位密码";
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unCheckmark.png"]] ;
            _hud.mode = MBProgressHUDModeCustomView;
            [_hud show:YES];
            [_hud hide:YES afterDelay:2];
        }
            break;
            
        case NLLogOnInfoType_ProtocolFailure:
        {
            _hud.labelText = detail;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unCheckmark.png"]] ;
            _hud.mode = MBProgressHUDModeCustomView;
            [_hud show:YES];
            [_hud hide:YES afterDelay:2];
        }
            break;
            
        case NLLogOnInfoType_ProtocolSuccess:
        {
            _hud.labelText = detail;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.png"]] ;
            _hud.mode = MBProgressHUDModeCustomView;
            [_hud show:YES];
            [_hud hide:YES afterDelay:2];
        }
            break;
            
        default:
            break;
    }
    return;
}

//判断信息是否正确
-(void)showErrorInfo:(NSString*)detail status:(NLHUDState)status
{
    [self oneFingerTwoTaps];
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



#pragma mark - keyboard hide event
-(void)oneFingerTwoTaps
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UITextField *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    [firstResponder resignFirstResponder];
}

//回收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self.view.subviews enumerateObjectsUsingBlock:^(UIView* obj, NSUInteger idx, BOOL *stop) {
		if ([obj isKindOfClass:[UITextField class]]) {
			[obj resignFirstResponder];
		}
	}];
    
    if ([_TextFiled.text length]==11) {
       
        [self PhoneNumMore];
    }
}

- (IBAction)MiBao:(id)sender
{
    planeMain *add= [[planeMain alloc]init];
    [NLUtils presentModalViewController:self newViewController:add];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
