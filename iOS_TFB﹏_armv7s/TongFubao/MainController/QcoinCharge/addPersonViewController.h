//
//  addPersonViewController.h
//  TongFubao
//
//  Created by kin on 14-8-20.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol addPersonViewDelegate <NSObject>
//
////-(void)returPersonIphoneDate:(NSMutableArray *)newPersonIphoneDate;
////-(void)UpdateTheDataUpPassengers;
//
//@end

@interface addPersonViewController : UIViewController<UITextFieldDelegate>

@property(nonatomic,retain)NSString *unmberID;
@property(nonatomic,retain)NSString *PassengerName;
@property(nonatomic,retain)NSString *PassengerCardType;
@property(nonatomic,retain)NSString *PassengerCardId;
@property(nonatomic,assign)NSInteger PassengerType;
@property(nonatomic,retain)NSMutableArray *PassengerPersonIphone;
@property(nonatomic,retain)NSMutableArray *selectionPersonIphone;
//@property(nonatomic,retain)id<addPersonViewDelegate>delegate;


//@property(nonatomic,retain)id<addPersonViewDelegate>delegate;


@end
