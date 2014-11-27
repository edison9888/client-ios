//
//  PayWidgetView.m
//  TongFubao
//
//  Created by  俊   on 14-11-24.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "PayWidgetView.h"

@interface PayWidgetView ()

@end

@implementation PayWidgetView

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

- (IBAction)OnClickBtn:(UIButton*)sender {
    switch (sender.tag) {
        case 1:
            NSLog(@"aaa");
            break;
        case 2:
             NSLog(@"bbb");
            break;
        case 3:
             NSLog(@"ccc");
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
