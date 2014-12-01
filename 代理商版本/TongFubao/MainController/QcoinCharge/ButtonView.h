//
//  ButtonView.h
//  TongFubao
//
//  Created by kin on 14-8-15.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ButtonViewdelegate <NSObject>

-(void)changeVuleCellSetype:(UIButton *)sender;
-(void)shouCell:(UIButton *)sender;


@end

@interface ButtonView : UIView

@property(retain,nonatomic)id<ButtonViewdelegate>delegate;
@property(retain,nonatomic)UIButton *_cellButton;


-(id)initWithFrame:(CGRect)frame buttonTag:(NSInteger)newTag buttonTitle:(NSString *)newTitle ;
-(void)ChangingStateButton;
-(void)ChangingIndexStateButton:(UIButton *)Sender;
+(void)pushStateButton;

@end
