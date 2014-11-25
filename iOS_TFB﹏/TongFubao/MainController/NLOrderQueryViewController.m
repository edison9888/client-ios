//
//  NLOrderQueryViewController.m
//  TongFubao
//
//  Created by MD313 on 13-9-25.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLOrderQueryViewController.h"
#import "NLProtocolRequest.h"
#import "NLUtils.h"
#import "NLProgressHUD.h"
#import "NLMoreOrderQueryViewController.h"
#import "NLStartOrderQueryViewController.h"

#define NLOrderQueryView0 100
#define NLOrderQueryView1 101
#define NLOrderQueryView2 102
#define NLOrderQueryView3 103
#define NLOrderQueryView4 104
#define NLOrderQueryView5 105
#define NLOrderQueryView6 106
#define NLOrderQueryView7 107
#define NLOrderQueryView8 108
#define NLOrderQueryView9 109
#define NLOrderQueryView10 110
#define NLOrderQueryView11 111

@interface NLOrderQueryViewController ()
{
    NLProgressHUD* _hud;
}
@property(nonatomic, strong)NSMutableArray* myArray;
@property(nonatomic, strong)NLButtonViewController* myBtnVC;
@property(nonatomic, strong)NLButtonViewController* myBtnVC0;
@property(nonatomic, strong)NLButtonViewController* myBtnVC1;
@property(nonatomic, strong)NLButtonViewController* myBtnVC2;
@property(nonatomic, strong)NLButtonViewController* myBtnVC3;
@property(nonatomic, strong)NLButtonViewController* myBtnVC4;
@property(nonatomic, strong)NLButtonViewController* myBtnVC5;
@property(nonatomic, strong)NLButtonViewController* myBtnVC6;
@property(nonatomic, strong)NLButtonViewController* myBtnVC7;
@property(nonatomic, strong)NLButtonViewController* myBtnVC8;
@property(nonatomic, strong)NLButtonViewController* myBtnVC9;
@property(nonatomic, strong)NLButtonViewController* myBtnVC10;
@property(nonatomic, strong)NLButtonViewController* myBtnVC11;
@property(nonatomic, strong)IBOutlet UIButton* myMoreBtn;

//-(IBAction)onMoreBtnClicked:(id)sender;
-(void)moreOrderQuery;

@end

@implementation NLOrderQueryViewController

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
    self.navigationController.topViewController.title = @"快递查询";
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"查看更多"
                                                                      style:UIBarButtonItemStyleBordered target:self
                                                                     action:@selector(moreOrderQuery)];
	self.navigationItem.rightBarButtonItem = anotherButton;
    
    [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
    
    self.myArray = [NSMutableArray arrayWithCapacity:1];
    UIView *content = [[self.view subviews] objectAtIndex:0];
	((UIScrollView *)self.view).contentSize = content.bounds.size;
    [self readKuaiDicmpList];
}

