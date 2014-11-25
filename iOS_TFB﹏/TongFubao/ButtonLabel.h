//
//  ButtonLabel.h
//  TongFubao
//
//  Created by Delpan on 14-8-14.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ButtonLabel : UIView

@property (nonatomic, strong) UIButton *selectBtn;

@property (nonatomic, strong) UILabel *titleLabel;

- (id)initWithTitle:(NSString *)title frame:(CGRect)frame tag:(NSInteger)tag;

@end
