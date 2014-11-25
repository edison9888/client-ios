//
//  GameDetailInfoChoiceCtr.m
//  TongFubao
//
//  Created by ec on 14-6-10.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "GameDetailInfoChoiceCtr.h"
#import "GameChargeBill.h"

#define NUMPICKER_TAG 101
#define AREAPICKER_TAG 102
#define SERVERPICKER_TAG 103

@interface GameDetailInfoChoiceCtr ()

{
    CGFloat IOS7HEIGHT;
    NLProgressHUD* _hud;
}

@property (nonatomic,strong) UILabel *categoryText;
@property (nonatomic,strong) UILabel *perPriceText;
@property (nonatomic,strong) UITextField *numTextField;
@property (nonatomic,strong) UITextField *areaTextField;
@property (nonatomic,strong) UITextField *serverTextField;
@property (nonatomic,strong) UITextField *accountField;

@property (nonatomic,strong) NSDictionary *information;
@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,strong) UIPickerView *gameDetailPickerView;
@property (nonatomic,strong) UIToolbar *toolBar;

@property (nonatomic,assign) NSInteger selectRow;


//@"gameId":gameIdStr,@"gameName":gameNameStr,@"price"

@end

@implementation GameDetailInfoChoiceCtr

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithInfor:(NSDictionary*)infor
{
    if (self = [super init]) {
        if (infor) {
            _information = [NSDictionary dictionaryWithDictionary:infor];
        }else{
            _information = [NSDictionary dictionary];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self UIInit];
    [self performSelector:@selector(getDetailData) withObject:nil afterDelay:0.1];
}

-(void)UIInit
{
    //加一层 背景 防止整体向上滚的时候部分黑色
    UIView *bigV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 800)];
    bigV.backgroundColor = RGBACOLOR(239, 244, 245, 1.0);
    [self.view addSubview:bigV];

    
    _dataArr = [NSMutableArray array];
    
    self.view.backgroundColor = RGBACOLOR(239, 244, 245, 1.0);
    IOS7HEIGHT=IOS7_OR_LATER==YES?64:0;
    
    UILabel *category = [[UILabel alloc]initWithFrame:CGRectMake(14, IOS7HEIGHT+24, 45, 20)];
    category.textColor = [UIColor grayColor];
    category.font = [UIFont systemFontOfSize:14];
    category.backgroundColor = [UIColor clearColor];
    category.text = @"类别：";
    [self.view addSubview:category];
    
    _categoryText = [[UILabel alloc]initWithFrame:CGRectMake(74, IOS7HEIGHT+24, 220, 20)];
    _categoryText.textColor = [UIColor grayColor];
    _categoryText.font = [UIFont systemFontOfSize:14];
    _categoryText.backgroundColor = [UIColor clearColor];
    _categoryText.text = _information[@"gameName"];
    [self.view addSubview:_categoryText];
    
    UILabel *perPrice = [[UILabel alloc]initWithFrame:CGRectMake(14, IOS7HEIGHT+62, 45, 20)];
    perPrice.textColor = [UIColor grayColor];
    perPrice.font = [UIFont systemFontOfSize:14];
    perPrice.backgroundColor = [UIColor clearColor];
    perPrice.text = @"单价：";
    [self.view addSubview:perPrice];
    
    _perPriceText = [[UILabel alloc]initWithFrame:CGRectMake(74, IOS7HEIGHT+62, 220, 20)];
    _perPriceText.textColor = RGBACOLOR(250, 160, 12, 1.0);
    _perPriceText.font = [UIFont systemFontOfSize:14];
    _perPriceText.backgroundColor = [UIColor clearColor];
    _perPriceText.text = [NSString stringWithFormat:@"￥%@",_information[@"price"]];
    [self.view addSubview:_perPriceText];
    
    UILabel *num = [[UILabel alloc]initWithFrame:CGRectMake(14, IOS7HEIGHT+100, 45, 20)];
    num.textColor = [UIColor grayColor];
    num.font = [UIFont systemFontOfSize:14];
    num.backgroundColor = [UIColor clearColor];
    num.text = @"数量：";
    [self.view addSubview:num];
    
    //输入数量
    UIImageView *numInputBg = [[UIImageView alloc]initWithFrame:CGRectMake(74, IOS7HEIGHT+90, 225, 40)];
    numInputBg.userInteractionEnabled = YES;
    [numInputBg setImage:[[UIImage imageNamed:@"input_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(6, 4, 6, 4) resizingMode:UIImageResizingModeStretch]];
    [self.view addSubview:numInputBg];
    
    _numTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, 165, 40)];
    _numTextField.text = @"1";
    _numTextField.userInteractionEnabled = NO;
    _numTextField.textColor = [UIColor grayColor];
    [numInputBg addSubview:_numTextField];
    
    UIImageView *arrowImg = [[UIImageView alloc]initWithFrame:CGRectMake(185, 5, 30, 30)];
    [arrowImg setImage:[UIImage imageNamed:@"down_gray_arrow"]];
    [numInputBg addSubview:arrowImg];
    
    UIButton *numBt = [UIButton buttonWithType:UIButtonTypeCustom];
    numBt.tag = NUMPICKER_TAG;
    numBt.frame = CGRectMake(0, 0, 225, 40);
    [numBt addTarget:self action:@selector(clickPicker:) forControlEvents:UIControlEventTouchUpInside];
    [numInputBg addSubview:numBt];
    
    //分割线
    UIImageView *lineA = [[UIImageView alloc]initWithFrame:CGRectMake(17, IOS7HEIGHT+150, 286,2)];
    [lineA setImage:[UIImage imageNamed:@"dashed_line"]];
    [self.view addSubview:lineA];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickBackView)];
    [self.view addGestureRecognizer:recognizer];
}

