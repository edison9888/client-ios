//
//  SecretText.h
//  TongFubao
//
//  Created by  俊   on 14-6-4.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecretText : UIViewController<DropDownChooseDelegate,DropDownChooseDataSource,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate>
@property (assign,nonatomic) BOOL UserBool;
@property (retain,nonatomic) NSString *phoneNumber;
@property (retain,nonatomic) NLProtocolResponse *pushResponse;
@end


