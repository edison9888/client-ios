//
//  NLKeyboardAvoidingLib.h
//  NLKeyboardAvoidingLib
//
//  Created by NatLiu on 13-8-13.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NLKeyboardAvoidingScrollView : UIScrollView

-(id)initWithFrame:(CGRect)frame;
- (void)keyboardWillShow:(NSNotification*)notification;
- (void)keyboardWillHide:(NSNotification*)notification;
- (void)adjustOffsetToIdealIfNeeded;

@end

@interface NLKeyboardAvoidingTableView : UITableView

-(id)initWithFrame:(CGRect)frame;
- (void)keyboardWillShow:(NSNotification*)notification;
- (void)keyboardWillHide:(NSNotification*)notification;
- (void)adjustOffsetToIdealIfNeeded;

@end
