//
//  WaterEleBillCtr.m
//  TongFubao
//
//  Created by ec on 14-5-29.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "WaterEleBillCtr.h"
#import "WaterEleBillSure.h"

@interface WaterEleBillCtr ()

{
     NLProgressHUD* _hud;
}

@property (nonatomic,strong) NSArray *information;

@property (nonatomic,strong) UIPickerView *companyPickerView;

@property (nonatomic,strong) UIButton *companyBt;

@property (nonatomic,strong) UITextField *customerNum;

@property (nonatomic,strong) NSMutableArray *companyArr;
@property (nonatomic,strong) NSString *sumbitComId;

@property (nonatomic,strong) UIToolbar *toolBar;

@end

@implementation WaterEleBillCtr

-(id)initWithInfor:(NSArray*)infor
{
    if (self = [super init]) {
        if (infor) {
            _information = [NSArray arrayWithArray:infor];
        }else{
            _information = [NSArray array];
        }
    }
    return self;
}

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
    // Do any additional setup after loading the view.
    [self UIInit];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [NLUtils enableSliderViewController:NO];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [NLUtils enableSliderViewController:YES];
}

-(void)UIInit
{
    self.view.backgroundColor = SACOLOR(245, 1.0);
    CGFloat IOS7HEIGHT=IOS7_OR_LATER==YES?64:0;
    
    //数据处理
    
    _companyArr = [NSMutableArray array];
    
    for (NSString *str in _information) {
        NSRange companyRange= [str rangeOfString:@"companyid"];
        NSRange separteRange= [str rangeOfString:@","];
        NSString *companyid = [str substringWithRange:NSMakeRange(companyRange.location+companyRange.length+1, separteRange.location-companyRange.location-companyRange.length-1)];
        NSString *companyStr = [[[str componentsSeparatedByString:@"companyname:"] lastObject] stringByReplacingOccurrencesOfString:@"," withString:@""];
        [_companyArr addObject:@{@"companyid": companyid,@"companyname":companyStr}];
    }

    
    //数据
    _sumbitComId = _companyArr[0][@"companyid"];
    _companyBt = [UIButton buttonWithType:UIButtonTypeCustom];
    _companyBt.frame = CGRectMake(15, 22+IOS7HEIGHT, 290, 44);
    _companyBt.backgroundColor = [UIColor whiteColor];
    [_companyBt setTitle:_companyArr[0][@"companyname"] forState:UIControlStateNormal];
    [_companyBt setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _companyBt.layer.cornerRadius = 5.0;
    _companyBt.layer.borderWidth = 1.0;
    _companyBt.layer.borderColor = SACOLOR(196, 1.0).CGColor;
    [_companyBt addTarget:self action:@selector(clickCompany) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_companyBt];
    
    UIImageView *arrowImg = [[UIImageView alloc]initWithFrame:CGRectMake(265, 14, 15, 15)];
    [arrowImg setImage:[UIImage imageNamed:@"next_page"]];
    [_companyBt addSubview:arrowImg];
    
    //客户编号
    _customerNum = [[UITextField alloc]initWithFrame:CGRectMake(15, 85+IOS7HEIGHT, 290, 44)];
    _customerNum.placeholder = @"请输入客户编号";
    _customerNum.textAlignment = UITextAlignmentCenter;
    _customerNum.layer.cornerRadius = 5;
    _customerNum.layer.borderWidth = 1.0;
    _customerNum.layer.borderColor = SACOLOR(196, 1.0).CGColor;
    _customerNum.backgroundColor = [UIColor whiteColor];
    _customerNum.keyboardType = UIKeyboardTypeNumberPad;
    _customerNum.textColor = [UIColor grayColor];
    [self.view addSubview:_customerNum];

    UIButton *sureBt = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBt addTarget:self action:@selector(clickSure) forControlEvents:UIControlEventTouchUpInside];
    sureBt.frame = CGRectMake(15, 145+IOS7HEIGHT, 290, 44);
    [sureBt setTitle:@"确定" forState:UIControlStateNormal];
    sureBt.titleLabel.font = [UIFont systemFontOfSize:16];
    [sureBt setBackgroundImage:[UIImage imageNamed:@"water_elec_change_btn_normal"] forState:UIControlStateNormal];
    [sureBt setBackgroundImage:[UIImage imageNamed:@"water_elec_change_btn_press"] forState:UIControlStateHighlighted];
    [self.view addSubview:sureBt];

    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickBackView)];
    [self.view addGestureRecognizer:recognizer];
}

