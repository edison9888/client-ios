//
//  PAYSKQMore.m
//  TongFubao
//
//  Created by  俊   on 14-5-13.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "PAYSKQMore.h"
#import "UPPayPlugin.h"
#import "NLProgressHUD.h"
#import "NLUtils.h"
#import "NLContants.h"
#import "GTMBase64.h"
#import "NLProtocolRegister.h"
#import "SwiperReader.h"
#import "NLUserInforSettingsCell.h"
#import "SGFocusImageItem.h"
#import "SGFocusImageFrame.h"
#import "PayMoneyOK.h"
#import "AddressPAY.h"

@interface PAYSKQMore ()<SGFocusImageFrameDelegate>
{
    
     int     IOS7HEIGHT;
     int     ios7Height;
     int     ordernum;
     NSString* _cardno;
     NLProgressHUD* _hud;
     BOOL _enablePayCard;
     BOOL _enableCardImage;
     NSString* _paycardid;
     NSString* _bkntno;
     NSString* _result;
     NSString* _resultPayCard;
     NSString* _payCardCheck;
     NSArray  * _visaReaderArray;
     NSString *shyunfeitype;
     NSString *shyunfei;
     VisaReader* _visaReader;
     NSString *IsSallMoney;
     NSString *agentno;
     AddressPAY *add;
    NSString *strAllMoney;
    NSString *stryunMoney;
    NSString *PayMoneyAllstr;
    NSString *MoneyAllstr;
    
}

@property (strong, nonatomic) IBOutlet UIScrollView *ScrollerView;
@property (weak, nonatomic) IBOutlet UIButton *OnBtnClick;
@property (weak, nonatomic) IBOutlet UILabel *NameTextFiled;
@property (weak, nonatomic) IBOutlet UILabel *PhoneTextFiled;
@property (weak, nonatomic) IBOutlet UILabel *AdressTextFiled;
@property (assign,nonatomic)BOOL flagBankList;
@property (weak, nonatomic) IBOutlet UILabel *Money688;
@property (weak, nonatomic) IBOutlet UILabel *Money0;
@property (weak, nonatomic) IBOutlet UILabel *MoneyAll;
@property (weak, nonatomic) IBOutlet UIButton *OnMoreSKQ;
@property (weak, nonatomic) IBOutlet UIButton *LittleSKQ;
@property (assign,nonatomic)  BOOL  IsoNFlag;
@property (assign,nonatomic)  BOOL  YinLianFlag;
- (IBAction)isOnMoreySKQ:(id)sender;
- (IBAction)LittleSkQ:(id)sender;
- (IBAction)BtnOnclickAction:(id)sender;
@end

int num=1;
@implementation PAYSKQMore

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        // Custom initialization
        self.title= @"收银台";
    }
    
    return self;
}

-(void)readAuBkCardInfo
{
    NSString* name = [NLUtils getNameForRequest:Notify_readAuBkCardInfo];
    REGISTER_NOTIFY_OBSERVER(self, readAuBkCardInfoNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] readAuBkCardInfo];
}

