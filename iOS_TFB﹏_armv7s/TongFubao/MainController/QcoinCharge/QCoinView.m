//
//  QCoinView.m
//  TongFubao
//
//  Created by ec on 14-5-5.
//  Copyright (c) 2014年 MD313. All rights reserved.
//


#import "QCoinView.h"
#import "QcoinMoneyGive.h"
#import "NLProtocolResponse.h"
#import "NLUtils.h"
#import "NLProtocolRequest.h"
#import "NLProgressHUD.h"
#import "UITextField+Shake.h"
#import "ProtocolParser.h"
#import "QRadioButton.h"
#import "MobileRechangeHistoryCtr.h"
#import "QCoinPayController.h"

#define QQNumTag        101
#define QQChargeTag     102


@interface QCoinView ()
{
    NLProgressHUD  * _hud;
}

//充值过的本地记录号码
@property (nonatomic,strong)  NSArray        *localNumArr;

//确定支付按钮
@property (strong, nonatomic)  UIButton *BtnPhoneMoneyOn;


//充值号码下拉列表
@property (nonatomic,strong)  UITableView *ddTableView;

// qq 号码
@property (weak, nonatomic) IBOutlet UITextField *QQNum;

//充值面额
@property (weak, nonatomic) IBOutlet UITextField *ChargeNum;

@property (weak, nonatomic) IBOutlet UILabel *IsLableOn;
@property (weak, nonatomic) IBOutlet UILabel *QBNamelable;
//实际支付
@property (weak, nonatomic) IBOutlet UILabel *realPay;

// 支付价格：50元
@end

@implementation QCoinView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"Q币充值";

        }
    return self;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (textField.tag == QQNumTag)
    {
        if (_ddTableView ==nil)
        {
            _ddTableView =[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
            _ddTableView.layer.borderWidth = 1;
            _ddTableView.layer.borderColor = [[UIColor blackColor] CGColor];
        }
        
        //号码从本地取出
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            _localNumArr = [userDefault objectForKey:@"chargeQQList"];
        
        _ddTableView.delegate = self;
        _ddTableView.dataSource = self;
        [_ddTableView setFrame:CGRectMake(_QQNum.frame.origin.x+5,_QQNum.frame.origin.y+_QQNum.frame.size.height, _QQNum.frame.size.width-10, _localNumArr.count*47)];
        
//        [self.view addSubview:_ddTableView];
        
        [self setDDListHidden:NO];
    }
    
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == QQNumTag) {
        [self setDDListHidden:YES];
    }
    
    if (textField.tag == QQChargeTag) {
        _realPay.text = [NSString stringWithFormat:@"支付价格：%@元",textField.text];
    }
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
    
    static NSString *CellID = @"LocalQQNumCell";
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
    _QQNum.text = [NSString stringWithFormat:@"%@",_localNumArr[indexPath.row]];
    [_QQNum resignFirstResponder];
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
    
    [@[_QQNum] enumerateObjectsUsingBlock:^(UITextField* obj, NSUInteger idx, BOOL *stop) {
        [obj setTag:QQNumTag];
		[obj.layer setBorderWidth:2];
		[obj setDelegate:self];
        //		[obj.layer setBorderColor:[UIColor colorWithRed:49.0/255.0 green:186.0/255.0 blue:81.0/255.0 alpha:1].CGColor];
        [obj.layer setBorderColor:(__bridge CGColorRef)[UIColor colorWithPatternImage:[UIImage imageNamed:@"filed@2x_pla.jpg"]]];
	}];
    
    _ChargeNum.tag = QQChargeTag;
    _ChargeNum.delegate = self;
    [_ChargeNum.layer setBorderWidth:2];
    [_ChargeNum.layer setBorderColor:(__bridge CGColorRef)[UIColor colorWithPatternImage:[UIImage imageNamed:@"filed@2x_pla.jpg"]]];
    
    //光标右移输入
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 11, 30)];
    _QQNum.leftView = paddingView1;
    _QQNum.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_QQNum];
    
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 11, 30)];
    _ChargeNum.leftView = paddingView2;
    _ChargeNum.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_ChargeNum];
}

- (void)setDDListHidden:(BOOL)hidden {
    
	NSInteger height = hidden ? 0 : 47*_localNumArr.count;
    
	[UIView beginAnimations:nil context:nil];
    
	[UIView setAnimationDuration:.2];
    
	[_ddTableView setFrame:CGRectMake(_QQNum.frame.origin.x+5,_QQNum.frame.origin.y+_QQNum.frame.size.height, _QQNum.frame.size.width-10, height)];
    
	[UIView commitAnimations];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    
    ViewControllerProperty;
    
#endif
    /*改版*/
    [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
    
    [self PhoneMoneyNumIsOk];
            
    [self BtnOnDock];
            
    [self PhoneMoneyHistoryRecord];

    /*自定义键盘*/
//    [self setKeyBoard];
    
}

#pragma BtnOnDock

-(void)BtnOnDock{

    //最底部的提示语
    UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(30, 275, 280, 40)];
    tip.font = [UIFont systemFontOfSize:16];
//    tip.text = @"充值提示：单号单日充值最大为5000！";
    tip.textColor= [UIColor colorWithRed:18/255.0 green:250/255.0 blue:254/255.0 alpha:1];
    tip.backgroundColor = [UIColor clearColor];
    _BtnPhoneMoneyOn= [UIButton buttonWithType:UIButtonTypeCustom];
    
    _BtnPhoneMoneyOn.titleLabel.textColor= [UIColor blueColor];
    [_BtnPhoneMoneyOn setBackgroundImage:[UIImage imageNamed:@"change_btn_press"] forState:UIControlStateNormal];
    [_BtnPhoneMoneyOn setTitle:@"充值" forState:UIControlStateNormal];
    [_BtnPhoneMoneyOn addTarget:self action:@selector(PhonePay:) forControlEvents:UIControlEventTouchUpInside];
    
    _BtnPhoneMoneyOn.frame= CGRectMake(16, 270, 288, 39);
    
    [self.view addSubview:tip];
    [self.view addSubview:_BtnPhoneMoneyOn];
}

