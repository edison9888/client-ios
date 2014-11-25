//
//  TFAgentSearchListCell.h
//  TongFubao
//
//  Created by ec on 14-5-13.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>


@class AddressCell;
@protocol AddressCellDelegate <NSObject>
@optional
-(void)longPressCell:(AddressCell*)cell;
@end

@interface AddressCell : UITableViewCell

@property (nonatomic, weak) id<AddressCellDelegate>  listCellDelegate;

@property (nonatomic,strong) UIImageView *roundView;

@property (nonatomic, strong) UIButton          *deleteBtn;

-(void)setData:(NSDictionary *)dict withRow:(NSInteger )row;

@end


