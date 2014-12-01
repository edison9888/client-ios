//
//  selectionPerson.m
//  TongFubao
//
//  Created by kin on 14-8-20.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "selectionPerson.h"
#import "TicketCustomTableViewCell.h"
@implementation selectionPerson

@synthesize selectionTableView,styUnmber,styWorld;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = RGBACOLOR(19, 193, 245, 1);
        self.selectionTableView = [[UITableView alloc]initWithFrame:CGRectMake(5, 5, self.frame.size.width-10, self.frame.size.height-10)];
        self.selectionTableView.delegate = self;
        self.selectionTableView.dataSource =self;
        [self addSubview:self.selectionTableView];
        self.styWorld = [[NSMutableArray alloc]initWithObjects:@"身份证",@"护照",@"军人证",@"回乡证",@"台胞证",@"港澳通行证",@"国际海员证",@"外国人永久居留证",@"户口簿",@"出生证明",@"其它", nil];
        self.styUnmber = [[NSMutableArray alloc]initWithObjects:@"1",@"2",@"4",@"7",@"8",@"10",@"11",@"20",@"25",@"27",@"99",nil];
    }
    return self;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.styWorld count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indefault = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indefault];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:indefault];
    }
    cell.textLabel.text = [self.styWorld objectAtIndex:indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate selectionPersonstyUnmber:[self.styUnmber objectAtIndex:indexPath.row] selectionPersonstystyWorld:[self.styWorld objectAtIndex:indexPath.row]];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end





























