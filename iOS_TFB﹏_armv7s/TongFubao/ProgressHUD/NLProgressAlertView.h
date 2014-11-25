//
//  NLProgressAlertView.h
//
//  Created by NatLiu on 13-5-8.
//  Copyright (c) 2013年 HTJF. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface NLProgressAlertView : UIAlertView

/***
 用于initProgressWithTitle接口
 */
@property (nonatomic, retain) UIProgressView* progressView;
/***
 用于initProgressWithTitle接口
 */
@property (nonatomic, retain) UILabel* progressLabel;

/***
 UIAlertView+UIActivityIndicatorView
 这个函数不能添加message信息
 */
- (id)initActivityIndicatorWithTitle:(NSString *)title
                            delegate:(id <UIAlertViewDelegate>)delegate
                   cancelButtonTitle:(NSString *)cancelButtonTitle
                   otherButtonTitles:(NSString *)otherButtonTitles, ... ;

/***
 UIAlertView+UIProgressView
 这个函数可以添加message信息
 */
- (id)initProgressWithTitle:(NSString *)title
                             message:(NSString *)message
                            delegate:(id <UIAlertViewDelegate>)delegate
                   cancelButtonTitle:(NSString *)cancelButtonTitle
                   otherButtonTitles:(NSString *)otherButtonTitles, ... ;
@end
