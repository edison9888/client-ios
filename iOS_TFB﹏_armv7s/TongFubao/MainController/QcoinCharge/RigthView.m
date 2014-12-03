//
//  RigthView.m
//  TongFubao
//
//  Created by kin on 14-8-18.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "RigthView.h"
#import "TicketCustomTableViewCell.h"

@implementation RigthView
@synthesize AirLineArray,AirLineKeys;


- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBACOLOR(19, 193, 245, 1);
//        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
//        button.frame = CGRectMake(0, 0, 160, 60);
//        button.titleLabel.text = @"所有航空";
//        button.titleLabel.font = [UIFont systemFontOfSize:20];
//        [button setTitle:button.titleLabel.text forState:(UIControlStateNormal)];
//        [button setImageEdgeInsets:(UIEdgeInsetsMake(0, 10, 0, 100))];
//        [button setImage:[UIImage imageNamed:@"9play@2x.png"] forState:(UIControlStateNormal)];
//        [button addTarget:self action:@selector(buttonSeletion) forControlEvents:(UIControlEventTouchUpInside)];
        
        self.rightTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 45, 160, self.frame.size.height-45)];
        self.rightTableView.delegate = self;
        self.rightTableView.dataSource = self;
//        self.rightTableView.tableFooterView = button;
        self.rightTableView.separatorColor = [UIColor clearColor];
        self.rightTableView.backgroundColor = RGBACOLOR(19, 193, 245, 1);
        [self addSubview:self.rightTableView];
    }
    return self;
}
- (void)ariNameDictionary:(NSMutableSet *)newariNameDictionary AirLineKeys:(NSMutableSet *)newAirLineKeys
{
    NSMutableArray *AirLineDicArray = [[NSMutableArray alloc]init];
//    NSMutableArray *AirLineDicKeys = [[NSMutableArray alloc]init];

    for (NSString *Dictionary in newariNameDictionary)
    {
        [AirLineDicArray addObject:Dictionary];
    }
    self.AirLineArray = AirLineDicArray;
    if ([self.AirLineArray count] > 0)
    {
        NSDictionary *allAirLineDic = [[NSDictionary alloc]initWithObjectsAndKeys:@"所有航空",@"KEY", nil];
        [self.AirLineArray addObject:allAirLineDic];
    }

//    NSLog(@"========newariNameDictionary======%@",AirLineArray);
//    for (NSString *key in newAirLineKeys)
//    {
//        [AirLineDicKeys addObject:key];
//    }
//    self.AirLineKeys = AirLineDicKeys;
    
    [self.rightTableView reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return [self.AirLineArray count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(TicketCustomTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indefault = @"cell";
    TicketCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indefault];
    if (!cell) {
        cell = [[TicketCustomTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:indefault];
    }
    cell.backgroundColor = [UIColor clearColor];
    UIView *backviewcell=[[UIView alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    backviewcell.backgroundColor=RGBACOLOR(165, 238, 255, 1);
    cell.selectedBackgroundView=backviewcell;
    
    NSString *key = [[[self.AirLineArray objectAtIndex:indexPath.row] allKeys] objectAtIndex:0];
    NSString *keyVlue = [[self.AirLineArray objectAtIndex:indexPath.row] objectForKey:key];
//    NSLog(@"========key======%@",key);
//    NSLog(@"========keyVlue======%@",keyVlue);
    [cell titleLable:keyVlue cellImage:[NSString stringWithFormat:@"%@@2x.png",key]];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [[[self.AirLineArray objectAtIndex:indexPath.row] allKeys] objectAtIndex:0];
    [self.delegate AirLineCode:key];
}
-(void)buttonSeletion
{
    [self.delegate ClearData];
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