#pragma mark
-(void)clickPicker:(UIButton *)sender
{
     [_accountField resignFirstResponder];
    
    _gameDetailPickerView.hidden = NO;
    _toolBar.hidden = NO;
    
    CGFloat ctrH = [NLUtils getCtrHeight];
    if (_gameDetailPickerView ==nil) {
        _gameDetailPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, ctrH+44, 320, 216)];\
        _gameDetailPickerView.backgroundColor = RGBACOLOR(239, 244, 245, 1.0);
    }
    
    _gameDetailPickerView.tag = sender.tag;
    _gameDetailPickerView.delegate = self;
    
    if (self.toolBar==nil) {
        self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, _gameDetailPickerView.frame.origin.y - 44, 320, 44)];
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
    
    [self.view addSubview:_gameDetailPickerView];
    
    if (_gameDetailPickerView.frame.origin.y==ctrH+44) {
        [UIView transitionWithView:self.view duration:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^void{
            _gameDetailPickerView.frame = CGRectMake(0, ctrH-216, 320, 216);
            self.toolBar.frame = CGRectMake(0, _gameDetailPickerView.frame.origin.y - 44, 320, 44);
        }completion:nil];
    }
}

-(void)confirmPickView
{
    [self hideAllControl];
}

-(void)clickBackView
{
    [_accountField resignFirstResponder];
    [self hideAllControl];
}

-(void)hideAllControl
{
    CGFloat ctrH = [NLUtils getCtrHeight];
    if (_gameDetailPickerView.frame.origin.y==ctrH-216) {
        [UIView transitionWithView:self.view duration:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^void{
            _gameDetailPickerView.frame = CGRectMake(0, ctrH+44, 320, 216);
            self.toolBar.frame = CGRectMake(0, _gameDetailPickerView.frame.origin.y - 44, 320, 44);
        }completion:^(BOOL finished){
            _gameDetailPickerView.hidden = YES;
            _toolBar.hidden = YES;
        }];
    }
}

#pragma mark UIPickerView delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == NUMPICKER_TAG) {
        return 10;
    }
    if (pickerView.tag == AREAPICKER_TAG) {
        return _dataArr.count;
    }
    if (pickerView.tag == SERVERPICKER_TAG) {
        return [_dataArr[_selectRow][@"server"] count];
    }
    
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == NUMPICKER_TAG) {
        return [NSString stringWithFormat:@"%d",row+1];
    }
    if (pickerView.tag == AREAPICKER_TAG) {
        return [NSString stringWithFormat:@"%@",_dataArr[row][@"area"]];
    }
    if (pickerView.tag == SERVERPICKER_TAG) {
        return [NSString stringWithFormat:@"%@",_dataArr[_selectRow][@"server"][row]];
    }
    return @"";
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag == NUMPICKER_TAG) {
        _numTextField.text = [NSString stringWithFormat:@"%d",row+1];
    }
    if (pickerView.tag == AREAPICKER_TAG) {
        _areaTextField.text = [NSString stringWithFormat:@"%@",_dataArr[row][@"area"]];
        _selectRow = row;
        
        if ([_dataArr[row][@"server"] count]>0) {
        _serverTextField.text = [NSString stringWithFormat:@"%@",_dataArr[row][@"server"][0]];
        }

    }
    if (pickerView.tag == SERVERPICKER_TAG) {
        _serverTextField.text = [NSString stringWithFormat:@"%@",_dataArr[_selectRow][@"server"][row]];
    }
}


#pragma mark

