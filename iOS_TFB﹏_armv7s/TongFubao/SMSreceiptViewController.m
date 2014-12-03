//
//  SMSreceiptViewController.m
//  TongFubao
//
//  Created by 通付宝MAC on 14-11-5.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "SMSreceiptViewController.h"
#import "NLAppDelegate.h"
#import "PaomaLabel.h"
#import "SMSTradingNoticeViewController.h"
#import "SMSPaymentHistoryTableViewController.h"
#import "SMSBankCardViewController.h"
#import "NLShowTextViewController.h"
#import "SMSAddBankCardViewController.h"

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBookUI/ABPeoplePickerNavigationController.h>

#import "SSCheckBoxView.h"
#import "XIAOYU_TheControlPackage.h"

@interface SMSreceiptViewController ()<UIAlertViewDelegate,UITextFieldDelegate,ABPeoplePickerNavigationControllerDelegate,BankCardDelegate,addBankCardDelegate,paymentHistoryDelegate>{

    NLProgressHUD *_hud;
    PaomaLabel *aUILabel;
    UITextField *textFields[4];
}

@property(strong,nonatomic)NSMutableArray *arrayIndex;

@property (weak, nonatomic) IBOutlet UILabel *nameOfBank;//银行名称
@property (weak, nonatomic) IBOutlet UILabel *accountName;//开户名
@property (weak, nonatomic) IBOutlet UILabel *tailNumber;//尾号
@property (weak, nonatomic) IBOutlet UILabel *category;//银行卡类别
@property (weak, nonatomic) IBOutlet UIImageView *bankLOGO;//银行LOGO
@property (weak, nonatomic) IBOutlet UIButton *initiateCollection;//发起收款
@property(strong,nonatomic)NSString *bankCardNumberStr;//全局银行卡号
@property(strong,nonatomic)NSString *bankPhoneStr;//全局预留银行电话号码

@property(strong,nonatomic)UILabel *labels;//输入框前面的标签

@property(strong,nonatomic)UITextField *textFieldFee;//手续费

@property(strong,nonatomic)UIAlertView *alertView;//弹窗

@property(strong,nonatomic)SSCheckBoxView *checkBox;//单选按钮


@property(strong,nonatomic)NSString *phoneString;
@property(strong,nonatomic)NSString *paymentAmountString;
@property(strong,nonatomic)NSString *theMessageString;

@property(strong,nonatomic)NSString *accountNumbers;//全局变量 接收银行卡号

@end

@implementation SMSreceiptViewController

-(void)tapleftBarButtonItemBack{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}


#pragma mark - 收款历史记录 协议代理方法
-(void)agent:(SMSPaymentHistoryTableViewController *)vc paymentHistoryPhone:(NSString *)phone{
    
    NSLog(@"收款历史记录 %@",phone);
    self.phoneString = phone;
    textFields[0].text = [NSString stringWithFormat:@"%@",phone];
}



#pragma mark - 新增银行卡 协议代理方法
-(void)agent:(SMSAddBankCardViewController *)vc Refresh:(BOOL)refresh theOpeningBankString:(NSString *)theOpeningBankString creditCard:(NSString *)creditCard name:(NSString *)name phone:(NSString *)phone identity:(NSString *)identity ccv:(NSString *)ccv month:(NSString *)month years:(NSString *)years{
    
    self.bankCardNumberStr = creditCard;//银行卡号
    self.bankPhoneStr = phone;//预留电话
    
    NSString *cardNumbe = creditCard.length > 4? [creditCard substringFromIndex:(creditCard.length - 4)] : @" ";
    
    self.nameOfBank.text = theOpeningBankString;//银行名称
    self.accountName.text = name;//开户名
    self.tailNumber.text = [NSString stringWithFormat:@"尾号:%@",cardNumbe];//尾号
    self.accountNumbers = [NSString stringWithFormat:@"%@",creditCard];
    self.category.text = ccv?@"信用卡":@"储蓄卡";//银行卡类别
    
    //银行LOGO
    NSString *names = [NLUtils getNameForRequest:Notify_ApiAuthorKuaibkcardInfoLists];
    REGISTER_NOTIFY_OBSERVER(self, checkDataForCardListsLogo, names);
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApiAuthorKuaibkcardInfoLists];
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    
    
}


- (void)checkDataForCardListsLogo:(NSNotification *)notify
{
    NLProtocolResponse *response = (NLProtocolResponse *)notify.object;
    int error = response.errcode;
    
    if (error == RSP_NO_ERROR)
    {
        [_hud hide:YES];
        [self getApiAuthorKuaibkcardInfoListsWithResponseLogo:response];
    }
    else
    {
        [_hud hide:YES];
        NSString *string = response.detail;
        NSLog(@"string = %@",string);
        
    }
}

