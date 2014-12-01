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
#import "NLCashMorePay.h"

@interface NLCashArriveMainViewController ()
{
    NSString* _commercial;
    NSString* _arrive;
    NSString* _couponid;
    NSString* _couponmoney;
    int _count;
    NLProgressHUD* _hud;
    
    BOOL  flagYZM;
    NSString   *requrl;
    NSString* bknordernumber;
    
    //总额限制
    NSInteger limitNum;
    
    //张数限制
    NSInteger limitBuyNum;
    
    /*id类型*/
    NSInteger couponidNum;
    
    NSString * _transferType;
    
    //立即购买按钮
    UIButton *buyBtn;
}

@property(nonatomic,retain) IBOutlet NLKeyboardAvoidingTableView* myTableView;
@property(nonatomic,retain) NSMutableArray* mycouponArray;
@property (weak, nonatomic) IBOutlet UIView *viewA;
@property (weak, nonatomic)  UIButton *skqBtn;
@property (weak, nonatomic)  UIButton *HtbBtn;

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
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"收款历史"
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
    /*状态页面*/
    [self viewinMain];
    [self readcouponinfo];
}

/*汇通宝支付*/
-(void)viewinMain
{
    _skqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _skqBtn.frame = CGRectMake(10, 250, 150, 44);
    _HtbBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _HtbBtn.frame = CGRectMake(160, 250, 150, 44);
    
    [_skqBtn setSelected:YES];
    _transferType= @"_skqBtn";
    [_skqBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_skqBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_HtbBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_HtbBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    [_skqBtn setBackgroundImage:[NLUtils createImageWithColor:SACOLOR(219, 1.0) rect:CGRectMake(0, 0, 150, 44)] forState:UIControlStateNormal];
    [_skqBtn setBackgroundImage:[NLUtils createImageWithColor:RGBACOLOR(28, 179, 241, 1.0) rect:CGRectMake(0, 0, 150, 44)] forState:UIControlStateSelected];
    [_HtbBtn setBackgroundImage:[NLUtils createImageWithColor:SACOLOR(219, 1.0) rect:CGRectMake(0, 0, 150, 44)] forState:UIControlStateNormal];
    [_HtbBtn setBackgroundImage:[NLUtils createImageWithColor:RGBACOLOR(28, 179, 241, 1.0) rect:CGRectMake(0, 0, 150, 44)] forState:UIControlStateSelected];
    
    [_skqBtn setTitle:@"刷卡支付" forState:UIControlStateNormal];
    [_HtbBtn setTitle:@"使用汇通宝" forState:UIControlStateNormal];
    _skqBtn.titleLabel.font= [UIFont systemFontOfSize:14];
    _HtbBtn.titleLabel.font= [UIFont systemFontOfSize:14];
    [_skqBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_HtbBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
     [_skqBtn addTarget:self action:@selector(clickCategory:) forControlEvents:UIControlEventTouchUpInside];
     [_HtbBtn addTarget:self action:@selector(clickCategory:) forControlEvents:UIControlEventTouchUpInside];
    /* */
    [self.view addSubview:_skqBtn];
    [self.view addSubview:_HtbBtn];
    
//    _viewA.frame= CGRectMake(self.viewA.frame.origin.x, 320, self.viewA.frame.size.width, self.viewA.frame.size.height);
   
    NSNumber *Vienum= [NSNumber numberWithFloat:_skqBtn.frame.origin.y+60];
    [_viewA.layer setValue:Vienum forKeyPath:@"frame.origin.y"];
   
    buyBtn = [UIButton buttonWithFrame:CGRectMake(10, 5, SelfWidth - 20, 40)
                         unSelectImage:imageName(@"yellow_button@2x", @"png")
                           selectImage:nil
                                   tag:10000
                            titleColor:[UIColor whiteColor]
                                 title:@"下一步"];
    [buyBtn addTarget:self action:@selector(onBuyNowBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_viewA addSubview:buyBtn];
}

-(void)clickCategory:(UIButton *)sender
{
    if (sender==_HtbBtn)
    {
        _transferType= @"_HtbBtn";
        _HtbBtn.selected = YES;
        _skqBtn.selected =  NO;
    }
    else
    {
        _transferType= @"_skqBtn";
        _HtbBtn.selected = NO;
        _skqBtn.selected =  YES;
    }
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
    
    if (_count==0)
    {
        [self showErrorInfo:@"请输入收款金额" status:NLHUDState_Error];
        return NO;
    }
    /*
    if (_count == 0||_count<0)
    {
        [self showErrorInfo:@"选择购买数量" status:NLHUDState_Error];
        return NO;
    }
    if (_count * [_couponmoney doubleValue]>limitNum) {
        [self showErrorInfo:@"购买数量过多" status:NLHUDState_Error];
        return NO;
    }
     
      <?xml version='1.0' encoding='utf-8' standalone='yes' ?><operation_response><msgheader version = "1.0"><au_token>yicSUMfApPDJlA7i97B622YG</au_token><req_token></req_token><req_bkenv>00</req_bkenv><retinfo><rettype>0</rettype><retcode>0</retcode><retmsg>ËØªÂèñÊäµÁî®Âà∏‰ø°ÊÅØÊàêÂäüÔºÅ</retmsg></retinfo></msgheader>
     
     <msgbody><msgchild><couponid>59</couponid><couponmoney>1</couponmoney><couponlimitnum>19845</couponlimitnum></msgchild><msgchild><couponid>60</couponid><couponmoney>19845</couponmoney><couponlimitnum>1</couponlimitnum></msgchild><result>success</result><message>ËØªÂèñÊäµÁî®Âà∏‰ø°ÊÅØÊàêÂäüÔºÅ</message><shopname>ÊòéÁõõÂïÜÂüé</shopname><isshop>1</isshop></msgbody></operation_response>
     
     */
    return YES;
}

- (IBAction)onBuyNowBtnClicked:(UIButton*)sender
{
    
    if ([self checkInfor])
    {
         /*
        NLCashSecondViewController* vc = [[NLCashSecondViewController alloc] initWithNibName:@"NLCashSecondViewController"bundle:nil];
        double sum = _count * [_couponmoney doubleValue];
        NSString* couponmoney = [NSString stringWithFormat:@"%.2f",sum];
        vc.myDictionary = [NSDictionary dictionaryWithObjectsAndKeys:_couponid,@"couponid",couponmoney,@"couponmoney", nil];
        [self.navigationController pushViewController:vc animated:YES];
   */
       /*刷卡支付*/
        if ([_transferType isEqualToString:@"_skqBtn"])
        {
            [self.view endEditing:YES];
            NLCashSecondViewController* vc = [[NLCashSecondViewController alloc] initWithNibName:@"NLCashSecondViewController"bundle:nil];
            double sum = _count * [_couponmoney doubleValue];
            NSString* couponmoney = [NSString stringWithFormat:@"%.2f",sum];
            
            vc.myDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSString stringWithFormat:@"%d",couponidNum],@"couponid",
                               couponmoney,@"couponmoney", nil];
            
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            
            [self readSKQInfo];
   
        }
       
    }
}

/*获取汇通卡是否绑定*/
/*汇通宝-商户收款（抵用券）*/
-(void)readSKQInfo
{
    double sum = _count * [_couponmoney doubleValue];
    NSString* couponmoney = [NSString stringWithFormat:@"%.2f",sum];
    NSString* name = [NLUtils getNameForRequest:Notify_ApiExpresspayInfo];
    REGISTER_NOTIFY_OBSERVER(self, readSKQInfoNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApiExpresspayInfo:@"59" couponmoney:couponmoney paycardid:@"4"];
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
}

//刷卡器的读取选项
-(void)readSKQInfoNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        
        [self doreadSKQInfoNotify:response];
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

//获取到的刷卡器信息选项
-(void)doreadSKQInfoNotify:(NLProtocolResponse*)response
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
        NLProtocolData* data = [response.data find:@"msgbody/requrl" index:0];
        requrl = data.value;
        data = [response.data find:@"msgbody/bkordernumber" index:0];
        bknordernumber = data.value;
     
        double sum = _count * [_couponmoney doubleValue];
        NSString* couponmoney = [NSString stringWithFormat:@"%.2f",sum];
        
        [self.view endEditing:YES];
        NLCashMorePay* vc = [[NLCashMorePay alloc] initWithNibName:@"NLCashMorePay" bundle:nil];
        vc.weburl= requrl;
        vc.bknordernumber= bknordernumber;
        vc.couponmoneyStr= couponmoney;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)buyHistory
{
    [self.view endEditing:YES];
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

/*
-(void)doDownrightBtnClicked:(id)sender
{
    if (_count > 0)
    {
        _count--;
        [self refreshCountCell];
    }
    
    return;
}
*/

/*
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
 */

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
    cell.mySelectedBtn.hidden = YES;
    [cell.myTextField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];

    switch (indexPath.row)
    {
        case 0:
        {
            cell.myHeaderLabel.text = @"收款商户";
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
            
//        case 1:
//        {
//            cell.myHeaderLabel.text = @"收款额度";
//            cell.myContentLabel.hidden = NO;
//            cell.myContentLabel.textAlignment = UITextAlignmentCenter;
//            cell.myContentLabel.text = @"1";
//            cell.myTextField.hidden = YES;
//            cell.myDownrightBtn.hidden = YES;
//            cell.myUprightBtn.hidden = YES;
//            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            cell.accessoryType = UITableViewCellAccessoryNone;
//        }
//            break;
            
        case 1:
        {
            cell.myContainer = self;
            cell.myHeaderLabel.text = @"收款金额";
            cell.myContentLabel.hidden = YES;
            cell.myTextField.hidden = NO;
            cell.myTextField.delegate = self;
            cell.myTextField.placeholder = @"请输入收款金额";
            [cell.myTextField setFrame:CGRectMake(120, cell.myTextField.frame.origin.y, 140, cell.myTextField.frame.size.height)];
            cell.myTextField.textAlignment = NSTextAlignmentCenter;
            cell.myTextField.backgroundColor = [UIColor clearColor];
            cell.myTextField.keyboardType = UIKeyboardTypeNumberPad;
            
            if (_count != 0)
            {
                cell.myTextField.text = [NSString stringWithFormat:@"%d",_count];
            }
            
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
    /*选择按钮键值
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
     */
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
    
    if (count>0)
    {
        NSDictionary *firstDic = self.mycouponArray[0];
        limitBuyNum = [firstDic[@"couponlimitnum"]intValue];
        limitNum = [firstDic[@"couponmoney"]intValue]*[firstDic[@"couponlimitnum"]intValue];
        couponidNum= [firstDic[@"couponid"]intValue];
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
            detail = @"服务器繁忙，请稍候再试";
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

- (void)doPush
{
    [_hud hide:YES];
    [NLUtils popToLogonVCByHTTPError:self feedOrLeft:1];
}

#pragma mark - UITextFieldDetegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString  *str = [NSString stringWithFormat:@"%@%@",textField.text,string];
    
    if (limitBuyNum > 0 && [str doubleValue] > limitBuyNum)
    {
        [self showErrorInfo:[NSString stringWithFormat:@"收款金额不能超过%d",limitBuyNum] status:NLHUDState_Error];
        
        return NO;
    }
    
    return YES;
}

@end




















