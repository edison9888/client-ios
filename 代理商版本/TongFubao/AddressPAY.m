//
//  AddressPAY.m
//  TongFubao
//
//  Created by  俊   on 14-5-14.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "AddressPAY.h"
#import "SGFocusImageItem.h"
#import "SGFocusImageFrame.h"
#import "NLProgressHUD.h"
#import "NLUserInforSettingsCell.h"
#import "NLContants.h"
#import "NLLogOnViewController.h"
#import "HZAreaPickerView.h"
#import "PAYSKQMore.h"
#import "AddressPAY.h"
#import "NLUtils.h"
#import "IsSurePAYAddress.h"
#import "NLProtocolRequest.h"

@interface AddressPAY ()<HZAreaPickerDelegate>
{
     NSString * _result;
     bool     *payAgentFlage;
     int     IOS7HEIGHT;
     NLProgressHUD* _hud;
     UIButton *Labelbtn;
     NSString *AderssIsProv;
     NSString *JumpType;
}
@property (weak, nonatomic) IBOutlet
NLKeyboardAvoidingTableView *tableViewFrame;
@property (strong, nonatomic) NSString *areaValue;
@property (strong,nonatomic)NSString *areaText;
@property (strong, nonatomic) HZAreaPickerView *locatePicker;
@property (weak, nonatomic) IBOutlet UIButton *IsOkBtn;

@property (strong, nonatomic) NSString *BankName;
@property (strong, nonatomic) NSString *BankPhone;
@property (strong, nonatomic) NSString *BankList;
@property (strong, nonatomic) NSString *BankNum;
@end

@implementation AddressPAY
@synthesize areaValue=_areaValue,areaText;
@synthesize PhoneStr,NameStr,CityStr,AreaStr,AllAddressStr,ProvinceStr,ZoneStr,PatientiaAddressStr,BankList,BankName,BankNum,BankPhone;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark - http request

-(void)doModifyAuBkCardInfoNotify:(NLProtocolResponse*)response
{
    NLProtocolData* data = [response.data find:@"msgbody/message" index:0];
    
    NSString* message = data.value;
    
    [self showErrorInfo:message status:NLHUDState_NoError];
    
    [self performSelector:@selector(goBack) withObject:nil afterDelay:2.0f];

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
    }
}

-(void)modifyAuBkCardInfo
{
    [self showErrorInfo:@"正在提交信息" status:NLHUDState_None];
    NSString* name = [NLUtils getNameForRequest:Notify_modifyAuBkCardInfo];
    REGISTER_NOTIFY_OBSERVER(self, modifyAuBkCardInfoNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] modifyAuBkCardInfo:BankName aushoucardphone:BankPhone aushoucardno:BankNum aushoucardbank:BankList];
}

-(void)goBack
{
    self.payAgentFlage=YES;
    
    [self.navigationController popViewControllerAnimated:YES];

}

