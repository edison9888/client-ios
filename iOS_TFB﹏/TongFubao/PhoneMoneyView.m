//
//  PhoneMoneyView.m
//  TongFubao
//
//  Created by  俊   on 14-4-21.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "PhoneMoneyView.h"
#import "PhoneMoneyGive.h"
#import "NLProtocolResponse.h"
#import "NLUtils.h"
#import "NLContants.h"
#import "NLProtocolRequest.h"
#import "NLProgressHUD.h"
#import "NLMyWalletViewController.h"
#import "UITextField+Shake.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBookUI/ABPeoplePickerNavigationController.h>
#import "NLRegisterViewController.h"
#import "ProtocolParser.h"
#import "QRadioButton.h"
#import "IQKeyBoardManager.h"
#import "MobileRechangeHistoryCtr.h"


#define MaxPhoneNum 11

@interface PhoneMoneyView ()<ABPeoplePickerNavigationControllerDelegate>
{
    NSInteger currentHeight;
    int        IOS7HEIGHT;
    NLProgressHUD  * _hud;
    NSDictionary   *dictOK;
    
    UIButton       *select;
    UIButton       *basebtn;
    NSString       *PhoneMoneyStr;
    NSString       *PhoneMoneyStrMore;
    NSString       *rechamoneyStr;
    NSString       *rechapaymoneyStr;
    
    NSArray        *PhoneMoneyMoreArray;
    UIView         *emitterView;
    NSMutableArray *resultArray;

    
}
@property (retain) NSMutableString *arrayfortabview;
@property (weak, nonatomic) IBOutlet UITextField *PhoneNum;
@property (weak, nonatomic) IBOutlet UILabel     *Address;
@property (weak, nonatomic) IBOutlet UILabel     *Operator;
@property (weak, nonatomic) IBOutlet UILabel     *lableAddress;
@property (weak, nonatomic) IBOutlet UILabel    *lableCMCC;
@property (weak, nonatomic) IBOutlet UIButton   *ButtonAddress;

@property(nonatomic, strong)   NSMutableArray   *myArray;
@property (strong,nonatomic)   UIButton         *Money100;

@property (strong, nonatomic)  UILabel          *cheapLable;
@property (strong, nonatomic)  UILabel          *TextBtnLable;
@property (strong, nonatomic)  UILabel          *TextBtnLable2;
@property (strong, nonatomic)  UIButton         *BtnPhoneMoneyOn;


@property (nonatomic,strong)  NSArray     *localNumArr;

@property (nonatomic,strong)  UITableView *ddTableView;

@property (nonatomic,strong) UIScrollView *btnScrollView;

@property (nonatomic) BOOL  ABPeoplePickerFlag;  //选择了通讯录的标示

@end

@implementation PhoneMoneyView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"手机充值";
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    if (_ABPeoplePickerFlag) {
        _PhoneNum.text= _arrayfortabview;
        _ABPeoplePickerFlag = NO;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    

}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (_ddTableView ==nil) {
        _ddTableView =[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _ddTableView.layer.borderWidth = 1;
        _ddTableView.layer.borderColor = [[UIColor blackColor] CGColor];
    }
    
    //号码从本地取出
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    _localNumArr = [userDefault objectForKey:@"chargeNumList"];

//    _localNumArr =[NSArray arrayWithObjects:@"11111",@"aafaf",@"2222", nil];
    
    _ddTableView.delegate = self;
    _ddTableView.dataSource = self;
    
    [_ddTableView setFrame:CGRectMake(_PhoneNum.frame.origin.x+5,_PhoneNum.frame.origin.y+_PhoneNum.frame.size.height, _PhoneNum.frame.size.width-10, _localNumArr.count*47)];
    
	[_PhoneNum addSubview:_ddTableView];
    
    [self setDDListHidden:NO];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self setDDListHidden:YES];
}
#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 47;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _localNumArr.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellID = @"LocalPhoneCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",_localNumArr[indexPath.row]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self setDDListHidden:YES];
    _PhoneNum.text = [NSString stringWithFormat:@"%@",_localNumArr[indexPath.row]];
    [_PhoneNum resignFirstResponder];
    [self PhoneNumMore];
}

