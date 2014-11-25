//
//  SMSServiceAgreementViewController.m
//  TongFubao
//
//  Created by 通付宝MAC on 14-11-8.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "SMSServiceAgreementViewController.h"
#import "XIAOYU_TheControlPackage.h"


@interface SMSServiceAgreementViewController ()

@end

@implementation SMSServiceAgreementViewController


-(void)tapleftBarButtonItemBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.title = @"短信收款业务服务协议";
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.navigationItem.leftBarButtonItem = [self leftBarButtonItem];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
