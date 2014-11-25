//
//  PaySKQ.m
//  TongFubao
//
//  Created by  俊   on 14-5-13.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "PaySKQ.h"
#import "SGFocusImageItem.h"
#import "SGFocusImageFrame.h"
#import "NLProgressHUD.h"
#import "NLUserInforSettingsCell.h"
#import "NLContants.h"
#import "NLLogOnViewController.h"
#import "HZAreaPickerView.h"
#import "PAYSKQMore.h"
#import "IsSurePAYAddress.h"
#import "AddressPAY.h"
#import "NLSlideBroadsideController.h"
#import "NLUtils.h"
#import "FeedController.h"
#import "MobileRechangeHistoryCtr.h"
#import "NLProtocolRequest.h"


@interface PaySKQ ()<SGFocusImageFrameDelegate>
{
    NLProgressHUD  * _hud;
    UIViewController *rightView;
    NSString *produrenameStr;//产品名字
    NSString *produrezhepriceStr;//优惠价格
    NSString *produrepriceStr;//产品价格
    NSString *produrememoStr;//产品描述
}

@property (weak, nonatomic) IBOutlet UIButton *OnBtnClick;
@property (retain, nonatomic) NLSlideBroadsideController* slider;
@property(nonatomic, strong)   NSMutableArray    *myArray;
@property (weak, nonatomic) IBOutlet UILabel *LaleHead;
@property (weak, nonatomic) IBOutlet UILabel *LableBody;
@property (weak, nonatomic) IBOutlet UIImageView *LableBlue;
@property (weak, nonatomic) IBOutlet UILabel *LableIsOkMoney;
@property (weak, nonatomic) IBOutlet UILabel *LableOnMoney;
@property (weak, nonatomic) IBOutlet UILabel *Lableline;
@property (weak, nonatomic) IBOutlet UIImageView *LableSide;

- (IBAction)OnClickToTheNext:(id)sender;

@end

@implementation PaySKQ
@synthesize slider;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title= @"购买刷卡器";
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    
    ViewControllerProperty;
    
#endif
    [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
    
    _myArray = [NSMutableArray array];
   
    [self SGFocusImageFrame_Action];
   
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"历史记录"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(historyRecord)];
    
    UITapGestureRecognizer *oneFingerTwoTaps = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(oneFingerTwoTaps)];
    // Set required taps and number of touches
    [oneFingerTwoTaps setNumberOfTapsRequired:2];
    
    [self.view addGestureRecognizer:oneFingerTwoTaps];
    
    //请求设备信息接口
    [self performSelector:@selector(readSKQInfo) withObject:nil afterDelay:0.1];
}

-(void)viewWillAppear:(BOOL)animated
{
    [NLUtils sliderSetleftController:nil];
}

//显示的右边
- (void)viewDidDisappear:(BOOL)animated
{
    [NLUtils sliderSetRightController:nil];
}

#pragma mark 历史记录
-(void)historyRecord
{
    MobileRechangeHistoryCtr *mobileRechangeHistoryCtr = [[MobileRechangeHistoryCtr alloc]initWithNibName:@"MobileRechangeHistoryCtr" bundle:nil];
    mobileRechangeHistoryCtr.myChargeHistoryType = buySKQType;
    [self.navigationController pushViewController:mobileRechangeHistoryCtr animated:YES];
}

//选择的按钮
- (void)btnIsOnRight
{
    NSMutableArray *array= [NSMutableArray array];
    
    [array addObject:@{@"img": @"transferRemittance.png",@"txt":@"首页"}];
    [array addObject:@{@"img": @"transferRemittance.png",@"txt":@"新增地址"}];
    [array addObject:@{@"img": @"transferRemittance.png",@"txt":@"默认地址"}];
    [array addObject:@{@"img": @"transferRemittance.png",@"txt":@"购物车"}];
    [array addObject:@{@"img": @"transferRemittance.png",@"txt":@"购买历史"}];
    [array addObject:@{@"img": @"transferRemittance.png",@"txt":@"刷卡器介绍"}];
    
    for (int i=0; i<=5; i++)
    {
        UIButton *btn= [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(20, 64  * i + 70, 150, 50)];
        btn.backgroundColor= [UIColor blueColor];
        [btn setTitle:[NSString stringWithFormat:@"%@",[array objectAtIndex:i][@"txt"]] forState:UIControlStateNormal];
        [btn setTag:i+1];
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[array objectAtIndex:i][@"img"]]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnMoreChoice:) forControlEvents:UIControlEventTouchUpInside];
        [rightView.view addSubview:btn];
    }
}

