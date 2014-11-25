//
//  NLOrderPaySecondViewController.m
//  TongFubao
//
//  Created by MD313 on 13-9-30.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLOrderPaySecondViewController.h"
#import "NLUserInforSettingsCell.h"
#import "NLProgressHUD.h"
#import "NLContants.h"
#import "NLUtils.h"
#import "NLProgressHUD.h"
#import "NLProtocolRequest.h"
#import "NLOrderPayThirdViewController.h"

@interface NLOrderPaySecondViewController ()
{
    NSString* _payCardCheck;
    BOOL _enablePayCard;
    NSString* _resultPayCard;
    NSString* _bankname;
    NSString* _bankcardno;
    NSString* _paycardid;
    BOOL _enableCardImage;
    VisaReader* _visaReader;
    NLProgressHUD* _hud;
    NSArray* _visaReaderArray;
}

@property(nonatomic,strong)IBOutlet UILabel* myNumberLabel;
@property(nonatomic,strong)IBOutlet UILabel* myDateLabel;
@property(nonatomic,strong)IBOutlet UILabel* myMoneyLabel;
@property(nonatomic,strong)IBOutlet UITableView* myTableView;
@property(nonatomic,strong)IBOutlet UIButton* mySureButton;

-(IBAction)onSureBtnClicked:(id)sender;

@end

@implementation NLOrderPaySecondViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.topViewController.title = @"刷卡";
    _enableCardImage = NO;
    _enablePayCard = YES;
    _resultPayCard = @"";
    _payCardCheck = @"";
    [self initLabels];
    [self initVisaReader];
    UITapGestureRecognizer *oneFingerTwoTaps = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(oneFingerTwoTaps)];
    // Set required taps and number of touches
    [oneFingerTwoTaps setNumberOfTapsRequired:2];
    //[oneFingerTwoTaps setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:oneFingerTwoTaps];
}

-(void)viewDidAppear:(BOOL)animated
{
    [NLUtils enableSliderViewController:NO];
    [self startVisaReader];
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [NLUtils enableSliderViewController:YES];
    [self stopVisaReader];
    [super viewWillDisappear:animated];
}

-(void)initVisaReader
{
    //_visaReader = [[VisaReader alloc] initWithDelegate:self];
    _visaReader = [VisaReader initWithDelegate:self];
    [_visaReader createVisaReader];
}

-(void)startVisaReader
{
    if (_visaReader)
    {
        [_visaReader resetVisaReader:YES];
    }
}

-(void)stopVisaReader
{
    if (_visaReader)
    {
        [_visaReader resetVisaReader:NO];
    }
}