- (void)getApiAuthorKuaibkcardInfoListsWithResponseLogo:(NLProtocolResponse *)response
{
    //获取数据标记，判断是否请求成功
    NLProtocolData *data = [response.data find:@"msgbody/result" index:0];
    NSString *result = data.value;
    
    NSRange range = [result rangeOfString:@"succ"];
    
    if (range.length <= 0)
    {
        //获取错误信息
        NLProtocolData *errorData = [response.data find:@"msgbody/message" index:0];
        
        NSLog(@"errorData = %@", errorData);
    }
    else
    {
        //默认付款卡
        NSArray *bkcardshoudefault = [response.data find:@"msgbody/msgchild/bkcardshoudefault"];
        
        for (int i=0; i<bkcardshoudefault.count; i++)
        {
            NLProtocolData *bkcardshoudefaultData = bkcardshoudefault[i];
            NSLog(@"是否为默认收款卡 %@",bkcardshoudefaultData.value);
            
            //如果有默认卡
            if ([bkcardshoudefaultData.value isEqualToString:@"1"])
            {
                
                //银行logo
                NSArray *bkcardbanklogos = [response.data find:@"msgbody/msgchild/bkcardbanklogo"];
                NLProtocolData *bkcardbanklogosData = bkcardbanklogos[i];//银行logo
                self.bankLOGO.image = [UIImage imageNamed:bkcardbanklogosData.value];
            }
        }
    }
}




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.title = @"短信收款";

    }
    return self;
}




-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"即将离开界面 键盘已收起");
    for (int i=0; i<4; i++) {
        [textFields[i] resignFirstResponder];
    }
//    [self.view endEditing:YES];
    [super viewWillDisappear:animated];
}


-(void)showErrorInfoDefaultPaymentCard:(NSString*)error status:(NLHUDState)status
{
    [_hud hide:YES];
    _hud = [[NLProgressHUD alloc] initWithParentView: self.view];
    
    switch (status)
    {
        case NLHUDState_Error:
        {
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unCheckmark.png"]] ;//失败
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.detailsLabelText = error;
            [_hud show:YES];
            [_hud hide:YES afterDelay:2];
        }
            break;
            
        case NLHUDState_NoError:
        {
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.png"]] ;//成功
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.labelText = error;
            [_hud show:YES];
            [_hud hide:YES afterDelay:2];
        }
            break;
            
        case NLHUDState_None:
        {
            [self theDefaultPaymentCard];//检测是否有默认收款卡
            
            _hud.labelText = error;
            [_hud show:YES];
        }
            break;
            
        default:
            break;
    }
    return;
}


#pragma mark - 检测是否有默认收款卡
-(void)theDefaultPaymentCard{
    NSLog(@"正在检测是否有默认收款卡");
    
    NSDictionary *dataDictionary = @{@"bkcardshoudefault" : @"1"};
    
    NSLog(@"传的参数 :%@",dataDictionary);
    
    [LoadDataWithASI loadDataWithMsgbody:dataDictionary apiName:@"ApiPaychannelInfo" apiNameFunc:@"readKuaipaybkcardInfo" rolePath:@"//operation_response/msgbody/msgchild" type:PublicList completionBlock:^(id data, NSError *error)
     {
         [_hud hide:YES];
         
         //没有默认卡
         if ([[data valueForKey:@"bkcardno"] objectAtIndex:0] == nil) {

              NSLog(@"没有默认银行卡数据获取");
             //如果没有绑定银行卡
             if (!self.alertView) {
                 [self SMSReceiptAlertView];//弹窗 提示添加默认卡
             }
             
         //有默认卡
         }else{
             
             NSLog(@"解析到的默认银行卡 :%@",data);
             
             for (NSDictionary *dic in data) {
 
//             NSString *bkcardshoudefault = [dic objectForKey:@"bkcardisdefault"];//默认银行卡号 1:默认 0:非默认
             
                 self.bankLOGO.image = [UIImage imageNamed:[dic objectForKey:@"bkcardbanklogo"]] ;//银行LOGO
                 
                 self.bankCardNumberStr = [dic objectForKey:@"bkcardno"];//银行卡号 传参用
                 self.accountNumbers = [dic objectForKey:@"bkcardno"];//银行卡号 传值用
             
                 self.bankPhoneStr = [dic objectForKey:@"bkcardbankphone"];//预留电话

                 NSString *cardNumbe = self.bankCardNumberStr.length > 4? [self.bankCardNumberStr substringFromIndex:(self.bankCardNumberStr.length - 4)] : @" ";
                 self.tailNumber.text = [NSString stringWithFormat:@"尾号:%@",cardNumbe];//尾号

                 self.nameOfBank.text = [dic objectForKey:@"bkcardbank"];//银行名称
                 self.accountName.text = [dic objectForKey:@"bkcardbankman"];//开户名
             
                 NSString *bkcardcardtypesStr = [dic objectForKey:@"bkcardcardtype"];//银行卡类型
             
                 if ([bkcardcardtypesStr isEqualToString:@"bankcard"]) {
                    self.category.text = [NSString stringWithFormat:@"%@",@"储蓄卡" ];
                }else if ([bkcardcardtypesStr isEqualToString:@"creditcard"]){
                    self.category.text = [NSString stringWithFormat:@"%@",@"信用卡" ];
                }else if ([bkcardcardtypesStr isEqualToString:@"x"]){
                    self.category.text = [NSString stringWithFormat:@"%@",@"信用卡" ];
                }else{
                    self.category.text = bkcardcardtypesStr;//银行卡类别
                }

             }
         }
     }];
    
    
/*
    NSString *name = [NLUtils getNameForRequest:Notify_ApiAuthorKuaibkcardInfoLists];
    REGISTER_NOTIFY_OBSERVER(self, checkDataForCardLists, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApiAuthorKuaibkcardInfoLists];
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
*/
 
}

