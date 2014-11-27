//
//  ACImmediatelyBinding.h
//  TongFubao
//
//  Created by 湘郎 on 14-11-21.
//  Copyright (c) 2014年 MD313. All rights reserved.
//
//  绑定本机/解除绑定/绑定刷卡器

#import <UIKit/UIKit.h>

@interface ACImmediatelyBinding : UIViewController

@property(strong,nonatomic)NSString *authorizationCodes;//授权码
@property(strong,nonatomic)NSString *bindingEquipments;//设备唯一标识符
@property(strong,nonatomic)NSString *paycardmachinnos;//授权机型

//复用界面状态表达值  1:绑定本机  2:解除绑定  3:绑定刷卡器
@property(assign,nonatomic)int state;

@end
