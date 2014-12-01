//
//  NLPeopleLevel.m
//  TongFubao
//
//  Created by  俊   on 14-9-9.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "NLPeopleLevel.h"

@interface NLPeopleLevel ()

@end

@implementation NLPeopleLevel

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
    self.title= @"用户级别说明";
    [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
    [self addRightButtonItemWithImage:[UIImage imageNamed:@"history"]];
}

/*发放历史*/
-(void)rightItemClick:(id)sender
{
    //demo
    NLhhzTestViewController *vc= [[NLhhzTestViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
