//
//  payMoneyTopeople.m
//  TongFubao
//
//  Created by  俊   on 14-9-3.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "payMoneyTopeople.h"

@interface payMoneyTopeople ()
{
    int      countTime;
    int      year;
    int      month;

    NSString   *strTimer;
    NSCalendar *calendar;
    NSData     *bodyData;
    NSString   * newDateOne;
    UIButton   *TimeButton[3];
    NSString   *currentSection;
    NLProgressHUD       * _hud;
    NSMutableURLRequest *request;
    NSDateComponents    *dateComponent;
    NSMutableDictionary *nameDictionary;
    UITableView *table;
    UILabel *agentAreaLabel;
}

@property (nonatomic, strong) NSDate      *monthShowing;
@property (nonatomic, strong) NSCalendar  *calendar;
@end

@implementation payMoneyTopeople
@synthesize URLpaymonthwage,URLreadwagelists;
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
    
    [self initwithmoney];
 
    /*再次刷新*/
    [self viewDataRead];
}

/*年月*/
-(void)initwithmoney
{
    
    /*日期 默认当前月 当前时间 时差问题*/
    
    self.departDate= [NSString stringWithFormat:@"%d-%d",year,month];
    
    /*年月选择*/
    for (int i = 0; i < 3; i++)
    {
        NSString * btnName = (i == 0? @"上一月" : i == 1? self.departDate : @"下一月");
        
        TimeButton[i] = [UIButton buttonWithType:UIButtonTypeCustom];
        TimeButton[i].opaque = YES;
        TimeButton[i].tag = 101 + i;
        TimeButton[i].frame = CGRectMake(15 + 100 * i, 205, 90, 35);
        if (i==0) {
            TimeButton[i].frame = CGRectMake(0, _LableText.frame.origin.y+28, 90, 40);
        }else if (i==1){
            TimeButton[i].frame = CGRectMake(91, _LableText.frame.origin.y+28, 138, 40);
        }else if (i==2){
            TimeButton[i].frame = CGRectMake(230, _LableText.frame.origin.y+28, 90, 40);
        }
        [TimeButton[i] setBackgroundColor:SACOLOR(200, 1.0)];
        [TimeButton[i] setTitle:btnName forState:UIControlStateNormal];
        [TimeButton[i] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [TimeButton[i] setTitleColor:RGBACOLOR(27, 195, 238, 1) forState:UIControlStateHighlighted];
        [TimeButton[i] addTarget:self action:@selector(timeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:TimeButton[i]];
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
    
    /*再次刷新*/
    [self viewDataRead];
}

- (NSDate *)firstDayOfMonthContainingDate:(NSDate *)date {
    NSDateComponents *comps = [self.calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    [comps setDay:1];
    return [self.calendar dateFromComponents:comps];
}

-(void)viewDataRead
{
    if (strTimer==nil)
    {
        NSString* monthStr;
        if (month<10) {
        monthStr= [NSString stringWithFormat:@"0%d",month];
        }else{
        monthStr= [NSString stringWithFormat:@"%d",month];
        }
        strTimer= [NSString stringWithFormat:@"%d-%@",year,monthStr];
    }
  
    NSDictionary *dataDictionary = @{ @"querytype" : @"month", @"querywhere" : strTimer  };
    /*支付工资*/
    [LoadDataWithASI loadDataWithMsgbody:dataDictionary apiName:@"ApiWageInfo" apiNameFunc:@"readwagelists" rolePath:@"//operation_response/msgbody/msgchild/ilist/msgchild" type:PublicList completionBlock:^(id data, NSError *error) {

        [_dataArr setArray:data];
        [table reloadData];

        if (_dataArr.count==0)
        {
            table.hidden= YES;
            agentAreaLabel.opaque = YES;
            agentAreaLabel.hidden= NO;
            agentAreaLabel.backgroundColor = [UIColor clearColor];
            agentAreaLabel.textColor = [UIColor blackColor];
            agentAreaLabel.font = [UIFont systemFontOfSize:18.0];
            agentAreaLabel.textAlignment= NSTextAlignmentCenter;
            agentAreaLabel.text= @"本月没有代发工资的员工";
            agentAreaLabel.numberOfLines = 0;
            [self.view addSubview:agentAreaLabel];

            _NotPayBtn.userInteractionEnabled= NO;
            [_NotPayBtn setBackgroundImage:[NLUtils createImageWithColor:SACOLOR(200, 1.0)] forState:UIControlStateNormal];
        }else
        {
            table.hidden= NO;
            agentAreaLabel.hidden= YES;
            _NotPayBtn.userInteractionEnabled= YES;
            [_NotPayBtn setBackgroundImage:[NLUtils createImageWithColor:RGBACOLOR(222, 127, 38, 1)] forState:UIControlStateNormal];
            
        }
        
    }];
}

- (void)returnName:(NSArray *)name
{
    //保存当前数据
    if (![nameDictionary objectForKey:currentSection])
    {
        [nameDictionary setObject:name forKey:currentSection];
    }
    
}

-(void)viewInMain
{
    self.title= @"发放工资";
    [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
    _dataArr = [NSMutableArray array];
    _monthShowing = [NSDate date];
    
    /*只算月份 获取当前月份*/
    self.calendar = [NSCalendar currentCalendar];
    self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [self.calendar setLocale:[NSLocale currentLocale]];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    dateComponent = [self.calendar components:unitFlags fromDate:_monthShowing];
    countTime= 0;
    year  = [dateComponent year];
    month = [dateComponent month];
    
    agentAreaLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 250, 300, 80)];
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, _LableText.frame.origin.y+100, 320, 280) style:UITableViewStylePlain];
    table.rowHeight= 50;
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];

}

