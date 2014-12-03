//
//  SignOnMain.m
//  TongFubao
//
//  Created by  俊   on 14-9-15.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "SignOnMain.h"
#import "NLMyBankCardEditViewController.h"

@interface SignOnMain ()
{
    int      year;
    int      month;
    UIButton            *TimeButton[3];
    NSString            *btnTitle;
    NSString            *strTimer;
    NLProgressHUD       * _hud;
    NSDateComponents    *dateComponent;
    NSMutableArray      *mainArr;
    NSMutableArray      *CellArr;
}
@property (retain,nonatomic) NSString     *departDate;
@property (nonatomic, strong) NSDate      *monthShowing;
@property (nonatomic, strong) NSCalendar  *calendar;
@property (copy, nonatomic) NSString *bossAuthoridStr;
@end

@implementation SignOnMain

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/*读取自己的bossid 134*/
-(void)boosidUrl
{
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    NSDictionary *dataDictionaryClick = @{ @"shoucardno" :@"" };
    [LoadDataWithASI loadDataWithMsgbody:dataDictionaryClick apiName:@"ApiWageInfo" apiNameFunc:@"readBossAuthorid" rolePath:@"//operation_response/msgbody" type:PublicCommon completionBlock:^(NSDictionary * data, NSError *error) {
        NSLog(@"134 请求成功%@",data);
        [_hud hide:YES];
        
        if ([data[@"result"] isEqualToString:@"success"]) {
            _bossAuthoridStr= data[@"bossauthorid"];
            [self viewIndataReadauthorwagelists];
        }
    }];
}


/*员工读取月份分类显示所有工资信息*/
-(void)viewIndataReadauthorwagelists
{
    [mainArr removeAllObjects];
    NSDictionary *dataDictionary = @{ @"querytype" : @"month", @"querywhere" : self.departDate ,@"bossauthorid" : [NLUtils getbossauthorid]};
    /*支付工资*/
    [LoadDataWithASI loadDataWithMsgbody:dataDictionary apiName:@"ApiWageInfo" apiNameFunc:@"readauthorwagelists" rolePath:@"//operation_response/msgbody/msgchild" type:PublicList completionBlock:^(id data, NSError *error)
    {
        [_hud hide:YES];
        [mainArr setArray:data];
        [_mytable reloadData];
        if (mainArr.count==0) {
            if (![data[@"result"] isEqualToString:@"success"])
            {
//                [self showErrorInfo:@"当前无数据" status:NLHUDState_Error];
                _lableText.text= @"亲！您本月还没收到工资哦！";
            }else{
                [self showErrorInfo:[data valueForKey:@"message"] status:NLHUDState_Error];
            }
            _lableHeard.hidden= YES;
            _ImageBG.hidden= YES;
            _mytable.hidden= YES;
            _lableText.hidden= NO;
        }else{
             _ImageBG.hidden= NO;
            _lableHeard.hidden= NO;
            _lableText.hidden= YES;
            _mytable.hidden= NO;
        }
    }];
}

