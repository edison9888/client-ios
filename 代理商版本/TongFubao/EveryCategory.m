//
//  EveryCategory.m
//  TongFubao
//
//  Created by Delpan on 14-8-13.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "EveryCategory.h"

@implementation UILabel (Additon)

+ (UILabel *)labelWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor textColor:(UIColor *)textColor text:(NSString *)text font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = backgroundColor;
    label.textColor = textColor;
    label.textAlignment = NSTextAlignmentLeft;
//    label.adjustsFontSizeToFitWidth = YES;
//    label.numberOfLines = 0;
    label.text = text;
    label.font = font;
    
    return label;
}

/*
$(inherited) $(SRCROOT) "$(SRCROOT)/../../../Desktop/MyWorkLib/我的有用的静态库" "$(SRCROOT)/../../../Desktop/MyWorkLib/我的有用的静态库/iphonesimulator" "$(SRCROOT)/../../../Desktop/MyWorkLib/通付宝/银联手机支付（控件版）/UPPayPluginEx-SND-2.0.6/upmp_iphone/sdk/libs/Release-iphoneos" $(PROJECT_DIR)


$(inherited) $(SRCROOT) "$(SRCROOT)/../../../Desktop/MyWorkLib/我的有用的静态库" "$(SRCROOT)/../../../Desktop/MyWorkLib/我的有用的静态库/iphonesimulator" "$(SRCROOT)/../../../Desktop/MyWorkLib/通付宝/银联手机支付（控件版）/UPPayPluginEx-SND-2.0.6/upmp_iphone/sdk/libs/Release-iphoneos" $(PROJECT_DIR) $(PROJECT_DIR)/TongFubao $(PROJECT_DIR)/TongFubao/ZBarSDK $(PROJECT_DIR)/TongFubao/customUI/ZBarSDK $(PROJECT_DIR)/TongFubao/ZBarSDK/Headers
*/




@end





@implementation UIButton (Additon)

+ (UIButton *)buttonWithFrame:(CGRect)frame unSelectImage:(UIImage *)unSelectImage selectImage:(UIImage *)selectImage tag:(int)tag titleColor:(UIColor *)titleColor title:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.opaque = YES;
    button.frame = frame;
    button.tag = tag;
    [button setBackgroundImage:unSelectImage forState:UIControlStateNormal];
    [button setBackgroundImage:selectImage forState:UIControlStateSelected];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    
    return button;
}

@end




@implementation UIView (Additon)

+ (UIView *)viewWithFrame:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.opaque = YES;
    view.backgroundColor = [UIColor clearColor];
    
    return view;
}

@end




@implementation UIImageView (Additon)

+ (UIImageView *)viewWithFrame:(CGRect)frame image:(UIImage *)image
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.opaque = YES;
    imageView.image = image;
    imageView.userInteractionEnabled = YES;
    
    return imageView;
}

@end




@implementation UITextField (Additon)

+ (UITextField *)textWithFrame:(CGRect)frame placeholder:(NSString *)placeholder
{
    UITextField *text = [[UITextField alloc] initWithFrame:frame];
    text.opaque = YES;
    text.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    text.placeholder = placeholder;
    
    return text;
}

@end

@implementation NSString (Additon)

+ (NSString *)stringWithFirst:(NSString *)first second:(NSString *)second third:(NSString *)third fourth:(NSString *)fourth
{
    NSString *lastString = [second substringFromIndex:(second.length - 4)];
    
    NSString *string = [NSString stringWithFormat:@"%@\t 尾号:%@\t %@\t %@", first, lastString, third, fourth];
    
    return string;
}

@end







@implementation UIImage (Additon)

+ (UIImage *)redraw:(UIImage *)image_ frame:(CGRect)frame_
{
    UIImage *image = image_;
    UIGraphicsBeginImageContext(frame_.size);
    [image drawInRect:frame_];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsPopContext();
    
    return image;
}

@end






















