//
//  NLBankListViewController.m
//  TongFubao
//
//  Created by MD313 on 13-8-9.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLBankListViewController.h"
#import "NLDataBase.h"
#import "ProtocolDefine.h"
#import "NLProtocolResponse.h"
#import "NLProtocolRequest.h"
#import "NLPlistOper.h"
#import "NLContants.h"
#import "MJRefresh.h"
#import "NLUtils.h"

typedef enum
{
    TablePushType_None = 0,
    TablePushType_Down,
    TablePushType_Up
} NLBankListTablePushType;

@interface NLBankListViewController()

@property (strong, nonatomic) IBOutlet UIView *myNoteView;


@end

@implementation Bank

@synthesize code = _code;
@synthesize name = _name;


- (id)initWithDictionary:(NSDictionary *)dictionary
{
    //    LOG(@"bank ==  %@",dictionary);
    if (self = [super init])
    {
        self.code = [dictionary objectForKey:@"code"];
        self.name = [dictionary objectForKey:@"name"];
    }
    return self;
}

+ (NSString *)keyName
{
    return @"name";
}
@end

@interface NLBankListViewController ()<MJRefreshBaseViewDelegate>
{
    BOOL flagend;
    NSString* _querywhere;
    NSString* _msgstart;
    NSString* _msgdisplay;
    NSString* _msgallcount;/*结束数据条数*/
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
    
    BOOL _shouldFree;
}

@property (nonatomic,strong)IBOutlet UISearchBar *searchBar;
@property (nonatomic,strong)IBOutlet UITableView *contentView;
@property (nonatomic,strong)IBOutlet UILabel *titleLabel;
@property (nonatomic,strong)NSArray *data;
@property (nonatomic,strong)NSArray *dataHold;
@property (nonatomic,assign)BOOL scrollTag;
@property (nonatomic,assign)NLBankListState searchState;
@property (nonatomic,strong)NLProgressHUD* myHUD;
@property(nonatomic,strong)NSMutableArray* myArray;
@property(nonatomic,strong)IBOutlet UITextField* myTextField;

- (IBAction)getHistoricalAccountBtton:(id)sender;

@end

@implementation NLBankListViewController

@synthesize bankIndex;
@synthesize searchBar = _searchBar;
@synthesize contentView = _contentView;
@synthesize data = _data;
@synthesize dataHold = _dataHold;
@synthesize delegate = _delegate;
@synthesize scrollTag = _scrollTag;
@synthesize searchState = _searchState;
@synthesize titleLabel = _titleLabel;
@synthesize myTextField;
@synthesize payListBank;

