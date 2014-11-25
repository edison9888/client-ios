//
//  ExpressageMain.m
//  TongFubao
//
//  Created by  俊   on 14-9-16.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "ExpressageMain.h"
#import "NLMoreOrderQueryViewController.h"
#import "NLStartOrderQueryViewController.h"

@interface ExpressageMain ()
{
    NSString       *apptxtBtn[12];
    NSString       *apptxt;
    NSString       *appcomBtn[12];
    NSString       *appmnuid;
    NLProgressHUD  * _hud;
    NSMutableArray *arraySet;
}
@end

@implementation ExpressageMain

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
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    
    ViewControllerProperty;
    
#endif
    [self mainView];
}

/*快递页面*/
-(void)mainView
{
    self.title= @"快递查询";
    [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
    [self addRightButtonItemWithTitle:@"查看更多"];
    self.myArray = [NSMutableArray arrayWithCapacity:1];
    /*content*/
    UIView *content = [[self.view subviews] objectAtIndex:0];
	((UIScrollView *)self.view).contentSize = content.bounds.size;
    /*get url information*/
    [self readKuaiDicmpList];
}

-(void)readKuaiDicmpList
{
    NSString* name = [NLUtils getNameForRequest:Notify_readKuaiDicmpList];
    REGISTER_NOTIFY_OBSERVER(self, readKuaiDicmpListNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] readKuaiDicmpList];
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
}

/*more espressage*/
-(void)rightItemClick:(id)sender
{
    NLMoreOrderQueryViewController* vc = [[NLMoreOrderQueryViewController alloc] initWithNibName:@"NLMoreOrderQueryViewController" bundle:nil];
    vc.myArray = [NSArray arrayWithArray:self.myArray];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)readKuaiDicmpListNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        [self doReadMenuModuleNotify:response];
    }
    else if (error == RSP_TIMEOUT)
    {
        [self showErrorInfo:@"请求超时,需要重新登录" status:NLHUDState_Error];
        [self performSelector:@selector(doPush) withObject:nil afterDelay:2.0f];
        return;
    }
    else
    {
        NSString* detail = response.detail;
        if (!detail || detail.length <= 0)
        {
            detail = @"服务器繁忙，请稍候再试";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}


-(void)doReadMenuModuleNotify:(NLProtocolResponse*)response
{
    NSArray* comid = [response.data find:@"msgbody/msgchild/comid"];
    NSString* comidStr = nil;
    NSArray* com = [response.data find:@"msgbody/msgchild/com"];
    NSString* comStr = nil;
    NSArray* comname = [response.data find:@"msgbody/msgchild/comname"];
    NSString* comnameStr = nil;
    NSArray* apitype = [response.data find:@"msgbody/msgchild/apitype"];
    NSString* apitypeStr = nil;
    NSArray* comlogo = [response.data find:@"msgbody/msgchild/comlogo"];
    NSString* comlogoStr = nil;
    for (int i=0; i<[comname count]; i++)
    {
        NLProtocolData* data = [comid objectAtIndex:i];
        comidStr = data.value;
        data = [com objectAtIndex:i];
        comStr = data.value;
        data = [comname objectAtIndex:i];
        comnameStr = data.value;
        data = [apitype objectAtIndex:i];
        apitypeStr = data.value;
        data = [comlogo objectAtIndex:i];
        comlogoStr = data.value;
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:comidStr,@"comid",comStr,@"com",comnameStr,@"comname",apitypeStr,@"apitype",comlogoStr,@"comlogo", nil];
        [self.myArray addObject:dic];
    }
    if ([self.myArray count] > 0)
    {
        [self ImageViewToList];
        [self ImageInView];
    }
}

