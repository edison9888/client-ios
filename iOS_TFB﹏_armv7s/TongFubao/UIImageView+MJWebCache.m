//
//  UIImageView+MJWebCache.m
//  FingerNews
//
//  Created by 〝Cow﹏. on 14-7-2.
//  Copyright (c) 2013年 〝Cow﹏. All rights reserved.
//


#import "UIImageView+MJWebCache.h"

@implementation UIImageView (MJWebCache)
- (void)setImageURL:(NSURL *)url placeholder:(UIImage *)placeholder
{
    [self setImageWithURL:url placeholderImage:placeholder options:SDWebImageRetryFailed | SDWebImageLowPriority];
}

- (void)setImageURLStr:(NSString *)urlStr placeholder:(UIImage *)placeholder
{
    [self setImageURL:[NSURL URLWithString:urlStr] placeholder:placeholder];
}
@end
