//
//  ApplyAgentViewController.m
//  TongFubao
//
//  Created by Delpan on 14-7-21.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "ApplyAgentViewController.h"
#import "MaterialLabel.h"

@interface ApplyAgentViewController ()
{
    NLProgressHUD *_hud;
    
    NSInteger currentHeight;
    //滑动底图
    UIScrollView *basicView;
    //姓名，手机号，区域代号输入框
    UITextField *basicText[3];
    //地区按扭
    UIButton *areaButton[3];
    //自定义地区
    UITextField *customText;
    //材料证明视图
    UIButton *materialBtn;
    //地区选择视图
    AreaSelectView *areaView;
    //代理商省
    NSArray *provs;
    //代理商市
    NSArray *citys;
    //代理商区
    NSArray *towns;
    //当前地区按扭
    UIButton *currentButton;
    //资质图片
    UIImage *materialImage;
    //已添加图片
    UIImage *didImage;
    //
    UIView *materialView[3];
    //详细底图
    UIView *moreView;
    //确定或重置
    UIButton *enterBtn[2];
    //
    NSArray *custypeids;
    //
    NSString *currentCustypeid;
    //
    NSArray *custypenames;
    //
    UIActionSheet *actionSheet;
    //
    NSArray *pictypenames;
}

@end


@implementation ApplyAgentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    
    ViewControllerProperty;
    
#endif
    
    self.title = @"正式申请";
    
    //获取当前屏幕size
    currentHeight = iphoneSize;
    
    [self addBackButtonItemWithImage:imageName(@"navigationLeftBtnBack2@2x", @"png")];
    
    //资质图片
    materialImage = imageName(@"camera_icon@2x", @"png");
    //已添加图片
    didImage = imageName(@"done_icon@2x", @"png");
    
    //代理商省请求
    [self loadDataWithProv];
    
    //代理商性质请求
    [self loadDataWithAgentInfo];
    
    //滑动视图
    [self initScrollView];
    
    //基本信息视图
    [self initBasicView];
    
    //地区视图
    [self initAreaView];
}

#pragma mark - 滑动视图
- (void)initScrollView
{
    basicView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SelfWidth, currentHeight - 20)];
    basicView.backgroundColor = [UIColor whiteColor];
    basicView.contentSize = CGSizeMake(SelfWidth, currentHeight + 32);
    [self.view addSubview:basicView];
}

#pragma mark - 基本信息视图
- (void)initBasicView
{
    //输入框提标
    NSString *textPlaceholder = nil;
    //文本名称
    NSString *labelName = nil;
    
    //姓名，手机号，区域代号
    for (int i = 0; i < 3; i++)
    {
        textPlaceholder = (i == 0? @"请输入您的名字" : i == 1? @"请输入您的手机号码" : @"请输入您想申请的号码");
        labelName = (i == 0? @"名       称" : i == 1? @"手机号码" : @"区域代号");
        
        //文本
        UILabel *basicLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10 + 40 * i, SelfWidth / 4 - 10, 35)];
        basicLabel.opaque = YES;
        basicLabel.backgroundColor = [UIColor clearColor];
        basicLabel.textColor = [UIColor blackColor];
        basicLabel.textAlignment = NSTextAlignmentLeft;
        basicLabel.text = labelName;
        basicLabel.font = [UIFont systemFontOfSize:15.0];
        [basicView addSubview:basicLabel];
        
        //输入框
        basicText[i] = [[UITextField alloc] initWithFrame:CGRectMake(SelfWidth / 4, 20 + 40 * i, SelfWidth / 4 * 3 - 10, 35)];
        basicText[i].opaque = YES;
        basicText[i].returnKeyType = UIReturnKeyDone;
        basicText[i].delegate = self;
//        basicText[i].borderStyle = UITextBorderStyleRoundedRect;
        basicText[i].placeholder = textPlaceholder;
        [basicView addSubview:basicText[i]];
        
        if (i > 0)
        {
            basicText[i].keyboardType = UIKeyboardTypeNumberPad;
        }
    }
}

