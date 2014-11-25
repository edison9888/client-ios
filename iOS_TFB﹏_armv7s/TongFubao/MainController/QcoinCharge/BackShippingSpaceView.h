//
//  BackShippingSpaceView.h
//  TongFubao
//
//  Created by kin on 14-9-19.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayCustomActivityView.h"


@protocol BackShippingSpaceViewDelegate <NSObject>

-(void)BackShippingSpaceView:(NSMutableArray *)newBackShippingSpaceArray;

-(void)IllustrateByPlane;


@end


@interface BackShippingSpaceView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    BOOL BackBool;
}

@property (retain,nonatomic)PlayCustomActivityView *activityView;

@property(retain,nonatomic)id<BackShippingSpaceViewDelegate>delegate;

@property (retain,nonatomic) UITableView *BackShippingTableView;
// textFile
@property (retain,nonatomic) UITextView *infoTextView;
@property (retain,nonatomic) UIButton *button;
@property (retain,nonatomic) NSMutableArray *BackShippingDataArray;


-(void)BackShippingdata:(NSMutableArray *)newBackShippingdata;


@end