/*
- (void)checkDataForCardLists:(NSNotification *)notify
{
    NLProtocolResponse *response = (NLProtocolResponse *)notify.object;
    int error = response.errcode;
    
    if (error == RSP_NO_ERROR)
    {
        [_hud hide:YES];
        [self getApiAuthorKuaibkcardInfoListsWithResponse:response];
    }
    else
    {
        [_hud hide:YES];
        NSString *string = response.detail;
        NSLog(@"string = %@",string);
        
        //如果没有绑定银行卡
        if (!self.alertView) {
            [self SMSReceiptAlertView];//弹窗 提示添加默认卡
                
        }
    }
}

 
 
- (void)getApiAuthorKuaibkcardInfoListsWithResponse:(NLProtocolResponse *)response
{
    //获取数据标记，判断是否请求成功
    NLProtocolData *data = [response.data find:@"msgbody/result" index:0];
    NSString *result = data.value;
    
    NSRange range = [result rangeOfString:@"succ"];
    
    if (range.length <= 0)
    {
        //获取错误信息
        NLProtocolData *errorData = [response.data find:@"msgbody/message" index:0];
        
        NSLog(@"errorData = %@", errorData);
    }
    else
    {
        
        //默认付款卡
        NSArray *bkcardshoudefault = [response.data find:@"msgbody/msgchild/bkcardshoudefault"];

        for (int i=0; i<bkcardshoudefault.count; i++)
        {
            NLProtocolData *bkcardshoudefaultData = bkcardshoudefault[i];
            NSLog(@"是否为默认收款卡 %@",bkcardshoudefaultData.value);
            
            if (bkcardshoudefaultData.value == nil) {
                bkcardshoudefaultData.value = [NSString stringWithFormat:@"%@",@"0"];
            }

            [self.arrayIndex addObject:bkcardshoudefaultData.value];
            
            //如果有默认卡
            if ([bkcardshoudefaultData.value isEqualToString:@"1"])
            {
                
                //银行logo
                NSArray *bkcardbanklogos = [response.data find:@"msgbody/msgchild/bkcardbanklogo"];
                //银行卡名
                NSArray *bkcardbanks = [response.data find:@"msgbody/msgchild/bkcardbank"];
                //用户名
                NSArray *bkcardbankmans = [response.data find:@"msgbody/msgchild/bkcardbankman"];
                //卡号
                NSArray *bkcardnos = [response.data find:@"msgbody/msgchild/bkcardno"];
                //卡类型
                NSArray *bkcardcardtypes = [response.data find:@"msgbody/msgchild/bkcardcardtype"];
                //预留电话
                NSArray *bkcardbankphones = [response.data find:@"msgbody/msgchild/bkcardbankphone"];
            
            
                NLProtocolData *bkcardbanklogosData = bkcardbanklogos[i];//银行logo
                NLProtocolData *bkcardbanksData = bkcardbanks[i];//银行卡名
                NLProtocolData *bkcardbankmansData = bkcardbankmans[i];//用户名
                NLProtocolData *bkcardnosData = bkcardnos[i]; //卡号
                NLProtocolData *bkcardcardtypesData = bkcardcardtypes[i];//卡类型
                NLProtocolData *bkcardbankphonesData = bkcardbankphones[i];//预留电话
            
            
                self.bankCardNumberStr = bkcardnosData.value;//银行卡号
                self.bankPhoneStr = bkcardbankphonesData.value;//预留电话
            
                NSString *cardNumbe = bkcardnosData.value.length > 4? [bkcardnosData.value substringFromIndex:(bkcardnosData.value.length - 4)] : @" ";
                self.tailNumber.text = [NSString stringWithFormat:@"尾号:%@",cardNumbe];//尾号
                self.accountNumbers = [NSString stringWithFormat:@"%@",bkcardnosData.value];
                self.nameOfBank.text = bkcardbanksData.value;//银行名称
                self.accountName.text = bkcardbankmansData.value;//开户名
                
                if ([bkcardcardtypesData.value isEqualToString:@"bankcard"]) {
                    self.category.text = [NSString stringWithFormat:@"%@",@"储蓄卡" ];
                }else if ([bkcardcardtypesData.value isEqualToString:@"creditcard"]){
                    self.category.text = [NSString stringWithFormat:@"%@",@"信用卡" ];
                }else if ([bkcardcardtypesData.value isEqualToString:@"x"]){
                    self.category.text = [NSString stringWithFormat:@"%@",@"信用卡" ];
                }else{
                    self.category.text = bkcardcardtypesData.value;//银行卡类别
                }
                
                
                self.bankLOGO.image = [UIImage imageNamed:bkcardbanklogosData.value] ;//银行LOGO
            
                NSLog(@"\n银行卡号:%@\n预留电话:%@\n尾号:%@\n银行名称:%@\n开户名:%@\n卡类别:%@\n LOGO%@",bkcardnosData.value,bkcardbankphonesData.value,cardNumbe,bkcardbanksData.value,bkcardbankmansData.value,bkcardcardtypesData.value,bkcardbanklogosData.value);
            
            }
        }
        //如果没有默认收款卡
        if (![self.arrayIndex containsObject:@"1"]) {
            NSLog(@"开始弹窗");
            //这个方法可能会进来多次 加个判断不会重复弹窗
            if (!self.alertView) {
                [self SMSReceiptAlertView];//弹窗 提示添加默认卡
                
            }
        }
    }
}

*/

