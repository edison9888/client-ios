//  AppDelegate.h
//  AnimatTabbarSample
//
//  Created by Cow﹏. on 14-7-24.
//  Copyright (c) 2014年 Cow﹏.. All rights reserved.
//

#import "AnimateTabbar.h"
#define TABBARVIEWHEIGHT 73;

@implementation AnimateTabbarView
@synthesize  firstBtn,secondBtn,thirdBtn,fourthBtn,delegate,backBtn,shadeBtn,gotabbar;

enum barsize{
    tabitem_width =80,
    tabitem_hight =65,
   
    tab_hight =72,
    tab_width =320,
   
    other_offtop =8,
    
    img_hight =31,
    img_width =34,
    img_x =22,
    img_y =6
    
};

- (id)initWithFrame:(CGRect)frame
{
    if (IOSVERSion>=7.0) {
         CGRect frame1=CGRectMake(frame.origin.x,iphoneSize-tab_hight, tab_width, tab_hight+1);
          self = [super initWithFrame:frame1];
    }else{
        CGRect frame1=CGRectMake(frame.origin.x, iphoneSize-tab_hight-20, tab_width, tab_hight+1);
        self = [super initWithFrame:frame1];
    }
    if (self) {

        [self setBackgroundColor:[UIColor whiteColor]];
        
        /*背景色*/
        backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setFrame:CGRectMake(-0.5, 0, tab_width+1, self.frame.size.height)];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"tabbg"] forState:UIControlStateNormal];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"tabbg"] forState:UIControlStateSelected];
       
        /*按钮点击替换色 isOn*/
        shadeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [shadeBtn setFrame:CGRectMake(-1, 7, tabitem_width, tabitem_hight)];
        [shadeBtn setBackgroundColor:RGBACOLOR(102, 102, 102, 1)];
        
        UIImageView *btnImgView;
        
        /*第一 有时间再循环*/
        btnImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tablock_1"] highlightedImage:[UIImage imageNamed:@"tablock_1"]];
        btnImgView.frame = CGRectMake(img_x, img_y, img_width, img_hight);
       
        firstBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [firstBtn setFrame:CGRectMake(0, other_offtop, tabitem_width, tabitem_hight)];
        [firstBtn setTag:1001];
        [firstBtn addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [firstBtn addSubview:btnImgView];
        
        /*第二*/
        btnImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tablock_2"] highlightedImage:[UIImage imageNamed:@"tablock_2"]];
        btnImgView.frame = CGRectMake(img_x, img_y, img_width, img_hight);
        secondBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [secondBtn setFrame:CGRectMake(tabitem_width, other_offtop, tabitem_width, tabitem_hight)];
        [secondBtn setTag:1002];
        [secondBtn addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [secondBtn addSubview:btnImgView];
        
        /*第三*/
        btnImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tablock_3"] highlightedImage:[UIImage imageNamed:@"tablock_3"]];
        btnImgView.frame = CGRectMake(img_x, img_y, img_width, img_hight);
        thirdBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [thirdBtn setFrame:CGRectMake(tabitem_width*2, other_offtop, tabitem_width, tabitem_hight)];
        [thirdBtn setTag:1003];
        [thirdBtn addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [thirdBtn addSubview:btnImgView];
        
        /*更多*/
        btnImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tablock_4"] highlightedImage:[UIImage imageNamed:@"tablock_4"]];
        btnImgView.frame = CGRectMake(img_x, img_y, img_width, img_hight);
        fourthBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [fourthBtn setFrame:CGRectMake(tabitem_width*3, other_offtop, tabitem_width, tabitem_hight)];
        [fourthBtn setTag:1004];
        [fourthBtn addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [fourthBtn addSubview:btnImgView];
        
        [backBtn addSubview:shadeBtn];
        [backBtn addSubview:firstBtn];
        [backBtn addSubview:secondBtn];
        [backBtn addSubview:thirdBtn];
        [backBtn addSubview:fourthBtn];
        [self addSubview:backBtn];
        
        /*btn里面添加title属性 暂效果会抖动*/
        UILabel     *labletitile;
        labletitile = [[UILabel alloc]initWithFrame:CGRectMake(0, 38, 80, 20)];
        labletitile.text = @"爱用";
        labletitile.textColor = [UIColor whiteColor];
        labletitile.backgroundColor= [UIColor clearColor];
        labletitile.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:13.0];
        labletitile.textAlignment= NSTextAlignmentCenter;
        [firstBtn addSubview:labletitile];
        
        labletitile = [[UILabel alloc]initWithFrame:CGRectMake(0, 38, 80, 20)];
        labletitile.text = @"掌上银行";
        labletitile.textColor = [UIColor whiteColor];
        labletitile.backgroundColor= [UIColor clearColor];
        labletitile.textAlignment= NSTextAlignmentCenter;
        labletitile.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:13.0];
        [secondBtn addSubview:labletitile];

        labletitile = [[UILabel alloc]initWithFrame:CGRectMake(0, 38, 80, 20)];
        labletitile.text = @"便民服务";
        labletitile.textColor = [UIColor whiteColor];
        labletitile.backgroundColor= [UIColor clearColor];
        labletitile.textAlignment= NSTextAlignmentCenter;
        labletitile.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:13.0];
        [thirdBtn addSubview:labletitile];

        labletitile = [[UILabel alloc]initWithFrame:CGRectMake(0, 38, 80, 20)];
        labletitile.text = @"更多";
        labletitile.textAlignment= NSTextAlignmentCenter;
        labletitile.textColor = [UIColor whiteColor];
        labletitile.backgroundColor= [UIColor clearColor];
        labletitile.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:13.0];
        [fourthBtn addSubview:labletitile];

        /*背景条*/
        UIImageView *linebar =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"linebar"]];
        linebar.frame = CGRectMake(0, 0, tab_width, 7);
        [self addSubview:linebar];
        
        /*滚动条*/
        gotabbar =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gotabbar"]];
        gotabbar.frame = CGRectMake(0, 0, 80, 9);
        [self addSubview:gotabbar];
        
    }
    return self;
}

