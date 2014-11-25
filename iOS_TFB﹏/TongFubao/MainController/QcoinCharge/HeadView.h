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
    BOOL open;
}

@property(nonatomic, weak) id <HeadViewDelegate> delegate;
@property(nonatomic, assign) int section;
@property(nonatomic, strong) UIButton* backBtn;

@end

@protocol HeadViewDelegate <NSObject>

-(void)selectedWith:(HeadView *)view;

@end
