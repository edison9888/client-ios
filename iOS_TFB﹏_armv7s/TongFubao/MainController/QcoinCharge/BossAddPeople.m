//
//  BossAddPeople.m
//  TongFubao
//
//  Created by  俊   on 14-9-19.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "BossAddPeople.h"

#define MaxPhoneNum 11

@interface BossAddPeople ()
{
    NLProgressHUD  * _hud;
    BOOL flagYF;
}
@end

@implementation BossAddPeople

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
    [self viewInMain];
}

-(void)GetStaffInfo
{
    /*1.1	根据员工手机号获取员工信息*/
    NSDictionary *dataDictionary = @{ @"phone" : _peoplePhoneTF.text , @"bossauthorid" : [NLUtils getbossauthorid]};
    /*支付工资*/
    [LoadDataWithASI loadDataWithMsgbody:dataDictionary apiName:@"ApiWageInfo" apiNameFunc:@"GetStaffInfo" rolePath:@"//operation_response/msgbody" type:PublicCommon completionBlock:^(NSDictionary *data, NSError *error)
     {
         if (![data[@"result"] isEqualToString:@"success"]) {
//             [NLUtils showAlertView:@"失败" message:data[@"message"] delegate:self tag:1 cancelBtn:@"返回" other:@"确定"];
              _LaCardisOn.text= @"未绑定";
         }else{
             
             if (flagYF!=NO) {
                 _NameTF.text= data[@"name"];
             }
             _LaCardisOn.text= data[@"hasRegister"] ? @"已绑定" : @"未绑定";
             _LaIsOn.text= data[@"hasRegister"];
             _NameTF.text= data[@"name"];
             _LaCardNumber.text= data[@"bankAccount"];
             flagYF =NO;
             NSLog(@"operation_response %@",data);
         }
     }];
}

-(void)addviewInData
{
    /*1.2	新增员工工资记录*/
    NSDictionary *dataDictionary = @{ @"month" : _monthNow, @"phone" : _peoplePhoneTF.text , @"name" : _NameTF.text , @"money" : _moneyTF.text , @"bossauthorid" : [NLUtils getbossauthorid]};
    /*支付工资*/
    [LoadDataWithASI loadDataWithMsgbody:dataDictionary apiName:@"ApiWageInfo" apiNameFunc:@"AddSalaryItem" rolePath:@"//operation_response/msgbody" type:PublicCommon completionBlock:^(NSDictionary *data, NSError *error)
     {
         if (![data[@"result"] isEqualToString:@"success"]) {
             /*
             [NLUtils showAlertView:@"失败" message:data[@"message"] delegate:self tag:1 cancelBtn:@"返回" other:@"确定"];*/
             [self showErrorInfo:data[@"message"] status:NLHUDState_Error];
             [_hud hide:YES afterDelay:2];
             
         }else{
             
             [TFData getTempData][BOOS_PAY_MONEY_PEOPLE]=BOOS_PAY_MONEY_PEOPLE;
             [self.navigationController popViewControllerAnimated:YES];
      
             NSLog(@"operation_response %@",data);
         }
     }];
}

-(void)viewInModifySalaryItem
{
    /*1.4	修改员工工资记录*/
    NSDictionary *dataDictionary = @{ @"id" : _deldic[@"id"], @"phone" : _peoplePhoneTF.text , @"name" : _NameTF.text , @"money" : _moneyTF.text , @"bossauthorid" : [NLUtils getbossauthorid]  };
    /*支付工资*/
    [LoadDataWithASI loadDataWithMsgbody:dataDictionary apiName:@"ApiWageInfo" apiNameFunc:@"ModifySalaryItem" rolePath:@"//operation_response/msgbody" type:PublicCommon completionBlock:^(NSDictionary *data, NSError *error)
     {
         if (![data[@"result"] isEqualToString:@"success"]) {
             
             [self showErrorInfo:data[@"message"] status:NLHUDState_Error];
             [_hud hide:YES afterDelay:2];
             
         }else{
             NSLog(@"operation_response %@",data);
             
             [TFData getTempData][BOOS_DELETE_MONEY_PEOPLE]=BOOS_DELETE_MONEY_PEOPLE;
             [self.navigationController popViewControllerAnimated:YES];
         }
     }];
}


