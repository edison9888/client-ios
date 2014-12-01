//
//  NLFindPasswordViewController.h
//  TongFubao
//
//  Created by MD313 on 13-8-29.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLContants.h"
#import "NLPassWordManagerViewController.h"

@interface NLFindPasswordViewController : UIViewController

@property(nonatomic,assign) TFBPasswordType myPasswordType;
@property(nonatomic,retain) NSString* myMobile;
@property(nonatomic,assign) NSString* isPaypwd;
@property(nonatomic,assign) NLPassWordManagerViewController* NLPassWordDetegate;

@end