// Customize the appearance of table view cells.

#pragma mark -
#pragma mark Table view delegate

#pragma ViewDidOnSetter
- (void)PhoneMoneyHistoryRecord{
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"历史记录"
                                                                      style:UIBarButtonItemStyleBordered
                                                                     target:self
                                                                     action:@selector(historyRecord)];
    self.navigationItem.rightBarButtonItem = anotherButton;
}

- (void)PhoneMoneyNumIsOk{
    //iphone 4 : iphone5
    _PhoneNum.frame= CGRectMake(self.PhoneNum.frame.origin.x, self.PhoneNum.frame.origin.y-IOS7HEIGHT, self.PhoneNum.frame.size.width, self.PhoneNum.frame.size.height);
    [self.view addSubview:_PhoneNum];
    
    _ButtonAddress.frame= CGRectMake(self.ButtonAddress.frame.origin.x, self.ButtonAddress.frame.origin.y-IOS7HEIGHT, self.ButtonAddress.frame.size.width, self.ButtonAddress.frame.size.height);
    [self.view addSubview:_ButtonAddress];
    
    _lableAddress.frame= CGRectMake(self.lableAddress.frame.origin.x, self.lableAddress.frame.origin.y-IOS7HEIGHT, self.lableAddress.frame.size.width, self.lableAddress.frame.size.height);
    [self.view addSubview:_lableAddress];
    
    _lableCMCC.frame= CGRectMake(self.lableCMCC.frame.origin.x, self.lableCMCC.frame.origin.y-IOS7HEIGHT, self.lableCMCC.frame.size.width, self.lableCMCC.frame.size.height);
    [self.view addSubview:_lableCMCC];
    
    _Address.frame= CGRectMake(self.Address.frame.origin.x, self.Address.frame.origin.y-IOS7HEIGHT, self.Address.frame.size.width, self.Address.frame.size.height);
    [self.view addSubview:_Address];
    
    _Operator.frame= CGRectMake(self.Operator.frame.origin.x, self.Operator.frame.origin.y-IOS7HEIGHT, self.Operator.frame.size.width, self.Operator.frame.size.height);
    [self.view addSubview:_Operator];
    

    [@[_PhoneNum] enumerateObjectsUsingBlock:^(UITextField* obj, NSUInteger idx, BOOL *stop) {
        
		[obj.layer setBorderWidth:2];
		[obj.layer setBorderColor:(__bridge CGColorRef)[UIColor colorWithPatternImage:[UIImage imageNamed:@"input_fieldside.png"]]];
		[obj setDelegate:self];
	}];
    
}

