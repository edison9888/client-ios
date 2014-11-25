//
//  peopleHadMoneyCell.m
//  TongFubao
//
//  Created by  俊   on 14-10-11.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "peopleHadMoneyCell.h"

@implementation peopleHadMoneyCell

- (void)awakeFromNib
{
    // Initialization code
}

- (IBAction)btnSelectAction:(id)sender {
    
    [self performSelector:@selector(delCell:) withObject:nil afterDelay:0.1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/*代理删除*/
-(void)delCell:(peopleHadMoneyCell*)cell
{
    if (self.peopleHadMoneyCellDelegate&&[self.peopleHadMoneyCellDelegate respondsToSelector:@selector(delCell:)]) {
        [self.peopleHadMoneyCellDelegate delCell:self];
    }
}
@end
