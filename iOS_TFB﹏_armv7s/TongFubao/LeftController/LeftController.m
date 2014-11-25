//
//  LeftController.m
//  DDMenuController
//
//  Created by Devin Doty on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LeftController.h"
#import "NLProtocolNotify.h"
#import "FeedController.h"
#import "NLAppDelegate.h"
#import "LeftControllerCell.h"
#import "NLSlideBroadsideController.h"
#import "NLUtils.h"
#import "NLContants.h"
#import "NLMoreViewController.h"
#import "NLFeedbackViewController.h"
#import "NLToast.h"
#import "NLAboutUsViewController.h"
#import "NLHelpCenterViewController.h"
#import "SecretText.h"
#import "NLUsersInfoSettingsViewController.h"
#import "TFAgentMainCtr.h"
#import "AgentInfoViewController.h"

@interface LeftController()

@property(nonatomic,strong) NSIndexPath *indexpathNum;
@property(nonatomic,strong) NSMutableArray *myContextArray;
@property(nonatomic,strong) NSMutableArray *myImageArray;
@property(nonatomic,strong) NSMutableArray *myAgentArray;
@property(nonatomic,strong) NSMutableArray *myImageAgentArray;
@property(nonatomic,assign) BOOL AgentFlag ;
-(void)showMainView;

@end

@implementation LeftController

@synthesize myContextArray,AgentFlag,myAgentArray,myImageAgentArray;
@synthesize tableView=_tableView;

- (id)init
{
    if ((self = [super init]))
    {
       //代理商的
        AgentFlag = [[NSUserDefaults standardUserDefaults] boolForKey:@"SlideBroadFlag"];
        //AgentFlag==NO
        if (AgentFlag==NO) {
           
            self.myAgentArray = [NSMutableArray arrayWithObjects:@"代理商",@"账户管理",@"意见反馈",@"检查更新",@"帮助中心",@"关于中心", nil];
            
            self.myImageAgentArray = [NSMutableArray arrayWithObjects:@"Imahome@2x.png",@"user.png",@"yijian.png",@"refresh.png",@"help.png",@"us.png", nil];
            
        }
        else
        {
            self.myContextArray = [NSMutableArray arrayWithObjects:@"主界面",@"账户管理",@"激活信息",@"意见反馈",@"检查更新",@"帮助中心",@"关于中心", nil];
           
            self.myImageArray = [NSMutableArray arrayWithObjects:@"home.png",@"user.png",@"dailishangicon.png",@"yijian.png",@"refresh.png",@"help.png",@"us.png", nil];
        }
    }
    
    return self;
}