- (IBAction)OnbtnCLick:(UIButton*)sender {
  
    UIButton *btn= (UIButton*)sender;
    switch (btn.tag) {
        case 1:
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
            break;
        case 2:
        {
            [self dismissModalViewControllerAnimated:YES];
        }
            break;
        case 3:
        {
            /*body数据  获取字典类型跳转*/
            [self viewDataReadbody];
        
        }
            break;
        default:
            break;
    }
}

/*读取工资列表 msgchild*/
-(void)viewDataReadbody
{
    if (strTimer==nil)
    {
        NSString* monthStr;
        if (month<10) {
            monthStr= [NSString stringWithFormat:@"0%d",month];
        }else{
            monthStr= [NSString stringWithFormat:@"%d",month];
        }
        strTimer= [NSString stringWithFormat:@"%d-%@",year,monthStr];
    }
    NSDictionary *dataDictionary = @{ @"querytype" : @"month", @"querywhere" : strTimer  };
    /*支付工资*/
    [LoadDataWithASI loadDataWithMsgbody:dataDictionary apiName:@"ApiWageInfo" apiNameFunc:@"readwagelists" rolePath:@"//operation_response/msgbody/msgchild" type:PublicCommon completionBlock:^(id data, NSError *error)
     {
         NSLog(@"operation_response %@",data);
         
         payMoneyPeopleMore *pay= [[payMoneyPeopleMore alloc]init];
         pay.pushArr= _dataArr;
//         pay.pushbodyArr= data;
//         pay.TimerStr= [NSString stringWithFormat:@"%@",strTimer];
         [self.navigationController pushViewController:pay animated:YES];
     }];
    
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict;
    dict= _dataArr[indexPath.row];
    
    UITableViewCell *cell=nil;
    static NSString *reuse=@"cell";
    
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }else{
        while ([cell.contentView.subviews lastObject] != nil) {
            
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    cell.textLabel.text= [NSString stringWithFormat:@"%@     %@         ￥%@",
                          dict[@"mobile"],dict[@"staname"],dict[@"wagemoney"]];
    cell.textLabel.font= [UIFont systemFontOfSize:16];
    cell.userInteractionEnabled= NO;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - keyboard hide event
-(void)oneFingerTwoTaps
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UITextField *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    [firstResponder resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
