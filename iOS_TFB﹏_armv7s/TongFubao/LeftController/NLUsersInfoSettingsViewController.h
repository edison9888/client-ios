//
//  NLUsersInfoSettingsViewController.h
//  TongFubao
//
//  Created by MD313 on 13-8-1.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLAsynImageView.h"

@interface NLUsersInfoSettingsViewController : UIViewController</*UIAlertViewDelegate,*/UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate>
@property(nonatomic,assign) BOOL agentFlag;
-(void)setDownImage:(UIImage *)image pathUrl:(NSString *)pathUrl;

@end
