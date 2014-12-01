//
//  TransferAccountsController.m
//  TongFubao
//
//  Created by Delpan on 14-9-23.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "TransferAccountsController.h"

@interface TransferAccountsController ()
{
    NLProgressHUD  *_hud;
    //当前高度
    NSInteger currentHeight;
    //切换按钮底图
    UIImageView *switchBasicView;
    //转账类型按钮
    UIButton *typeBtn[2];
    //历史卡列表
    UITableView *table;
    //信息数据字典
    NSMutableDictionary *infoDic;
    //转账参数
    NSString *paytype[2];
    //当前类型
    NSInteger currentRow;
    //提示视图
    UIView *tipsBasicView;
    //信息数据
    NSMutableArray *infos;
}

@end

@implementation TransferAccountsController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"renovateData" object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    
    ViewControllerProperty;
    
#endif
    
    //获取当前屏幕size
    currentHeight = iphoneSize;
    
    //标题
    self.title = @"转账汇款";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"历史记录"
                                                                      style:UIBarButtonItemStyleBordered
                                                                     target:self
                                                                     action:@selector(historyRecord)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    
    [self addBackButtonItemWithImage:imageName(@"navigationLeftBtnBack2@2x", @"png")];
    
    //初始化数据
    [self initData];
    //初始化视图
    [self initView];
    //刷新列表
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(renovateData) name:@"renovateData" object:nil];
}

#pragma mark - 刷新列表
- (void)renovateData
{
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    
    //超级账户列表
    [LoadDataWithASI loadDataWithMsgbody:@{ @"paytype" : @"suptfmg,tfmg" } apiName:@"ApiPayinfo" apiNameFunc:@"readshoucardList" rolePath:@"//operation_response/msgbody/msgchild" type:PublicList completionBlock:^(id data, NSError *error) {
        
        if (data)
        {
            //保存当前数据
            infos = data;
            table.hidden = NO;
            [table reloadData];
        }
        
        [_hud hide:YES];
    }];
}

#pragma mark - 初始化数据
- (void)initData
{
    //当前类型
    currentRow = 0;
    
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    
    //账户列表
    [LoadDataWithASI loadDataWithMsgbody:@{ @"paytype" : @"suptfmg,tfmg" } apiName:@"ApiPayinfo" apiNameFunc:@"readshoucardList" rolePath:@"//operation_response/msgbody/msgchild" type:PublicList completionBlock:^(id data, NSError *error) {
        
        if (data)
        {
            //保存当前数据
            infos = data;
            
            table.hidden = NO;
            [table reloadData];
        }
        
        [_hud hide:YES];
    }];
}

