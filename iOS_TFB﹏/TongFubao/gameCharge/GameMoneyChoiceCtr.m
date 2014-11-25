//
//  GameMoneyChoiceCtr.m
//  TongFubao
//
//  Created by ec on 14-6-9.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "GameMoneyChoiceCtr.h"
#import "GameDetailInfoChoiceCtr.h"

@interface GameMoneyChoiceCtr ()

{
    NLProgressHUD* _hud;
}

@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) NSDictionary *information;

@end

@implementation GameMoneyChoiceCtr

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithInfor:(NSDictionary*)infor
{
    if (self = [super init]) {
        if (infor) {
            _information = [NSDictionary dictionaryWithDictionary:infor];
        }else{
            _information = [NSDictionary dictionary];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self UIInit];
    [self performSelector:@selector(getData) withObject:nil afterDelay:0.2];
}

-(void)UIInit
{
    UIView *zeroView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:zeroView];
    self.title = @"面值选择";
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat ctrH = [NLUtils getCtrHeight];
    
    CGFloat IOS7HEIGHT=IOS7_OR_LATER==YES?64:0;
    
    CGFloat tableHeight=IOS7_OR_LATER==YES?(ctrH-64):ctrH;
    
    //查询表
    _table = [[UITableView alloc]initWithFrame:CGRectMake(0, IOS7HEIGHT, 320, tableHeight)];
    [self setExtraCellLineHidden:_table];
    _table.backgroundColor = [UIColor whiteColor];
    _table.dataSource = self;
    _table.delegate = self;
    [self.view addSubview:_table];
    
    //虚拟数据
    _dataArr = [NSMutableArray array];
}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *singleDic = _dataArr[indexPath.row];
    static NSString *cellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.text = singleDic[@"gameName"];
    cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right_yellow_arrow"]];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor grayColor];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
     NSDictionary *singleDic = _dataArr[indexPath.row];
    
    GameDetailInfoChoiceCtr *detailInfoChoiceCtr = [[GameDetailInfoChoiceCtr alloc]initWithInfor:singleDic];
    
    detailInfoChoiceCtr.title = @"详细信息选择";
    [self.navigationController pushViewController:detailInfoChoiceCtr animated:YES];
}

//获取列表
-(void)getData
{
    NSString* name = [NLUtils getNameForRequest:Notify_gameCharge_getChildGame];
    REGISTER_NOTIFY_OBSERVER(self, getChildGameNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] getGameChargeChildGame:_information[@"gameId"]];
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
}

-(void)getChildGameNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        
        [self doGetChildGameNotify:response];
        
    }
    else if (error == RSP_TIMEOUT)
    {
        [self showErrorInfo:@"请求超时,需要重新登录" status:NLHUDState_Error];
        [self performSelector:@selector(doPush) withObject:nil afterDelay:2.0f];
        return;
    }
    else
    {
        [_hud hide:YES];
        NSString *detail = response.detail;
        if (!detail || detail.length <= 0)
        {
            detail = @"请求失败，请检查网络";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

-(void)doGetChildGameNotify:(NLProtocolResponse*)response
{
    
    NLProtocolData* data = [response.data find:@"msgbody/result" index:0];
    NSString *result = data.value;
    NSRange range = [result rangeOfString:@"succ"];
    if (range.length <= 0)
    {
        NLProtocolData* data = [response.data find:@"msgbody/message" index:0];
        NSString* value = data.value;
        [self showErrorInfo:value status:NLHUDState_Error];
    }else{
        
        NSArray *gameIdArr = [response.data find:@"msgbody/msgchild/gameId"];
        NSArray *gameNameArr = [response.data find:@"msgbody/msgchild/gameName"];
        NSArray *priceArr = [response.data find:@"msgbody/msgchild/price"];
        NSArray *costArr= [response.data find:@"msgbody/msgchild/cost"];
      
        NSString *gameIdStr = nil;
        NSString *gameNameStr = nil;
        NSString *priceStr = nil;
        NSString *costStr = nil;
        
        for (int i = 0 ; i<gameIdArr.count; i++) {
            
            NLProtocolData* data = [gameIdArr objectAtIndex:i];
            gameIdStr = data.value;
            data = [gameNameArr objectAtIndex:i];
            gameNameStr = data.value;
            data = [priceArr objectAtIndex:i];
            priceStr = data.value;
            data = [costArr objectAtIndex:i];
            costStr= data.value;

            [_dataArr addObject:@{@"gameId":gameIdStr,@"gameName":gameNameStr,@"price":priceStr,@"cost":costStr}];
            
            [[NSUserDefaults standardUserDefaults]setObject:_dataArr forKey:@"gameArr"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^void {
            [_table reloadData];
        });
    }
    
}

//超时
- (void) doPush
{
    [_hud hide:YES];
    [NLUtils popToLogonVCByHTTPError:(UIViewController*)[[[self nextResponder] nextResponder] nextResponder] feedOrLeft:1];
    
}

#pragma showErrorInfo
//判断信息是否正确
-(void)showErrorInfo:(NSString*)detail status:(NLHUDState)status
{
    [_hud hide:YES];
    _hud = [[NLProgressHUD alloc] initWithParentView:self.view];
    switch (status)
    {
        case NLHUDState_Error:
        {
            _hud.detailsLabelText = detail;
            
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unCheckmark.png"]] ;
            
            _hud.mode = MBProgressHUDModeCustomView;
            
            [_hud show:YES];
            
            [_hud hide:YES afterDelay:2];
            
        }
            break;
            
        case NLHUDState_NoError:
        {
            _hud.labelText = detail;
            
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.png"]] ;
            
            _hud.mode = MBProgressHUDModeCustomView;
            [_hud show:YES];
            
            [_hud hide:YES afterDelay:2];
            
        }
            break;
            
        case NLHUDState_None:
        {
            _hud.labelText = detail;
            
            [_hud show:YES];
        }
            
        default:
            break;
    }
    return;
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
