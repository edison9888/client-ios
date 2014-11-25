//
//  MobileRechangeHistoryCell.h
//  TongFubao
//
//  Created by ec on 14-4-27.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MobileRechangeHistoryCell : UITableViewCell

-(void)setData:(NSDictionary *)dict;

-(void)setQcoinData:(NSDictionary *)dict;

-(void)setSKQData:(NSDictionary *)dict;

-(void)setWaterElecData:(NSDictionary *)dict;

-(void)setGameChargeData:(NSDictionary *)dict;

@end
