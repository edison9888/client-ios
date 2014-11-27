//
//  TFNewVersionAgentMainCtr.m
//  TongFubao
//
//  Created by 湘郎 on 14-11-26.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "TFNewVersionAgentMainCtr.h"
#import "XIAOYU_TheControlPackage.h"
#import "ACTwoAgentsViewController.h"
#import "ACAuthorizationCodeAssignmentViewController.h"
#import "ACMoreModulesViewController.h"

#import "TFAgentSearchCtr.h"
#import "TFAgentBookCardCtr.h"
#import "PaySKQ.h"

@interface TFNewVersionAgentMainCtr ()
{
    NLProgressHUD *_hud;
    UIScrollView *scrollView;
    UIButton *functionButton[6];
    UILabel *onTheSameDayReturn[9];
    UILabel *theAreaOfHistoryAndTotalRevenue;//本区历史总收益
    UILabel *inThisAreaTheNumberOfUsers;//本区用户数
    
}


@end

@implementation TFNewVersionAgentMainCtr

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
	// Do any additional setup after loading the view, typically from a nib.
    self.totalRevenue = @"0.00";//本区历史总收益
    self.theNumberOfUsers = @"0";//本区用户数
    self.onTheSameDayReturns = @"0";//代理商号
    self.anticipatedRevenues = @"0.00";//新增收益
    //前面补足钱标￥ 后面如果没有小数点 自动补足.00 当金额超过9个字符的时候需要加个判断 不然显示不完整
    self.amountOfMoneys = @"￥0.00";//当天收益
 
    
    scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    scrollView.backgroundColor = RGBACOLOR(223, 223, 223, 1.0);
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+20);
    scrollView.pagingEnabled = NO;
    scrollView.showsHorizontalScrollIndicator = YES;
    scrollView.showsVerticalScrollIndicator = YES;
    [self.view addSubview:scrollView];
    
    
    [self navigationItemTitleView];//导航条图片
    [self leftBarButtonHome];//跳转主页
    [self upView];//上部视图
    [self underTheView];//下部视图
    
    
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    
}

-(void)showErrorInfo:(NSString*)error status:(NLHUDState)status
{
    [_hud hide:YES];
    _hud = [[NLProgressHUD alloc] initWithParentView: self.view];
    
    switch (status)
    {
        case NLHUDState_Error:
        {
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unCheckmark.png"]] ;//失败
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.detailsLabelText = error;
            [_hud show:YES];
            [_hud hide:YES afterDelay:2];
        }
            break;
            
        case NLHUDState_NoError:
        {
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.png"]] ;//成功
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.labelText = error;
            [_hud show:YES];
            [_hud hide:YES afterDelay:2];
        }
            break;
            
        case NLHUDState_None:
        {
            [self networkRequest];
            _hud.labelText = error;
            [_hud show:YES];
        }
            break;
            
        default:
            break;
    }
    return;
}