-(void)readAuBkCardInfoNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [self doReadAuBkCardInfoNotify:response];
        //        [_hud hide:YES];
    }
    else
    {
        NSString* detail = response.detail;
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

-(void)doReadAuBkCardInfoNotify:(NLProtocolResponse*)response
{
    NSString *_shoucardno;
    
    NLProtocolData *data = [response.data find:@"msgbody/aushoucardno" index:0];
    
    _shoucardno = data.value;
  
    //直接读取卡号 是否设置过
    if (_shoucardno.length <= 0){
      
        add= [[AddressPAY alloc]initWithNibName:@"AddressPAY" bundle:nil];
        
        add.PYBankflage= YES;
        
        [self.navigationController pushViewController:add animated:YES];
    }else{
       
    //agentno ID 直接购买放弃返利
      _IsoNFlag = YES;
        
      [self performSelector:@selector(SKQpayOrderRq) withObject:nil afterDelay:0.1];
    }
    
   
}

//减30
-(void)viewDidAppear:(BOOL)animated
{
    num=1;
    
    [NLUtils sliderSetleftController:nil];
    
    [self startVisaReader];
    
    [super viewDidAppear:animated];
    
    [self someModelTextIsToUrl];
  
}

-(void)viewWillDisappear:(BOOL)animated
{
    [NLUtils enableSliderViewController:NO];
    
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

//这个先检测 进行这个方法
-(void)initVisaReader
{
    //_visaReader = [[VisaReader alloc] initWithDelegate:self];
    _visaReader = [VisaReader initWithDelegate:self];
    [_visaReader createVisaReader];
}
-(void)initValue
{
    _paycardid = @"";
    _enableCardImage = NO;
    _enablePayCard = YES;
    _bkntno = @"";
    _result= @"";
    _resultPayCard = @"";
    _payCardCheck = @"";
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _Money688.text = @"650.00 × 1";
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    IOS7HEIGHT=IOS7_OR_LATER==YES?0:64;
    
    ios7Height = [UIScreen mainScreen].bounds.size.height;
    
    [self loadData];
    
    [self.view addSubview:self.ScrollerView];
   
    [self someViewTableScrollerView];
    
    [self initValue];
    
    [self initVisaReader];
}

#pragma mark - 数据请求
- (void)loadData
{
    //创建通知名
    NSString *name = [NLUtils getNameForRequest:Notify_ApiAgentInfo];
    //创建通知
    REGISTER_NOTIFY_OBSERVER(self, getDataWithNotify, name);
    //发送请求
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApiAgentInfo];
}

#pragma mark - 数据判断
- (void)getDataWithNotify:(NSNotification *)notify
{
    NLProtocolResponse *response = (NLProtocolResponse *)notify.object;
    int error = response.errcode;
    
    //判断信息是否正确
    if (RSP_NO_ERROR ==error)
    {
        [self getDataWithResponse:response];
    }
    else if (error == RSP_TIMEOUT)
    {
        return ;
    }
    else
    {
        
    }
}

#pragma mark - 获取数据
- (void)getDataWithResponse:(NLProtocolResponse *)response
{
    NLProtocolData *data = [response.data find:@"msgbody/result" index:0];
    NSString *result = data.value;
    
    NSRange range = [result rangeOfString:@"succ"];
    
    if (range.length <= 0)
    {
        //获取错误信息
        NLProtocolData *errorData = [response.data find:@"msgbody/message" index:0];
        
        NSLog(@"%@",errorData);
    }
    else
    {
        NSArray *agentnos = [response.data find:@"msgbody/agentno"];
        
        NLProtocolData *agentnoData = agentnos[0];
        
        agentno = agentnoData.value;
        
        [_myTableView reloadData];
    }
}

-(void)someModelTextIsToUrl{

    NSLog(@"dict %@  %@",self.dict,self.arraydic);
   
    if ([_arraydic valueForKey:@"produrename"]) {
        
    }
    
    NSString *IsOnmoey= [[_arraydic valueForKey:@"produrezheprice"]objectAtIndex:0];
    
    self.NameTextFiled.text= [self.dict objectForKey:@"shman"];
    self.PhoneTextFiled.text= [self.dict objectForKey:@"shphone"];
    self.AdressTextFiled.text= [self.dict objectForKey:@"shaddress"];
    self.Money0.text= [NSString stringWithFormat:@"%@元",[self.dict objectForKey:@"shyunfei"]];
    
    if (add.payAgentFlage==YES)
    {
         self.MoneyAll.text= [NSString stringWithFormat:@"￥%d.00元",[IsOnmoey intValue]+[[self.dict objectForKey:@"shyunfei"]intValue]-30*ordernum];
    }
    else
    {
         self.MoneyAll.text= [NSString stringWithFormat:@"￥%d.00元",[IsOnmoey intValue]+[[self.dict objectForKey:@"shyunfei"]intValue]];
    }
    
    //取消返回来的个数 金钱显示
    [self.ScrollerView addSubview:_Money688];
    
    shyunfeitype=[self.dict objectForKey:@"shyunfeitype"];
    
    //运费类型 运了多少要多少运费
    shyunfei= [self.dict objectForKey:@"shyunfei"];
}

-(void)someViewTableScrollerView
{
    _myTableView.frame= CGRectMake(0, 0 - IOS7HEIGHT * 1 / 8, 320, 100);
    
    _myTableView.userInteractionEnabled= YES;
    
    _myTableView.scrollEnabled= NO;
    
    [self.ScrollerView addSubview:_myTableView];
    
    _OnBtnClick.frame= CGRectMake(10, 385 + IOS7HEIGHT * 1 / 3, 300, 40);
    
    self.ScrollerView.hidden= NO;
    
    if (ios7Height==568)
    {
        self.ScrollerView.frame= CGRectMake(self.ScrollerView.frame.origin.x, 0, 320, 504);
        
//        self.ScrollerView.scrollEnabled= NO;
        [self.ScrollerView setContentSize:CGSizeMake(320,700)];
    }
    else
    {
        self.ScrollerView.frame= CGRectMake(self.ScrollerView.frame.origin.x, 0, 320, 416);
        
        [self.ScrollerView setContentSize:CGSizeMake(320,700)];
    }
    
    [self.ScrollerView addSubview:_OnBtnClick];

    UITapGestureRecognizer *oneFingerTwoTaps = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(oneFingerTwoTaps)];
    // Set required taps and number of touches
    [oneFingerTwoTaps setNumberOfTapsRequired:2];
    
    [self.myTableView addGestureRecognizer:oneFingerTwoTaps];

}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
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
    cell.myContainer = self;
    
    //改自己的cell方法进行替换
    [cell.myTextField addTarget:self action:@selector(textFieldWithCardno:) forControlEvents:UIControlEventEditingChanged];
    switch (indexPath.row)
    {
        case 0:
        {
            cell.myContentLabel.hidden = YES;
            cell.myHeaderLabel.text = @"付款账户";
            cell.myTextField.hidden = NO;
            cell.myTextField.tag= 0;
            cell.myTextField.keyboardType = UIKeyboardTypeNumberPad;
            [cell.myTextField setFrame:CGRectMake(cell.myTextField.frame.origin.x, cell.myTextField.frame.origin.y, 155, cell.myTextField.frame.size.height)];
            
            if ([_cardno length] <= 0)
            {
                cell.myTextField.placeholder = @"刷卡或手动输入卡号";
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
            /*
        case 1:
        {
            cell.myContentLabel.hidden = YES;
            cell.userInteractionEnabled= NO;
            cell.myHeaderLabel.text = @"区域ID:";
            cell.myTextField.hidden = NO;
            cell.myTextField.tag= 1;
            if ([agentno length] <= 0)
            {
                  cell.myTextField.placeholder= @"请输入区域ID（选填）";
            }
            else
            {
                cell.myTextField.text = agentno;
                NSLog(@"agentno1 %@",agentno);
            }

            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
            break;
             */
        default:
            break;
    }

    return cell;
}

#pragma 验证输入卡号
+ (BOOL)checkPayCard:(NSString*)paycardid
{
    if (paycardid.length <= 0)
    {
        return NO;
    }
    
    NSString* mach = @"^[0-9]{14,20}$";
    
    return [PAYSKQMore matchRegularExpressionPsy:paycardid match:mach];
}

+ (BOOL)matchRegularExpressionPsy:(NSString*)text match:(NSString*)match
{
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:match options:0 error:&error];
    
    if (regex != nil)
    {
        NSTextCheckingResult *firstMatch = [regex firstMatchInString:text options:0 range:NSMakeRange(0, [text length])];
        
        if (firstMatch)
        {
            return YES;
        }
    }
    
    return NO;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, 30);
    
    UIView* view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:[UIColor clearColor]];
    
    rect.origin.x = 10;
    rect.origin.y = 5;
    rect.size.width = 300;
    rect.size.height = 30;
    
    UILabel* label = [[UILabel alloc] initWithFrame:rect];
    label.adjustsFontSizeToFitWidth = NO;
    label.backgroundColor=[UIColor clearColor];
    label.font=[UIFont systemFontOfSize:17];
    label.textColor = [UIColor lightGrayColor];
    
    if (0 == section)
    {
        label.text = @"付款银行账号信息";
    }
    
    [view addSubview:label];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 80;
}

