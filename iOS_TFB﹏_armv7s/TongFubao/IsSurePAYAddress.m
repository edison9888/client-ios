//
//  IsSurePAYAddress.m
//  TongFubao
//
//  Created by  俊   on 14-5-15.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "IsSurePAYAddress.h"
#import "AddressPAY.h"
#import "PAYSKQMore.h"
#import "NLUtils.h"
#import "NLProgressHUD.h"
#import "NLContants.h"
#import "NLProtocolRequest.h"
#import "SIAlertView.h"

@interface IsSurePAYAddress ()
{
    CGFloat IOS7HEIGHT;
    NLProgressHUD  * _hud;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@end

@implementation IsSurePAYAddress

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
  
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [NLUtils enableSliderViewController:NO];

    if ([TFData getTempData][ADD_SKQ_ADDRESS_FLAG]) {
        
        //手动增加过地址就需要刷新
        [self performSelector:@selector(readDefaultAddress) withObject:nil afterDelay:0.1];
        
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
      [NLUtils enableSliderViewController:YES];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *tempView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:tempView];
    
    IOS7HEIGHT=IOS7_OR_LATER==YES?64:0;
    // Do any additional setup after loading the view from its nib.
    self.title= @"默认地址";
   
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"增加地址"
                                                                      style:UIBarButtonItemStyleBordered
                                                                     target:self
                                                                     action:@selector(AddressAction)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    
    [self tableViewIsOn];
    
    _dataArr = [NSMutableArray array];
 
    /*接口-读取默认地址-+*/
    [self performSelector:@selector(readDefaultAddress) withObject:nil afterDelay:0.1];
}


- (void)tableViewIsOn
{
    
    self.view.backgroundColor = SACOLOR(226,1.0);
    CGFloat ctrH = [NLUtils getCtrHeight];
    
    CGFloat tableHeight=IOS7_OR_LATER==YES?(ctrH-64):ctrH;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, IOS7HEIGHT, 320, tableHeight)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle= NO;
    [self.view addSubview:_tableView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict;
 
    dict= _dataArr[indexPath.row];

    
    static NSString *cellIdentifier = @"agentSearchListCell";
    AddressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell = [[AddressCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    cell.listCellDelegate = self;
    
    if (indexPath.row%3==0)
    {
        [cell setData:dict withRow:0];
    }
    else if (indexPath.row%3==1)
    {
        [cell setData:dict withRow:1];
    }else if (indexPath.row%3==2)
    {
        [cell setData:dict withRow:2];
    }

    cell.selectionStyle=UITableViewCellSelectionStyleNone;
 
    return cell;
}

-(void)longPressCell:(AddressCell *)cell
{
    SIAlertView *alert = [[SIAlertView alloc] initWithTitle:@"温馨提示"
                                                 andMessage:[NSString stringWithFormat:@"确定删除该地址？"]];
    [alert setTransitionStyle:SIAlertViewTransitionStyleSlideFromTop];
    [alert addButtonWithTitle:@"取消" type:SIAlertViewButtonTypeCancel handler:^(SIAlertView *alertView) {
    }];
    [alert addButtonWithTitle:@"确定" type:SIAlertViewButtonTypeDefault handler:^(SIAlertView *SIAlertView){
        
        //删除数据
        NSIndexPath *deleteIndex = [self.tableView indexPathForCell:cell];
        
        NSDictionary *deleDict = [_dataArr objectAtIndex:deleteIndex.row];
        
        [_dataArr removeObjectAtIndex:deleteIndex.row];
        
        [_tableView beginUpdates];
        
        [_tableView deleteRowsAtIndexPaths:@[deleteIndex] withRowAnimation:UITableViewRowAnimationFade];
        
        [_tableView endUpdates];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 耗时的操作
            
        [[[NLProtocolRequest alloc] initWithRegister:YES] deleteSKQShaddressWithAddressId:[NSString stringWithFormat:@"%@",deleDict[@"shaddressid"]]];
        });

    }];
    
    [alert show];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PAYSKQMore *pay= [[PAYSKQMore alloc]initWithNibName:@"PAYSKQMore" bundle:nil];
    
    //将选中内容以字典形式传过去
    NSDictionary *dict = _dataArr[indexPath.row];
    pay.dict = dict;
    pay.arraydic= self.arrayDic;
    NSLog(@"---%@",self.arrayDic);
    [self.navigationController pushViewController:pay animated:YES];
}

