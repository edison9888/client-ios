//
//  NewfirstView.m
//  TongFubao
//
//  Created by  俊   on 14-10-22.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "NewfirstView.h"

@interface NewfirstView ()

@end

@implementation NewfirstView

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
}

- (IBAction)btnonclick:(UIButton*)sender {
    
    NSString *sendStr = sender.tag == 1? @"NewLoginView" : @"NLRegisterViewController";
    id thisClass = [[NSClassFromString(sendStr) alloc] initWithNibName:sendStr bundle:nil];
    [NLUtils presentModalViewController:self newViewController:thisClass];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
