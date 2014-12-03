//
//  RMHeard.h
//  RMSwipeTableViewCelliOS7UIDemo
//
//  Created by  俊   on 14-12-1.
//  Copyright (c) 2014年 The App Boutique. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HeadViewDelegate;

@interface RMHeard : UIView
{
    id <HeadViewDelegate> delegate;
}
@property(nonatomic, weak) id <HeadViewDelegate> delegate;
@property(nonatomic, assign) int section;
@property(nonatomic, strong) UIButton* backBtn;
@end

@protocol HeadViewDelegate <NSObject>

-(void)selectedWith:(RMHeard *)view sender:(UIButton *)sender;

@end