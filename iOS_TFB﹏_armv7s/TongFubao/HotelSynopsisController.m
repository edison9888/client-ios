//
//  HotelSynopsisController.m
//  TongFubao
//
//  Created by Delpan on 14-9-2.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "HotelSynopsisController.h"

@interface HotelSynopsisController ()
{
    NSInteger currentHeight;
}

@end

@implementation HotelSynopsisController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    
    ViewControllerProperty;
    
#endif
    
    //获取当前屏幕size
    currentHeight = iphoneSize;
    
    self.title = @"酒店简介";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //酒店信息
    [self.view addSubview:self.infoBasicView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


