/*
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, 30);
    
    UIView* view = [[UIView alloc] initWithFrame:rect];
    
    [view setBackgroundColor:[UIColor clearColor]];
    
    rect.origin.x = 10;
    
    rect.origin.y = 5;
    
    rect.size.width = 300;
    
    rect.size.height = 30;
    
    UILabel* label = [[UILabel alloc] initWithFrame:rect];
    
    label.adjustsFontSizeToFitWidth = NO;
    
    label.backgroundColor=[UIColor clearColor];
    
    label.numberOfLines= 2;
    
    label.font=[UIFont systemFontOfSize:14];
    
    label.textColor = [UIColor orangeColor];
    
    if (0 == section)
    {
        label.text = @"提醒:如填写您的区域代号、购买将立减30元";
    }
    [view addSubview:label];
    
    return view;
}
*/

- (void)textFieldWithCardno:(UITextField *)textField
{
    switch (textField.tag)
    {
        case 0:
            _cardno = textField.text;
            break;
//        case 1:
//            agentno = textField.text;
//
//            break;
        default:
            break;
    }
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma showErrorInfo
//判断信息是否正确
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
-(void)doVisaReaderEvent:(SwiperReaderStatus)event object:(NSString *)object
{
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
            
            _payCardCheck=_paycardid;
            
            [self resetCardNumber:_cardno];
            
            [self payCardCheck];
        }
    }
}