#pragma 支付
- (void)PhonePay:(id)sender
{
    [self shakePhone];
}

#pragma PhoneNum
- (void)shakePhone
{
    //检测输入的字符
    BOOL result = [NLUtils checkInterNum:_QQNum.text];
    
    if (!result || _QQNum.text.length < 6)
    {
        [_hud hide:YES afterDelay:1];
        
        [_QQNum shake:10
                   withDelta:5
                    andSpeed:0.04];
        
        [self showErrorInfo:@"请输入正确的QQ号码"];
        
        return;
    }
    
    BOOL chargeBool = [NLUtils checkInterNum:_ChargeNum.text];
    
    if (!chargeBool)
    {
        [_hud hide:YES afterDelay:1];
        
        [_ChargeNum shake:10
            withDelta:5
             andSpeed:0.04];
        
        [self showErrorInfo:@"请输入正确的面额"];
        
        return;
    }
    
    if ([_ChargeNum.text intValue] < 0)
    {
        [_hud hide:YES afterDelay:1];
        
        [_ChargeNum shake:10
                withDelta:5
                 andSpeed:0.04];
        
        [self showErrorInfo:@"请输入正确的面额"];
        return;
    }
    
    if ([_ChargeNum.text intValue] > 5000)
    {
        [_hud hide:YES afterDelay:1];
        
        [_ChargeNum shake:10
                withDelta:5
                 andSpeed:0.04];
        
        [self showErrorInfo:@"单号单日充值最大为5000！"];
        
        return;
    }
    
    [self.view endEditing:YES];
    QcoinMoneyGive *qcoinGive= [[QcoinMoneyGive alloc]initWithNibName:@"QcoinMoneyGive" bundle:nil];
    qcoinGive.PhoneGiveStr= _ChargeNum.text;
    qcoinGive.PhoneGiveStr2=_ChargeNum.text;
    qcoinGive.PhoneNum= _QQNum.text;
    [self.navigationController pushViewController:qcoinGive animated:YES];
    
    /*
    QCoinPayController *qcoinView = [[QCoinPayController alloc] init];
    qcoinView.infos = @[ @"QQ号  码：", @"充值 Q币：", @"实际支付：" ];
    qcoinView.particulars = @[ _QQNum.text, _ChargeNum.text, _ChargeNum.text ];
    [self.navigationController pushViewController:qcoinView animated:YES];
     */
}


#pragma mark 历史记录
-(void)historyRecord
{
    [self.view endEditing:YES];
    MobileRechangeHistoryCtr *mobileRechangeHistoryCtr = [[MobileRechangeHistoryCtr alloc]initWithNibName:@"MobileRechangeHistoryCtr" bundle:nil];
    mobileRechangeHistoryCtr.myChargeHistoryType = QCoinChargeType;
    [self.navigationController pushViewController:mobileRechangeHistoryCtr animated:YES];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL retValue = YES;
    
    if (textField.tag ==QQNumTag) {
        if([[textField text] length] - range.length + string.length > 15)
        {
            retValue=NO;
        }
    }
    
    if (textField.tag ==QQChargeTag) {
        if([[textField text] length] - range.length + string.length > 8)
        {
            retValue=NO;
        }
    }
    
    return retValue;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField != _QQNum) {
		[textField resignFirstResponder];
	} else {
		[self shakePhone];
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
    
    [_ChargeNum resignFirstResponder];
    
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

/*自定义键盘的设置
 -(void)setKeyBoard
 {
 //    self.myTextField.delegate = self;
 [_QQNum addPreviousNextDoneOnKeyboardWithTarget:self previousAction:@selector(previousClicked:) nextAction:@selector(nextClicked:) doneAction:@selector(doneClicked:)];
 
 [_ChargeNum addPreviousNextDoneOnKeyboardWithTarget:self previousAction:@selector(previousClicked:) nextAction:@selector(nextClicked:) doneAction:@selector(doneClicked:)];
 }
 
 -(void)doneClicked:(UIBarButtonItem*)barButton
 {
 [self.view endEditing:YES];
 
 if (_ddTableView!=nil) {
 [self setDDListHidden:YES];
 }
 }
 
 -(void)previousClicked:(UIBarButtonItem*)barButton
 {
 
 }
 -(void)nextClicked:(UIBarButtonItem*)barButton
 {
 
 }
 */


@end