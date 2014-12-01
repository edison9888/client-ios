//
//  NLUserInforSettingsCell.h
//  TongFubao
//
//  Created by MD313 on 13-8-2.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLAsynImageView.h"

@interface NLUserInforSettingsCell : UITableViewCell<UITextFieldDelegate>

@property(nonatomic,retain) IBOutlet UILabel* myHeaderLabel;
@property(nonatomic,retain) IBOutlet UILabel* myContentLabel;
@property(nonatomic,retain) IBOutlet NLAsynImageView* myUprightImage;
@property(nonatomic,retain) IBOutlet NLAsynImageView* myDownrightImage;
@property(nonatomic,retain) IBOutlet UIButton* myUprightBtn;
@property(nonatomic,retain) IBOutlet UIButton* myDownrightBtn;
@property(nonatomic,retain) IBOutlet UIButton* mySelectedBtn;
@property(nonatomic,retain) IBOutlet UITextField* myTextField;
@property(nonatomic,retain) id myContainer;

- (IBAction)onUprightBtnClicked:(id)sender;
- (IBAction)onDownrightBtnClicked:(id)sender;
- (IBAction)onSelectedBtnClicked:(id)sender;
-(void)setKeyBoard;

//查看相片
@property (nonatomic, copy) void (^CellBlock)(void);

@end
