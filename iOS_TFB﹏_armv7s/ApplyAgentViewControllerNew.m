//
//  ApplyAgentViewControllerNew.m
//  TongFubao
//
//  Created by  俊   on 14-9-3.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "ApplyAgentViewControllerNew.h"
#import "NLAsynImageView.h"

@interface ApplyAgentViewControllerNew ()
{
    NLProgressHUD *_hud;
    NSInteger currentHeight;
    //滑动底图
    NLKeyboardAvoidingScrollView *basicView;
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
    UIView *materialView[3];
    //详细底图
    UIView *moreView;
    //确定或重置
    UIButton *enterBtn[2];
    NSArray *custypeids;
    NSString *currentCustypeid;
    NSArray *custypenames;
    UIActionSheet *actionSheet;
    NSArray *pictypenames;
    
    /*选择文字*/
    UILabel *agentAreaLabel;
    /*资质按钮*/
    UIButton * treatyBtn;
    NSString * CellType;
    /*照片的*/
    int NumPath;
    int _isModifyPic;

    UIImage  * _downImage;
    UIImage  * _downImageCell1;
    UIImage  * _downImageCell2;
    UIImage  * _downImageCell3;
    NSString * _up_picpath;
    NSString * _down_picpath;
}
@end

@implementation ApplyAgentViewControllerNew

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
    
    /*修正*/
    UITapGestureRecognizer *oneFingerTwoTaps = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(oneFingerTwoTaps)];
    // Set required taps and number of touches
    [oneFingerTwoTaps setNumberOfTapsRequired:2];
    
    [self.view addGestureRecognizer:oneFingerTwoTaps];
}