- (void)viewDidAppear:(BOOL)animated{
      [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate
{
    return NO;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!_tableView)
    {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
      
        tableView.backgroundColor= [UIColor colorWithPatternImage:[NLUtils stretchImage:[UIImage imageNamed:@"bg2.jpg"] edgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)]];
       
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        tableView.delegate = (id<UITableViewDelegate>)self;
       
        tableView.dataSource = (id<UITableViewDataSource>)self;
       
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
       
        tableView.scrollEnabled = NO;
      
        [self.view addSubview:tableView];
      
        self.tableView = tableView;
        
        //修改侧边栏的显示状态 IOS6_7_DELTA(self.tableView, 0, 20, 0, 0);
        IOS6_7_DELTA(self.tableView, 0, 0, 0, 0);
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.tableView = nil;
    self.myContextArray = nil;
    self.myImageArray = nil;
    self.myImageAgentArray = nil;
    self.myAgentArray = nil;
}

-(void)showMainView
{
    if (IOS_7)
    {
        
        [[UINavigationBar appearance] setBarTintColor:NAV_COLOR];
       
        [UINavigationBar appearance].tintColor = [UIColor whiteColor];
       
        NSShadow *shadow = [[NSShadow alloc] init];
        
       
        shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
       
        shadow.shadowOffset = CGSizeMake(0, -0.5);
        
        [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                               [UIColor whiteColor], NSForegroundColorAttributeName,
                                                               shadow, NSShadowAttributeName,
                                                               [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
    }
    else
    {
        [UINavigationBar appearance].tintColor = NAV_COLOR;
    }
    
}

#pragma mark - UITableViewDataSource

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    return 50;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (AgentFlag==NO) {
        
        return [self.myAgentArray count];
        
    }else{
        
        return [self.myContextArray count];
    }
   
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeftControllerCell *cell =nil;
    static NSString *kCellID = @"LeftControllerCell";
    cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (cell == nil)
    {
        NSArray* temp = [[NSBundle mainBundle] loadNibNamed:kCellID owner:self options:nil];
        cell=[temp objectAtIndex:0];
    }
    
    if (indexPath.row==0) {
        
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    //代理商的
    if (AgentFlag==NO) {
        
         cell.myContextLabel.text = [self.myAgentArray objectAtIndex:[indexPath row]];
        
         cell.backgroundColor=[UIColor clearColor];
        
         cell.myImage.image = [UIImage imageNamed:[self.myImageAgentArray objectAtIndex:[indexPath row]]];
    }else{
        
         cell.myContextLabel.text = [self.myContextArray objectAtIndex:[indexPath row]];
        
         cell.backgroundColor=[UIColor clearColor];
        
         cell.myImage.image = [UIImage imageNamed:[self.myImageArray objectAtIndex:[indexPath row]]];
    }
   
    
    return cell;    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _indexpathNum=indexPath;
    // set the root controller
    
    if (AgentFlag==NO) {
        
        [self AgentFlagdidSelectRow];
        
    }else{
        
        [self MaindidSelectRow];
    }
   
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

//代理商的
-(void)AgentFlagdidSelectRow{
    switch (_indexpathNum.row)
    {
        case 0:
        {
            NLAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
            [delegate backToTFAgentTable1];

        }
        break;
        case 1:
        {
             //账户管理
            NLMoreViewController *vl = [[NLMoreViewController alloc] initWithNibName:@"NLMoreViewController" bundle:nil];
            vl.agentFlag= YES;
            [NLUtils presentModalViewController:self newViewController:vl];
        }
        break;
        
        case 2:
        {
            //意见反馈
            NLFeedbackViewController *vl = [[NLFeedbackViewController alloc] initWithNibName:@"NLFeedbackViewController" bundle:nil] ;
            [NLUtils presentModalViewController:self newViewController:vl];
        }
            break;
        case 3:
        {
            [self checkAppVersion];
        }
            break;
        case 4:
        {
            NLHelpCenterViewController* vl=  [[NLHelpCenterViewController alloc] initWithNibName:@"NLHelpCenterViewController" bundle:nil] ;
            [NLUtils presentModalViewController:self newViewController:vl];
            
        }
            break;
        case 5:
        {
            if ([self isUserRegister:NLPushViewType_AboutUs])
            {
                NLAboutUsViewController* vl=  [[NLAboutUsViewController alloc] initWithNibName:@"NLAboutUsViewController" bundle:nil] ;
                [NLUtils presentModalViewController:self newViewController:vl];
                
            }
        }
            break;
        default:
            break;
    }
    [self showMainView];
}

//普通账户
-(void)MaindidSelectRow
{
    switch (_indexpathNum.row)
    {
        case 0:
        {
            NLAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
            [delegate backToMainToTabe1];
        }
            break;
        case 1:
        {
            /*现在我的信息里面包括代理商李彪数据*/
            NLMoreViewController *vl = [[NLMoreViewController alloc] initWithNibName:@"NLMoreViewController" bundle:nil];
             /*agenttypeid字段 0普通/1正式/2虚拟 */
            NSString *agentID= [NLUtils getAgenttypeid];
            if (![agentID isEqualToString:@"0"]) {
                  vl.agentFlag= YES;
            }
            [NLUtils presentModalViewController:self newViewController:vl];
        }
            break;
        case 2:
        {
            //绑定代理商
            AgentInfoViewController *agentInfoView = [[AgentInfoViewController alloc] init];
            [NLUtils presentModalViewController:self newViewController:agentInfoView];
        }
            break;
        case 3:
        {
            //意见反馈
            NLFeedbackViewController *vl = [[NLFeedbackViewController alloc] initWithNibName:@"NLFeedbackViewController" bundle:nil] ;
            [NLUtils presentModalViewController:self newViewController:vl];
        }
            break;
        case 4:
        {
            [self checkAppVersion];
        }
            break;
        case 5:
        {
            NLHelpCenterViewController* vl=  [[NLHelpCenterViewController alloc] initWithNibName:@"NLHelpCenterViewController" bundle:nil] ;
            [NLUtils presentModalViewController:self newViewController:vl];
            
        }
            break;
        case 6:
        {
            if ([self isUserRegister:NLPushViewType_AboutUs])
            {
                NLAboutUsViewController* vl=  [[NLAboutUsViewController alloc] initWithNibName:@"NLAboutUsViewController" bundle:nil] ;
                [NLUtils presentModalViewController:self newViewController:vl];
                
            }
        }
            break;
        default:
            break;
    }
    [self showMainView];
}

-(void)checkAppVersion
{
    //    NSString* name = [NLUtils getNameForRequest:Notify_checkAppVersion];
    //    REGISTER_NOTIFY_OBSERVER(self, checkAppVersionNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] checkAppVersion:@"2" version:TFBVersion];
    [[[NLToast alloc] init] show:@"正在检查,请稍候"
                         gravity:NLToastGravityBottom
                        duration:NLToastDurationNormal];
    //[self showErrorInfo:@"请稍候" status:NLHUDState_None];
  
  
}

-(BOOL)isUserRegister:(NLPushViewType)type
{
    if ([self isForceUpdate])
    {
        return NO;
    }
    
    BOOL reg = [NLUtils isUserRegister];
    if (!reg)
    {
        Gesture *ges= [[Gesture alloc]init];
        ges.timeOutType = @"timeOut";
        [self presentModalViewController:ges animated:YES];
        
    }
    return reg;
}


-(BOOL)isForceUpdate
{
    BOOL result = [[NSUserDefaults standardUserDefaults] boolForKey:@"qiangzhi"];
    
    if(result){
        
        UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"提示"
                                                     message:@"需要更新才可以使用"
                                                    delegate:nil
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles: nil];
        [av show];
        
    }
    
    return result;

}


@end
