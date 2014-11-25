//
//  NLOrderPayFirstViewController.m
//  TongFubao
//
//  Created by MD313 on 13-9-30.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLOrderPayFirstViewController.h"
#import "NLUtils.h"
#import "NLProtocolRequest.h"
#import "NLProgressHUD.h"
#import "NLOrderPaySecondViewController.h"

@interface NLOrderPayFirstViewController ()
{
    NLProgressHUD* _hud;
}

@property(nonatomic,strong)IBOutlet UILabel* myAccountLabel;
@property(nonatomic,strong)IBOutlet UILabel* myWalletLabel;
@property(nonatomic,strong)IBOutlet UIButton* myAccountButton;
@property(nonatomic,strong)IBOutlet UIButton* myCardButton;
@property(nonatomic,strong)IBOutlet UIButton* mySureButton;

-(IBAction)onSureBtnClicked:(id)sender;

@end

@implementation NLOrderPayFirstViewController

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
    self.navigationController.topViewController.title = @"支付方式";
    [self readMyAccount];//支付方式 关联到我的钱包
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

//订单
-(IBAction)onSureBtnClicked:(id)sender
{
    NLOrderPaySecondViewController* vc = [[NLOrderPaySecondViewController alloc] initWithNibName:@"NLOrderPaySecondViewController" bundle:nil];
    vc.myDictionary = [NSDictionary dictionaryWithDictionary:self.myDictionary];
    [self.navigationController pushViewController:vc animated:YES];
}

//错误信息的提示框
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

//支付方式
-(void)doReadMyAccountNotify:(NLProtocolResponse*)response
{
    NLProtocolData* data = [response.data find:@"msgbody/accallmoney" index:0];
    if (data.value == nil || data.value.length <= 0)
    {
        self.myWalletLabel.text = @"0元";
    }
    else
    {
        self.myWalletLabel.text = [NSString stringWithFormat:@"%@元",data.value];
    }
}

-(void)readMyAccountNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    NSString* detail = response.detail;
    int error = response.errcode;
    if (error == RSP_NO_ERROR)
    {
        [self doReadMyAccountNotify:response];
        [_hud hide:YES];
    }
    else if (error == RSP_TIMEOUT)
    {
        [self showErrorInfo:@"请求超时,需要重新登录" status:NLHUDState_Error];
        [self performSelector:@selector(doPush) withObject:nil afterDelay:2.0f];
        return;
    }
    else
    {
        if (!detail || detail.length <= 0)
        {
            detail = @"服务器繁忙，请稍候再试";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

-(void)readMyAccount
{
    NSString* name = [NLUtils getNameForRequest:Notify_readMyAccount];
    REGISTER_NOTIFY_OBSERVER(self, readMyAccountNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] readMyAccount];
    [self showErrorInfo:nil status:NLHUDState_None];
}

//登陆超时的事件
- (void) doPush
{
    [_hud hide:YES];
    [NLUtils popToLogonVCByHTTPError:self feedOrLeft:1];
}

@end
