//
//  WaterElec.m
//  TongFubao
//
//  Created by ec on 14-5-28.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "WaterElec.h"
#import "UIViewController+NavigationItem.h"
#import "MobileRechangeHistoryCtr.h"
#import "WaterElecSelCity.h"
#import "WaterEleBillCtr.h"

#define WATERFLAG 1
#define ELECFLAG  2
#define GASFLAG   3

@interface WaterElec ()

{
    CGFloat IOS7HEIGHT;
    CGFloat ctrH;
    CGFloat scrollH;
}

@property (nonatomic,strong) UIButton *cityBt;
@property (nonatomic,strong) UIButton *waterBt;
@property (nonatomic,strong) UIButton *elecBt;
@property (nonatomic,strong) UIButton *gasBt;
@property (nonatomic,strong) NSDictionary *dataDict;

//遮罩层
@property (nonatomic, strong) UIView  *viewShade;
//弹出视图
@property (strong,nonatomic) UIView *alterView;

@end

@implementation WaterElec

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
    [self UIInit];
    
    [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [NLUtils enableSliderViewController:NO];
   
}

-(void)viewWillDisappear:(BOOL)animated
{
   [super viewWillDisappear:animated];
    [NLUtils enableSliderViewController:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([TFData getTempData][SELECT_CITY_FLAG]) {
        
        _dataDict = [TFData getTempData][SELECT_CITY_FLAG];
        [[TFData getTempData] removeObjectForKey:SELECT_CITY_FLAG];
    }else{
        //本地缓存
        NSDictionary *localSelectCityData = [[NSUserDefaults standardUserDefaults]objectForKey:LOCAL_CITY_SELECT_DATA];
        if (localSelectCityData !=nil) {
            _dataDict = localSelectCityData;
        }
    }
    
    if (_dataDict !=nil) {
        [_cityBt setTitle:_dataDict[@"cityName"] forState:UIControlStateNormal];
        NSString *typeNameArr = _dataDict[@"cityDict"];
        if (NSNotFound != [typeNameArr rangeOfString:@"水"].location){
            _waterBt.userInteractionEnabled = YES;
            [_waterBt setBackgroundImage:[UIImage imageNamed:@"water_rent_uesful_normal"] forState:UIControlStateNormal];
            [_waterBt setBackgroundImage:[UIImage imageNamed:@"water_rent_uesful_selected"] forState:UIControlStateHighlighted];
        }else{
            _waterBt.userInteractionEnabled = NO;
            [_waterBt setBackgroundImage:[UIImage imageNamed:@"water_rent_uesless"] forState:UIControlStateNormal];
        }
        
        if (NSNotFound != [typeNameArr rangeOfString:@"电"].location){
            _elecBt.userInteractionEnabled = YES;
            [_elecBt setBackgroundImage:[UIImage imageNamed:@"electric_rate_uesful_normal"] forState:UIControlStateNormal];
            [_elecBt setBackgroundImage:[UIImage imageNamed:@"electric_rate_uesful_selected"] forState:UIControlStateHighlighted];
        }else{
            _elecBt.userInteractionEnabled = NO;
            [_elecBt setBackgroundImage:[UIImage imageNamed:@"electric_rate_uesless"] forState:UIControlStateNormal];
        }
        
        if (NSNotFound != [typeNameArr rangeOfString:@"气"].location){
            _gasBt.userInteractionEnabled = YES;
            [_gasBt setBackgroundImage:[UIImage imageNamed:@"gas_fees_uesful_normal"] forState:UIControlStateNormal];
            [_gasBt setBackgroundImage:[UIImage imageNamed:@"gas_fees_uesful_selected"] forState:UIControlStateHighlighted];
        }else{
            _gasBt.userInteractionEnabled = NO;
            [_gasBt setBackgroundImage:[UIImage imageNamed:@"gas_fees_useless"] forState:UIControlStateNormal];
        }
 
    }
}

-(void)UIInit
{
    UIView *temp = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:temp];
    self.title = @"水电煤缴费";
    self.view.backgroundColor = SACOLOR(245, 1.0);
  
    IOS7HEIGHT=IOS7_OR_LATER==YES?64:0;
    ctrH = [NLUtils getCtrHeight];
    scrollH =IOS7_OR_LATER==YES?(ctrH-100-64):(ctrH-100);
    
    [self addRightButtonItemWithImage:[UIImage imageNamed:@"history"]];
   
    
    //遮罩层
    _viewShade = [[UIView alloc] init];
    _viewShade.frame = CGRectMake(0, 0, self.view.frame.size.width, ctrH);
    _viewShade.backgroundColor = [UIColor blackColor];
    _viewShade.alpha = 0.5;
    _viewShade.hidden = YES;
    [self.view addSubview:_viewShade];

    
    _cityBt = [UIButton buttonWithType:UIButtonTypeCustom];
    _cityBt.frame = CGRectMake(15, 22+IOS7HEIGHT, 290, 44);
    _cityBt.backgroundColor = [UIColor whiteColor];
    [_cityBt setTitle:@"选择所在的城市" forState:UIControlStateNormal];
    [_cityBt setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _cityBt.layer.cornerRadius = 5.0;
    _cityBt.layer.borderWidth = 1.0;
    _cityBt.layer.borderColor = SACOLOR(196, 1.0).CGColor;
    [_cityBt addTarget:self action:@selector(clickSelCity) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cityBt];
    
    UIImageView *arrowImg = [[UIImageView alloc]initWithFrame:CGRectMake(265, 14, 15, 15)];
    [arrowImg setImage:[UIImage imageNamed:@"next_page"]];
    [_cityBt addSubview:arrowImg];
    
    
    _waterBt = [UIButton buttonWithType:UIButtonTypeCustom];
    _waterBt.userInteractionEnabled = NO;
    _waterBt.tag = WATERFLAG;
    _waterBt.frame = CGRectMake(16, 85+IOS7HEIGHT, 90, 90);
    [_waterBt setBackgroundImage:[UIImage imageNamed:@"water_rent_uesless"] forState:UIControlStateNormal];
    [_waterBt addTarget:self action:@selector(clickBt:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_waterBt];
    
    _elecBt = [UIButton buttonWithType:UIButtonTypeCustom];
    _elecBt.userInteractionEnabled = NO;
    _elecBt.tag = ELECFLAG;
    _elecBt.frame = CGRectMake(115, 85+IOS7HEIGHT, 90, 90);
    [_elecBt setBackgroundImage:[UIImage imageNamed:@"electric_rate_uesless"] forState:UIControlStateNormal];
    [_elecBt addTarget:self action:@selector(clickBt:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_elecBt];

    _gasBt = [UIButton buttonWithType:UIButtonTypeCustom];
    _gasBt.userInteractionEnabled = NO;
    _gasBt.tag = GASFLAG;
    _gasBt.frame = CGRectMake(214, 85+IOS7HEIGHT, 90, 90);
    [_gasBt setBackgroundImage:[UIImage imageNamed:@"gas_fees_useless"] forState:UIControlStateNormal];
    [_gasBt addTarget:self action:@selector(clickBt:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_gasBt];

    UIImageView *warmImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 203+IOS7HEIGHT, 30, 30)];
    [warmImg setImage:[UIImage imageNamed:@"warning_icon"]];
    [self.view addSubview:warmImg];
    
    UILabel *warmLabel = [[UILabel alloc]initWithFrame:CGRectMake(44, 203+IOS7HEIGHT, 200, 30)];
    warmLabel.userInteractionEnabled = YES;
    warmLabel.font = [UIFont systemFontOfSize:13];
    warmLabel.textColor = [UIColor grayColor];
    warmLabel.backgroundColor = [UIColor clearColor];
    warmLabel.text = @"点击查阅注意事项";
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickTap)];
    [warmLabel addGestureRecognizer:tapGesture];
    
    [self.view addSubview:warmLabel];
}

