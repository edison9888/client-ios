//
//  NLAsynImageView.h
//  
//
//  Created by NatLiu on 13-3-5.
//  Copyright (c) 2013年 enuola. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NLAsynImageView : UIImageView

//图片对应的缓存在沙盒中的路径
@property (nonatomic, retain) NSString *fileName;

//指定默认未加载时，显示的默认图片
@property (nonatomic, retain) UIImage *placeholderImage;

//请求网络图片的URL
@property (nonatomic, retain) NSString *imageURL;

@end
