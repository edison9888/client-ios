//
//  planeMain.m
//  TongFubao
//
//  Created by  俊   on 14-6-30.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import "planeMain.h"
#import "CKCalendarView.h"
#import "planeChage.h"
#import "planePay.h"//信用卡支付 先看看效果

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface planeMain ()<CKCalendarDelegate>
{
     BOOL flag;
     BOOL flagGo;
     CKCalendarView *calendar;
     UIButton       *select;
     NSString       * _transferType;
}
@property(nonatomic, weak) CKCalendarView *calendar;
@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDateFormatter *dateFormatterback;
@property(nonatomic, strong) NSDate *minimumDate;
@property(nonatomic, strong) NSArray *disabledDates;
@property (weak, nonatomic) IBOutlet UIButton *TimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *singleBtn;
@property (weak, nonatomic) IBOutlet UIButton *roundBtn;
@property (weak, nonatomic) IBOutlet UIButton *onClick;
@property (nonatomic,strong) NSDictionary *information;
@property (weak, nonatomic) IBOutlet UIButton *gobtn;
@property (weak, nonatomic) IBOutlet UIButton *backbtn;
@property (weak, nonatomic) IBOutlet UIImageView *backtoIcon;
@property (weak, nonatomic) IBOutlet UIImageView *backIconheard;
@property (nonatomic,strong) UIImageView *deltaImgView; //倒三角图标

@property(nonatomic, assign) NSInteger numberweek;
@end

@implementation planeMain

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


//查询航线
-(void)onclicktoPlaneLine
{
    //信用卡支付
    planePay *plane= [[planePay alloc]initWithNibName:@"planePay" bundle:nil];
    [self.navigationController pushViewController:plane animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self nav];
    [self mainview];

}

-(void)mainview
{
    self.view.backgroundColor = RGBACOLOR(245, 245, 245, 1.0);
   
    /*默认单程*/
    [_onClick setFrame:CGRectMake(self.onClick.frame.origin.x, self.onClick.frame.origin.y-60, self.onClick.frame.size.width, self.onClick.frame.size.height)];
    
    //倒三角
    _deltaImgView = [[UIImageView alloc]initWithFrame:CGRectMake(_singleBtn.frame.origin.x/2+_singleBtn.frame.size.width/2, _singleBtn.frame.origin.y+_singleBtn.frame.size.height, 12, 6)];
    [_deltaImgView setImage:[UIImage imageNamed:@"triangle.png"]];
    [self.view addSubview:_deltaImgView];
    
    _transferType = @"0";
    [_roundBtn setTag:2];
    [_singleBtn setTag:1];
    _singleBtn.selected =YES;
    [_backBtn setHidden:YES];
    [_backIconheard setHidden:YES];
    [_backtoIcon setHidden:YES];

}

-(void)nav
{
    [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];

    self.title= @"机票查询";
    
}

- (IBAction)btn:(UIButton*)sender {
    
    NSInteger tag = sender.tag;
    
    switch (sender.tag) {
        case 1:
        {
            _transferType = @"0";
            
        }
            break;
        case 2:
        {
            _transferType = @"1";
        }
            break;
        case 3:
        {
            [self showCity];
        }
            break;
        case 4:
        {
            [self showbackCity];
        }
            break;
        case 5:
        {
            flag= YES;
            [self calender];
        }
            break;
        case 6:{
            flag= NO;
            [self calender];
        }
            break;
        case 7:
            [self onclicktoPlaneLine];
            break;
        default:
            break;
    }
    
    if ([_transferType isEqualToString:@"0"])
    {
        if (_backtoIcon.hidden!=YES)
        {
       
            [_onClick setFrame:CGRectMake(self.onClick.frame.origin.x, self.onClick.frame.origin.y-60, self.onClick.frame.size.width, self.onClick.frame.size.height)];
           
        }
        [_singleBtn setBackgroundImage:[UIImage imageNamed:@"left_selected_button.png"] forState:UIControlStateSelected];
        [_singleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_roundBtn setBackgroundImage:[UIImage imageNamed:@"right_normal_button.png"] forState:UIControlStateNormal];
        [_roundBtn setTitleColor:RGBACOLOR(3, 198, 230, 1) forState:UIControlStateNormal];
        
        [_backBtn setHidden:YES];
        [_backIconheard setHidden:YES];
        [_backtoIcon setHidden:YES];
    }else if ([_transferType isEqualToString:@"1"])
    {
        if (_backtoIcon.hidden!=NO)
        {
            [_onClick setFrame:CGRectMake(self.onClick.frame.origin.x, self.onClick.frame.origin.y+60, self.onClick.frame.size.width, self.onClick.frame.size.height)];
        }
        [_singleBtn setBackgroundImage:[UIImage imageNamed:@"left_normal_button.png"] forState:UIControlStateSelected];
        [_singleBtn setTitleColor:RGBACOLOR(3, 198, 230, 1) forState:UIControlStateSelected];
        [_roundBtn setBackgroundImage:[UIImage imageNamed:@"right_t_selected_button.png"] forState:UIControlStateNormal];
         [_roundBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_backBtn setHidden:NO];
        [_backIconheard setHidden:NO];
        [_backtoIcon setHidden:NO];
    }
    
    if (sender.tag==1||sender.tag==2) {
        
        [UIView transitionWithView:self.view duration:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^void{
            _deltaImgView.frame = CGRectMake(_singleBtn.frame.origin.x/2+_singleBtn.frame.size.width/2+(tag-1)*150, _singleBtn.frame.origin.y+_singleBtn.frame.size.height, 12, 6);
        }completion:nil];
    }
}

