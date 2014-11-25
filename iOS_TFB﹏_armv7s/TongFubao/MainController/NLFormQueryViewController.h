//
//  NLFormQueryViewController.h
//  TongFubao
//
//  Created by MD313 on 13-9-26.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	FormQuery_FormQuery = 0,
	FormQuery_FormPay,
    FormQuery_FormPayQuery
} FormQueryType;

@interface NLFormQueryViewController : UIViewController<UIActionSheetDelegate>

@property(nonatomic,assign)FormQueryType myFormQueryType;

@end