-(NSString *)checkInfo:(NSString *)str
{
    if (str == nil)
    {
        return @"未知";
    }
    else
    {
        return str;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.arrayIndex = [[NSMutableArray alloc]init];

    
    self.navigationItem.leftBarButtonItem = [self leftBarButtonItem];
    
    [self showErrorInfoDefaultPaymentCard:@"请稍后" status:NLHUDState_None];//检测是否有默认收款卡

    [self PaymentHistoryButtonItem];//收款历史
    [self SMSReceiptTextField];//所有输入框
    [self RadioButton];
    
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width,self.view.frame.size.height+50)];
    
    self.scrollView.backgroundColor = RGBACOLOR(246, 250, 252, 1);
    
 
    [self paoMaDing];//跑马灯效果
    
    

}


#pragma mark - 跑马灯效果
-(void)paoMaDing{
    
    aUILabel= [[PaomaLabel alloc]init];
    [aUILabel setFrame:CGRectMake(0, 11, textFields[1].frame.size.width, 21)];
    aUILabel.font = [UIFont fontWithName:nil size:16];
    aUILabel.text= @"          限单笔5,000.00，日累计20,000.00";
    aUILabel.textColor= RGBACOLOR(189, 189, 196, 1);
    aUILabel.userInteractionEnabled = YES;
    [textFields[1] addSubview:aUILabel];
    
}


#pragma mark - 收款历史
-(void)PaymentHistoryButtonItem{
    
    [self rightButtonItemWithTitle:@"收款历史" Frame:CGRectMake(0, 0, 70, 28) backgroundImage:[UIImage imageNamed:@"SMS_historybtn_normal@2x"] backgroundImageHighlighted:[UIImage imageNamed:@"SMS_historybtn_pressed@2x"]];

}


#pragma mark - 跳转收款历史
-(void)tapRightButtonItem:(id)sender{
    
    SMSPaymentHistoryTableViewController *vc = [[SMSPaymentHistoryTableViewController alloc]init];
    vc.delegate = self;
    [self jumpViewController:self newViewController:vc PushAndPresent:YES];

}






#pragma mark - 输入框
-(void)SMSReceiptTextField{

    UIImageView *vc = [[UIImageView alloc]initWithFrame:CGRectMake(5,13 , 310, 200)];//78
    vc.image = [UIImage imageNamed:@"SMS_1.png"];
//    vc.layer.cornerRadius = 6;
//    vc.layer.masksToBounds = YES;
    vc.userInteractionEnabled = YES;
    [self.scrollView addSubview:vc];
    
    for (int i=0; i<4; i++) {
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 7+(41+7)*i, 296, 41)];
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.layer.cornerRadius = 6;
        imageView.layer.masksToBounds = YES;
        [vc addSubview:imageView];
        
        textFields[i] = [[UITextField alloc]initWithFrame:CGRectMake(122, 7+(41+7)*i, 178, 41)];
        [textFields[i] setFont:[UIFont fontWithName:nil size:16]];
        textFields[i].delegate = self;
        textFields[i].backgroundColor = [UIColor whiteColor];
        textFields[i].textColor= RGBACOLOR(131, 131, 131, 1);
        textFields[i].tag = 7000+i;
        textFields[i].layer.cornerRadius = 6;
        textFields[i].layer.masksToBounds = YES;
        [vc addSubview:textFields[i]];
 
        self.labels= [[UILabel alloc]initWithFrame:CGRectMake(15, 7+(41+7)*i, 105, 41)];
        self.labels.textColor= RGBACOLOR(62, 62, 62, 1);
        [self.labels setFont:[UIFont fontWithName:nil size:17]];
        self.labels.tag = 7000+i;
        self.labels.layer.cornerRadius = 6;
        self.labels.layer.masksToBounds = YES;
        [self.labels setTextAlignment:NSTextAlignmentLeft];
        self.labels.backgroundColor = [UIColor whiteColor];
        [vc addSubview:self.labels];
        
        switch (self.labels.tag) {
            case 7000:
                self.labels.text = @"对方手机号码";
                break;
            case 7001:
                self.labels.text = @"收款金额(元)";
                break;
            case 7002:
                self.labels.text = @"手续费(元)";
                self.labels.textColor= RGBACOLOR(160, 160, 160, 1);
                break;
            case 7003:
                self.labels.text = @"留言";
                self.labels.frame = CGRectMake(15, 151, 40, 41);
                break;
                
            default:
                break;
        }
        
        
        switch (textFields[i].tag) {
            case 7000:
                textFields[0].placeholder = @"请输入电话号码";
                [self phoneButton];
                textFields[0].keyboardType = UIKeyboardTypeNumberPad;
                //                self.textFields.returnKeyType = UIReturnKeyDefault;
                [textFields[0] addTarget:self action:@selector(phoneTextEditingChanged:) forControlEvents:UIControlEventEditingChanged];
                break;
            case 7001:
//                textFields[1].placeholder = @"限单笔5千,日累计限2万";
                //@"限单笔5,000.00，日累计20,000.00"
                textFields[1].keyboardType = UIKeyboardTypeDecimalPad;
                [textFields[1] addTarget:self action:@selector(receivablesTextEditingChanged:) forControlEvents:UIControlEventEditingChanged];
                
                break;
            case 7002:
                textFields[2].userInteractionEnabled = NO;
                [self feeTextField];
                break;
            case 7003:
                textFields[3].frame = CGRectMake(60, 151, 240, 41);
                textFields[3].placeholder = @"限20个汉字(如:请付12月份贷款)";
                textFields[3].keyboardType = UIKeyboardTypeDefault;
                [textFields[3] addTarget:self action:@selector(theMessageTextEditingChanged:) forControlEvents:UIControlEventEditingChanged];
                break;
                
            default:
                break;
        }
        
    }
    
}


