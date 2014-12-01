//
//  NLTransferThirdViewController.h
//  TongFubao
//
//  Created by MD313 on 13-10-10.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLBankListViewController.h"
#import "VisaReader.h"
#import "UPPayPluginDelegate.h"
#import "NLKeyboardAvoid.h"

@interface NLTransferThirdViewController : UIViewController<UPPayPluginDelegate,VisaReaderDelegate,NLBankLisDelegate,UIAlertViewDelegate,UITextFieldDelegate>

/*核对完成 刷卡提交的页面*/

@property(nonatomic,strong)IBOutlet UITableView* myTableView;
/*核对完成数据*/
@property(nonatomic,strong)NSDictionary* myDictionary;

-(IBAction)onButtonBtnClicked:(id)sender;

@end
