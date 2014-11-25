//
//  TransferInfoController.m
//  TongFubao
//
//  Created by Delpan on 14-9-24.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "TransferInfoController.h"

@interface TransferInfoController () <UITextFieldDelegate, NLBankLisDelegate, VisaReaderDelegate>
{
    NLProgressHUD  *_hud;
    //当前高度
    NSInteger currentHeight;
    //当前屏幕y
    NSInteger currentY;
    //滑动底图
    UIScrollView *basicView;
    //卡信息
    TransferInfoView *infoView[4];
    //手续费文本底图
    UIView *poundageBasicView;
    //手续费文本
    UILabel *poundageLabel[3];
    //刷卡器
    VisaReader *visaReader;
    //显示刷卡器状态
    UIImageView *cardImageView;
    //刷卡器启动图片
    UIImage *availableImage;
    //刷卡器停用图片
    UIImage *unavailableImage;
    //支付金额
    UILabel *paymentLabel;
    //卡信息
    NSArray *visaInfos;
    //总金额
    NSString *sumPay;
    //手续费
    NSString *payfee;
    //到账日期
    NSString *arriveid;
    //所属银行ID
    NSString *bankID;
    //新卡
    BOOL newCard;
    //正确金额
    BOOL payMoney;
}

@end

@implementation TransferInfoController

- (id)initWithNewCard:(BOOL)newCard_
{
    if (self = [super init])
    {
        newCard = newCard_;
    }
    
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [NLUtils enableSliderViewController:NO];
    
    if (visaReader)
    {
        [visaReader resetVisaReader:YES];
    }
    
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [NLUtils enableSliderViewController:YES];
    
    if (visaReader)
    {
        [visaReader resetVisaReader:NO];
    }
    
    [super viewWillDisappear:animated];
}

-(void)initVisaReader
{
    visaReader = [VisaReader initWithDelegate:self];
    [visaReader createVisaReader];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    
    ViewControllerProperty;
    
#endif
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //获取当前屏幕size
    currentHeight = iphoneSize;
    
    //初始化视图
    [self initView];
    //初始化刷卡器
    [self initVisaReader];
}

#pragma mark - 初始化视图
- (void)initView
{
    //当前屏幕Y
    currentY = 0;
    
    bankID = [_dataDic objectForKey:@"bankid"];
    
    //刷卡器启动图片
    availableImage = imageName(@"swipingCard2@2x", @"png");
    //刷卡器停用图片
    unavailableImage = imageName(@"swipingCard@2x", @"png");
    
#pragma mark 收款人信息(UI)
    
    //滑动底图
    if (!basicView)
    {
        basicView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SelfWidth, currentHeight - 64)];
        basicView.contentSize = CGSizeMake(SelfWidth, currentHeight);
        [self.view addSubview:basicView];
    }
    
    if (!_dataDic)
    {
        _dataDic = [NSMutableDictionary dictionary];
    }
    
    //收款人信息
    UILabel *payeeLabel = [UILabel labelWithFrame:CGRectMake(10, currentY + 10, 200, 15)
                                  backgroundColor:[UIColor clearColor]
                                        textColor:[UIColor blackColor]
                                             text:@"收款账户信息"
                                             font:[UIFont systemFontOfSize:15.0]];
    [basicView addSubview:payeeLabel];
    currentY += 20;
    
    //标题
    NSArray *infoTitles = @[ @"账户", @"银行", @"姓名", @"金额" ];
    //输入框提示
    NSArray *infoTexts = @[ @"请刷卡或输入卡号", @"请选择银行", @"请输入姓名", @"请输入金额" ];
    
    /*卡背景图*/
    UIView *infoBasicView = [UIView viewWithFrame:CGRectMake(10, currentY + 20, SelfWidth - 20, 200)];
    infoBasicView.layer.borderColor = [UIColor grayColor].CGColor;
    infoBasicView.layer.borderWidth = 0.5;
    infoBasicView.layer.cornerRadius = 5.0;
    [basicView addSubview:infoBasicView];
    currentY += 220;
    
    for (int i = 0; i < 4; i++)
    {
        //添加分隔线
        if (i > 0)
        {
            UIImageView *lineView = [UIImageView viewWithFrame:CGRectMake(0, 50 * i, 300, 1) image:imageName(@"line1@2x", @"png")];
            [infoBasicView addSubview:lineView];
        }
        
        //卡信息
        infoView[i] = [[TransferInfoView alloc] initWithFrame:CGRectMake(0, 50 * i, 300, 40)];
        infoView[i].titleLabel.text = infoTitles[i];
        infoView[i].infoText.placeholder = infoTexts[i];
        infoView[i].infoText.delegate = self;
        infoView[i].infoText.tag = 3601 + i;
        infoView[i].infoText.font = [UIFont systemFontOfSize:15.0];
        infoView[i].infoText.text = i == 0? ([_dataDic objectForKey:@"shoucardno"]? [_dataDic objectForKey:@"shoucardno"] : @"") : i == 1? ([_dataDic objectForKey:@"shoucardbank"]? [_dataDic objectForKey:@"shoucardbank"] : @"") : i == 2? ([_dataDic objectForKey:@"shoucardman"]? [_dataDic objectForKey:@"shoucardman"] : @"") : @"";
        infoView[i].infoText.keyboardType = i == 0 || i == 3? UIKeyboardTypeNumberPad : UIKeyboardTypeDefault;
        [infoBasicView addSubview:infoView[i]];
        
        //刷卡器视图
        if (i == 0)
        {
            cardImageView = [UIImageView viewWithFrame:CGRectMake(260, 5, 30, 30) image:unavailableImage];
            [infoView[i] addSubview:cardImageView];
        }
        
        if (i == 1)
        {
            /*点击箭头*/
            UIImageView *changeView = [UIImageView viewWithFrame:CGRectMake(260, 15, 15, 15) image:imageName(@"nextlink_pla@2x", @"png")];
            [infoView[i] addSubview:changeView];
        }
 
}
    
