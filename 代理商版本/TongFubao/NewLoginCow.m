//
//  NewLoginCow.m
//  TongFubao
//
//  Created by  俊   on 14-6-5.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "NewLoginCow.h"

@interface NewLoginCow ()
{
    NSInteger currentHeight;
}

@end

@implementation NewLoginCow

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [NLUtils getAuthorid];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    
    ViewControllerProperty;
    
#endif
    
    //获取当前屏幕size
    currentHeight = iphoneSize;
    self.title = @"APP下载";
   [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 80, 250, 250)];
    imageView.image = imageName(@"ewm", @"jpg");
    [self.view addSubview:imageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
