//
//  NLStartOrderQueryViewController.m
//  TongFubao
//
//  Created by MD313 on 13-9-25.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLStartOrderQueryViewController.h"
#import "NLProtocolRequest.h"
#import "NLUtils.h"
#import "NLProgressHUD.h"
#import "NLResultOrderQueryViewController.h"

@interface NLStartOrderQueryViewController ()
{
    NLProgressHUD* _hud;
}

@property(nonatomic, strong)IBOutlet UITextField* myTextField;
@property(nonatomic, strong)IBOutlet UILabel* myLabel;
@property(nonatomic, strong)IBOutlet UIButton* myQueryBtn;
@property(nonatomic, strong)NSMutableArray* myArray;

-(IBAction)onQueryBtnClicked:(id)sender;

@end

@implementation NLStartOrderQueryViewController

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
     [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
    self.myArray = [NSMutableArray arrayWithCapacity:1];
    self.myLabel.text = self.myCompanyName;
    [self.myTextField becomeFirstResponder];
    
    _iconName.image= [UIImage imageNamed:_iconNameStr];
    if (_iconName.image==nil) {
      _iconName.image= [UIImage imageNamed:@"expressage.png"];
    }
    [_LablePhone setTitle:_LablePhoneStr forState:UIControlStateNormal];
    
}

- (IBAction)tapbutton:(UIButton*)sender {
    
      NSString *strRechamoney= [_LablePhoneStr stringByReplacingOccurrencesOfString:@"客服服务热线：" withString:@""];
    
    [NLUtils callTel:strRechamoney];
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

-(IBAction)onQueryBtnClicked:(id)sender
{
    [self.myTextField resignFirstResponder];
    if ([[self.myTextField text] length] <= 0)
    {  
        [self showErrorInfo:@"订单号不能为空" status:NLHUDState_Error];
    }
    else
    {
        [self chaxunKuaiDiNo];
    }
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

/*嵌套url 快递的*/
-(void)showResult:(NLResultOrderQueryType)type
{
    if ([self.myArray count] > 0)
    {
        NLResultOrderQueryViewController* vc = [[NLResultOrderQueryViewController alloc] initWithNibName:@"NLResultOrderQueryViewController" bundle:nil];
        vc.myType = type;
        vc.myArray = [NSArray arrayWithArray:self.myArray];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)doWebViewParse:(NLProtocolResponse*)response
{
    NSArray* apiurl = [response.data find:@"msgbody/apiurl"];
    NLProtocolData* data = [apiurl objectAtIndex:0];
    NSString* apiurlStr = data.value;
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:apiurlStr,@"apiurl", nil];
    if ([self.myArray count ]>0)
    {
        [self.myArray removeAllObjects];
        [self.myArray addObject:dic];
    }
    else
    {
        [self.myArray addObject:dic];
    }
//    [self.myArray addObject:dic];
    [self showResult:ResultOrderQuery_Web];
}

-(void)doTableViewParse:(NLProtocolResponse*)response
{
    NLProtocolData* data = nil;
    NSArray* time = [response.data find:@"msgbody/data/msgchild/time"];
    NSString* timeStr = nil;
    NSArray* context = [response.data find:@"msgbody/data/msgchild/context"];
    NSString* contextStr = nil;
    int count = [time count];
    for (int i=0; i<count; i++)
    {
        data = [time objectAtIndex:i];
        timeStr = data.value;
        data = [context objectAtIndex:i];
        contextStr = data.value;
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:timeStr,@"time",contextStr,@"context", nil];
        if ([self.myArray count ]>0)
        {
            [self.myArray removeAllObjects];
            [self.myArray addObject:dic];
        }
        else
        {
            [self.myArray addObject:dic];
        }
    }
    [self showResult:ResultOrderQuery_Table];
}

-(void)doChaxunKuaiDiNoNotify:(NLProtocolResponse*)response
{
    NSArray* apitype = [response.data find:@"msgbody/apitype"];
    NLProtocolData* data = [apitype objectAtIndex:0];
    NSString* apitypeStr = data.value;
    if (!apitypeStr || apitypeStr.length <= 0)
    {
        [self showErrorInfo:@"获取物流信息失败" status:NLHUDState_Error];
    }
    if ([apitypeStr isEqualToString:@"gethtmlorder"])//webView 显示结果
    {
        [self doWebViewParse:response];
    }
    else//tableView 显示结果
    {
        [self doTableViewParse:response];
    }
}

-(void)chaxunKuaiDiNoNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        [self doChaxunKuaiDiNoNotify:response];
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

-(void)chaxunKuaiDiNo
{
    NSString* name = [NLUtils getNameForRequest:Notify_chaxunKuaiDiNo];
    REGISTER_NOTIFY_OBSERVER(self, chaxunKuaiDiNoNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] chaxunKuaiDiNo:_iconNameStr nu:self.myTextField.text];
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
}

- (void) doPush
{
    [_hud hide:YES];
    [NLUtils popToLogonVCByHTTPError:self feedOrLeft:1];
}

@end
