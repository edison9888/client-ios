//
//  NLTransferRemittanceViewController.m
//  TongFubao
//
//  Created by MD313 on 13-8-5.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLTransferRemittanceViewController.h"
#import "NLKeyboardAvoid.h"
#import "NLUserInforSettingsCell.h"
#import "NLSpeUserInforSettingsCell.h"
#import "NLTransferResultViewController.h"
#import "NLCashArriveHistoryViewController.h"
#import "NLUtils.h"
#import "NLContants.h"
#import "NLPlistOper.h"
#import "NLProgressHUD.h"
#import "NLProtocolRequest.h"
#import "NLShowTextViewController.h"
#import "NLTransferSecondViewController.h"
#import "NLHistoricalAccountViewController.h"
#import "VisaReader.h"

typedef enum
{
    TableViewHistoricalAccountRowType = 0,
    TableViewCardBankRowType,
    TableViewCardNunberRowType,
    TableViewReCardNumberRowType,
    TableViewCardNameRowType,
    TableViewPayMoneyRowType,
    TableViewPayFeeRowType,
    
    TableViewSecondSectionType,
    TableViewGetAccountTimeRowType,
    
    TableViewThirdSectionType,
    TableViewCardMemoRowType,
    TableViewNoteReceivablesRowType,
    TableViewCardMobileRowType
}TransferRemittanceTavleViewRowType;

@interface NLTransferRemittanceViewController ()
{
    //普通
    int _arriveType;
    int _arriveTimeIndex;
    NSString* _paycardid;
    NSString* _shoucardno;
    NSString* _reshoucardno;
    NSString* _shoucardbank;
    NSString* _paymoney;
    NSString* _payfee;
    NSString* _money;
    NSString* _shoucardmobile;
    NSString* _shoucardman;
    NSString* _arriveid;
    NSString* _arriveidStr;
    NSString* _shoucardmemo;
    NSString* _sendsms;
    NSString* _bankid;
    VisaReader* _visaReader;
    BOOL _hasRead;
    BOOL _editCash;
    BOOL _freeNotify;
    
    //超级
    int _suparriveType;
    int _suparriveTimeIndex;
    NSString* _resultPayCard;
    NSString* _suppaycardid;
    NSString* _supshoucardno;
    NSString* _supreshoucardno;
    NSString* _supshoucardbank;
    NSString* _suppaymoney;
    NSString* _suppayfee;
    NSString* _supmoney;
    NSString* _supshoucardmobile;
    NSString* _supshoucardman;
    NSString* _suparriveid;
    NSString* _suparriveidStr;
    NSString* _supshoucardmemo;
    NSString* _supsendsms;
    NSString* _supbankid;
    NSString* _payCardCheck;
    NSArray* _visaReaderArray;
    BOOL _suphasRead;
    BOOL _supeditCash;
    BOOL _supfreeNotify;
    BOOL _enablePayCard;
    BOOL _enableCardImage;
    
    NSString* _transferType; //0.转账汇款 1.超级汇款
    NLProgressHUD* _hud;
    
    /*刷卡器对比信用卡信息*/
    NSString * bkcardyxmonthStr;
    NSString * bkcardbanknameStr;
    NSString * bkcardbankidCheckStr;
    NSString * bkcardphoneStr;
    NSString * bkcardmanCheckStr;
    NSString * bkcardnoCheckStr;
    NSString * bkcardtypeStr;
    NSString * bkcardidcardStr;
    NSString * bkcardcvvStr;
    NSString * bkcardyxyearStr;
    
    /*刷卡后获取列表不能点击*/
    BOOL flagSK;
}

@property(nonatomic,retain) IBOutlet UIButton* myNextBtn;
@property(nonatomic,retain) IBOutlet NLKeyboardAvoidingTableView* myTableView;
@property(nonatomic,retain) NSMutableArray* myBankArray;
@property(nonatomic,retain) NSMutableArray* myArriveTimeArray;
@property(nonatomic,retain) NSMutableArray* mySupArriveTimeArray;
@property(nonatomic,retain) UIButton* myHasReadBtn;
@property(nonatomic,retain) UIButton* myShowProtocolBtn;
@property (strong, nonatomic) IBOutlet UIImageView *myTopImageView;

- (IBAction)onLeftBtn:(id)sender;
- (IBAction)onRightBtn:(id)sender;
- (IBAction)onNextBtnClicked:(id)sender;

-(void)createBankArray;

@end

@implementation NLTransferRemittanceViewController