-(void)callButtonAction:(UIButton *)sender{
    int value=sender.tag;
    if (value==1001) {
        [self.delegate TabBarBtnClick:firstBtn];
    }
    if (value==1002) {
        [self.delegate TabBarBtnClick:secondBtn];
      }
    if (value==1003) {
        [self.delegate TabBarBtnClick:thirdBtn];
    }
    if (value==1004) {
        [self.delegate TabBarBtnClick:fourthBtn];
    }
    
    [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^void{
        gotabbar.frame = CGRectMake((value-1001)*80, gotabbar.frame.origin.y, 80, 9);
        
    }completion:nil];
}

int g_selectedTag=1001;
-(void)buttonClickAction:(id)sender
{
    /*跳转回来可以刷新点击页面 bug*/
    UIButton *btn=(UIButton *)sender;
   // UIImageView *view=btn1.subviews[0];
//    if(g_selectedTag==btn.tag)
//        return;
//    else
//        g_selectedTag=btn.tag;
    
    if (firstBtn.tag!=btn.tag) {
        ((UIImageView *)firstBtn.subviews[0]).highlighted=NO;
    }
    if (secondBtn.tag!=btn.tag) {
        ((UIImageView *)secondBtn.subviews[0]).highlighted=NO;
    }
    if (thirdBtn.tag!=btn.tag) {
       
        ((UIImageView *)thirdBtn.subviews[0]).highlighted=NO;
    }
    if (fourthBtn.tag!=btn.tag) {
        
        ((UIImageView *)fourthBtn.subviews[0]).highlighted=NO;
    }
    /*按钮移动*/
    [self moveShadeBtn:btn];
    [self imgAnimate:btn];
    ((UIImageView *)btn.subviews[0]).highlighted=YES;
    [self callButtonAction:btn];
    return;
}

/*按钮移动*/
- (void)moveShadeBtn:(UIButton*)btn{
    
    CGRect frame = shadeBtn.frame;
    frame.origin.x = btn.frame.origin.x;
    shadeBtn.frame = frame;
    
    /*现在不需要动画 有橙色栏滑动
    [UIView animateWithDuration:0.3 animations:
     ^(void){
         CGRect frame = shadeBtn.frame;
         frame.origin.x = btn.frame.origin.x;
        shadeBtn.frame = frame;
         
     } completion:^(BOOL finished){//do other thing
     }];
    */
}

/*图片动态效果*/
- (void)imgAnimate:(UIButton*)btn{
    
    UIView *view=btn.subviews[0];
    [UIView animateWithDuration:0.1 animations:
     ^(void){
          view.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.5, 0.5);
     } completion:^(BOOL finished){//do other thing
         [UIView animateWithDuration:0.2 animations:
          ^(void){
              view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.2, 1.2);
          } completion:^(BOOL finished){//do other thing
              [UIView animateWithDuration:0.1 animations:
               ^(void){
                   view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1,1);
               } completion:^(BOOL finished){//do other thing
               }];
          }];
     }];
}


@end
