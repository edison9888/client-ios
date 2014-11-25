//
//  BaseButton.m
//  bank navi test
//
//  Created by Cow on 13-12-21.
//  Copyright (c) 2013年 gao yulong. All rights reserved.
//

#import "BaseButton.h"


@implementation BaseButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

+(UIButton*)ButtonWithFrame:(CGRect)frame Target:(id)target Selector:(SEL)selector Image:(UIImage *)image Title:(NSString *)title TitleColor:(UIColor *)titleColor TitleColorSate:(UIControlState)titleColorSate{
    UIButton *button= [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    UIImage *newimage= [[UIImage alloc]init];
    [button setTitleColor:titleColor forState:titleColorSate];
    [button setImage:image forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundImage:newimage forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}

@end


@implementation BaseUImage

+(UIImage*)redraw:(UIImage*)_image frame:(CGRect)_frame
{
    UIImage *image= _image;
    UIGraphicsBeginImageContext(_frame.size);
    [image drawInRect:_frame];//给一个image对象 对其进行重绘
    image= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndPDFContext();
    return image;
}



@end

@implementation LableModel

+ (UILabel *)LableTile:(NSString *)lableTitle TitleFrame:(CGRect)frame TitleNum:(int)titlenum titleColor:(UIColor *)titleColor BGColor:(UIColor *)bgColor fontSize:(float)fontSize boldSize:(float)boldSize
{
    LableModel *lable= [[LableModel alloc]init];
    lable.text= lableTitle;
    lable.frame= frame;
    lable.backgroundColor= [UIColor clearColor];
    lable.numberOfLines= titlenum;
    lable.textColor= titleColor;
    lable.font= [UIFont systemFontOfSize:fontSize];
    lable.font= [UIFont boldSystemFontOfSize:boldSize];
    return lable;
}

@end

@implementation UIColor (Art)
+(UIColor*)colorWithHex:(long)hex{
    float red   = ((float)((hex & 0xFF0000) >> 16))/255.0;
    float green = ((float)((hex & 0xFF00) >> 8))/255.0;
    float blue  = ((float)((hex & 0xFF)))/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

@end


@implementation TextFiledModel


+ (UITextField *)textFiledFrame:(CGRect)frame Placeholder:(NSString *)placeholder BGColor:(UIColor *)bgColor textColor:(UIColor *)textColor TextAlignment:(NSTextAlignment)TextAlignment contentAlignment:(UIControlContentVerticalAlignment )contentAlignment clearBtn:(BOOL)clearBtn Delegate:(id)delegate Alpha:(CGFloat)alpha fontSize:(float)fontSize boldSize:(float)boldSize{
    UITextField *textfiled= [[UITextField alloc]init];
    textfiled.frame= frame;
    textfiled.placeholder= placeholder;
    textfiled.backgroundColor= bgColor;
    textfiled.textColor= textColor;
    textfiled.textAlignment= TextAlignment;
    textfiled.contentVerticalAlignment= contentAlignment;
    textfiled.clearButtonMode= clearBtn;
    textfiled.delegate= delegate;
    textfiled.alpha= alpha;
    textfiled.font= [UIFont systemFontOfSize:fontSize];
    textfiled.font= [UIFont boldSystemFontOfSize:boldSize];
    return textfiled;
    
}

@end

@implementation textViewModel

+ (UITextView *)textViewFrame:(CGRect)frame BGColor:(UIColor *)bgColor textColor:(UIColor *)textColor TextAlignment:(NSTextAlignment)TextAlignment Delegate:(id)delegate Alpha:(CGFloat)alpha fontSize:(float)fontSize boldSize:(float)boldSize{
    UITextView *textView= [[UITextView alloc]init];
    textView.frame= frame;
    textView.backgroundColor= bgColor;
    textView.textColor= textColor;
    textView.textAlignment= TextAlignment;
    textView.delegate= delegate;
    textView.alpha= alpha;
    textView.font= [UIFont systemFontOfSize:fontSize];
    textView.font= [UIFont boldSystemFontOfSize:boldSize];
    return textView;
    
}
@end

@implementation SwitchModel

-(UISwitch *)switchWithFrame:(CGRect)frame Onimage:(NSString*)onimage Offimage:(NSString*)offimage{
    UISwitch *swit= [[UISwitch alloc]init];
    swit.frame= CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    swit.onImage= [UIImage imageNamed:onimage];
    swit.offImage= [UIImage imageNamed:offimage];
    return swit;
}

@end