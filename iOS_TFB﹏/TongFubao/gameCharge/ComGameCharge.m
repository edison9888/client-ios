//
//  ComGameCharge.m
//  TongFubao
//
//  Created by ec on 14-6-9.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "ComGameCharge.h"
#import "GameMoneyChoiceCtr.h"

@interface ComGameCharge ()

{
    NLProgressHUD* _hud;
}

@property (nonatomic,strong) UITableView *table;

@property (nonatomic,strong) NSMutableArray                     *dataArray;

@property (nonatomic,assign) BOOL isFirst;

@property (nonatomic, strong) NSMutableArray                    *gameIndex;

@end

@implementation ComGameCharge

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
    self.view.backgroundColor = [UIColor blueColor];

    [self UIInit];
}

-(void)UIInit
{
    _dataArray = [NSMutableArray array];
    

    _gameIndex = [NSMutableArray array];
    
   
    _isFirst = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect rect = self.view.bounds;
    rect.size.height = [NLUtils getDeviceHeight]-108;
    
    //tableview
    
    _table = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    [self setExtraCellLineHidden:_table];
    if (IOS7_OR_LATER) {
        _table.sectionIndexBackgroundColor = [UIColor clearColor];
    }
    
    [self.view addSubview:_table];

}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}

#pragma mark - table view datasource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (tableView == _table) {
        return _gameIndex;
    }else{
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *strCellID = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    NSDictionary *singleDic = _dataArray[indexPath.row];
    
    cell.textLabel.text = singleDic[@"platformName"];
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor grayColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *singleDic = _dataArray[indexPath.row];
    
    GameMoneyChoiceCtr *moneyChoiceCtr = [[GameMoneyChoiceCtr alloc]initWithInfor:singleDic];
    UIViewController *vc = (UIViewController*)[[[self.view superview] superview]nextResponder];
    [vc.navigationController pushViewController:moneyChoiceCtr animated:YES];
 
    [TFData getTempData][RECORD_COM_FLAG] = @"yes";
}

//获取列表
-(void)getComGameList
{
    if (_isFirst) {
        NSString* name = [NLUtils getNameForRequest:Notify_gameCharge_getplatformList];
        REGISTER_NOTIFY_OBSERVER(self, getPlatformListNotify, name);
        [[[NLProtocolRequest alloc] initWithRegister:YES] getGameChargeplatform];
//        [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    }
}

-(void)getPlatformListNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        
        [self doGetPlatformListNotify:response];
        
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

-(void)doGetPlatformListNotify:(NLProtocolResponse*)response
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
        
        _isFirst = NO;
        
        NSArray *platformIdArr = [response.data find:@"msgbody/msgchild/platformId"];
        NSArray *platformNameArr = [response.data find:@"msgbody/msgchild/platformName"];
        NSString *platformIdStr = nil;
        NSString *platformNameStr = nil;
        
        for (int i = 0 ; i<platformIdArr.count; i++) {
            
            NLProtocolData* data = [platformIdArr objectAtIndex:i];
            platformIdStr = data.value;
            data = [platformNameArr objectAtIndex:i];
            platformNameStr = data.value;
            
           [_dataArray addObject:@{@"gameId":platformIdStr,@"platformName":platformNameStr}];
        
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
