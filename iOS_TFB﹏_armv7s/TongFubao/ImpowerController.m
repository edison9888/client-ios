//
//  ImpowerController.m
//  TongFubao
//
//  Created by Delpan on 14-10-22.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "ImpowerController.h"
#import "MyNumberController.h"

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
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //获取当前屏幕size
    currentHeight = iphoneSize;
    
    self.title = @"购买授权码";
    
    //初始化视图
    [self initView];
    
    //读取当前用户数据
    [self initData];
}

#pragma mark - 读取当前用记数据
- (void)initData
{
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    
    //参数
    NSDictionary *dic = @{ @"paycardtype" : @"2" };
    
    [LoadDataWithASI loadDataWithMsgbody:dic apiName:@"ApiAuthorInfo" apiNameFunc:@"GetpaycardList" rolePath:@"//operation_response/msgbody/msgchild" type:PublicCommon completionBlock:^(id data, NSError *error) {
        
        [_hud hide:YES];
        
        if (data)
        {
            userInfoDic = data;
            
            //当前是否有授权码
            if (![[userInfoDic objectForKey:@"paycardid"] isEqualToString:@""])
            {
                //我的授权码
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"我的授权码"
                                                                                          style:UIBarButtonItemStyleBordered
                                                                                         target:self
                                                                                         action:@selector(bindingAction:)];
            }
        }
    }];
}

#pragma mark - 初始化视图
- (void)initView
{
    //返回按扭
    [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
    
    //SrcollView内容大小
    self.basicView.contentSize = CGSizeMake(SelfWidth, currentHeight);
}

#pragma mark - 立即绑定/我的授权码
- (IBAction)bindingAction:(id)sender
{
    MyNumberController *numberView = [[MyNumberController alloc] initWithType:([sender isMemberOfClass:[UIButton class]]? ImpowerType : ImpowerInfoType)];
    
    numberView.impowerNumber = ![[userInfoDic objectForKey:@"paycardid"] isEqualToString:@""]? [userInfoDic objectForKey:@"paycardid"] : nil;
    
    numberView.paycardIMEI = ![[userInfoDic objectForKey:@"paycardIMEI"] isEqualToString:@""]? [userInfoDic objectForKey:@"paycardIMEI"] : nil;
    
    [self.navigationController pushViewController:numberView animated:YES];
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

