#pragma mark - 初始化视图
- (void)initView
{
    //切换按钮底图
    switchBasicView = [UIImageView viewWithFrame:CGRectMake(0, 0, SelfWidth, 60) image:imageName(@"TransferRemittanceTopLeft@2x", @"png")];
    [self.view addSubview:switchBasicView];
    
    //转账类型按钮
    for (int i = 0; i < 2; i++)
    {
        typeBtn[i] = [UIButton buttonWithFrame:CGRectMake(SelfWidth / 2 * i, 0, SelfWidth / 2, 60)
                                 unSelectImage:nil
                                   selectImage:nil
                                           tag:3501 + i
                                    titleColor:[UIColor blackColor]
                                         title:(i == 0? @"超级转账" : @"普通转账")];
        typeBtn[i].selected = i == 0? YES : NO;
        typeBtn[i].titleLabel.font = [UIFont systemFontOfSize:15.0];
        [typeBtn[i] addTarget:self action:@selector(typeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [switchBasicView addSubview:typeBtn[i]];
    }
    
    //发起转账按钮
    UIButton *initiateBtn = [UIButton buttonWithFrame:CGRectMake(10, 60, SelfWidth - 20, 40)
                                        unSelectImage:imageName(@"yellow_button@2x", @"png")
                                          selectImage:nil
                                                  tag:100000
                                           titleColor:[UIColor whiteColor]
                                                title:@"转给新账户"];
    initiateBtn.layer.cornerRadius = 5.0;
    initiateBtn.layer.masksToBounds = YES;
    [initiateBtn addTarget:self action:@selector(transferAccountsAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:initiateBtn];
    
#pragma mark 提示视图
    //提示底视图
    tipsBasicView = [UIView viewWithFrame:CGRectMake(0, 100, SelfWidth, currentHeight - 164)];
    tipsBasicView.backgroundColor = [UIColor whiteColor];
    tipsBasicView.opaque = YES;
    [self.view addSubview:tipsBasicView];
    
    //分隔线
    UIImageView *lineView = [UIImageView viewWithFrame:CGRectMake(10, 20, SelfWidth - 20, 1) image:imageName(@"line1@2x", @"png")];
    [tipsBasicView addSubview:lineView];
    
    //提示视图
    UIImageView *tipsView = [UIImageView viewWithFrame:CGRectMake(75, 60, 170, 160) image:imageName(@"转账汇款非功能界面-02", @"png")];
    [tipsBasicView addSubview:tipsView];
    
    //提示文字
    UILabel *tipsLabel_1 = [UILabel labelWithFrame:CGRectMake(80, 240, 160, 20)
                                 backgroundColor:[UIColor clearColor]
                                       textColor:[UIColor grayColor]
                                            text:@"您还没转过账哦，"
                                            font:[UIFont systemFontOfSize:18.0]];
    [tipsBasicView addSubview:tipsLabel_1];
    
    UILabel *tipsLabel_2 = [UILabel labelWithFrame:CGRectMake(80, 280, 200, 25)
                                   backgroundColor:[UIColor clearColor]
                                         textColor:RGBACOLOR(222, 148, 12, 1.0)
                                              text:@"赶快体验一下吧！"
                                              font:[UIFont systemFontOfSize:22.0]];
    [tipsBasicView addSubview:tipsLabel_2];
    
    //历史卡列表
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, SelfWidth, currentHeight - 164) style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    table.backgroundView = nil;
    table.hidden = YES;
    table.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:table];
}

#pragma mark - 转账历史
- (void)historyRecord
{
    NLCashArriveHistoryViewController *vc = [[NLCashArriveHistoryViewController alloc] initWithNibName:@"NLCashArriveHistoryViewController" bundle:nil];
    vc.myHistoryRecordType = typeBtn[0].selected? NLHistoryRecordType_SupTransferMoney : NLHistoryRecordType_TransferMoney;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 转账类型切换
- (void)typeBtnAction:(UIButton *)senser
{
    if (!senser.selected)
    {
        typeBtn[0].selected = !typeBtn[0].selected;
        typeBtn[1].selected = !typeBtn[1].selected;
        
        switchBasicView.image = typeBtn[0].selected? imageName(@"TransferRemittanceTopLeft@2x", @"png") : imageName(@"TransferRemittanceTopRight@2x", @"png");
        
        //当前类型
        currentRow = senser.tag - 3501;
    }
}

#pragma mark - 发起转账触发
- (void)transferAccountsAction:(UIButton *)sender
{
    TransferInfoController *infoView = [[TransferInfoController alloc] initWithNewCard:YES];
    infoView.title = currentRow == 0? @"超级转账" : @"普通转账";
    [self.navigationController pushViewController:infoView animated:YES];
}

#pragma mark - TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return infos? infos.count : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    
    BankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell)
    {
        cell = [[BankCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    //用户信息
    NSString *shoucardno = [[infos objectAtIndex:indexPath.row] objectForKey:@"shoucardno"];
    shoucardno = shoucardno.length > 4? [shoucardno substringFromIndex:(shoucardno.length - 4)] : shoucardno;
    
    //图标
    [cell.logoView imageWitwURL:[[infos objectAtIndex:indexPath.row] objectForKey:@"bkcardbanklogo"]];
    //所属银行
    cell.bankName.text = [[infos objectAtIndex:indexPath.row] objectForKey:@"shoucardbank"];
    //卡主名
    cell.masterName.text = [[infos objectAtIndex:indexPath.row] objectForKey:@"shoucardman"];
    //卡号
    cell.cardNumber.text = [NSString stringWithFormat:@"尾号:%@", shoucardno];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [[infos objectAtIndex:indexPath.row] objectForKey:@"shoucardno"], @"shoucardno",
                                    [[infos objectAtIndex:indexPath.row] objectForKey:@"shoucardman"], @"shoucardman",
                                    [[infos objectAtIndex:indexPath.row] objectForKey:@"shoucardbank"], @"shoucardbank",
                                    [[infos objectAtIndex:indexPath.row] objectForKey:@"bankid"], @"bankid", nil];
    
    TransferInfoController *infoView = [[TransferInfoController alloc] initWithNewCard:NO];
    infoView.title = currentRow == 0? @"超级转账" : @"普通转账";
    infoView.dataDic = dataDic;
    [self.navigationController pushViewController:infoView animated:YES];
}

#pragma mark - 删除信息
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [table setEditing:editing animated:animated];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self showErrorInfo:@"请稍候" status:NLHUDState_None];
        
        //删除数据
        NSDictionary *dic = @{ @"shoucardno" : [[infos objectAtIndex:indexPath.row] objectForKey:@"shoucardno"],
                               @"paytype" : @"suptfmg,tfmg" };
        
        //删除请求
        [LoadDataWithASI loadDataWithMsgbody:dic apiName:@"ApiPayinfo" apiNameFunc:@"delshoucardList" rolePath:@"//operation_response/msgbody" type:PublicCommon completionBlock:^(id data, NSError *error) {
            
            [_hud hide:YES];
        }];
        
        //移除数据
        [infos removeObjectAtIndex:indexPath.row];
        [table deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationFade];
        
        if (infos.count == 0)
        {
            infos = nil;
            
            table.hidden = YES;
        }
    }
}

#pragma showErrorInfo
- (void)showError:(NSString *)detail
{
    if (detail)
    {
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
    else
    {
        [self showErrorInfo:@"服务器繁忙，请稍候再试" status:NLHUDState_Error];
    }
}

//判断信息是否正确
-(void)showErrorInfo:(NSString*)detail status:(NLHUDState)status
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end






