-(void)ImageViewToList
{
    /*文档快递数据 我擦 写那么多*/
    arraySet= [NSMutableArray arrayWithCapacity:17];
    NSMutableArray *btMoreArr = [NSMutableArray arrayWithCapacity:8];
    [btMoreArr addObject:@{@"icon":@"shentong" , @"txt":@"400-889-5543"}];
    [btMoreArr addObject:@{@"icon":@"shunfeng" , @"txt":@"4008-111-111"}];
    [btMoreArr addObject:@{@"icon":@"EMSguonei",@"txt":@"11183"}];
    [btMoreArr addObject:@{@"icon":@"EMS" , @"txt":@"11183"}];
    [btMoreArr addObject:@{@"icon":@"yuantong" , @"txt":@"021-69777888"}];
    [btMoreArr addObject:@{@"icon":@"zhongtong" , @"txt":@"400-827-0270"}];
    [btMoreArr addObject:@{@"icon":@"yunda" , @"txt":@"400-821-6789"}];
    [btMoreArr addObject:@{@"icon":@"tiantian" , @"txt":@"400-188-8888"}];
    [btMoreArr addObject:@{@"icon":@"huitong", @"txt":@"400-956-5656"}];
    [btMoreArr addObject:@{@"icon":@"lianbangkuaidi", @"txt":@"400-889-1888"}];
    [btMoreArr addObject:@{@"icon":@"UPSkuaidi", @"txt":@"400-820-8388"}];
    [btMoreArr addObject:@{@"icon":@"quanfengkuaidi", @"txt":@"400-100-0001"}];
    [btMoreArr addObject:@{@"icon":@"quanyikuaidi", @"txt":@"400-663-1111"}];
    [btMoreArr addObject:@{@"icon":@"suerkuaidi", @"txt":@"400-158-9888"}];
    [btMoreArr addObject:@{@"icon":@"debangwuliu", @"txt":@"400-830-5555"}];
    [btMoreArr addObject:@{@"icon":@"TNTkuaidi", @"txt":@"800-820-9888"}];
    [btMoreArr addObject:@{@"icon":@"zhaijisong",@"txt":@"400-6789-000"}];
    [btMoreArr addObject:@{@"icon":@"anxinda",@"txt":@"400-626-2356"}];
    [btMoreArr addObject:@{@"icon":@"datianwuliu",@"txt":@"400-626-1166"}];
    [btMoreArr addObject:@{@"icon":@"guotongkuaidi",@"txt":@"400-111-1123"}];
    [btMoreArr addObject:@{@"icon":@"gongsuda",@"txt":@"400-111-0005"}];
    [btMoreArr addObject:@{@"icon":@"huayuwuliu",@"txt":@"400-808-6666"}];
    [btMoreArr addObject:@{@"icon":@"huiqiangkuaidi",@"txt":@"400-000-0177"}];
    [btMoreArr addObject:@{@"icon":@"jiejiwuliu",@"txt":@"400-820-5566"}];
    [btMoreArr addObject:@{@"icon":@"jianadayouzheng",@"txt":@"416-979-8822"}];
    [btMoreArr addObject:@{@"icon":@"kuaijiesudi",@"txt":@"400-830-4888"}];
    [btMoreArr addObject:@{@"icon":@"longbangsudi",@"txt":@"021-39283333"}];
    [btMoreArr addObject:@{@"icon":@"huiqiangkuaidi",@"txt":@"400-000-0177"}];
    [btMoreArr addObject:@{@"icon":@"jiejiwuliu",@"txt":@"400-820-5566"}];
    [btMoreArr addObject:@{@"icon":@"jianadayouzheng",@"txt":@"416-979-8822"}];
    [btMoreArr addObject:@{@"icon":@"kuaijiesudi",@"txt":@"400-830-4888"}];
    [btMoreArr addObject:@{@"icon":@"lianhao",@"txt":@"0769-88620000"}];
    [btMoreArr addObject:@{@"icon":@"ruidianyouzheng",@"txt":@"0046-8-23-22-20"}];
    [btMoreArr addObject:@{@"icon":@"quanritong",@"txt":@"400-830-4888"}];
    [btMoreArr addObject:@{@"icon":@"xinbangwuliu",@"txt":@"4008-000-222"}];
    [btMoreArr addObject:@{@"icon":@"xindanwuliu",@"txt":@"400-820-4400"}];
    [btMoreArr addObject:@{@"icon":@"xianggangyouzheng",@"txt":@"00852-2921-2222"}];
     [btMoreArr addObject:@{@"icon":@"yousukuaidi",@"txt":@"400-111-1119"}];
    
    for (int i=0; i<btMoreArr.count; i++) {
        
        NSString *str2= [[btMoreArr valueForKey:@"icon" ]objectAtIndex:i];
        NSString *txtstr= [[btMoreArr valueForKey:@"txt" ]objectAtIndex:i];
      
        for (int i=0; i<self.myArray.count; i++) {
            
            NSString *str= [[self.myArray valueForKey:@"com"]objectAtIndex:i];
           
            if ([str2 isEqualToString:str])
            {
                /*数组替换新增*/
                NSMutableDictionary *dic = [self.myArray[i] mutableCopy];
                [self.myArray removeObjectAtIndex:i];
                [dic setValue:txtstr forKey:@"phonetxt"];
                [self.myArray insertObject:dic atIndex:i];
                [arraySet addObject:self.myArray[i]];
          
            }
        }
    }
}

