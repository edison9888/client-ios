//
//  BossAddPeople.h
//  TongFubao
//
//  Created by  俊   on 14-9-19.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BossAddPeople : UIViewController<UIAlertViewDelegate,UINavigationControllerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *moneyTF;
@property (weak, nonatomic) IBOutlet UITextField *NameTF;
@property (weak, nonatomic) IBOutlet UITextField *peoplePhoneTF;

@property (weak, nonatomic) IBOutlet UILabel *LaIsOn;
@property (weak, nonatomic) IBOutlet UILabel *LaCardNumber;
@property (assign,nonatomic) BOOL flagType;
@property (weak, nonatomic) IBOutlet UILabel *LaCardisOn;
@property (weak, nonatomic) IBOutlet UIButton *deleBtn;
@property (weak, nonatomic) IBOutlet UIButton *onbtn;
@property (copy, nonatomic) NSDictionary *deldic;
@property (copy, nonatomic) NSString *monthNow;
/*bossid*/
@property (nonatomic, retain) NSString       *bossAuthoridStr;
@end