- (void)setDDListHidden:(BOOL)hidden {

	NSInteger height = hidden ? 0 : 47*_localNumArr.count;
    
	[UIView beginAnimations:nil context:nil];
    
	[UIView setAnimationDuration:.2];
    
	[_ddTableView setFrame:CGRectMake(_PhoneNum.frame.origin.x+5,_PhoneNum.frame.origin.y+_PhoneNum.frame.size.height, _PhoneNum.frame.size.width-10, height)];
    
    [self.view addSubview:_ddTableView];
    
	[UIView commitAnimations];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    
    ViewControllerProperty;
    
#endif
    
    //获取当前屏幕size
    currentHeight = iphoneSize;
  
    [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
    
//    IOS7HEIGHT = IOS7_OR_LATER==YES?64:0;
    /*适配懒得动*/
    IOS7HEIGHT= 70;
    
    //读取充值支付选项
    [self readRechaPayTypeinfo];
        
    [self PhoneMoneyNumIsOk];
            
    [self PhoneMoneyHistoryRecord];

    _ABPeoplePickerFlag = NO;
    
    _PhoneNum.text = @"";
}

#pragma tableView
    
#pragma BtnOnDock

-(void)BtnOnDock:(BOOL)first{
    
    NSArray *arrayBtn;
    if (first) {
        _btnScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 230-IOS7HEIGHT, 320, 70)];
        PhoneMoneyMoreArray= [NSMutableArray array];
        PhoneMoneyMoreArray= [_myArray valueForKey:@"rechapaymoney"];
        arrayBtn= _myArray;
        
    }else{
        
        PhoneMoneyMoreArray= [NSMutableArray array];
        PhoneMoneyMoreArray= [[[NSUserDefaults standardUserDefaults] objectForKey:@"_myArrayIsOn"] valueForKey:@"rechapaymoney"];
        
        arrayBtn= [[NSUserDefaults standardUserDefaults] objectForKey:@"_myArrayIsOn"];
       
        if (_btnScrollView==nil) {
            _btnScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 230-IOS7HEIGHT, 320, 70)];
        }
    }

    _btnScrollView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagScroll)];
    
    [_btnScrollView addGestureRecognizer:tap];
    
     _btnScrollView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_btnScrollView];
    
    if (arrayBtn.count>3) {
        _btnScrollView.frame = CGRectMake(0, 235-IOS7HEIGHT, 320, 108);
        _btnScrollView.contentSize = CGSizeMake(320, ((arrayBtn.count/3)+1)*54);
        _btnScrollView.showsVerticalScrollIndicator = YES;
        [_btnScrollView flashScrollIndicators];
    }
    
    CGRect frame;
    
    for (int i = 0; i < arrayBtn.count; i++)
    {
        
        frame.size.width= 82;
        frame.size.height= 38;
        frame.origin.x= (i%3)*(95)+25;
        frame.origin.y= floor(i/3)*(60);
        
        basebtn= [BaseButton ButtonWithFrame:frame Target:self Selector:@selector(PhoneyMoney:) Image:nil Title:[NSString stringWithFormat:@"￥%@",[[arrayBtn objectAtIndex:i] valueForKey:@"rechamoney"]] TitleColor:[UIColor lightGrayColor] TitleColorSate:UIControlStateNormal];
        
        basebtn.tag=200+i;
        basebtn.titleLabel.font= [UIFont systemFontOfSize:16];
        [basebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [basebtn setBackgroundImage:[UIImage imageNamed:@"1btn_normal"] forState:UIControlStateNormal];
        [basebtn setBackgroundImage:[UIImage imageNamed:@"1btn_selected"] forState:UIControlStateSelected];
        
        if (basebtn.tag == 201) {
            basebtn.selected = YES;
            PhoneMoneyStr = basebtn.titleLabel.text;
            if (PhoneMoneyMoreArray.count>1) {
                 PhoneMoneyStrMore =[PhoneMoneyMoreArray objectAtIndex:1];
            }
            select = basebtn;
        }
        [_btnScrollView addSubview:basebtn];
    }
    
    if (_TextBtnLable==nil) {
         _TextBtnLable = [[UILabel alloc]init];
         _cheapLable = [[UILabel alloc]init];
         _TextBtnLable2 = [[UILabel alloc]init];
    }

    _TextBtnLable.text= @"温馨提示：";
    _TextBtnLable2.text= @"   逢月底月初，因交易流量大，偶尔会出现延时请耐心等待。 ";
    _TextBtnLable.font= [UIFont systemFontOfSize:20];
    _TextBtnLable2.font= [UIFont systemFontOfSize:16];
    _TextBtnLable2.numberOfLines= 2;
    
    if (_BtnPhoneMoneyOn==nil) {
        _BtnPhoneMoneyOn= [UIButton buttonWithType:UIButtonTypeCustom];
    }
    
    _BtnPhoneMoneyOn.titleLabel.textColor= [UIColor whiteColor];
    [_BtnPhoneMoneyOn setBackgroundImage:[UIImage imageNamed:@"next_press.png"] forState:UIControlStateNormal];
    [_BtnPhoneMoneyOn setBackgroundImage:[UIImage  imageNamed:@"next_press.png"] forState:UIControlStateHighlighted];
    [_BtnPhoneMoneyOn setTitle:@"立即充值" forState:UIControlStateNormal];
    [_BtnPhoneMoneyOn addTarget:self action:@selector(PhonePay:) forControlEvents:UIControlEventTouchUpInside];
    
    if (arrayBtn.count<=3) {
        
        _TextBtnLable.frame= CGRectMake(30, 270-IOS7HEIGHT, 200, 40);
        _TextBtnLable2.frame= CGRectMake(30, 300-IOS7HEIGHT, 260, 40);
        _BtnPhoneMoneyOn.frame= CGRectMake(16, 360-IOS7HEIGHT, 288, 39);
    }
    else if (arrayBtn.count>3){
        
        _TextBtnLable.frame= CGRectMake(30, 340-IOS7HEIGHT, 200, 40);
        _TextBtnLable2.frame= CGRectMake(30, 386-IOS7HEIGHT, 260, 40);
        _BtnPhoneMoneyOn.frame= CGRectMake(16, 440-IOS7HEIGHT, 288, 39);
    }
    [self.view addSubview:_TextBtnLable];
    [self.view addSubview:_TextBtnLable2];
    [self.view addSubview:_BtnPhoneMoneyOn];
}

