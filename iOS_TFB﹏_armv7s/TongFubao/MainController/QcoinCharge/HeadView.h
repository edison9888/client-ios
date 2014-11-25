//
//  HeadView.h
//  Test04
//
//  Created by HuHongbing on 9/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HeadViewDelegate; 

@interface HeadView : UIView
{
    id <HeadViewDelegate> delegate;//代理
    int section;
    UIButton *backBtn;
    UIButton *btn;
    BOOL open;
    BOOL flag;
}

@property(nonatomic, weak) id <HeadViewDelegate> delegate;
@property(nonatomic, assign) int section;
@property (nonatomic, assign) BOOL typeflag;
@property(nonatomic, strong) NSString* imgStr;
@property(nonatomic, strong) UIButton* backBtn;
@property(nonatomic, strong) UIImageView* backImg;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@protocol HeadViewDelegate <NSObject>

-(void)selectedWith:(HeadView *)view;
-(void)selectedWith:(HeadView *)view sender:(UIButton *)sender;

@end
