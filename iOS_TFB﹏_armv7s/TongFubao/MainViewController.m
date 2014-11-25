//
//  MainViewController.m
//  NT
//
//  Created by 〝Cow﹏. on 14-11-17.
//  Copyright (c) 2014年 〝Cow﹏. All rights reserved.
//

#import "MainViewController.h"
#import "agentEarningsCell.h"
#import "agentEarningClassCell.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
     
        NSDictionary *dic = @{@"Cell": @"agentEarningsCell",@"isAttached":@(NO)};
        NSArray * array = @[dic,dic,dic,dic,dic,dic];
        
        self.dataArray = [[NSMutableArray alloc]init];
        self.dataArray = [NSMutableArray arrayWithArray:array];
        
        self.title = @"收益demo";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _table.separatorStyle= UITableViewCellSeparatorStyleSingleLineEtched;
   [_table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    if ([[self.dataArray[indexPath.row] objectForKey:@"Cell"] isEqualToString:@"agentEarningsCell"])
    {
        static NSString *CellIdentifier = @"agentEarningsCell";
        agentEarningsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[agentEarningsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        return cell;
        
    }
    else if([[self.dataArray[indexPath.row] objectForKey:@"Cell"] isEqualToString:@"agentEarningClassCell"])
    {
        
        static NSString *CellIdentifier = @"agentEarningClassCell";
        
        agentEarningClassCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = [[agentEarningClassCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        return cell;
    }
    return nil;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSIndexPath *path = nil;
    
    if ([[self.dataArray[indexPath.row] objectForKey:@"Cell"] isEqualToString:@"agentEarningsCell"])
    {
        path = [NSIndexPath indexPathForItem:(indexPath.row+1) inSection:indexPath.section];
    }else
    {
        path = indexPath;
    }
    
    if ([[self.dataArray[indexPath.row] objectForKey:@"isAttached"] boolValue]) {
        /* 关闭附加cell */
        NSDictionary * dic = @{@"Cell": @"agentEarningsCell",@"isAttached":@(NO)};
        self.dataArray[(path.row-1)] = dic;
        [self.dataArray removeObjectAtIndex:path.row];
        
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[path]  withRowAnimation:UITableViewRowAnimationMiddle];
        [self.tableView endUpdates];
        
    }else
    {
         /* 打开附加cell */
        NSDictionary * dic = @{@"Cell": @"agentEarningsCell",@"isAttached":@(YES)};
        self.dataArray[(path.row-1)] = dic;
        NSDictionary * addDic = @{@"Cell": @"agentEarningClassCell",@"isAttached":@(YES)};
        [self.dataArray insertObject:addDic atIndex:path.row];
     
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationMiddle];
        [self.tableView endUpdates];
        
    }
 
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.dataArray[indexPath.row] objectForKey:@"Cell"] isEqualToString:@"agentEarningsCell"])
    {
        return 50;
    }else{
        return 40;
    }
}

@end
