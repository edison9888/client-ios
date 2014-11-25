//
//  ShouMoneyViewController.h
//  TongFubao
//
//  Created by kin on 14/10/21.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShouMoneyViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    BOOL keySeletion;
}

@property(retain,nonatomic)UITableView *shouMoneyTableView;
@property(retain,nonatomic)NSArray *titleArray;
@property(retain,nonatomic)NSArray* savingPerson;




@end