#pragma mark - 滑动视图
- (void)initScrollView
{
    
    basicView = [[NLKeyboardAvoidingScrollView alloc]initWithFrame:CGRectMake(0, 0, SelfWidth, currentHeight - 64)];
    basicView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:basicView];
    
    /*上传图片的*/
    _Mytable.hidden =YES;
    [basicView addSubview:_Mytable];
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
        textPlaceholder = (i == 0? @"请输入名字" : i == 1? @"请输入手机号码" : @"自定义6位数字");
        labelName = (i == 0? @"*姓名" : i == 1? @"*手机号码" : @"*区域代号");
        
        //文本
        UILabel *basicLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20 + 42 * i, SelfWidth / 3 - 10, 40)];
        basicLabel.opaque = YES;
        basicLabel.backgroundColor = [UIColor clearColor];
        basicLabel.textColor = [UIColor blackColor];
        basicLabel.textAlignment = NSTextAlignmentLeft;
        basicLabel.text = labelName;
        basicLabel.font = [UIFont systemFontOfSize:17.0];
        [basicView addSubview:basicLabel];
        
        //输入框
        basicText[i] = [[UITextField alloc] initWithFrame:CGRectMake(SelfWidth / 3, 20 + 42 * i, SelfWidth / 4 * 3 - 50, 35)];
        basicText[i].opaque = YES;
        basicText[i].returnKeyType = UIReturnKeyDone;
        basicText[i].delegate = self;
        basicText[i].layer.cornerRadius = 5;
        basicText[i].layer.borderWidth = 1.0;
        basicText[i].layer.borderColor = SACOLOR(196, 1.0).CGColor;
        basicText[i].backgroundColor = [UIColor whiteColor];
        basicText[i].placeholder = textPlaceholder;
        
        UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 11, 30)];
        basicText[i].leftView = paddingView1;
        basicText[i].leftViewMode = UITextFieldViewModeAlways;
        
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
    UILabel *areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 155, 310, 20)];
    areaLabel.opaque = YES;
    areaLabel.backgroundColor = [UIColor clearColor];
    areaLabel.textColor = [UIColor blackColor];
    areaLabel.textAlignment = NSTextAlignmentLeft;
    areaLabel.text = @"*合同意向地区";
    areaLabel.font= [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:15.0];
    areaLabel.font = [UIFont systemFontOfSize:20.0];
    [basicView addSubview:areaLabel];
    
    //按扭名称
    NSString *btnName = nil;
    
    /*地区按扭*/
    for (int i = 0; i < 3; i++)
    {
        btnName = (i == 0? @"北京市" : i == 1? @"北京市" : @"丰台区");
        areaButton[i] = [UIButton buttonWithType:UIButtonTypeCustom];
        areaButton[i].opaque = YES;
        areaButton[i].tag = 2101 + i;
        areaButton[i].frame = CGRectMake(15 + 100 * i, 188, 90, 35);
        [areaButton[i] setBackgroundImage:imageName(@"next_press@2x", @"png") forState:UIControlStateNormal];
        [areaButton[i] setTitle:btnName forState:UIControlStateNormal];
        [areaButton[i] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        areaButton[i].titleLabel.font= [UIFont systemFontOfSize:17];
        [areaButton[i] setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
        [areaButton[i] addTarget:self action:@selector(areaBtnActionNew:) forControlEvents:UIControlEventTouchUpInside];
        [basicView addSubview:areaButton[i]];
    }
    
    agentAreaLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 200, 300, 80)];
    agentAreaLabel.textAlignment= NSTextAlignmentLeft;
    agentAreaLabel.opaque = YES;
    agentAreaLabel.backgroundColor = [UIColor clearColor];
    agentAreaLabel.text= [NSString stringWithFormat:@"%@-%@-%@",areaButton[0].titleLabel.text,areaButton[1].titleLabel.text,areaButton[2].titleLabel.text];
    agentAreaLabel.textColor = [UIColor lightGrayColor];
    agentAreaLabel.font = [UIFont systemFontOfSize:16.0];
    agentAreaLabel.numberOfLines = 0;
    [basicView addSubview:agentAreaLabel];
    
    
    basicView.contentSize = CGSizeMake(SelfWidth, currentHeight);
    
    //自定义地区输入
    customText = [[UITextField alloc] initWithFrame:CGRectMake(16, 260, 288, 37)];
    customText.opaque = YES;
    customText.returnKeyType = UIReturnKeyDone;
    customText.delegate = self;
    customText.layer.cornerRadius = 5;
    customText.layer.borderWidth = 1.0;
    customText.layer.borderColor = SACOLOR(196, 1.0).CGColor;
    customText.backgroundColor = [UIColor whiteColor];
    customText.placeholder = @"自定义填写意向地区";
    
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 11, 30)];
    customText.leftView = paddingView1;
    customText.leftViewMode = UITextFieldViewModeAlways;
    [basicView addSubview:customText];
    
    //资质证明材料
    treatyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    treatyBtn.frame = CGRectMake(10, 310, 190, 40);
    [treatyBtn setTitle:@"*资质证明材料 >>>" forState:UIControlStateNormal];
    [treatyBtn setTitle:@"*资质证明材料 <<<" forState:UIControlStateSelected];
    [treatyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    treatyBtn.titleLabel.font = [UIFont systemFontOfSize:20.0];
    treatyBtn.titleLabel.font= [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:20.0];
    treatyBtn.tag= 104;
    [treatyBtn addTarget:self action:@selector(AddRightAction:) forControlEvents:UIControlEventTouchUpInside];
    [basicView addSubview:treatyBtn];
}

#pragma mark - 地区选择
- (void)areaBtnActionNew:(UIButton *)sender
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