-(void)initLabels
{
    self.myNumberLabel.text = [self.myDictionary objectForKey:@"orderno"];
    self.myDateLabel.text = [self.myDictionary objectForKey:@"ordertime"];
    self.myMoneyLabel.text = [self.myDictionary objectForKey:@"ordermoney"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showErrorInfo:(NSString*)error status:(NLHUDState)status
{
    [_hud hide:YES];
    _hud = [[NLProgressHUD alloc] initWithParentView: self.view];
    
    switch (status)
    {
        case NLHUDState_Error:
        {
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unCheckmark.png"]] ;
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.detailsLabelText = error;
            [_hud show:YES];
            [_hud hide:YES afterDelay:2];
        }
            break;
            
        case NLHUDState_NoError:
        {
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.png"]] ;
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.labelText = error;
            [_hud show:YES];
            [_hud hide:YES afterDelay:2];
        }
            break;
            
        case NLHUDState_None:
        {
            _hud.labelText = error;
            [_hud show:YES];
        }
            break;
            
        default:
            break;
    }
    
    return;
}

-(BOOL)checkInfor
{
    if (_bankname.length <= 0)
    {
        [self showErrorInfo:@"请选择银行" status:NLHUDState_Error];
        return NO;
    }
    if (![NLUtils checkBankCard:_bankcardno])
    {
        [self showErrorInfo:@"请输入正确的银行卡号" status:NLHUDState_Error];
        return NO;
    }
    return YES;
}

-(IBAction)onSureBtnClicked:(id)sender
{
    if ([self checkInfor])
    {
        NLOrderPayThirdViewController* vc = [[NLOrderPayThirdViewController alloc] initWithNibName:@"NLOrderPayThirdViewController"
                                                                                            bundle:nil];
        vc.myDictionary = [NSDictionary dictionaryWithObjectsAndKeys:self.myNumberLabel.text,@"orderno",self.myDateLabel.text,@"ordertime",self.myMoneyLabel.text,@"ordermoney",_bankcardno,@"cardno",self.myMoneyLabel.text,@"ordermoney",[_visaReaderArray objectAtIndex:2],@"merReserved",_bankname,@"bankname", [self.myDictionary objectForKey:@"orderid"],@"orderid",nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
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
    cell.myDownrightBtn.hidden = YES;
    cell.myUprightBtn.hidden = YES;
    cell.myContentLabel.hidden = YES;
    cell.mySelectedBtn.hidden = YES;
    cell.myContainer = self;
    [cell.myTextField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
    
    if (0 == indexPath.row)
    {
        cell.myTextField.hidden = YES;
        cell.mySelectedBtn.hidden = YES;
        cell.myHeaderLabel.text = @"选择银行";
        cell.myContentLabel.hidden = NO;
        cell.myContentLabel.textAlignment = NSTextAlignmentLeft;
        if (!_bankname)
        {
            cell.myContentLabel.text = @"请选择银行";
        }
        else
        {
            cell.myContentLabel.text = _bankname;
            
        }
        cell.userInteractionEnabled = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (1 == indexPath.row)
    {
        cell.myContentLabel.hidden = YES;
        cell.myHeaderLabel.text = @"收款账户";
        cell.myTextField.hidden = NO;
        cell.myTextField.tag = 0;
        cell.myTextField.enabled = NO;
        cell.myTextField.keyboardType = UIKeyboardTypeNumberPad;
        [cell.myTextField setFrame:CGRectMake(cell.myTextField.frame.origin.x, cell.myTextField.frame.origin.y, 155, cell.myTextField.frame.size.height)];
        if ([_bankcardno length] <= 0)//卡号长度
        {
            cell.myTextField.placeholder = @"刷卡获取卡号";
        }
        else
        {
            cell.myTextField.text = _bankcardno;
        }
        cell.myUprightImage.hidden = NO;
        [cell.myUprightImage setFrame:CGRectMake(260, 7, 30, 30)];
        if (_enableCardImage)
        {
            cell.myUprightImage.image = [UIImage imageNamed:@"swipingCard2.png"];
        }
        else
        {
            cell.myUprightImage.image = [UIImage imageNamed:@"swipingCard.png"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self oneFingerTwoTaps];
    int section = indexPath.section;
    if (0 == section)
    {
        int row = indexPath.row;
        if (0 == row)
        {
            NLBankListViewController *vc = [[NLBankListViewController alloc] initWithNibName:@"NLBankListViewController" bundle:nil];
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//卡号获取
- (void)textFieldWithText:(UITextField *)textField
{
    switch (textField.tag)
    {
        case 0://卡号
            _bankcardno = textField.text;
            break;
        default:
            break;
    }
}

#pragma mark - NLBankLisDelegate

- (void)dataSearch:(NLBankListViewController *)controller didSelectWithObject:(id)aObject
         withState:(int)state
{
    _bankname = (NSString*)aObject;

    NLUserInforSettingsCell *cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (cell)
    {
        cell.myContentLabel.text = _bankname;
    }
}

- (void)dataSearchDidCanceled:(NLBankListViewController *)controller
                    withState:(int)state
{
    //[controller dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - keyboard hide event

-(void)oneFingerTwoTaps
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UITextField *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    [firstResponder resignFirstResponder];
}

#pragma mark - VisaReaderDelegate
-(void)doVisaReaderEvent:(SwiperReaderStatus)event object:(NSString*)object
{
    //NSLog(@"event = %d,object = %@",event,object);
    if (SRS_DeviceAvailable == event && [object isEqualToString:@"0"])
    {
        [self resetCardImage:YES];
    }
    else if (SRS_DeviceUnavailable == event)
    {
        [self resetCardImage:NO];
    }
    else if (SRS_Unknown == event)
    {
        [self showErrorInfo:@"刷卡失败，请拔出刷卡器后重新操作" status:NLHUDState_Error];
    }
    else if (SRS_OK == event)
    {
        [self doSRS_OK:object];
    }
}

-(void)doSRS_OK:(NSString*)str
{
    _visaReaderArray = [str componentsSeparatedByString:@"***@@@$$$"];//字符串切割成数组 获取里面的值
    NSLog(@"Cow _visaReaderArray%@",_visaReaderArray);
    if (_visaReaderArray.count >= 3)
    {
        NSString *str = [_visaReaderArray objectAtIndex:0];
        if ([str isEqualToString:@""])
        {
            return;
        }
        if ([[str substringToIndex:2] intValue] >0)
        {
        _bankcardno = [_visaReaderArray objectAtIndex:0];//获取卡号信息
            NSLog(@"Cow _bankcardno_1 %@",_bankcardno);
        _payCardCheck = [_visaReaderArray objectAtIndex:1];
            NSLog(@"Cow _payCardCheck_1%@",_payCardCheck);
        if (_payCardCheck.length >= 14)
        {
            _payCardCheck = [_payCardCheck substringToIndex:14];
            _payCardCheck = [_payCardCheck lowercaseString];
            NSLog(@"Cow _payCardCheck_2%@",_payCardCheck);
        }
        [self resetCardNumber:_bankcardno];
            NSLog(@"Cow _bankcardno_2 %@",_bankcardno);
        [self payCardCheck];
        }
    }
    else
    {
        [self showErrorInfo:@"刷卡失败，请重新操作" status:NLHUDState_None];
    }
}

-(void)resetCardImage:(BOOL)enable
{
    if (enable == YES)
    {
        _enableCardImage = YES;
        NLUserInforSettingsCell* cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        cell.myUprightImage.image = [UIImage imageNamed:@"swipingCard2.png"];
    }
    else
    {
        _enableCardImage = NO;
        NLUserInforSettingsCell* cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        cell.myUprightImage.image = [UIImage imageNamed:@"swipingCard.png"];
    }
}

-(void)resetCardNumber:(NSString*)str
{
    if (str.length > 0)
    {
        NLUserInforSettingsCell* cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        cell.myTextField.text = str;
    }
}

#pragma mark - http request
-(void)doPayCardCheckNotify:(NLProtocolResponse*)response
{
    NLProtocolData* data = [response.data find:@"msgbody/result" index:0];
    NSString* result = data.value;
    [self showErrorInfo:result status:NLHUDState_NoError];
}

-(void)payCardCheckNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    NSString* detail = response.detail;
    int error = response.errcode;
    if (error == RSP_NO_ERROR)
    {
        _enablePayCard = YES;
        [self doPayCardCheckNotify:response];
    }
    else if (error == RSP_TIMEOUT)
    {
        [self showErrorInfo:@"请求超时,需要重新登录" status:NLHUDState_Error];
        [self performSelector:@selector(doPush) withObject:nil afterDelay:2.0f];
        return;
    }
    else
    {
        _enablePayCard = NO;
        if (!detail || detail.length <= 0)
        {
            detail = @"服务器繁忙，请稍候再试";
        }
        _resultPayCard = detail;
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

//检查刷卡器 url
-(void)payCardCheck
{
    NSString* name = [NLUtils getNameForRequest:Notify_payCardCheck];
    REGISTER_NOTIFY_OBSERVER(self, payCardCheckNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] payCardCheck:_payCardCheck];
    [self showErrorInfo:@"正在验证刷卡器" status:NLHUDState_None];
}

@end
