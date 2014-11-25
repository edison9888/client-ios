//
//  NLHistoryDetailViewController.h
//  TongFubao
//
//  Created by MD313 on 13-8-12.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    NLHistoryDetailBuy = 0,
    NLHistoryDetailCash
} NLHistoryDetailType;

@interface NLHistoryDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,assign) NLHistoryDetailType myHistoryDetailType;

@end