-(void)AddRightAction:(UIButton*)sender
{
    sender.selected = !sender.selected;
    
    if (!sender.selected)
    {
        materialBtn.hidden= YES;
        _Mytable.hidden= YES;
        [enterBtn[0].layer setValue:@360 forKeyPath:@"frame.origin.y"];
        [enterBtn[1].layer setValue:@360 forKeyPath:@"frame.origin.y"];
        
    }
    else
    {
        materialBtn.hidden= NO;
        _Mytable.hidden= NO;
        NSNumber *num= [NSNumber numberWithFloat:materialBtn.frame.origin.y+390];
        [_Mytable.layer setValue:num forKeyPath:@"frame.origin.y"];
        [enterBtn[0].layer setValue:@740 forKeyPath:@"frame.origin.y"];
        [enterBtn[1].layer setValue:@740 forKeyPath:@"frame.origin.y"];
        basicView.contentSize = CGSizeMake(SelfWidth, currentHeight + 250);
    }
}

#pragma mark - 材料证明视图
- (void)initMaterialView
{
    moreView = [[UIView alloc] initWithFrame:CGRectMake(16, 360, 300, 50)];
    moreView.backgroundColor = [UIColor clearColor];
    [basicView addSubview:moreView];
    
    //代理商性质
    materialBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    materialBtn.opaque = YES;
    materialBtn.frame = CGRectMake(0, 0, 288, 40);
    [materialBtn setTitle:@"公司" forState:UIControlStateNormal];
    [materialBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [materialBtn setBackgroundImage:imageName(@"next_press@2x", @"png") forState:UIControlStateNormal];
    [materialBtn addTarget:self action:@selector(materialBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    materialBtn.hidden= YES;
    [moreView addSubview:materialBtn];
    
    //确定或重设按扭名称
    NSString *btnName = nil;
    
    for (int i = 0; i < 2; i++)
    {
        btnName = (i == 0? @"提交" : @"重置");
        
        enterBtn[i] = [UIButton buttonWithType:UIButtonTypeCustom];
        enterBtn[i].opaque = YES;
        enterBtn[i].tag = 2201 + i;
        enterBtn[i].frame = CGRectMake(10 + 160 * i, 360, 140, 40);
        [enterBtn[i] setTitle:btnName forState:UIControlStateNormal];
        [enterBtn[i] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [enterBtn[i] setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
        [enterBtn[i] setBackgroundImage:imageName(@"yellow_button@2x", @"png") forState:UIControlStateNormal];
        [enterBtn[i] addTarget:self action:@selector(enterBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [basicView addSubview:enterBtn[i]];
    }
}


#pragma mark - 提交或重置
- (void)enterBtnAction:(UIButton *)sender
{
    //提交
    if (sender.tag == 2201&& [self checkNoPictureInfo])
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
                NSString *text = (i == 0? @"北京市" : i == 1? @"北京市" : @"丰台区");
                
                basicText[i].text = @"";
                customText.text = @"";
                [areaButton[i] setTitle:text forState:UIControlStateNormal];
            }
        }
    }
}

-(BOOL)checkNoPictureInfo
{
    BOOL modify = YES;
   
    if (![NLUtils checkName:basicText[0].text])
    {
        [self showErrorInfo:@"输入正确的姓名" status:NLHUDState_Error];
        return NO;
    }
    
    if (![NLUtils checkMobilePhone:basicText[1].text])
    {
        modify = YES;
        [self showErrorInfo:@"输入正确的手机号码" status:NLHUDState_Error];
        return NO;
    }
    
    if (basicText[2].text.length<4)
    {
        modify = YES;
        [self showErrorInfo:@"输入正确的区域代号" status:NLHUDState_Error];
        return NO;
    }
    
    if (customText.text.length<3)
    {
        modify = YES;
        [self showErrorInfo:@"输入正确的区域代号" status:NLHUDState_Error];
        return NO;
    }
    
    return modify;
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
            actionSheet.tag= 101;
        }
    }
    
    [actionSheet showInView:self.view];
}

#pragma mark - ActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 101) {
        
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
        
    }else{
        switch (buttonIndex)
        {
            case 0:
            {
                [self addByPhotosAlbm];
            }
                break;
            case 1:
            {
                [self addByCamel];
            }
                break;
            case 2:
            {
                [self showBigImageView];
            }
                break;
            default:
                break;
        }
    }
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
        
        agentAreaLabel.text= [NSString stringWithFormat:@"%@-%@-%@",areaButton[0].titleLabel.text,areaButton[1].titleLabel.text,areaButton[2].titleLabel.text];
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
        [self showErrorInfo:@"请求超时,需要重新登录" status:NLHUDState_Error];
        [self performSelector:@selector(doPush) withObject:nil afterDelay:2.0f];
        return;
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

-(void)addTapGestureRecognizer:(UIView*)view
{
    UITapGestureRecognizer *oneFingerTwoTaps = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(oneFingerTwoTaps)];
    // Set required taps and number of touches
    [oneFingerTwoTaps setNumberOfTapsRequired:1];
    [oneFingerTwoTaps setNumberOfTouchesRequired:1];
    [view addGestureRecognizer:oneFingerTwoTaps];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) doPush
{
    [_hud hide:YES];
    [NLUtils popToLogonVCByHTTPError:self feedOrLeft:1];
}

