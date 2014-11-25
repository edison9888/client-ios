//
//  ToOkView.m
//  TongFubao
//
//  Created by  俊   on 14-8-14.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "ToOkView.h"

@interface ToOkView ()

@end

@implementation ToOkView

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
    [self mainview];
}

-(void)mainview
{
     [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
    
}
- (IBAction)OnbtnClick:(id)sender
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
