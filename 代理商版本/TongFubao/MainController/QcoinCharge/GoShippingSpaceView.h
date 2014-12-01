//
//  GoShippingSpaceView.h
//  TongFubao
//
//  Created by kin on 14-9-19.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayCustomActivityView.h"

@protocol GoShippingSpaceViewDelegate <NSObject>

-(void)GoShippingSpaceView:(NSMutableArray *)newGoShippingSpaceArray;

-(void)IllustrateByPlane;

@end


@interface GoShippingSpaceView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    BOOL goBool;
}

@property (retain,nonatomic)PlayCustomActivityView *activityView;
@property(retain,nonatomic)id<GoShippingSpaceViewDelegate>delegate;
@property (retain,nonatomic) UITableView *historicalTableView;
// textFile
@property (retain,nonatomic) UITextView *infoTextView;

@property (retain,nonatomic) UIButton *button;
@property (retain,nonatomic) NSMutableArray *GoShippingDataArray;

-(void)GoShippingdata:(NSMutableArray *)newGoShippingdata;

@end
















