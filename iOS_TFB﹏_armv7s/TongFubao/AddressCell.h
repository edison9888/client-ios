//
//  TFAgentSearchListCell.h
//  TongFubao
//
//  Created by 〝Cow﹏. on 14-5-13.
//  Copyright (c) 2014年 〝Cow﹏. All rights reserved.
//

#import <UIKit/UIKit.h>


@class AddressCell;
@protocol AddressCellDelegate <NSObject>
@optional
-(void)longPressCell:(AddressCell*)cell;
@end

/*购买刷卡器的*/
@interface AddressCell : UITableViewCell

@property (nonatomic, weak) id<AddressCellDelegate>  listCellDelegate;

@property (nonatomic,strong) UIImageView *roundView;

@property (nonatomic, strong) UIButton          *deleteBtn;

-(void)setData:(NSDictionary *)dict withRow:(NSInteger )row;

@end

/*发工资*/
@interface PayPeopleCellList : UITableViewCell
@property (nonatomic, assign) BOOL  HeadViewFlag;
@property (nonatomic, strong) UILabel *lableText;

@property (nonatomic, strong) UILabel  *LbPhone;
@property (nonatomic, strong) UILabel  *LbName;
@property (nonatomic, strong) UILabel  *LbMoney;

-(void)setData:(NSDictionary *)dict withRow:(NSInteger )row;

@end