#pragma mark - 地区视图
- (void)initAreaView
{
    //合同意向地区
    UILabel *areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 145, 310, 20)];
    areaLabel.opaque = YES;
    areaLabel.backgroundColor = [UIColor clearColor];
    areaLabel.textColor = [UIColor blackColor];
    areaLabel.textAlignment = NSTextAlignmentLeft;
    areaLabel.text = @"合同意向地区";
    areaLabel.font = [UIFont systemFontOfSize:20.0];
    [basicView addSubview:areaLabel];
    
    //按扭名称
    NSString *btnName = nil;
    
    //地区按扭
    for (int i = 0; i < 3; i++)
    {
        btnName = (i == 0? @"省" : i == 1? @"市" : @"区/县");
        
        areaButton[i] = [UIButton buttonWithType:UIButtonTypeCustom];
        areaButton[i].opaque = YES;
        areaButton[i].tag = 2101 + i;
        areaButton[i].frame = CGRectMake(15 + 100 * i, 175, 90, 35);
        [areaButton[i] setBackgroundImage:imageName(@"next_press@2x", @"png") forState:UIControlStateNormal];
        [areaButton[i] setTitle:btnName forState:UIControlStateNormal];
        [areaButton[i] setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [areaButton[i] addTarget:self action:@selector(areaBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [basicView addSubview:areaButton[i]];
    }
    
    //自定义地区输入
    customText = [[UITextField alloc] initWithFrame:CGRectMake(15, 225, 290, 35)];
    customText.opaque = YES;
    customText.returnKeyType = UIReturnKeyDone;
    customText.delegate = self;
    customText.placeholder = @"输入您申请的地区";
    [basicView addSubview:customText];
    
    //资质证明材料
    UILabel *materialLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 270, 150, 20)];
    materialLabel.opaque = YES;
    materialLabel.backgroundColor = [UIColor clearColor];
    materialLabel.textColor = [UIColor blackColor];
    materialLabel.textAlignment = NSTextAlignmentLeft;
    materialLabel.text = @"资质证明材料";
    materialLabel.font = [UIFont systemFontOfSize:20.0];
    [basicView addSubview:materialLabel];
}

