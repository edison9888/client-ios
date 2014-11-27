//
//  XIAOYU_TheControlPackage.h
//  TongFubao
//
//  Created by 通付宝MAC on 14-11-5.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <Foundation/Foundation.h>

//@interface XIAOYU_TheControlPackage : NSObject
//@end

@interface UIViewController (NavigationItem)


//右按钮方法
-(void)rightButtonItemWithTitle:(NSString *)title Frame:(CGRect)frame backgroundImage:(UIImage *)backgroundImage backgroundImageHighlighted:(UIImage *)backgroundImageHighlighted;

//左按钮方法
- (UIBarButtonItem *)leftBarButtonItem;
-(void)tapleftBarButtonItemBack;

//跳转方法
- (void)jumpViewController:(UIViewController*)oldViewController
         newViewController:(UIViewController*)newViewController PushAndPresent:(BOOL)identifier;

//返回方法
- (UIButton *)leftBarButtonBack;






@end