//
//  NLBigImageViewController.m
//  TongFubao
//
//  Created by MD313 on 13-8-28.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLBigImageViewController.h"

@interface NLBigImageViewController ()

@end

@implementation NLBigImageViewController

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
    self.navigationController.topViewController.title = @"查看大图";
    self.myImageView.image = self.myImage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
