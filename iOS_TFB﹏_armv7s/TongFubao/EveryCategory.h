//
//  EveryCategory.h
//  TongFubao
//
//  Created by 〝Cow﹏. on 14-8-13.
//  Copyright (c) 2014年 〝Cow﹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UILabel (Additon)

+ (UILabel *)labelWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor textColor:(UIColor *)textColor text:(NSString *)text font:(UIFont *)font;

@end

@interface UIButton (Additon)

+ (UIButton *)buttonWithFrame:(CGRect)frame unSelectImage:(UIImage *)unSelectImage selectImage:(UIImage *)selectImage tag:(int)tag titleColor:(UIColor *)titleColor title:(NSString *)title;

@end


@interface UIView (Additon)
+ (UIView *)viewWithFrame:(CGRect)frame;
@end


@interface UIImageView (Additon)
+ (UIImageView *)viewWithFrame:(CGRect)frame image:(UIImage *)image;
@end


@interface UITextField (Additon)
+ (UITextField *)textWithFrame:(CGRect)frame placeholder:(NSString *)placeholder;
@end


@interface NSString (Additon)
+ (NSString *)stringWithFirst:(NSString *)first second:(NSString *)second third:(NSString *)third fourth:(NSString *)fourth;
@end


@interface UIImage (Additon)
+ (UIImage *)redraw:(UIImage *)image_ frame:(CGRect)frame_;
@end


















