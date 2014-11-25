//
//  HotelPhotoController.m
//  TongFubao
//
//  Created by Delpan on 14-9-3.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "HotelPhotoController.h"

@interface HotelPhotoController ()
{
    NSInteger currentHeight;
    //酒店相片
    CacheImageView *photoView;
}

@end

@implementation HotelPhotoController

- (id)initWithImage:(UIImage *)image
{
    if (self = [super init])
    {
        photoView = [[CacheImageView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 300)];
        photoView.image = [UIImage redraw:image frame:CGRectMake(0, 0, self.view.bounds.size.width, 300)];
        [self.view addSubview:photoView];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    
    ViewControllerProperty;
    
#endif
    
    self.title = @"酒店照片";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //获取当前屏幕size
    currentHeight = iphoneSize;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end



















