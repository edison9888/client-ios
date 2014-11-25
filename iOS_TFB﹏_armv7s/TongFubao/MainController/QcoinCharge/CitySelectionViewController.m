//
//  CitySelectionViewController.m
//  TongFubao
//
//  Created by kin on 14-8-15.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "CitySelectionViewController.h"
#import "FlightData.h"
#import "PlayCustomActivityView.h"


@interface CitySelectionViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate, FlightDataDelegate>
@end

@implementation CitySelectionViewController

{
    NSMutableArray *_buttonArray;
    UISearchBar *_searchBar;
    NSMutableArray *_cellButtonArray;
    NSMutableArray *_cellArrayStype;
    BOOL CellStype;
    NSArray *_addArray;
    NSString *_fromString ;
    NSString *_toString ;
    FlightData *_flight;
    BOOL buttonSelection;
    PlayCustomActivityView *activityView;

    
}
@synthesize citySelectionTableView,FROMTO,HotCityArray,LetterSelectionArray,LetterSelectionSet,SortArray,allCity,LetterSelectionDictionary,numberArray,cityCodeDictionary,cityIdDictionary,fromSelectionCity,toSelectionCity,ButtonViewArray;

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
    
    notityTion = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    _buttonArray = [[NSMutableArray alloc]init];
    _cellButtonArray = [[NSMutableArray alloc]init];
    _cellArrayStype = [[NSMutableArray alloc ]init];
    // 网络请求下来的存数据
    self.LetterSelectionSet = [[NSMutableSet alloc]init];
    // 网络请求下来集合存在数组中
    self.LetterSelectionArray = [[NSMutableArray alloc]init];
    // 存字母数组
    self.SortArray = [[NSMutableArray alloc]init];
    // 字典装所有的字母地名
    self.LetterSelectionDictionary =  [[NSMutableDictionary alloc]init];
    // 城市code
    self.cityCodeDictionary = [[NSMutableDictionary alloc]init];
    // 城市id
    self.cityIdDictionary = [[NSMutableDictionary alloc]init];
    
    //生成选择城市
    self.allCity = [[NSArray alloc]initWithObjects:@"热门",@"🔍",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"W",@"X",@"Y",@"Z", nil];
    _addArray = [[NSArray alloc]initWithObjects:@"0",@"1",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"W",@"X",@"Y",@"Z", nil];
    self.numberArray = [[NSArray alloc]initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26", nil];
    
    // 网络请求类
    _flight = [[FlightData alloc]init];
    _flight.flightDataDelegate = self;
    [_flight CitytToFindTheNetworkRequest:@" " requestCityName:@" " buttonTag:0];
    // 导航
    [self navigationView];
    // 控件
    [self allViewControl];
    
}