- (void)AddressAction{

    AddressPAY *add= [[AddressPAY alloc]initWithNibName:@"AddressPAY" bundle:nil];
    [self.navigationController pushViewController:add animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//接口
-(void)readDefaultAddress
{
    NSString* name = [NLUtils getNameForRequest:Notify_readShaddressinfo];
    REGISTER_NOTIFY_OBSERVER(self, readDefaultAddressNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] readSKQShaddressInfo];
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];

}

//刷卡器的读取选项
-(void)readDefaultAddressNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        
        [self doReadDefaultAddressNotify:response];
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
            detail = @"服务器繁忙，请稍候再试";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

//获取到的刷卡器信息选项
-(void)doReadDefaultAddressNotify:(NLProtocolResponse*)response
{
     if ([TFData getTempData][ADD_SKQ_ADDRESS_FLAG]) {
         // 刷钱前移除所有数据
         [_dataArr removeAllObjects];
         
         [[TFData getTempData]removeObjectForKey:ADD_SKQ_ADDRESS_FLAG];
     }
    
    NLProtocolData* data = [response.data find:@"msgbody/result" index:0];
    
    NSString *result = data.value;
    
    NSRange range = [result rangeOfString:@"succ"];
    
    if (range.length <= 0)
    {
        NLProtocolData* data = [response.data find:@"msgbody/message" index:0];
        
        NSString* value = data.value;
        [self showErrorInfo:value status:NLHUDState_Error];
    }
    else
    {
        //收货地址id
        NSArray* shaddressid = [response.data find:@"msgbody/msgchild/shaddressid"];
        //收货地址
        NSArray* shaddress = [response.data find:@"msgbody/msgchild/shaddress"];
        //收货人
        NSArray* shman = [response.data find:@"msgbody/msgchild/shman"];
        //收货电话
        NSArray* shphone = [response.data find:@"msgbody/msgchild/shphone"];
        //运费
        NSArray* shyunfei = [response.data find:@"msgbody/msgchild/shyunfei"];
        //运费类型
        NSArray* shyunfeitype = [response.data find:@"msgbody/msgchild/shyunfeitype"];
        
        NSString *shaddressidStr = nil;
        NSString *shaddressStr = nil;
        NSString *shmanStr  = nil;
        NSString *shphoneStr = nil;
        NSString *shyunfeiStr = nil;
        NSString *shyunfeitypeStr = nil;
        
        for (int i =0 ; i<shaddressid.count; i++) {
            
            NLProtocolData* data = [shaddressid objectAtIndex:i];
            shaddressidStr = [self checkInfo:data.value];
            data = [shaddress objectAtIndex:i];
            shaddressStr = [self checkInfo:data.value];
            data = [shman objectAtIndex:i];
            shmanStr = [self checkInfo:data.value];
            data = [shphone objectAtIndex:i];
            shphoneStr = [self checkInfo:data.value];
            data = [shyunfei objectAtIndex:i];
            shyunfeiStr = [self checkInfo:data.value];
            data = [shyunfeitype objectAtIndex:i];
            shyunfeitypeStr = [self checkInfo:data.value];
            
            NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:shaddressidStr, @"shaddressid", shaddressStr, @"shaddress", shmanStr, @"shman", shphoneStr, @"shphone", shyunfeiStr, @"shyunfei", shyunfeitypeStr, @"shyunfeitype", nil];
            
            [_dataArr addObject:dic];
            
        }
    }
    
    
    //解析完刷新
    [_tableView reloadData];
    
}

//判断信息是否正确
-(void)showErrorInfo:(NSString*)detail status:(NLHUDState)status
{
    [self oneFingerTwoTaps];
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

-(NSString *)checkInfo:(NSString *)str
{
    if (str == nil)
    {
        return @"未知";
    }
    else
    {
        return str;
    }
}


#pragma mark - keyboard hide event
-(void)oneFingerTwoTaps
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    UITextField *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    
    [firstResponder resignFirstResponder];
}

- (void) doPush
{
    [_hud hide:YES];
    [NLUtils popToLogonVCByHTTPError:self feedOrLeft:1];
}

@end
