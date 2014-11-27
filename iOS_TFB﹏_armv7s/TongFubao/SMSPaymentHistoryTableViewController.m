//
//  SMSPaymentHistoryTableViewController.m
//  TongFubao
//
//  Created by 湘郎 on 14-11-18.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "SMSPaymentHistoryTableViewController.h"

#import "SMSPaymentHistoryCell.h"
#import "SMSMode.h"

#import "XIAOYU_TheControlPackage.h"

@interface SMSPaymentHistoryTableViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *smsArray;
    NLProgressHUD *_hud;
    UITableView *table;
}


@end

@implementation SMSPaymentHistoryTableViewController

-(void)tapleftBarButtonItemBack{
    [self.navigationController popViewControllerAnimated:YES];
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"收款历史";
        
        [self showErrorInfo:@"请稍后" status:NLHUDState_None];
//        [_hud hide:YES afterDelay:2];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [self leftBarButtonItem];
    smsArray = [NSMutableArray array];

    table = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    
    // Do any additional setup after loading the view.
}

#pragma mark - 网络请求 历史记录
-(void)historicalRecords{
    
    
    
    NSDictionary *dataDictionary;// = @{ @"money" : textFields.text};
    
    [LoadDataWithASI loadDataWithMsgbody:dataDictionary apiName:@"ApiSMSReceiptInfo" apiNameFunc:@"readSMSReceiptList" rolePath:@"//operation_response/msgbody/msgchild" type:PublicList completionBlock:^( id data, NSError *error)
     {
         
         [_hud hide:YES];
         
         if ([[data valueForKey:@"money"] objectAtIndex:0] == nil)
         {
             NSLog(@"解析失败");
             
             [self showErrorInfo:@"数据加载失败" status:NLHUDState_Error];
             
         }else
         {
             
             NSLog(@"解析成功");
             //             [self showErrorInfo:@"数据加载成功" status:NLHUDState_NoError];
             
             for (NSDictionary *dic in data) {
                 [smsArray addObject:dic];
             }
             NSLog(@"^^^^^^^^ %d",smsArray.count);
             [table reloadData];//刷新列表数据
             
             
             /*
              for (NSDictionary *dict in data) {
              NSString *str = [dict objectForKey:@"fumobile"];
              NSString *str2 = [dict objectForKey:@"smsrdate"];
              NSString *str3 = [dict objectForKey:@"money"];
              NSString *str4 = [dict objectForKey:@"smsrstate"];
              NSLog(@"\n%@\n%@\n%@\n%@",str,str2,str3,str4);
              }
              */
         }
         
     }];
    
    
}


-(void)showErrorInfo:(NSString*)error status:(NLHUDState)status
{
    [_hud hide:YES];
    _hud = [[NLProgressHUD alloc] initWithParentView: self.view];
    
    switch (status)
    {
        case NLHUDState_Error:
        {
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unCheckmark.png"]] ;//失败
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.detailsLabelText = error;
            [_hud show:YES];
            [_hud hide:YES afterDelay:2];
        }
            break;
            
        case NLHUDState_NoError:
        {
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.png"]] ;//成功
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.labelText = error;
            [_hud show:YES];
            [_hud hide:YES afterDelay:2];
            
            
        }
            break;
            
        case NLHUDState_None:
        {
            //调用记录接口
            [self historicalRecords];
            
            _hud.labelText = error;
            [_hud show:YES];
            
        }
            break;
            
        default:
            break;
    }
    return;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return smsArray.count;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    SMSPaymentHistoryCell*cell;
    static NSString *identifier = @"SMSPaymentHistoryCell";
    cell = (SMSPaymentHistoryCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SMSPaymentHistoryCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    
        SMSMode *mode = [SMSMode useWithDictionary:[smsArray objectAtIndex:indexPath.row]];
        //电话
        NSString *phone1 = [mode.historyPhone substringToIndex:3];
        NSString *phone2 = [mode.historyPhone substringFromIndex:7];
        NSString *phone3 = [NSString stringWithFormat:@"%@%@%@",phone1,@"****",phone2];
        cell.phone.text = phone3;
        
        //交易日期
        NSString *transactionState = [mode.historyDate substringWithRange:NSMakeRange(0, 16)];
        cell.transactionDtae.text = transactionState;
        
        //金额
        NSString *money = [NSString stringWithFormat:@"%@%@",@"+",mode.historyMoney];
        cell.amountOfMoney.text = money;
        
        //交易状态
        cell.transactionState.text = [NSString stringWithFormat:@"%@",mode.historyState];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SMSMode *mode = [SMSMode useWithDictionary:[smsArray objectAtIndex:indexPath.row]];
    
    [self.delegate agent:self paymentHistoryPhone:mode.historyPhone];
    
    [self.navigationController popViewControllerAnimated:YES];
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
