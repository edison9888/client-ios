//
//  TFAgentSearchCtr.m
//  TongFubao
//
//  Created by 〝Cow﹏. on 14-5-13.
//  Copyright (c) 2014年 〝Cow﹏. All rights reserved.
//

#import "TFAgentSearchCtr.h"
#import "NLUtils.h"
#import "NLProtocolRegister.h"
#import "SJTDatePickerView.h"

@interface TFAgentSearchCtr ()

@property (nonatomic,strong) TFSegment *seg;
@property (nonatomic,strong) UIScrollView *scroll;

@property (nonatomic,strong) TFAgentSearchByType *searchByDay;
@property (nonatomic,strong) TFAgentSearchByType *searchByMonth;
@property (nonatomic,strong) TFAgentSearchByType *searchByYear;

@property (nonatomic,strong) SJTDatePickerView   *datePicker;
@property (nonatomic,strong) UIActionSheet *pickerActionSheet;

@end

@implementation TFAgentSearchCtr

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

    [self UIInit];
}


-(void)UIInit
{
    self.view.backgroundColor = SACOLOR(245,1.0);
    CGFloat ctrH = [NLUtils getCtrHeight];
    CGFloat IOS7HEIGHT = IOS7_OR_LATER == YES? 64 : 0;
    
    UIView *tempView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:tempView];
    
    NSArray *item = @[@"按日",@"按月", @"按年"];
    
    _seg = [[TFSegment alloc] initWithFrame:CGRectMake(15, IOS7HEIGHT + 8, 290, 39) items:item];
    _seg.delegate = self;
    [self.view addSubview:_seg];
    
    CGFloat scrollH = IOS7_OR_LATER == YES? (ctrH - 60 - 64) : (ctrH - 60);
    
    _scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 60 + IOS7HEIGHT, 320 * 3, scrollH)];
    _scroll.scrollEnabled = NO;
    
    _searchByDay = [[TFAgentSearchByType alloc]initWithType:SearchTypeDay];
    _searchByDay.delegate = self;
    _searchByDay.isCurrent = YES;
    _searchByDay.view.frame = CGRectMake(0, 0, 320, scrollH);
    [_searchByDay clickType];
    
    _searchByMonth = [[TFAgentSearchByType alloc]initWithType:SearchTypeMonth];
    _searchByMonth.delegate = self;
    _searchByMonth.isCurrent = NO;
    _searchByMonth.view.frame = CGRectMake(320, 0, 320, scrollH);
    
    _searchByYear = [[TFAgentSearchByType alloc]initWithType:SearchTypeYear];
    _searchByYear.delegate = self;
    _searchByYear.isCurrent = NO;
    _searchByYear.view.frame = CGRectMake(640, 0, 320, scrollH);
    
    [_scroll addSubview:_searchByDay.view];
    [_scroll addSubview:_searchByMonth.view];
    [_scroll addSubview:_searchByYear.view];
    
    [self.view addSubview:_scroll];
    
   
}


#pragma mark - select time
-(void)clickSearchBt:(TFAgentSearchType)type
{
    _pickerActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                    delegate:nil
                                           cancelButtonTitle:nil
                                      destructiveButtonTitle:nil
                                           otherButtonTitles:nil];
    [_pickerActionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
    _datePicker = [[SJTDatePickerView alloc] initWithFrame:pickerFrame];
    
    if (type == SearchTypeDay)
    {
        _datePicker.datePickerViewMode = SJTDatePickerViewModeDay;
    }
    else if (type == SearchTypeMonth)
    {
        _datePicker.datePickerViewMode = SJTDatePickerViewModeMonth;
    }
    else
    {
        _datePicker.datePickerViewMode = SJTDatePickerViewModeYear;
    }
    
    [_pickerActionSheet addSubview:_datePicker];
    
    UIToolbar *pickerDateToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    pickerDateToolbar.backgroundColor = SACOLOR(221, 1.0);
    [pickerDateToolbar sizeToFit];
    
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(pickerViewCancel)];
    cancelBtn.tintColor = RGBACOLOR(19, 159, 217, 1.0);
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerViewDone)];
    doneBtn.tintColor = RGBACOLOR(19, 159, 217, 1.0);
    [pickerDateToolbar setItems:@[ cancelBtn, flexSpace, doneBtn ] animated:NO];
    
    [_pickerActionSheet addSubview:pickerDateToolbar];
    [_pickerActionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
    [_pickerActionSheet setBounds:CGRectMake(0, 0, 320, 485)];
}

- (void)pickerViewDone
{
    [_pickerActionSheet dismissWithClickedButtonIndex:0 animated:YES];
    _pickerActionSheet = nil;
    
    CGFloat pageWidth = _scroll.frame.size.width / 3;
    int page = floor(_scroll.contentOffset.x / pageWidth) + 1;

    NSDate *date = [_datePicker getDateInUnit:_datePicker.changedUnit];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
   
    if (page == 1)
    {
        dateFormatter.calendar = [NSCalendar currentCalendar];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        
        if (date != nil)
        {
            NSString *searchDay = [dateFormatter stringFromDate:date];
            dateFormatter.dateFormat = @"yyyy年MM月dd日";
            _searchByDay.recordTime = [dateFormatter stringFromDate:date];
            [_searchByDay searchByTime:searchDay];
        }
    }
    else if (page == 2)
    {
        dateFormatter.calendar = [NSCalendar currentCalendar];
        dateFormatter.dateFormat = @"yyyy-MM";
        
        if (date != nil)
        {
            NSString *searchMonth = [dateFormatter stringFromDate:date];
            dateFormatter.dateFormat = @"yyyy年MM月";
            _searchByMonth.recordTime = [dateFormatter stringFromDate:date];
            [_searchByMonth searchByTime:searchMonth];
        }
    }
    else
    {
        dateFormatter.calendar = [NSCalendar currentCalendar];
        dateFormatter.dateFormat = @"yyyy";
        
        if (date != nil)
        {
            NSString *searchYear = [dateFormatter stringFromDate:date];
            dateFormatter.dateFormat = @"yyyy年";
            _searchByYear.recordTime = [dateFormatter stringFromDate:date];
            [_searchByYear searchByTime:searchYear];
        }
    }
}

- (void)pickerViewCancel
{
    [_pickerActionSheet dismissWithClickedButtonIndex:0 animated:YES];
    _pickerActionSheet = nil;
}

#pragma mark - delegate method
-(void)segmentValueChanged:(UIButton *)btn
{
    NSInteger tag = btn.tag;
    [_scroll setContentOffset:CGPointMake(self.view.frame.size.width * tag, 0) animated:NO];
    
    //滚动再读取当前月，年数据
    if (tag == 0)
    {
        _searchByDay.isCurrent = YES;
        _searchByMonth.isCurrent = NO;
        _searchByYear.isCurrent = NO;
    }
    
    if (tag == 1)
    {
        [_searchByMonth clickType];
        _searchByDay.isCurrent = NO;
        _searchByMonth.isCurrent = YES;
        _searchByYear.isCurrent = NO;
    }

    if (tag == 2)
    {
        [_searchByYear clickType];
        _searchByDay.isCurrent = NO;
        _searchByMonth.isCurrent = NO;
        _searchByYear.isCurrent = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