#pragma mark - keyboard hide event
-(void)oneFingerTwoTaps
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    UITextField *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    
    [firstResponder resignFirstResponder];
}

/*不为空的取值返回数据*/
-(NSString*)getNoNilStr:(NSString*)str
{
    //NSLog(@"str = %@, length = %d, null = %d",str,str.length,[str isEqual:[NSNull null]]);
    if (str == nil)
    {
        return @"";
    }
    return str;
}


#pragma mark - UITableViewDataSource

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 70;
}

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
    
    cell.myHeaderLabel.hidden = NO;
    cell.myHeaderLabel.hidden= NO;
    cell.mySelectedBtn.hidden = YES;
    cell.myContainer = self;
    cell.myDownrightBtn.hidden = NO;
    cell.myDownrightImage.hidden = NO;
    
    [cell.myTextField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
   
    [cell setFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, 120)]; 
    [cell.myHeaderLabel setFrame:CGRectMake(cell.myHeaderLabel.frame.origin.x+15, cell.myHeaderLabel.frame.origin.y+13, cell.myHeaderLabel.frame.size.width+20, cell.myHeaderLabel.frame.size.height)];
    [self addTapGestureRecognizer:cell.myHeaderLabel];
    
    cell.myContentLabel.hidden = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.CellBlock= ^{
        NumPath= indexPath.row;
    };
    [cell.myDownrightBtn setFrame:CGRectMake( 200, 8, 60, 60)];
    [cell.myDownrightImage setFrame:CGRectMake(200, 8, 60, 60)];
    cell.myDownrightBtn.hidden = NO;
    cell.myDownrightImage.hidden = NO;
    switch (indexPath.row)
    {
            /*可替换返回数据的值*/
        case 0:
        {
            cell.myHeaderLabel.text = @"营业执照";

            if (_downImage)
            {
                cell.myDownrightImage.image = _downImage;
            }
            else if ([_down_picpath rangeOfString:@"http://"].length > 0)
            {
                cell.myDownrightImage.placeholderImage = [UIImage imageNamed:@"addUsersPhoto.png"];
                /*下载网络图片
                cell.myDownrightImage.imageURL = _down_picpath;*/
            }
            else
            {
                cell.myDownrightImage.image = [UIImage imageNamed:@"addUsersPhoto.png"];;
            }
        }
            break;
        case 1:
        {
            cell.myHeaderLabel.text = @"组织机构代码证";
     
            if (_downImageCell1)
            {
                cell.myDownrightImage.image = _downImageCell1;
            }
            else if ([_down_picpath rangeOfString:@"http://"].length > 0/*_down_picpath.length > 0*/)
            {
                cell.myDownrightImage.placeholderImage = [UIImage imageNamed:@"addUsersPhoto.png"];
                cell.myDownrightImage.imageURL = _down_picpath;
            }
            else
            {
                cell.myDownrightImage.image = [UIImage imageNamed:@"addUsersPhoto.png"];;
            }

        }
            break;
        case 2:
        {
            cell.myHeaderLabel.text = @"税务登记证";
  
           
            if (_downImageCell2)
            {
                cell.myDownrightImage.image = _downImageCell2;
            }
            else if ([_down_picpath rangeOfString:@"http://"].length > 0/*_down_picpath.length > 0*/)
            {
                cell.myDownrightImage.placeholderImage = [UIImage imageNamed:@"addUsersPhoto.png"];
                cell.myDownrightImage.imageURL = _down_picpath;
            }
            else
            {
                cell.myDownrightImage.image = [UIImage imageNamed:@"addUsersPhoto.png"];;
            }
        }
            break;
        case 3:
        {
            cell.myHeaderLabel.text = @"法人身份证";
           
            if (_downImageCell3)
            {
                cell.myDownrightImage.image = _downImageCell3;
            }
            else if ([_down_picpath rangeOfString:@"http://"].length > 0/*_down_picpath.length > 0*/)
            {
                cell.myDownrightImage.placeholderImage = [UIImage imageNamed:@"addUsersPhoto.png"];
                cell.myDownrightImage.imageURL = _down_picpath;
            }
            else
            {
                cell.myDownrightImage.image = [UIImage imageNamed:@"addUsersPhoto.png"];;
            }
        }
            break;
           
        default:
            break;
    }
    return cell;
}

