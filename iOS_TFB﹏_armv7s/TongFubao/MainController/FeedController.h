//
//  FeedController.h
//  TongFubao
//
//  Created by MD313 on 13-8-1.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#define kFileName @"archive.plist"
#define kDataKey @"Data"

#import <UIKit/UIKit.h>

typedef enum {
    NLMainTouchUpActiont_None = 0,
    NLMainTouchUpActiont_tfmg,
    NLMainTouchUpActiont_mobilerecharge,
    NLMainTouchUpActiont_family,
    NLMainTouchUpActiont_delivery,
    NLMainTouchUpActiont_airplane,
    NLMainTouchUpActiont_train,
    NLMainTouchUpActiont_hotel,
    NLMainTouchUpActiont_game,
    NLMainTouchUpActiont_qqrecharge,
    NLMainTouchUpActiont_creditcard,
    NLMainTouchUpActiont_balance,
    NLMainTouchUpActiont_coupon,
    NLMainTouchUpActiont_orderbuy,
    NLMainTouchUpActiont_agentbuy
}NLMainTouchUpAction;

@interface FeedController : UIViewController<UIScrollViewDelegate,UIAlertViewDelegate>
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,copy) NSString *password;
@property (nonatomic,copy) NSString *authorid;
@property (nonatomic,copy) NSMutableArray *dic;

-(NSString *)dataFilePath;
-(void)applicationWillResignActive:(NSNotification *)nofication;

@end
