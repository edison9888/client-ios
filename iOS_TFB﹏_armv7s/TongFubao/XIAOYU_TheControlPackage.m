//
//  XIAOYU_TheControlPackage.m
//  TongFubao
//
//  Created by 通付宝MAC on 14-11-5.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "XIAOYU_TheControlPackage.h"

//@implementation XIAOYU_TheControlPackage
//@end


@implementation UIViewController (NavigationItem)


#pragma mark - 导航条右边按钮
-(void)rightButtonItemWithTitle:(NSString *)title Frame:(CGRect)frame backgroundImage:(UIImage *)backgroundImage backgroundImageHighlighted:(UIImage *)backgroundImageHighlighted{
    
    UIButton *btn = [[UIButton alloc]initWithFrame:frame];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize: 15.0]];
    [btn setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    [btn setBackgroundImage:backgroundImageHighlighted forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(tapRightButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    
/*
    if (self.navigationItem) {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleBordered target:self action:@selector(rightItemClick:)];
        [rightItem setBackgroundImage:backgroundImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [rightItem setBackgroundImage:backgroundImage forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
*/
}


#pragma mark - 导航条左边按钮
- (UIBarButtonItem *)leftBarButtonItem{
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 30)];
    [button addTarget:self action:@selector(tapleftBarButtonItemBack) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"navigationLeftBtnBack2"] forState:UIControlStateNormal];
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithCustomView:button];
    return left;
    
}



/*
-(void)leftButtonItemWithTitle:(NSString *)title backgroundImage:(UIImage *)backgroundImage backgroundImageHighlighted:(UIImage *)backgroundImageHighlighted{
    
    if (self.navigationItem) {
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleBordered target:self action:@selector(leftItemClick:)];
        [leftItem setBackgroundImage:backgroundImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [leftItem setBackgroundImage:backgroundImage forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
        self.navigationItem.leftBarButtonItem = leftItem;
    }
}
*/


#pragma mark - 界面跳转方法封装
- (void)jumpViewController:(UIViewController*)oldViewController
         newViewController:(UIViewController*)newViewController PushAndPresent:(BOOL)identifier{
    
    //保存BOOL的状态值 做返回的时候 根据值来判断怎么返回
    [[NSUserDefaults standardUserDefaults]setBool:identifier forKey:@"JumpBOOL"];
    
    if (identifier == YES) {
        [oldViewController.navigationController pushViewController:newViewController animated:YES];
    }else{
        //如果是present 次级界面想带导航条就得主动添加导航条
        UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:newViewController];
        [oldViewController presentViewController:navController animated:YES completion:nil];
    }
}


#pragma mark - 返回
- (UIButton *)leftBarButtonBack{
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10, 30)];
    imageView.image = [UIImage imageNamed:@"navigationLeftBtnBack2"];
    imageView.contentMode = UIViewContentModeLeft;
    
    UIButton* backButton= [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 55, 28);
    
    [backButton addTarget:self action:@selector(tapBack:) forControlEvents:UIControlEventTouchUpInside];
    /*
    [[backButton titleLabel] setFont:[UIFont boldSystemFontOfSize:16]];
    [backButton setTitle:@" 返回" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [backButton.titleLabel setTextAlignment:NSTextAlignmentRight];
    */
    [backButton addSubview:imageView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    return backButton;
    
}



-(void)tapBack:(id)sender{
    
    BOOL identifier = [[NSUserDefaults standardUserDefaults] boolForKey:@"JumpBOOL"];
    NSLog(@"NSNumber  %d",identifier);
    
    if (identifier == YES) {
        [self.navigationController popViewControllerAnimated:YES];
        NSLog(@"popViewControllerAnimated");
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
        NSLog(@"dismissViewControllerAnimated");
    }
    
}


#pragma mark - 单选按钮
-(void)radioButton{
    
    
    
}





//为了减少个警告而写的  没实际用处
-(void)tapRightButtonItem:(id)sender{}
-(void)leftItemClick:(id)sender{}
-(void)tapleftBarButtonItemBack{}
@end