#pragma  PayPhoneMoney
- (void)PhoneyMoney:(id)sender
{
    
    UIButton *btn= (UIButton*)sender;

    select.selected= !select.selected;
    
    btn.selected=YES;
    
    select =btn;
    if (btn.selected) {
        
        PhoneMoneyStr= btn.titleLabel.text;
    }
    int Num;
    Num= btn.tag-200;
    PhoneMoneyStrMore =[PhoneMoneyMoreArray objectAtIndex:Num];
}


#pragma 支付
- (void)PhonePay:(id)sender {
    
    [self shake];
}

#pragma PhoneNum
- (void)shake{
    
    BOOL result = [NLUtils checkMobilePhone:_PhoneNum.text];
    
    if (!result){
        [_hud hide:YES afterDelay:1];
        
        [self.PhoneNum shake:10
                   withDelta:5
                    andSpeed:0.04];
        
        [self showErrorInfo:@"请输入正确的手机号码"];
    }
    else if(result){
        
        /*判断当前面额是否可充值 先屏蔽*/
//        [self ApiCanRecharge];
         [self payPhonetoMoneyGive];
    }
}

/*当前手机及话费金额是否充值*/
-(void)ApiCanRecharge
{
    NSString* name = [NLUtils getNameForRequest:Notify_ApiCanRecharge];
    REGISTER_NOTIFY_OBSERVER(self, ApiCanRechargeNotify, name);
     NSString *strRechamoney= [PhoneMoneyStr stringByReplacingOccurrencesOfString:@"￥" withString:@""];
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApiCanRecharge:strRechamoney phone:_PhoneNum.text];
    [self showErrorInfo:@"正在查询面额状态..." status:NLHUDState_None];
}

//支付金额的读取选项
-(void)ApiCanRechargeNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        [self doApiCanRechargeNotify:response];
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
            detail = @"请求失败，请检查网络";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

//获取到的本地充值信息选项
-(void)doApiCanRechargeNotify:(NLProtocolResponse*)response
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
         [self payPhonetoMoneyGive];
    }
}

/*如果可以充值则跳转*/
-(void)payPhonetoMoneyGive
{
    PhoneMoneyGive *phone= [[PhoneMoneyGive alloc]initWithNibName:@"PhoneMoneyGive" bundle:nil];
    phone.PhoneGiveStr= PhoneMoneyStr;
    phone.PhoneGiveStr2=PhoneMoneyStrMore;
    phone.PhoneAddress= [[[NSUserDefaults standardUserDefaults]objectForKey:@"dict_array"]valueForKey:@"att" ];
    phone.PhoneNum= _PhoneNum.text;
    [self.navigationController pushViewController:phone animated:YES];
}


#pragma mark 历史记录
-(void)historyRecord
{
    MobileRechangeHistoryCtr *mobileRechangeHistoryCtr = [[MobileRechangeHistoryCtr alloc]initWithNibName:@"MobileRechangeHistoryCtr" bundle:nil];
    mobileRechangeHistoryCtr.myChargeHistoryType = MobileChargeType;
    [self.navigationController pushViewController:mobileRechangeHistoryCtr animated:YES];
}