/*员工工资签收 :(int)Number*/
-(void)viewIndataPayauthorwagecheck:(NSDictionary*)ArrMain
{
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    NSDictionary *dataDictionary = @{ @"querytype" : @"month", @"querywhere" : self.departDate ,@"wageid": ArrMain[@"wageid"] };
    /*支付工资*/
    [LoadDataWithASI loadDataWithMsgbody:dataDictionary apiName:@"ApiWageInfo" apiNameFunc:@"payauthorwagecheck" rolePath:@"//operation_response/msgbody" type:PublicCommon completionBlock:^(id data, NSError *error)
     {
         [_hud hide:YES];
         NSLog(@"reqxml %@",data);
         if (![data[@"result"]  isEqualToString:@"success"]) {
            
             NSRange range = [data[@"message"] rangeOfString:@"未补充"];
             //审批
             if (range.length > 0)/*>0 <=不正确*/
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提 示"
                                                                 message:data[@"message"]
                                                                delegate:self
                                                       cancelButtonTitle:@"返回"
                                                       otherButtonTitles:@"确定",nil];
                 [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
                     NSLog(@"选择的按钮%d",buttonIndex);
                     switch (buttonIndex) {
                         case 1:
                         {
                             NLMyBankCardEditViewController *bank=[[NLMyBankCardEditViewController alloc]init];
                             bank.singInFlag= YES;
                             [self.navigationController pushViewController:bank animated:YES];
                         }
                             break;
                             
                         default:
                             break;
                     }
                 }];
             }else
             {
                 [NLUtils showAlertView:@"提 示" message:data[@"message"] delegate:self tag:1 cancelBtn:nil other:@"确 定"];
             }
            
         }else{
             NSRange range = [data[@"message"] rangeOfString:@"绑定"];
           //审批
             if (range.length > 0)/*>0 <=不正确*/
             {
                 [NLUtils showAlertView:@"提 示" message:data[@"message"] delegate:self tag:8 cancelBtn:@"返回" other:@"马上绑定"];
             }else{
                  [NLUtils showAlertView:@"提 示" message:data[@"message"] delegate:self tag:12 cancelBtn:nil other:@"确 定"];
             }
             /*再次刷新读取工资接口数据*/
             [self viewIndataReadauthorwagelists];
             [_mytable reloadData];
         }
     }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1 == buttonIndex){
        
        if (alertView.tag==8) {
            /*绑定*/
            NLMyBankCardEditViewController *pay= [[NLMyBankCardEditViewController alloc]init];
            [self.navigationController pushViewController:pay animated:YES];
        }else{
            
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    
    ViewControllerProperty;
    
#endif
    // Do any additional setup after loading the view from its nib.
    [self initwithmoney];
    [self viewInbtn];
    [self viewIndataReadauthorwagelists];
}


/*年月*/
-(void)initwithmoney
{
    /*日期 默认当前月 当前时间 时差问题*/
    self.title= @"工资签收";
    _monthShowing = [NSDate date];
    mainArr= [NSMutableArray array];
    /*
    [mainArr addObject:@{@"wagemoney":@"账户管理",@"isqianshou":@"签收"}];
    [mainArr addObject:@{@"wagemoney":@"服务信息",@"isqianshou":@"签收"}];
    [mainArr addObject:@{@"wagemoney":@"代理商",@"isqianshou":@"签收"}];
    [mainArr addObject:@{@"wagemoney":@"帮助中心",@"isqianshou":@"签收"}];
    [mainArr addObject:@{@"wagemoney":@"意见反馈",@"isqianshou":@"签收"}];
    [mainArr addObject:@{@"wagemoney":@"关于我们",@"isqianshou":@"签收"}];
    */
    CellArr= [NSMutableArray array];
    
    [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
    [self addRightButtonItemWithTitle:@"历史记录"];
    _mytable.separatorStyle= UITableViewCellSeparatorStyleNone;
    _mytable.backgroundColor= [UIColor clearColor];
    
    /*只算月份 获取当前月份*/
    self.calendar = [NSCalendar currentCalendar];
    self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [self.calendar setLocale:[NSLocale currentLocale]];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    dateComponent = [self.calendar components:unitFlags fromDate:_monthShowing];
    
    year  = [dateComponent year];
    month = [dateComponent month];
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(void)viewInbtn
{
    NSString* monthStr;
    if (month<10) {
        monthStr= [NSString stringWithFormat:@"0%d",month];
    }else{
        monthStr= [NSString stringWithFormat:@"%d",month];
    }
    self.departDate= [NSString stringWithFormat:@"%d-%@",year,monthStr];
//    NSString *departDateTItle= [NSString stringWithFormat:@"%d年%d月工资",year,month];
    
    /*年月选择*/
    for (int i = 0; i < 3; i++)
    {
        NSString * btnName = (i == 0? @"上个月" : i == 1? self.departDate : @"下个月");
        TimeButton[i] = [UIButton buttonWithType:UIButtonTypeCustom];
        TimeButton[i].opaque = YES;
        TimeButton[i].tag = 101 + i;
        if (i==0) {
            TimeButton[i].frame = CGRectMake(0, 6, 80, 43);
        }else if (i==1){
            TimeButton[i].frame = CGRectMake(81, 6, 158, 43);
        }else if (i==2){
            TimeButton[i].frame = CGRectMake(240, 6, 80, 43);
        }
        [TimeButton[i] setBackgroundColor:SACOLOR(200, 1.0)];
        [TimeButton[i] setTitle:btnName forState:UIControlStateNormal];
        [TimeButton[i] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [TimeButton[i] setTitleColor:RGBACOLOR(27, 195, 238, 1) forState:UIControlStateHighlighted];
        [TimeButton[i] addTarget:self action:@selector(timeBtnAct:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:TimeButton[i]];
    }
}

/*年月*/
-(void)timeBtnAct:(UIButton *)sender
{
    UIButton *senderButton = (UIButton *)sender;
    
    if (senderButton.tag==101) {
        self.monthShowing = [[self firstDayOfMonthContainingDate:self.monthShowing] dateByAddingTimeInterval:-100000];
    }else{
        NSDateComponents* comps = [[NSDateComponents alloc]init];
        [comps setMonth:1];
        self.monthShowing = [self.calendar dateByAddingComponents:comps toDate:self.monthShowing options:0];
    }
    //当前的时间格式
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy年MM月";
    strTimer= [dateFormatter stringFromDate:self.monthShowing];

    dateFormatter.dateFormat= @"yyyy-MM";
    self.departDate= [dateFormatter stringFromDate:self.monthShowing];
    TimeButton[1].titleLabel.text= [NSString stringWithFormat:@"%@",self.departDate];
    [TimeButton[1] setTitle:TimeButton[1].titleLabel.text forState:UIControlStateNormal];
    
    /*签收*/
    [self viewIndataReadauthorwagelists];
}

- (NSDate *)firstDayOfMonthContainingDate:(NSDate *)date {
    NSDateComponents *comps = [self.calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    [comps setDay:1];
    return [self.calendar dateFromComponents:comps];
}

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
            break;
    }
    return;
}

-(void)oneFingerTwoTaps
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UITextField *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    [firstResponder resignFirstResponder];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[mainArr valueForKey:@"wagemoney"] count];
    return 6;
}

- (peopleHadMoneyCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _btnOnClick.hidden= YES;
    peopleHadMoneyCell *cell =nil;
    static NSString *kCellID = @"peopleHadMoneyCell";
    cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (cell == nil)
    {
        NSArray* temp = [[NSBundle mainBundle] loadNibNamed:kCellID owner:self options:nil];
        cell=[temp objectAtIndex:0];
    }
    cell.peopleHadMoneyCellDelegate= self;
    if (mainArr.count!=0){
        btnTitle= [[[mainArr valueForKey:@"isqianshou"] objectAtIndex:indexPath.row] isEqualToString:@"0"]? @"签收" : @"已签收";
        if (![[[mainArr valueForKey:@"isqianshou"]objectAtIndex:indexPath.row] isEqualToString:@"0"]) {
            cell.onbtnClick.userInteractionEnabled= NO;
            [cell.onbtnClick setBackgroundImage:[UIImage imageNamed:@"unable_btn"] forState:UIControlStateNormal];
        }else{
            cell.onbtnClick.userInteractionEnabled= YES;
            [cell.onbtnClick setBackgroundImage:[UIImage imageNamed:@"able_btn"] forState:UIControlStateNormal];
        }
        [cell.onbtnClick setTitle:btnTitle forState:UIControlStateNormal];
        cell.onMoney.text = [NSString stringWithFormat:@"￥%@", [[mainArr valueForKey:@"wagemoney"]objectAtIndex :indexPath.row]];
    }
    return cell;
}

/*签收工资 是否绑定落地账户
- (IBAction)btnOnClick:(id)sender {
    
    if ([mainArr valueForKey:@"wageid"]!=nil) {
        
        [self viewIndataPayauthorwagecheck];
    }
}
*/

//删除数据
-(void)delCell:(peopleHadMoneyCell*)cell
{
    NSIndexPath *deleteIndex = [self.mytable indexPathForCell:cell];
    NSDictionary *deleDict = [mainArr objectAtIndex:deleteIndex.row];
    if ([mainArr valueForKey:@"wageid"]!=nil) {
        /*对应index。row*/
        [self viewIndataPayauthorwagecheck:deleDict];
    }
}

/*发放历史*/
-(void)rightItemClick:(id)sender
{
    payMoneyHistory *pay= [[payMoneyHistory alloc]init];
    pay.flagSingOn= YES;
    [self.navigationController pushViewController:pay animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    /*
     id thisClass = [[NSClassFromString(@"NLMyBankCardEditViewController") alloc] initWithNibName:@"NLMyBankCardEditViewController" bundle:nil];
     [self.navigationController pushViewController:thisClass animated:YES];
     */
}

@end