#pragma mark - 电话号码限制为11个字符
-(void)phoneTextEditingChanged:(UITextField *)textField
{
    if ([textField.text length]>11) {
        textField.text=[textField.text substringToIndex:11];
        self.phoneString = [ self.phoneString substringWithRange:NSMakeRange(0,11)];
        NSLog(@"截取到的手机号码 :%@",self.phoneString);
    }else{
        self.phoneString = [NSString stringWithFormat:@"%@",textField.text];
        NSLog(@"对方手机号码 :%@", self.phoneString);
    }

}


#pragma mark - 金额
-(void)receivablesTextEditingChanged:(UITextField *)textField{
    
    //跑马灯效果开关
    if (textField.text.length >0) {
        aUILabel.alpha = 0;
    }else{
        aUILabel.alpha = 1;
    }
    
    
    if ([textField.text intValue]>=5001) {
        self.paymentAmountString = [NSString stringWithFormat:@"%@",textField.text];
        NSLog(@"已经超出最高收款金额 :%@",self.theMessageString);
    }else{
        self.paymentAmountString= [NSString stringWithFormat:@"%@",textField.text];
        NSLog(@"收款金额 :%@",self.paymentAmountString);
    }
    
    if (![textField.text isEqualToString:@""]) {
        NSDictionary *dataDictionary = @{ @"money" : textFields[1].text};
        
        NSLog(@"手续费传的参数 :%@",textFields[1].text);
        
        [LoadDataWithASI loadDataWithMsgbody:dataDictionary apiName:@"ApiSMSReceiptInfo" apiNameFunc:@"SMSReceiptfee" rolePath:@"//operation_response/msgbody" type:PublicCommon completionBlock:^(NSDictionary *data, NSError *error)
         {
             //失败
             if (![data[@"result"] isEqualToString:@"success"]) {
                 
                 self.textFieldFee.placeholder = @"手续费计算失败 !";
                 
                 //成功
             }else{
                 NSLog(@"解析到的字典 %@ ",data);
                 //根据输入金额计算手续费
                 NSString *payfee = [data objectForKey:@"payfee"];
                 self.textFieldFee.text = payfee;
                 
             }
         }];
    }
}


#pragma mark - 手续费显示框
-(void)feeTextField{

    self.textFieldFee = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, textFields[2].frame.size.width, textFields[2].frame.size.height)];
    [self.textFieldFee setFont:[UIFont fontWithName:nil size:16]];
    self.textFieldFee.userInteractionEnabled = NO;
    self.textFieldFee.placeholder = @"手续费由系统计算";
    self.textFieldFee.backgroundColor = [UIColor whiteColor];
    self.textFieldFee.textColor= RGBACOLOR(131, 131, 131, 1);
    self.textFieldFee.userInteractionEnabled = NO;
    [textFields[2] addSubview:self.textFieldFee];
    
}


#pragma mark - 留言
-(void)theMessageTextEditingChanged:(UITextField *)textField
{
    
    self.theMessageString = [NSString stringWithFormat:@"%@",textField.text];
    NSLog(@"\n已输入字符个数 :%d\n当前留言 :%@",self.theMessageString.length,self.theMessageString);
    
/*
    if ([textField.text length]>20) {
        textField.text=[textField.text substringToIndex:20];
        self.theMessageString = [self.theMessageString substringWithRange:NSMakeRange(0,20)];
        NSLog(@"截取到的留言 :%@",self.theMessageString);
    }else{
        self.theMessageString= [NSString stringWithFormat:@"%@",textField.text];
        NSLog(@"当前留言 :%@",self.theMessageString);
    }
*/
 
}

