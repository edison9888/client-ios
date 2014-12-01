//
//  payMoneyHistory.m
//  TongFubao
//
//  Created by  俊   on 14-9-3.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "payMoneyHistory.h"

@interface payMoneyHistory ()<NLTressTableListDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSInteger currentHeight;
    NLTressTableListType currentType;
    NLTressTableList *table;
    NLProgressHUD    * _hud;
    NSDictionary     *dic;
    NSArray          *headViews;
    NSMutableArray   *dataCell;
    NSMutableArray   *arraySet;
    
}
@property (nonatomic,strong) NSMutableArray    *PersonArr;
@end

@implementation payMoneyHistory
@synthesize LBPhone,LBMoney,LBName;

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
    [self viewInMain];
   
}

-(void)viewInMain
{
    self.title= @"发放历史";
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    
    ViewControllerProperty;
    
#endif
    
    //获取当前屏幕size
    currentHeight = iphoneSize;
    _MainArray    = [NSMutableArray arrayWithCapacity:20];
    _pictypenames = [NSMutableArray array];
    _PersonArr    = [NSMutableArray array];
     dataCell     = [NSMutableArray array];
    
    /*请求历史*/
    [self viewInData];
}

/*发放工资*/
-(void)viewInData
{
    NSString *func;
    NSString *apiname;
    if (_flagSingOn==YES) {
        func= @"readauthorwagelists";
        apiname= @"ApiWageInfo";
    }else{
        func= @"readwagelists";
        apiname= @"ApiWageInfo";
    }
    
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    NSString* name = [NLUtils getNameForRequest:Notify_Apireadwagelists];
    REGISTER_NOTIFY_OBSERVER(self, readOrderProinfoinfoNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApireadwagelists:@"all" querywhere:@"all" bossauthorid:[NLUtils getbossauthorid] func:func Apiame:apiname];
    
}

-(void)readOrderProinfoinfoNotify:(NSNotification*)notify
{
    
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [self doReadOrderProinfoinfoNotify:response];
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

-(void)doReadOrderProinfoinfoNotify:(NLProtocolResponse*)response
{
    
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
        NSArray* ilist = [response.data find:@"msgbody/msgchild/ilist"];
        NSArray* msgchild = [response.data find:@"msgbody/msgchild"];

        //发放人数
        NSArray* wagestanum = [response.data find:@"msgbody/msgchild/wagestanum"];
        //发放金额
        NSArray* wageallmoney = [response.data find:@"msgbody/msgchild/wageallmoney"];
        //支付月份
        NSArray* wagemonth = [response.data find:@"msgbody/msgchild/wagemonth"];
        
        NSArray* wagepaymoney;
        if (_flagSingOn==YES)
        {
            //工资id
            wagepaymoney = [response.data find:@"msgbody/msgchild/wageid"];
        }else
        {
            //已支付金额
            wagepaymoney = [response.data find:@"msgbody/msgchild/wagepaymoney"];
        }

        NSString *wagestanumStr = nil;
        NSString *wagemonthStr = nil;
        NSString *wagepaymoneyStr = nil;
        NSString *wageallmoneyStr = nil;
        NSString *ilistStr= nil;

        for (int i=0; i<msgchild.count; i++) {
            
            NLProtocolData* data = [wagestanum objectAtIndex:i];
            wagestanumStr = [self checkInfo:data.value];
            
            data = [wagemonth objectAtIndex:i];
            wagemonthStr = [self checkInfo:data.value];
      
            data = [wageallmoney objectAtIndex:i];
            wageallmoneyStr = [self checkInfo:data.value];
            
            data= [wagepaymoney objectAtIndex:i];
            wagepaymoneyStr= [self checkInfo:data.value];
            
            data= [ilist objectAtIndex:i];
            ilistStr= [self checkInfo:data.value];

            [_MainArray addObject: [NSDictionary dictionaryWithObjectsAndKeys:wagestanumStr,@"wagestanum",wagemonthStr,@"wagemonth",wagepaymoneyStr,@"wagepaymoney",wageallmoneyStr,@"wageallmoney",ilistStr,@"ilist", nil]];
        }
        
        if (_flagSingOn==YES) {
       
            //剔除重复数据
            [_PersonArr setArray:[_MainArray valueForKeyPath:@"@distinctUnionOfObjects.wagemonth"]];
            // 按顺序添加排序描述器 NO⬇️
            NSSortDescriptor *firstnameDesc = [NSSortDescriptor sortDescriptorWithKey:@"" ascending:NO];
            NSArray *descs = [NSArray arrayWithObjects: firstnameDesc, nil];
            NSArray *array2 = [_PersonArr sortedArrayUsingDescriptors:descs];
            
            [self showErrorInfo:@"请稍候" status:NLHUDState_None];
            NSDictionary *dataDictionary = @{ @"querytype" : @"all", @"querywhere" : @"all" , @"bossauthorid" : [NLUtils getbossauthorid] };
  
            [LoadDataWithASI loadDataWithMsgbody:dataDictionary apiName:@"ApiWageInfo" apiNameFunc:@"readauthorwagelists" rolePath:@"//operation_response/msgbody/msgchild" type:PublicList completionBlock:^(id data, NSError *error)
             {
                [_hud hide:YES];
                [dataCell setArray:data];
                 table = [[NLTressTableList alloc]
                          initWithFrame:CGRectMake(0, 0, SelfWidth, currentHeight - 64) style:UITableViewStylePlain headInfos:array2 customTableType:NLTressTableListPayMoney flag:YES];
                 table.flagQian= YES;
                 table.bgImageView.hidden= YES;
                 table.NLTressTableListDelegate = self;
                 [self.view addSubview:table];
             }];
        }else
        {
            NSDictionary *dataDictionary = @{ @"querytype" : @"", @"querywhere" : @"" , @"bossauthorid" : [NLUtils getbossauthorid] };
            [LoadDataWithASI loadDataWithMsgbody:dataDictionary apiName:@"ApiWageInfo" apiNameFunc:@"readwagelists" rolePath:@"//operation_response/msgbody/msgchild/ilist/msgchild" type:PublicList completionBlock:^(id data, NSError *error)
            {
                [_hud hide:YES];
                [dataCell setArray:data];
                table = [[NLTressTableList alloc] initWithFrame:CGRectMake(0, 0, SelfWidth, currentHeight - 64) style:UITableViewStylePlain headInfos:_MainArray customTableType:NLTressTableListPayMoney flag:NO];
                table.bgImageView.hidden= YES;
                table.NLTressTableListDelegate = self;
                [self.view addSubview:table];
            }];
        }
    }
}