#pragma mark --- 网络代理返回的数据
- (void)getDataWithArray:(NSArray *)array oldLogoString:(NSString *)newlogoString requestCityName:(NSString *)newCityName buttonTag:(NSInteger)newTag cityCodeArray:(NSArray *)newcityCodeArray cityIdArray:(NSArray *)newcityIdArray
{
    // 默认是热门
    if ([newlogoString  isEqual: @" "] && [newCityName isEqual: @" "] )
    {
        newlogoString = @"0";
    }
    // 搜索
    else if ([newlogoString isEqual:@" "] && [newCityName length] > 0 )
    {
        newlogoString = @"1";
        // 搜索每次不同字段替换
        NSDictionary *leterDictionary = [[NSDictionary alloc]initWithObjectsAndKeys:array,newlogoString, nil];
        [self.LetterSelectionDictionary addEntriesFromDictionary:leterDictionary];
    }
    // 集合字段将所有的字典加入大字典中
    if ([array count] > 0)
    {
        BOOL isCon = [self.LetterSelectionSet containsObject:newlogoString];
        [self.LetterSelectionSet addObject:newlogoString];
        if (isCon == NO)
        {
            // 存城市名
            NSDictionary *leterDictionary = [[NSDictionary alloc]initWithObjectsAndKeys:array,newlogoString, nil];
            [self.LetterSelectionDictionary addEntriesFromDictionary:leterDictionary];
            
            // 存城市编号
            NSDictionary * codeDictionary = [[NSDictionary alloc]initWithObjectsAndKeys:newcityCodeArray,newlogoString, nil];
            [self.cityCodeDictionary addEntriesFromDictionary:codeDictionary];
            
            // 存城市的id
            NSDictionary * cityIdDic = [[NSDictionary alloc]initWithObjectsAndKeys:newcityIdArray,newlogoString, nil];
            [self.cityIdDictionary addEntriesFromDictionary:cityIdDic];
        }
    }

    
    // 判断字典不为空
    if ([self.LetterSelectionDictionary count] != 0)
    {
        // 是否每次按button请求
        if (buttonSelection == YES)
        {
            NSLog(@"====newTag====%d",newTag);
            //_cellArrayStype装着按钮所有的状态，按钮的标识newTag，通过标识找到每一个按钮的状态
            NSString *boolString = [_cellArrayStype objectAtIndex:newTag];
            NSLog(@"====boolString====%@",boolString);
            BOOL cellBool = [boolString boolValue];
            cellBool = !cellBool;
            boolString= [NSString stringWithFormat:@"%d",cellBool];
            NSMutableArray *newArray = [_cellArrayStype mutableCopy];
            [newArray replaceObjectAtIndex:newTag withObject:[NSString stringWithFormat:@"%d",cellBool]];
            _cellArrayStype = newArray;
            // 将点击段中key返回一个数组（即段中的所有行）
            NSArray *selecTionArray = [self.LetterSelectionDictionary objectForKey:[_addArray objectAtIndex:newTag]];
            NSLog(@"====selecTionArray===%@",selecTionArray);
            NSLog(@"====cellBool===%d",cellBool);
            // 判断选中行
            if (cellBool)
            {
                NSMutableArray * array = [[NSMutableArray alloc] init];
                for (int i=0; i< [selecTionArray count] ; i++)
                {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:newTag];
                    [array addObject:indexPath];
                }
                    // 将行插入数组中
                    [self.citySelectionTableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
            }
        }
    }
    
    NSLog(@"=====self.LetterSelectionDictionary======%@",self.LetterSelectionDictionary);
    
    [activityView performSelector:@selector(endActivity) withObject:activityView afterDelay:0.7];
    [activityView removeFromSuperview];
    [self.citySelectionTableView reloadData];
    
}
-(void)navigationView
{
    [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
    self.title= @"城市选择";
//    [self addRightButtonItemWithTitle:@"确定"];

}
//// 右边导航
//-(void)rightItemClick:(id)sender
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}
// 回调
-(void)leftItemClick:(id)sender
{
        [self.delegate changVuleFrome:_fromString andTo:_toString];
        [self.navigationController popViewControllerAnimated:YES];
}

// 视图将要销毁的时候
-(void)viewWillDisappear:(BOOL)animated
{
    if (notityTion == NO)
    {
        // 移除通知
        REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_ApiAirticket);
    }
    [ButtonView pushStateButton];

}
-(void)allViewControl
{
    // 出发到达按钮
    for (int i = 0; i < 2; i++)
    {
        UIButton *fromButton =[UIButton buttonWithType:(UIButtonTypeCustom)];
        fromButton.frame = CGRectMake(0+160*i, 64, 160, 44);
        fromButton.tag = i;
        if (fromButton.tag == 0)
        {
            if (FROMTO == YES)
            {
                fromButton.backgroundColor = RGBACOLOR(19, 193, 245, 1);
                [fromButton setImage:[UIImage imageNamed:@"selected_plan@2x.png"] forState:(UIControlStateNormal)];
                [fromButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
            }
            else
            {
                fromButton.backgroundColor = RGBACOLOR(165, 238, 255, 1);
                [fromButton setTitleColor: RGBACOLOR(3, 198, 230, 1) forState:UIControlStateNormal];
                [fromButton setImage:[UIImage imageNamed:@"startplay@2x.png"] forState:(UIControlStateNormal)];

                
            }
            if (self.fromSelectionCity!= nil)
            {
                [fromButton setTitle:self.fromSelectionCity forState:(UIControlStateNormal)];
            }
            else
            {
                [fromButton setTitle:@"出发" forState:(UIControlStateNormal)];
            }

            [fromButton setImageEdgeInsets:(UIEdgeInsetsMake(10, 35, 10, 90))];
        }
        else if (fromButton.tag == 1)
        {
            if (FROMTO == YES)
            {
                [fromButton setImage:[UIImage imageNamed:@"plane2@2x.png"] forState:(UIControlStateNormal)];
                fromButton.backgroundColor = RGBACOLOR(165, 238, 255, 1);
                [fromButton setTitleColor:RGBACOLOR(3, 198, 230, 1) forState:(UIControlStateNormal)];
            }
            else
            {
                fromButton.backgroundColor = RGBACOLOR(19, 193, 245, 1);
                [fromButton setImage:[UIImage imageNamed:@"selected_plan2@2x.png"] forState:(UIControlStateNormal)];
                [fromButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];

            }
            if (self.toSelectionCity!= nil)
            {
                [fromButton setTitle:self.toSelectionCity forState:(UIControlStateNormal)];
            }
            else
            {
                [fromButton setTitle:@"到达" forState:(UIControlStateNormal)];
            }

            [fromButton setImageEdgeInsets:(UIEdgeInsetsMake(10, 35, 10, 90))];
        }
        [fromButton addTarget:self action:@selector(fromClik:) forControlEvents:(UIControlEventTouchUpInside)];
        [_buttonArray addObject:fromButton];
        [self.view addSubview:fromButton];
    }
    
    self.ButtonViewArray = [[NSMutableArray alloc]init];
    // cell头按钮
    for (int i = 0 ; i < [self.allCity count]; i++)
    {
        ButtonView *_cellButton = [[ButtonView alloc]initWithFrame:CGRectMake(0, 0, 320, 40) buttonTag:i buttonTitle:[self.allCity objectAtIndex:i]];
        [_cellButtonArray addObject:_cellButton];
        _cellButton.delegate = self;
        _cellButton.tag = i;
        [self.ButtonViewArray addObject:_cellButton];
        if (_cellButton.tag < 2 )
        {
            CellStype = YES;
        }
        else
        {
            CellStype = NO;
        }
        [_cellArrayStype addObject:[NSString stringWithFormat:@"%d",CellStype]];
    }
    NSLog(@"======_cellArrayStype=======%@",_cellArrayStype );
    
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"请输入城市名称";
    self.citySelectionTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,108, 320, self.view.frame.size.height-100) style:(UITableViewStyleGrouped)];
    self.citySelectionTableView.delegate = self;
    self.citySelectionTableView.dataSource = self;
    self.citySelectionTableView.tag = 10;
    self.citySelectionTableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.citySelectionTableView.tableHeaderView = _searchBar;
    [self.view addSubview:self.citySelectionTableView];
    
    activityView = [[PlayCustomActivityView alloc] initWithFrame:CGRectMake(0, 0, 130, 130)];
    activityView.center = self.view.center;
    [activityView setTipsText:@"正在加载数据..."];
    [activityView starActivity];
    [self.view addSubview:activityView];
    
}