#pragma mark - 留言限制20个字符
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"进入此方法");
    //手机号码
    if (textField.tag == 7000) {
        
        
        
    //输入金额
    }else if(textField.tag == 7001){
        
        NSScanner      *scanner    = [NSScanner scannerWithString:string];
        NSCharacterSet *numbers;
        NSRange         pointRange = [textField.text rangeOfString:@"."];
        
        if ( (pointRange.length > 0) && (pointRange.location < range.location  || pointRange.location > range.location + range.length) )
        {
            numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        }
        else
        {
            numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
        }
        
        if ( [textField.text isEqualToString:@""] && [string isEqualToString:@"."] )
        {
            return NO;
        }
        
        short remain = 2; //默认保留2位小数
        
        NSString *tempStr = [textField.text stringByAppendingString:string];
        NSUInteger strlen = [tempStr length];
        if(pointRange.length > 0 && pointRange.location > 0){ //判断输入框内是否含有“.”。
            if([string isEqualToString:@"."]){ //当输入框内已经含有“.”时，如果再输入“.”则被视为无效。
                return NO;
            }
            if(strlen > 0 && (strlen - pointRange.location) > remain+1){ //当输入框内已经含有“.”，当字符串长度减去小数点前面的字符串长度大于需要要保留的小数点位数，则视当次输入无效。
                return NO;
            }
        }
        
        NSRange zeroRange = [textField.text rangeOfString:@"0"];
        if(zeroRange.length == 1 && zeroRange.location == 0){ //判断输入框第一个字符是否为“0”
            if(![string isEqualToString:@"0"] && ![string isEqualToString:@"."] && [textField.text length] == 1){ //当输入框只有一个字符并且字符为“0”时，再输入不为“0”或者“.”的字符时，则将此输入替换输入框的这唯一字符。
                textField.text = string;
                return NO;
            }else{
                if(pointRange.length == 0 && pointRange.location > 0){ //当输入框第一个字符为“0”时，并且没有“.”字符时，如果当此输入的字符为“0”，则视当此输入无效。
                    if([string isEqualToString:@"0"]){
                        return NO;
                    }
                }
            }
        }
        
        NSString *buffer;
        if ( ![scanner scanCharactersFromSet:numbers intoString:&buffer] && ([string length] != 0) )
        {
            return NO;
        }
        
        
    //输入留言
    }else if(textField.tag == 7003){
      /*
        if (range.location > 20){
            [self showErrorInfo:@"您输入的留言已超出20字符。" status:NLHUDState_Error];
            [textField resignFirstResponder];
            return NO; // return NO to not change text
            return YES;
       }*/
    }
    return YES;
}



#pragma mark - 获取通讯录
-(void)phoneButton{
    
    UIButton *viewBtn = [[UIButton alloc]initWithFrame:CGRectMake(120, 0, 60, 41)];
    [viewBtn setBackgroundColor:[UIColor clearColor]];
    viewBtn.tag = 7063;
    [viewBtn addTarget:self action:@selector(tapPhone:) forControlEvents:UIControlEventTouchUpInside];
    [textFields[0] addSubview:viewBtn];
    
    UIButton *phone = [[UIButton alloc]initWithFrame:CGRectMake(140, 4, 32, 33)];
    [phone setBackgroundImage:[UIImage imageNamed:@"SMS_phone_book@2x.png"] forState:UIControlStateNormal];
    phone.tag = 7064;
    [phone addTarget:self action:@selector(tapPhone:) forControlEvents:UIControlEventTouchUpInside];
    [textFields[0] addSubview:phone];
}


-(void)tapPhone:(UIButton *)btn{
    
    NSLog(@"选择电话簿");
    
    ABPeoplePickerNavigationController *ppnc = [[ABPeoplePickerNavigationController alloc] init];
    ppnc.peoplePickerDelegate = self;
    [self presentModalViewController:ppnc animated:YES];
}


#pragma mark- 通讯录取值方法

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person{
    
    NSMutableString *number;
    
    NSMutableArray *temparray = [[NSMutableArray alloc] initWithCapacity:1];
    
    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    NSUInteger num = [(__bridge NSMutableArray *)ABMultiValueCopyArrayOfAllValues(phone) count];
    
    if (num >0) {
        for (int i = 0; i<num; i++) {
            number = (__bridge NSMutableString *)ABMultiValueCopyValueAtIndex(phone, i);
            
            [temparray addObject:number];
        }
    }
    //去除电话符
    NSString *originalString = [temparray objectAtIndex:0];
    
    NSMutableString *strippedString = [NSMutableString
                                       stringWithCapacity:originalString.length];
    
    NSScanner *scanner = [NSScanner scannerWithString:originalString];
    NSCharacterSet *numbers = [NSCharacterSet
                               characterSetWithCharactersInString:@"0123456789"];
    while ([scanner isAtEnd] == NO) {
        NSString *buffer;
        if ([scanner scanCharactersFromSet:numbers intoString:&buffer]) {
            [strippedString appendString:buffer];
        }
        else {
            [scanner setScanLocation:([scanner scanLocation] + 1)];
        }
    }
    NSLog(@"取到的电话号码 :%@",strippedString);
    
    self.phoneString = strippedString;
    
    if (self.phoneString.length >0) {
        
        textFields[0].text = [NSString stringWithFormat:@"%@",self.phoneString];

    }
    
    [self dismissModalViewControllerAnimated:YES];
    return NO;
}

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    return NO;
}
-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}







#pragma mark - 弹窗提示
-(void)SMSReceiptAlertView{

   self.alertView = [[UIAlertView alloc]initWithTitle:nil message:@"为了您收款资金及时到账,请您首先设置收款账户信息。该账户将作为您的默认收款账户,如果需要,您可以通过“我的银行卡”菜单进行账户的新增、变更或删除。" delegate:self cancelButtonTitle:@"新增银收款账户" otherButtonTitles:@"选择已有账户", nil];
    self.alertView.tag = 1079;
    [self.alertView show];
    
    NLAppDelegate *delegate = [UIApplication sharedApplication].delegate;
    delegate.alertView = self.alertView;
}


