//
//  MobileReChangeDetailCtr.m
//  TongFubao
//
//  Created by ec on 14-4-29.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "MobileReChangeDetailCtr.h"
#import "NLUserInforSettingsCell.h"

@interface MobileReChangeDetailCtr ()

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (nonatomic,strong) NSDictionary *myDict;

@property (nonatomic,strong) NSArray *myArr;

@end

@implementation MobileReChangeDetailCtr

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
    // Do any additional setup after loading the view from its nib.
    
    [self dataInit];
    [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
    [self setExtraCellLineHidden:self.myTableView];
}

-(void)setData:(NSDictionary *)dict
{
    _myDict = dict;
}

//充值金额 rechamoney
//支付金额   rechapaymoney
//手机号码   rechamobile
//手机所属地  Rechamobileprov
//银行卡号   rechabkcardno
//订单时间   rechadatetime
//订单状态   rechastate

-(void)dataInit
{
    
    switch (self.myChargeHistoryType) {
        case MobileChargeType:
        {
            [self mobileDataInit];
        }
            break;
        case QCoinChargeType:
        {
            [self QQDataInit];
        }
            break;
        case buySKQType:
        {
            [self SKQDataInit];
        }
            break;
        case WaterEleType:
        {
            [self waterEleDataInit];
        }
            break;
        case GameType:
        {
            [self gameDataInit];
        }
            break;
        default:
            break;
    }
}


-(void)mobileDataInit
{
    NSString *stateStr;
    if ([_myDict[@"rechastate"] intValue]==0) {
        stateStr = @"成功";
    }else{
        stateStr = @"失败";
    }
    _myArr = @[@{@"type":@"充值金额",@"content":_myDict[@"rechamoney"]},@{@"type":@"支付金额",@"content":_myDict[@"rechapaymoney"]},@{@"type":@"手机号码",@"content":_myDict[@"rechamobile"]},@{@"type":@"手机所属地",@"content":_myDict[@"rechamobileprov"]},@{@"type":@"银行卡号",@"content":_myDict[@"rechabkcardno"]},@{@"type":@"订单时间",@"content":_myDict[@"rechadatetime"]},@{@"type":@"订单状态",@"content":stateStr}];

}

-(void)QQDataInit
{
    NSString *stateStr;
    if ([_myDict[@"rechastate"] intValue]==0) {
        stateStr = @"成功";
    }else{
        stateStr = @"失败";
    }
    _myArr = @[@{@"type":@"充值金额",@"content":_myDict[@"rechamoney"]},@{@"type":@"支付金额",@"content":_myDict[@"rechapaymoney"]},@{@"type":@"QQ号码",@"content":_myDict[@"rechamobile"]},@{@"type":@"银行卡号",@"content":_myDict[@"rechabkcardno"]},@{@"type":@"订单时间",@"content":_myDict[@"rechadatetime"]},@{@"type":@"订单状态",@"content":stateStr}];
    
}

-(void)SKQDataInit
{
    NSString *orderpaystatusStr;
    NSString *orderstateStr;
    if ([_myDict[@"orderpaystatus"] intValue]==0) {
        orderpaystatusStr = @"成功";
    }else{
        orderpaystatusStr = @"失败";
    }
    
    if ([_myDict[@"orderstate"] intValue]==0) {
        orderstateStr = @"成功";
    }else{
        orderstateStr = @"失败";
    }
    
    _myArr =
  @[@{@"type":@"订单编号",@"content":_myDict[@"orderno"]},
  @{@"type":@"产品名称",@"content":_myDict[@"orderprodurename"]},
  @{@"type":@"购买数量",@"content":_myDict[@"ordernum"]},
  @{@"type":@"购买单价",@"content":_myDict[@"orderprice"]},
  @{@"type":@"订单金额",@"content":_myDict[@"ordermoney"]},
  @{@"type":@"详细收货地址",@"content":_myDict[@"ordershaddress"]},
  @{@"type":@"收货人",@"content":_myDict[@"ordershman"]},
  @{@"type":@"收货电话",@"content":_myDict[@"ordershphone"]},
  @{@"type":@"支付状态",@"content":_myDict[@"orderpaystatus"]},
  @{@"type":@"订单状态",@"content":_myDict[@"orderstate"]},
  @{@"type":@"物流订单号",@"content":_myDict[@"wlno"]},
  @{@"type":@"运费金额",@"content":_myDict[@"yunmoney"]},
  @{@"type":@"产品总额",@"content":_myDict[@"promoney"]}];
}

-(void)waterEleDataInit
{
    NSString *stateStr;
    if ([_myDict[@"status"] intValue]==0) {
        stateStr = @"已支付";
    }else{
        stateStr = @"未支付";
    }
    
    _myArr = @[@{@"type":@"订单编号",@"content":_myDict[@"bkntno"]},@{@"type":@"实际金额",@"content":_myDict[@"factNumber"]},@{@"type":@"支付金额",@"content":_myDict[@"payNumber"]},@{@"type":@"收费单位",@"content":_myDict[@"company"]},@{@"type":@"状态",@"content":stateStr},@{@"type":@"完成时间",@"content":_myDict[@"completeTime"]}];
}

-(void)gameDataInit
{
    _myArr = @[@{@"type":@"订单编号",@"content":_myDict[@"bkntno"]},@{@"type":@"充值数量",@"content":_myDict[@"quantity"]},@{@"type":@"总价格",@"content":_myDict[@"totalPrice"]},@{@"type":@"游戏",@"content":_myDict[@"gamename"]},@{@"type":@"账号",@"content":_myDict[@"account"]},@{@"type":@"完成时间",@"content":_myDict[@"completeTime"]}];
}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return _myArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = _myArr[indexPath.row];
    NLUserInforSettingsCell *cell = nil;
    
    static NSString *kCellID = @"NLUsersInforSettingsCell";
    cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    
    if (cell == nil)
    {
        NSArray* temp = [[NSBundle mainBundle] loadNibNamed:kCellID owner:self options:nil];
        cell=[temp objectAtIndex:0];
    }
    
    cell.myTextField.hidden = YES;
    cell.myDownrightBtn.hidden = YES;
    cell.myUprightBtn.hidden = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    cell.myHeaderLabel.hidden = NO;
    cell.myHeaderLabel.text = dict[@"type"];
    cell.myContentLabel.hidden = NO;
    cell.myContentLabel.textAlignment = NSTextAlignmentLeft;
    cell.myContentLabel.text = dict[@"content"];
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
