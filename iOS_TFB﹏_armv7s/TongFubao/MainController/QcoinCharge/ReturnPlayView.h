//
//  ReturnPlayView.h
//  TongFubao
//
//  Created by kin on 14-9-19.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ReturnPlayViewdelegate <NSObject>

-(void)ReturnPlayViewInfoTuPiao;

@end

@interface ReturnPlayView : UIView

@property(retain,nonatomic)id<ReturnPlayViewdelegate>delegate;


- (id)initWithFrame:(CGRect)frame firstSecondArray:(NSArray *)newfirstSecondArray;

@end