-(void)resetCardNumber:(NSString*)str
{
    if (str.length > 0)
    {
        NLUserInforSettingsCell* cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        cell.myTextField.text = str;
    }
}

#pragma 刷卡器验证
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
    NSString *result = data.value;
    
    [self showErrorInfo:result status:NLHUDState_NoError];
}

//验证刷卡器卡号的长度
-(BOOL)checkTransferInfo
{
    if (_cardno.length<=0)
    {
        [self showErrorInfo:@"亲，请插入通付宝刷卡器并刷卡" status:NLHUDState_Error];
        return NO;
    } if (_cardno.length<14)
    {
        [self showErrorInfo:@"亲，请输入正确的银行卡号" status:NLHUDState_Error];
        return NO;
    }
//    if (agentno.length>1) {
//        
//        [self showErrorInfo:@"亲，请插入正确的代理商代号" status:NLHUDState_Error];
//        return NO;
//    }
    return YES;
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

#pragma imageIsOnOrNo
-(void)resetCardImage:(BOOL)enable
{
    if (enable == YES)
    {
        _enableCardImage = YES;
        
        NLUserInforSettingsCell* cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell.myUprightImage.image = [UIImage imageNamed:@"swipingCard2.png"];
    }
    else
    {
        _enableCardImage = NO;
        
        NLUserInforSettingsCell* cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell.myUprightImage.image = [UIImage imageNamed:@"swipingCard.png"];
    }
}

#pragma mark - UPPayPluginDelegate
- (void)UPPayPluginResult:(NSString *)result
{
    if ([result isEqualToString:@"success"] || [result isEqualToString:@"cancel"] || [result isEqualToString:@"fail"])
    {
        _result = result;
        
        NSLog(@"_result%@",_result);
        
        _YinLianFlag=YES;
        
        //这里要加取消后显示的数据
        NSString *strM= [[NSUserDefaults standardUserDefaults]objectForKey:@"strAllMoney"];
            
        self.MoneyAll.text= strM;
        
        self.Money688.text= [NSString stringWithFormat:@"%@ × %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"IsSallMoney"], [[NSUserDefaults standardUserDefaults]objectForKey:@"ordernum"]];
    }
    else
    {
        return;
    }
    
    //支付成功后反馈
    [self ensureSQKPayMoney];
}

- (BOOL)doStartPay:(NSString *)payData sysProvide:(NSString*)sysProvide spId:(NSString*)spId mode:(NSString*)mode viewController:(UIViewController *)viewController delegate:(id<UPPayPluginDelegate>)delegate;
{
    return [UPPayPlugin startPay:payData mode:mode viewController:viewController delegate:delegate];
}

//银联返回的数据
#pragma elseShow
-(void)showMainView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) doPush
{
    [_hud hide:YES];
    [NLUtils popToLogonVCByHTTPError:self feedOrLeft:1];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma 按钮来的
- (IBAction)BtnOnclickAction:(id)sender
{
    if ([self checkTransferInfo])//确认提交 检查是否正确信息
    {
        //放弃返利的/或者直接购买
       if (add.UpPayFlage==YES)
       {
           
        [self performSelector:@selector(SKQpayOrderRq) withObject:nil afterDelay:0.1];
            
       }
       else
       {
            [self readAuBkCardInfo];
        }
    }
}

- (IBAction)isOnMoreySKQ:(id)sender
{
    if (num < 9)
    {
        num++;
        IsSallMoney= [[_arraydic valueForKey:@"produrezheprice"]objectAtIndex:0];
        
        self.Money688.text= [NSString stringWithFormat:@"%@ × %d",IsSallMoney,num];
        
        _Money0.text=[NSString stringWithFormat:@"%@元",shyunfei];
       
        if (add.payAgentFlage==YES)
        {
            
             self.MoneyAll.text= [NSString stringWithFormat:@"￥%d.0元",[IsSallMoney intValue]*num+[shyunfei intValue]-30*ordernum];
        }
        else
        {
            //还要加上运费
            self.MoneyAll.text= [NSString stringWithFormat:@"￥%d.0元",[IsSallMoney intValue]*num+[shyunfei intValue]];
        }
        
        ordernum= num;
        
        NSLog(@"运费类型%@",shyunfei);
          NSLog(@"++ %d",ordernum);
    }
}

- (IBAction)LittleSkQ:(id)sender {
    if (num>=2) {
        num--;
       
        self.Money688.text= [NSString stringWithFormat:@"%@ × %d",IsSallMoney,num];
       
        if (add.payAgentFlage==YES) {
            
            PayMoneyAllstr= [NSString stringWithFormat:@"￥%d.0元",[IsSallMoney intValue]*num+[shyunfei intValue]-30*ordernum];
            
            self.MoneyAll.text= PayMoneyAllstr;
        }else{
            
             MoneyAllstr= [NSString stringWithFormat:@"￥%d.0元",[IsSallMoney intValue]*num+[shyunfei intValue]];
            
             self.MoneyAll.text= MoneyAllstr;
        }
        
        ordernum= num;
//        NSLog(@"-- %d",ordernum);
    }

}

#pragma mark 请求银联交易号接口
-(void)SKQpayOrderRq
{
    //取消或返回支付的数量状态
    NSString *ordernumStr= [NSString stringWithFormat:@"%d",ordernum];
        
    [[NSUserDefaults standardUserDefaults] setObject:ordernumStr forKey:@"ordernum"];
    [[NSUserDefaults standardUserDefaults] setObject:IsSallMoney forKey:@"IsSallMoney"];
    [[NSUserDefaults standardUserDefaults] synchronize];
   
    NSString* name = [NLUtils getNameForRequest:Notify_payOrderRq];
    
    REGISTER_NOTIFY_OBSERVER(self, SKQpayOrderRqNotify, name);
    
    [self pushToYinLian];
}

-(void)pushToYinLian
{
     stryunMoney = [self.Money0.text stringByReplacingOccurrencesOfString:@"元" withString:@""];
    
    //如果代理商id没填或不正确 都不返现
    if (agentno.length>4 && _IsoNFlag==YES)
    {
        IsSallMoney= [[_arraydic valueForKey:@"produrezheprice"]objectAtIndex:0];
        
        PayMoneyAllstr= [NSString stringWithFormat:@"￥%d.0元",[IsSallMoney intValue]*ordernum+[shyunfei intValue]-30*ordernum];
        
        strAllMoney= [PayMoneyAllstr stringByReplacingOccurrencesOfString:@"￥" withString:@""];
        
    }
    else
    {
        strAllMoney = [self.MoneyAll.text stringByReplacingOccurrencesOfString:@"￥" withString:@""];
    }
    
    NSString* str = [_visaReaderArray objectAtIndex:2];
    
    NSData* data = [NLUtils stringToData:str];
    
    NSString* merReserved = [GTMBase64 stringByEncodingData:data];
    
    NSLog(@"_paycardid刷卡就有 %@",_paycardid);
    
    BOOL result = [PAYSKQMore checkPayCard:_cardno];
    
    if (!result)
    {
        [self showErrorInfo:@"请确定您输入的银行卡是正确的" status:NLHUDState_Error];
        return;
    }
    else
    {
        [self showErrorInfo:@"正在跳转银联..." status:NLHUDState_None];
        
        [[[NLProtocolRequest alloc] initWithRegister:YES] paySKQcardIDRq:_paycardid orderPaytypeid:@"1" orderprodureid:[[_arraydic valueForKey:@"produreid"]objectAtIndex:0] ordernum:[NSString stringWithFormat:@"%d",ordernum] orderprice:[[_arraydic valueForKey:@"produrezheprice"]objectAtIndex:0]ordermoney:strAllMoney ordershaddressid: [_dict objectForKey:@"shaddressid"] oredershaddress:self.AdressTextFiled.text ordershman:self.NameTextFiled.text ordershphone:self.PhoneTextFiled.text orderfucardno:_cardno orderfucardbank:@"" ordermemo:@"text" yunmoney:stryunMoney yunprice:@"0" promoney:[[_arraydic valueForKey:@"produrezheprice"] objectAtIndex:0] produrename:[[_arraydic valueForKey:@"produrename"]objectAtIndex:0] agentno:agentno];
    }
}

-(void)SKQpayOrderRqNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)//正确的话
    {
        [self doSKQpayOrderRqNotify:response];
    }
    else if (error == RSP_TIMEOUT)//错误代码 或超时登陆
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

//获取流水线并跳到银联
-(void)doSKQpayOrderRqNotify:(NLProtocolResponse*)response
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
        self.MoneyAll.text= strAllMoney;
        
        [[NSUserDefaults standardUserDefaults]setObject:strAllMoney forKey:@"strAllMoney"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
       //交易码
        NLProtocolData* data =  [response.data find:@"msgbody/bkntno" index:0];
        
        _bkntno = data.value;
        
        [_hud hide:YES];
        
        [self doStartPay:_bkntno
              sysProvide:nil
                    spId:nil
                    mode:[NLUtils get_req_bkenv]
          viewController:self
                delegate:self];
    }
}

