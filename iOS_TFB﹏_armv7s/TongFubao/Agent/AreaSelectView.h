//
//  AreaSelectView.h
//  UIText
//
//  Created by Delpan on 14-7-21.
//  Copyright (c) 2014年 Delpan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RemoveView;

//点击黑视图触发代理
@protocol RemoveViewDelegate <NSObject>

@optional

- (void)removeView;

@end

@class AreaSelectView;

//cell触发代理
@protocol AreaSelectViewDelegate <NSObject>

@optional

- (void)areaChange:(BOOL)change btn:(UIButton *)btn;

- (void)bankTagWith:(int)tag;

@end


@interface RemoveView : UIView

@property (nonatomic, weak) id <RemoveViewDelegate> removeViewDelegate;

@end


@interface AreaSelectView : UIView <UITableViewDataSource, UITableViewDelegate, RemoveViewDelegate>
{
    @private
    //地区
    NSArray *areas;
    //地区变化按扭
    UIButton *areaButton;
    //银行页面
    BOOL bankView;
    
    BOOL NLData;
    
}

@property (nonatomic, strong) UITableView *table;

@property (nonatomic, weak) id <AreaSelectViewDelegate> areaSelectViewDelegate;

- (void)loadDataWith:(NSArray *)data button:(UIButton *)button dictionary:(BOOL)dictionary NLData:(BOOL)NLdata;

@end








