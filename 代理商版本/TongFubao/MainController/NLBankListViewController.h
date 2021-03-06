//
//  NLBankListViewController.h
//  TongFubao
//
//  Created by MD313 on 13-8-9.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLProgressHUD.h"

typedef enum
{
    BankListStateBank = 0,
} NLBankListState;

@class NLBankListViewController;

@interface Bank : NSObject //银行选择的页面

@property (nonatomic,copy)NSString *code;/**< 银行代码*/
@property (nonatomic,copy)NSString *name;/**< 银行名称*/

- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (NSString *)keyName;

@end

@protocol NLBankLisDelegate <NSObject>

- (void)dataSearch:(NLBankListViewController *)controller didSelectWithObject:(id)aObject
         withState:(NSString *)state;

- (void)dataSearchDidCanceled:(NLBankListViewController *)controller
                    withState:(int)state;
@end


@interface NLBankListViewController :UIViewController <UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,NLProgressHUDDelegate>

@property (nonatomic,assign)id<NLBankLisDelegate> delegate;
@property (nonatomic,assign) int bankIndex;
@property (nonatomic,strong) NSString* myActivemobilesms;
@property (nonatomic,assign) BOOL banKtype;
// kin
@property (nonatomic,retain) NSString *payListBank;

@end
