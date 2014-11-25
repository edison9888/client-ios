//
//  NLLoginView.h
//  TongFubao
//
//  Created by  俊   on 14-10-22.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NLLoginView : UIViewController<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lablePhone;
@property (weak, nonatomic) IBOutlet UIImageView *imageHeard;
@property (weak, nonatomic) IBOutlet UIButton *qieHuanBtn;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (assign, nonatomic) BOOL flagOn;
@property (assign, nonatomic) BOOL flagChange;/*修改密码后的*/
@property (assign, nonatomic) BOOL flagdenchu;/*登出*/
@property (nonatomic,retain) NSString *mobile;

@end
