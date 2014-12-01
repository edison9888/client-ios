//
//  MobileShop.m
//  TongFubao
//
//  Created by  俊   on 14-10-24.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "MobileShop.h"

@interface MobileShop ()
{
       NLProgressHUD  * _hud;
}
@end

@implementation MobileShop

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
    // Do any additional setup after loading the view.
    [self mainview];
}

-(void)viewWillAppear:(BOOL)animated{
    [_hud hide:YES];
}

-(void)mainview
{
    self.title= @"手机购物";
    self.view.backgroundColor= RGBACOLOR(245, 245, 245, 1);
    [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
    
    NSMutableArray *mainArr = [NSMutableArray arrayWithCapacity:8];
    [mainArr addObject:@{@"icon":@"lefengwang" , @"txt":@"乐峰网"}];
    [mainArr addObject:@{@"icon":@"suning" , @"txt":@"苏宁商城"}];
    [mainArr addObject:@{@"icon":@"meilishuo" , @"txt":@"美丽说"}];
    [mainArr addObject:@{@"icon":@"dangdang" , @"txt":@"当当"}];
    [mainArr addObject:@{@"icon":@"lashouwang" , @"txt":@"拉手网"}];
    
    int count = [mainArr count];
    
    for (int i=0; i<12&i<count; i++)
    {
        UIView *bgview= [[UIView alloc]initWithFrame:CGRectMake(110*(i%3), 74+100*(i/3), 105, 93)];
        UIButton *treatyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        treatyBtn.opaque = YES;
        treatyBtn.tag= 100+i;
        treatyBtn.frame = CGRectMake(20, 20, 60, 62);
        [treatyBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 0, -90, 0)];
        [treatyBtn setTitle:[[mainArr objectAtIndex:i] valueForKey:@"txt"] forState:UIControlStateNormal];
        [treatyBtn setBackgroundImage:[UIImage imageNamed:[[mainArr objectAtIndex:i] valueForKey:@"icon"]] forState:UIControlStateNormal];
        [treatyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        treatyBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:15.0];
      
        [treatyBtn addTarget:self action:@selector(onNLButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [bgview addSubview:treatyBtn];
        [self.view addSubview:bgview];
        
    }
}

-(void)onNLButtonClicked:(UIButton*)button
{
   
    /*可读性比较差
    NSString *urlStr= button.tag == 100 ? [NSString stringWithFormat:@"http://track.lefeng.com/track.jsp?aid=1959184&cid2=%@&url=http://www.lefeng.com" ,[NLUtils getRegisterMobile]] : [NSString stringWithFormat:@"http://union.suning.com/aas/open/vistorAd.action?userId=1343832&webSiteId=0&adInfoId=2&adBookId=0&channel=11&vistURL=http://m.suning.com/&subUserEx=%@", [NLUtils getRegisterMobile]];*/
    
    NSString *urlStr;
    switch (button.tag) {
        case 100:
        {
            /*乐峰网*/
            urlStr= [NSString stringWithFormat:@"http://m.lefeng.com/index.php/home/index/aid/4850/cid2/1959184/uniStr/%@" ,[NLUtils getRegisterMobile]];
        }
            break;
        case 101:
        {
            /*苏宁*/
            urlStr= [NSString stringWithFormat:@"http://union.suning.com/aas/open/vistorAd.action?userId=1343832&webSiteId=0&adInfoId=2&adBookId=0&channel=11&vistURL=http://m.suning.com/&subUserEx=%@", [NLUtils getRegisterMobile]];
        }
            break;
        case 102:
        {
            /*美丽说*/
            urlStr= [NSString stringWithFormat:@"http://m.meilishuo.com/?nmref=NM_s10936_0_%@&channel=40106", [NLUtils getRegisterMobile]];
        }
            break;
        case 103:
        {
            /*当当*/
            urlStr= [NSString stringWithFormat:@"http://m.dangdang.com/?unionid=P-325477-%@", [NLUtils getRegisterMobile]];
        }
            break;
        case 104:
        {
            /*拉手网*/
            urlStr= [NSString stringWithFormat:@"http://m.lashou.com/?union_pid=707022118&src=lashouwap&uid=%@", [NLUtils getRegisterMobile]];
        }
            break;
           
        default:
            break;
    }
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    SVWebViewController *webViewController = [[SVWebViewController alloc] initWithURL:URL];
    [NLUtils presentModalViewController:self newViewController:webViewController];
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
            //_hud.labelText = error;
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
