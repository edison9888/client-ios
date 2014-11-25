//
//  PAYSKQMore.h
//  TongFubao
//
//  Created by  俊   on 14-5-13.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VisaReader.h"
#import "UPPayPluginDelegate.h"
#import "NLKeyboardAvoid.h"

@interface PAYSKQMore : UIViewController<VisaReaderDelegate,UPPayPluginDelegate,UITextFieldDelegate,UITextFieldDelegate>
@property(nonatomic,strong)IBOutlet UITableView* myTableView;

@property (nonatomic,strong) NSDictionary *dict;
@property (nonatomic,strong) NSMutableArray *arraydic;
@end
