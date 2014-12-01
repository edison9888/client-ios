//
//  payMoneyToPay.m
//  TongFubao
//
//  Created by  俊   on 14-9-5.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "payMoneyToPay.h"

@interface payMoneyToPay ()
{
     NLProgressHUD  * _hud;
     NSString *cellAllMoneyPay;
     NSString *cellPeoplePay;
     NSString *cellMoneyIsPay;
     NSString *cellMoneyNeedPay;
     NSString *needpay;
}
@end

@implementation payMoneyToPay

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
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
    cell.myHeaderLabel.hidden = NO;
    cell.myContentLabel.hidden = NO;
    cell.myContentLabel.textAlignment = NSTextAlignmentLeft;
    cell.myDownrightBtn.hidden = YES;
    cell.myUprightBtn.hidden = YES;
    cell.mySelectedBtn.hidden = YES;
    cell.myTextField.hidden = NO;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    [cell.myHeaderLabel setFrame:CGRectMake(cell.myHeaderLabel.frame.origin.x+5, cell.myHeaderLabel.frame.origin.y, cell.myHeaderLabel.frame.size.width+30, cell.myHeaderLabel.frame.size.height)];
    cell.myTextField.userInteractionEnabled= NO;
    [cell.myTextField setFrame:CGRectMake(140, cell.myTextField.frame.origin.y, 140, cell.myTextField.frame.size.height)];
    cell.myTextField.textAlignment = NSTextAlignmentCenter;
    cell.myHeaderLabel.textColor= SACOLOR(159, 1);
    cell.myTextField.textColor= SACOLOR(159, 1);
    
    switch (indexPath.row)
    {
        case 0:
        {
            cell.myHeaderLabel.text = @"发送人员：";
            cell.myContainer = self;
            cell.myContentLabel.hidden = YES;
            cell.myTextField.text = cellPeoplePay;
        }
            break;
        case 1:
        {
            cell.myHeaderLabel.text = @"工资总额：";
            cell.myContainer = self;
            cell.myContentLabel.hidden = YES;
            cell.myTextField.text = cellAllMoneyPay;
        }
            break;
            /*
        case 2:
        {
            cell.myHeaderLabel.text = @"支付总额：";
            cell.myContainer = self;
            cell.myContentLabel.hidden = YES;
            if (needpay!=nil) {
                  cell.myTextField.text = [NSString stringWithFormat:@"%@元",needpay];
            }
        }
            break;
             */
        case 2:
        {
            cell.myContainer = self;
            cell.myHeaderLabel.text = @"已支付：";
            cell.myContentLabel.hidden = YES;
            if (cellMoneyIsPay!=nil) {
                cell.myTextField.text = [NSString stringWithFormat:@"%@元",cellMoneyIsPay];
            }
        }
            break;
        case 3:
        {
            cell.myContainer = self;
            cell.myHeaderLabel.text = @"仍需支付：";
            cell.myContentLabel.hidden = YES;
            if (cellMoneyNeedPay!=nil) {
                  cell.myTextField.text = [NSString stringWithFormat:@"%.2lf元",[cellMoneyNeedPay doubleValue]];
            }
        }
            break;
        default:
            break;
    }
    return cell;
}

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
            break;
    }
    return;
}

