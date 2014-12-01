//
//  AddNewBankCardController.m
//  TongFubao
//
//  Created by Delpan on 14-8-8.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "AddNewBankCardController.h"
#import "ChangeButton.h"
#import "CardInfoView.h"
#import "NLShowTextViewController.h"

@interface AddNewBankCardController ()
{
    NLProgressHUD *_hud;
    
    NSInteger currentHeight;
    //
    UIScrollView *basicView;
    //卡按钮
    UIButton *changeBtn[2];
    //移动光标
    UIImageView *moveView;
    //储蓄卡输入
    CardInfoView *saveCardView[4];
    //信用卡输入
    CardInfoView *creditCardView[2];
    //
    BOOL creditCard;
    //当前卡类型
    NSString *currentCard;
    //信息
    NSArray *infos;
    //信用卡底图
    UIView *creditView;
    //保存按扭
    UIButton *saveBtn;
    //
    BOOL editOr;
    //移除按钮
    UIButton *removeBtn;
    //默认卡
    NSString *defaultCard;
    //银行选择
    AreaSelectView *areaView;
    //银行数组
    NSMutableArray *bankTags;
    //银行ID
    NSString *bankID;
    //信用卡月
    NSString *month;
    //信用卡年
    NSString *year;
}

@end

@implementation AddNewBankCardController

@synthesize cardInfo = _cardInfo;
@synthesize masterInfos = _masterInfos;
@synthesize addDelegate = _addDelegate;

