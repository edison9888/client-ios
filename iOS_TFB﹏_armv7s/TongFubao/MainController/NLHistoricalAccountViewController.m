//
//  NLHistoricalAccountViewController.m
//  TongFubao
//
//  Created by jiajie on 13-12-30.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLHistoricalAccountViewController.h"
#import "NLHistoricalAccountCell.h"
#import "NLProtocolRequest.h"
#import "NLProtocolData.h"
#import "NLProgressHUD.h"
#import "NLUtils.h"

@interface NLHistoricalAccountViewController ()
{
    NLProgressHUD* _hud;
}

@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, retain) NSMutableArray* myArray;

@end

@implementation NLHistoricalAccountViewController
@synthesize myTableView,otherPage;

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
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
    // Do any additional setup after loading the view from its nib.
    self.myArray = [NSMutableArray arrayWithCapacity:1];
    [self protocolRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [NLUtils enableSliderViewController:NO];
    [super viewDidAppear:animated];
    if (animated)
    {
        [self.myTableView flashScrollIndicators];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [NLUtils enableSliderViewController:YES];
    [super viewWillDisappear:animated];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
    return view;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ([self.myArray count] + 1);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NLHistoricalAccountCell *cell =nil;
    static NSString *kCellID = @"NLHistoricalAccountCell";
    cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (cell == nil)
    {
        NSArray* temp = [[NSBundle mainBundle] loadNibNamed:kCellID owner:self options:nil];
        cell=[temp objectAtIndex:0];
    }
    
    
    if ([indexPath row] == 0)
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else
    {
        int i = [indexPath row] - 1;
        
        if (i < [self.myArray count])
        {
            cell.myCardNumberLabel.text = [NLUtils formatCardNumber:[[self.myArray objectAtIndex:i] objectForKey:@"shoucardno"]];
            cell.myCardBankLabel.text = [[self.myArray objectAtIndex:i] objectForKey:@"shoucardbank"];
            cell.myCardNameLabel.text = [[self.myArray objectAtIndex:i] objectForKey:@"shoucardman"];
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int i = [indexPath row] - 1;
    if (i < [self.myArray count])
    {
        switch (self.myHistoryPayType)
        {
            case NLHistoryPayType_Creditcard:
            {
                NSString* shoucardno = [[self.myArray objectAtIndex:i] objectForKey:@"shoucardno"];
                NSString* shoucardbank = [[self.myArray objectAtIndex:i] objectForKey:@"shoucardbank"];
                NSString* shoucardman = [[self.myArray objectAtIndex:i] objectForKey:@"shoucardman"];
                NSString* shoucardmobile = [[self.myArray objectAtIndex:i] objectForKey:@"shoucardmobile"];
                if ([otherPage isEqualToString:@"Saving"])
                {
                    [self.delegate HistoriupdateValue:shoucardno Historishoucardbank:shoucardbank Historishoucardman:shoucardman Historishoucardmobile:shoucardmobile Historibankid:@""];
                }
                else
                {
                    
                    [self.creditcardDelegate updateValue:shoucardno shoucardbank:shoucardbank shoucardman:shoucardman shoucardmobile:shoucardmobile];
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
                break;
            case NLHistoryPayType_Repay:
            {
                NSString* shoucardno = [[self.myArray objectAtIndex:i] objectForKey:@"shoucardno"];
                NSString* shoucardbank = [[self.myArray objectAtIndex:i] objectForKey:@"shoucardbank"];
                NSString* shoucardman = [[self.myArray objectAtIndex:i] objectForKey:@"shoucardman"];
                NSString* shoucardmobile = [[self.myArray objectAtIndex:i] objectForKey:@"shoucardmobile"];
                NSString* bankid = [[self.myArray objectAtIndex:i] objectForKey:@"bankid"];
                
                if ([otherPage isEqualToString:@"Saving"])
                {
                    [self.delegate HistoriupdateValue:shoucardno Historishoucardbank:shoucardbank Historishoucardman:shoucardman Historishoucardmobile:shoucardmobile Historibankid:bankid];
                }
                else
                {
                    [self.repayDelegate updateValue:shoucardno shoucardbank:shoucardbank shoucardman:shoucardman shoucardmobile:shoucardmobile bankid:bankid];
                }
                
                
                [self.navigationController popViewControllerAnimated:YES];
            }
                break;
            case NLHistoryPayType_Order:
            {
                
            }
                break;
            case NLHistoryPayType_Tfmg:
            case NLHistoryPayType_Suptfmg:
            {
                NSString* shoucardno = [[self.myArray objectAtIndex:i] objectForKey:@"shoucardno"];
                NSString* shoucardbank = [[self.myArray objectAtIndex:i] objectForKey:@"shoucardbank"];
                NSString* shoucardman = [[self.myArray objectAtIndex:i] objectForKey:@"shoucardman"];
                NSString* shoucardmobile = [[self.myArray objectAtIndex:i] objectForKey:@"shoucardmobile"];
                NSString* bankid = [[self.myArray objectAtIndex:i] objectForKey:@"bankid"];
                if ([otherPage isEqualToString:@"Saving"])
                {
                    [self.delegate HistoriupdateValue:shoucardno Historishoucardbank:shoucardbank Historishoucardman:shoucardman Historishoucardmobile:shoucardmobile Historibankid:bankid];
                }
                else
                {
                    
                    [self.tfmgDelegate updateValue:shoucardno shoucardbank:shoucardbank shoucardman:shoucardman shoucardmobile:shoucardmobile bankid:bankid];
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
                break;
                
            default:
                break;
        }
    }
}

-(void)protocolRequest
{
    switch (self.myHistoryPayType)
    {
        case NLHistoryPayType_Creditcard:
        {
            [self readshoucardList:@"creditcard"];
        }
            break;
        case NLHistoryPayType_Repay:
        {
            [self readshoucardList:@"repay"];
        }
            break;
        case NLHistoryPayType_Order:
        {
            [self readshoucardList:@"order"];
        }
            break;
        case NLHistoryPayType_Tfmg:
        {
            [self readshoucardList:@"tfmg"];
        }
            break;
        case NLHistoryPayType_Suptfmg:
        {
            [self readshoucardList:@"suptfmg"];
        }
            break;
            
        default:
            break;
    }
}

-(void)showErrorInfo:(NSString*)detail status:(NLHUDState)status
{
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
        return @"";
    }
    else
    {
        return str;
    }
}

-(void)doReadshoucardListNotify:(NLProtocolResponse*)response
{
    NSArray* shoucardid = [response.data find:@"msgbody/msgchild/shoucardid"];
    NSArray* shoucardno = [response.data find:@"msgbody/msgchild/shoucardno"];
    NSArray* shoucardbank = [response.data find:@"msgbody/msgchild/shoucardbank"];
    NSArray* shoucardman = [response.data find:@"msgbody/msgchild/shoucardman"];
    NSArray* shoucardmobile = [response.data find:@"msgbody/msgchild/shoucardmobile"];
    NSArray* paytype = [response.data find:@"msgbody/msgchild/paytype"];
    NSArray* bankid = [response.data find:@"msgbody/msgchild/bankid"];
    
    NSString* shoucardidStr = nil;
    NSString* shoucardnoStr = nil;
    NSString* shoucardbankStr = nil;
    NSString* shoucardmanStr = nil;
    NSString* shoucardmobileStr = nil;
    NSString* paytypeStr = nil;
    NSString* bankidStr = nil;
    
    for (int i=0; i<[shoucardid count]; i++)
    {
        NLProtocolData* data = [shoucardid objectAtIndex:i];
        shoucardidStr = [self checkInfo:data.value];
        data = [shoucardno objectAtIndex:i];
        shoucardnoStr = [self checkInfo:data.value];
        data = [shoucardbank objectAtIndex:i];
        shoucardbankStr = [self checkInfo:data.value];
        data = [shoucardman objectAtIndex:i];
        shoucardmanStr = [self checkInfo:data.value];
        data = [shoucardmobile objectAtIndex:i];
        shoucardmobileStr = [self checkInfo:data.value];
        data = [paytype objectAtIndex:i];
        paytypeStr = [self checkInfo:data.value];
        data = [bankid objectAtIndex:i];
        bankidStr = [self checkInfo:data.value];
        
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:shoucardidStr, @"shoucardid", shoucardnoStr, @"shoucardno", shoucardbankStr, @"shoucardbank", shoucardmanStr, @"shoucardman", shoucardmobileStr, @"shoucardmobile", paytypeStr, @"paytype", bankidStr, @"bankid", nil];
        [self.myArray addObject:dic];
    }
}

-(void)readshoucardListNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        [self doReadshoucardListNotify:response];
        self.myTableView.hidden = NO;
        [[self myTableView] reloadData];
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
        //self.myTableView.hidden = YES;
        NSString* detail = response.detail;
        
        if (!detail || detail.length <= 0)
        {
            detail = @"服务器繁忙，请稍候再试";
        }
        
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

-(void)readshoucardList:(NSString*)paytype
{
    NSString* name = [NLUtils getNameForRequest:Notify_readshoucardList];
    REGISTER_NOTIFY_OBSERVER(self, readshoucardListNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] readshoucardList:paytype];
    [self showErrorInfo:@"正在读取历史账户" status:NLHUDState_None];
}

- (void) doPush
{
    [_hud hide:YES];
    [NLUtils popToLogonVCByHTTPError:self feedOrLeft:1];
}

@end