-(void)clickCompany
{
    [_customerNum resignFirstResponder];
     CGFloat ctrH = [NLUtils getCtrHeight];
    if (_companyPickerView ==nil) {
        _companyPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, ctrH+44, 320, 216)];
    }
    
    if (self.toolBar==nil) {
            self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, _companyPickerView.frame.origin.y - 44, 320, 44)];
            NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:3];
            UIBarButtonItem *confirmBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(confirmPickView)];
            UIBarButtonItem *flexibleSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            [items addObject:cancelBtn];
            [items addObject:flexibleSpaceItem];
            [items addObject:confirmBtn];
            self.toolBar.hidden = NO;
            self.toolBar.barStyle = UIBarStyleBlackTranslucent;
            self.toolBar.items = items;
        [self.view addSubview:self.toolBar];
    }
   
    _companyPickerView.delegate = self;
   
    [self.view addSubview:_companyPickerView];
    if (_companyPickerView.frame.origin.y==ctrH+44) {
        [UIView transitionWithView:self.view duration:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^void{
            _companyPickerView.frame = CGRectMake(0, ctrH-216, 320, 216);
            self.toolBar.frame = CGRectMake(0, _companyPickerView.frame.origin.y - 44, 320, 44);
        }completion:nil];
    }
}

-(void)confirmPickView
{
    [self hideAllControl];
}

-(void)clickBackView
{
    [self hideAllControl];
}

-(void)hideAllControl
{
    [_customerNum resignFirstResponder];
     CGFloat ctrH = [NLUtils getCtrHeight];
    if (_companyPickerView.frame.origin.y==ctrH-216) {
        [UIView transitionWithView:self.view duration:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^void{
            _companyPickerView.frame = CGRectMake(0, ctrH+44, 320, 216);
            self.toolBar.frame = CGRectMake(0, _companyPickerView.frame.origin.y - 44, 320, 44);
        }completion:nil];
    }
}

#pragma mark

-(BOOL)checkData
{
    if (_customerNum.text.length ==0) {
        [NLUtils showTosatViewWithMessage:@"请输入客户编号" inView:self.view hideAfterDelay:1.0 beIndeter:NO];
        [_customerNum becomeFirstResponder];
        return NO;
    }
    
    if (![NLUtils checkInterNum:_customerNum.text]) {
        [NLUtils showTosatViewWithMessage:@"请输入正确的客户编号" inView:self.view hideAfterDelay:1.0 beIndeter:NO];
        [_customerNum becomeFirstResponder];
        return NO;
    }
    
    return YES;
}

-(void)clickSure
{
    if ([self checkData]) {
        [self hideAllControl];
        
      //账单信息
        [self performSelector:@selector(createOrder) withObject:nil afterDelay:0.1];
    };
}

//创建水电煤订单
-(void)createOrder
{
    NSString* name = [NLUtils getNameForRequest:Notify_waterEle_createOrder];
    REGISTER_NOTIFY_OBSERVER(self, createOrderNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] createWaterEleOrder:_customerNum.text productId:_sumbitComId];
    
     [self showErrorInfo:@"请稍候" status:NLHUDState_None];
}


-(void)createOrderNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self doCreateOrderNotify:response];
        });
        
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

-(void)doCreateOrderNotify:(NLProtocolResponse*)response
{
    NLProtocolData* data = [response.data find:@"msgbody/result" index:0];
    NSString *result = data.value;
    NSRange range = [result rangeOfString:@"succ"];
    if (range.length <= 0)
    {
        NLProtocolData* data = [response.data find:@"msgbody/message" index:0];
        NSString* value = data.value;
        [self showErrorInfo:value status:NLHUDState_Error];
    }else{
        data = [response.data find:@"msgbody/orderid" index:0];
        NSString* orderidStr = data.value;
        data = [response.data find:@"msgbody/username" index:0];
        NSString* usernameStr = data.value;
        data = [response.data find:@"msgbody/factBills" index:0];
        NSString* factBillsStr = data.value;
        data = [response.data find:@"msgbody/totalBill" index:0];
        NSString* totalBillStr = data.value;
        
        dispatch_async(dispatch_get_main_queue(), ^void{
            NSDictionary *billInfo = @{@"companyName":_companyBt.titleLabel.text,@"username":usernameStr,@"factBill":factBillsStr,@"totalBill":totalBillStr,@"orderid":orderidStr};
            WaterEleBillSure *waterEleBillSure = [[WaterEleBillSure alloc]initWithInfor:billInfo];
            waterEleBillSure.title = @"账单信息";
            [self.navigationController pushViewController:waterEleBillSure animated:YES];
        });
    }
}

#pragma mark UIPickerView delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_companyArr count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_companyArr objectAtIndex:row][@"companyname"];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [_companyBt setTitle: [NSString stringWithFormat:@"%@",[_companyArr objectAtIndex:row][@"companyname"]]forState:UIControlStateNormal];
    _sumbitComId = [_companyArr objectAtIndex:row][@"companyid"];
}

//超时
- (void) doPush
{
    [_hud hide:YES];
    [NLUtils popToLogonVCByHTTPError:self feedOrLeft:1];
    
}

#pragma showErrorInfo
//判断信息是否正确
-(void)showErrorInfo:(NSString*)detail status:(NLHUDState)status
{
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
