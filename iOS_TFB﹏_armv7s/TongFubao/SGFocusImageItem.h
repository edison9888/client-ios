//
//  SGFocusImageItem.h
//  VideoPlayer
//
//  Created by 〝Cow﹏. on 13-10-19.
//  Copyright (c) 2013年 〝Cow﹏.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface SGFocusImageItem : NSObject

@property (nonatomic, retain)  NSString     *title;
@property (nonatomic, retain)  UIImage      *image;
@property (nonatomic, assign)  NSInteger     tag;
@property (nonatomic, assign)  UIImageView  *imageView;

- (id)initWithTitle:(NSString *)title image:(UIImage *)image tag:(NSInteger)tag;
- (id)initWithTitle:(NSString *)title imageView:(UIImageView *)imageView;
@end