// 出发到达事件
-(void)fromClik:(UIButton *)sender
{
    UIButton *button = (UIButton *)sender;
    if (button == [_buttonArray objectAtIndex:button.tag])
    {
        button.backgroundColor = RGBACOLOR(19, 193, 245, 1);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if (button.tag == 0) {
            [button setImage:[UIImage imageNamed:@"selected_plan@2x.png"] forState:(UIControlStateNormal)];
            FROMTO = YES;
        }
        else if (button.tag == 1)
        {
            [button setImage:[UIImage imageNamed:@"selected_plan2@2x.png"] forState:(UIControlStateNormal)];
            FROMTO = NO;
        }
    }
    for (int i = 0; i < 2; i++)
    {
        if (button != [_buttonArray objectAtIndex:i])
        {
            [[_buttonArray objectAtIndex:i] setTitleColor: RGBACOLOR(3, 198, 230, 1) forState:UIControlStateNormal];
            [[_buttonArray objectAtIndex:i] setBackgroundColor:  RGBACOLOR(165, 238, 255, 1)];
            if (button.tag == 0)
            {
                [[_buttonArray objectAtIndex:i] setImage:[UIImage imageNamed:@"plane2@2x.png"] forState:(UIControlStateNormal)];
            }
            else if (button.tag == 1)
            {
                [[_buttonArray objectAtIndex:i] setImage:[UIImage imageNamed:@"startplay@2x.png"] forState:(UIControlStateNormal)];
            }
        }
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.allCity count];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [_cellButtonArray objectAtIndex:section];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // 选的每个一个段的状态
    NSString * cellBool = [_cellArrayStype objectAtIndex:section];
    if ([cellBool boolValue] == NO)
    {
        return 0;
    }
    else
    {
        // 所选的第几段
        if (section == [[self.numberArray objectAtIndex:section] integerValue])
        {
            // 返回具体段的多少行
            return [[self.LetterSelectionDictionary objectForKey:[_addArray objectAtIndex:section]] count];
        }
        return 0;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    NSString *key = [_allCity objectAtIndex:section];
//    return key;
//}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString  *indenfault = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indenfault];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault    reuseIdentifier:indenfault];
    }
    
    UIView *backviewcell=[[UIView alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    backviewcell.backgroundColor=RGBACOLOR(165, 238, 255, 1);
    cell.selectedBackgroundView = backviewcell;

    
    NLProtocolData *cellData = [[self.LetterSelectionDictionary objectForKey:[_addArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    cell.textLabel.text  = cellData.value;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (FROMTO == YES)
    {
        // 城市的名称
        NLProtocolData *cellData = [[self.LetterSelectionDictionary objectForKey:[_addArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        _fromString = cellData.value;
//        [[NSUserDefaults standardUserDefaults] setObject:_fromString forKey:@"FROM"];
        
        // 城市的编码
        NLProtocolData *cityCodeData = [[self.cityCodeDictionary objectForKey:[_addArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        [[NSUserDefaults standardUserDefaults] setObject:cityCodeData.value forKey:@"cityCodeFrom"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        
        // 城市的id
        NLProtocolData *cityIdData = [[self.cityIdDictionary objectForKey:[_addArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        [[NSUserDefaults standardUserDefaults] setObject:cityIdData.value forKey:@"cityIdFrom"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        
        
        [[_buttonArray objectAtIndex: 0] setTitle:cellData.value forState:(UIControlStateNormal)] ;
        UIButton *button = [_buttonArray objectAtIndex:0];
        button.backgroundColor = RGBACOLOR(165, 238, 255, 1);
        [button setImageEdgeInsets:(UIEdgeInsetsMake(10, 35, 10, 90))];
        [button setImage:[UIImage imageNamed:@"startplay@2x.png"] forState:(UIControlStateNormal)];
        [button setTitleColor:RGBACOLOR(3, 198, 230, 1) forState:(UIControlStateNormal)];

        UIButton *button1 = [_buttonArray objectAtIndex:1];
        button1.backgroundColor = RGBACOLOR(19, 193, 245, 1);
        [button1 setImage:[UIImage imageNamed:@"selected_plan2@2x.png"] forState:(UIControlStateNormal)];
        [button1 setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        FROMTO = NO;
        
        
    }
    else if (FROMTO == NO)
    {
        // 城市的名称
        NLProtocolData *cellData = [[self.LetterSelectionDictionary objectForKey:[_addArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        _toString = cellData.value;
        
        //城市的编码
        NLProtocolData *cityCodeData = [[self.cityCodeDictionary objectForKey:[_addArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        [[NSUserDefaults standardUserDefaults]setObject:cityCodeData.value forKey:@"cityCodeTo"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        // 城市的id
        NLProtocolData *cityIdData = [[self.cityIdDictionary objectForKey:[_addArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        [[NSUserDefaults standardUserDefaults] setObject:cityIdData.value forKey:@"cityIdTo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"====cityIdData=11===%@",cityIdData.value);
        
        [[_buttonArray objectAtIndex: 1] setTitle:cellData.value forState:(UIControlStateNormal)] ;
        UIButton *button = [_buttonArray objectAtIndex:0];
        button.backgroundColor = RGBACOLOR(19, 193, 245, 1);
        [button setImageEdgeInsets:(UIEdgeInsetsMake(10, 35, 10, 90))];
        [button setImage:[UIImage imageNamed:@"selected_plan@2x.png"] forState:(UIControlStateNormal)];
        [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];

        UIButton *button1 = [_buttonArray objectAtIndex:1];
        button1.backgroundColor = RGBACOLOR(165, 238, 255, 1);
        [button1 setImage:[UIImage imageNamed:@"plane2@2x.png"] forState:(UIControlStateNormal)];
        [button1 setTitleColor:RGBACOLOR(3, 198, 230, 1) forState:(UIControlStateNormal)];
        FROMTO = YES;
        
    }
    if ([_fromString length] > 0 && [_toString length] > 0)
    {
        [self.delegate changVuleFrome:_fromString andTo:_toString];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark --  搜索
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    buttonSelection = YES;
    ButtonView * btView0 = [self.ButtonViewArray objectAtIndex:0];
    [btView0 ChangingIndexStateButton:btView0._cellButton];

    activityView = [[PlayCustomActivityView alloc] initWithFrame:CGRectMake(0, 0, 130, 130)];
    activityView.center = self.view.center;
    [activityView setTipsText:@"正在加载数据..."];
    [activityView starActivity];
    [self.view addSubview:activityView];
    // 网络请求
    [_flight CitytToFindTheNetworkRequest:@" " requestCityName:_searchBar.text buttonTag:1];
    [searchBar resignFirstResponder];
    
    ButtonView * btView = [self.ButtonViewArray objectAtIndex:1];
    [btView ChangingStateButton];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"=========searchBarTextDidEndEditingsearchBarTextDidEndEditing===");
    ButtonView * btView = [self.ButtonViewArray objectAtIndex:1];
    [btView ChangingIndexStateButton:btView._cellButton];
}

#pragma mark --   cell按钮事件
-(void)changeVuleCellSetype:(UIButton *)sender
{
    buttonSelection = YES;
    UIButton *senderButton = (UIButton*)sender;
    NSLog(@"=======tag========%d",senderButton.tag);

    if ([self.LetterSelectionDictionary objectForKey:[_addArray objectAtIndex:senderButton.tag]] == nil)
    {

    if (senderButton.tag != 1)
    {
        activityView = [[PlayCustomActivityView alloc] initWithFrame:CGRectMake(0, 0, 130, 130)];
        activityView.center = self.view.center;
        [activityView setTipsText:@"正在加载数据..."];
        [activityView starActivity];
        [self.view addSubview:activityView];

        // 网络请求类
        [_flight CitytToFindTheNetworkRequest:senderButton.tag == 0 ? @" " :[_addArray objectAtIndex:senderButton.tag] requestCityName:@" " buttonTag:senderButton.tag];
    }
    // 判断下标为1时请求网络
    else if (senderButton.tag == 1 && [_searchBar.text length] > 0)
    {
        [_flight CitytToFindTheNetworkRequest: @" " requestCityName:_searchBar.text buttonTag:1];
    }
    [_searchBar resignFirstResponder];
    }
    // 不用再次请求网络直接拿缓存数据
    else
    {
        
        // 判断字典不为空
        if ([self.LetterSelectionDictionary count] != 0)
        {
            // 是否每次按button请求
            if (buttonSelection == YES)
            {
                NSLog(@"====newTag====%d",senderButton.tag);
                //_cellArrayStype装着按钮所有的状态，按钮的标识newTag，通过标识找到每一个按钮的状态
                NSString *boolString = [_cellArrayStype objectAtIndex:senderButton.tag];
                NSLog(@"====boolString====%@",boolString);
                BOOL cellBool = [boolString boolValue];
                cellBool = !cellBool;
                boolString= [NSString stringWithFormat:@"%d",cellBool];
                NSMutableArray *newArray = [_cellArrayStype mutableCopy];
                [newArray replaceObjectAtIndex:senderButton.tag withObject:[NSString stringWithFormat:@"%d",cellBool]];
                _cellArrayStype = newArray;
                // 将点击段中key返回一个数组（即段中的所有行）
                NSArray *selecTionArray = [self.LetterSelectionDictionary objectForKey:[_addArray objectAtIndex:senderButton.tag]];
                NSLog(@"====selecTionArray===%@",selecTionArray);
                NSLog(@"====cellBool===%d",cellBool);
                // 判断选中行
                if (cellBool)
                {
                    NSMutableArray * array = [[NSMutableArray alloc] init];
                    for (int i=0; i< [selecTionArray count] ; i++)
                    {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:senderButton.tag];
                        [array addObject:indexPath];
                    }
                    // 将行插入数组中
                    [self.citySelectionTableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
                }
            }
        }
        NSLog(@"=====self.LetterSelectionDictionary======%@",self.LetterSelectionDictionary);
        [self.citySelectionTableView reloadData];
    }
}
#pragma mark --  按钮没有选中时将段的cell全部收起
-(void)shouCell:(UIButton *)senderCell
{
    UIButton *sendButton = (UIButton*)senderCell;
    NSString *boolString = [_cellArrayStype objectAtIndex:sendButton.tag];
    BOOL cellBool = [boolString boolValue];
    cellBool = !cellBool;
    boolString= [NSString stringWithFormat:@"%d",cellBool];
    NSMutableArray *newArray = [_cellArrayStype mutableCopy];
    [newArray replaceObjectAtIndex:sendButton.tag withObject:[NSString stringWithFormat:@"%d",cellBool]];
    _cellArrayStype = newArray;
    NSArray *selecTionArray = [self.LetterSelectionDictionary objectForKey:[_addArray objectAtIndex:sendButton.tag]];
    
    if (!cellBool)
    {
        NSMutableArray  *indexArray = [[NSMutableArray alloc]init];
        for (int i = 0; i < [selecTionArray count]; i++)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:sendButton.tag];
            [indexArray addObject:indexPath];
        }
        [self.citySelectionTableView deleteRowsAtIndexPaths:indexArray withRowAnimation:(UITableViewRowAnimationNone)];
    }
    [self.citySelectionTableView reloadData];
    
}
// 字母选择
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.allCity;
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [_searchBar resignFirstResponder];

}


@end










