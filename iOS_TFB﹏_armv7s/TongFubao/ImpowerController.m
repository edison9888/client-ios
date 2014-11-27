//
//  ImpowerController.m
//  TongFubao
//
//  Created by Delpan on 14-10-22.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "ImpowerController.h"
#import "MyNumberController.h"

#import "XIAOYU_TheControlPackage.h"
#import "ACMyAuthorizationCode.h"
#import "ACImmediatelyBinding.h"


@interface ImpowerController ()
{
    NLProgressHUD  *_hud;
    //当前高度
    NSInteger currentHeight;
    //当前用户授权码信息
    NSDictionary *userInfoDic;
}

@property (nonatomic, weak) IBOutlet UIScrollView *basicView;

@end

@implementation ImpowerController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"购买授权码";
    }
    return self;
}

#pragma mark - 我的授权码
-(void)myAuthorizationCode{

    [self rightButtonItemWithTitle:@"我的授权码" Frame:CGRectMake(0, 0, 90, 28) backgroundImage:[UIImage imageNamed:@"SMS_historybtn_normal@2x"] backgroundImageHighlighted:[UIImage imageNamed:@"SMS_historybtn_pressed@2x"]];
}

    
#pragma mark - 跳转我的授权码
-(void)tapRightButtonItem:(id)sender{
        
    ACMyAuthorizationCode *vc = [[ACMyAuthorizationCode alloc]init];
    
    vc.authorizationCode = [userInfoDic objectForKey:@"paycardid"];
//    vc.bindingEquipment = [userInfoDic objectForKey:@"paycardIMEI"];
    vc.paycardmachinno = [userInfoDic objectForKey:@"paycardmachinno"];
    
    //复用界面状态表达值  1:绑定本机  2:解除绑定
    vc.bindingEquipment = @"";
    vc.state = [vc.bindingEquipment isEqualToString:@""] ? 1:2;
    NSLog(@"******  vc.bindingEquipment :%@",vc.bindingEquipment);
    [self jumpViewController:self newViewController:vc PushAndPresent:YES];
    
}
    




- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //获取当前屏幕size
    currentHeight = iphoneSize;
    
    //初始化视图
    [self initView];
    
    
    //读取当前用户数据
    [self initData];
}

#pragma mark - 读取当前用记数据
- (void)initData
{
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    
    //参数  //商户：author 代理商：agent
    NSDictionary *dic = @{@"paycardtype" : @"2",@"IDtype" : @"author"};
    
    
    
    [LoadDataWithASI loadDataWithMsgbody:dic apiName:@"ApiAuthorInfo" apiNameFunc:@"GetpaycardList" rolePath:@"//operation_response/msgbody/msgchild" type:PublicList completionBlock:^(id data, NSError *error) {
        
        [_hud hide:YES];
        
        NSLog(@"^^^^^^^^  %@",data);
        userInfoDic = data;

        if (userInfoDic.count == 0) {
            //假设没有授权码
            //我的授权码
            [self myAuthorizationCode];
            userInfoDic = @{@"paycardid":@"18810200030",@"paycardIMEI":@"iphone4S"};
        }
        
        
        
        
        if (![data[@"result"] isEqualToString:@"success"]){
//            [self showErrorInfo:data[@"message"] status:NLHUDState_NoError];//@"请求失败 !"
//            [_hud hide:YES afterDelay:2];
        }else{
//            [self showErrorInfo:data[@"message"] status:NLHUDState_Error];
//            userInfoDic = data;
            
            //授权码
            NSString *paycardid = [data objectForKey:@"paycardid"];
            //设备唯一标识符
            NSString *paycardIMEI = [data objectForKey:@"paycardIMEI"];
            //授权机型
            NSString *paycardmachinno = [data objectForKey:@"paycardmachinno"];
            NSLog(@"paycardid   %@",paycardid);
            NSLog(@"paycardIMEI   %@",paycardIMEI);
            NSLog(@"paycardmachinno   %@",paycardmachinno);
//            NSLog(@"@@@@@   %@",[userInfoDic objectForKey:@"paycardid"]);
//            NSLog(@"$$$$$   %@",[userInfoDic objectForKey:@"paycardIMEI"]);
        }
/*
        if (data)
        {
            
            

            //当前是否有授权码
            if (![[userInfoDic objectForKey:@"paycardid"] isEqualToString:@""])
            {
                //我的授权码
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"我的授权码"
                                                                                          style:UIBarButtonItemStyleBordered
                                                                                         target:self
                                                                                         action:@selector(bindingAction:)];

            }
        }else{
        }
*/
    }];
}

#pragma mark - 初始化视图
- (void)initView
{
    //返回按扭
    [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
    
    //SrcollView内容大小
    self.basicView.contentSize = CGSizeMake(SelfWidth, currentHeight+120);
}

#pragma mark - 立即绑定/我的授权码
- (IBAction)bindingAction:(id)sender
{
    
    ACImmediatelyBinding *vc = [[ACImmediatelyBinding alloc]init];
    //复用界面状态表达值  3:绑定刷卡器
    vc.state = 3;
    [self jumpViewController:self newViewController:vc PushAndPresent:YES];
    
    
/*
    MyNumberController *numberView = [[MyNumberController alloc] initWithType:([sender isMemberOfClass:[UIButton class]]? ImpowerType : ImpowerInfoType)];
    
    numberView.impowerNumber = ![[userInfoDic objectForKey:@"paycardid"] isEqualToString:@""]? [userInfoDic objectForKey:@"paycardid"] : nil;
    
    numberView.paycardIMEI = ![[userInfoDic objectForKey:@"paycardIMEI"] isEqualToString:@""]? [userInfoDic objectForKey:@"paycardIMEI"] : nil;
    
    [self.navigationController pushViewController:numberView animated:YES];
*/
}

#pragma mark - 购买授权码
- (IBAction)payAction:(id)sender
{
    
}

//判断信息是否正确
-(void)showErrorInfo:(NSString *)detail status:(NLHUDState)status
{
    [_hud hide:YES];
    _hud = [[NLProgressHUD alloc] initWithParentView:self.view];
    
    switch (status)
    {
        case NLHUDState_Error:
        {
            _hud.detailsLabelText = detail;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unCheckmark.png"]];
            _hud.mode = MBProgressHUDModeCustomView;
            [_hud show:YES];
            [_hud hide:YES afterDelay:2];
        }
            break;
            
        case NLHUDState_NoError:
        {
            _hud.labelText = detail;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.png"]];
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
    
    return ;
}

@end

















