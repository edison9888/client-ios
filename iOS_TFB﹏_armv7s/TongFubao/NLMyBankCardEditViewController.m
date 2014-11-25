//
//  NLMyBankCardEditViewController.m
//  TongFubao
//
//  Created by MD313 on 13-8-5.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLMyBankCardEditViewController.h"
#import "NLUserInforSettingsCell.h"
#import "NLKeyboardAvoid.h"
#import "NLPlistOper.h"
#import "NLContants.h"
#import "NLUtils.h"
#import "NLProtocolRegister.h"
#import "NLCashArriveHistoryViewController.h"
#import "NLReturnSecondViewController.h"
#import "IQKeyboardManager.h"

@interface NLMyBankCardEditViewController ()
{
    NLProgressHUD* _hud;
    
    NSString* _shoucardbank;
    NSString* _shoucardno;
    NSString* _shoucardman;
    NSString* _shoucardmobile;
    
    /*界面布局*/
    TransferInfoView *infoView[4];
    /*所属银行ID*/
    NSString *bankID;
}

@property(nonatomic,retain) IBOutlet NLKeyboardAvoidingTableView* myTableView;

- (IBAction)onNextBtnClicked:(id)sender;

@end

@implementation NLMyBankCardEditViewController
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [NLUtils enableSliderViewController:NO];

    [super viewDidAppear:animated];
    if (animated)
    {
        [self.myTableView flashScrollIndicators];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.view endEditing:YES];
    [NLUtils enableSliderViewController:YES];
    [super viewWillDisappear:animated];
   
}
-(void)setInitValue:(NSString*)bank no:(NSString*)no man:(NSString*)man mobile:(NSString*)mobile
{
    _shoucardbank = bank;
    _shoucardno = no;
    _shoucardman = man;
    _shoucardmobile = mobile;
}

-(void)viewOther
{
    self.navigationController.topViewController.title = @"收款银行卡";
    UITapGestureRecognizer *oneFingerTwoTaps = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(oneFingerTwoTaps)];
    [oneFingerTwoTaps setNumberOfTapsRequired:2];
    [self.view addGestureRecognizer:oneFingerTwoTaps];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    
    ViewControllerProperty;
    
#endif
    [self viewOther];
    [self mainview];
    [self readAuBkCardInfo];
}

