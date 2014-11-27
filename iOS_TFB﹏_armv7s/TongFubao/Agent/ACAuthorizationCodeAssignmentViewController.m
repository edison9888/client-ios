//
//  ACAuthorizationCodeAssignmentViewController.m
//  TFB_代理商界面
//
//  Created by 湘郎 on 14-11-26.
//  Copyright (c) 2014年 MacAir. All rights reserved.
//

#import "ACAuthorizationCodeAssignmentViewController.h"
#import "ACDistributionRecordsViewController.h"
#import "ACAssignmentCell.h"
#import "XIAOYU_TheControlPackage.h"

@interface ACAuthorizationCodeAssignmentViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *table;
}


@end

@implementation ACAuthorizationCodeAssignmentViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.authorizationCount = @"720";
    
    self.title = @"授权码分配";
    
    [self leftBarButtonBack];//返回按钮
    
    [self distributionRecords];//分配记录
    
    [self tableVC];//UITableView
}
 
 
#pragma mark - 分配记录
-(void)distributionRecords{
    
    [self rightButtonItemWithTitle:@"已分配记录" Frame:CGRectMake(0, 0, 80, 28) backgroundImage:[UIImage imageNamed:@"SMS_historybtn_normal@2x"] backgroundImageHighlighted:[UIImage imageNamed:@"SMS_historybtn_pressed@2x"]];
}



#pragma mark - 跳转分配记录
-(void)tapRightButtonItem:(id)sender{
    NSLog(@"分配记录");
    ACDistributionRecordsViewController *vc = [[ACDistributionRecordsViewController alloc]init];
    [self jumpViewController:self newViewController:vc PushAndPresent:YES];
    
}


#pragma mark - UITableView创建
-(void)tableVC{
    
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    
    UIView *vc = [[UIView alloc]initWithFrame:CGRectMake(0, 0, table.frame.size.width, 160)];
    vc.backgroundColor = RGBACOLOR(242, 242, 242, 1.0);
    table.tableHeaderView = vc;
    
    
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 300, 50)];
//    imageView1.backgroundColor = [UIColor redColor];
    imageView1.image = [UIImage imageNamed:@"AC_InputBox"];
    [vc addSubview:imageView1];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 170, 21)];
//    label2.backgroundColor = [UIColor redColor];
    label2.text = @"剩余可分配授权码个数 :";
    [label2 setTextAlignment:NSTextAlignmentLeft];
    label2.font = [UIFont systemFontOfSize:16];
    [imageView1 addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(190, 0, 100, 50)];
//    label3.backgroundColor = [UIColor redColor];
    label3.text = self.authorizationCount;
    label3.textColor = RGBACOLOR(233, 142, 52, 1.0);
    [label3 setTextAlignment:NSTextAlignmentCenter];
    label3.font = [UIFont systemFontOfSize:24];
    [imageView1 addSubview:label3];
    
    
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 90, 100, 21)];
    //    label1.backgroundColor = [UIColor redColor];
    label1.text = @"未分配清单";
    label1.font = [UIFont boldSystemFontOfSize:13];
    label1.textColor = RGBACOLOR(88, 86, 87, 1.0);
    [vc addSubview:label1];
    
    UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 119, 320, 41)];
    imageView2.image = [UIImage imageNamed:@"AC_InputBox"];
    [vc addSubview:imageView2];
    
    UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(20, 130, 60, 21)];
//    label4.backgroundColor = [UIColor redColor];
    label4.text = @"授权码";
    [label4 setTextAlignment:NSTextAlignmentCenter];
    label4.font = [UIFont systemFontOfSize:16];
    [vc addSubview:label4];
    
    UILabel *label5 = [[UILabel alloc]initWithFrame:CGRectMake(130, 130, 80, 21)];
//    label5.backgroundColor = [UIColor redColor];
    label5.text = @"分配账户";
    [label5 setTextAlignment:NSTextAlignmentCenter];
    label5.font = [UIFont systemFontOfSize:16];
    [vc addSubview:label5];
    
    UILabel *label6 = [[UILabel alloc]initWithFrame:CGRectMake(255, 130, 40, 21)];
//    label6.backgroundColor = [UIColor redColor];
    label6.text = @"操作";
    [label6 setTextAlignment:NSTextAlignmentCenter];
    label6.font = [UIFont systemFontOfSize:16];
    [vc addSubview:label6];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 3;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACAssignmentCell*cell;
    static NSString *identifier = @"ACAssignmentCell";
    cell = (ACAssignmentCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ACAssignmentCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    //    SMSMode *mode = [SMSMode useWithDictionary:[smsArray objectAtIndex:indexPath.row]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 41.0;
}



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
