//  AppDelegate.h
//  AnimatTabbarSample
//
//  Created by Cow﹏. on 14-7-24.
//  Copyright (c) 2014年 Cow﹏. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AnimateTabbarDelegate<NSObject>
@required
-(void)TabBarBtnClick:(UIButton*)sender;

@end
@interface AnimateTabbarView : UIView

@property(nonatomic,strong)id <AnimateTabbarDelegate> delegate;
@property(nonatomic,strong) UIButton *firstBtn;
@property(nonatomic,strong) UIButton *secondBtn;
@property(nonatomic,strong) UIButton *thirdBtn;
@property(nonatomic,strong) UIButton *fourthBtn;

@property(nonatomic,strong) UIButton *backBtn;
@property(nonatomic,strong) UIButton *shadeBtn;
 
@property(nonatomic,strong) UIImageView *gotabbar;

-(void)buttonClickAction:(id)sender;
@end
