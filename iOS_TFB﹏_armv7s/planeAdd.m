//
//  planeAdd.m
//  TongFubao
//
//  Created by  俊   on 14-7-22.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "planeAdd.h"

@interface planeAdd ()
{
    CGFloat IOS7HEIGHT;
    NLProgressHUD  * _hud;
}
@property (nonatomic,strong) UITableView    *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@end

@implementation planeAdd

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [NLUtils enableSliderViewController:NO];
    
    if ([TFData getTempData][PLANE_ADD_PEOPLE]) {
        
        /*手动增加乘机人刷新数据*/
        [self performSelector:@selector(addpeople) withObject:nil afterDelay:0.1];
        
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [NLUtils enableSliderViewController:YES];
    [super viewWillDisappear:animated];
}

/*乘机人接口*/
-(void)addpeople{
    
     NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:@"你好", @"shaddressid", @"飞鸡票", @"shaddress",nil];
    [_dataArr addObject:dic];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self mainView];
}

-(void)mainView{
    
    UIView *tempView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:tempView];
    
    self.title= @"添加乘机人";
    IOS7HEIGHT=IOS7_OR_LATER==YES?64:0;
    [self addRightButtonItemWithTitle:@"确定"];
    
    [self tableViewIsOn];
    /*获取数据的个数*/
     _dataArr = [NSMutableArray array];
    /*接口-读取默认地址*/
    [self performSelector:@selector(addpeople) withObject:nil afterDelay:0.1];
}

- (void)tableViewIsOn
{
    
    self.view.backgroundColor = SACOLOR(226,1.0);
    CGFloat ctrH = [NLUtils getCtrHeight];
    CGFloat tableHeight=IOS7_OR_LATER==YES?(ctrH-64):ctrH;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, IOS7HEIGHT, 320, tableHeight)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle= NO;
    _tableView.rowHeight= 60;
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"planeCell";
    planeaddpeoplecell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell = [[planeaddpeoplecell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    cell.listCellDelegate = self;
    cell.userInteractionEnabled= YES;
    UIButton *btn= [UIButton buttonWithType:UIButtonTypeCustom];
    btn= cell.BtnIson;
    [btn addTarget:self action:@selector(btnIsonAciton:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [cell addSubview:btn];
    return cell;
}

-(void)btnIsonAciton:(UIButton*)sender{
    
     [sender setBackgroundImage:[UIImage imageNamed:@"911.png"] forState:UIControlStateSelected];
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /*点击默认选中作为乘机人*/

}

/*确定添加乘机人*/
-(void)rightItemClick:(id)sender{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma other
//判断信息是否正确
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
            
        default:
            break;
    }
    return;
}

-(NSString *)checkInfo:(NSString *)str
{
    if (str == nil)
    {
        return @"未知";
    }
    else
    {
        return str;
    }
}

#pragma mark - keyboard hide event
-(void)oneFingerTwoTaps
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    UITextField *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    
    [firstResponder resignFirstResponder];
}

- (void) doPush
{
    [_hud hide:YES];
    [NLUtils popToLogonVCByHTTPError:self feedOrLeft:1];
}

@end
