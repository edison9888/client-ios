//
//  AttentionWKViewController.m
//  TongFubao
//
//  Created by Delpan on 14-8-7.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "AttentionWKViewController.h"

@interface AttentionWKViewController ()
{
    NSInteger currentHeight;
}

@end

@implementation AttentionWKViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    
    ViewControllerProperty;
    
#endif
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"关注微信";
    
    //获取当前屏幕size
    currentHeight = iphoneSize;
    

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
