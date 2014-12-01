//
//  payoffView.h
//  TongFubao
//
//  Created by  俊   on 14-9-3.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "payMoneyHistory.h"
#import "payMoneyTopeople.h"

@interface payoffView : UIViewController<ASIHTTPRequestDelegate,UITextFieldDelegate>
{
    NLProgressHUD  * _hud;
}
@property (weak, nonatomic) IBOutlet UITextField *payPhoneLogin;
@property (weak, nonatomic) IBOutlet UIButton *OnbtnClick;
@property (weak, nonatomic) IBOutlet UIView *ViewA;
@property (weak, nonatomic) IBOutlet UITextField *StaffName;

@property (retain,nonatomic) NSString *BossauthoridStr;
@property (assign, nonatomic) BOOL UrlbdcaiwuAuthor;/*绑定财务人员账户*/
@property (assign, nonatomic) BOOL UrlreadAuthorInfo;/*手机号读取用户信息*/
@end
