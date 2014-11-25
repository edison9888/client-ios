//
//  ApplyAgentViewControllerNew.h
//  TongFubao
//
//  Created by  俊   on 14-9-3.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AreaSelectView.h"
#import "MaterialLabel.h"
#import "NLBigImageViewController.h"
#import "NLSandboxFile.h"
#import "NLUserInforSettingsCell.h"

@interface ApplyAgentViewControllerNew : UIViewController<UITextFieldDelegate, AreaSelectViewDelegate, UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet NLKeyboardAvoidingTableView *Mytable;

@end
