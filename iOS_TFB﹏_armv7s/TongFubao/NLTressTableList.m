//
//  NLTressTableList.m
//  TongFubao
//
//  Created by  俊   on 14-9-5.
//  Copyright (c) 2014年 〝Cow﹏. All rights reserved.
//

#import "NLTressTableList.h"
#import "SIAlertView.h"

@implementation NLTressTableList

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style headInfos:(NSArray *)headInfos customTableType:(NLTressTableListType)customTableType flag:(BOOL)flag
{
    if (self = [super initWithFrame:frame style:style])
    {
        //生成选择城市
        listArr = headInfos;
        headViews = [NSMutableArray array];
        cirtArr= [NSMutableArray array];
        
        //生成列表头视图
        [self performSelector:NSSelectorFromString((flag? @"initTableViewHeadQianshou" : @"initTableViewHead"))];
        
        self.separatorColor = [UIColor clearColor];
        self.backgroundColor = RGBACOLOR(245, 245, 245, 1.0);
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.delegate = self;
        self.dataSource = self;
    }
    
    return self;
}

#pragma mark - 生成列表头视图
- (void)initTableViewHead
{
    for(int i = 0; i < listArr.count; i++)
    {
        HeadView *headView = [[HeadView alloc] init];
        headView.delegate = self;
        headView.section = i;
        headView.typeflag = YES;
        headView.backBtn.tag= i+1;
        headView.titleLabel.text = [listArr[i] objectForKey:@"wagemonth"];
        [headViews addObject:headView];
    }
}

-(void)initTableViewHeadQianshou
{
    for(int i = 0; i < listArr.count; i++)
    {
        HeadView *headView = [[HeadView alloc] init];
        headView.delegate = self;
        headView.section = i;
        headView.typeflag = YES;
        headView.backBtn.tag= i+1;
        headView.titleLabel.text = listArr[i];
        [headViews addObject:headView];
    }
}

#pragma mark - TableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_flagQian!=YES) {
        if (indexPath.row==0)
        {
            return 90;
        }
    }
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return headViews[section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return listArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    HeadView *headView = headViews[section];

    int num= _flagQian ? 0: 1;
    return headView.backBtn.selected?  [[listDic valueForKey:currentlist] count] + num : 0;
}