-(void)viewInDeleteSalaryItem
{
    /*1.5	删除员工工资记录*/
    NSDictionary *dataDictionary = @{ @"id" : _deldic[@"id"] ,  @"bossauthorid" : [NLUtils getbossauthorid]};
    /*支付工资*/
    [LoadDataWithASI loadDataWithMsgbody:dataDictionary apiName:@"ApiWageInfo" apiNameFunc:@"DeleteSalaryItem" rolePath:@"//operation_response/msgbody" type:PublicCommon completionBlock:^(NSDictionary *data, NSError *error)
     {
         if (![data[@"result"] isEqualToString:@"success"]) {
             
             [self showErrorInfo:data[@"message"] status:NLHUDState_Error];
             [_hud hide:YES afterDelay:2];
             
         }else{
             NSLog(@"operation_response %@",data);
             
             [TFData getTempData][BOOS_DELETE_MONEY_PEOPLE]=BOOS_DELETE_MONEY_PEOPLE;
             [self.navigationController popViewControllerAnimated:YES];
         }
     }];
}

-(void)viewWillAppear:(BOOL)animated{
    
}

/*view界面*/
-(void)viewInMain
{
    self.title= @"登记工资";
    _peoplePhoneTF.delegate = self;
    _NameTF.delegate        = self;
    _moneyTF.delegate       = self;
    
    if ([_deldic valueForKey:@"phone"]!=nil) {
        
        _NameTF.text=  _deldic[@"name"];
        _moneyTF.text= _deldic[@"money"];
        _peoplePhoneTF.text= _deldic[@"phone"];
        
        _LaIsOn.text= _deldic[@"hasRegister"];
        _LaCardNumber.text= _deldic[@"bankAccount"];
        
        if (_LaCardNumber.text.length > 9) {
           _LaCardisOn.text= @"已绑定";
        }else
        {
           _LaCardisOn.text= @"未绑定";
        }
    }
    if (_flagType==YES) {
        _peoplePhoneTF.userInteractionEnabled= NO;
        _deleBtn.hidden= NO;
    
        [_onbtn.layer setValue:@169 forKeyPath:@"frame.origin.x"];
        [_onbtn.layer setValue:@140 forKeyPath:@"frame.size.width"];
//        [_onbtn setFrame:(CGRect){169,self.onbtn.frame.origin.y,self.onbtn.frame.size.height,140}];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_moneyTF resignFirstResponder];
    [_NameTF resignFirstResponder];
    [_peoplePhoneTF resignFirstResponder];
}

- (IBAction)BtnOnClick:(UIButton *)sender {
    
    UIButton *senderButton = (UIButton *)sender;
    
    switch (senderButton.tag) {
        case 1:
        {
            if ([_deldic valueForKey:@"id"]!=nil) {
            
                 [self performSelector:@selector(viewInDeleteSalaryItem) withObject:nil afterDelay:0.1];
            }else
            {
                [self showErrorInfo:@"你当前无可删除员工" status:NLHUDState_Error];
                [_hud hide:YES afterDelay:2];
            }
           
        }
            break;
        case 2:
        {
            if ([self checkNoPictureInfo]) {
                
                if (_deldic[@"id"]!=nil) {
                    
                    [self performSelector:@selector(viewInModifySalaryItem) withObject:nil afterDelay:0.1];
                }else
                {
                    [self performSelector:@selector(addviewInData) withObject:nil afterDelay:0.1];
                }
                
            }
        }
            break;
        default:
            break;

    }
}

-(BOOL)checkNoPictureInfo
{
    BOOL modify= YES;
    
    if (![NLUtils checkMobilePhone:_peoplePhoneTF.text])
    {
        [self showErrorInfo:@"输入正确的手机号码" status:NLHUDState_Error];
        return NO;
    }
    
    if (_moneyTF.text.length < 1)
    {
        [self showErrorInfo:@"请正确的支付金额" status:NLHUDState_Error];
        return NO;
    }
    
    if (_NameTF.text.length < 1) {
        [self showErrorInfo:@"请输入员工的姓名" status:NLHUDState_Error];
        return NO;
    }

    return modify;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ( _peoplePhoneTF.text.length == MaxPhoneNum  && _peoplePhoneTF == textField) {
        [self GetStaffInfo];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL retValue = YES;
    if (textField == _peoplePhoneTF) {
       
        if([[textField text] length] - range.length + string.length > MaxPhoneNum)
        {
            retValue=NO;
            
        }
    }
    return retValue;
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


@end