- (IBAction)OnbtnClick:(UIButton*)sender {
    UIButton *btn= (UIButton*)sender;
    switch (btn.tag) {
        case 1:
        {
            if (_pushFlag==YES) {
                [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
            }else{
                /*直接用以前的参数了*/
                [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
            }
        }
            break;
        case 2:
        {
            /*直接用以前的参数了*/
            [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)textFieldWithText:(UITextField *)textField
{
    /*对应执照图片*/
}

-(void)oneFingerTwoTaps
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UITextField *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    [firstResponder resignFirstResponder];
}

-(void)viewDidAppear:(BOOL)animated{
   
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title= @"支付结果";
//    _Mytable.userInteractionEnabled= NO;
    [self viewMain];
   
    [self performSelector:@selector(viewDataOnclickOnOk) withObject:nil afterDelay:0.8];
 
}

-(void)viewMain
{
    self.navigationItem.hidesBackButton =YES;
    _Mytable.bounces= NO;
    _cellArrPay= [NSMutableArray array];
    _Mytable.separatorStyle= UITableViewCellSeparatorStyleSingleLineEtched;
}

-(void)viewDataOnclickOnOk
{
       /*支付工资120*/
    if (_hud==nil) {
         [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    }
    NSDictionary *dataDictionary = @{ @"querytype" : @"month", @"querywhere" : _timerStr,  @"bossauthorid" : [NLUtils getbossauthorid]};
    [LoadDataWithASI loadDataWithMsgbody:dataDictionary apiName:@"ApiWageInfo" apiNameFunc:@"paymonthwage" rolePath:@"//operation_response/msgbody/msgchild" type:PublicList completionBlock:^(id data, NSError *error) {
        NSLog(@"120 请求成功%@",data);
        [_cellArrPay setArray:data];
        if ([[data valueForKey:@"wagepaymoney"] objectAtIndex:0]!=nil ) {
        
            if (data!=nil) {
                /*共支付*/
                cellAllMoneyPay= [NSString stringWithFormat:@"%.2lf元",[[[_cellArrPay valueForKey:@"wageallmoney"]objectAtIndex:0] doubleValue]];
            }
         
            /*支付人数*/
            cellPeoplePay = [NSString stringWithFormat:@"%@人",[[_cellArrPay valueForKey:@"wagestanum"]objectAtIndex:0]];
            /*已支付*/
            cellMoneyIsPay = [NSString stringWithFormat:@"%.2lf",[[[_cellArrPay valueForKey:@"wagepaymoney"]objectAtIndex:0] doubleValue]];
            
            /*需支付*/
            needpay = [NSString stringWithFormat:@"%.2lf",[[[_cellArrPay valueForKey:@"needpaymoney"]objectAtIndex:0] doubleValue]];
            /*还需支付*/
            cellMoneyNeedPay = [NSString stringWithFormat:@"%lf元",[needpay doubleValue]-[cellMoneyIsPay doubleValue]];
            
            /*循环刷新 后台有延迟*/
            if ([cellMoneyIsPay isEqualToString:_wagepaymoneyStr]) {
                [self viewDataOnclickOnOk];
                return ;
            }else{
                 [_hud hide:YES];
                if ([cellMoneyNeedPay doubleValue]<=0) {
               
                    [_Mytable setHidden:YES];
                    [_labletextHeard setHidden:YES];
                    [_laleTOOK setHidden:NO];
                    [_lableHeard setHidden:NO];
                    [_NotData setHidden:YES];
                    [_btnReturn setHidden:YES];
                    [_returnBtn.layer setValue:@16 forKeyPath:@"frame.origin.x"];
                    [_returnBtn.layer setValue:@288 forKeyPath:@"frame.size.width"];
//                    [_btnReturn setUserInteractionEnabled:NO];
//                    [_btnReturn setBackgroundImage:[NLUtils createImageWithColor:SACOLOR(200, 1)] forState:UIControlStateNormal];
                }else{
                    
                    _NotData.hidden= YES;
                    _Mytable.hidden= NO;
                    [_labletextHeard setHidden:NO];
                    [_lableHeard setHidden:YES];
                    [_laleTOOK setHidden:YES];
                    [_btnReturn setHidden:NO];
                    [_returnBtn.layer setValue:@169 forKeyPath:@"frame.origin.x"];
                    [_returnBtn.layer setValue:@136 forKeyPath:@"frame.size.width"];
                    
//                    [_btnReturn setUserInteractionEnabled:YES];
                }
                  [_Mytable reloadData];
            }
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
