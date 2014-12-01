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
    ImpowerInfoType = 0,
    ImpowerType = 1,
    ImpowerSignOutType = 2
}MyImpowerType;

@interface MyNumberController : UIViewController

//授权码
@property (nonatomic, copy) NSString *impowerNumber;

- (instancetype)initWithType:(MyImpowerType)type;

@end
