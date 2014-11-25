//
//  NLHelpCenterViewController.m
//  TongFubao
//
//  Created by MD313 on 13-8-7.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLHelpCenterViewController.h"
#import "NLHelpCenterCell.h"
#import "NLProtocolRequest.h"
#import "NLUtils.h"
#import "NLPlistOper.h"
#import "NLContants.h"
#import "NLShowTextViewController.h"
#import "NLProgressHUD.h"
#import "MJRefresh.h"

@interface NLHelpCenterViewController ()<MJRefreshBaseViewDelegate>
{
    NLProgressHUD* _hud;
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
    
    NSString* _msgdiscount;
    NSString* _msgstart;
    NSString* _msgdisplay;
    BOOL _shouldFree;
}

@property(nonatomic,retain) IBOutlet UITableView* myTableView;
@property(nonatomic,strong)NSMutableArray* myArray;

@end

@implementation NLHelpCenterViewController

@synthesize myTableView;

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
    self.navigationController.topViewController.title = @"帮助中心";
    
    UIButton* backButton = [NLUtils createNavigationLeftBarButtonImage];
    
    [backButton setBackgroundImage:[UIImage imageNamed:@"navigationLeftBtnBack2"] forState:UIControlStateNormal];
    
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    [self initValue];
    [self initMJRefresh];
    [self readHelpList];
}

-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)initValue
{
    _msgdiscount = @"";
    _msgstart = @"0";
    _msgdisplay = @"5";
    self.myArray = [NSMutableArray arrayWithCapacity:1];
    _shouldFree = YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    _shouldFree = YES;
    [super viewDidAppear:animated];
}


-(void)viewWillDisappear:(BOOL)animated
{
    if (_shouldFree)
    {
        [_footer free];
        [_header free];
    }
    [super viewWillDisappear:animated];
}

-(void)initMJRefresh
{
    // 下拉刷新
    _header = [[MJRefreshHeaderView alloc] init];
    _header.delegate = self;
    _header.scrollView = self.myTableView;
    
    // 上拉加载更多
    _footer = [[MJRefreshFooterView alloc] init];
    _footer.delegate = self;
    _footer.scrollView = self.myTableView;
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

-(NSString*)getNoNilStr:(NSString*)str
{
    if (str == nil)
    {
        return @"";
    }
    return str;
}

-(void)refrshTableView
{
    if ([self.myArray count] > 0)
    {
        self.myTableView.hidden = NO;
        [self.myTableView reloadData];
    }
    else
    {
        self.myTableView.hidden = YES;
    }
}

-(void)doReadHelpListNotify:(NLProtocolResponse*)response
{
    NLProtocolData* data = [response.data find:@"msgbody/msgdiscount" index:0];
    _msgdiscount = [self getNoNilStr:data.value];
    NSArray* helpidArr = [response.data find:@"msgbody/msgchild/helpid"];
    NSString* helpcontent = nil;
    NSString* helpdate = nil;
    NSString* helpname = nil;
    NSString* helpid = nil;
    int count = [helpidArr count];
    for (int i=0; i<count; i++)
    {
        data = [response.data find:@"msgbody/msgchild/helpcontent" index:i];
        helpcontent = [self getNoNilStr:data.value];
        data = [response.data find:@"msgbody/msgchild/helpdate" index:i];
        helpdate = [self getNoNilStr:data.value];
        data = [response.data find:@"msgbody/msgchild/helpname" index:i];
        helpname = [self getNoNilStr:data.value];
        data = [response.data find:@"msgbody/msgchild/helpid" index:i];
        helpid = [self getNoNilStr:data.value];
       
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:helpcontent,@"helpcontent",helpdate,@"helpdate",helpname,@"helpname",helpid,@"helpid",nil];
        [self.myArray addObject:dic];
    }
    [self refrshTableView];
}

-(void)readHelpListNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (error == RSP_NO_ERROR)
    {
        [_hud hide:YES];
        [self doReadHelpListNotify:response];
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
        // 让刷新控件恢复默认的状态
        [_header endRefreshing];
        [_footer endRefreshing];
        if (!detail || detail.length <= 0)
        {
            detail = @"请求失败，请检查网络";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

-(void)readHelpList
{
     NSString* name = [NLUtils getNameForRequest:Notify_readHelpList];
    REGISTER_NOTIFY_OBSERVER(self, readHelpListNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] readHelpList:_msgstart display:_msgdisplay];
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
}

-(void)showTextView:(NSString*)text title:(NSString*)title
{
    NLShowTextViewController* vc = [[NLShowTextViewController alloc] initWithNibName:@"NLShowTextViewController" bundle:nil];
    vc.myType = 0;
    vc.myText = text;
    vc.myTitle = @"详细信息";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 76;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    // 让刷新控件恢复默认的状态
    [_header endRefreshing];
    [_footer endRefreshing];
    int count = [self.myArray count];
    return count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NLHelpCenterCell *cell =nil;
    static NSString *kCellID = @"NLHelpCenterCell";
    cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (cell == nil)
    {
        NSArray* temp = [[NSBundle mainBundle] loadNibNamed:kCellID owner:self options:nil];
        cell=[temp objectAtIndex:0];
    }
    if (indexPath.row >= [self.myArray count])
    {
        return cell;
    }
    
    NSString* title = [[self.myArray objectAtIndex:indexPath.row] objectForKey:@"helpname"];    
    NSString* date = [[self.myArray objectAtIndex:indexPath.row] objectForKey:@"helpdate"];
    NSString* content = [[self.myArray objectAtIndex:indexPath.row] objectForKey:@"helpcontent"];
    
    cell.myTitleLabel.text = title;
    cell.myDateLabel.text = date;
    cell.myDetailLabel.text = content;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _shouldFree = NO;
    NSString* title = [[self.myArray objectAtIndex:indexPath.row] objectForKey:@"helpname"];
    NSString* date = [[self.myArray objectAtIndex:indexPath.row] objectForKey:@"helpdate"];
    NSString* content = [[self.myArray objectAtIndex:indexPath.row] objectForKey:@"helpcontent"];
    NSString* text = [NSString stringWithFormat:@"%@\n%@\n%@",title,date,content];
    [self showTextView:text title:title];
    return;
}

- (void) doPush
{
    [_hud hide:YES];
    [NLUtils popToLogonVCByHTTPError:self feedOrLeft:0];
}

#pragma mark MJRefreshBaseViewDelegate

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH : mm : ss.SSS";
    if (_header == refreshView)
    {
        [self.myArray removeAllObjects];
        [self setRequestValues:YES];
        [self readHelpList];
    }
    else
    {
        [self setRequestValues:NO];
        [self readHelpList];
    }
}

-(void)setRequestValues:(BOOL)isDownPush
{
    if (isDownPush)//下拉
    {
        _msgstart = @"0";
        _msgdisplay = @"5";
    }
    else
    {
        int start = [_msgstart intValue];
        int display = [_msgdisplay intValue];
        _msgstart = [NSString stringWithFormat:@"%d",(start+display)];
        _msgdisplay = @"5";
    }
}

@end
