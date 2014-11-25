//
//  WalletMainView.m
//  TongFubao
//
//  Created by  俊   on 14-5-9.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "WalletMainView.h"

@interface WalletMainView ()

@end

@implementation WalletMainView

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
    // Do any additional setup after loading the view from its nib.
    self.title= @"我的钱包";
    /*i4
    UIImageView *image= [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    image.backgroundColor= [UIColor blueColor];
    [self.view addSubview:image];*/
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
