//
//  UIViewController+NavigationItem.m
//  BossLink
//

#import "UIViewController+NavigationItem.h"
#import "UIImage+Tint.h"
#import "NLUtils.h"

@implementation UIViewController (NavigationItem)

/*文字返回*/
-(void)addBackButtonItemWithTitle:(NSString *)title{
    if (self.navigationItem) {
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(leftItemClick:)];
        
        self.navigationItem.leftBarButtonItem = backItem;
    }
}

/*图片返回*/
-(void)addBackButtonItemWithImage:(UIImage *)img{
    if (self.navigationItem){
        UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
        btnBack.frame = CGRectMake(0, 0, 31, 31);
        [btnBack setBackgroundImage:img forState:UIControlStateNormal];
        [btnBack addTarget:self action:@selector(leftItemClick:) forControlEvents:UIControlEventTouchUpInside];
        [btnBack setBackgroundImage:[img imageWithTintColor:RGBACOLOR(137, 62, 17, 0.2)] forState:UIControlStateHighlighted];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
        self.navigationItem.leftBarButtonItem = backItem;
    }
}

//right图片
-(void)addRightButtonItemWithImage:(UIImage *)img{
    if (self.navigationItem) {
        UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
        btnBack.frame = CGRectMake(0, 0, 21, 21);
        [btnBack setBackgroundImage:img forState:UIControlStateNormal];
        [btnBack setBackgroundImage:[img imageWithTintColor:RGBACOLOR(137, 62, 17, 0.2)] forState:UIControlStateHighlighted];
        [btnBack addTarget:self action:@selector(rightItemClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
        self.navigationItem.rightBarButtonItem = backItem;
    }
}

/*right文字*/
-(void)addRightButtonItemWithTitle:(NSString *)title{
    if (self.navigationItem) {
        if (IOS7_OR_LATER) {
            UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:title
                                                                          style:UIBarButtonItemStyleBordered
                                                                         target:self
                                                                         action:@selector(rightItemClick:)];
            
            self.navigationItem.rightBarButtonItem = rightItem;
        }else{
            UIImage *image = [NLUtils createImageWithColor:[UIColor clearColor] rect:CGRectMake(0, 0, 10, 10)];
            UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
            [btnRight setBackgroundImage:[NLUtils stretchImage:image edgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forState:UIControlStateNormal];
            [btnRight setTitle:title forState:UIControlStateNormal];
            [[btnRight titleLabel] setFont:[UIFont systemFontOfSize:16]];
            [btnRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btnRight setTitleColor:[UIColor colorWithHex:0xFBC429] forState:UIControlStateHighlighted];
            [btnRight setTitleEdgeInsets:UIEdgeInsetsMake(7, 4, 0, 0)];
            [btnRight sizeToFit];
            CGRect rect = btnRight.frame;
            btnRight.frame = CGRectInset(rect, -6, 2);
            [btnRight addTarget:self action:@selector(rightItemClick:) forControlEvents:UIControlEventTouchUpInside];
            
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
        }
    }
}

-(void)leftItemClick:(id)sender{
    if ([self.navigationController.viewControllers count] > 1) {
        /*nav类型返回*/
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        /*tab类型返回*/
        [self dismissModalViewControllerAnimated:YES];
    }
}

-(void)rightItemClick:(id)sender{

}

- (void)setNavRightItemWithImage:(UIImage*)img
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // 按钮背景图片自适应
    UIImage *buttonImage = [[UIImage imageNamed:@"nav_top_detail_btn.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 15)];
    UIImage *buttonPressedImage = [[UIImage imageNamed:@"nav_top_detail_btn_sel.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 15)];
    
    // 按钮文字样式
    [[button titleLabel] setFont:[UIFont boldSystemFontOfSize:12.0]];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [button setTitleShadowColor:[UIColor clearColor] forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor clearColor] forState:UIControlStateHighlighted];
    [[button titleLabel] setShadowOffset:CGSizeMake(0.0, 1.0)];
    
    // 设置按钮大小
    CGRect buttonFrame = [button frame];
    buttonFrame.size.width = img.size.width + 24.0;
    buttonFrame.size.height = buttonImage.size.height;
    [button setFrame:buttonFrame];
    
    // 设置按钮背景
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted];
    [button setImage:img forState:UIControlStateNormal];
    
    // 按钮事件
    [button addTarget:self action:@selector(RightBarItemClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 添加到导航条
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)setNavBackItemByLastControllerTitle
{
    // 取得返回按钮的文字
    NSArray *viewControllerArray = [self.navigationController viewControllers];
    if ([viewControllerArray count]>1) {
        int parentViewControllerIndex = [viewControllerArray count] - 2;
        NSString *title = ((UIViewController*)[viewControllerArray objectAtIndex:parentViewControllerIndex]).navigationItem.title;
        [self addBackButtonItemWithTitle:title];
    }
}

/*返回*/
- (void)setNavBackItemByLastControllerBackTitle
{
    // 取得返回按钮的文字
    NSArray *viewControllerArray = [self.navigationController viewControllers];
    if ([viewControllerArray count]>1) {
        int parentViewControllerIndex = [viewControllerArray count] - 2;
        NSString *title = ((UIViewController*)[viewControllerArray objectAtIndex:parentViewControllerIndex]).navigationItem.backBarButtonItem.title;
        [self addBackButtonItemWithTitle:title];
    }

}

- (void)setNavRightArrowItemWithTitle:(NSString*)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // 按钮背景图片自适应
    UIImage *buttonImage = [[UIImage imageNamed:@"nav_top_right_arrow_btn.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 15)];
    UIImage *buttonPressedImage = [[UIImage imageNamed:@"nav_top_right_arrow_btn_sel.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 15)];
    
    // 按钮文字样式
    [[button titleLabel] setFont:[UIFont boldSystemFontOfSize:12.0]];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [button setTitleShadowColor:[UIColor clearColor] forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor clearColor] forState:UIControlStateHighlighted];
    [[button titleLabel] setShadowOffset:CGSizeMake(0.0, 1.0)];
    
    // 设置按钮大小
    CGRect buttonFrame = [button frame];
    buttonFrame.size.width = [title sizeWithFont:[UIFont boldSystemFontOfSize:12.0]].width + 24.0;
    buttonFrame.size.height = buttonImage.size.height;
    [button setFrame:buttonFrame];
    
    // 设置按钮背景
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted];
    [button setTitle:[NSString stringWithFormat:@"%@  ",title] forState:UIControlStateNormal];
    
    // 按钮事件
    [button addTarget:self action:@selector(RightBarItemClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 添加到导航条
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}


@end
