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
    //默认卡支付
    NSString *defaultCard;
    //默认卡收款
    NSString *defaultPayment;
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
    /*年月bg*/
    UIView *yearview;
    /*显示的银行卡*/
    NSString *bankTFstr;
    NSString *cardTFstr;
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
        currentCard = creditCard? @"x" : @"bankcard";
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    
    ViewControllerProperty;
    
#endif
    [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
    
    self.title = editOr? @"编辑银行卡" : @"添加银行卡";
    
    infos = @[ @"开户银行", @"银行卡号", @"持卡人姓名", @"手机号码", @"安全码", @"身份证号码" ];
    
    //有效月
    month = _cardInfo.bkcardyxmonth? _cardInfo.bkcardyxmonth : nil;
    //有效年
    year = _cardInfo.bkcardyxyear? _cardInfo.bkcardyxyear : nil;
    //是否为默认支付支付卡
    defaultCard = _cardInfo.bkcardisdefault? _cardInfo.bkcardisdefault : nil;
    NSLog(@"是否为支付默认卡 :%@",defaultCard);
    //是否为默认收款支付卡
    defaultPayment = _cardInfo.bkcardisdefaultPayment?_cardInfo.bkcardisdefaultPayment : nil;
    NSLog(@"是否为付款默认卡 :%@",defaultCard);
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
    basicView.contentSize = CGSizeMake(SelfWidth, 660);

    [self.view addSubview:basicView];
    
    if (!editOr)
    {
        //类型按扭
        for (int i = 0; i < 2; i++)
        {
            UIImage *image = i == 0? imageName(@"left_normal_button@2x", @"png") : imageName(@"right_normal_button@2x", @"png");
            UIImage *selectedImage = i == 0? imageName(@"left_selected_button@2x", @"png") : imageName(@"right_t_selected_button@2x", @"png");
            
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
  
    /*储蓄卡 信用卡 添加、修改 我擦 改死哥了*/
    /*判断点击我已有银行卡、新增或修改我的信用或银行卡布局样式判断*/
    int num = editOr ? 20 : 65;
    int row = creditCard ? 46 : 0;
    NSString *labelName = nil;
    CGRect creatView;
    
    for (int i = 0; i < 4; i++)
    {
         labelName = (i == 0? @"请选择银行卡" : i == 1 ? @"请输入银行卡号" : i == 2? @"请输入持卡人姓名" : @"请输入银行预留的手机号");
        creatView = i > 1 ?  CGRectMake(10, num + 46 * i + row, 300, 42) :  CGRectMake(10, num + 46 * i, 300, 42)  ;
        
        saveCardView[i] = [[CardInfoView alloc] initWithFrame: creatView];
        saveCardView[i].infoLabel.text = infos[textnumber];
        saveCardView[i].infoText.placeholder = labelName;
        saveCardView[i].infoText.text = _masterInfos[textnumber];
        saveCardView[i].infoText.keyboardType = i == 2? UIKeyboardTypeDefault : UIKeyboardTypeNumberPad;
        saveCardView[i].infoText.delegate = self;
        saveCardView[i].infoText.tag = 2701 + i;
        saveCardView[i].infoText.returnKeyType = UIReturnKeyDone;
        [basicView addSubview:saveCardView[i]];
        
        textnumber++;
    }
    
    /*显示打星号*/

    bankTFstr = saveCardView[1].infoText.text;

    if ( editOr ) {
        NSRange rang = NSMakeRange(4, bankTFstr.length - 8);
        NSString *changeBank = [saveCardView[1].infoText.text stringByReplacingCharactersInRange:rang withString:@"****"];
        saveCardView[1].infoText.text= changeBank;
        NSLog(@"bankTFstr%@ %@",bankTFstr,changeBank);
    }

    int yearNum =  saveCardView[1].frame.origin.y + 45;
    yearview= [[UIView alloc]initWithFrame:CGRectMake(0, yearNum, 320, 40)];
    yearview.hidden= _rightflag ? NO : YES;
    yearview.backgroundColor = RGBACOLOR(241, 243, 246, 1.0);
    [basicView addSubview:yearview];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 320, 40)];
    dateLabel.opaque = YES;
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.textAlignment = NSTextAlignmentLeft;
    dateLabel.textColor = [UIColor grayColor];
    dateLabel.text = @"有限期                          月/                          年";
    dateLabel.font = [UIFont systemFontOfSize:15.0];
    [yearview addSubview:dateLabel];
    
    //月按钮
    ChangeButton *monthBtn = [ChangeButton buttonWithFrame:CGRectMake(60, 3, 100, 35)];
    monthBtn.tag = 2501;
    [monthBtn setTitle:_cardInfo.bkcardyxmonth forState:UIControlStateNormal];
    [monthBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [monthBtn addTarget:self action:@selector(dateBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [yearview addSubview:monthBtn];
    
    //年按钮
    ChangeButton *yearBtn = [ChangeButton buttonWithFrame:CGRectMake(195, 3, 100, 35)];
    yearBtn.tag = 2502;
    [yearBtn setTitle:_cardInfo.bkcardyxyear forState:UIControlStateNormal];
    [yearBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [yearBtn addTarget:self action:@selector(dateBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [yearview addSubview:yearBtn];
  
    CGRect saveBtnRect = CGRectMake(10, editOr ? 465 : 505, 300, 38);

    if (!creditCard)
    {
        saveBtnRect = CGRectMake(10,  editOr ? 235 : 245, 300, 38);
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
        CGRect removeRect = creditCard? CGRectMake(10, editOr ? 515 : 585, 300, 38) : CGRectMake(10, 285, 300, 38);
        
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

#pragma mark - 默认收款 默认支付 UI
- (void)initCreditCardView:(int)textnumber
{
    //信用卡添加
    if (creditCard)
    {
        //信用卡底图 先解决上面布局再说
        int numY= editOr ?  260 : 300 ;
        creditView = [[UIView alloc] initWithFrame:CGRectMake(0, numY, SelfWidth, 150)];
        creditView.backgroundColor = [UIColor clearColor];
        creditView.opaque = YES;
        [basicView addSubview:creditView];
        
        for (int i = 0; i < 2; i++)
        {
            creditCardView[i] = [[CardInfoView alloc] initWithFrame:CGRectMake(10, 2+46 * i, 300, 42)];
            creditCardView[i].infoLabel.text = infos[textnumber];
            creditCardView[i].infoText.text = _masterInfos[textnumber];
            creditCardView[i].infoText.placeholder= i == 0 ? @"请输入安全码" : @"请输入身份证号码";
            creditCardView[i].infoText.keyboardType = UIKeyboardTypeNumberPad;
            creditCardView[i].infoText.delegate = self;
            creditCardView[i].infoText.tag = 2601 + i;
            creditCardView[i].infoText.returnKeyType = UIReturnKeyDone;
            [creditView addSubview:creditCardView[i]];
            
            textnumber++;
        }
     
        /*显示信息*/
         cardTFstr =  creditCardView[1].infoText.text;
        if (_rightflag && editOr) {
           
            NSRange rang = NSMakeRange(4, cardTFstr.length - 8);
            NSString *changeCard = [creditCardView[1].infoText.text stringByReplacingCharactersInRange:rang withString:@"****"];
            creditCardView[1].infoText.text = changeCard;
            NSLog(@"changeCard %@",changeCard);
        }
    
        int yearNum =  58;
        //支付默认卡
        UIButton *defaultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        defaultBtn.opaque = YES;
        defaultBtn.frame = CGRectMake(10, yearNum + 40, 25, 25);
        [defaultBtn setBackgroundImage:imageName(@"unSelected@2x", @"png") forState:UIControlStateNormal];
        [defaultBtn setBackgroundImage:imageName(@"selected@2x", @"png") forState:UIControlStateSelected];
        defaultBtn.selected = [_cardInfo.bkcardisdefault isEqualToString:@"1"]? YES : NO;
        [defaultBtn addTarget:self action:@selector(defaultBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [creditView addSubview:defaultBtn];
        
        UILabel *defaultLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, yearNum + 40, 150, 25)];
        defaultLabel.opaque = YES;
        defaultLabel.backgroundColor = [UIColor clearColor];//
        defaultLabel.textAlignment = NSTextAlignmentLeft;
        defaultLabel.textColor = [UIColor grayColor];
        defaultLabel.text = @"设为默认支付卡";
        defaultLabel.font = [UIFont systemFontOfSize:17.0];
        [creditView addSubview:defaultLabel];

        NSString *treatyBtnName = [NSString stringWithFormat:@"*点击查看《通付宝默认支付协议》"];
        
        //查看协议
        UIButton *treatyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        treatyBtn.opaque = YES;
        treatyBtn.frame = CGRectMake(10, yearNum + 113, 300, 25);
        [treatyBtn setTitle:treatyBtnName forState:UIControlStateNormal];
        treatyBtn.backgroundColor= [UIColor clearColor];
        treatyBtn.contentHorizontalAlignment= UIControlContentHorizontalAlignmentLeft;
        [treatyBtn setTitleColor:RGBACOLOR(18, 20, 191, 1.0) forState:UIControlStateNormal];
        treatyBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [treatyBtn addTarget:self action:@selector(treatyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [creditView addSubview:treatyBtn];
        
        
        //收款默认卡
        UIButton *defaultBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        defaultBtn2.opaque = YES;
        defaultBtn2.frame = CGRectMake( 10, yearNum + 80, 25, 25);
        [defaultBtn2 setBackgroundImage:imageName(@"unSelected@2x", @"png") forState:UIControlStateNormal];
        [defaultBtn2 setBackgroundImage:imageName(@"selected@2x", @"png") forState:UIControlStateSelected];
        defaultBtn2.selected = [_cardInfo.bkcardisdefaultPayment isEqualToString:@"1"]? YES : NO;
        [defaultBtn2 addTarget:self action:@selector(defaultBtnAction2:) forControlEvents:UIControlEventTouchUpInside];
        [creditView addSubview:defaultBtn2];
        
        UILabel *defaultLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(40, yearNum + 80, 150, 25)];
        defaultLabel2.opaque = YES;
        defaultLabel2.backgroundColor = [UIColor clearColor];
        defaultLabel2.textAlignment = NSTextAlignmentLeft;
        defaultLabel2.textColor = [UIColor grayColor];
        defaultLabel2.text = @"设为默认收款卡";
        defaultLabel2.font = [UIFont systemFontOfSize:17.0];
        [creditView addSubview:defaultLabel2];
        
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

/*呔*/
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL retValue = YES;
    
    if([[textField text] length] - range.length + string.length > 19 && textField ==  saveCardView[1].infoText )
    {
        retValue=NO;
    }
    if([[textField text] length] - range.length + string.length > 11 && textField ==  saveCardView[3].infoText )
    {
        retValue=NO;
    }
    if([[textField text] length] - range.length + string.length > 3 && textField ==  creditCardView[0].infoText )
    {
        retValue=NO;
    }
    if([[textField text] length] - range.length + string.length > 18 && textField ==  creditCardView[1].infoText )
    {
        retValue=NO;
    }
    return retValue;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == saveCardView[0].infoText)
    {
        NLBankListViewController *bankListView = [[NLBankListViewController alloc] initWithNibName:@"NLBankListViewController" bundle:nil];
        [self.view endEditing:YES];
        bankListView.delegate = self;
        bankListView.banKtype = creditCard? YES : NO;
        [self.navigationController pushViewController:bankListView animated:YES];
        
        return NO;
    }
    if (textField == saveCardView[1].infoText) {
        if (![saveCardView[1].infoText.text isEqualToString:bankTFstr]) {
            saveCardView[1].infoText.text= @"";
            bankTFstr= @"";
        }
    }
    if (textField == creditCardView[1].infoText) {
        if (![creditCardView[1].infoText.text isEqualToString:cardTFstr]) {
            creditCardView[1].infoText.text= @"";
            cardTFstr= @"";
        }
        
    }
    
    return YES;
}

#pragma mark - NLBankLisDelegate
- (void)dataSearch:(NLBankListViewController *)controller didSelectWithObject:(id)aObject withState:(NSString *)state andBankctt:(NSString *)bankctt
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
        
        int yframe= 65 + 46 * 2;
        int yframe2= 65 + 46 *3;
        int yearframe= 50;
        //保存按钮偏移
        if (creditCard)
        {
            if (!creditView)
            {
                int textNumber = 4;
                [self initCreditCardView:textNumber];
            }
            
            creditView.hidden = NO;
            yearview.hidden= NO;
            
            NSString * num =[NSString stringWithFormat:@"%d", yframe + yearframe ];
            [saveCardView[2].layer setValue:num forKeyPath:@"frame.origin.y"];
            num =[NSString stringWithFormat:@"%d", yframe2 + yearframe ];
            [saveCardView[3].layer setValue:num forKeyPath:@"frame.origin.y"];
            
            [saveBtn.layer setValue:@505 forKeyPath:@"frame.origin.y"];
            
            if (removeBtn)
            {
            
                [removeBtn.layer setValue:@505 forKeyPath:@"frame.origin.y"];
            }
        }
        else
        {
            creditView.hidden = YES;
            yearview.hidden= YES;
            
            NSString * num =[NSString stringWithFormat:@"%d", yframe];
            [saveCardView[2].layer setValue:num forKeyPath:@"frame.origin.y"];
            num =[NSString stringWithFormat:@"%d",yframe2];
            [saveCardView[3].layer setValue:num forKeyPath:@"frame.origin.y"];
        
            [saveBtn.layer setValue:@265 forKeyPath:@"frame.origin.y"];
            
            if (removeBtn)
            {
            
                [removeBtn.layer setValue:@265 forKeyPath:@"frame.origin.y"];
            }
        }
        
        [self reloadInputViews];
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
    
    [self.view endEditing:YES];
    
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

#pragma mark - 是否默认支付卡
- (void)defaultBtnAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    defaultCard = sender.selected? @"1" : @"0";
    NSLog(@"defaultCard selected %d",sender.selected);
}

#pragma mark - 是否默认收款卡
- (void)defaultBtnAction2:(UIButton *)sender
{
    sender.selected = !sender.selected;
    defaultPayment = sender.selected? @"1" : @"0";
    NSLog(@"defaultPayment selected2 %d",sender.selected);
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
    /*保存处理 bankTFstr cardTFstr
    saveCardView[1].infoText.text= nil;
    creditCardView[1].infoText.text= nil;*/
    
    month = month? month : @" ";
    year = year? year : @" ";
    //是否选择默认银行卡
    defaultCard = defaultCard? defaultCard : @"0 ";
    defaultPayment = defaultPayment? defaultPayment : @"0";/*雨*/
  
    cardTFstr= creditCardView[1].infoText.text;
    NSString *bkcardidcard = cardTFstr? cardTFstr : @" ";
    
    //当前输入的卡号长度
    if (![NLUtils checkInterNum:bankTFstr] || bankTFstr.length < 14)
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
                                                                              bkcardbank:saveCardView[0].infoText.text bkcardno:bankTFstr
                                                                           bkcardbankman:saveCardView[2].infoText.text
                                                                         bkcardbankphone:saveCardView[3].infoText.text
                                                                           bkcardyxmonth:month
                                                                            bkcardyxyear:year
                                                                               bkcardcvv:creditCardView[0].infoText.text
                                                                            bkcardidcard:bkcardidcard
                                                                          bkcardcardtype:currentCard
                                                                         bkcardisdefault:defaultCard
                                                                  bkcardisdefaultPayment:defaultPayment];
        NSLog(@"编辑保存   支付：%@  付款：%@",defaultCard,defaultPayment);
        
    }
    else
    {
        NSString *name = [NLUtils getNameForRequest:Notify_ApiAuthorKuaibkcardInfoAdd];
        REGISTER_NOTIFY_OBSERVER(self, checkDataForNewCard, name);
        [[[NLProtocolRequest alloc] initWithRegister:YES] getApiAuthorKuaibkcardInfoAdd:bankID
                                                                             bkcardbank:saveCardView[0].infoText.text
                                                                               bkcardno:bankTFstr
                                                                          bkcardbankman:saveCardView[2].infoText.text
                                                                        bkcardbankphone:saveCardView[3].infoText.text
                                                                          bkcardyxmonth:month
                                                                           bkcardyxyear:year
                                                                              bkcardcvv:creditCardView[0].infoText.text
                                                                           bkcardidcard:bkcardidcard
                                                                         bkcardcardtype:currentCard
                                                                        bkcardisdefault:defaultCard
                                                                 bkcardisdefaultPayment:defaultPayment];
        
        NSLog(@"新增   支付：%@  付款：%@",defaultCard,defaultPayment);
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













