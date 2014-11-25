//
//  LeftControllerCell.m
//  TongFubao
//
//  Created by MD313 on 13-8-2.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "LeftControllerCell.h"

@implementation LeftControllerCell

@synthesize myContextLabel;
@synthesize myImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