/*长按删除*/
-(void)longCell:(NLHistoricalAccountCell*)gesture
{
    SIAlertView *alert = [[SIAlertView alloc] initWithTitle:@"温馨提示"
                                                 andMessage:[NSString stringWithFormat:@"确定删除该地址？"]];
    [alert setTransitionStyle:SIAlertViewTransitionStyleSlideFromTop];
    [alert addButtonWithTitle:@"取消" type:SIAlertViewButtonTypeCancel handler:^(SIAlertView *alertView) {
    }];
      [alert addButtonWithTitle:@"确定" type:SIAlertViewButtonTypeDefault handler:^(SIAlertView *SIAlertView){
      }];
    [alert show];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    NLHistoricalAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil)
    {
        cell = [[NLHistoricalAccountCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
//    else{
//        
//        [cell removeFromSuperview];//防止数据重用
//        cell= [[NLHistoricalAccountCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
//        cell.backgroundView=nil;
//    }
    
    /*发放工资历史*/
    if ([indexPath row] == 0 &&_flagQian!=YES)
    {
        _bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 90)];
        _bgImageView.hidden= NO;
        _bgImageView.backgroundColor= [UIColor whiteColor];
        
        UILabel *_lableText= [[UILabel alloc]initWithFrame:CGRectMake(16, 15, 300, 15)];
        _lableText.text= [NSString stringWithFormat:@"总共%@名员工，发放总额%@元",[listArr[indexPath.section] objectForKey:@"wagestanum"],[listArr[indexPath.section] objectForKey:@"wagepaymoney"]];
        
        UIImageView *img= [[UIImageView alloc]initWithFrame:CGRectMake(10, 47, 300, 2)];
        img.image= [UIImage imageNamed:@"dashed_line.png"];
        
        UILabel *lable= [[UILabel alloc]initWithFrame:CGRectMake( 15, 65, 300, 17)];
        lable.text= [NSString stringWithFormat:@"手机号                 姓名           本月工资"];
        
        if (![[listArr[indexPath.section] objectForKey:@"wagestanum"] isEqualToString:@"0"]) {
       
            [cell addSubview:_bgImageView];
            [_bgImageView addSubview:_lableText];
            [_bgImageView addSubview:img];
            [_bgImageView addSubview:lable];
     
        }

        cell.selectionStyle=UITableViewCellSelectionStyleNone;
       
    }
    /*发放工资历史*/
    else if ([indexPath row] != 0&& _flagQian!=YES)
    {
        cell.myCardNumberLabel.text = [[[listDic valueForKey:currentlist]objectAtIndex:indexPath.row-1 ]valueForKey:@"mobile"];
        
        NSString *str= [[[listDic valueForKey:currentlist]objectAtIndex:indexPath.row-1 ]valueForKey:@"staname"];
        if ([str length]==0) {
            cell.myCardBankLabel.text =@"匿名";
        }else{
            cell.myCardBankLabel.text = [[[listDic valueForKey:currentlist]objectAtIndex:indexPath.row-1 ]valueForKey:@"staname"];
        }
        cell.listlongDelegate= self;
        cell.myCardNameLabel.text = [[[listDic valueForKey:currentlist]objectAtIndex:indexPath.row-1 ]valueForKey:@"wagemoney"];
    }
    if (_flagQian==YES) {
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.myCardBankLabel.hidden= YES;
        cell.myCardNumberLabel.frame= (CGRect){15,5,200,30};
        cell.myCardNumberLabel.text= [NSString stringWithFormat:@"应发工资%@元",[[[listDic valueForKey:currentlist]objectAtIndex:indexPath.row]valueForKey:@"wagemoney"]];
        
        NSString *strQianshou= [[[listDic valueForKey:currentlist]objectAtIndex:indexPath.row ]valueForKey:@"isqianshou"];
        NSString *isQType= [strQianshou isEqualToString:@"1"] ? @"已签收": @"未签收";
        cell.myCardNameLabel.text= isQType;
    }
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_NLTressTableListDelegate respondsToSelector:@selector(returnWithObject:)])
    {
        UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        [_NLTressTableListDelegate returnWithObject:cell.textLabel.text];
        
    }
}
#pragma mark - HeadViewDelegate
- (void)selectedWith:(HeadView *)view sender:(UIButton *)sender
{
    if (!listDic)
    {
        listDic = [NSMutableDictionary dictionary];
    }
    /*
    view.backBtn.selected = !view.backBtn.selected;
    if (view.backBtn.selected )
    {
        NSLog(@"view.backBtn.selected==yes yes yes");
        if (![listDic objectForKey:listArr[view.section]])
        {
            currentlist = listArr[view.section];
            
            if ([self.NLTressTableListDelegate respondsToSelector:@selector(loadCitiesWithFirstLetter:)])
            {
                [_NLTressTableListDelegate loadCitiesWithFirstLetter:currentlist];
            }
        }
    }else{
        NSLog(@"view.backBtn.selected==no no no");
    }
     */
    
    UIButton *btn= (UIButton*)sender;
    select.selected= !select.selected;
    btn.selected=YES;
    select =btn;
    
    //判断当前是否有缓存的数据
    if (btn.selected)
    {
        currentlist= _flagQian ? listArr[view.section]  : [listArr[view.section] objectForKey:@"wagemonth"];
        
        if ([self.NLTressTableListDelegate respondsToSelector:@selector(loadCitiesWithFirstLetter:)])
        {
            [_NLTressTableListDelegate loadCitiesWithFirstLetter:currentlist];
        }
    }
    [self reloadData];
    
    /*
     //只允许选中一个
     UIButton *btn= (UIButton*)sender;
     select.selected= !select.selected;
     btn.selected=YES;
     select =btn;
     
     //判断当前是否有缓存的数据
     if (btn.selected)
     {
     currentlist= _flagQian ? listArr[view.section]  : [listArr[view.section] objectForKey:@"wagemonth"];
     
     if ([self.NLTressTableListDelegate respondsToSelector:@selector(loadCitiesWithFirstLetter:)]&& [currentlist isEqualToString:view.titleLabel.text])
     {
     [_NLTressTableListDelegate loadCitiesWithFirstLetter:currentlist];
     }
     }
     [self reloadData];    
     */
}

#pragma mark - 添加数据
- (void)returnCities:(NSArray *)cities
{
    if (![listDic objectForKey:currentlist])
    {
        [listDic setObject:cities forKey:currentlist];
    }
    
    [self reloadData];
}

/*
 UITableViewCell *cell=nil;
 static NSString *reuse=@"cell";
 
 if (cell==nil) {
 cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
 }else{
 while ([cell.contentView.subviews lastObject] != nil) {
 
 [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
 }
 }
 
 NSString *CellIdentifier = [NSString stringWithFormat:@"cell%d",indexPath.row];
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 if (cell == nil) {
 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 }else {
 return cell;
 }
 
 NLHistoricalAccountCell *cell =nil;
 static NSString *reuse=@"cell";
 if (cell==nil) {
 cell=[[NLHistoricalAccountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
 }else{
 while ([cell.contentView.subviews lastObject] != nil) {
 [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];  //删除并进行重新分配
 }
 }
 */
@end
