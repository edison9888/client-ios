//
//  SampleCell.m
//  TongFubao
//
//  Created by  俊   on 14-8-4.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "SampleCell.h"

#define CLIENT_IMG_WIDTH 41
#define CLIENT_IMG_HEIGHT 41

@implementation SampleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

-(void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)dealloc {
    
    [_labelForPlace release];
    [_labelForCountry release];
    [_imageview release];
    [super dealloc];
}
@end
