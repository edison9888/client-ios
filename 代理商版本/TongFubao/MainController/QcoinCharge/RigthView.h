//
//  RigthView.h
//  TongFubao
//
//  Created by kin on 14-8-18.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RigthViewDelegate <NSObject>

-(void)AirLineCode:(NSString *)newAirLineCode;
-(void)ClearData;



@end



@interface RigthView : UIView<UITableViewDataSource,UITableViewDelegate>

@property(retain,nonatomic)id<RigthViewDelegate>delegate;
@property(retain,nonatomic)UITableView *rightTableView;
@property(retain,nonatomic)NSMutableArray *AirLineArray;
@property(retain,nonatomic)NSMutableArray *AirLineKeys;

- (void)ariNameDictionary:(NSMutableSet *)newariNameDictionary  AirLineKeys:(NSMutableSet *)newAirLineKeys;





@end

















































