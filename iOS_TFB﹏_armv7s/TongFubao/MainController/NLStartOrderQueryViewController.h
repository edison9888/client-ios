//
//  NLStartOrderQueryViewController.h
//  TongFubao
//
//  Created by MD313 on 13-9-25.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NLStartOrderQueryViewController : UIViewController

@property(nonatomic, strong)NSString* myCompanyName;
@property(nonatomic, strong)NSString* myCompanyCom;
@property(nonatomic, strong)NSString* iconNameStr;
@property(nonatomic, strong)NSString* LablePhoneStr;

@property (weak, nonatomic) IBOutlet UIImageView *iconName;
@property (weak, nonatomic) IBOutlet UIButton *LablePhone;

@end
