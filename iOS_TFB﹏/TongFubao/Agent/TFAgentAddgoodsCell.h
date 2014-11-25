//
//  TFAgentAddgoodsCell.h
//  TongFubao
//
//  Created by ec on 14-5-16.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AgentAddGoodsCellDelete;

@interface TFAgentAddgoodsCell : UITableViewCell

-(void)setData:(NSDictionary *)dict;

@property(nonatomic,assign) id<AgentAddGoodsCellDelete> delegate;

@end

@protocol AgentAddGoodsCellDelete <NSObject>

-(void)cellClickReceive:(TFAgentAddgoodsCell *)cell;

@end
