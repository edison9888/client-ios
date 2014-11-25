//
//  NLCashArriveMainViewController.m
//  TongFubao
//
//  Created by MD313 on 13-8-30.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLCashArriveMainViewController.h"
#import "NLCashArriveHistoryViewController.h"
#import "NLProtocolRequest.h"
#import "NLProtocolData.h"
#import "NLProgressHUD.h"
#import "NLUtils.h"
#import "NLUserInforSettingsCell.h"
#import "NLKeyboardAvoid.h"
#import "NLCashSecondViewController.h"

@interface NLCashArriveMainViewController ()
{
    NSString* _commercial;
    NSString* _arrive;
    NSString* _couponid;
    NSString* _couponmoney;
    int _count;
    NLProgressHUD* _hud;
    
    
    //总额限制
    NSInteger limitNum;
    
    //张数限制
    NSInteger limitBuyNum;
}

@property(nonatomic,retain) IBOutlet NLKeyboardAvoidingTableView* myTableView;
@property(nonatomic,retain) IBOutlet UIButton* myBuyNowBtn;
@property(nonatomic,retain) NSMutableArray* mycouponArray;

- (IBAction)onBuyNowBtnClicked:(id)sender;

@end

@implementation NLCashArriveMainViewController

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
    _commercial = @"";
    _arrive = @"";
    _couponid = @"";
    _couponmoney = @"1";
    _count = 0;
    self.mycouponArray = [NSMutableArray arrayWithCapacity:1];
}

-(void)viewDidAppear:(BOOL)animated
{
    [NLUtils enableSliderViewController:NO];
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [NLUtils enableSliderViewController:YES];
    [super viewWillDisappear:animated];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.topViewController.title = @"商户收款";
    [self initValue];
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"商户收款历史"
                                                                      style:UIBarButtonItemStyleBordered target:self
                                                                     action:@selector(buyHistory)];
	self.navigationItem.rightBarButtonItem = anotherButton;
   
    [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
    
    UITapGestureRecognizer *oneFingerTwoTaps = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(oneFingerTwoTaps)];
    // Set required taps and number of touches
    [oneFingerTwoTaps setNumberOfTapsRequired:2];
    //[oneFingerTwoTaps setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:oneFingerTwoTaps];
    [self readcouponinfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)checkInfor
{
    if (_couponmoney.length <= 0)
    {
        [self showErrorInfo:@"商户收款" status:NLHUDState_Error];
        return NO;
    }
    
    if (_count == 0||_count<0)
    {
        [self showErrorInfo:@"选择购买数量" status:NLHUDState_Error];
        return NO;
    }
    
    if (_count * [_couponmoney doubleValue]>limitNum) {
        [self showErrorInfo:@"购买数量过多" status:NLHUDState_Error];
        return NO;
    }

    return YES;
}

