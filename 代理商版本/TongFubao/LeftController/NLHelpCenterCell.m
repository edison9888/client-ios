//
//  NLHelpCenterCell.m
//  TongFubao
//
//  Created by MD313 on 13-8-7.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLHelpCenterCell.h"

@implementation NLHelpCenterCell

@synthesize myDateLabel;
@synthesize myDetailLabel;
@synthesize myTitleLabel;

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