-(void)clickTap
{
    _viewShade.hidden = NO;
    [self.view bringSubviewToFront:_viewShade];
    
    
    if (_alterView==nil) {
        _alterView = [[UIView alloc]init];
        _alterView.backgroundColor = RGBACOLOR(232, 233, 232, 1.0);
        _alterView.layer.cornerRadius = 3.0;
        
        UILabel *alterTxt = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 70, 30)];
        alterTxt.text = @"注意事项";
        alterTxt.font = [UIFont systemFontOfSize:14];
        alterTxt.backgroundColor = [UIColor clearColor];
        [_alterView addSubview:alterTxt];
        
        UIButton *closeBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBt setTitle:@"关闭" forState:UIControlStateNormal];
        closeBt.titleLabel.font = [UIFont systemFontOfSize:14];
        [closeBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        closeBt.frame = CGRectMake(240, 0, 40, 30);
        [closeBt addTarget:self action:@selector(clickClose) forControlEvents:UIControlEventTouchUpInside];
        [_alterView addSubview:closeBt];
        
        UITextView *alterViewText = [[UITextView alloc]initWithFrame:CGRectMake(5, 30, 270, scrollH-35)];
        alterViewText.text = @"1、不支持预付费区域（后付费）：水电煤缴费金额必须等于欠费金额，低于或大于欠费金额则有可能显示不成功；而支持预付费区域（预付费），缴费金额必须等于或大于欠费金额\n2、核对扣款账号与扣款记录，若因客户输入缴费号错误，公司不承担客户损失\n3、请用户在帐单的有效期内进行缴付，如因超过账单有效期而未能缴付成功的，我公司不承担相关责任，建议客户到相关营业厅进行处理。\n4、公用事业单位的网上托管数据会迟于纸质账单发出，并且在发送途中也会出现数据包丢失，而导致要重新传输。因此当查询不到账单时，请不用着急，可隔几天重试，只要在最后缴费日前查询到即可。\n5、缴费时请输入正确的账单编号，并确认缴费信息与所要缴付的账单信息是否一致。如因用户输错账单编号造成的各类损失，我公司不予承担。";
        alterViewText.font = [UIFont systemFontOfSize:13];
        [_alterView addSubview:alterViewText];
       
    }
    _alterView.frame = CGRectMake(20, ctrH, 280, scrollH);
    [self.view addSubview:_alterView];
    [self.view bringSubviewToFront:_alterView];

    [UIView transitionWithView:self.view duration:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^void(){
        _alterView.frame = CGRectMake(20, IOS7HEIGHT+50, 280, scrollH);
    }completion:nil];
    
}