//传值选项
-(id)initWithInfor:(NSDictionary*)infor
{
    if (self = [super init])
    {
        if (infor)
        {
            _information = [NSDictionary dictionaryWithDictionary:infor];
        }else{
            _information = [NSDictionary dictionary];
        }
    }
    return self;
}

-(void)showCity
{
    planeChage *plane= [[planeChage alloc]init];
//    game.Planeflag=YES;
    [self.navigationController pushViewController:plane animated:YES];
}

-(void)showbackCity
{
    planeChage *plane= [[planeChage alloc]init];
//    game.Planebackflag=YES;
    [self.navigationController pushViewController:plane animated:YES];
}

-(void)showalert
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//calendar
- (void)calender {
   
    calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
    calendar.userInteractionEnabled= YES;
    self.calendar = calendar;
    calendar.delegate = self;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.minimumDate = [self.dateFormatter dateFromString:@"2014-06-01"];
    
    
    self.dateFormatterback = [[NSDateFormatter alloc] init];
    [self.dateFormatterback setDateFormat:@"yyyy-MM-dd"];
    self.minimumDate = [self.dateFormatterback dateFromString:@"2014-06-01"];
    
//    calendar.onlyShowCurrentMonth = NO;
//    calendar.adaptHeightToNumberOfWeeksInMonth = YES;
    calendar.alpha= 0.9;
    calendar.frame = CGRectMake(10, 80, 300, 320);
    [self.view addSubview:calendar];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localeDidChange) name:NSCurrentLocaleDidChangeNotification object:nil];
    
    //不允许选择的指定日期
    /*
     self.disabledDates = @[
     [self.dateFormatter dateFromString:@"2014/01/20"],
     [self.dateFormatter dateFromString:@"2015/01/13"],
     [self.dateFormatter dateFromString:@"2016/01/14"]
     ];*/
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    }
    else
    {
        return YES;
    }
}

- (void)localeDidChange
{
//    [self.calendar setLocale:[NSLocale currentLocale]];
}

- (BOOL)dateIsDisabled:(NSDate *)date
{
    for (NSDate *disabledDate in self.disabledDates)
    {
        if ([disabledDate isEqualToDate:date])
        {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark -
#pragma mark - CKCalendarDelegate
//不允许点击的
//- (void)calendar:(CKCalendarView *)calendar configureDateItem:(CKDateItem *)dateItem forDate:(NSDate *)date
//{
//    // TODO: play with the coloring if we want to...
//    
//      if ([self dateIsDisabled:date])
//      {
//        dateItem.backgroundColor = [UIColor redColor];
//        dateItem.textColor = [UIColor whiteColor];
//    }
//}

- (BOOL)calendar:(CKCalendarView *)calenda willSelectDate:(NSDate *)date {
    
    return ![self dateIsDisabled:date];
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    
    if (flag==YES) {
         self.TimeBtn.titleLabel.text = [self.dateFormatter stringFromDate:date];
    }else{
       
         self.backBtn.titleLabel.text= [self.dateFormatterback stringFromDate:date];
        
    }
}

//颜色
- (BOOL)calendar:(CKCalendarView *)calendar willChangeToMonth:(NSDate *)date {
    
    if ([date laterDate:self.minimumDate] == date) {
        self.calendar.backgroundColor = UIColorFromRGB(0x88B6DB);
      
    } else {
        self.calendar.backgroundColor = [UIColor redColor];
        return NO;
    }
}

- (void)calendar:(CKCalendarView *)calendar didLayoutInRect:(CGRect)frame {
    NSLog(@"calendar layout: %@", NSStringFromCGRect(frame));
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