//不用的方法
- (void)btnMoreChoice:(UIButton *)sender
{
    [NLUtils enableSliderViewController:NO];
    
    UIButton *btn= (UIButton*)sender;
    
    switch (btn.tag)
    {
        case 1:
        {
            FeedController *feed= [[FeedController alloc]initWithNibName:@"FeedController" bundle:nil];
            [self.navigationController pushViewController:feed animated:YES];
        }
            break;
            
        case 2:
        {
            AddressPAY *add= [[AddressPAY alloc]initWithNibName:@"AddressPAY" bundle:nil];
            [self.navigationController pushViewController:add animated:YES];
        }
            break;
            
        case 3:
        {
            IsSurePAYAddress *add= [[IsSurePAYAddress alloc]init];
            [self.navigationController pushViewController:add animated:YES];
        }
            
        default:
            break;
    }
}

//广告的显示图标
-(void)SGFocusImageFrame_Action
{
    SGFocusImageItem *item1 = [[SGFocusImageItem alloc] initWithTitle:@"title1" image:[UIImage imageNamed:@"SLID_PIC1.png"] tag:201];
    SGFocusImageFrame *imageFrame;
    imageFrame= [[SGFocusImageFrame alloc] initWithFrame:CGRectMake(10, 10, 300, 240.0) delegate:self focusImageItems:item1, nil];
    [self.view addSubview:imageFrame];
}

- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame didSelectItem:(SGFocusImageItem *)item
{
    
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

- (IBAction)OnClickToTheNext:(id)sender
{
    IsSurePAYAddress *pay= [[IsSurePAYAddress alloc]init];
    pay.arrayDic= _myArray;
    [self.navigationController pushViewController:pay animated:YES];
}

//接口
-(void)readSKQInfo
{
    NSString* name = [NLUtils getNameForRequest:Notify_readOrderProinfo];
    REGISTER_NOTIFY_OBSERVER(self, readOrderProinfoinfoNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] readSKQOrderInfo];
//    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
}

//刷卡器的读取选项
-(void)readOrderProinfoinfoNotify:(NSNotification*)notify
{
    NLProtocolResponse *response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        
        [self doReadOrderProinfoinfoNotify:response];
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
        //产品id
        NSArray* produreid = [response.data find:@"msgbody/msgchild/produreid"];
        //产品名字
        NSArray* produrename = [response.data find:@"msgbody/msgchild/produrename"];
        //产品价格
        NSArray* produreprice = [response.data find:@"msgbody/msgchild/produreprice"];
        //优惠价格
        NSArray* produrezheprice = [response.data find:@"msgbody/msgchild/produrezheprice"];
        //产品描述
        NSArray* produrememo = [response.data find:@"msgbody/msgchild/produrememo"];
        //每次限购数量
        NSArray* produrelimitnum = [response.data find:@"msgbody/msgchild/produrelimitnum"];
        
        produrenameStr = nil;
        produrezhepriceStr = nil;
        produrepriceStr  = nil;
        produrememoStr = nil;
        NSString *produreidStr = nil;
        NSString *produrelimitnumStr = nil;
        
        for (int i = 0 ; i < produreid.count; i++)
        {
            NLProtocolData* data = [produreid objectAtIndex:i];
            produreidStr = [self checkInfo:data.value];
            data = [produrename objectAtIndex:i];
            produrenameStr = [self checkInfo:data.value];
            data = [produreprice objectAtIndex:i];
            produrepriceStr = [self checkInfo:data.value];
            data = [produrezheprice objectAtIndex:i];
            produrezhepriceStr = [self checkInfo:data.value];
            data = [produrememo objectAtIndex:i];
            produrememoStr = [self checkInfo:data.value];
            data = [produrelimitnum objectAtIndex:i];
            produrelimitnumStr = [self checkInfo:data.value];
            
            NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:produreidStr, @"produreid", produrenameStr, @"produrename", produrepriceStr, @"produreprice", produrezhepriceStr, @"produrezheprice", produrememoStr, @"produrememo", produrelimitnumStr, @"produrelimitnum", nil];
            [_myArray addObject:dic];
            NSLog(@"produrenameStr%@",produrenameStr);
            
            _LableBody.numberOfLines = 0;
            _LableBody.text= produrememoStr;
            
            NSArray *array = [produrepriceStr componentsSeparatedByString:@".00"];
            NSArray *arrayIsOn = [produrezhepriceStr componentsSeparatedByString:@".00"];
            
            _LableOnMoney.text= [NSString stringWithFormat:@"原价:￥%@.00",[array objectAtIndex:0]];
            _LableIsOkMoney.text= [NSString stringWithFormat:@"￥%@.00",[arrayIsOn objectAtIndex:0]];;
            
            NSLog(@"dddd%@",dic);
        }
    }
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

- (void) doPush
{
    [_hud hide:YES];
    [NLUtils popToLogonVCByHTTPError:self feedOrLeft:1];
}

@end






















