//
//  ACMoreModulesViewController.m
//  TFB_代理商界面
//
//  Created by 湘郎 on 14-11-26.
//  Copyright (c) 2014年 MacAir. All rights reserved.
//

#import "ACMoreModulesViewController.h"
#import "XIAOYU_TheControlPackage.h"

@interface ACMoreModulesViewController ()
{
    UIScrollView *scrollView;
}


#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )

#define RGBACOLOR(r,g,b,a)      [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:a]

@end

@implementation ACMoreModulesViewController


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
    // Do any additional setup after loading the view.
    
    self.title = @"更多";
    
    [self leftBarButtonBack];//返回按钮
    [self scrollVC];
    [self initVC];
}


 
#pragma mark - UIScrollView
-(void)scrollVC{
    scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    scrollView.backgroundColor = RGBACOLOR(223, 223, 223, 1.0);
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    scrollView.pagingEnabled = NO;
    scrollView.showsHorizontalScrollIndicator = YES;
    scrollView.showsVerticalScrollIndicator = YES;
    [self.view addSubview:scrollView];
}


#pragma mark - UI视图
-(void)initVC{

    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 130, scrollView.frame.size.width, 41)];
    label.text = @"更多功能尚在开发中, 敬请期待 !";
    [label setTextAlignment:NSTextAlignmentCenter];
    label.font = [UIFont boldSystemFontOfSize:20];
    [scrollView addSubview:label];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