#pragma mark - 材料证明视图
- (void)initMaterialView
{
    moreView = [[UIView alloc] initWithFrame:CGRectMake(10, 300, 300, 235)];
    moreView.backgroundColor = [UIColor clearColor];
    [basicView addSubview:moreView];
    
    //代理商性质
    materialBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    materialBtn.opaque = YES;
    materialBtn.frame = CGRectMake(0, 0, 300, 35);
    [materialBtn setTitle:@"公司" forState:UIControlStateNormal];
    [materialBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [materialBtn setBackgroundImage:imageName(@"next_press@2x", @"png") forState:UIControlStateNormal];
    [materialBtn addTarget:self action:@selector(materialBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [moreView addSubview:materialBtn];
    
    //代理商申请资料
    NSString *materialLabelText = nil;
    
    for (int i = 0, k = 0; i < 3; i++)
    {
        materialView[i] = [[UIView alloc] initWithFrame:CGRectMake(0, 45, SelfWidth - 20, 190)];
        materialView[i].backgroundColor = [UIColor clearColor];
        [moreView addSubview:materialView[i]];
        
        for (int j = 0; j < 4; j++)
        {
            if (i == 1)
            {
                if (j == 3)
                {
                    continue ;
                }
            }
            else if (i == 2)
            {
                if (j > 0)
                {
                    continue ;
                }
            }
            
            NLProtocolData *data = pictypenames[k];
            materialLabelText = data.value;
            
            MaterialLabel *materialLabel = [[MaterialLabel alloc]initWithFrame:CGRectMake(0, 2.5 + 45 * j, SelfWidth - 20, 45)];
            materialLabel.text = materialLabelText;
            materialLabel.font = [UIFont systemFontOfSize:20.0];
            materialLabel.imageBtn.tag = 2301 + k;
            [materialLabel.imageBtn setBackgroundImage:materialImage forState:UIControlStateNormal];
            [materialLabel.imageBtn addTarget:self action:@selector(imageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [materialView[i] addSubview:materialLabel];
            
            k++;
        }
        
        if (i > 0)
        {
            materialView[i].hidden = YES;
        }
    }
    
    //确定或重设按扭名称
    NSString *btnName = nil;
    
    for (int i = 0; i < 2; i++)
    {
        btnName = (i == 0? @"提交" : @"重置");
        
        enterBtn[i] = [UIButton buttonWithType:UIButtonTypeCustom];
        enterBtn[i].opaque = YES;
        enterBtn[i].tag = 2201 + i;
        enterBtn[i].frame = CGRectMake(10 + 160 * i, moreView.frame.origin.y + moreView.frame.size.height + 10, 140, 35);
        [enterBtn[i] setTitle:btnName forState:UIControlStateNormal];
        [enterBtn[i] setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [enterBtn[i] setBackgroundImage:imageName(@"yellow_button@2x", @"png") forState:UIControlStateNormal];
        [enterBtn[i] addTarget:self action:@selector(enterBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [basicView addSubview:enterBtn[i]];
    }
}

#pragma mark - 地区选择
- (void)areaBtnAction:(UIButton *)sender
{
    if (!areaView)
    {
        areaView = [[AreaSelectView alloc] initWithFrame:basicView.frame];
        areaView.alpha = 0.0;
        areaView.areaSelectViewDelegate = self;
        areaView.backgroundColor = [UIColor clearColor];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        areaView.alpha = 1.0;
    }];
    
    [basicView addSubview:areaView];
    
    currentButton = sender;
    
    switch (sender.tag)
    {
        case 2101:
        {
            [areaView loadDataWith:provs button:sender dictionary:NO NLData:YES];
        }
            break;
            
        case 2102:
        {
            if (citys)
            {
                [areaView loadDataWith:citys button:sender dictionary:NO NLData:YES];
            }
        }
            break;
            
        case 2103:
        {
            if (towns)
            {
                [areaView loadDataWith:towns button:sender dictionary:NO NLData:YES];
            }
        }
            break;
    }
}

#pragma mark - 提交或重置
- (void)enterBtnAction:(UIButton *)sender
{
    //提交
    if (sender.tag == 2201)
    {
        [self loadDataWith:currentCustypeid name:basicText[0].text address:customText.text prov:[areaButton[0] titleForState:UIControlStateNormal] city:[areaButton[1] titleForState:UIControlStateNormal] town:[areaButton[2] titleForState:UIControlStateNormal]];
    }
    else
    {
        //重置
        for (int i = 0; i < 4; i++)
        {
            if (i < 3)
            {
                NSString *text = (i == 0? @"省" : i == 1? @"市" : @"区/县");
                
                basicText[i].text = @"";
                customText.text = @"";
                [areaButton[i] setTitle:text forState:UIControlStateNormal];
            }
        }
    }
}

#pragma mark - 代理商性质选择
- (void)materialBtnAction:(UIButton *)sender
{
    if (!actionSheet)
    {
        NSString *actionString = @"取消";
        
        if (custypenames)
        {
            NLProtocolData *data_1 = custypenames[0];
            NLProtocolData *data_2 = custypenames[1];
            NLProtocolData *data_3 = custypenames[2];
            
            actionString = nil;
            
            actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:actionString destructiveButtonTitle:nil otherButtonTitles:data_1.value, data_2.value, data_3.value, nil];
        }
    }
    
    [actionSheet showInView:self.view];
}

#pragma mark - ActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    for (int i = 0; i < 3; i++)
    {
        materialView[i].hidden = YES;
    }
    
    materialView[buttonIndex].hidden = NO;
    
    //设置代理商性质
    NLProtocolData *dataBtn = custypenames[buttonIndex];
    NLProtocolData *dataId = custypeids[buttonIndex];
    
    [materialBtn setTitle:dataBtn.value forState:UIControlStateNormal];
    currentCustypeid = dataId.value;
}

#pragma mark - 资料证明触发
- (void)imageBtnAction:(UIButton *)sender
{
    NSLog(@"添加资料");
}

#pragma mark - TextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL retValue = YES;
    
    if (textField == basicText[2])
    {
        if([[textField text] length] - range.length + string.length > 6)
        {
            retValue = NO;
        }
    }
    
    return retValue;
}

#pragma mark - 获取地区省
- (void)loadDataWithProv
{
    NSString *name = [NLUtils getNameForRequest:Notify_ApiAgentApplyProv];
    REGISTER_NOTIFY_OBSERVER(self, getApiAgentApplyNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApiAgentApplyWithProv];
}

#pragma mark - 获取地区市
- (void)loadDataWithProv:(NSString *)prov
{
    NSString *name = [NLUtils getNameForRequest:Notify_ApiAgentApplyCity];
    REGISTER_NOTIFY_OBSERVER(self, getApiAgentApplyNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApiAgentApplyWithProv:prov];
}

#pragma mark - 获取地区区
- (void)loadDataWithProv:(NSString *)prov city:(NSString *)city
{
    NSString *name = [NLUtils getNameForRequest:Notify_ApiAgentApplyTown];
    REGISTER_NOTIFY_OBSERVER(self, getApiAgentApplyNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApiAgentApplyWithProv:prov city:city];
}

#pragma mark - 获取地区判断
- (void)getApiAgentApplyNotify:(NSNotification *)notify
{
    NLProtocolResponse *response = (NLProtocolResponse *)notify.object;
    int error = response.errcode;
    
    if (error == RSP_NO_ERROR)
    {
        [self didGetApiAgentApplyNotify:response];
    }
    else if (error == RSP_TIMEOUT)
    {
        return ;
    }
    else
    {
        NSString *string = response.detail;
        NSLog(@"string = %@",string);
    }
}

#pragma mark - 处理地区数据
- (void)didGetApiAgentApplyNotify:(NLProtocolResponse *)response
{
    //获取数据标记，判断是否请求成功
    NLProtocolData *data = [response.data find:@"msgbody/result" index:0];
    NSString *result = data.value;
    
    NSRange range = [result rangeOfString:@"succ"];
    
    if (range.length <= 0)
    {
        //获取错误信息
        NLProtocolData *errorData = [response.data find:@"msgbody/message" index:0];
        
        NSLog(@"errorData = %@",errorData);
    }
    else
    {
        //获取省
        if (!provs)
        {
            provs = [response.data find:@"msgbody/msgchild/prov"];
        }
        
        //获取市
        if (currentButton == areaButton[0])
        {
            citys = [response.data find:@"msgbody/msgchild/city"];
        }
        
        //获取区
        if (currentButton == areaButton[1])
        {
            towns = [response.data find:@"msgbody/msgchild/town"];
        }
    }
}

#pragma mark - 创建代理商信息
- (void)loadDataWithAgentInfo
{
    NSString *name = [NLUtils getNameForRequest:Notify_ApiAgentApplyBasinfo];
    REGISTER_NOTIFY_OBSERVER(self, cheakApiAgentApplyNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApiAgentApply];
}

#pragma mark - 判断代理商信息
- (void)cheakApiAgentApplyNotify:(NSNotification *)notify
{
    NLProtocolResponse *response = (NLProtocolResponse *)notify.object;
    int error = response.errcode;
    
    if (error == RSP_NO_ERROR)
    {
        [self didLoadApiAgentApplyNotify:response];
    }
    else if (error == RSP_TIMEOUT)
    {
        return ;
    }
    else
    {
        NSString *string = response.detail;
        NSLog(@"string = %@",string);
    }
}

#pragma mark - 处理代理商信息
- (void)didLoadApiAgentApplyNotify:(NLProtocolResponse *)response
{
    //获取数据标记，判断是否请求成功
    NLProtocolData *data = [response.data find:@"msgbody/result" index:0];
    NSString *result = data.value;
    
    NSRange range = [result rangeOfString:@"succ"];
    
    if (range.length <= 0)
    {
        //获取错误信息
        NLProtocolData *errorData = [response.data find:@"msgbody/message" index:0];
        
        NSLog(@"errorData = %@",errorData);
    }
    else
    {
        //代理商类型ID
        custypeids = [response.data find:@"msgbody/msgchild/custypeid"];
        
        NLProtocolData *da = custypeids[0];
        currentCustypeid = da.value;
        
        //代理商类型名称
        custypenames = [response.data find:@"msgbody/msgchild/custypename"];
        
        //资料名称
        pictypenames = [response.data find:@"msgbody/msgchild/msgfile/msgchild/pictypename"];
        
        [self initMaterialView];
    }
}

#pragma mark - areaViewDelegate
- (void)areaChange:(BOOL)change btn:(UIButton *)btn
{
    //下级数据
    if (change)
    {
        NSString *name = [currentButton titleForState:UIControlStateNormal];
        
        if (currentButton == areaButton[0])
        {
            [self loadDataWithProv:name];
        }
        if (currentButton == areaButton[1])
        {
            NSString *provName = [areaButton[0] titleForState:UIControlStateNormal];
            
            [self loadDataWithProv:provName city:name];
        }
    }
}

#pragma mark - 代理商申请
- (void)loadDataWith:(NSString *)custypeid name:(NSString *)name address:(NSString *)address prov:(NSString *)prov city:(NSString *)city town:(NSString *)town
{
    NSString *name_ = [NLUtils getNameForRequest:Notify_ApiAgentApplyAdd];
    REGISTER_NOTIFY_OBSERVER(self, cheakApiAgentApplyAddNotify, name_);
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApiAgentApplyAddWith:custypeid name:name address:address prov:prov city:city town:town];
}

- (void)cheakApiAgentApplyAddNotify:(NSNotification *)notify
{
    NLProtocolResponse *response = (NLProtocolResponse *)notify.object;
    int error = response.errcode;
    
    if (error == RSP_NO_ERROR)
    {
        [self didLoadApiAgentApplyAddNotify:response];
    }
    else if (error == RSP_TIMEOUT)
    {
        return ;
    }
    else
    {
        NSString *string = response.detail;
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提    示" message:string delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
        NSLog(@"string = %@",string);
    }
}

- (void)didLoadApiAgentApplyAddNotify:(NLProtocolResponse *)response
{
    //获取数据标记，判断是否请求成功
    NLProtocolData *data = [response.data find:@"msgbody/result" index:0];
    NSString *result = data.value;
    
    NSRange range = [result rangeOfString:@"succ"];
    
    if (range.length <= 0)
    {
        //获取错误信息
        NLProtocolData *errorData = [response.data find:@"msgbody/message" index:0];
        
        NSLog(@"errorData = %@",errorData);
    }
    else
    {
        [self showErrorInfo:@"正在申请" status:NLHUDState_NoError];
        
        [self performSelector:@selector(popView) withObject:nil afterDelay:0.5];
    }
}

- (void)popView
{
    [self.navigationController popViewControllerAnimated:YES];
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
            
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unCheckmark.png"]];
            
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

@end













