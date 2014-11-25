//
//  MyNumberController.h
//  TongFubao
//
//  Created by Delpan on 14/10/27.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    //信息全
    ImpowerInfoType = 0,
    //获取授权码
    ImpowerType = 1,
    //解除绑定
    ImpowerSignOutType = 2
}MyImpowerType;

@interface MyNumberController : UIViewController

//授权码
@property (nonatomic, copy) NSString *impowerNumber;
//唯一标识符
@property (nonatomic, copy) NSString *paycardIMEI;

- (instancetype)initWithType:(MyImpowerType)type;

@end

























