//
//  SGFocusImageItem.m
//  VideoPlayer
//
//  Created by 〝Cow﹏. on 13-10-19.
//  Copyright (c) 2013年 〝Cow﹏.. All rights reserved.
//

#import "SGFocusImageItem.h"

@implementation SGFocusImageItem
@synthesize title =  _title;
@synthesize image =  _image;
@synthesize tag =  _tag;
@synthesize imageView= _imageView;
//- (void)dealloc
//{
//    [_title release];
//    [_image release];
//    [super dealloc];
//}

- (id)initWithTitle:(NSString *)title image:(UIImage *)image tag:(NSInteger)tag
{
    self = [super init];
    if (self)
    {
        self.title = title;
        self.image = image;
        self.tag = tag;
    }
    
    return self;
}
- (id)initWithTitle:(NSString *)title imageView:(UIImageView *)imageView
{
    self = [super init];
    if (self)
    {
        self.title = title;
        self.imageView = imageView;
    }
    
    return self;
}

@end