@synthesize myTableView;
@synthesize myNextBtn;
@synthesize myBankArray;

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
    
    [self startVisaReader];
    
    [super viewDidAppear:animated];
    
    if (animated)
    {
        [self.myTableView flashScrollIndicators];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [NLUtils enableSliderViewController:YES];
  
    [self stopVisaReader];

    [super viewWillDisappear:animated];
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

-(void)initVisaReader
{
    //_visaReader = [[VisaReader alloc] initWithDelegate:self];
    _visaReader = [VisaReader initWithDelegate:self];
    [_visaReader createVisaReader];
}

-(void)initValue
{
    flagSK= YES;
    
    //普通
    _arriveType = -1;
    _arriveTimeIndex = -1;
    _paycardid = @"";
    _shoucardno = @"";
    _reshoucardno = @"";
    _shoucardbank = @"";
    _paymoney = @"";
    _payfee = @"";
    _money = @"";
    _shoucardmobile = @"";
    _shoucardman = @"";
    _arriveid = @"";
    _arriveidStr = @"";
    _shoucardmemo = @"";
    _sendsms = @"";
    _bankid = @"";
    _hasRead = YES;
    _editCash = NO;
    _freeNotify = YES;
    _enableCardImage = NO;
    _resultPayCard = @"";
    
    //超级
    _suparriveType = -1;
    _suparriveTimeIndex = -1;
    _suppaycardid = @"";
    _supshoucardno = @"";
    _supreshoucardno = @"";
    _supshoucardbank = @"";
    _suppaymoney = @"";
    _suppayfee = @"";
    _supmoney = @"";
    _supshoucardmobile = @"";
    _supshoucardman = @"";
    _suparriveid = @"";
    _suparriveidStr = @"";
    _supshoucardmemo = @"";
    _supsendsms = @"";
    _supbankid = @"";
    _suphasRead = YES;
    _supeditCash = NO;
    _supfreeNotify = YES;
    _enablePayCard = YES;
     _payCardCheck = @"";
    
    _transferType = @"1";
    
    self.myArriveTimeArray = [NSMutableArray arrayWithCapacity:10];
    self.mySupArriveTimeArray = [NSMutableArray arrayWithCapacity:10];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.topViewController.title = @"转账汇款";
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"历史记录"
                                                                      style:UIBarButtonItemStyleBordered
                                                                     target:self
                                                                     action:@selector(historyRecord)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    
    [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
    
    [self initValue];
    [self initVisaReader];
    [self createBankArray];
    
    UITapGestureRecognizer *oneFingerTwoTaps = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(oneFingerTwoTaps)];
    // Set required taps and number of touches
    [oneFingerTwoTaps setNumberOfTapsRequired:2];
    //[oneFingerTwoTaps setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:oneFingerTwoTaps];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)historyRecord
{
    NLCashArriveHistoryViewController *vc = [[NLCashArriveHistoryViewController alloc] initWithNibName:@"NLCashArriveHistoryViewController" bundle:nil];
    vc.myHistoryRecordType = [_transferType isEqualToString:@"0"]? NLHistoryRecordType_TransferMoney : NLHistoryRecordType_SupTransferMoney;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)createBankArray
{
    
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
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unCheckmark.png"]];
            _hud.mode = MBProgressHUDModeCustomView;
            [_hud show:YES];
            [_hud hide:YES afterDelay:2];
        }
            break;
            
        case NLHUDState_NoError:
        {
            _hud.labelText = detail;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.png"]];
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
            break;
    }
    return;
}

-(BOOL)checkMobile
{
    if ([_transferType isEqualToString:@"0"])
    {
        if (![NLUtils checkMobilePhone:_shoucardmobile])
        {
            [self showErrorInfo:@"输入正确的手机号码" status:NLHUDState_Error];
            return NO;
        }
        
        return YES;
    }
    else
    {
        if (![NLUtils checkMobilePhone:_supshoucardmobile])
        {
            [self showErrorInfo:@"输入正确的手机号码" status:NLHUDState_Error];
            return NO;
        }
        
        return YES;
    }
}

-(BOOL)checkBankCard
{
    if ([_transferType isEqualToString:@"0"])
    {
        if (![NLUtils checkBankCard:_shoucardno])
        {
            [self showErrorInfo:@"输入正确的银行卡号" status:NLHUDState_Error];
            return NO;
        }
        return YES;
    }
    else
    {
        if (![NLUtils checkBankCard:_supshoucardno])
        {
            [self showErrorInfo:@"输入正确的银行卡号" status:NLHUDState_Error];
            return NO;
        }
        return YES;
    }
}

//检查输入的卡号 是否一样
-(BOOL)checkReBankCard
{
    if ([_transferType isEqualToString:@"0"])
    {
        if (![_shoucardno isEqualToString:_reshoucardno])
        {
            [self showErrorInfo:@"两次输入卡号不一致" status:NLHUDState_Error];
            return NO;
        }
        
        return YES;
    }
    else
    {
        if (![_supshoucardno isEqualToString:_supreshoucardno])
        {
            [self showErrorInfo:@"两次输入卡号不一致" status:NLHUDState_Error];
            return NO;
        }
        
        return YES;
    }
}

-(BOOL)checkGetTransferPayfeeInfo
{
    if ([_transferType isEqualToString:@"0"])
    {
        if (!_hasRead)
        {
            [self showErrorInfo:@"请同意转账服务协议" status:NLHUDState_Error];
            return NO;
        }
        if (_shoucardbank.length <= 0)
        {
            [self showErrorInfo:@"请选择银行" status:NLHUDState_Error];
            return NO;
        }
        if (![self checkBankCard])
        {
            return NO;
        }
        
        if (![self checkReBankCard])
        {
            return NO;
        }
        
        if (![NLUtils checkName:_shoucardman])
        {
            [self showErrorInfo:@"输入正确姓名" status:NLHUDState_Error];
            return NO;
        }
        
        if (_paymoney.length <= 0)
        {
            [self showErrorInfo:@"输入转账金额" status:NLHUDState_Error];
            return NO;
        }
        else if ([_paymoney floatValue] <= 0)
        {
            [self showErrorInfo:@"转账金额必须大于0元" status:NLHUDState_Error];
            return NO;
        }
        
        if (_payfee.length <= 0)
        {
            [self showErrorInfo:@"请点击获取手续费" status:NLHUDState_Error];
            return NO;
        }
        if (![_money isEqualToString:[NSString stringWithFormat:@"%.2f",(float)([_payfee floatValue]+[_paymoney floatValue])]])
        {
            [self showErrorInfo:@"转账金额已经修改，请重新获取手续费" status:NLHUDState_Error];
            return NO;
        }
        if (_shoucardmemo.length >20)
        {
            [self showErrorInfo:@"备注信息过长，请输入少于20位的备注" status:NLHUDState_Error];
            return NO;
        }
        if (_freeNotify && ![self checkMobile])
        {
            return NO;
        }
        return YES;
    }
    else
    {
        if (!_suphasRead)
        {
            [self showErrorInfo:@"请同意转账服务协议" status:NLHUDState_Error];
            
            return NO;
        }
        
        if (_supshoucardbank.length <= 0)
        {
            [self showErrorInfo:@"请选择银行" status:NLHUDState_Error];
            return NO;
        }
        
        if (![self checkBankCard])
        {
            return NO;
        }
        
        if (![self checkReBankCard])
        {
            return NO;
        }
        
        if (![NLUtils checkName:_supshoucardman])
        {
            [self showErrorInfo:@"输入正确姓名" status:NLHUDState_Error];
            return NO;
        }
        
        if (_suppaymoney.length <= 0)
        {
            [self showErrorInfo:@"输入转账金额" status:NLHUDState_Error];
            return NO;
        }
        else if ([_suppaymoney floatValue] <= 0)
        {
            [self showErrorInfo:@"转账金额必须大于0元" status:NLHUDState_Error];
            return NO;
        }
        
        if (_suppayfee.length <= 0)
        {
            [self showErrorInfo:@"请点击获取手续费" status:NLHUDState_Error];
            return NO;
        }
        
        if (![_supmoney isEqualToString:[NSString stringWithFormat:@"%.2f",(float)([_suppayfee floatValue]+[_suppaymoney floatValue])]])
        {
            [self showErrorInfo:@"转账金额已经修改，请重新获取手续费" status:NLHUDState_Error];
            return NO;
        }
        
        if (_supshoucardmemo.length > 20)
        {
            [self showErrorInfo:@"备注信息过长，请输入少于20位的备注" status:NLHUDState_Error];
            return NO;
        }
        
        if (_supfreeNotify && ![self checkMobile])
        {
            return NO;
        }
        
        return YES;
    }
}

#pragma mark - buttons clicked event
//判断选择的转账类型
-(IBAction)onLeftBtn:(id)sender
{
    _transferType = @"1";
    [self.myTopImageView setImage:[UIImage imageNamed:@"TransferRemittanceTopLeft@2x.png"]];
    [self.myTableView reloadData];
}

-(IBAction)onRightBtn:(id)sender
{
    _transferType = @"0";
    [self.myTopImageView setImage:[UIImage imageNamed:@"TransferRemittanceTopRight@2x.png"]];
    [self.myTableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section)
    {
        return 7;
    }
    else if (1 == section)
    {
        if ([_transferType isEqualToString:@"0"])
        {
            //return 2;
            return self.myArriveTimeArray.count;
        }
        else
        {
            return [self.mySupArriveTimeArray count];
        }
    }
    else
    {
        if ([_transferType isEqualToString:@"0"])
        {
            if (_freeNotify)
            {
                return 3;
            }
            else
            {
                return 2;
            }
        }
        else
        {
            if (_supfreeNotify)
            {
                return 3;
            }
            else
            {
                return 2;
            }
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_transferType isEqualToString:@"1"] && indexPath.section == 1)
    {
        NLSpeUserInforSettingsCell *cell =nil;
        static NSString *kCellID = @"NLSpeUsersInforSettingsCell";
        cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
        
        if (cell == nil)
        {
            NSArray* temp = [[NSBundle mainBundle] loadNibNamed:kCellID owner:self options:nil];
            cell = [temp objectAtIndex:0];
        }
        
        cell.myHeaderLabel.hidden = NO;
        cell.myDownrightBtn.hidden = YES;
        cell.myUprightBtn.hidden = YES;
        cell.myContentLabel.hidden = YES;
        cell.myContainer = self;
        [cell.myTextField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
        
        cell.myTextField.hidden = YES;
        [cell.myHeaderLabel setFrame:CGRectMake(cell.myHeaderLabel.frame.origin.x, cell.myHeaderLabel.frame.origin.y, 200, cell.myHeaderLabel.frame.size.height)];
        cell.myHeaderLabel.text = [[self.mySupArriveTimeArray objectAtIndex:indexPath.row] objectForKey:@"arrivetime"];
        cell.mySelectedBtn.hidden = NO;
        cell.mySelectedBtn.tag = indexPath.row;
        
        NSString* activearriveid = [[self.mySupArriveTimeArray objectAtIndex:indexPath.row] objectForKey:@"activearriveid"];
        
        cell.mySpeContentLabel.text = [NSString stringWithFormat:@"%@", [[self.mySupArriveTimeArray objectAtIndex:indexPath.row] objectForKey:@"activememo"]];
        
        BOOL selected = activearriveid.length > 0? YES : NO;
        
        if (selected)
        {
            [cell.mySelectedBtn setBackgroundImage:[UIImage imageNamed:@"singleSelected.png"]
                                          forState:UIControlStateNormal];
        }
        else
        {
            [cell.mySelectedBtn setBackgroundImage:[UIImage imageNamed:@"singleUnselected.png"]
                                          forState:UIControlStateNormal];
        }
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        return cell;
    }
    
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
    cell.myContainer = self;
    [cell.myTextField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
    
    switch (indexPath.section)
    {
        case 0:
        {
            switch (indexPath.row)
            {
                case TableViewHistoricalAccountRowType:
                {
                    cell.myTextField.hidden = YES;
                    cell.mySelectedBtn.hidden = YES;
                    cell.myHeaderLabel.text = @"选择历史账户";
                    cell.myContentLabel.hidden = NO;
                    cell.myContentLabel.textAlignment = NSTextAlignmentLeft;
                    cell.myContentLabel.text = @"";
                    cell.userInteractionEnabled = YES;
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                    break;
                case TableViewCardBankRowType:
                {
                    /*刷卡后不允许点击银行卡列表*/
                    
                    cell.myTextField.hidden = YES;
                    cell.mySelectedBtn.hidden = YES;
                    cell.myHeaderLabel.text = @"选择银行";
                    cell.myContentLabel.hidden = NO;
                    cell.myContentLabel.textAlignment = NSTextAlignmentLeft;
                    
                    if ([_transferType isEqualToString:@"0"])
                    {
                        if (_shoucardbank.length <= 0)
                        {
                            cell.myContentLabel.text = @"请选择银行";
                        }
                        else
                        {
                            cell.myContentLabel.text = _shoucardbank;
                        }
                    }
                    else
                    {
                        if (_supshoucardbank.length <= 0)
                        {
                            cell.myContentLabel.text = @"请选择银行";
                        }
                        else
                        {
                            cell.myContentLabel.text = _supshoucardbank;
                        }
                    }
                    cell.userInteractionEnabled = YES;
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                    break;
                case TableViewCardNunberRowType:
                {
                    cell.myContentLabel.hidden = YES;
                    cell.myHeaderLabel.text = @"收款卡号";
                    cell.myTextField.hidden = NO;
                    cell.myTextField.tag = 0;
                    cell.myTextField.delegate = self;
                    cell.myTextField.keyboardType = UIKeyboardTypeNumberPad;
                    cell.myTextField.returnKeyType = UIReturnKeyDone;
                    [cell.myTextField setFrame:CGRectMake(cell.myTextField.frame.origin.x, cell.myTextField.frame.origin.y, 155, cell.myTextField.frame.size.height)];
                    
                    if ([_transferType isEqualToString:@"0"])
                    {
                        if ([_shoucardno length] <= 0)
                        {
                            cell.myTextField.placeholder = @"刷卡或手动输入卡号";
                        }
                        else
                        {
                            cell.myTextField.text = _shoucardno;
                        }
                    }
                    else
                    {
                        if ([_supshoucardno length] <= 0)
                        {
                            cell.myTextField.placeholder = @"刷卡或手动输入卡号";
                        }
                        else
                        {
                            cell.myTextField.text = _supshoucardno;
                        }
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
                case TableViewReCardNumberRowType:
                {
                    cell.myContentLabel.hidden = YES;
                    cell.myHeaderLabel.text = @"确认卡号";
                    cell.myTextField.hidden = NO;
                    cell.myTextField.tag = 1;
                    cell.myTextField.delegate = self;
                    cell.myTextField.keyboardType = UIKeyboardTypeNumberPad;
                    cell.myTextField.returnKeyType = UIReturnKeyDone;
                    [cell.myTextField setFrame:CGRectMake(cell.myTextField.frame.origin.x, cell.myTextField.frame.origin.y, 155, cell.myTextField.frame.size.height)];
                    
                    if ([_transferType isEqualToString:@"0"])
                    {
                        if ([_reshoucardno length] <= 0)
                        {
                            cell.myTextField.placeholder = @"刷卡或手动输入卡号";
                        }
                        else
                        {
                            cell.myTextField.text = _reshoucardno;
                        }
                    }
                    else
                    {
                        if ([_supreshoucardno length] <= 0)
                        {
                            cell.myTextField.placeholder = @"刷卡或手动输入卡号";
                        }
                        else
                        {
                            cell.myTextField.text = _supreshoucardno;
                            
                        }
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
                case TableViewCardNameRowType:
                {
                    cell.myTextField.hidden = NO;
                    cell.mySelectedBtn.hidden = YES;
                    [cell.myHeaderLabel setFrame:CGRectMake(cell.myHeaderLabel.frame.origin.x, cell.myHeaderLabel.frame.origin.y, cell.myHeaderLabel.frame.size.width+20, cell.myHeaderLabel.frame.size.height)];
                    cell.myHeaderLabel.text = @"收款人姓名";
                    cell.myContentLabel.hidden = YES;
                    cell.myTextField.tag = 2;
                    
                    if ([_transferType isEqualToString:@"0"])
                    {
                        if (_shoucardman.length <= 0)
                        {
                            cell.myTextField.placeholder = @"请输入收款人姓名";
                        }
                        else
                        {
                            cell.myTextField.text = _shoucardman;
                        }
                    }
                    else
                    {
                        if (_supshoucardman.length <= 0)
                        {
                            cell.myTextField.placeholder = @"请输入收款人姓名";
                        }
                        else
                        {
                            cell.myTextField.text = _supshoucardman;
                        }
                    }
                    
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                    break;
                case TableViewPayMoneyRowType:
                {
                    cell.myTextField.hidden = NO;
                    cell.mySelectedBtn.hidden = YES;
                    cell.myContentLabel.hidden = YES;
                    [cell.myHeaderLabel setFrame:CGRectMake(cell.myHeaderLabel.frame.origin.x, cell.myHeaderLabel.frame.origin.y, cell.myHeaderLabel.frame.size.width+20, cell.myHeaderLabel.frame.size.height)];
                    cell.myHeaderLabel.text = @"转账金额";
                    cell.myTextField.tag = 3;
                    cell.myTextField.delegate = self;
                    cell.myTextField.keyboardType = UIKeyboardTypeDecimalPad;
                    if ([_transferType isEqualToString:@"0"])
                    {
                        if (_paymoney.length <= 0)
                        {
                            cell.myTextField.placeholder = @"请输入转账金额";
                        }
                        else
                        {
                            cell.myTextField.text = _paymoney;
                        }
                    }
                    else
                    {
                        if (_suppaymoney.length <= 0)
                        {
                            cell.myTextField.placeholder = @"请输入转账金额";
                        }
                        else
                        {
                            cell.myTextField.text = _suppaymoney;
                        }
                    }
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                    break;
                case TableViewPayFeeRowType:
                {
                    cell.myTextField.hidden = YES;
                    cell.mySelectedBtn.hidden = YES;
                    cell.myHeaderLabel.text = @"手续费";
                    cell.myContentLabel.hidden = NO;
                    cell.myContentLabel.textAlignment = NSTextAlignmentLeft;
                    
                    if ([_transferType isEqualToString:@"0"])
                    {
                        if (_payfee.length <= 0)
                        {
                            cell.myContentLabel.text = @"点击获取手续费";
                        }
                        else
                        {
                            cell.myContentLabel.text = _payfee;
                        }
                    }
                    else
                    {
                        if (_suppayfee.length <= 0)
                        {
                            cell.myContentLabel.text = @"点击获取手续费";
                        }
                        else
                        {
                            cell.myContentLabel.text = _suppayfee;
                        }
                    }
                    
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            {
                cell.myTextField.hidden = YES;
                [cell.myHeaderLabel setFrame:CGRectMake(cell.myHeaderLabel.frame.origin.x, cell.myHeaderLabel.frame.origin.y, 200, cell.myHeaderLabel.frame.size.height)];
                cell.myHeaderLabel.text = [[self.myArriveTimeArray objectAtIndex:indexPath.row] objectForKey:@"arrivetime"];
                cell.mySelectedBtn.hidden = NO;
                cell.mySelectedBtn.tag = indexPath.row;
                BOOL selected = NO;
                NSString* activearriveid = [[self.myArriveTimeArray objectAtIndex:indexPath.row] objectForKey:@"activearriveid"];
                
                if (activearriveid.length > 0)
                {
                    selected = YES;
                }
                else
                {
                    selected = NO;
                }
                
                if (selected)
                {
                    [cell.mySelectedBtn setBackgroundImage:[UIImage imageNamed:@"singleSelected.png"]
                                                      forState:UIControlStateNormal];
                }
                else
                {
                    [cell.mySelectedBtn setBackgroundImage:[UIImage imageNamed:@"singleUnselected.png"]
                                                      forState:UIControlStateNormal];
                }
                
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
            break;
            
        case 2:
        {
            switch (indexPath.row)
            {
                case (TableViewCardMemoRowType - TableViewThirdSectionType -1):
                {
                    cell.myTextField.hidden = NO;
                    cell.mySelectedBtn.hidden = YES;
                    cell.myHeaderLabel.text = @"备注";
                    cell.myTextField.tag = 4;
                    if ([_transferType isEqualToString:@"0"])
                    {
                        if (_shoucardmemo.length <= 0)
                        {
                            cell.myTextField.placeholder = @"请输入备注信息";
                        }
                        else
                        {
                            cell.myTextField.text = _shoucardmemo;
                        }
                    }
                    else
                    {
                        if (_supshoucardmemo.length <= 0)
                        {
                            cell.myTextField.placeholder = @"请输入备注信息";
                        }
                        else
                        {
                            cell.myTextField.text = _supshoucardmemo;
                        }
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
                    break;
                case (TableViewNoteReceivablesRowType - TableViewThirdSectionType - 1):
                {
                    cell.myTextField.hidden = YES;
                    [cell.myHeaderLabel setFrame:CGRectMake(cell.myHeaderLabel.frame.origin.x, cell.myHeaderLabel.frame.origin.y, 200, cell.myHeaderLabel.frame.size.height)];
                    cell.myHeaderLabel.text = @"免费通知收款人";
                    cell.mySelectedBtn.hidden = NO;
                    cell.mySelectedBtn.tag = 100;
                    
                    if ([_transferType isEqualToString:@"0"])
                    {
                        if (_freeNotify)
                        {
                            [cell.mySelectedBtn setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
                        }
                        else
                        {
                            [cell.mySelectedBtn setBackgroundImage:[UIImage imageNamed:@"unSelected.png"] forState:UIControlStateNormal];
                        }
                    }
                    else
                    {
                        if (_supfreeNotify)
                        {
                            [cell.mySelectedBtn setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
                        }
                        else
                        {
                            [cell.mySelectedBtn setBackgroundImage:[UIImage imageNamed:@"unSelected.png"] forState:UIControlStateNormal];
                        }
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
                    break;
                case (TableViewCardMobileRowType - TableViewThirdSectionType - 1):
                    {
                        cell.myTextField.hidden = NO;
                        cell.mySelectedBtn.hidden = YES;
                        cell.myHeaderLabel.text = @"手机号码";
                        cell.myTextField.tag = 5;
                        cell.myTextField.keyboardType = UIKeyboardTypePhonePad;
                        
                        if ([_transferType isEqualToString:@"0"])
                        {
                            if (_shoucardmobile.length <= 0)
                            {
                                cell.myTextField.placeholder = @"请输入手机号码";
                            }
                            else
                            {
                                cell.myTextField.text = _shoucardmobile;
                            }
                        }
                        else
                        {
                            if (_supshoucardmobile.length <= 0)
                            {
                                cell.myTextField.placeholder = @"请输入手机号码";
                            }
                            else
                            {
                                cell.myTextField.text = _supshoucardmobile;
                            }
                        }
                        
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        cell.accessoryType = UITableViewCellAccessoryNone;
                    }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

-(void)resetPayfeeCell:(NSString *)str
{
    NLUserInforSettingsCell *cell = (NLUserInforSettingsCell *)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:TableViewPayFeeRowType inSection:0]];
    cell.myTextField.text = str;
}

-(BOOL)isGetTransferPayfee
{
    if ([_transferType isEqualToString:@"0"])
    {
        if (_paymoney.length <= 0)
        {
            [self resetPayfeeCell:@""];
            return NO;
        }
        
        if (_bankid.length > 0)
        {
            _editCash = NO;
            return YES;
        }
        
        [self showErrorInfo:@"请选择银行" status:NLHUDState_Error];
        return NO;
    }
    else
    {
        if (_suppaymoney.length <= 0)
        {
            [self resetPayfeeCell:@""];
            return NO;
        }
        
        if (_supbankid.length > 0)
        {
            _supeditCash = NO;
            return YES;
        }
        
        [self showErrorInfo:@"请选择银行" status:NLHUDState_Error];
        return NO;
    }
}

- (void)textFieldWithText:(UITextField *)textField
{
    if ([_transferType isEqualToString:@"0"])
    {
        switch (textField.tag)
        {
            case 0://收款人卡号
            {
                _shoucardno = textField.text;
            }
                break;
            case 1://确认卡号
            {
                _reshoucardno = textField.text;
            }
                break;
            case 2://收款人姓名
            {
                _shoucardman = textField.text;
            }
                break;
            case 3://转账金额
            {
                _editCash = YES;
                _paymoney = textField.text;
            }
                break;
            case 4://备注
            {
                _shoucardmemo = textField.text;
            }
                break;
            case 5://手机号码
            {
                _shoucardmobile = textField.text;
            }
                break;
            default:
                break;
        }
    }
    else
    {
        switch (textField.tag)
        {
            case 0://收款人卡号
            {
                _supshoucardno = textField.text;
            }
                break;
            case 1://确认卡号
            {
                _supreshoucardno = textField.text;
            }
                break;
            case 2://收款人姓名
            {
                _supshoucardman = textField.text;
            }
                break;
            case 3://转账金额
            {
                _supeditCash = YES;
                _suppaymoney = textField.text;
            }
                break;
            case 4://备注
            {
                _supshoucardmemo = textField.text;
            }
                break;
            case 5://手机号码
            {
                _supshoucardmobile = textField.text;
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0 == section || 2 == section? 30 : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1 == section? 30 : 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (0 == section)
    {
        CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, 30);
        
        UIView* view = [[UIView alloc] initWithFrame:rect];
        [view setBackgroundColor:[UIColor clearColor]];
        rect.origin.x = 10;
        rect.origin.y = 5;
        rect.size.width = 300;
        rect.size.height = 20;
        
        UILabel* label = [[UILabel alloc] initWithFrame:rect];
        label.adjustsFontSizeToFitWidth = NO;
        label.backgroundColor=[UIColor clearColor];
        label.font=[UIFont systemFontOfSize:13.0f];
        label.textColor = [UIColor blueColor];
        label.text = @"";
        [view addSubview:label];
        
        return view;
    }
    else if (2 == section)
    {
        CGRect rect = CGRectMake(10, 2, 25, 25);
        UIView* view = [[UIView alloc] initWithFrame:rect];
        [view setBackgroundColor:[UIColor clearColor]];
        
        self.myHasReadBtn = [[UIButton alloc] initWithFrame:rect];
        self.myHasReadBtn.selected = YES;
        [self.myHasReadBtn setBackgroundImage:[UIImage imageNamed:@"unSelected.png"] forState:UIControlStateNormal];
        [self.myHasReadBtn setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateSelected];
        [self.myHasReadBtn addTarget:self action:@selector(onHasReadBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:self.myHasReadBtn];
        
        rect.origin.x = 40;
        rect.size.width = 270;
        
        //同意条款的按钮
        self.myShowProtocolBtn = [[UIButton alloc] initWithFrame:rect];
        [self.myShowProtocolBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.myShowProtocolBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [self.myShowProtocolBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
        [self.myShowProtocolBtn setTitle:@"已阅读并同意<<通付宝转账汇款服务协议>>" forState:UIControlStateNormal];
        [self.myShowProtocolBtn addTarget:self action:@selector(onShowProtocolBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:self.myShowProtocolBtn];
        
        return view;
    }
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (1 == section)
    {
        CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, 30);
        
        UIView* view = [[UIView alloc] initWithFrame:rect];
        [view setBackgroundColor:[UIColor clearColor]];
        rect.origin.x = 10;
        rect.origin.y = 5;
        rect.size.width = 300;
        rect.size.height = 20;
        
        UILabel* label = [[UILabel alloc] initWithFrame:rect];
        label.adjustsFontSizeToFitWidth = NO;
        label.backgroundColor=[UIColor clearColor];
        label.font=[UIFont systemFontOfSize:13.0f];
        label.textColor = [UIColor blackColor];
        label.text = @"到账日期";
        [view addSubview:label];
        
        return view;
    }
    else
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [_transferType isEqualToString:@"1"] && indexPath.section == 1? 60.0f :44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    
    if (0 == section)
    {
        int row = indexPath.row;
        
        if (TableViewHistoricalAccountRowType == row)
        {
            /*转账类型*/
            NLHistoricalAccountViewController *con = [[NLHistoricalAccountViewController alloc]initWithNibName:@"NLHistoricalAccountViewController" bundle:nil];
            con.myHistoryPayType = [_transferType isEqualToString:@"0"]? NLHistoryPayType_Tfmg : NLHistoryPayType_Suptfmg;
            con.tfmgDelegate = self;
            [self.navigationController pushViewController:con animated:YES];
        }
        else if (TableViewCardBankRowType == row)
        {
            /*刷卡后不能改变银行状态*/
            if (flagSK==NO)
            {
                [[[NLToast alloc] init] show:@"您当前已刷卡获取过银行信息"
                                     gravity:NLToastGravityBottom
                                    duration:NLToastDurationNormal];
            }
            else
            {
                /*银行列表*/
                NLBankListViewController *vc = [[NLBankListViewController alloc] initWithNibName:@"NLBankListViewController" bundle:nil];
                vc.delegate = self;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        else if (TableViewPayFeeRowType == row)
        {
            /*手续费*/
            if ([self isGetTransferPayfee])
            {
                if ([_transferType isEqualToString:@"0"])
                {
                    [self getTransferPayfee];
                }
                else
                {
                    [self getSupTransferPayfee];
                }
            }
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*下一步*/
- (IBAction)onNextBtnClicked:(id)sender
{
    if ([self checkGetTransferPayfeeInfo])//信息填写完成
    {
        /*普通转账类型*/
        if ([_transferType isEqualToString:@"0"])
        {
            /*核对信息页面*/
            NLTransferSecondViewController *vc = [[NLTransferSecondViewController alloc] initWithNibName:@"NLTransferSecondViewController" bundle:nil];
            NSString* sendsms = [NSString stringWithFormat:@"%d", _freeNotify];
            
            vc.myDictionary = [NSDictionary dictionaryWithObjectsAndKeys:_shoucardmemo, @"shoucardmemo", _arriveidStr, @"arriveidStr", _arriveid, @"arriveid", _shoucardman, @"shoucardman", _shoucardmobile, @"shoucardmobile", _money, @"money", _payfee, @"payfee", _paymoney, @"paymoney", _shoucardbank, @"shoucardbank", _shoucardno, @"shoucardno", sendsms, @"sendsms", _transferType, @"transferType",_paycardid,@"cardReaderId",_bankid,@"receiveBankCardId",nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            NLTransferSecondViewController *vc = [[NLTransferSecondViewController alloc] initWithNibName:@"NLTransferSecondViewController" bundle:nil];
            NSString* sendsms = [NSString stringWithFormat:@"%d", _supfreeNotify];
            
            /*
             _supshoucardmemo : 备注
             _suparriveidStr : 转账类型(工作日 T + 0)
             _suparriveid : 到账日期
             _supshoucardman : 收款人姓名
             _supshoucardmobile : 手机号码
             _supmoney : 总金额
             _suppayfee : 手续费
             _suppaymoney : 支付金额
             _supshoucardbank : 所属银行名
             _supshoucardno : 卡号
             _supfreeNotify : 通知收款人
             sendsms : 通知收款人
             _transferType : 转账性质
             _paycardid : 刷卡器ID
             _supbankid : 银行卡ID
             */
            
            vc.myDictionary = [NSDictionary dictionaryWithObjectsAndKeys:_supshoucardmemo, @"shoucardmemo", _suparriveidStr, @"arriveidStr", _suparriveid, @"arriveid", _supshoucardman, @"shoucardman", _supshoucardmobile, @"shoucardmobile", _supmoney, @"money", _suppayfee, @"payfee", _suppaymoney, @"paymoney", _supshoucardbank, @"shoucardbank", _supshoucardno, @"shoucardno", sendsms, @"sendsms", _transferType, @"transferType",_paycardid,@"cardReaderId",_supbankid,@"receiveBankCardId", nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - keyboard hide event
-(void)oneFingerTwoTaps
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UITextField *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    [firstResponder resignFirstResponder];
}

-(void)doSelectedBtnClicked:(id)sender
{
    NLUserInforSettingsCell* cell = (NLUserInforSettingsCell *)sender;
    
    if ([_transferType isEqualToString:@"0"])
    {
        if (100 == cell.mySelectedBtn.tag)
        {
            _freeNotify = !_freeNotify;
            
            if (!_freeNotify)
            {
                _shoucardmobile = @"";
            }
            
            [self.myTableView reloadSections:[NSIndexSet indexSetWithIndex:2]
                            withRowAnimation:UITableViewRowAnimationFade];
        }
        else
        {
            NLUserInforSettingsCell* cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_arriveType inSection:1]];
            [cell.mySelectedBtn setBackgroundImage:[UIImage imageNamed:@"singleUnselected.png"]
                                          forState:UIControlStateNormal];
            _arriveType = cell.mySelectedBtn.tag;
            cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_arriveType inSection:1]];
            [cell.mySelectedBtn setBackgroundImage:[UIImage imageNamed:@"singleSelected.png"]
                                          forState:UIControlStateNormal];
            _arriveid = [[self.myArriveTimeArray objectAtIndex:_arriveType] objectForKey:@"arriveid"];
            _arriveTimeIndex = [_arriveid intValue];
            _arriveidStr = [[self.myArriveTimeArray objectAtIndex:_arriveType] objectForKey:@"arrivetime"];
            
            if ([self isGetTransferPayfee])
            {
                [self getTransferPayfee];
            }
        }
    }
    else
    {
        if (100 == cell.mySelectedBtn.tag)
        {
            _supfreeNotify = !_supfreeNotify;
            
            if (!_supfreeNotify)
            {
                _supshoucardmobile = @"";
            }
            
            [self.myTableView reloadSections:[NSIndexSet indexSetWithIndex:2]
                            withRowAnimation:UITableViewRowAnimationFade];
        }
        else
        {
            NLUserInforSettingsCell* cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_suparriveType inSection:1]];
            [cell.mySelectedBtn setBackgroundImage:[UIImage imageNamed:@"singleUnselected.png"]
                                          forState:UIControlStateNormal];
            _suparriveType = cell.mySelectedBtn.tag;
            cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_suparriveType inSection:1]];
            [cell.mySelectedBtn setBackgroundImage:[UIImage imageNamed:@"singleSelected.png"]
                                          forState:UIControlStateNormal];
            _suparriveid = [[self.mySupArriveTimeArray objectAtIndex:_suparriveType] objectForKey:@"arriveid"];
            _suparriveTimeIndex = [_suparriveid intValue];
            _suparriveidStr = [[self.mySupArriveTimeArray objectAtIndex:_suparriveType] objectForKey:@"arrivetime"];
            
            if ([self isGetTransferPayfee])
            {
                [self getSupTransferPayfee];
            }
        }
    }
}

#pragma mark - DataSearchDelegate
- (void)dataSearch:(NLBankListViewController *)controller didSelectWithObject:(id)aObject
         withState:(NSString *)state
{
    if ([_transferType isEqualToString:@"0"])
    {
        _editCash = YES;
        _shoucardbank = (NSString *)aObject;
        _bankid = [NSString stringWithFormat:@"%@",state];
        
        NLUserInforSettingsCell *cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:TableViewCardBankRowType inSection:0]];
        
        if (cell)
        {
            cell.myContentLabel.text = _shoucardbank;
        }
        if ([self isGetTransferPayfee])
        {
            [self getTransferPayfee];
        }
    }
    else
    {
        _supeditCash = YES;
        _supshoucardbank = (NSString*)aObject;
        _supbankid = [NSString stringWithFormat:@"%@",state];
        
        NLUserInforSettingsCell *cell = (NLUserInforSettingsCell *)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:TableViewCardBankRowType inSection:0]];
        
        if (cell)
        {
            cell.myContentLabel.text = _supshoucardbank;
        }
        if ([self isGetTransferPayfee])
        {
            [self getSupTransferPayfee];
        }
    }
}

- (void)dataSearchDidCanceled:(NLBankListViewController *)controller withState:(int)state
{
    //[controller dismissViewControllerAnimated:YES completion:NULL];
}

- (void)onShowProtocolBtnClicked:(id)sender
{
    NSString* name = [NLUtils getNameForRequest:Notify_readAppruleList];
    REGISTER_NOTIFY_OBSERVER(self, readAppruleListNotify, name);
    NSString* str = [NSString stringWithFormat:@"%d",5];
    [[[NLProtocolRequest alloc] initWithRegister:YES] readAppruleList:str];
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
}

- (void)onHasReadBtnClicked:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    if ([_transferType isEqualToString:@"0"])
    {
        _hasRead = !_hasRead;
    }
    else
    {
        _suphasRead = !_suphasRead;
    }
}

-(void)showTextView
{
    NLShowTextViewController* vc = [[NLShowTextViewController alloc] initWithNibName:@"NLShowTextViewController" bundle:nil];
    vc.myType = 5;
    [NLUtils presentModalViewController:self newViewController:vc];
}

#pragma mark - http request
-(void)readAppruleListNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    if (error == RSP_NO_ERROR)
    {
        [_hud hide:YES];
        [self showTextView];
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
            detail = @"服务器繁忙，请稍候再试";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

-(NSString*)getNoNilStr:(NSString*)str
{
    if (str == nil)
    {
        return @"";
    }
    
    return str;
}

-(void)doGetTransferPayfeeNotify:(NLProtocolResponse*)response
{
    NLProtocolData* data = [response.data find:@"msgbody/payfee" index:0];
    _payfee = data.value;
    _money = [NSString stringWithFormat:@"%.2f",(float)([_payfee floatValue]+[_paymoney floatValue])];
    data = [response.data find:@"msgbody/arrivetime" index:0];
    NLUserInforSettingsCell* cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:TableViewPayFeeRowType inSection:0]];
    cell.myContentLabel.text = _payfee;
    
    NSArray* arriveid = [response.data find:@"msgbody/msgchild/arriveid"];
    NSString* arriveidStr = nil;
    NSArray* arrivetime = [response.data find:@"msgbody/msgchild/arrivetime"];
    NSString* arrivetimeStr = nil;
    NSArray* activearriveid = [response.data find:@"msgbody/msgchild/activearriveid"];
    NSString* activearriveidStr = nil;
    
//    data = [activearriveid objectAtIndex:0];
//    _arriveid = data.value;
//    _arriveTimeIndex = [_arriveid intValue];
    
    [self.myArriveTimeArray removeAllObjects];
    
    for (int i=0; i < arriveid.count; i++)
    {
        data = [arriveid objectAtIndex:i];
        arriveidStr = [self getNoNilStr:data.value];
        data = [arrivetime objectAtIndex:i];
        arrivetimeStr = [self getNoNilStr:data.value];
        data = [activearriveid objectAtIndex:i];
        activearriveidStr = [self getNoNilStr:data.value];
        if (activearriveidStr.length > 0)
        {
            _arriveid = arriveidStr;
            _arriveidStr = arrivetimeStr;
        }
        
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:arriveidStr,@"arriveid",arrivetimeStr,@"arrivetime",activearriveidStr,@"activearriveid", nil];
        [self.myArriveTimeArray addObject:dic];
    }

    if ([self.myArriveTimeArray count] > 0)
    {
        [self.myTableView reloadSections:[NSIndexSet indexSetWithIndex:1]
                        withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)getTransferPayfeeNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        [self doGetTransferPayfeeNotify:response];
    }
    else
    {
        NSString* detail = response.detail;
        
        if (!detail || detail.length <= 0)
        {
            detail = @"服务器繁忙，请稍候再试";
        }
        
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

-(void)getTransferPayfee
{
    [self showErrorInfo:@"正在获取手续费" status:NLHUDState_None];
    NSString* name = [NLUtils getNameForRequest:Notify_getTransferPayfee];
    REGISTER_NOTIFY_OBSERVER(self, getTransferPayfeeNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] getTransferPayfee:_bankid
                                                                  money:_paymoney
                                                               arriveid:_arriveid];
}

-(void)doGetSupTransferPayfeeNotify:(NLProtocolResponse*)response
{
    NLProtocolData* data = [response.data find:@"msgbody/payfee" index:0];
    _suppayfee = data.value;
    _supmoney = [NSString stringWithFormat:@"%.2f",(float)([_suppayfee floatValue]+[_suppaymoney floatValue])];
    data = [response.data find:@"msgbody/arrivetime" index:0];
    NLUserInforSettingsCell* cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:TableViewPayFeeRowType inSection:0]];
    cell.myContentLabel.text = _suppayfee;
    
    NSArray* arriveid = [response.data find:@"msgbody/msgchild/arriveid"];
    NSString* arriveidStr = nil;
    NSArray* arrivetime = [response.data find:@"msgbody/msgchild/arrivetime"];
    NSString* arrivetimeStr = nil;
    NSArray* activearriveid = [response.data find:@"msgbody/msgchild/activearriveid"];
    NSString* activearriveidStr = nil;
    NSArray* activememo = [response.data find:@"msgbody/msgchild/activememo"];
    NSString* activememoStr = nil;
    
    [self.mySupArriveTimeArray removeAllObjects];
    
    for (int i=0; i<arriveid.count; i++)
    {
        data = [arriveid objectAtIndex:i];
        arriveidStr = [self getNoNilStr:data.value];
        data = [arrivetime objectAtIndex:i];
        arrivetimeStr = [self getNoNilStr:data.value];
        data = [activearriveid objectAtIndex:i];
        activearriveidStr = [self getNoNilStr:data.value];
        data = [activememo objectAtIndex:i];
        activememoStr = [self getNoNilStr:data.value];
        if (activearriveidStr.length > 0)
        {
            _suparriveid = arriveidStr;
            _suparriveidStr = arrivetimeStr;
        }
        
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:arriveidStr, @"arriveid", arrivetimeStr, @"arrivetime", activearriveidStr, @"activearriveid", activememoStr, @"activememo", nil];
        [self.mySupArriveTimeArray addObject:dic];
    }
    
    if ([self.mySupArriveTimeArray count] > 0)
    {
        [self.myTableView reloadSections:[NSIndexSet indexSetWithIndex:1]
                        withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)getSupTransferPayfeeNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        [self doGetSupTransferPayfeeNotify:response];
    }
    else
    {
        NSString* detail = response.detail;
        
        if (!detail || detail.length <= 0)
        {
            detail = @"服务器繁忙，请稍候再试";
        }
        
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

-(void)getSupTransferPayfee
{
    [self showErrorInfo:@"正在获取手续费" status:NLHUDState_None];
    NSString* name = [NLUtils getNameForRequest:Notify_getSupTransferPayfee];
    REGISTER_NOTIFY_OBSERVER(self, getSupTransferPayfeeNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] getSupTransferPayfee:_supbankid
                                                                     money:_suppaymoney
                                                                  arriveid:_suparriveid];
}

#pragma mark - oPayCardCheck
//验证刷卡器卡号的长度
-(BOOL)checkTransferInfo
{
    if (_supshoucardno.length<=0)
    {
        [self showErrorInfo:@"请刷卡或手动输入卡号" status:NLHUDState_Error];
        return NO;
    }
    
    NSString* mach = @"^[0-9]{14,20}$";
    
    if (![NLUtils matchRegularExpressionPsy:_supshoucardno match:mach]) {
        [self showErrorInfo:@"请确定您输入的银行卡是正确的" status:NLHUDState_Error];
        return NO;
    }
    
    return YES;
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


-(void)resetCardImage:(BOOL)enable
{
    if (enable == YES)
    {
        _enableCardImage = YES;
        NLUserInforSettingsCell* cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        NLUserInforSettingsCell* cell2 = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        cell.myUprightImage.image = [UIImage imageNamed:@"swipingCard2.png"];
        cell2.myUprightImage.image = [UIImage imageNamed:@"swipingCard2.png"];
    }
    else
    {
        _enableCardImage = NO;
        NLUserInforSettingsCell* cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        NLUserInforSettingsCell* cell2 = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        
        cell.myUprightImage.image = [UIImage imageNamed:@"swipingCard.png"];
        cell2.myUprightImage.image = [UIImage imageNamed:@"swipingCard.png"];
    }
}

-(void)resetCardNumber:(NSString*)str
{
    if (str.length > 0)
    {
        NLUserInforSettingsCell* cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        NLUserInforSettingsCell* cell2 = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        cell.myTextField.text = str;
        cell2.myTextField.text = str;
    }
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
            _shoucardno = [_visaReaderArray objectAtIndex:0];
            _reshoucardno= [_visaReaderArray objectAtIndex:0];
            _supshoucardno= [_visaReaderArray objectAtIndex:0];
            _supreshoucardno= [_visaReaderArray objectAtIndex:0];
            _paycardid = [_visaReaderArray objectAtIndex:1];
            
            if (_paycardid.length >= 14)
            {
                _paycardid = [_paycardid substringToIndex:14];
                _paycardid = [_paycardid lowercaseString];
            }
            
            _payCardCheck = _paycardid;
            
            if ([_transferType isEqualToString:@"0"])
            {
                [self resetCardNumber:_shoucardno];
                [self resetCardNumber:_reshoucardno];
            }
            else
            {
                [self resetCardNumber:_supshoucardno];
                [self resetCardNumber:_supreshoucardno];
            }
            
//            [self payCardCheck];
            /*刷卡获取数据*/
             [self ApipayCardCheck];
        }
    }
}

/*刷卡验证*/
-(void)ApipayCardCheck
{
    /*刷卡器唯一码*/
    NSString *paycardkey_check= _payCardCheck;
    /*银行卡号*/
    NSString *bkcardno_check= _shoucardno;
    /*交易类型*/
    NSString *paytype_check= [[[NSUserDefaults standardUserDefaults]objectForKey:BANK_PAYTYPE_CHECK] objectAtIndex:0];
    
    NSString* name = [NLUtils getNameForRequest:Notify_ApipayCardCheck];
    REGISTER_NOTIFY_OBSERVER(self, ApipayCardCheckNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApipayCardCheck:paycardkey_check bkcardno:bkcardno_check paytype:paytype_check readmode:@"s"];
}

/*信用卡刷卡信息对比*/
-(void)ApipayCardCheckNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    if (error == RSP_NO_ERROR)
    {
        [_hud hide:YES];
        [self doApiPayCardCheckNotify:response];
    }
    else if (error == RSP_TIMEOUT)
    {
        [self showErrorInfo:@"获取数据为空，请重试" status:NLHUDState_Error];
        [self performSelector:@selector(doPush) withObject:nil afterDelay:2.0f];
        return;
    }
    else
    {
        NSString *detailA = response.detail;
        if (!detailA || detailA.length <= 0)
        {
            detailA = @"服务器繁忙，请稍候再试";
        }
        [self showErrorInfo:detailA status:NLHUDState_Error];
    }
}
/*信用卡信息对比*/
-(void)doApiPayCardCheckNotify:(NLProtocolResponse*)response
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
        //银行卡号
        NLProtocolData* bkcardnoCheck = [response.data find:@"msgbody/bkcardno" index:0];
        bkcardnoCheckStr = bkcardnoCheck.value;
        //执卡人
        NLProtocolData* bkcardmanCheck = [response.data find:@"msgbody/bkcardman" index:0];
        bkcardmanCheckStr = bkcardmanCheck.value;
        //预留手机号码
        NLProtocolData* bkcardphoneCheck = [response.data find:@"msgbody/bkcardphone" index:0];
        bkcardphoneStr= bkcardphoneCheck.value;
        //银行id
        NLProtocolData* bkcardbankidCheck = [response.data find:@"msgbody/bkcardbankid" index:0];
        bkcardbankidCheckStr= bkcardbankidCheck.value;
        //银行名
        NLProtocolData* bkcardbanknameCheck = [response.data find:@"msgbody/bkcardbankname" index:0];
        bkcardbanknameStr= bkcardbanknameCheck.value;
        //有效月
        NLProtocolData* bkcardyxmonthCheck = [response.data find:@"msgbody/bkcardyxmonth" index:0];
        bkcardyxmonthStr= bkcardyxmonthCheck.value;
        //有效年
        NLProtocolData* bkcardyxyearCheck = [response.data find:@"msgbody/bkcardyxyear" index:0];
        bkcardyxyearStr= bkcardyxyearCheck.value;
        //CVV校验
        NLProtocolData* bkcardcvvCheck = [response.data find:@"msgbody/bkcardcvv" index:0];
        bkcardcvvStr= bkcardcvvCheck.value;
        //身份证
        NLProtocolData* bkcardidcardCheck = [response.data find:@"msgbody/bkcardidcard" index:0];
        bkcardidcardStr= bkcardidcardCheck.value;
        //银行卡类型
        NLProtocolData* bkcardtypeCheck = [response.data find:@"msgbody/bkcardtype" index:0];
        bkcardtypeStr= bkcardtypeCheck.value;
        
        if (bkcardbanknameStr.length > 10)
        {
            flagSK= NO;
        }
        else
        {
            flagSK= YES;
        }
        
        /*填充信息*/
        if ([_transferType isEqualToString:@"0"])
        {
            _shoucardbank = bkcardbanknameStr;
            _bankid = bkcardbankidCheckStr;
        }
        else
        {
            _supshoucardbank = bkcardbanknameStr;
            _supbankid = bkcardbankidCheckStr;
        }
        [self.myTableView reloadData];
    }
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

-(void)payCardCheck
{
    NSString* name = [NLUtils getNameForRequest:Notify_payCardCheck];
    REGISTER_NOTIFY_OBSERVER(self, payCardCheckNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] payCardCheck:_payCardCheck];
    
    [self showErrorInfo:@"正在验证刷卡器" status:NLHUDState_None];
}


- (void) doPush
{
    [_hud hide:YES];
    [NLUtils popToLogonVCByHTTPError:self feedOrLeft:1];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL input = YES;
    
    int result = [NLUtils doTextFieldDelegate:textField
                shouldChangeCharactersInRange:range
                            replacementString:string];
    
    switch (result)
    {
        case 0:
        {
            input = YES;
        }
            break;
        case 1:
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
      
        case 4:
        {
            input = NO;
            [self showErrorInfo:@"金额最高2万元，请重新输入" status:NLHUDState_Error];
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

-(void)updateValue:(NSString*)shoucardno shoucardbank:(NSString*)shoucardbank shoucardman:(NSString*)shoucardman shoucardmobile:(NSString*)shoucardmobile bankid:(NSString*)bankid
{
    if ([_transferType isEqualToString:@"0"])
    {
        _shoucardbank = shoucardbank;
        _shoucardno = shoucardno;
        _reshoucardno = shoucardno;
        _shoucardmobile = shoucardmobile;
        _shoucardman = shoucardman;
        _bankid = bankid;
    }
    else
    {
        _supshoucardbank = shoucardbank;
        _supshoucardno = shoucardno;
        _supreshoucardno = shoucardno;
        _supshoucardmobile = shoucardmobile;
        _supshoucardman = shoucardman;
        _supbankid = bankid;
    }
    
    [self.myTableView reloadData];
}

- (void)viewDidUnload
{
    [self setMyTopImageView:nil];
    [super viewDidUnload];
}

@end











