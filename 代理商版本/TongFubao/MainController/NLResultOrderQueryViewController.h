//
//  NLResultOrderQueryViewController.h
//  TongFubao
//
//  Created by MD313 on 13-9-26.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    ResultOrderQuery_Web = 0,
    ResultOrderQuery_Table
} NLResultOrderQueryType;

@interface NLResultOrderQueryViewController : UIViewController<UIWebViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, assign)NLResultOrderQueryType myType;
@property(nonatomic, strong)NSArray* myArray;

@end