#pragma mark 交易反馈接口
-(void)ensureSQKPayMoney
{
    NSString* name = [NLUtils getNameForRequest:Notify_orderPayrqStatus];
    
    REGISTER_NOTIFY_OBSERVER(self, orderPayrqStatusNotify, name);
    
    [[[NLProtocolRequest alloc] initWithRegister:YES] checkPaySKQStatus:_bkntno result:_result];
    
    [self showErrorInfo:@"客官，请稍候。。。" status:NLHUDState_None];
}

-(void)orderPayrqStatusNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        
        [self doOrderPayrqStatusNotify:response];
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
        
        if ([detail isEqualToString:@"支付失败!"])
            
            if (!detail || detail.length <= 0)
            {
                detail = @"服务器繁忙，请稍候再试";
            }
        
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

//充值完成返回来的页面
-(void)doOrderPayrqStatusNotify:(NLProtocolResponse*)response
{
    NSRange range = [_result rangeOfString:@"succ"];
    if (range.length <= 0)
    {
        NLProtocolData* data = [response.data find:@"msgbody/message" index:0];
        NSString* value = data.value;
        [self showErrorInfo:value status:NLHUDState_Error];
    }
    else
    {
        //跳转成功页面
        PayMoneyOK* payOk = [[PayMoneyOK alloc] initWithNibName:@"PayMoneyOK" bundle:nil];
        payOk.title = @"购买成功";
        payOk.dict = @{BUY_SUC_TITLT: @"购买成功",BUY_SUC_CONTENT: @"您成功在明盛商场购买了通付宝刷卡器"};
        [self.navigationController pushViewController:payOk animated:YES];
    }
}

- (void)registerForKeyboardNotifications
{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidde:) name:UIKeyboardWillHideNotification object:nil];
}

//-(void)keyboardWasShow:(NSNotification*)noti
//{
//    [UIView beginAnimations:nil context:nil];
//    self.view.frame= CGRectMake(0,self.view.frame.origin.y+120, self.view.frame.size.width, self.view.frame.size.height);
//    [UIView commitAnimations];
//}
//
//-(void)keyboardWasHidde:(id)noti
//{
//    [UIView beginAnimations:nil context:nil];
//    self.view.frame= CGRectMake(0, self.view.frame.origin.y-120, self.view.frame.size.width, self.view.frame.size.height);
//    [UIView commitAnimations];
//}

@end


