/*以前界面太恶心了重新做啊 呔 直接hidden原来的代码*/
-(void)mainview
{
    [self addBackButtonItemWithImage:imageName(@"navigationLeftBtnBack2@2x", @"png")];
    
    NSArray *infoTitles = @[ @"账户", @"银行", @"姓名",@"手机" ];
    NSArray *infoTexts = @[ @"请输入卡号", @"请选择银行", @"请输入姓名",@"请输入手机" ];
    
    UIView *infoBasicView = [UIView viewWithFrame:CGRectMake(16,  16, 288, 50 * 4 )];
    infoBasicView.layer.borderColor = [UIColor grayColor].CGColor;
    infoBasicView.layer.borderWidth = 0.5;
    infoBasicView.layer.cornerRadius = 5.0;
    [self.view addSubview:infoBasicView];
    
    for (int i = 0; i < 4; i++)
    {
        /*分割线*/
        if (i > 0)
        {
            UIImageView *lineView = [UIImageView viewWithFrame:CGRectMake(0, 50 * i, 288, 1) image:imageName(@"line1@2x", @"png")];
            [infoBasicView addSubview:lineView];
        }

        infoView[i] =  [[TransferInfoView alloc] initWithFrame:CGRectMake(0, 50 * i , 288, 45)];
        infoView[i].titleLabel.text       = infoTitles[i];
        infoView[i].infoText.placeholder  = infoTexts[i];
        infoView[i].infoText.delegate     = self;
        infoView[i].infoText.tag          = 3838+i;
        infoView[i].infoText.font         = [UIFont systemFontOfSize:15.0];
        infoView[i].infoText.keyboardType = i == 0 || i == 3 ? UIKeyboardTypeNumberPad : UIKeyboardTypeDefault;
        [infoBasicView addSubview:infoView[i]];
        
        if (i == 1)
        {
            /*点击箭头*/
            UIImageView *changeView = [UIImageView viewWithFrame:CGRectMake(260, 15, 15, 15) image:imageName(@"nextlink_pla@2x", @"png")];
            [infoView[i] addSubview:changeView];
        }
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    BOOL textEdit = YES;
    
    //是否允许用户交互
    if (textField.tag <= 3840)
    {
        textEdit = textField.tag == 3838 || textField.tag == 3840? YES : NO;
        
        //选择银行
        if (textField.tag == 3839)
        {
            
            [self.view endEditing:YES];
            NLBankListViewController *bankListView = [[NLBankListViewController alloc] initWithNibName:@"NLBankListViewController" bundle:nil];
            bankListView.delegate = self;
            [self.navigationController pushViewController:bankListView animated:YES];
        }
        
    }
    
    return textEdit;
}

#pragma mark - 信息检测
- (NSString *)checkWithInfo
{
    if (infoView[0].infoText.text.length == 0 || [infoView[0].infoText.text isEqualToString:@""])
    {
        return @"请输入账号";
    }

    if (infoView[1].infoText.text.length == 0 || [infoView[1].infoText.text isEqualToString:@""])
    {
        return @"请选择银行";
    }

    if (infoView[2].infoText.text.length == 0 || [infoView[2].infoText.text isEqualToString:@""])
    {
        return @"输入姓名";
    }

    if (infoView[3].infoText.text.length == 0 || [infoView[3].infoText.text isEqualToString:@""])
    {
        return @"请输入手机";
    }
    
    return nil;
}

/*读取默认信息*/
-(void)doReadAuBkCardInfoNotify:(NLProtocolResponse*)response
{
    NLProtocolData* data = [response.data find:@"msgbody/aushoucardbank" index:0];
    _shoucardbank = data.value;
    
    if (_shoucardbank && infoView[1].infoText.text.length == 0)
    {
        infoView[1].infoText.text = _shoucardbank;
    }
    
    data = [response.data find:@"msgbody/aushoucardno" index:0];
    _shoucardno = data.value;
    
    if ( _shoucardno && infoView[0].infoText.text.length == 0)
    {
        infoView[0].infoText.text = _shoucardno;
    }
    
    data = [response.data find:@"msgbody/aushoucardman" index:0];
    _shoucardman = data.value;
    
    if (_shoucardman && infoView[2].infoText.text.length == 0)
    {
        infoView[2].infoText.text = _shoucardman;
    }
    
    data = [response.data find:@"msgbody/aushoucardphone" index:0];
    _shoucardmobile = data.value;
    
    if (_shoucardmobile && infoView[3].infoText.text.length == 0)
    {
        infoView[3].infoText.text = _shoucardmobile;
    }
    
    data = [response.data find:@"msgbody/aushoucardstate" index:0];
    NSString* state = data.value;
    if (state && [state isEqualToString:@"1"])
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
    else
    {
        /*不需要编辑 直接显示*/
//        UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleBordered target:self action:@selector(editBankCard)];
//        self.navigationItem.rightBarButtonItem = anotherButton;
    }
    
//    [self.myTableView reloadData];
}


-(void)readAuBkCardInfoNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        [self doReadAuBkCardInfoNotify:response];
    }
    else if (error == RSP_TIMEOUT)
    {
        [self showErrorInfo:@"请求超时,需要重新登录" status:NLHUDState_Error];
        [self performSelector:@selector(doPush) withObject:nil afterDelay:2.0f];
        return;
    }
    else
    {
        NSString* detail = response.detail;
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

/*外包的旧接口 不想改了*/
-(void)readAuBkCardInfo
{
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    NSString* name = [NLUtils getNameForRequest:Notify_readAuBkCardInfo];
    REGISTER_NOTIFY_OBSERVER(self, readAuBkCardInfoNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] readAuBkCardInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)checkReturnLoanInfo
{
    if (infoView[1].infoText.text.length <= 0)
    {
        [self showErrorInfo:@"请选择银行" status:NLHUDState_Error];
        return NO;
    }
    if (![NLUtils checkBankCard:infoView[0].infoText.text])
    {
        [self showErrorInfo:@"请输入正确的银行卡号" status:NLHUDState_Error];
        return NO;
    }
    if (![NLUtils checkName:infoView[2].infoText.text])
    {
        [self showErrorInfo:@"输入正确的姓名" status:NLHUDState_Error];
        return NO;
    }
    if (![NLUtils checkMobilePhone:infoView[3].infoText.text])
    {
        [self showErrorInfo:@"输入正确的手机号码" status:NLHUDState_Error];
        return NO;
    }
    
    return YES;
}

- (IBAction)onNextBtnClicked:(id)sender
{
    if ([self checkReturnLoanInfo])
    {

        [self modifyAuBkCardInfo];
    }
}

- (void)textFieldWithText:(UITextField *)textField
{
    switch (textField.tag)
    {
        case 1://银行卡号
        {
            _shoucardno = textField.text;
        }
            break;
            
        case 2://开户人
        {
            _shoucardman = textField.text;
        }
            break;
            
        case 3://手机号码
        {
            _shoucardmobile = textField.text;
        }
            break;

        default:
            break;
    }
}

#pragma mark - UITableViewDataSource

#ifdef IOS_7

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
    return view;
}

