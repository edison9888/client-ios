//
//  ACTwoAgentsViewController.m
//  TFB_代理商界面
//
//  Created by 湘郎 on 14-11-25.
//  Copyright (c) 2014年 MacAir. All rights reserved.
//


#import "ACTwoAgentsViewController.h"
#import "XIAOYU_TheControlPackage.h"
#import "ACTwoAgentsCell.h"

@interface ACTwoAgentsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *table;
}

@end

@implementation ACTwoAgentsViewController


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
    
    self.title = @"二级代理商";
    
    self.splittingJine = @"￥304.00";
    
    [self leftBarButtonBack];
    
    [self tableVC];
    
    
    
}



#pragma mark - UITableView创建
-(void)tableVC{

    table = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    
    UIView *vc = [[UIView alloc]initWithFrame:CGRectMake(0, 0, table.frame.size.width, 100)];
    vc.backgroundColor = RGBACOLOR(242, 242, 242, 1.0);
    table.tableHeaderView = vc;
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(120, 8, 100, 21)];
    //    label1.backgroundColor = [UIColor redColor];
    label1.text = @"分润贡献总额";
    label1.font = [UIFont systemFontOfSize:14];
    label1.textColor = RGBACOLOR(93, 93, 93, 1.0);
    [vc addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 25, table.frame.size.width, 50)];
    //    label2.backgroundColor = [UIColor redColor];
    label2.text = self.splittingJine;
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = [UIFont systemFontOfSize:32];
    label2.textColor = RGBACOLOR(111, 111, 111, 1.0);
    [vc addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(112, 70, 100, 21)];
    //    label3.backgroundColor = [UIColor redColor];
    label3.text = @"分润贡献排行榜";
    label3.font = [UIFont systemFontOfSize:14];
    label3.textColor = RGBACOLOR(235, 134, 51, 1.0);
    [vc addSubview:label3];
    
    UIImageView *image1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 80, 90, 1)];
    image1.backgroundColor = RGBACOLOR(239, 189, 165, 1.0);
    [vc addSubview:image1];
    
    UIImageView *image2 = [[UIImageView alloc]initWithFrame:CGRectMake(230, 80, 90, 1)];
    image2.backgroundColor = RGBACOLOR(239, 189, 165, 1.0);
    [vc addSubview:image2];
    
    UIImageView *image3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 99, table.frame.size.width, 1)];
    image3.backgroundColor = RGBACOLOR(158, 158, 158, 1.0);
    [vc addSubview:image3];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 5;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACTwoAgentsCell*cell;
    static NSString *identifier = @"ACTwoAgentsCell";
    cell = (ACTwoAgentsCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ACTwoAgentsCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    
//    SMSMode *mode = [SMSMode useWithDictionary:[smsArray objectAtIndex:indexPath.row]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 95.0;
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
