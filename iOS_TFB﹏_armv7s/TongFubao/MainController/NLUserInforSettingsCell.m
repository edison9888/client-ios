//
//  NLUserInforSettingsCell.m
//  TongFubao
//
//  Created by MD313 on 13-8-2.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLUserInforSettingsCell.h"

@interface NLUserInforSettingsCell()

@end

@implementation NLUserInforSettingsCell

@synthesize myContentLabel;
@synthesize myDownrightBtn;
@synthesize myDownrightImage;
@synthesize myHeaderLabel;
@synthesize myUprightBtn;
@synthesize myUprightImage;
@synthesize myTextField;
@synthesize myContainer;
@synthesize mySelectedBtn;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (IBAction)onUprightBtnClicked:(id)sender
{
    if ([self.myContainer respondsToSelector:@selector(doUprightBtnClicked:)])
    {
        self.CellBlock();
        [self.myContainer performSelector:@selector(doUprightBtnClicked:) withObject:self];
    }
}

- (IBAction)onDownrightBtnClicked:(id)sender
{
    if ([self.myContainer respondsToSelector:@selector(doDownrightBtnClicked:)])
    {
        self.CellBlock();
        [self.myContainer performSelector:@selector(doDownrightBtnClicked:) withObject:self];
    }
}

- (IBAction)onSelectedBtnClicked:(id)sender
{
    if ([self.myContainer respondsToSelector:@selector(doSelectedBtnClicked:)])
    {
        [self.myContainer performSelector:@selector(doSelectedBtnClicked:) withObject:self];
    }
}

#pragma mark Rotation

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate
{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

/*
-(void)setKeyBoard
{
//    self.myTextField.delegate = self;
    [self.myTextField addPreviousNextDoneOnKeyboardWithTarget:self previousAction:@selector(previousClicked:) nextAction:@selector(nextClicked:) doneAction:@selector(doneClicked:)];
}

-(void)doneClicked:(UIBarButtonItem*)barButton
{
    [self endEditing:YES];
}

-(void)previousClicked:(UIBarButtonItem*)barButton
{
    
}
-(void)nextClicked:(UIBarButtonItem*)barButton
{
    
}
 */

@end