-(void)AddRightAction:(UIButton*)sender
{
    
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

#pragma mark - CustomTableDelegate
- (void)loadCitiesWithFirstLetter:(NSString *)firstLetter
{
    
    [_pictypenames removeAllObjects];
    
//    NSString *currt= _flagSingOn ? @"wagemonth" : @"wagemonth";
    NSString *currt= @"wagemonth";
    
    for (int i = 0; i < dataCell.count; i++)
    {
        if ([[dataCell[i] valueForKey:currt] isEqualToString:firstLetter])
        {
            [_pictypenames addObject:dataCell[i]];
        }
    }
    [table returnCities:_pictypenames];
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


#pragma mark - keyboard hide event
-(void)oneFingerTwoTaps
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UITextField *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    [firstResponder resignFirstResponder];
}


#pragma mark - 键盘回收
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 arraySet= [NSMutableArray array];
 
 for (int i=0; i<dataCell.count; i++) {
 
 NSString *Mpictypename= [[dataCell valueForKey:@"pictypename"] objectAtIndex:i];
 NSString *Mstaname= [[dataCell valueForKey:@"staname"] objectAtIndex:i];
 NSString *Mwagemoney= [[dataCell valueForKey:@"wagemoney"] objectAtIndex:i];
 NSString *Mmobile= [[dataCell valueForKey:@"mobile"] objectAtIndex:i];
 NSString *Mbkcardbank= [[dataCell valueForKey:@"bkcardbank"] objectAtIndex:i];
 NSString *Mbkcardno= [[dataCell valueForKey:@"bkcardno"] objectAtIndex:i];
 for (int i=0; i<_MainArray.count; i++) {
 
 NSString *str= [[_MainArray valueForKey:@"wagemonth"]objectAtIndex:i];
 
 if ([str isEqualToString:Mpictypename]) {
 NSMutableDictionary *dicMI = [_MainArray[i] mutableCopy];
 [_MainArray removeObjectAtIndex:i];
 //重构数据
 [dicMI setValue:Mpictypename forKey:@"Mpictypename"];
 [dicMI setValue:Mstaname forKey:@"Mstaname"];
 [dicMI setValue:Mwagemoney forKey:@"Mwagemoney"];
 [dicMI setValue:Mmobile forKey:@"Mmobile"];
 [dicMI setValue:Mbkcardbank forKey:@"Mbkcardbank"];
 [dicMI setValue:Mbkcardno forKey:@"Mbkcardno"];
 
 [_MainArray insertObject:dicMI atIndex:i];
 [arraySet addObject:_MainArray[i]];
 }
 }
 }
 */
/*
 NSDate *date = [NSDate date];
 NSCalendar *calendar = [NSCalendar currentCalendar];
 NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
 NSDateComponents    *dateComponent = [calendar components:unitFlags fromDate:date];
 
 int year  = [dateComponent year];
 */


@end