#pragma mark - UIAlertView代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //buttonIndex坐标为1等于确定 为0等于取消
    
    if (alertView.tag == 1079) {
        switch (buttonIndex) {
            case 0:
                
                [self newBankCard];
                
                NSLog(@"新增账户");
                break;
            case 1:
                
                [self theExistingBankAccount];
                
                NSLog(@"默认账户");
                break;
            default:
                break;
        }
    }
    
    NSLog(@"%d",buttonIndex);
}



#pragma mark - 单选按钮
-(void)RadioButton{
    
    //checked=YES?开启:关闭   kSSCheckBoxViewStyleClick/不同的图片
    self.checkBox = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(5, 302, 30, 30) style:kSSCheckBoxViewStyleClick checked:YES];
    [self.checkBox setStateChangedTarget:self selector:@selector(checkBoxViewChangedState:)];
    [self.initiateCollection setSelected:YES];
    [self.scrollView addSubview:self.checkBox];
}

-(void)checkBoxViewChangedState:(SSCheckBoxView*)checkBox{
    
    if(checkBox.checked ){
        
        checkBox.checked = YES;
        [self.initiateCollection setSelected:YES];
        NSLog(@"选中");
    }else{
        
        checkBox.checked = NO;
        [self.initiateCollection setSelected:NO];
        NSLog(@"取消");
    }
}


#pragma mark - 收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
//    [textField resignFirstResponder];
    
    return YES;
    
}


#pragma mark - 银行卡
- (IBAction)tapBankCard:(UIButton *)sender {
    
    [self theExistingBankAccount];
    
    NSLog(@"点击银行卡");
}

#pragma mark - 服务协议
- (IBAction)tapServiceAgreement:(UIButton *)sender {
    
    NSString* name = [NLUtils getNameForRequest:Notify_readAppruleList];
    
    REGISTER_NOTIFY_OBSERVER(self, readAppruleListNotify, name);
    
    NSString* str = [NSString stringWithFormat:@"%d",2];
    
    [[[NLProtocolRequest alloc] initWithRegister:YES] readAppruleList:str];
    
    
    NSLog(@"点击服务协议");
}


-(void)readAppruleListNotify:(NSNotification*)notify