-(void)doReadMenuModuleNotify:(NLProtocolResponse*)response
{
    /*
    NSArray* comid = [response.data find:@"msgbody/msgchild/comid"];
   */
}

#pragma mark IQKeyBoardManager delegate
-(void)doneClicked:(UIBarButtonItem*)barButton
{
    [self.view.subviews enumerateObjectsUsingBlock:^(UIView* obj, NSUInteger idx, BOOL *stop) {
		if ([obj isKindOfClass:[UITextField class]]) {
			[obj resignFirstResponder];
		}
	}];
    if ([_PhoneNum.text length]==11) {
        [self PhoneNumMore];
    }
    if (_ddTableView!=nil) {
        [self setDDListHidden:YES];
    }
   
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
    [self.navigationController dismissModalViewControllerAnimated:YES];
}


#pragma PhoneNumTextUrl
- (void)PhoneNumMore{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSURL *url= [NSURL URLWithString:[NSString stringWithFormat:@"http://api.k780.com:88/?app=phone.get&phone=%@&appkey=10832&sign=d885f6d5d27f8166e026dbb42d6c8213&form=json",_PhoneNum.text]];
        
        /*通过url连接创建一个请求*/
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
            _Address.text= [[[NSUserDefaults standardUserDefaults]objectForKey:@"dict_array"]valueForKey:@"att" ];
            _Operator.text= [[[NSUserDefaults standardUserDefaults]objectForKey:@"dict_array"]valueForKey:@"ctype" ];
        });
    });
}

- (IBAction)AddressPeople:(id)sender {
    ABPeoplePickerNavigationController *ppnc = [[ABPeoplePickerNavigationController alloc] init];
    ppnc.peoplePickerDelegate = self;
    [self presentModalViewController:ppnc animated:YES];
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

/*长度控制*/
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
    if (textField != _PhoneNum) {
		[textField resignFirstResponder];
	} else {
		[self shake];
	}
	
	return YES;
}

//回收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self.view.subviews enumerateObjectsUsingBlock:^(UIView* obj, NSUInteger idx, BOOL *stop) {
		if ([obj isKindOfClass:[UITextField class]]) {
			[obj resignFirstResponder];
		}
	}];
    if (basebtn==nil) {
        [self BtnOnDock:YES];
    }
    if ([_PhoneNum.text length]==11) {
        [self PhoneNumMore];
    }
    
    if (_ddTableView !=nil) {
         [self setDDListHidden:YES];
    }
    
}

//点击按钮scrollview
-(void)tagScroll
{
    [self.view.subviews enumerateObjectsUsingBlock:^(UIView* obj, NSUInteger idx, BOOL *stop) {
        
		if ([obj isKindOfClass:[UITextField class]]) {
			[obj resignFirstResponder];
		}
	}];
    if ([_PhoneNum.text length]==11) {
        [self PhoneNumMore];
    }
    
    if (_ddTableView !=nil) {
        [self setDDListHidden:YES];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}


- (void) doPush
{
    [_hud hide:YES];
    
    [NLUtils popToLogonVCByHTTPError:self feedOrLeft:1];
}

#pragma mark 充值支付选项
-(void)readRechaPayTypeinfo
{
    NSString* name = [NLUtils getNameForRequest:Notify_readRechaMoneyinfo];
    REGISTER_NOTIFY_OBSERVER(self, readRechaMoneyinfoNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] readRechaMoneyinfo];
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
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
            detail = @"请求失败，请检查网络";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
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
        }
    
    //第一次刷新界面
    NSArray *localArr = [[NSUserDefaults standardUserDefaults]objectForKey:@"_myArrayIsOn"];
    if (localArr.count==0) {
        //刷新界面
        [self BtnOnDock:YES];
    }
    else{
        [self BtnOnDock:NO];
    }
    
    if (_myArray.count!=0) {
        [[NSUserDefaults standardUserDefaults]setObject:_myArray forKey:@"_myArrayIsOn"];
        
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
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

@end