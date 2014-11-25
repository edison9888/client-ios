//
//  UIImageView+MJWebCache.h
//  FingerNews
//
//  Created by 〝Cow﹏. on 14-7-2.
//  Copyright (c) 2013年 〝Cow﹏. All rights reserved.
//

#import "UIImageView+WebCache.h"

@interface UIImageView (MJWebCache)
- (void)setImageURL:(NSURL *)url placeholder:(UIImage *)placeholder;
- (void)setImageURLStr:(NSString *)urlStr placeholder:(UIImage *)placeholder;
@end