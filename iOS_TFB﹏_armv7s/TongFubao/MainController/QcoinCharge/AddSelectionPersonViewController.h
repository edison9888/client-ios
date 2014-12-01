//
//  AddSelectionPersonViewController.h
//  TongFubao
//
//  Created by kin on 14-8-21.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AddSelectionPersonVieDelegate <NSObject>
//
////-(void)returPersonIphoneDate:(NSMutableArray *)newPersonIphoneDate;
-(void)UpdateAddSelectionPersonPassengers;
//
@end
@interface AddSelectionPersonViewController : UIViewController<UIAlertViewDelegate>


@property (retain,nonatomic) NSString *PassengerName;
@property (retain,nonatomic) NSString *PassengerIphone;
@property (retain,nonatomic) id<AddSelectionPersonVieDelegate>delegate;



@end
