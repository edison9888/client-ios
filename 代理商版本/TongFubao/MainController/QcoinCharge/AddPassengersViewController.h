//
//  AddPassengersViewController.h
//  TongFubao
//
//  Created by kin on 14-8-20.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddPassengersViewdelegate <NSObject>

-(void)addPersonIphoneArray:(NSMutableArray *)newIphoneArray;

@end

@interface AddPassengersViewController : UIViewController

@property (retain,nonatomic) NSMutableArray *CellDateArray;
@property (retain,nonatomic) NSMutableArray *CellIndexArray;
@property (retain,nonatomic) id<AddPassengersViewdelegate>delegate;
@property (retain,nonatomic) NSArray *ticketArray;
@property (assign,nonatomic) NSInteger teger;

-(void)InternetDownloads;


@end
