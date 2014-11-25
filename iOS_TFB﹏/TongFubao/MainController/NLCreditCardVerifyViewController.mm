//
//  NLCreditCardVerifyViewController.m
//  TongFubao
//
//  Created by MD313 on 13-10-22.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLCreditCardVerifyViewController.h"
#import "NLUserInforSettingsCell.h"
#import "NLKeyboardAvoid.h"
#import "NLUtils.h"
#import "NLContants.h"
#import "NLProgressHUD.h"
#import "NLProtocolRequest.h"
#import "GTMBase64.h"
#import "UPPayPlugin.h"
#import "NLTransferResultViewController.h"

@interface NLCreditCardVerifyViewController ()
{
    NSString* _result;
    NLProgressHUD* _hud;
}

@property(nonatomic,strong)IBOutlet UITableView* myTableView;
@property(nonatomic,strong)IBOutlet UIButton* myButton;

- (IBAction)onFinishedBtnClicked:(id)sender;

@end

@implementation NLCreditCardVerifyViewController

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
    self.navigationController.topViewController.title = @"核对信息";
    _result = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
    return view;
}


- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NLUserInforSettingsCell *cell =nil;
    static NSString *kCellID = @"NLUsersInforSettingsCell";
    cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (cell == nil)
    {
        NSArray* temp = [[NSBundle mainBundle] loadNibNamed:kCellID owner:self options:nil];
        cell=[temp objectAtIndex:0];
    }
    cell.myTextField.hidden = YES;
    cell.myDownrightBtn.hidden = YES;
    cell.myUprightBtn.hidden = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    cell.myHeaderLabel.hidden = NO;
    cell.myContentLabel.hidden = NO;
    cell.myContentLabel.textAlignment = NSTextAlignmentLeft;
    
    switch (indexPath.row)
    {
        case 0:       
        {
            cell.myHeaderLabel.text = @"收款卡号";
            cell.myContentLabel.text = [self.myDictionary objectForKey:@"shoucardno"];
        }
            break;
        case 1:
        {
            cell.myHeaderLabel.text = @"付款卡号";
            cell.myContentLabel.text = [self.myDictionary objectForKey:@"fucardno"];
        }
            break;
        case 2:
        {
            cell.myHeaderLabel.text = @"还款金额";
            cell.myContentLabel.text = [self.myDictionary objectForKey:@"paymoney"];
        }
            break;
        case 3:
        {
            cell.myHeaderLabel.text = @"手续费用";
            cell.myContentLabel.text = [self.myDictionary objectForKey:@"feemoney"];
        }
            break;
        case 4:
        {
            cell.myHeaderLabel.text = @"总金额";
            cell.myContentLabel.text = [self.myDictionary objectForKey:@"allmoney"];
        }
            break;
            
        default:
            break;
    }
   
    return cell;
}

- (IBAction)onFinishedBtnClicked:(id)sender
{
    [self doStartPay:[self.myDictionary objectForKey:@"bkntno"]
          sysProvide:nil
                spId:nil
                mode:[NLUtils get_req_bkenv]
      viewController:self
            delegate:self];

}

#pragma mark - UPPayPluginDelegate
- (void)UPPayPluginResult:(NSString *)result
{
    if ([result isEqualToString:@"success"] || [result isEqualToString:@"cancel"] || [result isEqualToString:@"fail"])
    {
        _result = result;
    }
    else
    {
        return;
    }
    [self insertcreditCardMoney];
}

- (BOOL)doStartPay:(NSString *)payData sysProvide:(NSString*)sysProvide spId:(NSString*)spId mode:(NSString*)mode viewController:(UIViewController *)viewController delegate:(id<UPPayPluginDelegate>)delegate;
{
   return [UPPayPlugin startPay:payData mode:mode viewController:viewController delegate:delegate];
}

#pragma mark - http
-(void)createInforForResultView:(NLTransferResultViewController*)vc
{
    vc.myNavigationTitle = @"信用卡还款结果";
    vc.myTitle = @"信用卡还款成功";
    
    NSMutableArray* arr = [NSMutableArray arrayWithCapacity:1];
    
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:@"收款卡号",@"header", [self.myDictionary objectForKey:@"shoucardno"],@"content", nil];
    [arr addObject:dic];
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"付款卡号",@"header", [self.myDictionary objectForKey:@"fucardno"],@"content", nil];
    [arr addObject:dic];
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"还款金额",@"header", [self.myDictionary objectForKey:@"paymoney"],@"content", nil];
    [arr addObject:dic];
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"手续费用",@"header", [self.myDictionary objectForKey:@"feemoney"],@"content", nil];
    [arr addObject:dic];
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"总金额",@"header", [self.myDictionary objectForKey:@"allmoney"],@"content", nil];
    [arr addObject:dic];
    vc.myArray = [NSArray arrayWithArray:arr];
    vc.myType = 0;
}

-(void)doInsertcreditCardMoneyNotify:(NLProtocolResponse*)response
{
    NSRange range = [_result rangeOfString:@"succ"];
    if (range.length <= 0)
    {
        NLProtocolData* data = [response.data find:@"msgbody/message" index:0];
        NSString* value = data.value;
        [self showErrorInfo:value status:NLHUDState_Error];
    }
    else
    {
        NLTransferResultViewController* vc = [[NLTransferResultViewController alloc] initWithNibName:@"NLTransferResultViewController" bundle:nil];
        
        [self createInforForResultView:vc];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)insertcreditCardMoneyNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        [self doInsertcreditCardMoneyNotify:response];
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
        if ([detail isEqualToString:@"支付失败!"])
        {
//            [self performSelector:@selector(showMainView) withObject:nil afterDelay:2.0f];
            [self performSelector:@selector(showPreView) withObject:nil afterDelay:2.0f];
            
        }
        if (!detail || detail.length <= 0)
        {
            detail = @"请求失败，请检查网络";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

-(void)insertcreditCardMoney
{
    NSString* name = [NLUtils getNameForRequest:Notify_insertcreditCardMoney];
    REGISTER_NOTIFY_OBSERVER(self, insertcreditCardMoneyNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] insertcreditCardMoney:[self.myDictionary objectForKey:@"bkntno"] result:_result];
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
}

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

-(void)showMainView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)showPreView
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
