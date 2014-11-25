//
//  SortView.h
//  TongFubao
//
//  Created by Delpan on 14-7-15.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SortView;

@protocol SortViewDelegate <NSObject>

@optional

- (void)sortViewDidTouch:(UIButton *)sender;

@end

@interface SortView : UIScrollView

@property (nonatomic, weak) id <SortViewDelegate> sortViewDelegate;

@end
