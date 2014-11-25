//
//  DropDownListView.m
//  DropDownDemo
//
//  Created by Cow on 14-5-28.
//  Copyright (c) 2014年 Cow. All rights reserved.
//

#import "DropDownListView.h"
#define DEGREES_TO_RADIANS(angle) ((angle)/180.0 *M_PI)
#define RADIANS_TO_DEGREES(radians) ((radians)*(180.0/M_PI))

@implementation DropDownListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame dataSource:(id)datasource delegate:(id) delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor yellowColor];
        
        currentExtendSection = -1;
        
        self.dropDownDataSource = datasource;
        
        self.dropDownDelegate = delegate;
        
        NSInteger sectionNum =0;
        
        if ([self.dropDownDataSource respondsToSelector:@selector(numberOfSections)] ) {
            
            sectionNum = [self.dropDownDataSource numberOfSections];
        }
        
        if (sectionNum == 0) {
            self = nil;
        }
        
        //初始化默认显示view
        CGFloat sectionWidth = (1.0*(frame.size.width)/sectionNum);
        for (int i = 0; i <sectionNum; i++) {
            
            UIButton *sectionBtn = [[UIButton alloc] initWithFrame:CGRectMake(sectionWidth*i, 1, sectionWidth, frame.size.height-2)];
            
            sectionBtn.tag = SECTION_BTN_TAG_BEGIN + i;
            
            [sectionBtn addTarget:self action:@selector(sectionBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
            
            NSString *sectionBtnTitle = @"--";
            
            if ([self.dropDownDataSource respondsToSelector:@selector(titleInSection:index:)]) {
                
                sectionBtnTitle = [self.dropDownDataSource titleInSection:i index:[self.dropDownDataSource defaultShowSection:i]];
            }
            
            [sectionBtn  setTitle:sectionBtnTitle forState:UIControlStateNormal];
            
            sectionBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -150, 0, 0);
            
            [sectionBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            sectionBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
            
            [self addSubview:sectionBtn];
            
            UIImageView *sectionBtnIv = [[UIImageView alloc] initWithFrame:CGRectMake(sectionWidth*i +(sectionWidth - 35), (self.frame.size.height-32)/2, 30, 30)];
            
            [sectionBtnIv setImage:[UIImage imageNamed:@"chosenside"]];
            
            [sectionBtnIv setContentMode:UIViewContentModeScaleToFill];
            
            sectionBtnIv.tag = SECTION_IV_TAG_BEGIN + i;
            
            [self addSubview: sectionBtnIv];
            
            if (i<sectionNum && i != 0) {
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(sectionWidth*i, frame.size.height/4, 1, frame.size.height/2)];
                lineView.backgroundColor = [UIColor yellowColor];
                [self addSubview:lineView];
            }
            
        }
        
    }
    return self;
}

-(void)sectionBtnTouch:(UIButton *)btn
{
    NSInteger section = btn.tag - SECTION_BTN_TAG_BEGIN;
    
    UIImageView *currentIV= (UIImageView *)[self viewWithTag:(SECTION_IV_TAG_BEGIN +currentExtendSection)];
    
    [UIView animateWithDuration:0.3 animations:^{
        currentIV.transform = CGAffineTransformRotate(currentIV.transform, DEGREES_TO_RADIANS(180));
    }];
    
    if (currentExtendSection == section) {
        [self hideExtendedChooseView];
    }else{
        currentExtendSection = section;
        currentIV = (UIImageView *)[self viewWithTag:SECTION_IV_TAG_BEGIN + currentExtendSection];
        [UIView animateWithDuration:0.3 animations:^{
            currentIV.transform = CGAffineTransformRotate(currentIV.transform, DEGREES_TO_RADIANS(180));
        }];
        
        [self showChooseListViewInSection:currentExtendSection choosedIndex:[self.dropDownDataSource defaultShowSection:currentExtendSection]];
    }

}

