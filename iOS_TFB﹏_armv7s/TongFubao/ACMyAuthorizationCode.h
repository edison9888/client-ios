//
//  ACMyAuthorizationCode.h
//  TongFubao
//
//  Created by 湘郎 on 14-11-20.
//  Copyright (c) 2014年 MD313. All rights reserved.
//
//  我的授权码

#import <UIKit/UIKit.h>

@interface ACMyAuthorizationCode : UIViewController

@property(strong,nonatomic)NSString *authorizationCode;//授权码
@property(strong,nonatomic)NSString *bindingEquipment;//设备唯一标识符
@property(strong,nonatomic)NSString *paycardmachinno;//授权机型

//复用界面状态表达值  1:绑定本机  2:解除绑定
@property(assign,nonatomic)int state;

@end
