//
//  CustomAlertView.h
//  TongFubao
//
//  Created by Delpan on 14-8-21.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomAlertViewDelegate <NSObject>

@optional

- (void)customAlertViewTouch:(NSInteger)button;

@end

@interface CustomAlertView : UIView
{
    UIButton *leftBtn;
    UIButton *rightBtn;
}

//信息输入框
@property (nonatomic, strong) UITextField *infoText;

@property (nonatomic, weak) id <CustomAlertViewDelegate> customAlertViewDelegate;

- (id)initWithframe:(CGRect)frame title:(NSString *)title delegate:(id <CustomAlertViewDelegate>)customDelegate firstTitle:(NSString *)firstTitle secondTitle:(NSString *)secondTitle;

@end