- (IBAction)onBuyNowBtnClicked:(id)sender
{
    if ([self checkInfor])
    {
        NLCashSecondViewController* vc = [[NLCashSecondViewController alloc] initWithNibName:@"NLCashSecondViewController"
                                                                                      bundle:nil];
        double sum = _count * [_couponmoney doubleValue];
        NSString* couponmoney = [NSString stringWithFormat:@"%.2f",sum];
        vc.myDictionary = [NSDictionary dictionaryWithObjectsAndKeys:_couponid,@"couponid",couponmoney,@"couponmoney", nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)buyHistory
{
    NLCashArriveHistoryViewController* vc = [[NLCashArriveHistoryViewController alloc] initWithNibName:@"NLCashArriveHistoryViewController" bundle:nil] ;
    vc.myHistoryRecordType = NLHistoryRecordType_CashArrive;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)refreshCountCell
{
    NLUserInforSettingsCell *cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    if (cell)
    {
        cell.myTextField.text = [NSString stringWithFormat:@"%d",_count];
    }
}

-(void)doDownrightBtnClicked:(id)sender
{
    if (_count > 0)
    {
        _count--;
        [self refreshCountCell];
    }
    
    return;
}

-(void)doUprightBtnClicked:(id)sender
{
    if (_count >=100)
    {
        [self showErrorInfo:@"数量最多为100张" status:NLHUDState_Error];
        return;
    }
    _count++;
    [self refreshCountCell];
    return;
}

- (void)textFieldWithText:(UITextField *)textField
{
    switch (textField.tag)
    {
        case 0://收款人卡号
        {
            _count = [textField.text intValue];
        }
            break;
        
        default:
            break;
    }
}

#pragma mark - NLOnceListDelegate
- (void)doClickedEvent:(int)index object:(NSString*)object
{
    _couponid = [[self.mycouponArray objectAtIndex:index] objectForKey:@"couponid"];
    _couponmoney = [[self.mycouponArray objectAtIndex:index] objectForKey:@"couponmoney"];
    limitBuyNum = [[[self.mycouponArray objectAtIndex:index] objectForKey:@"couponlimitnum"] intValue];
    NLUserInforSettingsCell* cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    cell.myContentLabel.text = _couponmoney;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
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
    cell.mySelectedBtn.hidden = YES;
    [cell.myTextField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];

    switch (indexPath.row)
    {
        case 0:
        {
            cell.myHeaderLabel.text = @"所属商户";
            cell.myContentLabel.hidden = NO;
            cell.myContentLabel.textAlignment = NSTextAlignmentLeft;
            cell.myContentLabel.text = _commercial;
            cell.myTextField.hidden = YES;
            cell.myDownrightBtn.hidden = YES;
            cell.myUprightBtn.hidden = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
            break;
            
        case 1:
        {
            cell.myHeaderLabel.text = @"抵用券额度";
            cell.myContentLabel.hidden = NO;
            cell.myContentLabel.textAlignment = UITextAlignmentCenter;
            if (_arrive.length > 0)
            {
                cell.myContentLabel.text = _arrive;
            }
            else
            {
                if ([_couponmoney isEqualToString:@""]) {
                 cell.myContentLabel.text = @"选择抵用券额度";
                }else{
                    cell.myContentLabel.text = _couponmoney;
                }

            }
            cell.myTextField.hidden = YES;
            cell.myDownrightBtn.hidden = YES;
            cell.myUprightBtn.hidden = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
            
        case 2:
        {
            cell.myContainer = self;
            cell.myHeaderLabel.text = @"购买数量";
            cell.myContentLabel.hidden = YES;
            
//            cell.myUprightBtn.hidden = NO;
//            [cell.myUprightBtn setFrame:CGRectMake(100, 5,34,34/*cell.myUprightBtn.frame.origin.y, cell.myUprightBtn.frame.size.width, cell.myUprightBtn.frame.size.height*/)];
//            [cell.myUprightBtn setBackgroundImage:[UIImage imageNamed:@"BetteryMainBetteryFull.png"] forState:UIControlStateNormal];
//            [cell.myUprightBtn setTitle:@"+" forState:UIControlStateNormal];
            
            cell.myTextField.hidden = NO;
            cell.myTextField.delegate = self;
            cell.myTextField.placeholder = @"请输入购买数量";
            [cell.myTextField setFrame:CGRectMake(120, cell.myTextField.frame.origin.y, 140, cell.myTextField.frame.size.height)];
            cell.myTextField.textAlignment = NSTextAlignmentCenter;
            cell.myTextField.backgroundColor = [UIColor clearColor];
            cell.myTextField.keyboardType = UIKeyboardTypeNumberPad;
            if (_count!=0) {
                cell.myTextField.text = [NSString stringWithFormat:@"%d",_count];
            }

//            cell.myDownrightBtn.hidden = NO;
//            [cell.myDownrightBtn setFrame:CGRectMake(250, 5,34,34/*cell.myDownrightBtn.frame.origin.y, cell.myDownrightBtn.frame.size.width, cell.myDownrightBtn.frame.size.height*/)];
//             [cell.myDownrightBtn setBackgroundImage:[UIImage imageNamed:@"BetteryMainBetteryFull.png"] forState:UIControlStateNormal];
//            [cell.myDownrightBtn setTitle:@"-" forState:UIControlStateNormal];
           
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (1 == indexPath.row)
    {
        NLOnceListViewController *vc = [[NLOnceListViewController alloc] initWithNibName:@"NLOnceListViewController" bundle:nil];
        vc.myDelegate = self;
        NSMutableArray* arr = [NSMutableArray arrayWithCapacity:1];
        NSString* str = nil;
        for (int i=0; i<[self.mycouponArray count]; i++)
        {
            str =[[self.mycouponArray objectAtIndex:i] objectForKey:@"couponmoney"];
            [arr addObject:str];
        }
        vc.myArry = [NSArray arrayWithArray:arr];
        [self.navigationController pushViewController:vc animated:YES];
    }
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

-(NSString*)getNoNilStr:(NSString*)str
{
    if (str == nil)
    {
        return @"";
    }
    return str;
}

-(void)doReadcouponinfoNotify:(NLProtocolResponse*)response
{
    NLProtocolData* data =  [response.data find:@"msgbody/shopname" index:0];
    _commercial = data.value;
    NLUserInforSettingsCell* cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.myContentLabel.text = _commercial;
    
    NSArray* couponmoney = [response.data find:@"msgbody/msgchild/couponmoney"];
    NSString* couponmoneyStr = nil;
    NSArray* couponid = [response.data find:@"msgbody/msgchild/couponid"];
    NSString* couponidStr = nil;
    NSArray *couponlimitnum = [response.data find:@"msgbody/msgchild/couponlimitnum"];
    NSString *couponlimitnumStr =nil;
    
    int count = [couponmoney count];
    for (int i=0; i<count; i++)
    {
        data = [couponmoney objectAtIndex:i];
        couponmoneyStr = [self getNoNilStr:data.value];
        data = [couponid objectAtIndex:i];
        couponidStr = [self getNoNilStr:data.value];
        data = [couponlimitnum objectAtIndex:i];
        couponlimitnumStr = [self getNoNilStr:data.value];
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:couponmoneyStr,@"couponmoney",couponlimitnumStr,@"couponlimitnum",couponidStr,@"couponid",nil];
        [self.mycouponArray addObject:dic];
    }
    
    if (count>0) {
        NSDictionary *firstDic = self.mycouponArray[0];
        limitBuyNum = [firstDic[@"couponlimitnum"]intValue];
        limitNum = [firstDic[@"couponmoney"]integerValue]*[firstDic[@"couponlimitnum"]integerValue];
    }
}

-(void)readcouponinfoNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        [self doReadcouponinfoNotify:response];
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
        if (!detail || detail.length <= 0)
        {
            detail = @"请求失败，请检查网络";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

-(void)readcouponinfo
{
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    NSString* name = [NLUtils getNameForRequest:Notify_readcouponinfo];
    REGISTER_NOTIFY_OBSERVER(self, readcouponinfoNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] readcouponinfo];
}

- (void) doPush
{
    [_hud hide:YES];
    [NLUtils popToLogonVCByHTTPError:self feedOrLeft:1];
}

#pragma mark - UITextFieldDetegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString  *str = [NSString stringWithFormat:@"%@%@",textField.text,string];
    if (limitBuyNum>0&&[str doubleValue] > limitBuyNum)
    {
        [self showErrorInfo:[NSString stringWithFormat:@"数量最多为%d张",limitBuyNum] status:NLHUDState_Error];
        return NO;
    }
    return YES;
}

@end