-(void)getDetailData
{
    NSString* name = [NLUtils getNameForRequest:Notify_gameCharge_getGameDetail];
    REGISTER_NOTIFY_OBSERVER(self, getGameDetailNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] getGameChargeGameDetail:_information[@"gameId"]];
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
}

-(void)getGameDetailNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        
        [self doGetGameDetailNotify:response];
        
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
            detail = @"请求失败，请检查网络";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

-(void)doGetGameDetailNotify:(NLProtocolResponse*)response
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
        
        NSArray *areaArr = [response.data find:@"msgbody/msgchild/area"];
        NSArray *serverArr = [response.data find:@"msgbody/msgchild/server"];
        
        NSString *areaStr = nil;
        NSString *serverStr = nil;
  
        for (int i = 0 ; i<areaArr.count; i++) {
            
            NLProtocolData* data = [areaArr objectAtIndex:i];
            areaStr = data.value;
            data = [serverArr objectAtIndex:i];
            serverStr = data.value;
            
            if (serverStr.length>0) {
                NSArray *area_serverArr = [serverStr componentsSeparatedByString:@"#"];
                [_dataArr addObject:@{@"area":areaStr,@"server":area_serverArr}];
            }else{
                [_dataArr addObject:@{@"area":areaStr,@"server":[NSArray array]}];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^void {
           // 更新ui
            [self updateUI];
        });
    }
}