-(void)viewDidAppear:(BOOL)animated
{
    [NLUtils enableSliderViewController:NO];
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [NLUtils enableSliderViewController:YES];
    [super viewWillDisappear:animated];
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

-(NLButtonViewController*)getButton:(NSString*)title tag:(int)tag
{
    NLButtonViewController* vc = [[NLButtonViewController alloc] initWithTitle:title image:nil tag:tag];
    vc.myDelegate = self;
    return vc;
}

-(void)getButtionVC:(int)index view:(UIView*)view title:(NSString*)title
{
    switch (index)
    {
        case NLOrderQueryView0:
        {
            self.myBtnVC0 = [self getButton:title tag:NLOrderQueryView0];
            [view addSubview:self.myBtnVC0.view];
        }
            break;
        case NLOrderQueryView1:
        {
            self.myBtnVC1 = [self getButton:title tag:NLOrderQueryView1];
            [view addSubview:self.myBtnVC1.view];
        }
            break;
        case NLOrderQueryView2:
        {
            self.myBtnVC2 = [self getButton:title tag:NLOrderQueryView2];
            [view addSubview:self.myBtnVC2.view];
        }
            break;
        case NLOrderQueryView3:
        {
            self.myBtnVC3 = [self getButton:title tag:NLOrderQueryView3];
            [view addSubview:self.myBtnVC3.view];
        }
            break;
        case NLOrderQueryView4:
        {
            self.myBtnVC4 = [self getButton:title tag:NLOrderQueryView4];
            [view addSubview:self.myBtnVC4.view];
        }
            break;
        case NLOrderQueryView5:
        {
            self.myBtnVC5 = [self getButton:title tag:NLOrderQueryView5];
            [view addSubview:self.myBtnVC5.view];
        }
            break;
        case NLOrderQueryView6:
        {
            self.myBtnVC6 = [self getButton:title tag:NLOrderQueryView6];
            [view addSubview:self.myBtnVC6.view];
        }
            break;
        case NLOrderQueryView7:
        {
            self.myBtnVC7 = [self getButton:title tag:NLOrderQueryView7];
            [view addSubview:self.myBtnVC7.view];
        }
            break;
        case NLOrderQueryView8:
        {
            self.myBtnVC8 = [self getButton:title tag:NLOrderQueryView8];
            [view addSubview:self.myBtnVC8.view];
        }
            break;
        case NLOrderQueryView9:
        {
            self.myBtnVC9 = [self getButton:title tag:NLOrderQueryView9];
            [view addSubview:self.myBtnVC9.view];
        }
            break;
        case NLOrderQueryView10:
        {
            self.myBtnVC10 = [self getButton:title tag:NLOrderQueryView10];
            [view addSubview:self.myBtnVC10.view];
        }
            break;
        case NLOrderQueryView11:
        {
            self.myBtnVC11 = [self getButton:title tag:NLOrderQueryView11];
            [view addSubview:self.myBtnVC11.view];
        }
            break;
            
        default:
            break;
    }
}

-(void)showView:(int)index show:(BOOL)show title:(NSString*)title
{
    UIView* view = (UIView *)[self.view viewWithTag:index];
    if (show == NO)
    {
        view.hidden = YES;
    }
    else
    {
        view.hidden = NO;
        [self getButtionVC:index view:view title:title];
    }
}

-(void)refresh
{
    int count = [self.myArray count];
    for (int i=0; i<12&&i<count; i++)
    {
        [self showView:(NLOrderQueryView0+i)
                  show:YES
                 title:[[self.myArray objectAtIndex:i] objectForKey:@"comname"]];
    }
    for (int i=count; i<12; i++)
    {
        [self showView:(NLOrderQueryView0+i)
                  show:NO
                 title:nil];
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
         NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:comidStr,@"comid",comStr,@"com",comnameStr,@"comname",apitypeStr,@"apitype",comlogoStr,@"comlogo", nil];
        [self.myArray addObject:dic];
    }
    if ([self.myArray count] > 0)
    {
        [self refresh];
    }
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
            detail = @"请求失败，请检查网络";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

-(void)readKuaiDicmpList
{
    NSString* name = [NLUtils getNameForRequest:Notify_readKuaiDicmpList];
    REGISTER_NOTIFY_OBSERVER(self, readKuaiDicmpListNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] readKuaiDicmpList];
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
}

#pragma mark - NLButtonViewControllerDelegate

-(void)onNLButtonClicked:(UIButton*)button
{
    //NLLogNoLocation(@"tag = %d",button.tag);
    int tag = button.tag;
    if (tag >= NLOrderQueryView0)
    {
        tag -= NLOrderQueryView0;
    }
    NLStartOrderQueryViewController* vc = [[NLStartOrderQueryViewController alloc] initWithNibName:@"NLStartOrderQueryViewController" bundle:nil];
    vc.myCompanyName = [[self.myArray objectAtIndex:tag] objectForKey:@"comname"];
    vc.myCompanyCom = [[self.myArray objectAtIndex:tag] objectForKey:@"com"];
    [self.navigationController pushViewController:vc animated:YES];
}

//-(IBAction)onMoreBtnClicked:(id)sender
//{
//    NLMoreOrderQueryViewController* vc = [[NLMoreOrderQueryViewController alloc] initWithNibName:@"NLMoreOrderQueryViewController" bundle:nil];
//    vc.myArray = [NSArray arrayWithArray:self.myArray];
//    [self.navigationController pushViewController:vc animated:YES];
//}

-(void)moreOrderQuery
{
    NLMoreOrderQueryViewController* vc = [[NLMoreOrderQueryViewController alloc] initWithNibName:@"NLMoreOrderQueryViewController" bundle:nil];
    vc.myArray = [NSArray arrayWithArray:self.myArray];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) doPush
{
    [_hud hide:YES];
    [NLUtils popToLogonVCByHTTPError:self feedOrLeft:1];
}

@end