#endif

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NLUserInforSettingsCell *cell =nil;
    static NSString *kCellID = @"NLUsersInforSettingsCell";
    cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (cell == nil)
    {
        NSArray* temp = [[NSBundle mainBundle] loadNibNamed:kCellID owner:self options:nil];
        cell=[temp objectAtIndex:0];
    }
    
    cell.myHeaderLabel.hidden = NO;
    [cell.myHeaderLabel setFrame:CGRectMake(cell.myHeaderLabel.frame.origin.x, cell.myHeaderLabel.frame.origin.y, 100, cell.myHeaderLabel.frame.size.height)];
    cell.myDownrightBtn.hidden = YES;
    cell.myUprightBtn.hidden = YES;
    [cell.myTextField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
    
    switch (indexPath.row)
    {
        case 1:
        {
            cell.myHeaderLabel.text = @"开户银行";
            cell.myContentLabel.hidden = NO;
            [cell.myContentLabel setFrame:CGRectMake(100, cell.myContentLabel.frame.origin.y, 185, cell.myContentLabel.frame.size.height)];
            cell.myContentLabel.textAlignment = NSTextAlignmentLeft;
            
            if (_shoucardbank.length <= 0)
            {
                cell.myContentLabel.text = @"请选择银行";
            }
            else
            {
                cell.myContentLabel.text = _shoucardbank;
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
            
        case 0:
        {
            cell.myHeaderLabel.text = @"账户";
            cell.myContentLabel.hidden = YES;
            cell.myTextField.hidden = NO;
            [cell.myTextField setFrame:CGRectMake(100, cell.myTextField.frame.origin.y, 185, cell.myTextField.frame.size.height)];
            
            if (_shoucardno && _shoucardno.length > 0)
            {
                cell.myTextField.text = _shoucardno;
            }
            else
            {
                cell.myTextField.placeholder = @"请刷卡或输入卡号";
            }
            
            cell.myTextField.tag = 1;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
            break;
            
        case 2:
        {
            cell.myHeaderLabel.text = @"姓名";
            cell.myContentLabel.hidden = YES;
            cell.myTextField.hidden = NO;
            [cell.myTextField setFrame:CGRectMake(100, cell.myTextField.frame.origin.y, 185, cell.myTextField.frame.size.height)];
            
            if (_shoucardman && _shoucardman.length > 0)
            {
                cell.myTextField.text = _shoucardman;
            }
            else
            {
                cell.myTextField.placeholder = @"请输入姓名";
            }
            
            cell.myTextField.tag = 2;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
            break;
            
        case 3:
        {
            cell.myHeaderLabel.text = @"手机";
            cell.myContentLabel.hidden = YES;
            cell.myTextField.hidden = NO;
            [cell.myTextField setFrame:CGRectMake(100, cell.myTextField.frame.origin.y, 185, cell.myTextField.frame.size.height)];
            if (_shoucardmobile && _shoucardmobile.length > 0)
            {
                cell.myTextField.text = _shoucardmobile;
            }
            else
            {
                cell.myTextField.placeholder = @"请输入手机";
            }
            cell.myTextField.tag = 3;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
            break;
            
        default:
            break;
    }

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // set the root controller
    
    int row = indexPath.row;
    if (1 == row)
    {
        [self.view endEditing:YES];
        NLBankListViewController *vc = [[NLBankListViewController alloc] initWithNibName:@"NLBankListViewController" bundle:nil];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma mark NLBankLisDelegate

- (void)dataSearch:(NLBankListViewController *)controller didSelectWithObject:(id)aObject
         withState:(NSString *)state
{
    /*
    _shoucardbank = (NSString*)aObject;
    NLUserInforSettingsCell *cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    if (cell)
    {
        cell.myContentLabel.text = _shoucardbank;
    }
     */
    infoView[1].infoText.text = (NSString *)aObject;
    bankID = state;
}

- (void)dataSearchDidCanceled:(NLBankListViewController *)controller
                    withState:(int)state
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - keyboard hide event

-(void)oneFingerTwoTaps
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UITextField *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    [firstResponder resignFirstResponder];
}

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

#pragma mark - http request

-(void)doModifyAuBkCardInfoNotify:(NLProtocolResponse*)response
{
    NLProtocolData* data = [response.data find:@"msgbody/message" index:0];
    NSString* message = data.value;
    [self showErrorInfo:message status:NLHUDState_NoError];
    [self performSelector:@selector(goBack) withObject:nil afterDelay:2.0f];
    self.delegate.isChanged = YES;
}

-(void)modifyAuBkCardInfoNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [self doModifyAuBkCardInfoNotify:response];
//        [_hud hide:YES];
    }
    else if (error == RSP_TIMEOUT)
    {
        [self showErrorInfo:@"请求超时,需要重新登录" status:NLHUDState_Error];
        [self performSelector:@selector(doPush) withObject:nil afterDelay:2.0f];
        return;
    }
    else
    {
        NSString* detail = response.detail;
        [self showErrorInfo:detail status:NLHUDState_Error];
        [self performSelector:@selector(goBack) withObject:nil afterDelay:1.0f];
    }
}

/*提交*/
-(void)modifyAuBkCardInfo
{
    [self showErrorInfo:@"正在提交信息" status:NLHUDState_None];
    NSString* name = [NLUtils getNameForRequest:Notify_modifyAuBkCardInfo];
    REGISTER_NOTIFY_OBSERVER(self, modifyAuBkCardInfoNotify, name);
    /*
    [[[NLProtocolRequest alloc] initWithRegister:YES] modifyAuBkCardInfo:_shoucardman aushoucardphone:_shoucardmobile aushoucardno:_shoucardno aushoucardbank:_shoucardbank];
    */
    [[[NLProtocolRequest alloc] initWithRegister:YES] modifyAuBkCardInfo:infoView[2].infoText.text aushoucardphone:infoView[3].infoText.text aushoucardno:infoView[0].infoText.text aushoucardbank:infoView[1].infoText.text];
}

-(void)doPush
{
    [_hud hide:YES];
    [NLUtils popToLogonVCByHTTPError:self feedOrLeft:0];
}

-(void)goBack
{
    [self dismissModalViewControllerAnimated:YES];
//    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate

/*/判断数字输入错误的集合
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL input = YES;
    int result = [NLUtils doTextFieldDelegate:textField
                shouldChangeCharactersInRange:range
                            replacementString:string];
    switch (result)
    {
        case 1:
        {
            input = YES;
        }
            break;
        case 0:
        {
            input = NO;
            [self showErrorInfo:@"只能保留二位小数" status:NLHUDState_Error];
        }
            break;
        case 2:
        {
            input = NO;
            [self showErrorInfo:@"第一位不能输入小数点" status:NLHUDState_Error];
        }
            break;
        case 3:
        {
            input = NO;
            [self showErrorInfo:@"不能大于八位数" status:NLHUDState_Error];
        }
            break;
        case 5:
        {
            input = NO;
            [self showErrorInfo:@"第一位不能为0" status:NLHUDState_Error];
        }
            break;
        case 6:
        {
            input = NO;
            [self showErrorInfo:@"粘贴数目第一位为0,请手动输入" status:NLHUDState_Error];
        }
        default:
            break;
    }
    
    return input;
}
*/
@end