-(void)updateUI
{
    //区
    if (_dataArr.count>0) {
        
        UIImageView *areaInputBg = [[UIImageView alloc]initWithFrame:CGRectMake(15, IOS7HEIGHT+174, 290, 40)];
        areaInputBg.userInteractionEnabled = YES;
        [areaInputBg setImage:[[UIImage imageNamed:@"input_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(6, 4, 6, 4) resizingMode:UIImageResizingModeStretch]];
        [self.view addSubview:areaInputBg];
        
        _areaTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, 240, 40)];
        _areaTextField.text = _dataArr[0][@"area"];
        _areaTextField.userInteractionEnabled = NO;
        _areaTextField.textColor = [UIColor grayColor];
        [areaInputBg addSubview:_areaTextField];
        
        UIImageView *arrowImg = [[UIImageView alloc]initWithFrame:CGRectMake(229, 5, 30, 30)];
        [arrowImg setImage:[UIImage imageNamed:@"down_gray_arrow"]];
        [areaInputBg addSubview:arrowImg];
        
        UIButton *areaBt = [UIButton buttonWithType:UIButtonTypeCustom];
        areaBt.frame = CGRectMake(0 , 0, 290, 40);
        areaBt.tag = AREAPICKER_TAG;
        [areaBt addTarget:self action:@selector(clickPicker:) forControlEvents:UIControlEventTouchUpInside];
        [areaInputBg addSubview:areaBt];
        
        BOOL hasServer = NO;
        if ([_dataArr[0][@"server"] count]>0) {
            hasServer = YES;
        }
        
        if (hasServer) {
            //服
            UIImageView *locationInputBg = [[UIImageView alloc]initWithFrame:CGRectMake(15, IOS7HEIGHT+236, 290, 40)];
            locationInputBg.userInteractionEnabled = YES;
            [locationInputBg setImage:[[UIImage imageNamed:@"input_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(6, 4, 6, 4) resizingMode:UIImageResizingModeStretch]];
            [self.view addSubview:locationInputBg];
            
            _serverTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, 240, 40)];
            _serverTextField.text = _dataArr[0][@"server"][0];
            _serverTextField.userInteractionEnabled = NO;
            _serverTextField.textColor = [UIColor grayColor];
            [locationInputBg addSubview:_serverTextField];
            
            UIImageView *arrowImg = [[UIImageView alloc]initWithFrame:CGRectMake(229, 5, 30, 30)];
            [arrowImg setImage:[UIImage imageNamed:@"down_gray_arrow"]];
            [locationInputBg addSubview:arrowImg];

            UIButton *locationBt = [UIButton buttonWithType:UIButtonTypeCustom];
            locationBt.frame = CGRectMake(0 , 0, 290, 40);
            [locationInputBg addSubview:locationBt];
            locationBt.tag = SERVERPICKER_TAG;

            [locationBt addTarget:self action:@selector(clickPicker:) forControlEvents:UIControlEventTouchUpInside];
            [locationInputBg addSubview:locationBt];
        }
        
        if (hasServer) {
            UIImageView *accountInputBg = [[UIImageView alloc]initWithFrame:CGRectMake(15, IOS7HEIGHT+298, 290, 40)];
            accountInputBg.userInteractionEnabled = YES;
            [accountInputBg setImage:[[UIImage imageNamed:@"input_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(6, 4, 6, 4) resizingMode:UIImageResizingModeStretch]];
            [self.view addSubview:accountInputBg];
            
            _accountField = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, 270, 40)];
            _accountField.delegate = self;
            _accountField.textColor = [UIColor grayColor];
            _accountField.placeholder = @"请输入游戏账号";
            [accountInputBg addSubview:_accountField];
            
        }else{
            UIImageView *accountInputBg = [[UIImageView alloc]initWithFrame:CGRectMake(15, IOS7HEIGHT+236, 290, 40)];
            accountInputBg.userInteractionEnabled = YES;
            [accountInputBg setImage:[[UIImage imageNamed:@"input_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(6, 4, 6, 4) resizingMode:UIImageResizingModeStretch]];
            [self.view addSubview:accountInputBg];
            
            _accountField = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, 270, 40)];
            _accountField.delegate = self;
            _accountField.textColor = [UIColor grayColor];
            _accountField.placeholder = @"请输入游戏账号";
            [accountInputBg addSubview:_accountField];
        }
    }else{
        
        UIImageView *accountInputBg = [[UIImageView alloc]initWithFrame:CGRectMake(15, IOS7HEIGHT+174, 290, 40)];
        accountInputBg.userInteractionEnabled = YES;
        [accountInputBg setImage:[[UIImage imageNamed:@"input_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(6, 4, 6, 4) resizingMode:UIImageResizingModeStretch]];
        [self.view addSubview:accountInputBg];
        
        _accountField = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, 270, 40)];
        _accountField.delegate = self;
        _accountField.textColor = [UIColor grayColor];
        _accountField.placeholder = @"请输入游戏账号";
        [accountInputBg addSubview:_accountField];
    }
    
    UIButton *sureBt = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBt addTarget:self action:@selector(clickSure) forControlEvents:UIControlEventTouchUpInside];
    sureBt.frame = CGRectMake(15, [_accountField superview].frame.origin.y+62, 290, 44);
    [sureBt setTitle:@"立即充值" forState:UIControlStateNormal];
    sureBt.titleLabel.font = [UIFont systemFontOfSize:16];
    [sureBt setBackgroundImage:[UIImage imageNamed:@"water_elec_change_btn_normal"] forState:UIControlStateNormal];
    [sureBt setBackgroundImage:[UIImage imageNamed:@"water_elec_change_btn_press"] forState:UIControlStateHighlighted];
    [self.view addSubview:sureBt];

}

-(void)clickSure
{
    if ([self checkData]) {
        
        [self clickBackView];
        
        NSMutableDictionary *chargeDic = [NSMutableDictionary dictionary];
        chargeDic[@"gameName"] = _information[@"gameName"];
        chargeDic[@"gameId"] = _information[@"gameId"];
        chargeDic[@"cost"]= _information[@"cost"];
        
        if (_areaTextField.text.length>0) {
            chargeDic[@"area"] = _areaTextField.text;
        }
        if (_serverTextField.text.length>0) {
            chargeDic[@"server"] = _serverTextField.text;
        }
        
        chargeDic[@"quantity"] = _numTextField.text;
        chargeDic[@"price"] = _information[@"price"];
        chargeDic[@"userCount"] = _accountField.text;
        
       GameChargeBill *gameChargeBill = [[GameChargeBill alloc]initWithInfor:chargeDic];
       [self.navigationController pushViewController:gameChargeBill animated:YES];
    }
}

-(BOOL)checkData
{
    if (_accountField.text.length==0) {
        [NLUtils showTosatViewWithMessage:@"请输入账号" inView:self.view hideAfterDelay:1.0 beIndeter:NO];
        return NO;
    }
    return YES;
}

#pragma mark -textfieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self performSelector:@selector(change:) withObject:nil];
}

#pragma mark 键盘移动

- (void)change:(id)sender
{
    //创建一个仿射变换
    CGFloat offSetY = [_accountField superview].frame.origin.y;
    
    CGAffineTransform pTransform = CGAffineTransformMakeTranslation(0, -offSetY+90-IOS7HEIGHT);
    if ([NLUtils isIphone5]) {
        pTransform = CGAffineTransformMakeTranslation(0, -100-IOS7HEIGHT);
    }
    
    //使视图使用这个变换
    [UIView
     transitionWithView:self.view
     duration:0.5
     options:UIViewAnimationOptionCurveEaseInOut
     animations:^(void) {
         self.view.transform = pTransform;
     }
     completion:nil];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //使视图回到原来的位置
    CGAffineTransform pTransform = CGAffineTransformMakeTranslation(0, 0);
    //使视图使用这个变换
    [UIView
     transitionWithView:self.view
     duration:0.5
     options:UIViewAnimationOptionCurveEaseInOut
     animations:^(void) {
         self.view.transform = pTransform;
     }
     completion:nil];
    
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