#pragma mark - 网络请求
-(void)networkRequest{

    NSDictionary *dataDictionary;
        
    [LoadDataWithASI loadDataWithMsgbody:dataDictionary apiName:@"ApiAgentInfo" apiNameFunc:@"readagentinfo" rolePath:@"//operation_response/msgbody" type:PublicCommon completionBlock:^( id data, NSError *error)
    {
             
        [_hud hide:YES];
             
        if (![data[@"result"] isEqualToString:@"success"])
        {
            NSLog(@"解析失败");
                 
            [self showErrorInfo:@"数据加载失败" status:NLHUDState_Error];
                 
        }else{
                 
            NSLog(@"解析成功 \n%@",data);
            
            //前面补足钱标￥ 后面如果没有小数点 自动补足.00 当金额超过9个字符的时候需要加个判断 不然显示不完整
            NSString *string1 = @"￥";
            NSString *string2 = @"￥";
            NSString *string3 = @"￥";
            
            //本区历史总收益
            NSString *str1 = [data objectForKey:@"areafenrun"];
            if ([str1 rangeOfString:@"."].location != NSNotFound) {
                string1 = [string1 stringByAppendingFormat:@"%@",str1];
                
            }else{
                string1 = [string1 stringByAppendingFormat:@"%@%@",str1,@".00"];
            }
            self.totalRevenue = string1;
            
            
            //本区用户数
            self.theNumberOfUsers = [data objectForKey:@"areaauthornum"];
            
            
            //代理商号
            self.onTheSameDayReturns = [data objectForKey:@"agentno"];
            
            
            //新增收益
            NSString *str2 = [data objectForKey:@"areapaycardnum"];
            if ([str2 rangeOfString:@"."].location != NSNotFound) {
                string2 = [string2 stringByAppendingFormat:@"%@",str2];
                
            }else{
                string2 = [string2 stringByAppendingFormat:@"%@%@",str2,@".00"];
            }
            self.anticipatedRevenues = string2;
            
            
            //当天收益
            NSString *str3 = [data objectForKey:@"todayfenrun"];
            if ([str3 rangeOfString:@"."].location != NSNotFound) {
                string3 = [string3 stringByAppendingFormat:@"%@",str3];
                
            }else{
                string3 = [string3 stringByAppendingFormat:@"%@%@",str3,@".00"];
            }
            self.amountOfMoneys = string3;

            
            /*
             agentlevel = 1;
             agentno = 000254;
             areaauthornum = 0;
             areafenrun = 0;
             areapaycardnum = 0;
             message = "\U8bfb\U53d6\U6210\U529f!";
             result = success;
             salepaycardnum = 0;
             todayfenrun = 0;
             todayyufenrun = "";
             */
            

        }
    }];
}





#pragma mark - 导航条图片
-(void)navigationItemTitleView{
 /*
    CGRect svFrame = IOS7_OR_LATER? CGRectMake(0, -20, 320, 64) : CGRectMake(0, 0, 320, 44);
    UIView *vc = [[UIView alloc] initWithFrame:svFrame];
    vc.opaque = YES;
    vc.backgroundColor = RGBACOLOR(0, 102, 156, 1.0);
    
    [self.navigationController.navigationBar addSubview:vc];
    */
    
    //标题图片
    UIImageView *titleImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo@@x"]];
    titleImgView.frame = CGRectMake(40, 0, 106, 44);
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [titleView addSubview:titleImgView];
    
    
    self.navigationItem.titleView = titleView;
    self.navigationController.view.backgroundColor = RGBACOLOR(0, 102, 152, 1.0);
  
  
  
}