- (id)initWithDataList:(NSArray *)dataList
                 state:(NLBankListState)state
              delegate:(id<NLBankLisDelegate>)delegate
{
    self = [super initWithNibName:@"DataSearchViewController" bundle:[NSBundle mainBundle]];
    if (self)
    {
        self.data = [NSArray arrayWithArray:dataList];
        self.dataHold = [NSArray arrayWithArray:dataList];
        self.delegate = delegate;
        self.searchState = state;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.myActivemobilesms = @"0";
        self.myArray = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

- (IBAction)cancel:(id)sender
{
    if ([_delegate respondsToSelector:@selector(dataSearchDidCanceled:withState:)])
    {
        [_delegate dataSearchDidCanceled:self withState:_searchState];
    }
}

- (void)loadView
{
    [super loadView];
    self.title = @"请选择银行";
    [self addBackButtonItemWithImage:imageName(@"navigationLeftBtnBack2@2x", @"png")];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self initMJRefresh];
    _shouldFree = YES;
    [NLUtils enableSliderViewController:NO];
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (_shouldFree)
    {
        [_footer free];
        [_header free];
        _footer = nil;
        _header = nil;
    }
    [NLUtils enableSliderViewController:YES];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initReadView];
    _shouldFree = YES;
    self.myArray = [NSMutableArray arrayWithCapacity:1];
    [self setExtraCellLineHidden:self.contentView];
    [self getHistoricalAccountBtton:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)initMJRefresh
{
    // 下拉刷新
    if (_header == nil)
    {
        _header = [[MJRefreshHeaderView alloc] init];
        _header.delegate = self;
        _header.scrollView = self.contentView;
    }
    
    // 上拉加载更多
    if (_footer == nil)
    {
        _footer = [[MJRefreshFooterView alloc] init];
        _footer.delegate = self;
        _footer.scrollView = self.contentView;
    }
}

-(void)initReadView
{
    [self setRequestValues:@""
                msgdisplay:@""
                  pushType:TablePushType_None];
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 让刷新控件恢复默认的状态
    [_header endRefreshing];
    [_footer endRefreshing];
    //return [_data count];
    return [self.myArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"DataSearchCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    //NLDataBase_bankListTable *node = [_data objectAtIndex:indexPath.row];
    if (_searchState == BankListStateBank)
    {
        if (indexPath.row >= [self.myArray count])
        {
            return cell;
        }
        cell.textLabel.text = [[self.myArray objectAtIndex:indexPath.row] objectForKey:@"bankname"];//node.myName;
    }
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //if (self.bankIndex != indexPath.row)
    {
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.bankIndex inSection:0]];
        if ([oldCell accessoryType] == UITableViewCellAccessoryCheckmark)
        {
            [oldCell setAccessoryType:UITableViewCellAccessoryNone];
        }
        self.bankIndex = indexPath.row;
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
        if ([newCell accessoryType] == UITableViewCellAccessoryNone)
        {
            [newCell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
        if ([_delegate respondsToSelector:@selector(dataSearch:didSelectWithObject:withState:)])
        {
            //NLDataBase_bankListTable *node = [_data objectAtIndex:indexPath.row];
            NSString* name = [[self.myArray objectAtIndex:indexPath.row] objectForKey:@"bankname"];
            NSString *bankIDs = [[self.myArray objectAtIndex:indexPath.row] objectForKey:@"bankno"];
            //NSString* name = node.myName;
            //int bankID = [node.myID intValue];
            [_delegate dataSearch:self didSelectWithObject:name withState:bankIDs];
            
            NSLog(@"bankIDs %@",bankIDs);
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark MJRefreshBaseViewDelegate

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH : mm : ss.SSS";
    if (_header == refreshView)
    {
        [self.myArray removeAllObjects];
        [self setRequestValues:self.myTextField.text
                    msgdisplay:@""
                      pushType:TablePushType_Up];
        [self readOrderListMore];
    }
    else
    {
        [self setRequestValues:self.myTextField.text
                    msgdisplay:@""
                      pushType:TablePushType_Down];
        if (flagend!=YES)
         {
            [self readOrderListMore];
         }else{
            [_footer endRefreshing];
            [self readOrderListMore];
            [self viewend];
         }
       
    }
}

#pragma mark -
#pragma mark search bar delegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    //NSLog(@"%@",searchText);
    if ([searchText isEqualToString:@""])
    {
        self.data = _dataHold;
        [_contentView reloadData];
        return;
    }
    
    NSString *keyName = @"";
    if (_searchState == BankListStateBank)
    {
        keyName = [Bank keyName];
    }
    /**< 模糊查找*/
    NSPredicate *predicateString = [NSPredicate predicateWithFormat:@"%K contains[cd] %@", keyName, searchText];
    
    /**< 精确查找*/
    //  NSPredicate *predicateString = [NSPredicate predicateWithFormat:@"%K == %@", keyName, searchText];
    
    //NSLog(@"predicate %@",predicateString);
    
    NSMutableArray  *filteredArray = [NSMutableArray arrayWithArray:[_dataHold filteredArrayUsingPredicate:predicateString]];
    
    self.data = filteredArray;
    [_contentView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_searchBar resignFirstResponder];
}

#pragma mark - readOrderList

-(void)readOrderUrl{
    
    /*银行类型 yibao
     bank nil*/
    NSString *banktypeStr= @"";
    
    if (_banKtype==YES)
    {
        banktypeStr= @"yibao";
    }
    NSLog(@"====payListBank=====%@",payListBank);
    NSString* name = [NLUtils getNameForRequest:Notify_readBankList];
    REGISTER_NOTIFY_OBSERVER(self, readBankListNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES]readBankListByPaging:self.myActivemobilesms msgstart:_msgstart msgdisplay:_msgdisplay querywhere:_querywhere banktype:banktypeStr  returnReadmode:payListBank];
}

#pragma mark readBankList
-(void)doReadBankListNotify:(NLProtocolResponse*)response
{
    NLProtocolData* d = nil;
    
    /*银行结束数值计算*/
    _msgallcount = [response.data find:@"msgbody/msgallcount" index:0].value;
    
    NSArray* arr = [response.data find:@"msgbody/msgchild"];
    NSString* bankid = nil;
    NSString* bankno = nil;
    NSString* bankname = nil;
    for (NLProtocolData* data in arr)
    {
        /*NLProtocolData*/ d = [data find:@"bankid" index:0];
        bankid = d.value;
        
        d = [data find:@"bankno" index:0];
        bankno = d.value;
        
        d = [data find:@"bankname" index:0];
        bankname = d.value;
     
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:bankid,@"bankno",bankname,@"bankname", nil];
        [self.myArray addObject:dic];
    }
    if ([self.myArray count] > 0)
    {
        [self.contentView reloadData];
    }
}

-(void)readBankListNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    //NSString* detail = response.detail;
    int error = response.errcode;
    if (error == RSP_NO_ERROR)
    {
//        [self hidMyHUD:YES];
        [self doReadBankListNotify:response];
    }
    else if (error == RSP_TIMEOUT)
    {
        self.myHUD.labelText = @"请求超时,需要重新登录";
        self.myHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unCheckmark.png"]] ;
        self.myHUD.mode = MBProgressHUDModeCustomView;
        [self.myHUD show:YES];
        [self.myHUD hide:YES afterDelay:2];
        [self performSelector:@selector(doPush) withObject:nil afterDelay:2.0f];
        return;
    }
    else
    {
        NSString* detail = response.detail;
        [self.contentView reloadData];
        // 让刷新控件恢复默认的状态
        [_header endRefreshing];
        [_footer endRefreshing];
        [self refresh];
        if (!detail || detail.length <= 0)
        {
            detail = @"服务器繁忙，请稍候再试";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
//        [self hidMyHUD:NO];
    }
}

-(void)hidMyHUD:(BOOL)success
{
    if (success)
    {
        self.myHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.png"]] ;
        self.myHUD.mode = MBProgressHUDModeCustomView;
        self.myHUD.labelText = @"获取成功";
    }
    else
    {
        self.myHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unCheckmark.png"]] ;
        self.myHUD.mode = MBProgressHUDModeCustomView;
        self.myHUD.labelText = @"服务器繁忙，请稍候再试";
    }
    //sleep(2);
    [self.myHUD hide:YES afterDelay:0.1];
}

-(void)showHUD
{
    self.myHUD = [[NLProgressHUD alloc] initWithParentView: self.view];
    self.myHUD.labelText = @"请稍候";
    [self.myHUD show:YES];
}

#pragma mark - readKuaiDicmpList

-(void)showErrorInfo:(NSString*)error status:(NLHUDState)status
{
    [self.myHUD hide:YES];
    self.myHUD = [[NLProgressHUD alloc] initWithParentView: self.view];
    
    switch (status)
    {
        case NLHUDState_Error:
        {
            self.myHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unCheckmark.png"]] ;
            self.myHUD.mode = MBProgressHUDModeCustomView;
            self.myHUD.detailsLabelText = error;
            [self.myHUD show:YES];
            [self.myHUD hide:YES afterDelay:2];
        }
            break;
            
        case NLHUDState_NoError:
        {
            self.myHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.png"]] ;
            self.myHUD.mode = MBProgressHUDModeCustomView;
            self.myHUD.labelText = error;
            [self.myHUD show:YES];
            [self.myHUD hide:YES afterDelay:2];
        }
            break;
            
        case NLHUDState_None:
        {
            self.myHUD.labelText = error;
            [self.myHUD show:YES];
        }
            break;
            
        default:
            break;
    }
    return;
}

-(void)refresh
{
    self.data = [[NLDataBase shareNLDataBase] getAllDataBase:NLDataBaseTable_BlankList
                                                          by:NLDataBaseSearchBy_Default];
    self.searchState = BankListStateBank;
}

- (void) doPush
{
    [self.myHUD hide:YES afterDelay:2];
    [NLUtils popToLogonVCByHTTPError:self feedOrLeft:1];
}

#pragma mark - setRequestValues

-(void)setRequestValues:(NSString*)querywhere
             msgdisplay:(NSString*)msgdisplay
               pushType:(NLBankListTablePushType)pushType
{
    _querywhere = querywhere;
    switch (pushType)
    {
        case TablePushType_None:
        {
        }
            break;
        case TablePushType_Down:
        {
            int start   = [_msgstart intValue];
            int display = [_msgdisplay intValue];
            int allcount= [_msgallcount intValue];
            
            _msgstart = [NSString stringWithFormat:@"%d",(start+display)];

            _msgdisplay = [NSString stringWithFormat:@"%d",allcount - start];
        }
            break;
        case TablePushType_Up:
        {
            _msgstart = @"0";
            {
                _msgdisplay = @"10";
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - ButtonEvent

- (IBAction)getHistoricalAccountBtton:(id)sender
{
    [self.myTextField resignFirstResponder];
    [self.myArray removeAllObjects];
    [self setRequestValues:self.myTextField.text
                msgdisplay:@""
                  pushType:TablePushType_Up];
    [self readOrderListMore];
}



-(void)readOrderListMore
{
     /*结束条数判断*/
    
    if ([_msgdisplay intValue] == [_msgallcount intValue]) {
        flagend= YES;
        [self readOrderUrl];
        
    }else if([_msgdisplay intValue]==10){
        
        [self readOrderUrl];
        
    }else {
        
        [_footer endRefreshing];
        [self viewend];
    }
}

-(void)viewend{
    
    [[[NLToast alloc] init] show:@"当前已加载全部数据..."
                         gravity:NLToastGravityBottom
                        duration:NLToastDurationNormal];
}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [self.contentView setTableFooterView:view];
    [self.contentView setTableHeaderView:view];
}

- (void)viewDidUnload {
    [self setMyNoteView:nil];
    [super viewDidUnload];
}
@end