- (void)setTitle:(NSString *)title inSection:(NSInteger) section
{
    UIButton *btn = (id)[self viewWithTag:SECTION_BTN_TAG_BEGIN +section];
    
    [btn setTitle:title forState:UIControlStateNormal];
}

- (BOOL)isShow
{
    if (currentExtendSection == -1) {
        return NO;
    }
    return YES;
}

-  (void)hideExtendedChooseView
{
    if (currentExtendSection != -1) {
        currentExtendSection = -1;
        CGRect rect = self.mTableView.frame;
        rect.size.height = 0;
        [UIView animateWithDuration:0.3 animations:^{
            self.mTableBaseView.alpha = 1.0f;
            self.mTableView.alpha = 1.0f;
            
            self.mTableBaseView.alpha = 0.2f;
            self.mTableView.alpha = 0.2;
            
            self.mTableView.frame = rect;
        }completion:^(BOOL finished) {
            [self.mTableView removeFromSuperview];
            [self.mTableBaseView removeFromSuperview];
        }];
    }
}

-(void)showChooseListViewInSection:(NSInteger)section choosedIndex:(NSInteger)index
{
    if (!self.mTableView) {
        
        self.mTableBaseView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.origin.x+16, self.frame.origin.y + self.frame.size.height , self.frame.size.width, 180)];
      
        self.mTableBaseView.backgroundColor= [UIColor clearColor];
        
        UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTappedAction:)];
        
        [self.mTableBaseView addGestureRecognizer:bgTap];
        
        self.mTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.frame.origin.x+16, self.frame.origin.y + self.frame.size.height, self.frame.size.width, 180) style:UITableViewStyleGrouped];
        
        self.mTableView.backgroundColor= [UIColor lightGrayColor];
        
        self.mTableView.delegate = self;
        
        self.mTableView.dataSource = self;
        
    }
    
    //修改tableview的frame
    
    CGRect rect = self.mTableView.frame;
    
    rect.origin.x = 16;
    
    rect.size.width = 288;
    
    rect.size.height = 0;
    
    self.mTableView.frame = rect;
    
    [self.mSuperView addSubview:self.mTableBaseView];
    
    [self.mSuperView addSubview:self.mTableView];
    
    //动画设置位置
    rect .size.height = 170;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.mTableBaseView.alpha = 0.2;
        
        self.mTableView.alpha = 0.2;
        
        self.mTableBaseView.alpha = 1.0;
        
        self.mTableView.alpha = 1.0;
        
        self.mTableView.frame =  rect;
    }];
    
    [self.mTableView reloadData];
}

-(void)bgTappedAction:(UITapGestureRecognizer *)tap
{
    UIImageView *currentIV = (UIImageView *)[self viewWithTag:(SECTION_IV_TAG_BEGIN + currentExtendSection)];
    [UIView animateWithDuration:0.3 animations:^{
        currentIV.transform = CGAffineTransformRotate(currentIV.transform, DEGREES_TO_RADIANS(180));
    }];
    [self hideExtendedChooseView];
}

#pragma mark -- UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dropDownDelegate respondsToSelector:@selector(chooseAtSection:index:)]) {
        
        NSString *chooseCellTitle = [self.dropDownDataSource titleInSection:currentExtendSection index:indexPath.row];
        
        UIButton *currentSectionBtn = (UIButton *)[self viewWithTag:SECTION_BTN_TAG_BEGIN + currentExtendSection];
        
        [currentSectionBtn setTitle:chooseCellTitle forState:UIControlStateNormal];
        
        [self.dropDownDelegate chooseAtSection:currentExtendSection index:indexPath.row];
        [self hideExtendedChooseView];
    }
}

#pragma mark -- UITableView DataSource


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dropDownDataSource numberOfRowsInSection:currentExtendSection];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = [self.dropDownDataSource titleInSection:currentExtendSection index:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    cell.textLabel.textColor= [UIColor blackColor];
  
    
    return cell;
}



@end