#pragma mark - 跳转主页
-(void)leftBarButtonHome{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 14, 0, 0)];
    imageView.image = [UIImage imageNamed:@"navigationLeftBtnBack2"];
    imageView.userInteractionEnabled = YES;
    imageView.contentMode = UIViewContentModeLeft;
    
    UIButton* backButton= [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 55, 28);
    
    [backButton addTarget:self action:@selector(tapHome:) forControlEvents:UIControlEventTouchUpInside];
    [[backButton titleLabel] setFont:[UIFont boldSystemFontOfSize:17]];
    [backButton setTitle:@"  主页" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [backButton.titleLabel setTextAlignment:NSTextAlignmentRight];
    
    [backButton addSubview:imageView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}


#pragma mark - 上部视图
-(void)upView{
    
    UIView *upVC = [[UIView alloc]initWithFrame:CGRectMake(scrollView.frame.origin.x
                                                           , scrollView.frame.origin.y, scrollView.frame.size.width, 242)];
    upVC.backgroundColor = RGBACOLOR(71, 136, 187, 1.0);
    [scrollView addSubview:upVC];
    
    /*******今天收益*******/
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 25, 300, 125)];
    imageView.backgroundColor = RGBACOLOR(117, 174, 208, 1.0);
    [upVC addSubview:imageView];
    
    UILabel *otsdr = [[UILabel alloc]initWithFrame:CGRectMake(50, 6, 230, 15)];
    //    otsdr.backgroundColor = [UIColor redColor];
    otsdr.text = [NSString stringWithFormat:@"代理商%@,您今天的收益",self.onTheSameDayReturns];
    otsdr.font = [UIFont systemFontOfSize:14];
    otsdr.textColor = RGBACOLOR(27, 71, 128, 1.0);
    [imageView addSubview:otsdr];
    
    UIImageView *imageViewDiTu1 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 24, 245, 2)];
    imageViewDiTu1.backgroundColor = RGBACOLOR(186, 211, 227, 1.0);
    [imageView addSubview:imageViewDiTu1];
    
    
    UILabel *anticipatedRevenue = [[UILabel alloc]initWithFrame:CGRectMake(99, 104, 190, 15)];
    //    anticipatedRevenue.backgroundColor = [UIColor redColor];
    anticipatedRevenue.text = [NSString stringWithFormat:@"( +%@ )",self.anticipatedRevenues];
    anticipatedRevenue.textAlignment = NSTextAlignmentRight;
    anticipatedRevenue.font = [UIFont systemFontOfSize:14];
    anticipatedRevenue.textColor = RGBACOLOR(206, 36, 39, 1.0);
    [imageView addSubview:anticipatedRevenue];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(10, 39, 280, 60)];
    image.backgroundColor = RGBACOLOR(194, 204, 207, 1.0);
    [imageView addSubview:image];
    
    NSLog(@"amountOfMoneys %@",self.amountOfMoneys);
    
    
    
    for (int i=0; i<9; i++) {
        onTheSameDayReturn[i] = [[UILabel alloc]initWithFrame:CGRectMake(5+30*i, 5, 30, 50)];
        onTheSameDayReturn[i].backgroundColor = [UIColor yellowColor];
        onTheSameDayReturn[i].textColor = [UIColor whiteColor];
        onTheSameDayReturn[i].textAlignment = NSTextAlignmentCenter;
        onTheSameDayReturn[i].font = [UIFont systemFontOfSize:37];
        onTheSameDayReturn[i].tag = 7150+i;
        
        
        
        
        switch (onTheSameDayReturn[i].tag) {
            case 7150:
                onTheSameDayReturn[i].backgroundColor = RGBACOLOR(234, 133, 51, 1.0);
                break;
            case 7151:
                onTheSameDayReturn[i].backgroundColor = RGBACOLOR(240, 166, 65, 1.0);
                break;
            case 7152:
                onTheSameDayReturn[i].backgroundColor = RGBACOLOR(234, 133, 51, 1.0);
                break;
            case 7153:
                onTheSameDayReturn[i].backgroundColor = RGBACOLOR(240, 166, 65, 1.0);
                break;
            case 7154:
                onTheSameDayReturn[i].backgroundColor = RGBACOLOR(234, 133, 51, 1.0);
                break;
            case 7155:
                onTheSameDayReturn[i].backgroundColor = RGBACOLOR(240, 166, 65, 1.0);
                break;
            case 7156:
                onTheSameDayReturn[i].backgroundColor = RGBACOLOR(234, 133, 51, 1.0);
                break;
            case 7157:
                onTheSameDayReturn[i].backgroundColor = RGBACOLOR(240, 166, 65, 1.0);
                break;
            case 7158:
                onTheSameDayReturn[i].backgroundColor = RGBACOLOR(234, 133, 51, 1.0);
                break;
                
            default:
                break;
        }
        
        
        [image addSubview:onTheSameDayReturn[i]];
    }
    
    for (int c=1 ; c<(int)self.amountOfMoneys.length+1; c++) {
        
        NSString *newString = [self.amountOfMoneys substringFromIndex:[self.amountOfMoneys length] - c];
        self.toString = [newString substringToIndex:1];
        
        NSLog(@"最后一个字符 %@",self.toString);
        int y=9;
        
        onTheSameDayReturn[y-c].text = self.toString;
        
    }
    
    
    
    
    
    
    /*******本区历史总收益***本区用户数********/
    
    UILabel *tAOHATR = [[UILabel alloc]initWithFrame:CGRectMake(30, 180, 100, 18)];
    //    tAOHATR.backgroundColor = [UIColor yellowColor];
    tAOHATR.text = @"本区历史总收益";
    tAOHATR.textColor = [UIColor whiteColor];
    tAOHATR.textAlignment = NSTextAlignmentCenter;
    //正常字体:systemFontOfSize  粗体:boldSystemFontOfSize
    tAOHATR.font = [UIFont boldSystemFontOfSize:13];
    [upVC addSubview:tAOHATR];
    
    theAreaOfHistoryAndTotalRevenue = [[UILabel alloc]initWithFrame:CGRectMake(10, 205, 140, 18)];
    //    theAreaOfHistoryAndTotalRevenue.backgroundColor = [UIColor yellowColor];
    theAreaOfHistoryAndTotalRevenue.text = self.totalRevenue;
    theAreaOfHistoryAndTotalRevenue.textColor = [UIColor whiteColor];
    theAreaOfHistoryAndTotalRevenue.textAlignment = NSTextAlignmentCenter;
    theAreaOfHistoryAndTotalRevenue.font = [UIFont boldSystemFontOfSize:22];
    [upVC addSubview:theAreaOfHistoryAndTotalRevenue];
    
    
    UILabel *iTATNOU = [[UILabel alloc]initWithFrame:CGRectMake(200, 180, 100, 18)];
    //    iTATNOU.backgroundColor = [UIColor yellowColor];
    iTATNOU.text = @"本区用户数";
    iTATNOU.textColor = [UIColor whiteColor];
    iTATNOU.textAlignment = NSTextAlignmentCenter;
    iTATNOU.font = [UIFont boldSystemFontOfSize:13];
    [upVC addSubview:iTATNOU];
    
    
    inThisAreaTheNumberOfUsers = [[UILabel alloc]initWithFrame:CGRectMake(185, 205, 130, 18)];
    //    inThisAreaTheNumberOfUsers.backgroundColor = [UIColor yellowColor];
    inThisAreaTheNumberOfUsers.text = self.theNumberOfUsers;
    inThisAreaTheNumberOfUsers.textColor = [UIColor whiteColor];
    inThisAreaTheNumberOfUsers.textAlignment = NSTextAlignmentCenter;
    inThisAreaTheNumberOfUsers.font = [UIFont boldSystemFontOfSize:22];
    [upVC addSubview:inThisAreaTheNumberOfUsers];
    
    UIImageView *imageViewDiTu2 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 168, 300, 2)];
    imageViewDiTu2.backgroundColor = RGBACOLOR(144, 178, 203, 1.0);
    [upVC addSubview:imageViewDiTu2];
    
    UIImageView *imageViewDiTu3 = [[UIImageView alloc]initWithFrame:CGRectMake(171, 176, 2, 55)];
    imageViewDiTu3.backgroundColor = RGBACOLOR(142, 182, 211, 1.0);
    [upVC addSubview:imageViewDiTu3];
}

