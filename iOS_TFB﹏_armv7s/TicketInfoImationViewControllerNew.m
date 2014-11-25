//
//  TicketInfoImationViewControllerNew.m
//  TongFubao
//
//  Created by kin on 14-9-10.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "TicketInfoImationViewControllerNew.h"
#import "AddPassengersViewController.h"
#import "AddContactPersonViewController.h"
#import "TicketBillsViewController.h"
#import "PlayFromToView.h"
#import "PersonView.h"
#import "PersonIphoneView.h"
@interface TicketInfoImationViewControllerNew ()<AddPassengersViewdelegate,PersonViewdelegate,AddContactPersondelegate,PersonIphoneViewdelegate>

@end

@implementation TicketInfoImationViewControllerNew

{
    UIImageView *_boardingImage;
    UIImageView *_contactImage;
    PlayFromToView *_desperAriView;
    UIButton *_sureButton;
    UIScrollView *_ticketInfoScrollView;
    PersonView *_obView ;
    UIView *_contactionIphone;
    
}

@synthesize priceTicket,msgchildTicket,standardPriceTicket,oilFeeTicket,taxTicket,standardPriceChirldTicket,oilFeeChirldTicket,taxForTicket,standardPricebadyTicket,oilFeeForBabyTicket,taxForBabyTicket,quantityTicket,rerNoteTicket,endNoteTicket,refNoteTicket,classTicket,TicketArrivePlay,TicketDepartPlay,TicketDeTimeFrom,TicketArriveTimeTo,TicketDepartCode,TicketArriveCode,TicketInfoDepartCtity,TicketInfoArriveCity,playName,TicketFlihtCity,infoArray,ticketPersonArray,AddContactPersonAdrray,AllPriceArray;


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
    
    //    NSLog(@"==实际价格==%@===航班===%@===原始价==%@====燃油附加费===%@====成人税===%@======儿童标准价====%@======儿童油费用===%@==儿童税==%@=====婴儿标准价====%@==婴儿油费用==%@======婴儿税====%@====%@=====剩余票量===%@==00==%@==11=%@===舱位等级===%@==起程城市机场=%@==到达城市机场==%@==起飞时间==%@====到达时间==%@===起程城市code===%@====到达城市code===%@====起飞城市===%@==到达城市==%@====航空名=====%@=====航班号===%@===",priceTicket,msgchildTicket,standardPriceTicket,oilFeeTicket,taxTicket,standardPriceChirldTicket,oilFeeChirldTicket,taxForTicket,standardPricebadyTicket,oilFeeForBabyTicket,taxForBabyTicket,quantityTicket,rerNoteTicket,endNoteTicket,refNoteTicket,classTicket,TicketArrivePlay,TicketDepartPlay,TicketDeTimeFrom,TicketArriveTimeTo,TicketDepartCode,TicketArriveCode,TicketInfoDepartCtity,TicketInfoArriveCity,playName,TicketFlihtCity);
    
    NSString *dateFrom = [self.TicketDeTimeFrom substringWithRange:NSMakeRange(0, 9)];
    NSString *timeFrom = [self.TicketDeTimeFrom substringWithRange:NSMakeRange(11, 5)];
    NSString *dateTo = [self.self.TicketArriveTimeTo substringWithRange:NSMakeRange(0, 9)];
    NSString *timeTo = [self.self.TicketArriveTimeTo substringWithRange:NSMakeRange(11, 5)];
    
    
    //  封装数据
    self.infoArray = [[NSArray alloc]initWithObjects:dateFrom,dateTo,timeFrom,timeTo,TicketArrivePlay,TicketInfoDepartCtity,TicketInfoArriveCity,TicketDepartPlay,playName,TicketFlihtCity,classTicket,[NSString stringWithFormat:@"￥%@", priceTicket],[NSString stringWithFormat:@"￥%@", taxTicket], [NSString stringWithFormat:@"￥%@",oilFeeTicket],nil];
    //  总价格
    self.AllPriceArray = [[NSArray alloc]initWithObjects:self.priceTicket,self.oilFeeTicket,self.taxTicket,self.standardPriceChirldTicket,self.oilFeeChirldTicket,self.taxForTicket,self.standardPricebadyTicket,self.oilFeeForBabyTicket,self.taxForBabyTicket,nil];
    NSLog(@"=====self.AllPriceArray=====%@",self.AllPriceArray);
    
    
    // 登机人
    self.ticketPersonArray = [[NSMutableArray alloc]init];
    self.AddContactPersonAdrray = [[NSMutableArray alloc]init];
    
    // 导航
    [self navigationView];
    [self allControllerView];
}
-(void)navigationView
{
    [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
    self.title= @"机票订单";
}
#pragma mark =======添加乘机人
-(void)addPersonIphoneArray:(NSMutableArray *)newIphoneArray{
    
    
    NSMutableArray *iphonePerson =[[NSMutableArray alloc]init];
    for (int i = 0; i < [newIphoneArray count]; i++)
    {
        if ([[[newIphoneArray objectAtIndex:i] objectAtIndex:5] isEqualToString:@"b"])
        {
            [iphonePerson addObject:[newIphoneArray objectAtIndex:i]];
        }
    }
    self.ticketPersonArray = iphonePerson;
    NSLog(@"=========ticketPersonArray=======%@",self.ticketPersonArray);
    
    _boardingImage.frame =CGRectMake(10, 25+_desperAriView.frame.origin.y+_desperAriView.frame.size.height, 300, 90+40*[self.ticketPersonArray count]);
    _contactImage.frame =CGRectMake(10, 15+_boardingImage.frame.origin.y+_boardingImage.frame.size.height, 300, 90+40*[self.AddContactPersonAdrray count]);
    _contactionIphone.frame = CGRectMake(10, 15+_boardingImage.frame.origin.y+_boardingImage.frame.size.height, 300, 50);
    _sureButton.frame = CGRectMake(10, _contactImage.frame.origin.y+_contactImage.frame.size.height + 20, 300, 45);
    [_ticketInfoScrollView setContentSize:CGSizeMake(self.view.frame.size.width, _sureButton.frame.origin.y+_sureButton.frame.size.height +20 )];
    [self chanageView];
    
}

#pragma mark =======添加联系人
-(void)AddContactPersonArray:(NSMutableArray *)newAddContactPerson;
{
    
    NSMutableArray *ContactPerson =[[NSMutableArray alloc]init];
    for (int i = 0; i < [newAddContactPerson count]; i++)
    {
        if ([[[newAddContactPerson objectAtIndex:i] objectAtIndex:3] isEqualToString:@"b"])
        {
            [ContactPerson addObject:[newAddContactPerson objectAtIndex:i]];
        }
    }
    self.AddContactPersonAdrray = ContactPerson;
    NSLog(@"=========ticketPersonArray======%@",self.ticketPersonArray);
    _boardingImage.frame =CGRectMake(10, 25+_desperAriView.frame.origin.y+_desperAriView.frame.size.height, 300, 90+40*[self.ticketPersonArray count]);
    _contactImage.frame =CGRectMake(10, 15+_boardingImage.frame.origin.y+_boardingImage.frame.size.height, 300, 90+40*[self.AddContactPersonAdrray count]);
    _contactionIphone.frame = CGRectMake(10, 15+_boardingImage.frame.origin.y+_boardingImage.frame.size.height, 300, 50);
    _sureButton.frame = CGRectMake(10, _contactImage.frame.origin.y+_contactImage.frame.size.height + 20, 300, 45);
    [_ticketInfoScrollView setContentSize:CGSizeMake(self.view.frame.size.width, _sureButton.frame.origin.y+_sureButton.frame.size.height +20 )];
    [self ContactPersonView];
    
}
// 添加乘机人
-(void)chanageView
{
    for (PersonView *views in [_boardingImage subviews])
    {
        if ([views isKindOfClass:[UIView class]])
        {
            [views removeFromSuperview];
        }
    }
    
    for (NSInteger i = 0; i <  [self.ticketPersonArray count]; i++)
    {
        _obView = [[PersonView alloc]initWithFrame:CGRectMake(0, 60+43*i, 300, 40) nameLabel:[[self.ticketPersonArray objectAtIndex:i] objectAtIndex:0 ] iphoneLabel:[[self.ticketPersonArray objectAtIndex:i] objectAtIndex:2] buttonTag:i];
        _obView.delegate = self;
        [_boardingImage addSubview:_obView];
    }
}
// 添加联系人
-(void)ContactPersonView
{
    for (PersonView *views in [_contactImage subviews])
    {
        if ([views isKindOfClass:[UIView class]])
        {
            [views removeFromSuperview];
        }
    }
    
    for (NSInteger i = 0; i <  [self.AddContactPersonAdrray count]; i++)
    {
        PersonIphoneView* PersonIphone = [[PersonIphoneView alloc]initWithFrame:CGRectMake(0, 60+43*i, 300, 40) nameLabel:[[self.AddContactPersonAdrray objectAtIndex:i] objectAtIndex:1 ] iphoneLabel:[[self.AddContactPersonAdrray objectAtIndex:i] objectAtIndex:2] buttonTag:i];
        PersonIphone.delegate = self;
        [_contactImage addSubview:PersonIphone];
    }
}
// 删除登机人
-(void)deletSelectionButtonTag:(NSInteger)newTage;
{
    [self.ticketPersonArray removeObjectAtIndex:newTage];
    _boardingImage.frame =CGRectMake(10, 25+_desperAriView.frame.origin.y+_desperAriView.frame.size.height, 300, 90+40*[self.ticketPersonArray count]);
    _contactImage.frame =CGRectMake(10, 15+_boardingImage.frame.origin.y+_boardingImage.frame.size.height, 300, 90+40*[self.AddContactPersonAdrray count]);
    _sureButton.frame = CGRectMake(10, _contactImage.frame.origin.y+_contactImage.frame.size.height + 20, 300, 45);
    _contactionIphone.frame = CGRectMake(10, 15+_boardingImage.frame.origin.y+_boardingImage.frame.size.height, 300, 50);
    [_ticketInfoScrollView setContentSize:CGSizeMake(self.view.frame.size.width, _sureButton.frame.origin.y+_sureButton.frame.size.height +20 )];
    [self chanageView];
}
// 删除联系人
-(void)deletSelectionPersonIphoneButtonTag:(NSInteger)newTage
{
    [self.AddContactPersonAdrray removeObjectAtIndex:newTage];
    _boardingImage.frame =CGRectMake(10, 25+_desperAriView.frame.origin.y+_desperAriView.frame.size.height, 300, 90+40*[self.ticketPersonArray count]);
    _contactImage.frame =CGRectMake(10, 15+_boardingImage.frame.origin.y+_boardingImage.frame.size.height, 300, 90+40*[self.AddContactPersonAdrray count]);
    _sureButton.frame = CGRectMake(10, _contactImage.frame.origin.y+_contactImage.frame.size.height + 20, 300, 45);
    _contactionIphone.frame = CGRectMake(10, 15+_boardingImage.frame.origin.y+_boardingImage.frame.size.height, 300, 50);
    [_ticketInfoScrollView setContentSize:CGSizeMake(self.view.frame.size.width, _sureButton.frame.origin.y+_sureButton.frame.size.height +20 )];
    [self ContactPersonView];
    
}

-(void)allControllerView
{
    
    _ticketInfoScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    _ticketInfoScrollView.backgroundColor = RGBACOLOR(230, 230, 230, 1);
    [self.view addSubview:_ticketInfoScrollView];
    
    // 单返模块
    _desperAriView = [[PlayFromToView alloc]initWithFrame:CGRectMake(0, 0, 320, 260) infoArray:self.infoArray];
    [_ticketInfoScrollView addSubview:_desperAriView];
    
    // 登机人
    _boardingImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 25+_desperAriView.frame.origin.y+_desperAriView.frame.size.height, 300, 90)];
    _boardingImage.userInteractionEnabled = YES;
    _boardingImage.image = [[UIImage imageNamed:@"BG2green@2x.png"] resizableImageWithCapInsets:(UIEdgeInsetsMake(12, 0, 12, 0)) resizingMode:UIImageResizingModeStretch];
    [_ticketInfoScrollView addSubview:_boardingImage];
    
    for (int i = 0; i < 2; i++)
    {
        UILabel *boardLabel = [[UILabel alloc]init];
        boardLabel.tag = i;
        boardLabel.backgroundColor = [UIColor clearColor];
        boardLabel.textColor = [UIColor whiteColor];
        if (boardLabel.tag == 0)
        {
            boardLabel.text = @"登机人";
            boardLabel.frame = CGRectMake(20, 40+_desperAriView.frame.origin.y+_desperAriView.frame.size.height, 100, 20);
        }
        else if (boardLabel.tag == 1)
        {
            boardLabel.frame = CGRectMake(10, 75+_desperAriView.frame.origin.y+_desperAriView.frame.size.height, 300, 1);
            boardLabel.backgroundColor = [UIColor whiteColor];
        }
        //        else if (boardLabel.tag == 2)
        //        {
        //            boardLabel.text = @"请添加登机人";
        //            boardLabel.frame = CGRectMake(10, 85+_desperAriView.frame.origin.y+_desperAriView.frame.size.height, 200, 20);
        //        }
        [_ticketInfoScrollView addSubview:boardLabel];
    }
    
    UIButton *boardButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    boardButton.frame = CGRectMake(180,  40+_desperAriView.frame.origin.y+_desperAriView.frame.size.height, 120, 30);
    [boardButton setTitle:@"添加登机人" forState:(UIControlStateNormal)];
    [boardButton addTarget:self action:@selector(addPerson) forControlEvents:(UIControlEventTouchUpInside)];
    [boardButton setBackgroundImage:[UIImage imageNamed:@"greenbutton@2x.png"] forState:(UIControlStateNormal)];
    [boardButton setBackgroundImage:[UIImage imageNamed:@"greenbutton_selected@2x.png"] forState:(UIControlStateSelected)];
    [_ticketInfoScrollView addSubview:boardButton];
    
    // 联系人
    _contactImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15+_boardingImage.frame.origin.y+_boardingImage.frame.size.height, 300, 90)];
    _contactImage.userInteractionEnabled = YES;
    _contactImage.image = [[UIImage imageNamed:@"BG2white1@2x.png"] resizableImageWithCapInsets:(UIEdgeInsetsMake(12, 0, 12, 0)) resizingMode:UIImageResizingModeStretch];
    [_ticketInfoScrollView addSubview:_contactImage];
    
    _contactionIphone = [[UIView alloc]initWithFrame:CGRectMake(10, 15+_boardingImage.frame.origin.y+_boardingImage.frame.size.height, 300, 50)];
    [_ticketInfoScrollView addSubview:_contactionIphone];
    
    for (int i = 0; i < 2; i++)
    {
        UILabel *contactLabel = [[UILabel alloc]init];
        contactLabel.tag = i;
        contactLabel.backgroundColor = [UIColor clearColor];
        contactLabel.textColor = [UIColor grayColor];
        if (contactLabel.tag == 0)
        {
            contactLabel.text = @"联系人";
            contactLabel.frame = CGRectMake(10, 15, 100, 20);
        }
        else if (contactLabel.tag == 1)
        {
            contactLabel.frame = CGRectMake(0, 50, 300, 1);
            contactLabel.backgroundColor = [UIColor grayColor];
        }
        //        else if (contactLabel.tag == 2)
        //        {
        //            contactLabel.text = @"请添加联系人";
        //            contactLabel.frame = CGRectMake(10, 60, 200, 20);
        //        }
        [_contactionIphone addSubview:contactLabel];
    }
    
    UIButton *contacButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    contacButton.frame = CGRectMake(170, 15, 120, 30);
    [contacButton setTitle:@"添加联系人" forState:(UIControlStateNormal)];
    contacButton.backgroundColor = [UIColor grayColor];
    [contacButton addTarget:self action:@selector(contacButton) forControlEvents:(UIControlEventTouchUpInside)];
    [_contactionIphone addSubview:contacButton];
    
    _sureButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _sureButton.frame = CGRectMake(10, _contactImage.frame.origin.y+_contactImage.frame.size.height + 20, 300, 45);
    [_sureButton setTitle:@"确认" forState:(UIControlStateNormal)];
    _sureButton.backgroundColor = [UIColor orangeColor];
    [_sureButton addTarget:self action:@selector(suerPay) forControlEvents:(UIControlEventTouchUpInside)];
    [_ticketInfoScrollView addSubview:_sureButton];
    
    // 滚动范围
    [_ticketInfoScrollView setContentSize:CGSizeMake(self.view.frame.size.width, _sureButton.frame.origin.y+_sureButton.frame.size.height +20 )];
    
    
}
// 添加乘机人
-(void)addPerson
{
    AddPassengersViewController  *addPassengerView = [[AddPassengersViewController alloc]init];
    addPassengerView.delegate = self;
    addPassengerView.ticketArray = self.ticketPersonArray;
    addPassengerView.teger = 1;
    [self.navigationController pushViewController:addPassengerView animated:YES];
}
// 添加联系人
-(void)contacButton
{
    AddContactPersonViewController *addContactPersonView = [[AddContactPersonViewController alloc]init];
    addContactPersonView.delegate = self;
    addContactPersonView.ticketArray = self.AddContactPersonAdrray;
    addContactPersonView.teger = 1;
    [self.navigationController pushViewController:addContactPersonView animated:YES];
}
-(void)suerPay
{
    if ([self.ticketPersonArray count] > 0 && [AddContactPersonAdrray count] >0) {
        TicketBillsViewController *ticketInfoView  = [[TicketBillsViewController alloc] init];
        ticketInfoView.TicketBillsArray =self.ticketPersonArray;
        ticketInfoView.allPriceBillsArray= self.AllPriceArray;
        [self.navigationController pushViewController:ticketInfoView animated:YES];
    }
    else
    {
        UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:@"请填写完整信息" message:@"请添加乘机人或联系人" delegate:self cancelButtonTitle:@"退出" otherButtonTitles:nil, nil];
        [alerView show];
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