-(void)clickClose
{
    [self.view endEditing:YES];
    
    [UIView transitionWithView:self.view duration:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^void(){
        _alterView.frame = CGRectMake(20, ctrH, 280, scrollH);
    }completion:^void(BOOL finished){
        _viewShade.hidden = YES;
        [self.view sendSubviewToBack:_viewShade];
        [self.view bringSubviewToFront:_alterView];}
     ];
    
}

-(void)rightItemClick:(id)sender{
    MobileRechangeHistoryCtr *mobileRechangeHistoryCtr = [[MobileRechangeHistoryCtr alloc]initWithNibName:@"MobileRechangeHistoryCtr" bundle:nil];
    mobileRechangeHistoryCtr.myChargeHistoryType = WaterEleType;
    [self.navigationController pushViewController:mobileRechangeHistoryCtr animated:YES];
   
}

-(void)clickSelCity
{
    WaterElecSelCity *selCityCtr = [[WaterElecSelCity alloc]init];
    selCityCtr.title = @"城市选择";
    [self.navigationController pushViewController:selCityCtr animated:YES];
}

-(void)clickBt:(UIButton *)sender
{
    if (_dataDict == nil) {
        [NLUtils showTosatViewWithMessage:@"请选择所在城市" inView:self.view hideAfterDelay:1.0 beIndeter:NO];
        return;
    }
    NSString *payNameStr = [NSString stringWithFormat:@"%@",_dataDict[@"cityDict"]];
    
    NSMutableArray *patypeNameArr = [NSMutableArray arrayWithArray:[payNameStr componentsSeparatedByString:@"#@#"]] ;
    [patypeNameArr removeObjectAtIndex:0];
    
    if (sender.tag==WATERFLAG) {
        for (NSString *payName in patypeNameArr) {
            if (NSNotFound != [payName rangeOfString:@"水"].location){
                NSMutableArray *companyArr = [NSMutableArray arrayWithArray:[payName componentsSeparatedByString:@"@@"]];
                [companyArr removeObjectAtIndex:0];
                 WaterEleBillCtr *waterEleBillCtr = [[WaterEleBillCtr alloc]initWithInfor:companyArr];
                [self.navigationController pushViewController:waterEleBillCtr animated:YES];
                 waterEleBillCtr.title = @"水费缴费";
                return;
            }
        }
    }else if(sender.tag==ELECFLAG){
        for (NSString *payName in patypeNameArr) {
            if (NSNotFound != [payName rangeOfString:@"电"].location){
                NSMutableArray *companyArr = [NSMutableArray arrayWithArray:[payName componentsSeparatedByString:@"@@"]];
                [companyArr removeObjectAtIndex:0];
                WaterEleBillCtr *waterEleBillCtr = [[WaterEleBillCtr alloc]initWithInfor:companyArr];
                [self.navigationController pushViewController:waterEleBillCtr animated:YES];                waterEleBillCtr.title = @"电费缴费";
                return;
            }
        }

    }else if(sender.tag==GASFLAG){
        for (NSString *payName in patypeNameArr) {
            if (NSNotFound != [payName rangeOfString:@"气"].location){
                NSMutableArray *companyArr = [NSMutableArray arrayWithArray:[payName componentsSeparatedByString:@"@@"]];
                [companyArr removeObjectAtIndex:0];
                WaterEleBillCtr *waterEleBillCtr = [[WaterEleBillCtr alloc]initWithInfor:companyArr];
                [self.navigationController pushViewController:waterEleBillCtr animated:YES];
                waterEleBillCtr.title = @"燃气费缴费";
                return;
            }
        }
    }
    
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
