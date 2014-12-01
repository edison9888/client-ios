//
//  ShopCell.h
//  TongFubao
//
//  Created by 〝Cow﹏. on 14-9-1.
//  Copyright (c) 2014年 〝Cow﹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopCell : UITableViewCell
@property(strong,nonatomic)UIView *middleView;
@property(strong,nonatomic)UIImageView *myImageView;
@property(strong,nonatomic)UILabel *titleLabel;
@property(strong,nonatomic)UILabel *priceLabel;
@property(strong,nonatomic)UILabel *numOfEatLabel;
@property(strong,nonatomic)UILabel *otherLabel;
@property(strong,nonatomic)UIImageView *buyImageView;
@property(strong,nonatomic)UIView *viewBG;
-(void)buyAnimation;
-(void)notbuyAnimation;
-(void)setInfoTitle:(NSString *)title andPrice:(NSString *)price andNum:(int)num andImageUrl:(NSString *)imageUrl andBuyed:(BOOL) buyed;

@end
