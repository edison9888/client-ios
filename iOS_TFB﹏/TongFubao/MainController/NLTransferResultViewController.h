//
//  NLTransferResultViewController.h
//  TongFubao
//
//  Created by MD313 on 13-8-8.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h> //成功转账页面

@interface NLTransferResultViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, strong)NSArray* myArray;
@property(nonatomic, strong)NSString* myNavigationTitle;
@property(nonatomic, strong)NSString* myTitle;
@property(nonatomic, assign)int myType;

@end