/*have image in view*/
-(void)ImageInView
{
   
        int count = [arraySet count];
    
        for (int i=0; i<12&i<count; i++)
        {
            UIView *bgview= [[UIView alloc]initWithFrame:CGRectMake(110*(i%3), 1+96*(i/3), 105, 93)];
            UIButton *treatyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            treatyBtn.opaque = YES;
            treatyBtn.tag= 100+i;
            treatyBtn.frame = CGRectMake(20, 20, 60, 62);
            [treatyBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 0, -75, 0)];
            [treatyBtn setTitle:[[arraySet objectAtIndex:i] valueForKey:@"comname"] forState:UIControlStateNormal];
            [treatyBtn setBackgroundImage:[UIImage imageNamed:[[arraySet objectAtIndex:i] valueForKey:@"com"]] forState:UIControlStateNormal];
            [treatyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            treatyBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:15.0];
            appcomBtn[i] = [arraySet valueForKey:@"com"][i];
            apptxtBtn[i] = [arraySet valueForKey:@"phonetxt"][i];
            [treatyBtn addTarget:self action:@selector(onNLButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [bgview addSubview:treatyBtn];
            [self.view addSubview:bgview];
    }
}

-(void)onNLButtonClicked:(UIButton*)button
{
    //NLLogNoLocation(@"tag = %d",button.tag);

    NLStartOrderQueryViewController* vc = [[NLStartOrderQueryViewController alloc] initWithNibName:@"NLStartOrderQueryViewController" bundle:nil];
    appmnuid= appcomBtn[button.tag-100];
    apptxt= apptxtBtn[button.tag-100];
    vc.myCompanyName = button.titleLabel.text;
    vc.iconNameStr= appmnuid;
    if (apptxt!=nil) {
        vc.LablePhoneStr= [NSString stringWithFormat:@"客服服务热线：%@",apptxt];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showErrorInfo:(NSString*)error status:(NLHUDState)status
{
    [_hud hide:YES];
    _hud = [[NLProgressHUD alloc] initWithParentView: self.view];
    
    switch (status)
    {
        case NLHUDState_Error:
        {
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unCheckmark.png"]] ;
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.detailsLabelText = error;
            [_hud show:YES];
            [_hud hide:YES afterDelay:2];
        }
            break;
            
        case NLHUDState_NoError:
        {
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.png"]] ;
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.labelText = error;
            [_hud show:YES];
            [_hud hide:YES afterDelay:2];
        }
            break;
            
        case NLHUDState_None:
        {
            _hud.labelText = error;
            [_hud show:YES];
        }
            break;
            
        default:
            break;
    }
    
    return;
}


@end
