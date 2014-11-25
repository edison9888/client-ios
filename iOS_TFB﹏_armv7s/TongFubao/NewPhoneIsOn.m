//
//  NewPhoneIsOn.m
//  TongFubao
//
//  Created by  俊   on 14-5-5.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "NewPhoneIsOn.h"
#import "NLKeyboardAvoid.h"
#import "NLRechargeCreditCardThirdViewController.h"
#import "NLUserInforSettingsCell.h"
#import "NLProgressHUD.h"
#import "NLProtocolRegister.h"
#import "NLUtils.h"
#import "GTMBase64.h"
#import "PhoneMoneyToOK.h"
#import "NLTransferResultViewController.h"

@interface NewPhoneIsOn ()
{
    NSString *_cardno;
    NSString *_paycardid;
    NSString* _payCardCheck;

    BOOL _enablePayCard;
    NSString* _resultPayCard;
    BOOL _enableCardImage;
    NLProgressHUD* _hud;
    VisaReader* _visaReader;
    NSArray* _visaReaderArray;
   
}

@property (weak, nonatomic) IBOutlet UIButton *OnBtnClick;
@property (strong, nonatomic) IBOutlet NLKeyboardAvoidingTableView *tableViewFrame;

@end

@implementation NewPhoneIsOn

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)initValue
{
    _enablePayCard= YES;
    _enableCardImage = NO;
    _payCardCheck = @"";
    
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

//刷卡时间
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.topViewController.title = @"新手机验证";
    self.view.backgroundColor= RGBACOLOR(246, 250, 251, 1);
    [self addBackButtonItemWithImage:imageName(@"navigationLeftBtnBack2@2x", @"png")];
    
    [self initVisaReader];
    
    UITapGestureRecognizer *oneFingerTwoTaps = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(oneFingerTwoTaps)];
    // Set required taps and number of touches
    [oneFingerTwoTaps setNumberOfTapsRequired:1];
    
    [self.myTableView addGestureRecognizer:oneFingerTwoTaps];
    
}


//完成信息
-(IBAction)onButtonBtnClicked:(id)sender
{
    if ([self checkTransferInfo])//确认提交 检查是否正确信息
    {
      
        
    }
}

#pragma mark - UITableViewDataSource

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
    
    switch (indexPath.section)
    {
        case 0:
        {
            cell.myHeaderLabel.hidden = NO;
            cell.myTextField.hidden = NO;
            cell.myContentLabel.hidden = YES;
            
            switch (indexPath.row)
            {

            case 0:
        {
            cell.myHeaderLabel.text= @"新手机验证：";
            
            cell.myTextField.keyboardType = UIKeyboardTypeNumberPad;
            
             cell.myTextField.placeholder = @"请输入您的新手机";
    
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
            break;
        case 3:
        {
            cell.myHeaderLabel.text = @"收款账户";
            
            cell.myContentLabel.hidden = YES;
            
            cell.myTextField.hidden = NO;
            
            cell.myTextField.enabled = NO;
            
            cell.myTextField.keyboardType = UIKeyboardTypeNumberPad;
            
            [cell.myTextField setFrame:CGRectMake(cell.myTextField.frame.origin.x, cell.myTextField.frame.origin.y, 155, cell.myTextField.frame.size.height)];
            
            if ([_cardno length] <= 0)
            {
                cell.myTextField.placeholder = @"刷卡获取卡号";
                NSLog(@"_cardno lenth%d",_cardno.length);
            }
            else
            {
                cell.myTextField.text = _cardno;
                
                NSLog(@"_cardno %@",_cardno);
            }
            cell.myUprightImage.hidden = NO;
            
            [cell.myUprightImage setFrame:CGRectMake(260, 7, 30, 30)];
            if (_enableCardImage)//判断bool状态
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

            break;
                    
            case 1:
        {
            cell.myHeaderLabel.text = @"原支付密码：";
            
            cell.myTextField.placeholder = @"请输入您原支付密码";
            
            cell.myTextField.keyboardType = UIKeyboardTypeASCIICapable;
            
            cell.myTextField.secureTextEntry = YES;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
            break;
                    
            case 2:
        {
            cell.myHeaderLabel.text = @"开户人姓名：";
            
            cell.myTextField.placeholder = @"请输入您卡号的开户人姓名";
            
            cell.myTextField.keyboardType = UIKeyboardTypeNamePhonePad;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        }
    }
}
        default:
            break;
        }
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, 30);
    
    UIView* view = [[UIView alloc] initWithFrame:rect];
    
    [view setBackgroundColor:[UIColor clearColor]];
    
    rect.origin.x = 20;
    
    rect.origin.y = 5;
    
    rect.size.width = 300;
    
    rect.size.height = 20;
    
    UILabel* label = [[UILabel alloc] initWithFrame:rect];
    
    label.adjustsFontSizeToFitWidth = NO;
    
    label.backgroundColor=[UIColor clearColor];
    
    label.font=[UIFont systemFontOfSize:17];
    
    label.textColor = [UIColor lightGrayColor];
    
    if (0 == section)
    {
        label.text = @"新手机验证信息";
    }
    [view addSubview:label];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma showErrorInfo
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
    else if (SRS_OK == event)
    {
        [self doSRS_OK:object];
    }
}

//检测是否插入刷卡器
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

#pragma mark - oPayCardCheck
//验证刷卡器卡号的长度
-(BOOL)checkTransferInfo
{
    if (_cardno.length<=0)
    {
        [self showErrorInfo:@"亲，请插入通付宝刷卡器并刷卡验证" status:NLHUDState_Error];
        return NO;
    }
    return YES;
}

-(void)doSRS_OK:(NSString*)str
{
    _visaReaderArray = [str componentsSeparatedByString:@"***@@@$$$"];
    if (_visaReaderArray.count >= 3)
    {
        NSString *str = [_visaReaderArray objectAtIndex:0];
        if ([str isEqualToString:@""])
        {
            return;
        }
        if ([[str substringToIndex:2] intValue] >0)
        {
            _cardno = [_visaReaderArray objectAtIndex:0];
            _paycardid = [_visaReaderArray objectAtIndex:1];
            if (_paycardid.length >= 14)
            {
                _paycardid = [_paycardid substringToIndex:14];
                _paycardid = [_paycardid lowercaseString];
            }
            _payCardCheck = _paycardid;
            
            [self resetCardNumber:_cardno];
            
            [self payCardCheck];
        }
    }
}

//检查啦号信息
-(void)payCardCheck
{
    NSString* name = [NLUtils getNameForRequest:Notify_payCardCheck];
    REGISTER_NOTIFY_OBSERVER(self, payCardCheckNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] payCardCheck:_payCardCheck];
    [self showErrorInfo:@"正在验证刷卡器" status:NLHUDState_None];
}


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

- (void) doPush
{
    [_hud hide:YES];
    [NLUtils popToLogonVCByHTTPError:self feedOrLeft:1];
}

@end
