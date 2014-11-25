//
//  HotelPhotoCell.h
//  TongFubao
//
//  Created by Delpan on 14-9-2.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotelPhotoCell : UITableViewCell
{
    UIButton *photoBtn[3];
}

@property (nonatomic, strong) UIButton *firstBtn;

@property (nonatomic, strong) UIButton *secondBtn;

@property (nonatomic, strong) UIButton *thirdBtn;
//查看酒店相片
@property (nonatomic, copy) void (^photoBlock)(UIButton *currentBtn);

@end
