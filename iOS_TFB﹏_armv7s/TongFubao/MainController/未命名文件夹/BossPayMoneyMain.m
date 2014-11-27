//
//  BossPayMoneyMain.m
//  TongFubao
//
//  Created by  俊   on 14-9-19.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "BossPayMoneyMain.h"
#import "payMoneyPeopleMore.h"
#import "BossAddPeople.h"

@interface BossPayMoneyMain ()
{
    /*年月*/
    int      year;
    int      month;
    BOOL     flagPay;
    NSString   *strTimer;
    NSCalendar *calendar;
    UIButton   *TimeButton[3];
    NSDateComponents    *dateComponent;
    
    NLProgressHUD  * _hud;
    UILabel        *agentAreaLabel;
    NSMutableArray *_dataArr;
    NSString       *canEditStr;
}

@property (weak, nonatomic) IBOutlet UIButton *backStaffBtn;
@property (weak, nonatomic) IBOutlet UITableView *MytableView;
@property (weak, nonatomic) IBOutlet UIButton *BtnOnClick;
@property (weak, nonatomic) IBOutlet UIButton *staffBtn;
@property (weak, nonatomic) IBOutlet UILabel *lableheardlist;
@property (weak, nonatomic) IBOutlet UIButton *staffIsOn;

@property (nonatomic, retain) NSMutableArray * myCellArray;
@property (nonatomic, strong) NSDate         *monthShowing;
@property (nonatomic, strong) NSCalendar     *calendar;
@property (nonatomic, retain) NSString       *departDate;
/*bossid*/
@property (nonatomic, retain) NSString       *bossAuthoridStr;
@property (nonatomic,strong) NSDictionary    *dic;

@end

@implementation BossPayMoneyMain
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/*年月*/
-(void)initwithmoney
{
    _monthShowing = [NSDate date];
    /*只算月份 获取当前月份*/
    self.calendar = [NSCalendar currentCalendar];
    self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [self.calendar setLocale:[NSLocale currentLocale]];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    dateComponent = [self.calendar components:unitFlags fromDate:_monthShowing];
    year  = [dateComponent year];
    month = [dateComponent month];
    
    /*日期 默认当前月 当前时间 时差问题*/
    NSString* monthStr;
    if (month<10) {
        monthStr= [NSString stringWithFormat:@"0%d",month];
    }else{
        monthStr= [NSString stringWithFormat:@"%d",month];
    }
    self.departDate= [NSString stringWithFormat:@"%d-%@",year,monthStr];
    
    /*年月选择*/
    for (int i = 0; i < 3; i++)
    {
        NSString * btnName = (i == 0? @"上个月" : i == 1? self.departDate : @"下个月");
        TimeButton[i] = [UIButton buttonWithType:UIButtonTypeCustom];
        TimeButton[i].opaque = YES;
        TimeButton[i].tag = 101 + i;
        TimeButton[i].frame = CGRectMake(15 + 100 * i, 205, 90, 35);
        if (i==0) {
            TimeButton[i].frame = CGRectMake(8, 73, 86, 40);
        }else if (i==1){
            TimeButton[i].frame = CGRectMake(95, 73, 130, 40);
        }else if (i==2){
            TimeButton[i].frame = CGRectMake(226, 73, 86, 40);
        }
        [TimeButton[i] setBackgroundColor:SACOLOR(200, 1.0)];
        [TimeButton[i] setTitle:btnName forState:UIControlStateNormal];
        [TimeButton[i] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [TimeButton[i] setTitleColor:RGBACOLOR(27, 195, 238, 1) forState:UIControlStateHighlighted];
        [TimeButton[i] addTarget:self action:@selector(timeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:TimeButton[i]];
        
        UIImageView *imageNext= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nextPay"]];
        [imageNext setFrame:(CGRect){72,15,6,9}];
        [TimeButton[2] addSubview:imageNext];
        UIImageView *imagebefore= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"beforePay"]];
        [imagebefore setFrame:(CGRect){8,15,6,9}];
        [TimeButton[0] addSubview:imagebefore];
    }
    
}

/*年月*/
-(void)timeBtnAction:(UIButton *)sender
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
    dateFormatter.dateFormat = @"yyyy-MM";
    strTimer= [dateFormatter stringFromDate:self.monthShowing];
    TimeButton[1].titleLabel.text= strTimer;
    [TimeButton[1] setTitle:TimeButton[1].titleLabel.text forState:UIControlStateNormal];

    [self viewInRead];
}

