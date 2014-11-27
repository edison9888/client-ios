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

static MainViewController *mView = nil;

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }

    return self;
}

-(void)reloadtable
{
    [_table reloadData];
}

+ (id)singleton
{
    if (!mView)
    {
        mView = [[MainViewController alloc]init];
    }
    return mView;
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
    return [TFData getarr].count;
}

/*cell点击展开*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[TFData getarr][indexPath.row] objectForKey:@"Cell"] isEqualToString:@"agentEarningsCell"])
    {
        static NSString *CellIdentifier = @"agentEarningsCell";
        agentEarningsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell)
        {
            NSArray* temp = [[NSBundle mainBundle] loadNibNamed:@"agentEarningsCell" owner:self options:nil];
            cell=[temp objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        else{
            
            [cell removeFromSuperview];
            cell= [[agentEarningsCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.backgroundView=nil;
        }
        
        if (indexPath.row == [[TFData getarr]  count]-1) {
            cell.iconCell.image= [UIImage imageNamed:@"yellowdot.png"];
            cell.typeCell.text= @"总收益";
            cell.moneyCell.textColor= RGBACOLOR(253, 154, 14, 1.0);
            if ( [TFData getdic][@"appfunEarn"] != nil)
            {
                cell.moneyCell.text= [NSString stringWithFormat:@"￥%@",[TFData getdic][@"appfunEarn"]];
            }else
            {
                cell.moneyCell.text= @"￥0.00";

            }
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.rightIcon.hidden= YES;
            cell.userInteractionEnabled= NO;
        }
        
        cell.typeCell.text= [[TFData getarr][indexPath.row] objectForKey:@"appfunName"];
         cell.moneyCell.text= [NSString stringWithFormat:@"￥%@",[[TFData getarr][indexPath.row] objectForKey:@"appfunEarn"]];
        
        return cell;
    }
    else if([[[TFData getarr][indexPath.row] objectForKey:@"Cell"] isEqualToString:@"agentEarningClassCell"])
    {

        static NSString *CellIdentifier = @"agentEarningClassCell";
        
        agentEarningClassCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
       
        if (!cell)
        {
            NSArray* temp = [[NSBundle mainBundle] loadNibNamed:@"agentEarningClassCell" owner:self options:nil];
            cell=[temp objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        else{
            
            [cell removeFromSuperview];
            cell= [[agentEarningClassCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.backgroundView=nil;
        }
        
//        NSDictionary *dataDictionary = @{ @"querytype" : [[TFData getarr][indexPath.row-1] objectForKey:@"querType"],@"querywhere" : [[TFData getarr][indexPath.row] objectForKey:@"querwhere"] ,@"appfunid" : [[TFData getarr][indexPath.row] objectForKey:@"appfunid"] };
//        
//        [LoadDataWithASI loadDataWithMsgbody:dataDictionary apiName:@"ApiAgentInfo" apiNameFunc:@"payagentfenrunlist" rolePath:@"//operation_response/msgbody/msgchild" type:PublicList completionBlock:^(id data, NSError *error) {
//            NSLog(@"msgchilddata %@",data);
//            
//            
//        }];
        
        cell.typecell.text= [[TFData getarr][indexPath.row] objectForKey:@"appfunName"];
        cell.moneycell.text= [NSString stringWithFormat:@"￥%@",[[TFData getarr][indexPath.row] objectForKey:@"appfunEarn"]];
        
        return cell;
    }
    return nil;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSIndexPath *path = nil;
    
    if ([[[TFData getarr][indexPath.row] objectForKey:@"Cell"] isEqualToString:@"agentEarningsCell"])
    {
        path = [NSIndexPath indexPathForItem:(indexPath.row+1) inSection:indexPath.section];
    }else
    {
        path = indexPath;
    }
    
    if ([[[TFData getarr][indexPath.row] objectForKey:@"isAttached"] boolValue]) {
        /* 关闭附加cell */
        NSDictionary * dic = @{@"Cell": @"agentEarningsCell",@"isAttached":@(NO)};
        [TFData getarr][(path.row-1)] = dic;
        [[TFData getarr] removeObjectAtIndex:path.row];
        
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[path]  withRowAnimation:UITableViewRowAnimationMiddle];
        [self.tableView endUpdates];
        
    }else
    {
         /* 打开附加cell */
        NSDictionary * dic = @{@"Cell": @"agentEarningsCell",@"isAttached":@(YES)};
        [TFData getarr][(path.row-1)] = dic;
        NSDictionary * addDic = @{@"Cell": @"agentEarningClassCell",@"isAttached":@(YES)};
        [[TFData getarr] insertObject:addDic atIndex:path.row];
     
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationMiddle];
        [self.tableView endUpdates];
        
    }
 
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[TFData getarr][indexPath.row] objectForKey:@"Cell"] isEqualToString:@"agentEarningsCell"])
    {
        return 50;
    }else{
        return 40;
    }
}

@end
