//
//  leftView.h
//  TongFubao
//
//  Created by kin on 14-8-18.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol leftViewDelegate <NSObject>

//-(void)selectionTime:(NSInteger)newButtonTeger;
-(void)SelectButtonAction:(UIButton *)sender;
-(void)DonChooseButtonEvents:(UIButton*)sender;

@end


@interface leftView : UIView

@property(retain,nonatomic)NSMutableArray *buttonArray;
@property(retain,nonatomic)NSMutableArray *priceTimeArray;
@property(retain,nonatomic)id<leftViewDelegate>delegate;

-(void)ButtontToRecover;


@end
