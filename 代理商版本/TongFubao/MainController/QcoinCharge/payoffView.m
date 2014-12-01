//
//  payoffView.m
//  TongFubao
//
//  Created by  俊   on 14-9-3.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "payoffView.h"
#define MaxPhoneNum 11

@interface payoffView ()
{
    NSData *bodyData;
    NSDictionary *dic;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@end

@implementation payoffView
@synthesize UrlbdcaiwuAuthor,UrlreadAuthorInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewInData
{
    NSMutableDictionary * msgDictionary = [NSMutableDictionary dictionaryWithCapacity:5];
    if (UrlbdcaiwuAuthor==YES) {
        
        [msgDictionary setObject:_phoneText.text forKey:@"authorusername"];
        [LoadDataWithASI loadDataWithMsgbody:msgDictionary apiName:@"ApiWageInfo" apiNameFunc:@"bdcaiwuAuthor" rolePath:@"//operation_response/msgbody" type:PublicCommon completionBlock:^(NSDictionary *data, NSError *error) {
            NSLog(@"请求成功%@",data);
            NSRange range = [data[@"result"] rangeOfString:@"succ"];
            if (range.length <= 0)
            {
                [self showErrorInfo:data[@"message"] status:NLHUDState_Error];
                [_hud hide:YES afterDelay:1.5];
            }else
            {
                _phoneText.text= data[@"cwmobile"];
                dic= [NSDictionary dictionaryWithObjectsAndKeys:data[@"cwmobile"], @"cwmobile",data[@"cwemail"], @"cwemail",data[@"cwtrueidcard"], @"cwtrueidcard",data[@"cwtruename"], @"cwtruename", nil];
               
              /*财务修订
                 payMoneyTopeople *pay= [[payMoneyTopeople alloc]init];
                pay.dic= dic;
                [self.navigationController pushViewController:pay animated:YES];
              */
                BossPayMoneyMain *boss= [[BossPayMoneyMain alloc]init];
                [self.navigationController pushViewController:boss animated:YES];
            }
        }];

    }else{
        /*绑定后读取*/
        [self readcwAuthorInfoUrl];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self readcwAuthorInfoUrl];
    [self viewInMain];
//    [self viewInData];
}

/*读取已绑定的财务人员 130*/
-(void)readcwAuthorInfoUrl
{
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    [LoadDataWithASI loadDataWithMsgbody:nil apiName:@"ApiWageInfo" apiNameFunc:@"readcwAuthorInfo" rolePath:@"//operation_response/msgbody" type:PublicCommon completionBlock:^(NSDictionary * data, NSError *error) {
        NSLog(@"130 请求成功%@",data);
        [_hud hide:YES];
        if (![data[@"result"] isEqualToString:@"success"]) {
             [self showErrorInfo:data[@"message"] status:NLHUDState_Error];
        }else{
            _phoneText.text= data[@"cwmobile"];
            _StaffName.text= [data[@"cwtruename"]length]==0 ? @"未登记": data[@"cwtruename"];
//            _phoneText.userInteractionEnabled= NO;
//            _StaffName.userInteractionEnabled= NO;
        }
    }];
}

/*读取已绑定的财务人员 1.1 阿翔的后台*/
-(void)readAuthorInfo
{
    NSDictionary *dataDictionaryClick = @{ @"phone" : _phoneText.text };
    [LoadDataWithASI loadDataWithMsgbody:dataDictionaryClick apiName:@"ApiWageInfo" apiNameFunc:@"GetStaffInfo" rolePath:@"//operation_response/msgbody" type:PublicCommon completionBlock:^(NSDictionary * data, NSError *error) {
        NSLog(@"1.1 请求成功%@",data);
        [_hud hide:YES];
        if ([data[@"result"] isEqualToString:@"success"]) {
            _StaffName.text= [data[@"name"]length]==0 ? @"未登记": data[@"name"];
        }
    }];
}


-(void)viewInMain
{
    self.title= @"指定财务";
    [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
    [self addBackButtonItemWithTitle:@"历史记录"];
    [self.view endEditing:YES];
    UITapGestureRecognizer *oneFingerTwoTaps = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(oneFingerTwoTaps)];
    // Set required taps and number of touches
    [oneFingerTwoTaps setNumberOfTapsRequired:2];
    
    [self.view addGestureRecognizer:oneFingerTwoTaps];
    
}


- (IBAction)OnbtnClick:(id)sender {
    
    UrlbdcaiwuAuthor= YES;
   
    if ([self checkNoPictureInfo]) {
        [self viewInData];
      
    }
}

-(BOOL)checkNoPictureInfo
{
    BOOL modify= YES;

    if (![NLUtils checkMobilePhone:_payPhoneLogin.text])
    {
        [self showErrorInfo:@"输入正确的手机号码" status:NLHUDState_Error];
        return NO;
    }
    return modify;
}

//判断信息是否正确
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

#pragma mark - keyboard hide event
-(void)oneFingerTwoTaps
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UITextField *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    [firstResponder resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL retValue = YES;
    
    if([[textField text] length] - range.length + string.length > MaxPhoneNum)
    {
        retValue=NO;
    }
    return retValue;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ( _phoneText.text.length == MaxPhoneNum  && _phoneText == textField) {
          [self readAuthorInfo];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField != _payPhoneLogin) {
		[textField resignFirstResponder];
	} else {
		[self checkNoPictureInfo];
	}
	return YES;
}

/*发放历史*/
-(void)rightItemClick:(id)sender
{
    payMoneyHistory *pay= [[payMoneyHistory alloc]init];
    [self.navigationController pushViewController:pay animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