- (id)initWithEdit:(BOOL)edit creditCard:(BOOL)creditCard_
{
    if (self = [super init])
    {
        editOr = edit;
        
        creditCard = creditCard_;
        
        //卡类型
        currentCard = creditCard? @"creditcard" : @"bankcard";
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    
    ViewControllerProperty;
    
#endif
    
    self.title = editOr? @"编辑银行卡" : @"添加银行卡";
    
    infos = @[ @"开户银行", @"银行卡号", @"开户人", @"手机号码", @"安全码", @"身份证号码" ];
    
    //有效月
    month = _cardInfo.bkcardyxmonth? _cardInfo.bkcardyxmonth : nil;
    //有效年
    year = _cardInfo.bkcardyxyear? _cardInfo.bkcardyxyear : nil;
    
    //是否为默认卡
    defaultCard = _cardInfo.bkcardisdefault? _cardInfo.bkcardisdefault : nil;
    
    //获取当前屏幕size
    currentHeight = iphoneSize;
    
    //初始化视图
    [self initView];
}

#pragma mark - 初始化视图
- (void)initView
{
    int textnumber = 0;
    
    basicView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SelfWidth, 504)];
    basicView.backgroundColor = RGBACOLOR(241, 243, 246, 1.0);
    basicView.contentSize = CGSizeMake(SelfWidth, 600);

    [self.view addSubview:basicView];
    
    if (!editOr)
    {
        //类型按扭
        for (int i = 0; i < 2; i++)
        {
            UIImage *image = i == 0? imageName(@"left_normal_button@2x", @"png") : imageName(@"right_normal_button@2x", @"png");;
            UIImage *selectedImage = i == 0? imageName(@"left_selected_button@2x", @"png") : imageName(@"right_t_selected_button@2x", @"png");;
            
            BOOL selected;
            
            if (creditCard)
            {
                selected = i == 0? YES : NO;
            }
            else
            {
                selected = i == 0? NO : YES;
            }
            
            NSString *btnName = i == 0? @"信用卡" : @"储蓄卡";
            
            changeBtn[i] = [UIButton buttonWithType:UIButtonTypeCustom];
            changeBtn[i].opaque = YES;
            changeBtn[i].frame = CGRectMake(10 + 150 * i, 15, 150, 40);
            changeBtn[i].tag = 2401 + i;
            changeBtn[i].selected = selected;
            [changeBtn[i] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [changeBtn[i] setTitle:btnName forState:UIControlStateNormal];
            [changeBtn[i] setBackgroundImage:image forState:UIControlStateNormal];
            [changeBtn[i] setBackgroundImage:selectedImage forState:UIControlStateSelected];
            [changeBtn[i] addTarget:self action:@selector(changeCardAction:) forControlEvents:UIControlEventTouchUpInside];
            [basicView addSubview:changeBtn[i]];
        }
        CGRect moveViewRect = CGRectMake(72, 55, 12, 6);
        
        if (!creditCard)
        {
            moveViewRect = CGRectMake(232, 55, 12, 6);
        }
        
        //移动光标
        moveView = [[UIImageView alloc] initWithFrame:moveViewRect];
        moveView.opaque = YES;
        moveView.image = imageName(@"triangle@2x", @"png");
        [basicView addSubview:moveView];
    }
    
    //储蓄卡输入
    for (int i = 0; i < 4; i++)
    {
        saveCardView[i] = [[CardInfoView alloc] initWithFrame:CGRectMake(10, 65 + 40 * i, 300, 40)];
        saveCardView[i].infoLabel.text = infos[textnumber];
        saveCardView[i].infoText.placeholder = i == 0? @"请选择银行卡" : @"";
        saveCardView[i].infoText.text = _masterInfos[textnumber];
        saveCardView[i].infoText.keyboardType = i == 2? UIKeyboardTypeDefault : UIKeyboardTypeNumberPad;
        saveCardView[i].infoText.delegate = self;
        saveCardView[i].infoText.tag = 2701 + i;
        saveCardView[i].infoText.returnKeyType = UIReturnKeyDone;
        [basicView addSubview:saveCardView[i]];
        
        textnumber++;
    }
    
    CGRect saveBtnRect = CGRectMake(10, 415, 300, 35);
    
    if (!creditCard)
    {
        saveBtnRect = CGRectMake(10, 235, 300, 35);
    }
    
    //保存按扭
    saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.opaque = YES;
    saveBtn.frame = saveBtnRect;
    [saveBtn setBackgroundImage:imageName(@"next_press@2x", @"png") forState:UIControlStateNormal];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [basicView addSubview:saveBtn];
    
    //修改
    if (editOr)
    {
        CGRect removeRect = creditCard? CGRectMake(10, 455, 300, 35) : CGRectMake(10, 275, 300, 35);
        
        removeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        removeBtn.opaque = YES;
        removeBtn.frame = removeRect;
        [removeBtn setBackgroundImage:imageName(@"yellow_button@2x", @"png") forState:UIControlStateNormal];
        [removeBtn setTitle:@"解除绑定" forState:UIControlStateNormal];
        [removeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [removeBtn addTarget:self action:@selector(removeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [basicView addSubview:removeBtn];
    }
    
    if (creditCard)
    {
        [self initCreditCardView:textnumber];
    }
}

- (void)initCreditCardView:(int)textnumber
{
    //信用卡添加
    if (creditCard)
    {
        //信用卡底图
        creditView = [[UIView alloc] initWithFrame:CGRectMake(0, 225, SelfWidth, 190)];
        creditView.backgroundColor = [UIColor clearColor];
        creditView.opaque = YES;
        [basicView addSubview:creditView];
        
        for (int i = 0; i < 2; i++)
        {
            creditCardView[i] = [[CardInfoView alloc] initWithFrame:CGRectMake(10, 40 * i, 300, 40)];
            creditCardView[i].infoLabel.text = infos[textnumber];
            creditCardView[i].infoText.text = _masterInfos[textnumber];
            creditCardView[i].infoText.keyboardType = UIKeyboardTypeNumberPad;
            creditCardView[i].infoText.delegate = self;
            creditCardView[i].infoText.tag = 2601 + i;
            creditCardView[i].infoText.returnKeyType = UIReturnKeyDone;
            [creditView addSubview:creditCardView[i]];
            
            textnumber++;
        }
        
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 85, 320, 40)];
        dateLabel.opaque = YES;
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.textAlignment = NSTextAlignmentLeft;
        dateLabel.textColor = [UIColor grayColor];
        dateLabel.text = @"有效期                          月/                          年";
        dateLabel.font = [UIFont systemFontOfSize:15.0];
        [creditView addSubview:dateLabel];
        
        //月按钮
        ChangeButton *monthBtn = [ChangeButton buttonWithFrame:CGRectMake(60, 85, 100, 35)];
        monthBtn.tag = 2501;
        [monthBtn setTitle:_cardInfo.bkcardyxmonth forState:UIControlStateNormal];
        [monthBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [monthBtn addTarget:self action:@selector(dateBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [creditView addSubview:monthBtn];
        
        //年按钮
        ChangeButton *yearBtn = [ChangeButton buttonWithFrame:CGRectMake(195, 85, 100, 35)];
        yearBtn.tag = 2502;
        [yearBtn setTitle:_cardInfo.bkcardyxyear forState:UIControlStateNormal];
        [yearBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [yearBtn addTarget:self action:@selector(dateBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [creditView addSubview:yearBtn];
        
        //默认按钮
        UIButton *defaultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        defaultBtn.opaque = YES;
        defaultBtn.frame = CGRectMake(10, 125, 25, 25);
        [defaultBtn setBackgroundImage:imageName(@"unSelected@2x", @"png") forState:UIControlStateNormal];
        [defaultBtn setBackgroundImage:imageName(@"selected@2x", @"png") forState:UIControlStateSelected];
        defaultBtn.selected = [_cardInfo.bkcardisdefault isEqualToString:@"1"]? YES : NO;
        [defaultBtn addTarget:self action:@selector(defaultBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [creditView addSubview:defaultBtn];
        
        UILabel *defaultLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 125, 200, 25)];
        defaultLabel.opaque = YES;
        defaultLabel.backgroundColor = [UIColor clearColor];
        defaultLabel.textAlignment = NSTextAlignmentLeft;
        defaultLabel.textColor = [UIColor grayColor];
        defaultLabel.text = @"设为默认支付卡";
        defaultLabel.font = [UIFont systemFontOfSize:15.0];
        [creditView addSubview:defaultLabel];
        
        NSString *treatyBtnName = [NSString stringWithFormat:@"点击查看《通付宝默认支付协议》"];
        
        //查看协议
        UIButton *treatyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        treatyBtn.opaque = YES;
        treatyBtn.frame = CGRectMake(10, 155, 300, 25);
        [treatyBtn setTitle:treatyBtnName forState:UIControlStateNormal];
        [treatyBtn setTitleColor:RGBACOLOR(18, 110, 191, 1.0) forState:UIControlStateNormal];
        treatyBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [treatyBtn addTarget:self action:@selector(treatyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [creditView addSubview:treatyBtn];
    }
}

#pragma mark - TextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    
    if (textField.tag >= 2601)
    {
        [UIView animateWithDuration:0.3 animations:^{
            
            basicView.frame = CGRectMake(0, 0, SelfWidth, 508);
        }];
    }
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == saveCardView[0].infoText)
    {
        NLBankListViewController *bankListView = [[NLBankListViewController alloc] initWithNibName:@"NLBankListViewController" bundle:nil];
        bankListView.delegate = self;
        bankListView.banKtype = creditCard? YES : NO;
        [self.navigationController pushViewController:bankListView animated:YES];
        
        return NO;
    }
    
    return YES;
}

#pragma mark - NLBankLisDelegate
- (void)dataSearch:(NLBankListViewController *)controller didSelectWithObject:(id)aObject withState:(NSString *)state
{
    bankID = state;
    saveCardView[0].infoText.text = (NSString *)aObject;
}

- (void)areaChange:(BOOL)change btn:(UIButton *)btn
{
    if (change)
    {
        if (btn.tag == 2501)
        {
            month = [btn titleForState:UIControlStateNormal];
        }
        else
        {
            year = [btn titleForState:UIControlStateNormal];
        }
    }
}

#pragma mark - 银行卡类型选择
- (void)changeCardAction:(UIButton *)sender
{
    if (!editOr)
    {
        if (!sender.selected)
        {
            //更改图片
            changeBtn[0].selected = !changeBtn[0].selected;
            changeBtn[1].selected = !changeBtn[1].selected;
        }
        
        //光标偏移
        NSNumber *moveX = sender.tag == 2401? @72 : @232;
        [moveView.layer setValue:moveX forKeyPath:@"frame.origin.x"];
        
        //是否为信用卡
        creditCard = sender.tag == 2401? YES : NO;
        
        //当前所选卡类型
        currentCard = creditCard? @"creditcard" : @"bankcard";
        
        //保存按钮偏移
        if (creditCard)
        {
            if (!creditView)
            {
                int textNumber = 4;
                [self initCreditCardView:textNumber];
            }
            
            creditView.hidden = NO;
            
            [saveBtn.layer setValue:@415 forKeyPath:@"frame.origin.y"];
            
            if (removeBtn)
            {
                [removeBtn.layer setValue:@455 forKeyPath:@"frame.origin.y"];
            }
        }
        else
        {
            creditView.hidden = YES;
            
            [saveBtn.layer setValue:@235 forKeyPath:@"frame.origin.y"];
            
            if (removeBtn)
            {
                [removeBtn.layer setValue:@275 forKeyPath:@"frame.origin.y"];
            }
        }
    }
}

#pragma mark - 日期选择
- (void)dateBtnAction:(UIButton *)sender
{
    if (!areaView)
    {
        areaView = [[AreaSelectView alloc]initWithFrame:CGRectMake(0, 0, SelfWidth, 504)];
        areaView.areaSelectViewDelegate = self;
    }
    
    if (sender.tag == 2501)
    {
        [areaView loadDataWith:@[ @"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12" ] button:sender dictionary:NO NLData:NO];
    }
    else
    {
        [areaView loadDataWith:@[ @"2014",@"2015",@"2016",@"2017",@"2018",@"2019",@"2020",@"2021",@"2022",@"2023",@"2024",@"2025",@"2026",@"2027",@"2028",@"2029",@"2030" ] button:sender dictionary:NO NLData:NO];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        
        areaView.alpha = 1.0;
    }];
    
    [basicView addSubview:areaView];
}

#pragma mark - 是否默认信用卡
- (void)defaultBtnAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    defaultCard = sender.selected? @"1" : @"0";
}

#pragma mark - 查看协议
- (void)treatyBtnAction:(UIButton *)sender
{
    NLShowTextViewController *showView = [[NLShowTextViewController alloc] initWithNibName:@"NLShowTextViewController" bundle:nil];
    showView.myType = 2;
    [NLUtils presentModalViewController:self newViewController:showView];
}

#pragma mark - 保存银行卡信息
- (void)saveBtnAction:(UIButton *)sender
{
    month = month? month : @" ";
    year = year? year : @" ";
    defaultCard = defaultCard? defaultCard : @" ";
    NSString *bkcardidcard = creditCardView[1].infoText.text? creditCardView[1].infoText.text : @" ";
    
    //当前输入的卡号长度
    if (![NLUtils checkInterNum:saveCardView[1].infoText.text] || saveCardView[1].infoText.text.length < 14)
    {
        [self showErrorInfo:@"请输入正确的卡号" status:NLHUDState_Error];
        
        return ;
    }
    
    if (editOr) 
    {
        NSString *name = [NLUtils getNameForRequest:Notify_ApiAuthorKuaibkcardInfoEdit];
        REGISTER_NOTIFY_OBSERVER(self, checkDataForCardEdit, name);
        [[[NLProtocolRequest alloc] initWithRegister:YES] getApiAuthorKuaibkcardInfoEdit:_cardInfo.bkcardid
                                                                            bkcardbankid:_cardInfo.bkcardbankid
                                                                              bkcardbank:saveCardView[0].infoText.text bkcardno:saveCardView[1].infoText.text
                                                                           bkcardbankman:saveCardView[2].infoText.text
                                                                         bkcardbankphone:saveCardView[3].infoText.text
                                                                           bkcardyxmonth:month
                                                                            bkcardyxyear:year
                                                                               bkcardcvv:creditCardView[0].infoText.text
                                                                            bkcardidcard:bkcardidcard
                                                                          bkcardcardtype:currentCard
                                                                         bkcardisdefault:defaultCard];
    }
    else
    {
        NSString *name = [NLUtils getNameForRequest:Notify_ApiAuthorKuaibkcardInfoAdd];
        REGISTER_NOTIFY_OBSERVER(self, checkDataForNewCard, name);
        [[[NLProtocolRequest alloc] initWithRegister:YES] getApiAuthorKuaibkcardInfoAdd:bankID
                                                                             bkcardbank:saveCardView[0].infoText.text
                                                                               bkcardno:saveCardView[1].infoText.text
                                                                          bkcardbankman:saveCardView[2].infoText.text
                                                                        bkcardbankphone:saveCardView[3].infoText.text
                                                                          bkcardyxmonth:month
                                                                           bkcardyxyear:year
                                                                              bkcardcvv:creditCardView[0].infoText.text
                                                                           bkcardidcard:bkcardidcard
                                                                         bkcardcardtype:currentCard
                                                                        bkcardisdefault:defaultCard];
    }
}

#pragma mark - 移除按钮
- (void)removeBtnAction:(UIButton *)sender
{
    NSString *name = [NLUtils getNameForRequest:Notify_ApiAuthorKuaibkcardInfoDelete];
    REGISTER_NOTIFY_OBSERVER(self, checkDataForCard, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApiAuthorKuaibkcardInfoDelete:_cardInfo.bkcardid];
}

#pragma mark - 检查银行卡信息
- (void)checkDataForNewCard:(NSNotification *)notify
{
    NLProtocolResponse *response = (NLProtocolResponse *)notify.object;
    int error = response.errcode;
    
    if (error == RSP_NO_ERROR)
    {
        [self getDataWithNewCard:response];
    }
    else
    {
        NSString *string = response.detail;
        
        [self showError:string];
    }
}

- (void)getDataWithNewCard:(NLProtocolResponse *)response
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
        [_addDelegate popAndReloadData];
        
        [self showError:@"操作成功"];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 检查修改银行卡
- (void)checkDataForCardEdit:(NSNotification *)notify
{
    NLProtocolResponse *response = (NLProtocolResponse *)notify.object;
    int error = response.errcode;
    
    if (error == RSP_NO_ERROR)
    {
        [self getDataForCardEdit:response];
    }
    else
    {
        NSString *string = response.detail;
        
        [self showError:string];
    }
}

- (void)getDataForCardEdit:(NLProtocolResponse *)response
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
        [_addDelegate popAndReloadData];
        
        [self showError:@"操作成功"];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 查看是否成功
- (void)checkDataForCard:(NSNotification *)notify
{
    NLProtocolResponse *response = (NLProtocolResponse *)notify.object;
    int error = response.errcode;
    
    if (error == RSP_NO_ERROR)
    {
        [self getDataWithCard:response];
    }
    else
    {
        NSString *string = response.detail;
        
        [self showError:string];
    }
}

- (void)getDataWithCard:(NLProtocolResponse *)response
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
        [self showError:@"操作成功"];
        
        [_addDelegate popAndReloadData];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma showErrorInfo
- (void)showError:(NSString *)detail
{
    if (detail)
    {
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
    else
    {
        [self showErrorInfo:@"服务器繁忙，请稍候再试" status:NLHUDState_Error];
    }
}

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
    
    return ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end