/*照片相册获取*/
-(void)doDownrightBtnClicked:(id)sender
{
    [self adding:0];
    return;
}

/*就要一个好了
-(void)doUprightBtnClicked:(id)sender
{
    _upOrDown = 1;
    [self adding:1];
    return;
}
*/
-(void)adding:(int)tag
{
    UIActionSheet *menu = [[UIActionSheet alloc]
                initWithTitle: nil
                delegate:self
                cancelButtonTitle:@"取消"
                destructiveButtonTitle:nil
                otherButtonTitles:@"从相册选取",@"立即拍照上传",@"查看大图", nil];
  
    menu.actionSheetStyle = UIActionSheetStyleDefault;
    menu.tag = tag;
    [menu showInView:[UIApplication sharedApplication].keyWindow];
}

-(void)addByPhotosAlbm
{
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	picker.allowsEditing = YES;
	
	picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
	{
        //混合类型 photo + movie
		picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    }
	[self presentViewController:picker animated:YES completion:nil];
    
}

- (void) addByCamel
{
    //先设定sourceType为相机，然后判断相机是否可用（ipod）没相机，不可用将sourceType设定为相片库
	UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
		sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	}
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)showBigImageView
{
    NLBigImageViewController* vc = [[NLBigImageViewController alloc] initWithNibName:@"NLBigImageViewController" bundle:nil];

    if (NumPath==0) {
         vc.myImage = _downImage;
    }else if (NumPath==1) {
        vc.myImage = _downImageCell1;
    }else if (NumPath==2) {
        vc.myImage = _downImageCell2;
    }else if (NumPath==3) {
        vc.myImage = _downImageCell3;
    }
   
 
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark Camera View Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self performSelector:@selector(saveImage:)
               withObject:image
               afterDelay:0.5];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveImage:(UIImage *)image
{

    NSString* path = nil;
    if (NumPath==0) {
         _downImage = image;
    }else if (NumPath==1){
         _downImageCell1 = image;
    }else if (NumPath==2){
        _downImageCell2 = image;
    }else if (NumPath==3){
        _downImageCell3 = image;
    }
   
 
    if (_isModifyPic < 2)
    {
        _isModifyPic++;
    }
    
    NSData* data = UIImageJPEGRepresentation(image, 1.0);
    [data writeToFile:path atomically:YES];

    NSArray *arr = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:NumPath inSection:0]];
    [self.Mytable reloadRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationFade];
}

- (void)textFieldWithText:(UITextField *)textField
{
    /*对应执照图片*/
}

@end