{
    
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    
    int error = response.errcode;
    
    if (error == RSP_NO_ERROR)
        
    {
        
        [_hud hide:YES];
        
        //跳转服务协议方法
        [self serviceAgreement];
        
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






#pragma mark - 发起收款
- (IBAction)tapInitiateCollection:(UIButton *)sender {
    
    if(sender.selected == YES)
    {
        
//   留言     ![self.theMessageString isEqualToString:@""]

        if (self.phoneString.length>0 && self.paymentAmountString.length>0) {
            
             NSLog(@"手机号码: %@    收款金额: %@",self.phoneString,self.paymentAmountString);

            if ([NLUtils checkMobilePhone:self.phoneString] == YES) {
                
                if ([self.paymentAmountString floatValue] >0.00 && [self.paymentAmountString floatValue] <=5000.00) {
                    
                    if (self.theMessageString.length <=20) {
                        
                        if ([self.nameOfBank.text length] >0) {
                            //提交收款
                            NSLog(@"点击发起收款");
                            [self submitReceipts];
                            
                        }else{
                            
                            [self showErrorInfo:@"尚未选择银行卡。" status:NLHUDState_Error];
                        }
                        
                    }else{
                        [self showErrorInfo:@"留言超长,请修改。" status:NLHUDState_Error];
                    }

                }else{

                    [self showErrorInfo:@"收款金额超限，请重新输入或隔日再尝试。目前，短信收款业务单笔交易不超过人民币5,000.00元，日累计不超过人民币20,000.00元。" status:NLHUDState_Error];
                }
            }else{

                [self showErrorInfo:@"请确认您输入的手机号码是否正确。" status:NLHUDState_Error];
            }
            
        }else{

            [self showErrorInfo:@"手机号码/收款金额尚未填写" status:NLHUDState_Error];
        }
        
        
    }else{
        NSLog(@"没有选中服务协议 不能发起收款");
        
        [self showErrorInfo:@"请遵守服务协议再来发起收款。" status:NLHUDState_Error];
        
    }
    
}


#pragma mark - 跳转 默认银行卡
-(void)theExistingBankAccount{
    SMSBankCardViewController *vc = [[SMSBankCardViewController alloc]init];
    vc.delegate = self;
    [self jumpViewController:self newViewController:vc PushAndPresent:YES];
}


#pragma mark - 默认银行卡列表 协议代理方法
-(void)agent:(SMSBankCardViewController *)vc BankName:(NSString *)bankName AccountName:(NSString *)accountName TailNumber:(NSString *)tailNumber Category:(NSString *)category BankLogo:(UIImage *)bankLogo Bankphone:(NSString *)bankphone{
    
    self.bankCardNumberStr = tailNumber;//银行卡号
    self.bankPhoneStr = bankphone;//预留电话
    
    NSString *cardNumbe = tailNumber.length > 4? [tailNumber substringFromIndex:(tailNumber.length - 4)] : @" ";
    
    self.nameOfBank.text = bankName;//银行名称
    self.accountName.text = accountName;//开户名
    self.tailNumber.text = [NSString stringWithFormat:@"尾号:%@",cardNumbe];//尾号
    self.accountNumbers = [NSString stringWithFormat:@"%@",tailNumber];
    self.category.text = category;//银行卡类别
    self.bankLOGO.image = bankLogo;//银行LOGO

}



#pragma mark - 跳转 新增银行卡
-(void)newBankCard{
    SMSAddBankCardViewController *vc = [[SMSAddBankCardViewController alloc]init];
    vc.delegate = self;
    vc.stateIndex = 1;// 1:短信收款主界面  2:短信收款银行卡列表
    [self jumpViewController:self newViewController:vc PushAndPresent:YES];
}


#pragma mark - 跳转 服务协议界面
-(void)serviceAgreement{
    
    NLShowTextViewController* vc = [[NLShowTextViewController alloc] initWithNibName:@"NLShowTextViewController" bundle:nil];
    vc.myType = 7;
    [NLUtils presentModalViewController:self newViewController:vc];
    
  /*
    SMSServiceAgreementViewController *vc = [[SMSServiceAgreementViewController alloc]initWithNibName:@"SMSServiceAgreementViewController" bundle:nil];
    [self jumpViewController:self newViewController:vc PushAndPresent:YES];
  */
}



#pragma mark - 提交短信收款 网络请求
-(void)submitReceipts{
    
    NSDictionary *dataDictionary = @{ @"fumobile" : textFields[0].text, @"money" : textFields[1].text , @"payfee" : self.textFieldFee.text , @"memo" : textFields[3].text, @"shoucardno" : self.bankCardNumberStr ,@"shoucardman" : self.accountName.text ,@"shoucardmobile" : self.bankPhoneStr ,@"shoucardbank" : self.nameOfBank.text};
    
    NSLog(@"传的参数 :%@,%@,%@,%@,%@,%@,%@,%@",textFields[0].text,textFields[1].text,self.textFieldFee.text,textFields[3].text,self.bankCardNumberStr,self.accountName.text,self.bankPhoneStr,self.nameOfBank.text);
    
    [LoadDataWithASI loadDataWithMsgbody:dataDictionary apiName:@"ApiSMSReceiptInfo" apiNameFunc:@"addSMSReceipt" rolePath:@"//operation_response/msgbody" type:PublicCommon completionBlock:^(NSDictionary *data, NSError *error)
     {
         //失败
         if (![data[@"message"] isEqualToString:@"发送成功"]) {
             NSLog(@"收款失败");
            
             if ([data[@"message"] isEqualToString:@"付款手机号码非通付宝会员！"]) {
//                 [self showErrorInfo:@"付款手机号码非通付宝会员!" status:NLHUDState_Error];
                 [self showErrorInfo:data[@"message"] status:NLHUDState_Error];
                 [_hud hide:YES afterDelay:2];
                 
             }else if([data[@"message"] isEqualToString:@"每日交易不能超过20000！"]){
//                 [self showErrorInfo:@"收款金额超限，请重新输入或隔日再尝试。目前，短信收款业务单笔交易不超过人民币5,000.00元，日累计不超过人民币20,000.00元。" status:NLHUDState_Error];
                 [self showErrorInfo:data[@"message"] status:NLHUDState_Error];
                 [_hud hide:YES afterDelay:5];
             
             }else{
                 
                 [self showErrorInfo:@"因网络原因，您当前申请的收款交易未能成功，请你稍后尝试" status:NLHUDState_Error];
                 [_hud hide:YES afterDelay:2];
             }
            
         //成功
         }else{
             NSLog(@"收款成功");
             [self showErrorInfo:@"请稍后" status:NLHUDState_NoError];
             [_hud hide:YES afterDelay:2];
             //跳转交易通知界面
             [self tradingNotice];
         }
     }];
    
    
    
    
    
}
 
 
-(void)showErrorInfo:(NSString*)error status:(NLHUDState)status
{
    [_hud hide:YES];
    _hud = [[NLProgressHUD alloc] initWithParentView: self.view];
    
    switch (status)
    {
        case NLHUDState_Error:
        {
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unCheckmark.png"]] ;//失败
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.detailsLabelText = error;
            [_hud show:YES];
            [_hud hide:YES afterDelay:2];
        }
            break;
            
        case NLHUDState_NoError:
        {
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.png"]] ;//成功
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.labelText = error;
            [_hud show:YES];
            [_hud hide:YES afterDelay:2];
        }
            break;
            
        case NLHUDState_None:
        {
            _hud.labelText = error;
            [_hud show:YES];
        }
            break;
            
        default:
            break;
    }
    return;
}




#pragma mark - 跳转 交易通知界面
-(void)tradingNotice{
    //checkInterNum 判断数字是否合法
    
    NSLog(@"判断里的金额为:%@",self.paymentAmountString);
    SMSTradingNoticeViewController *vc = [[SMSTradingNoticeViewController alloc]initWithNibName:@"SMSTradingNoticeViewController" bundle:nil];
    vc.telephone = [NSString stringWithFormat:@"%@",self.phoneString];
    vc.amountOfMoney = [NSString stringWithFormat:@"%@",self.paymentAmountString];
    vc.theOpeningBank = [NSString stringWithFormat:@"%@",self.nameOfBank.text];
    vc.bankAccount = [NSString stringWithFormat:@"%@",self.accountNumbers];

    [self jumpViewController:self newViewController:vc PushAndPresent:YES];
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