- (NSDate *)firstDayOfMonthContainingDate:(NSDate *)date {
    NSDateComponents *comps = [self.calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    [comps setDay:1];
    return [self.calendar dateFromComponents:comps];
}

/*137获取可编辑的接口*/
-(void)viewInRead
{
    if (_bossAuthoridStr==nil) {
        _bossAuthoridStr= [NLUtils getbossauthorid];
    }else{
        
        [self showErrorInfo:@"请稍候" status:NLHUDState_None];
        /*实际就是137的接口*/
        NSDictionary *dataDictionaryClick = @{ @"month" :  TimeButton[1].titleLabel.text , @"bossauthorid" : [NLUtils getbossauthorid] };
        
        [LoadDataWithASI loadDataWithMsgbody:dataDictionaryClick apiName:@"ApiWageInfo" apiNameFunc:@"GetSalaryList" rolePath:@"//operation_response/msgbody" type:PublicCommon completionBlock:^(NSDictionary *data, NSError *error) {
            NSLog(@"137 请求成功%@",data);
            [_hud hide:YES];
            if ([data[@"result"] isEqualToString:@"success"])
            {
                 [NLUtils setWagelistid:data[@"wagelistid"]];
            }
        }];
  
        /*1.3	读取员工工资记录*/
        NSDictionary *dataDictionary = @{ @"month" : TimeButton[1].titleLabel.text , @"bossauthorid" : [NLUtils getbossauthorid]};
        /*支付工资*/
        [LoadDataWithASI loadDataWithMsgbody:dataDictionary apiName:@"ApiWageInfo" apiNameFunc:@"GetSalaryList" rolePath:@"//operation_response/msgbody/msgchild" type:PublicList completionBlock:^(id data, NSError *error)
         {
             [_hud hide:YES];
             
             if ([TFData getTempData][BOOS_PAY_MONEY_PEOPLE]) {
                 // 刷钱前移除所有数据
                 [_dataArr removeAllObjects];
                 
                 [[TFData getTempData]removeObjectForKey:BOOS_PAY_MONEY_PEOPLE];
             }
             
             [_dataArr setArray:data];
             
             if (_dataArr.count==0)
             {
                 _MytableView.hidden= YES;
                 agentAreaLabel.opaque = YES;
                 agentAreaLabel.hidden= NO;
                 agentAreaLabel.frame= CGRectMake(20, 200, 270, 20);
                 agentAreaLabel.backgroundColor = [UIColor clearColor];
                 agentAreaLabel.textColor = [UIColor blackColor];
                 agentAreaLabel.font = [UIFont systemFontOfSize:18.0];
                 agentAreaLabel.textAlignment= NSTextAlignmentCenter;
                 agentAreaLabel.text= @"本月没有代发工资的员工";
                 _lableheardlist.hidden= YES;
                 agentAreaLabel.numberOfLines = 0;
                 [self.view addSubview:agentAreaLabel];
                 
                 /*隐藏财务*/
                 _BtnOnClick.userInteractionEnabled= NO;
                 [_BtnOnClick setTitle:@"当月无发放列表" forState:UIControlStateNormal];
                 [_BtnOnClick setBackgroundImage:[NLUtils createImageWithColor:SACOLOR(200, 1.0)] forState:UIControlStateNormal];
             }else{
                /*获取支付几人且共多少金额*/
                 if (_staffBtn.hidden != YES) {
                     [self wagelistidInBoss];
                 }else{
                     double num= 0.00;
                     for (int i= 0; i<_dataArr.count; i++)
                     {
                    num  +=  [[[_dataArr valueForKey:@"money"] objectAtIndex:i] doubleValue];
                     }
                     _lableheardlist.text= [NSString stringWithFormat:@"本月发放共%d人次,共%.2lf元",_dataArr.count ,num];
                 }
    
                 _MytableView.hidden= NO;
                 _BtnOnClick.userInteractionEnabled= YES;
                 agentAreaLabel.hidden= YES;
                 [_BtnOnClick setBackgroundImage:[UIImage imageNamed:@"change_btn_normal.png"] forState:UIControlStateNormal];
                 [_BtnOnClick setTitle:@"确定支付" forState:UIControlStateNormal];
                 [self.MytableView reloadData];
             }
         }];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (8 == buttonIndex || 1 == buttonIndex)
    {
        [self viewDataOnclick];
    }
}

/*读取自己的bossid 134*/
-(void)boosidUrl
{

    [self showErrorInfo:@"请稍候" status:NLHUDState_None];

    NSDictionary *dataDictionaryClick = @{ @"shoucardno" :@"" };
    [LoadDataWithASI loadDataWithMsgbody:dataDictionaryClick apiName:@"ApiWageInfo" apiNameFunc:@"readBossAuthorid" rolePath:@"//operation_response/msgbody" type:PublicCommon completionBlock:^(NSDictionary * data, NSError *error) {
        NSLog(@"134 请求成功%@",data);
        [_hud hide:YES];
       /*老板没有指定财务的话即使用自己的authorid 
        指定财务即使用老板的bossauthorid进行获取表信息
        */
        if ([data[@"result"] isEqualToString:@"success"]) {
            _bossAuthoridStr= data[@"bossauthorid"];
            if (![[NLUtils getAuthorid] isEqualToString:_bossAuthoridStr]) {
                /*财务修订*/
                _staffBtn.hidden= YES;
                _BtnOnClick.hidden= YES;
                _staffIsOn.hidden= NO;
                _backStaffBtn.hidden= YES;
            }
        }else{
            /*当前老板为*/
            _staffIsOn.hidden= YES;
            _staffBtn.hidden= NO;
            _BtnOnClick.hidden= NO;
            _backStaffBtn.hidden= NO;
            _bossAuthoridStr= [NLUtils getAuthorid];
        }
        [NLUtils setbossauthorid:_bossAuthoridStr];
       
        [self viewInRead];

    }];
}

/*确定锁定工资*/
-(void)viewDataOnclick
{
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    /*锁定工资*/
    NSDictionary *dataDictionaryClick = @{ @"month" : TimeButton[1].titleLabel.text , @"bossauthorid" : [NLUtils getbossauthorid] };
    [LoadDataWithASI loadDataWithMsgbody:dataDictionaryClick apiName:@"ApiWageInfo" apiNameFunc:@"Submit" rolePath:@"//operation_response/msgbody" type:PublicCommon completionBlock:^(NSDictionary * data, NSError *error) {
        NSLog(@"锁定 请求成功%@",data);
        [_hud hide:YES];
        NSRange range = [data[@"result"] rangeOfString:@"succ"];
        if (range.length <= 0)
        {
            [self showErrorInfo:data[@"message"] status:NLHUDState_Error];
            [_hud hide:YES afterDelay:1.5];
        }else
        {
            [self viewInRead];
            [self viewDataisread];
        }
    }];
}

/*读取120接口获取waglistid*/
-(void)wagelistidInBoss
{
    if (_hud==nil) {
          [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    }
    NSString *wagelistidStr= [NLUtils getgWagelistid];
    if (wagelistidStr==nil) {
        wagelistidStr= @"null";
    }
    /*120 读取工资*/
    NSDictionary *dataDictionary = @{ @"querytype" : @"month", @"querywhere" : TimeButton[1].titleLabel.text ,  @"bossauthorid" : [NLUtils getbossauthorid], @"wagelistid" : wagelistidStr };
    
    [LoadDataWithASI loadDataWithMsgbody:dataDictionary apiName:@"ApiWageInfo" apiNameFunc:@"paymonthwage" rolePath:@"//operation_response/msgbody/msgchild" type:PublicList completionBlock:^(id data, NSError *error) {
        NSLog(@"12022 请求成功%@",data);
        if ([[data valueForKey:@"wageallmoney"] objectAtIndex:0]!=nil) {
            [_hud hide:YES];
            _lableheardlist.text= [NSString stringWithFormat:@"本月发放共%@人次,共%@元",[[data valueForKey:@"wagestanum"] objectAtIndex:0],[[data valueForKey:@"wageallmoney"] objectAtIndex:0]];
        }else{
        
        }
    }];
}

/*读取工资是否为0元*/
-(void)viewDataisread
{
    if (_hud==nil) {
        [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    }
    /*120 读取工资*/
    NSDictionary *dataDictionary = @{ @"querytype" : @"month", @"querywhere" : TimeButton[1].titleLabel.text ,  @"bossauthorid" : [NLUtils getbossauthorid], @"wagelistid" : [NLUtils getgWagelistid]};
    [LoadDataWithASI loadDataWithMsgbody:dataDictionary apiName:@"ApiWageInfo" apiNameFunc:@"paymonthwage" rolePath:@"//operation_response/msgbody/msgchild" type:PublicList completionBlock:^(id data, NSError *error) {
        NSLog(@"120msgchild 请求成功%@",data);
        if ([[data valueForKey:@"wagepaymoney"] objectAtIndex:0]!=nil ) {
            [_hud hide:YES afterDelay:2];
            /*共支付*/
            NSString *cellAllMoneyPay= [NSString stringWithFormat:@"%.2lf元",[[[data valueForKey:@"wageallmoney"]objectAtIndex:0] doubleValue]];
            /*已支付*/
            NSString *cellMoneyIsPay = [NSString stringWithFormat:@"%.2lf",[[[data valueForKey:@"wagepaymoney"]objectAtIndex:0] doubleValue]];
     
            NSString *pushMoney= [NSString stringWithFormat:@"%.2lf",[cellAllMoneyPay doubleValue]-[cellMoneyIsPay doubleValue]];
            /*支付是否为空*/
            if ([pushMoney doubleValue] > 0) {
                if ([[NLUtils getbossauthorid] isEqualToString:[NLUtils getAuthorid]]) {
                    [self viewInPush];
                }else{
                    [NLUtils showAlertView:@"提示"
                                   message:@"当前暂不支持财务人员支付"
                                  delegate:self
                                       tag:7
                                 cancelBtn:@"确定"
                                     other:nil];
                }
            }else if ([pushMoney doubleValue] <= 0){
                [self showErrorInfo:@"当前需要支付工资：0" status:NLHUDState_Error];
            }
        }
    }];
}

/*payWagecwedit*/
-(void)payWagecwedit
{
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    /*锁定工资 wagelistid*/
    NSDictionary *dataDictionaryClick = @{ @"querytype" :  @"month" , @"querywhere" : TimeButton[1].titleLabel.text , @"wagelistid" : [NLUtils getgWagelistid] , @"changecwcanEdit" : @"1" };
    [LoadDataWithASI loadDataWithMsgbody:dataDictionaryClick apiName:@"ApiWageInfo" apiNameFunc:@"payWagecwedit" rolePath:@"//operation_response/msgbody" type:PublicCommon completionBlock:^(NSDictionary * data, NSError *error) {
        NSLog(@"129 请求成功%@",data);
        [_hud hide:YES];
        NSRange range = [data[@"result"] rangeOfString:@"succ"];
        if (range.length <= 0)
        {
            [self showErrorInfo:data[@"message"] status:NLHUDState_Error];
            [_hud hide:YES afterDelay:1.5];
        }else
        {
            [NLUtils showAlertView:@"提示"
                           message:data[@"message"]
                          delegate:self
                               tag:6
                         cancelBtn:@"确定"
                             other:nil];
        }
    }];

}

/*136财务提交提交
 财务提交当月工资记录进行审批，提交后财务不允许新增或者修改任何工资记录，只有BOSS退回财务修改或者已经支付后,该月的工资记录才能解锁允许财务修改.
 */
-(void)cwWagetoSubmit
{
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    /*锁定工资 wagelistid*/
    NSDictionary *dataDictionaryClick = @{ @"wagelistid" :  [NLUtils getgWagelistid] , @"bossauthorid" : [NLUtils getbossauthorid] };
    [LoadDataWithASI loadDataWithMsgbody:dataDictionaryClick apiName:@"ApiWageInfo" apiNameFunc:@"cwWagetoSubmit" rolePath:@"//operation_response/msgbody" type:PublicCommon completionBlock:^(NSDictionary * data, NSError *error) {
        NSLog(@"136 请求成功%@",data);
        [_hud hide:YES];
        NSRange range = [data[@"result"] rangeOfString:@"succ"];
        if (range.length <= 0)
        {
            [self showErrorInfo:data[@"message"] status:NLHUDState_Error];
            [_hud hide:YES afterDelay:1.5];
        }else
        {
            [NLUtils showAlertView:@"提示"
                           message:data[@"message"]
                          delegate:self
                               tag:6
                         cancelBtn:@"确定"
                             other:nil];
            [self viewInRead];
        }
    }];
}

/*137财务提交提交
 财务提交当月工资记录进行审批，提交后财务不允许新增或者修改任何工资记录，只有BOSS退回财务修改或者已经支付后,该月的工资记录才能解锁允许财务修改.
 
-(void)GetSalaryList
{
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    NSDictionary *dataDictionaryClick = @{ @"month" :  TimeButton[1].titleLabel.text , @"bossauthorid" : [NLUtils getbossauthorid] };

    [LoadDataWithASI loadDataWithMsgbody:dataDictionaryClick apiName:@"ApiWageInfo" apiNameFunc:@"GetSalaryList" rolePath:@"//operation_response/msgbody" type:PublicCommon completionBlock:^(NSDictionary *data, NSError *error) {
        NSLog(@"137 请求成功%@",data);
         [_hud hide:YES];
         if ([data[@"result"] isEqualToString:@"success"])
         {
            
         }
    }];

    [LoadDataWithASI loadDataWithMsgbody:dataDictionaryClick apiName:@"ApiWageInfo" apiNameFunc:@"GetSalaryList" rolePath:@"//operation_response/msgbody/msgchild" type:PublicList completionBlock:^(id  data, NSError *error) {
        NSLog(@"137 请求成功%@",data);
        [_hud hide:YES];
        if ([[data valueForKey:@"phone"] objectAtIndex:0] ==nil)
        {
            [self showErrorInfo:[[data valueForKey:@"message"] objectAtIndex:0] status:NLHUDState_Error];
            [_hud hide:YES afterDelay:1.5];
        }
    }];
}
*/

/*
 */
-(void)viewInPush
{
    payMoneyPeopleMore *pay= [[payMoneyPeopleMore alloc]init];
    pay.TimerStr= TimeButton[1].titleLabel.text;
    [self.navigationController pushViewController:pay animated:YES];
    
}


/*新增地址之后返回刷新*/
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([TFData getTempData][BOOS_PAY_MONEY_PEOPLE]||[TFData getTempData][BOOS_DELETE_MONEY_PEOPLE]||[TFData getTempData][BOOS_CHANGE_MONEY_PEOPLE]) {
    
        [self performSelector:@selector(viewInRead) withObject:nil afterDelay:0.1];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    
    ViewControllerProperty;
    
#endif
    [self viewInMain];
    [self initwithmoney];
    [self boosidUrl];
}

-(void)leftItemClick:(id)sender
{
    [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];
}

-(void)viewInMain
{
    self.title= @"发放工资";
    agentAreaLabel= [[UILabel alloc]init];
    [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
    [self addRightButtonItemWithTitle:@"发放历史"];
    self.MytableView.separatorStyle= UITableViewCellSeparatorStyleNone;
    self.myCellArray = [NSMutableArray arrayWithCapacity:1];
     _dataArr= [NSMutableArray array];
    
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

//删除
//-(NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return @"delete";
//}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BossPayMoneyCell *cell =nil;
    static NSString *kCellID = @"BossPayMoneyCell";
    cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (cell == nil)
    {
        NSArray* temp = [[NSBundle mainBundle] loadNibNamed:kCellID owner:self options:nil];
        cell=[temp objectAtIndex:0];
    }
    /*请求数组对应的字段填充*/
    NSDictionary*dic = [_dataArr objectAtIndex:indexPath.row];
    if ([dic[@"name"]length]==0) {
        cell.LabaleName.text= [NSString stringWithFormat:@" %d  %@",indexPath.row+1,  @"匿名"];
    }else
    {
         cell.LabaleName.text= [NSString stringWithFormat:@" %d  %@",indexPath.row+1, dic[@"name"]];
    }
    //手机号
    NSString *phoneStr = dic[@"phone"];
    NSRange rang = NSMakeRange(3, 4);
    //将搜索中的字符串替换成为一个新的字符串
    NSString *cellphone = [phoneStr stringByReplacingCharactersInRange:rang withString:@"****"];
    cell.LaPhone.text= cellphone;
    cell.LableIsOn.text= dic[@"hasRegister"];
    if ([dic[@"bankAccount"]length] < 5) {
        cell.LaManId.text= @"未绑定银行卡";
    }else{
        NSString *bankStr = dic[@"bankAccount"];
        NSRange rang;
        if ([dic[@"bankAccount"] length] > 16) {
             rang = NSMakeRange(4, 11);
        }else{
             rang = NSMakeRange(4, 8);
        }
        NSString *cellBank = [bankStr stringByReplacingCharactersInRange:rang withString:@"****"];
        cell.LaManId.text= cellBank;
    }
    cell.LabaleName.lineBreakMode = UILineBreakModeCharacterWrap;
    cell.LableMoney.lineBreakMode = UILineBreakModeHeadTruncation;
    cell.LaManId.textAlignment= NSTextAlignmentCenter;
    cell.LableMoney.text= [NSString stringWithFormat:@"￥%@",dic[@"money"]];
    cell.BossPayMoneyCellDelegate= self;
   
    if ([dic[@"canEdit"]  isEqualToString:@"0"]) {
        
         [TFData getTempData][PAY_MONEY_BOOS_PUSH]=PAY_MONEY_BOOS_PUSH;
        
        cell.btnSelect.userInteractionEnabled= NO;
        [cell.btnSelect setBackgroundImage:[NLUtils createImageWithColor:SACOLOR(200, 1.0)] forState:UIControlStateNormal];
        
    }else if ([dic[@"canEdit"] isEqualToString:@"1"]){
        
        [[TFData getTempData]removeObjectForKey:PAY_MONEY_BOOS_PUSH];
        
        if ([dic[@"cwcanEdit"]isEqualToString:@"1"]) {
            
            cell.btnSelect.userInteractionEnabled= YES;
            [cell.btnSelect setBackgroundImage:[UIImage imageNamed:@"green_button_nor.png"] forState:UIControlStateNormal];
            
        }else if ([dic[@"cwcanEdit"]isEqualToString:@"0"]){
           
            cell.btnSelect.userInteractionEnabled= NO;
            [cell.btnSelect setBackgroundImage:[NLUtils createImageWithColor:SACOLOR(200, 1.0)] forState:UIControlStateNormal];
        }
    }
   
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;

    return cell;
}

//删除数据
-(void)delCell:(BossPayMoneyCell*)cell
{
    //删除数据
    NSIndexPath *deleteIndex = [self.MytableView indexPathForCell:cell];
    NSDictionary *deleDict = [_dataArr objectAtIndex:deleteIndex.row];
    BossAddPeople *pay= [[BossAddPeople alloc]init];
    pay.monthNow= TimeButton[1].titleLabel.text;
    pay.deldic= deleDict;
    pay.flagType= YES;
    [self.navigationController pushViewController:pay animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78;
}

- (IBAction)btnOnClick:(UIButton *)sender {
    
//    [self viewInPush];
    
    UIButton *senderButton = (UIButton *)sender;
    
    switch (senderButton.tag) {
        case 1:
        {
            BossAddPeople *pay= [[BossAddPeople alloc]init];
            pay.monthNow= TimeButton[1].titleLabel.text;
            [self.navigationController pushViewController:pay animated:YES];
        }
            break;
        case 2:
        {
           
            if ([TFData getTempData][PAY_MONEY_BOOS_PUSH]==nil)
            {
                /*pay money*/
                /*发放工资判断是否为0*/
                [NLUtils showAlertView:@"提示"
                               message:@"开始支付后本月工资信息将不能再更改，请确认工资清单是否已核对完毕？"
                              delegate:self
                                   tag:8
                             cancelBtn:@"取消"
                                 other:@"确定"];
            }else{
                if ([[NLUtils getbossauthorid] isEqualToString:[NLUtils getAuthorid]]) {
                      [self viewDataisread];
                }else{
                    [NLUtils showAlertView:@"提示"
                                   message:@"当前暂不支持财务人员支付"
                                  delegate:self
                                       tag:7
                                 cancelBtn:@"确定"
                                     other:nil];
                }
            }
        }
            break;
            
            case 3:
        {
            payoffView *pay= [[payoffView alloc]init];
            [self.navigationController pushViewController:pay animated:YES];
        }
            break;
        case 4:
        {
            /*退回财务修订*/
            [self payWagecwedit];
        }
            break;
        case 5:
        {
           /*保存修订的订单*/
           [self cwWagetoSubmit];

        }
            break;
        default:
            break;
    }
}

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

/*发放历史*/
-(void)rightItemClick:(id)sender
{
    payMoneyHistory *pay= [[payMoneyHistory alloc]init];
    [self.navigationController pushViewController:pay animated:YES];
}
/*
 <?xml version='1.0' encoding='utf-8' standalone='yes' ?><operation_response>
 
 <msgheader version = "1.0"><au_token>n3JFAcWXqq3JlA7g9rF00mYH</au_token><req_token></req_token><req_bkenv>00</req_bkenv><retinfo><rettype>0</rettype><retcode>0</retcode><retmsg>读取员工工资记录成功1</retmsg></retinfo></msgheader>
 
 <msgbody>
 <msgchild><canEdit>1</canEdit>
 <id>1</id>
 <phone></phone>
 <name></name>
 <money>0.00</money>
 <hasRegister>未注册</hasRegister>
 <bankAccount></bankAccount>
 </msgchild><result>success</result>
 <message>读取员工工资记录成功1</message>
 </msgbody>
 
 </operation_response>
 */

@end