#pragma mark 手续费信息(UI)
    //手续费文本底图
  
    poundageBasicView = [UIView viewWithFrame:CGRectMake(10, currentY + 10, 300, 120)];
    poundageBasicView.opaque = YES;
    [basicView addSubview:poundageBasicView];
    currentY += 130;
    
    //手续费信息
    NSArray *poundageInfos = @[ @"到账时间", @"手续费", @"支付金额" ];
    
    //手续费信息
    for (int i = 0; i < poundageInfos.count; i++)
    {
        UILabel *infoLabel = [UILabel labelWithFrame:CGRectMake(10, 35 * i, 100, 30)
                                     backgroundColor:[UIColor clearColor]
                                           textColor:[UIColor blackColor]
                                                text:poundageInfos[i]
                                                font:[UIFont systemFontOfSize:18.0]];
        [poundageBasicView addSubview:infoLabel];
    }
    
    /*就显示T+0 T+1的 不影响下面请求显示的代码*/
    UILabel* paytimeOn = [[UILabel alloc] initWithFrame:CGRectMake(140, 0 , 140, 40)];
    paytimeOn.opaque = YES;
    paytimeOn.backgroundColor = [UIColor clearColor];
    paytimeOn.textColor = [UIColor grayColor];
    paytimeOn.text= [self.title isEqualToString:@"超级转账"]? @"T + 0" : @"T + 1";
    paytimeOn.textAlignment= NSTextAlignmentRight;
    paytimeOn.font = [UIFont systemFontOfSize:18.0];
    paytimeOn.numberOfLines = 0;
    [poundageBasicView addSubview:paytimeOn];
    
    //确定按钮
    UIButton *enterBtn = [UIButton buttonWithFrame:CGRectMake(20, 370, 280, 40)
                                     unSelectImage:imageName(@"yellow_button@2x", @"png")
                                       selectImage:nil
                                               tag:100000
                                        titleColor:[UIColor whiteColor]
                                             title:@"下一步"];
    enterBtn.layer.cornerRadius = 5.0;
    enterBtn.layer.masksToBounds = YES;
    [enterBtn addTarget:self action:@selector(enterBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [basicView addSubview:enterBtn];
}

#pragma mark - TextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 3604)
    {
        if (![textField.text isEqualToString:@""])
        {
            [self showErrorInfo:@"请稍候" status:NLHUDState_None];
            
            //请求参数
            NSDictionary *dic = @{ @"bankid" : [_dataDic objectForKey:@"bankid"]? [_dataDic objectForKey:@"bankid"] : @"",
                                   @"money" : textField.text,
                                   @"arriveid" : ([_dataDic objectForKey:@"arriveid"]? [_dataDic objectForKey:@"arriveid"] : @"") };
            
            //apiFunc
            NSString *apiFunc = [self.title isEqualToString:@"超级转账"]? @"getSupTransferPayfee" : @"getTransferPayfee";
            
#pragma mark 手续费数据请求
            [LoadDataWithASI loadDataWithMsgbody:dic apiName:@"ApiPayinfo" apiNameFunc:apiFunc rolePath:@"//operation_response/msgbody/msgchild" type:PublicCommon completionBlock:^(id data, NSError *error) {
                
                if (data)
                {
                    //到账日期
                    arriveid = [data objectForKey:@"arriveid"];
                }
            }];
            
            //数据请求
            [LoadDataWithASI loadDataWithMsgbody:dic apiName:@"ApiPayinfo" apiNameFunc:apiFunc rolePath:@"//operation_response/msgbody" type:PublicCommon completionBlock:^(id data, NSError *error) {
                
                [_hud hide:YES];
                
                if (data)
                {
                    if ([[data objectForKey:@"result"] isEqualToString:@"failure"])
                    {
                        payMoney = NO;
                        
                        [self showError:[data objectForKey:@"message"]];
                    }
                    else
                    {
                        payMoney = YES;
                        
                        //手续费数据
                        NSArray *poundageDatas = @[ ([self.title isEqualToString:@"超级转账"]? @"T + 0" : @"T + 1"),
                                                    [NSString stringWithFormat:@"￥%.2f", [[data objectForKey:@"payfee"] floatValue]],
                                                    [NSString stringWithFormat:@"￥%.2f", ([infoView[3].infoText.text floatValue] + [[data objectForKey:@"payfee"] floatValue])] ];
                        //总金额
                        sumPay = [NSString stringWithFormat:@"%.2f",([infoView[3].infoText.text floatValue] + [[data objectForKey:@"payfee"] floatValue])];
                        //手续费
                        payfee = [data objectForKey:@"payfee"];
                        
                        if (!poundageLabel[0])
                        {
                            //手续费信息
                            for (int i = 0; i < poundageDatas.count; i++)
                            {
                                //手续费文本
                                poundageLabel[i] = [UILabel labelWithFrame:CGRectMake(140, 35 * i, 140, 40)
                                                           backgroundColor:[UIColor clearColor]
                                                                 textColor:(i < 2? [UIColor grayColor] : RGBACOLOR(222, 148, 12, 1.0))
                                                                      text:poundageDatas[i]
                                                                      font:(i < 2? [UIFont systemFontOfSize:18.0] : [UIFont systemFontOfSize:22.0])];
                                poundageLabel[i].textAlignment = NSTextAlignmentRight;
                                [poundageBasicView addSubview:poundageLabel[i]];
                            }
                        }
                        else
                        {
                            //显示手续费
                            poundageLabel[1].text = [data objectForKey:@"payfee"];
                            //显示总金额
                            poundageLabel[2].text = sumPay;
                        }
                    }
                }
            }];
        }
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    BOOL textEdit = YES;
    
    //是否允许用户交互
    if (textField.tag <= 3603)
    {
        textEdit = newCard? (textField.tag == 3601 || textField.tag == 3603? YES : NO) : NO;
        
        //选择银行
        if (textField.tag == 3602)
        {
            if ([textField.text isEqualToString:@""] || !textField.text)
            {
                [self.view endEditing:YES];
                NLBankListViewController *bankListView = [[NLBankListViewController alloc] initWithNibName:@"NLBankListViewController" bundle:nil];
                bankListView.delegate = self;
                [self.navigationController pushViewController:bankListView animated:YES];
            }
        }
    }
    
    return textEdit;
}

#pragma mark - NLBankLisDelegate
- (void)dataSearch:(NLBankListViewController *)controller didSelectWithObject:(id)aObject withState:(NSString *)state
{
    infoView[1].infoText.text = (NSString *)aObject;
    bankID = state;
}

#pragma mark - VisaReaderDelegate
-(void)doVisaReaderEvent:(SwiperReaderStatus)event object:(NSString*)object
{
//    NSLog(@"event = %d,object = %@",event,object);
    if (newCard)
    {
        if (SRS_DeviceAvailable == event && [object isEqualToString:@"0"])
        {
            cardImageView.image = availableImage;
        }
        else if (SRS_DeviceUnavailable == event)
        {
            cardImageView.image = unavailableImage;
        }
        else if (SRS_OK == event)
        {
            [self doSRSOK:object];
        }
    }
}

#pragma mark -获取刷卡信息
- (void)doSRSOK:(NSString *)info
{
    //卡信息
    visaInfos = [info componentsSeparatedByString:@"***@@@$$$"];
    
    if (visaInfos.count >= 3)
    {
        if (![visaInfos[0] isEqualToString:@""])
        {
            if ([[visaInfos[0] substringToIndex:2] intValue] >0)
            {
                //获取卡号
                infoView[0].infoText.text = visaInfos[0];
                //刷卡器ID
                NSString *paycardid = visaInfos[1];
                
                if (paycardid.length >= 14)
                {
                    paycardid = [paycardid substringToIndex:14];
                    paycardid = [paycardid lowercaseString];
                }
                
                [_dataDic setObject:paycardid forKey:@"paycardid"];
                
                //刷卡验证
                [LoadDataWithASI loadDataWithMsgbody:@{ @"paycardkey" : paycardid, @"bkcardno" : visaInfos[0], @"paytype" : [[[NSUserDefaults standardUserDefaults]objectForKey:BANK_PAYTYPE_CHECK] objectAtIndex:0] } apiName:@"ApiAuthorInfo" apiNameFunc:@"payCardCheck" rolePath:@"//operation_response/msgbody" type:PublicCommon completionBlock:^(id data, NSError *error) {
                    
                    if (data)
                    {
                        //所属银行
                        infoView[1].infoText.text = [data objectForKey:@"bkcardbankname"];
                        //所属银行ID
                        bankID = [data objectForKey:@"bkcardbankid"];
                        //卡主名
                        infoView[2].infoText.text = [data objectForKey:@"bkcardman"];
                    }
                }];
            }
        }
    }
}

#pragma mark - 下一步触发
- (void)enterBtnAction:(UIButton *)sender
{
    if (payMoney)
    {
        NSString *checkString = [self checkWithInfo];
        
        if (!checkString)
        {
            NLTransferThirdViewController *thirdView = [[NLTransferThirdViewController alloc] initWithNibName:@"NLTransferThirdViewController" bundle:nil];
            
            thirdView.myDictionary = @{ @"shoucardmemo" : @"",
                                        @"arriveidStr" : [NSString stringWithFormat:@"工作日%@", ([self.title isEqualToString:@"超级转账"]? @"T + 0" : @"T + 1")],
                                        @"arriveid" : (arriveid? arriveid : @""),
                                        @"shoucardman" : infoView[2].infoText.text,
                                        @"shoucardmobile" : @"",
                                        @"money" : sumPay,
                                        @"payfee" : payfee,
                                        @"paymoney" : infoView[3].infoText.text,
                                        @"shoucardbank" : infoView[1].infoText.text,
                                        @"shoucardno" : infoView[0].infoText.text,
                                        @"sendsms" : @"1",
                                        @"transferType" : ([self.title isEqualToString:@"超级转账"]? @"1" : @"0"),
                                        @"cardReaderId" : ([_dataDic objectForKey:@"paycardid"]? [_dataDic objectForKey:@"paycardid"] : @""),
                                        @"receiveBankCardId" : bankID };
            
            [self.navigationController pushViewController:thirdView animated:YES];
        }
        else
        {
            [self showError:checkString];
        }
    }
    else
    {
        [self showError:@"请输入正确金额"];
    }
}

#pragma mark - 信息检测
- (NSString *)checkWithInfo
{
    //账号
    if (infoView[0].infoText.text.length == 0 || [infoView[0].infoText.text isEqualToString:@""])
    {
        return @"请输入账号";
    }
    
    //银行
    if (infoView[1].infoText.text.length == 0 || [infoView[1].infoText.text isEqualToString:@""])
    {
        return @"请选择银行";
    }
    
    //姓名
    if (infoView[2].infoText.text.length == 0 || [infoView[2].infoText.text isEqualToString:@""])
    {
        return @"输入姓名";
    }
    
    //金额
    if (infoView[3].infoText.text.length == 0 || [infoView[3].infoText.text isEqualToString:@""])
    {
        return @"请输入金额";
    }
    
    return nil;
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

























