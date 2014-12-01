//
//  TimerButtonView.h
//  TongFubao
//
//  Created by kin on 14-8-15.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TimerButtonViewDelegate <NSObject>

-(void)returnDate:(NSString *)newDate;

@end

@interface TimerButtonView : UIView

@property (retain,nonatomic)id<TimerButtonViewDelegate>delegate;
@property (retain,nonatomic) NSString *dateString ;
@property (retain,nonatomic) NSString *nowTimeString;

- (id)initWithFrame:(CGRect)frame  wacthTime:(NSString *)newWacthTime  shijianca:(NSInteger)newshijianca;

-(void)selectionDateTime:(NSString *)newDateTime  goTime:(NSString *)newGoTime shijianca:(NSInteger)newshijianca;

@end

