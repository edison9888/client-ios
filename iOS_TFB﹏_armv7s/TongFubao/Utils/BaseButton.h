//
//  BaseButton.h
//  bank navi test
//
//  Created by Cow on 13-12-21.
//  Copyright (c) 2013年 gao yulong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseButton : UIButton

+(UIButton *)ButtonWithFrame:(CGRect)frame Target:(id)target Selector:(SEL)selector Image:(UIImage *)image Title:(NSString *)title TitleColor:(UIColor *)titleColor TitleColorSate:(UIControlState)titleColorSate;

+ (UIButton*) createButtonWithFrame: (CGRect) frame Target:(id)target Selector:(SEL)selector Image:(NSString *)image ImagePressed:(NSString *)imagePressed;

+ (UIButton *) createButtonWithFrame:(CGRect)frame Title:(NSString *)title Target:(id)target Selector:(SEL)selector;

@end

@interface LableModel : UILabel
+ (UILabel *)LableTile:(NSString *)lableTitle TitleFrame:(CGRect)frame TitleNum:(int)titlenum titleColor:(UIColor *)titleColor BGColor:(UIColor *)bgColor fontSize:(float)fontSize boldSize:(float)boldSize;
@end


@interface BaseUImage : UIImage
+(UIImage *)redraw:(UIImage*)_image frame:(CGRect)_frame;
@end

@interface TextFiledModel : UITextField
+ (UITextField *)textFiledFrame:(CGRect)frame  Placeholder:(NSString *)placeholder BGColor:(UIColor *)bgColor textColor: (UIColor *)textColor TextAlignment:(NSTextAlignment)TextAlignment contentAlignment:(UIControlContentVerticalAlignment )contentAlignment clearBtn:(BOOL)clearBtn  Delegate:(id)delegate Alpha:(CGFloat)alpha fontSize:(float)fontSize boldSize:(float)boldSize;
@end

@interface textViewModel : UITextView
+ (UITextView *)textViewFrame:(CGRect)frame  BGColor:(UIColor *)bgColor textColor: (UIColor *)textColor TextAlignment:(NSTextAlignment)TextAlignment Delegate:(id)delegate Alpha:(CGFloat)alpha fontSize:(float)fontSize boldSize:(float)boldSize;
@end

@interface SwitchModel : UISwitch
-(UISwitch *)switchWithFrame:(CGRect)frame Onimage:(NSString*)onimage Offimage:(NSString*)offimage;
@end

@interface UIColor (Art)
+(UIColor*)colorWithHex:(long)hex;
@end