//读取的
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
    
    NLProtocolData* data = [response.data find:@"msgbody/result" index:0];
    
    NSString *result = data.value;
    
    NSRange range = [result rangeOfString:@"succ"];
    
    if (range.length <= 0)
    {
        NLProtocolData* data = [response.data find:@"msgbody/message" index:0];
        
        NSString* value = data.value;
        
        [self showErrorInfo:value status:NLHUDState_Error];
        
    }
    
    NLProtocolData *shoucardnoData = [response.data find:@"msgbody/aushoucardno" index:0];
    
    _shoucardno = shoucardnoData.value;
    
    NSRange shoucardnorange = [_result rangeOfString:@"aushoucardno"];
    
    if (shoucardnorange.length <= 0){
        //不设定
        
        [self.navigationController popViewControllerAnimated:YES];
    }else{
         //如果设定完成了

         self.payAgentFlage=YES;
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (_PYBankflage==YES) {
        
         self.navigationController.topViewController.title = @"默认账户";
    }else{
         self.navigationController.topViewController.title = @"新增地址";
    }
    
    
    IOS7HEIGHT=IOS7_OR_LATER==YES?0:64;
    
    _IsOkBtn.frame= CGRectMake(16, 300-IOS7HEIGHT, 288, 40);
    
    [self.view addSubview:_IsOkBtn];
    
    if (_PYBankflage==YES) {
        
        UIButton *btn= [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.frame= CGRectMake(16, 360-IOS7HEIGHT, 288, 40);
        [btn setBackgroundImage:[UIImage imageNamed:@"change_btn_normalside.png"] forState:UIControlStateNormal];
        
        [btn setTitle:@"放弃返利" forState:UIControlStateNormal];
        
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [btn
          addTarget:self action:@selector(btnActionAgent) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:btn];
    }
    
    _tableViewFrame.frame= CGRectMake(0, 64-IOS7HEIGHT*2/3, 320, 220);
    
    _tableViewFrame.userInteractionEnabled= YES;
    
    [self.view addSubview:_tableViewFrame];
    
    
}

-(void)btnActionAgent{
    self.UpPayFlage=YES;
    [self.navigationController popViewControllerAnimated:YES];
}

//完成的跳转
- (IBAction)IsOnBtn:(id)sender {
    
    if ([self checkData]) {
        
        if (_PYBankflage==YES) {
            
            _payAgentFlage= YES;
          
            [self modifyAuBkCardInfo];
            
        }else if(_payAgentFlage!=YES){
            
            JumpType = @"finish";
            
            [self performSelector:@selector(addBuySKQAddress) withObject:nil afterDelay:0.1];
        }
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
    cell.tag= indexPath.row;
    
    cell.myHeaderLabel.hidden = NO;
    
    cell.myTextField.hidden = NO;
    
    cell.myDownrightBtn.hidden = YES;
    
    cell.myUprightBtn.hidden = YES;
    
    cell.myContentLabel.hidden = YES;
    
    cell.textLabel.font= [UIFont systemFontOfSize:19];
    
    [cell.myTextField addTarget:self action:@selector(textFieldWithSKQ:) forControlEvents:UIControlEventEditingChanged];
    
    cell.myTextField.delegate = self;
    
    if (_PYBankflage==YES) {
        switch (indexPath.row)
        {
            case 0:
            {
                cell.myHeaderLabel.text = @"开户人：";
                cell.myTextField.placeholder = @"请输入姓名";
                cell.myTextField.tag=0;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
                break;
            case 1:
            {
                cell.myHeaderLabel.text = @"手机号码：";
                cell.myTextField.placeholder = @"请输入银行预留手机号";
                cell.myTextField.tag=1;
                cell.myTextField.keyboardType = UIKeyboardTypeNumberPad;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
                break;
            case 2:
            {
                cell.myHeaderLabel.text = @"银行卡号：";
                cell.myTextField.placeholder = @"请输入银行卡号";
                cell.myTextField.tag=2;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
                break;
                
            case 3:
            {
                cell.myHeaderLabel.text = @"开户银行：";
                cell.myTextField.placeholder = @"请输入银行卡";
                cell.myTextField.tag=3;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
                break;
            default:
                break;
        }
        
    }else{
        switch (indexPath.row)
        {
            case 0:
            {
                cell.myHeaderLabel.text = @"收货人";
                cell.myTextField.placeholder = @"请输入收货人姓名";
                cell.myTextField.tag=0;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
                break;
            case 1:
            {
                Labelbtn= [UIButton buttonWithType:UIButtonTypeCustom];
                //            Labelbtn.backgroundColor= [UIColor redColor];
                Labelbtn.frame= CGRectMake(75, 5, 210, 35);
                Labelbtn.backgroundColor= [UIColor clearColor];
                [Labelbtn setTitle:@"请滚动选择您所在的区域" forState:UIControlStateNormal];
                Labelbtn.titleLabel.font= [UIFont systemFontOfSize:14];
                cell.myTextField.tag=1;
                [Labelbtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                [Labelbtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
                cell.myHeaderLabel.text = @"收货区域";
                [cell addSubview:Labelbtn];
                cell.myTextField.hidden=YES;
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
                break;
            case 2:
            {
                cell.myHeaderLabel.text = @"收货地址";
                cell.myTextField.placeholder = @"您的详细街道地址、门牌号";
                cell.myTextField.tag=2;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
                break;
                
            case 3:
            {
                cell.myHeaderLabel.text = @"联系电话";
                cell.myTextField.placeholder = @"请输入您要收货的电话号码";
                cell.myTextField.tag=3;
                cell.myTextField.keyboardType = UIKeyboardTypeNumberPad;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
                break;
            default:
                break;
        }
    }
   
    return cell;
}
#pragma pickView
//用于传输数值的方法
-(void)setAreaValue:(NSString *)areaValue
{
    if (![_areaValue isEqualToString:areaValue]) {
        _areaValue = areaValue ;
        Labelbtn.titleLabel.text = areaValue;
    }
}
- (void)viewDidUnload
{
    [self setAreaText:nil];
    [self cancelLocatePicker];
    [super viewDidUnload];
    [self registerForKeyboardNotifications];
    // Release any retained subviews of the main view.
}
-(void)cancelLocatePicker
{
    [self.locatePicker cancelPicker];
    self.locatePicker.delegate = nil;
    self.locatePicker = nil;
}

#pragma mark - HZAreaPicker delegate
-(void)pickerDidChaneStatus:(HZAreaPickerView *)picker
{
    if (picker.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict) {
        
        self.areaValue = [NSString stringWithFormat:@"%@ %@ %@", picker.locate.state, picker.locate.city, picker.locate.district];
        
        NSMutableArray *adressArray= [NSMutableArray array];
        [adressArray addObject:@{@"state":picker.locate.state}];
        [adressArray addObject:@{@"city":picker.locate.city}];
        [adressArray addObject:@{@"district":picker.locate.district}];
    }

}
-(void)pickDidCancel:(HZAreaPickerView *)picker
{
    self.areaValue = [NSString stringWithFormat:@"%@ %@ %@", picker.locate.state, picker.locate.city, picker.locate.district];
    Labelbtn.titleLabel.text =self.areaValue;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
}


- (void)btnAction:(UIButton*)sender{
    
    [self.view endEditing:YES];
    
    if ([sender.titleLabel.text isEqual:Labelbtn.titleLabel.text]) {
        [self cancelLocatePicker];
        self.locatePicker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCityAndDistrict delegate:self];
        Labelbtn.titleLabel.text= AderssIsProv;
        [self.locatePicker showInView:self.view];
    }
    
    [self pickerDidChaneStatus:self.locatePicker];
}

- (void)textFieldWithSKQ:(UITextField *)textField
{
    if (_PYBankflage == YES) {
        
        switch (textField.tag)
        {
            case 0://开户人
            {
                BankName= textField.text;
                
            }
                break;
            case 1:{//手机号码
                 BankPhone= textField.text;
            }
                break;
            case 2:
            {
                BankNum= textField.text;
                
            }
                break;
                
            case 3://
            {
                
                BankList= textField.text;
                
            }
                break;
            default:
                break;
        }

    }else{
        switch (textField.tag)
        {
            case 0://收款人
            {
                NameStr= textField.text;
                
            }
                break;
            case 1:{
                
            }
                break;
            case 2://详细地址 区号在1
            {
                AreaStr= textField.text;
                
            }
                break;
                
            case 3://手机号码
            {
                
                PhoneStr= textField.text;
                
            }
                break;
            default:
                break;
        }

    }
    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [_locatePicker cancelPicker];
    return YES;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, 30);
    
    UIView* view = [[UIView alloc] initWithFrame:rect];
    
    [view setBackgroundColor:[UIColor clearColor]];
    
    rect.origin.x = 10;
    
    rect.origin.y = 0;
    
    rect.size.width = 300;
    
    rect.size.height = 20;
    
    UILabel* label = [[UILabel alloc] initWithFrame:rect];
    
    label.adjustsFontSizeToFitWidth = NO;
    
    label.backgroundColor=[UIColor clearColor];
    
    label.font=[UIFont systemFontOfSize:17];
    
    label.textColor = [UIColor blackColor];
    
    if (0 == section)
    {
        label.text = @"请填写您的基本信息";
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
            
        default:
            break;
    }
    return;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//检查填入的信息是否都符合
-(BOOL)checkData
{
    BOOL check = YES;
    if (_PYBankflage==YES) {
        
        if (BankName.length<1)
        {
            [self showErrorInfo:@"请填写正确的开户人"];
            check = NO;
            return check;
        }
        if (BankNum.length<14)
        {
            [self showErrorInfo:@"请填写正确的银行卡号"];
            check = NO;
            return check;
        }
        if (BankList.length<2)
        {
            [self showErrorInfo:@"请填写正确的开户银行"];
            check = NO;
            return check;
        }
        check =[NLUtils checkMobilePhone:BankPhone];
        
        if (!check)
        {
            [self showErrorInfo:@"请填写正确的手机号码"];
            check = NO;
            return check;
        }
         return check;
    }else{
        check = [NLUtils checkMobilePhone:PhoneStr];
        if (!check)
        {
            [self showErrorInfo:@"请输入正确的手机号码"];
            return check;
        }
        
        if (NameStr.length<1)
        {
            [self showErrorInfo:@"请填写正确的收货人"];
            check = NO;
            return check;
        }
        
        if (AreaStr.length<3)
        {
            [self showErrorInfo:@"请填写您正确的收货地址"];
            check = NO;
            return check;
        }
        
        if (Labelbtn.titleLabel.text.length<2) {
            [self showErrorInfo:@"请滚动选择您的收货区域/或直接输入"];
            check = NO;
            return check;
        }
  
    }
    return check;
}

//输入是否是中文 只能支持一个文字的
-(BOOL)isChinese:(NSString*)c{
    int strlength = 0;
    char* p = (char*)[c cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[c lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return ((strlength/2)==1)?YES:NO;
}


//新增地址接口
-(void)addBuySKQAddress
{
    NSString* name = [NLUtils getNameForRequest:Notify_shaddressAdd];
    REGISTER_NOTIFY_OBSERVER(self, addBuySKQAddressNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] addSKQShaddressProvince:@"" city:@"" county:@"" address:[NSString stringWithFormat:@"%@%@",Labelbtn.titleLabel.text,AreaStr] man:NameStr phone:PhoneStr defaultAdress:[NSString stringWithFormat:@"%@%@",Labelbtn.titleLabel.text,AreaStr]];
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    
}

//刷卡器的读取选项
-(void)addBuySKQAddressNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        
        [self doAddBuySKQAddressNotify:response];
    }
    //超时300
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
-(void)doAddBuySKQAddressNotify:(NLProtocolResponse*)response
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
       //成功
        
        //加一个刷新标记
        [TFData getTempData][ADD_SKQ_ADDRESS_FLAG]=ADD_SKQ_ADDRESS_FLAG;
        
        if ([JumpType isEqualToString:@"finish"] ) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
}

#pragma addressPay

- (void)registerForKeyboardNotifications
{
    [self cancelLocatePicker];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown1:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden1:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardWasShown1:(NSNotification*)noti{
    [self cancelLocatePicker];
}

-(void)keyboardWasHidden1:(id)noti{
     [self cancelLocatePicker];
}

- (void) doPush
{
    [_hud hide:YES];
    [NLUtils popToLogonVCByHTTPError:self feedOrLeft:1];
}

@end