#pragma mark - 下部视图
-(void)underTheView{
    
    UIScrollView *underTheVC = [[UIScrollView alloc]initWithFrame:CGRectMake(scrollView.frame.origin.x, 242, scrollView.frame.size.width, 270)];
    underTheVC.backgroundColor = RGBACOLOR(223, 223, 223, 1.0);
    [scrollView addSubview:underTheVC];
    
    
    
    
    for (int i=0; i<6; i++) {
        functionButton[i] = [[UIButton alloc]initWithFrame:CGRectMake((i%3)*(78+30)+13, (i/3)*(78+42)+18, 78, 78)];
        [functionButton[i] setTitleColor:RGBACOLOR(22, 52, 81, 1.0) forState:UIControlStateNormal];
        [functionButton[i] setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, -105, 0.0)];
        [functionButton[i].titleLabel setTextAlignment:NSTextAlignmentCenter];
        [functionButton[i].titleLabel setFont:[UIFont systemFontOfSize: 15.0]];
        functionButton[i].tag = 7110+i;
        
        switch (functionButton[i].tag) {
            case 7110:
                [functionButton[i] setTitle:@"历史收益" forState:UIControlStateNormal];
                [functionButton[i] setBackgroundImage:[UIImage imageNamed:@"bank1"] forState:UIControlStateNormal];
                [functionButton[i] addTarget:self action:@selector(tapHistoricalReturn:) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 7111:
                [functionButton[i] setTitle:@"购买刷卡器" forState:UIControlStateNormal];
                [functionButton[i] setBackgroundImage:[UIImage imageNamed:@"bank2"] forState:UIControlStateNormal];
                [functionButton[i] addTarget:self action:@selector(tapBuyACardReader:) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 7112:
                [functionButton[i] setTitle:@"分配授权码" forState:UIControlStateNormal];
                [functionButton[i] setBackgroundImage:[UIImage imageNamed:@"bank3"] forState:UIControlStateNormal];
                [functionButton[i] addTarget:self action:@selector(tapTheDistributionOfTheAuthorizationCode:) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 7113:
                [functionButton[i] setTitle:@"二级代理商" forState:UIControlStateNormal];
                [functionButton[i] setBackgroundImage:[UIImage imageNamed:@"bank4"] forState:UIControlStateNormal];
                [functionButton[i] addTarget:self action:@selector(tapTwoaAgents:) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 7114:
                [functionButton[i] setTitle:@"订购优惠卡" forState:UIControlStateNormal];
                [functionButton[i] setBackgroundImage:[UIImage imageNamed:@"bank8"] forState:UIControlStateNormal];
                [functionButton[i] addTarget:self action:@selector(tapTheFormalApplication:) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 7115:
                [functionButton[i] setTitle:@"更多模块" forState:UIControlStateNormal];
                [functionButton[i] setBackgroundImage:[UIImage imageNamed:@"bank11"] forState:UIControlStateNormal];
                [functionButton[i] addTarget:self action:@selector(tapMoreModules:) forControlEvents:UIControlEventTouchUpInside];
                break;
            default:
                break;
        }
        [underTheVC addSubview:functionButton[i]];
        
    }
    
    
    
}

#pragma mark - 历史收益
-(void)tapHistoricalReturn:(UIButton *)btn{
    NSLog(@"历史收益");
    
    TFAgentSearchCtr *agentSearchCtr = [[TFAgentSearchCtr alloc]init];
    [self jumpViewController:self newViewController:agentSearchCtr PushAndPresent:YES];
//    agentSearchCtr.title = @"查询历史收益";
//    [agentSearchCtr addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
    //    MainViewController *agentSearchCtr = [[MainViewController alloc]init];
//    [self.navigationController pushViewController:agentSearchCtr animated:YES];
}


#pragma mark - 购买刷卡器
-(void)tapBuyACardReader:(UIButton *)btn{
    NSLog(@"购买刷卡器");
    PaySKQ *vc= [[PaySKQ alloc]init];
    [self jumpViewController:self newViewController:vc PushAndPresent:YES];
    
}


#pragma mark - 分配授权码
-(void)tapTheDistributionOfTheAuthorizationCode:(UIButton *)btn{
    NSLog(@"分配授权码");
    
    ACAuthorizationCodeAssignmentViewController *vc = [[ACAuthorizationCodeAssignmentViewController alloc]init];
    [self jumpViewController:self newViewController:vc PushAndPresent:YES];
    
}


#pragma mark - 二级代理商
-(void)tapTwoaAgents:(UIButton *)btn{
    NSLog(@"二级代理商");
    
    ACTwoAgentsViewController *vc = [[ACTwoAgentsViewController alloc]init];
    [self jumpViewController:self newViewController:vc PushAndPresent:YES];
    
}


#pragma mark - 订购优惠卡
-(void)tapTheFormalApplication:(UIButton *)btn{
    NSLog(@"订购优惠卡");
    
    TFAgentBookCardCtr *bookcardView = [[TFAgentBookCardCtr alloc]init];
    [bookcardView setTitle:@"汇通卡订购"];
    [self jumpViewController:self newViewController:bookcardView PushAndPresent:YES];
    
}


#pragma mark - 更多模块
-(void)tapMoreModules:(UIButton *)btn{
    NSLog(@"更多模块");
    
    ACMoreModulesViewController *vc = [[ACMoreModulesViewController alloc]init];
    [self jumpViewController:self newViewController:vc PushAndPresent:YES];
    
}


-(void)tapHome:(UIButton *)btn{
    
    NSLog(@"主页");
    
    NLAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    [delegate backToMain];
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
