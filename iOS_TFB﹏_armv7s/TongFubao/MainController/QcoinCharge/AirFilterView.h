//
//  AirFilterView.h
//  TongFubao
//
//  Created by kin on 14-8-18.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AirFilterViewdelegate <NSObject>

-(void)moveLeftRightView:(NSInteger)newInteger;


@end

@interface AirFilterView : UIView

@property(retain,nonatomic)id<AirFilterViewdelegate>delegate;

-(void)backLableMove;
-(void)leftBackLableMove;



@end
