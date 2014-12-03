//
//  TicketInfoImationViewController.m
//  TongFubao
//
//  Created by kin on 14-9-10.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "TicketInfoImationViewController.h"

#import "AddPassengersViewController.h"
#import "AddContactPersonViewController.h"
#import "TicketBillsViewController.h"
#import "PlayFromToView.h"
#import "PersonView.h"
#import "PersonIphoneView.h"
#import "ReturnPlayView.h"


@interface TicketInfoImationViewController ()<AddPassengersViewdelegate,PersonViewdelegate,AddContactPersondelegate,PersonIphoneViewdelegate,PlayFromToViewdelegate,ReturnPlayViewdelegate>

@end

@implementation TicketInfoImationViewController

{
    UIImageView *_boardingImage;
    UIImageView *_contactImage;
    PlayFromToView *_desperAriView;
    UIButton *_sureButton;
    UIScrollView *_ticketInfoScrollView;
    PersonView *_obView ;
    UIView *_contactionIphone;
    ReturnPlayView *_ReturnPlayAriView;
    NSInteger SingleHighBack ;
    
}

@synthesize FlightType,priceTicket,msgchildTicket,standardPriceTicket,oilFeeTicket,taxTicket,standardPriceChirldTicket,oilFeeChirldTicket,taxForTicket,standardPricebadyTicket,oilFeeForBabyTicket,taxForBabyTicket,quantityTicket,rerNoteTicket,endNoteTicket,refNoteTicket,classTicket,TicketArrivePlay,TicketDepartPlay,TicketDeTimeFrom,TicketArriveTimeTo,TicketDepartCode,TicketArriveCode,TicketInfoDepartCtity,TicketInfoArriveCity,playName,TicketFlihtCity,infoArray,ticketPersonArray,AddContactPersonAdrray,AllPriceArray,TicketdPicedId,fromPriceTicketId,backPriceTicketId,infoTextView;

@synthesize backTicketPrice,airPlayInfoArray;



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
    
    if ([self.FlightType  isEqualToString:@"S"])
    {
        
        NSString *dateFrom = [self.TicketDeTimeFrom substringWithRange:NSMakeRange(0, 10)];
        NSString *timeFrom = [self.TicketDeTimeFrom substringWithRange:NSMakeRange(11, 5)];
        NSString *dateTo = [self.self.TicketArriveTimeTo substringWithRange:NSMakeRange(0, 10)];
        NSString *timeTo = [self.self.TicketArriveTimeTo substringWithRange:NSMakeRange(11, 5)];
        //  封装数据
        self.infoArray = [[NSMutableArray alloc]initWithObjects:dateFrom,dateTo,timeFrom,timeTo,TicketDepartPlay,TicketInfoDepartCtity,TicketInfoArriveCity,TicketArrivePlay,playName,TicketFlihtCity,classTicket,[NSString stringWithFormat:@"￥%@", priceTicket],[NSString stringWithFormat:@"￥%@", taxTicket], [NSString stringWithFormat:@"￥%@",oilFeeTicket],nil];
        //  总价格
        self.AllPriceArray = [[NSMutableArray alloc]initWithObjects:self.priceTicket,self.oilFeeTicket,self.taxTicket,self.standardPriceChirldTicket,self.oilFeeChirldTicket,self.taxForTicket,self.standardPricebadyTicket,self.oilFeeForBabyTicket,self.taxForBabyTicket,nil];
//        NSLog(@"=====self.AllPriceArray=====%@",self.AllPriceArray);
    }
    else
    {
        
        NSString * fromDateFist = [[self.firstTicketArray objectAtIndex:0] substringToIndex:10];
        NSString * fromTimeFist = [[self.firstTicketArray objectAtIndex:0]substringWithRange:NSMakeRange(11, 5)];
        NSString * toDateFist = [[self.firstTicketArray objectAtIndex:1] substringToIndex:10];
        NSString * toTimeFist = [[self.firstTicketArray objectAtIndex:1]substringWithRange:NSMakeRange(11, 5)];
        
        NSString * fromDateSecond = [[self.seconedTicketArray objectAtIndex:0] substringToIndex:10];
        NSString * fromTimeSecond = [[self.seconedTicketArray objectAtIndex:0]substringWithRange:NSMakeRange(11, 5)];
        NSString * toDateSecond = [[self.seconedTicketArray objectAtIndex:1] substringToIndex:10];
        NSString * toTimeSecond = [[self.seconedTicketArray objectAtIndex:1]substringWithRange:NSMakeRange(11, 5)];
        
        NSString * firstplayfrom = [self.firstTicketArray objectAtIndex:5];
        NSString * firstplayto = [self.firstTicketArray objectAtIndex:6];
        NSString * Secondplayfrom = [self.seconedTicketArray objectAtIndex:5];
        NSString * Secondplayto = [self.seconedTicketArray objectAtIndex:6];
        
        self.allPlayInfo = [[NSMutableArray alloc]initWithObjects:fromDateFist,fromTimeFist,toDateFist,toTimeFist,fromDateSecond,fromTimeSecond,toDateSecond,toTimeSecond,firstplayfrom,firstplayto,Secondplayfrom,Secondplayto,self.TicketInfoDepartCtity,self.TicketInfoArriveCity,[self.firstTicketArray objectAtIndex:4],[self.firstTicketArray objectAtIndex:7],[self.seconedTicketArray objectAtIndex:4],[self.seconedTicketArray objectAtIndex:7],self.classTicketFist,self.classTicketSecond,[NSString stringWithFormat:@"￥%@", priceTicket],[NSString stringWithFormat:@"￥%@", taxTicket], [NSString stringWithFormat:@"￥%@",oilFeeTicket], nil];
        
    }
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
        if ([[[newIphoneArray objectAtIndex:i] objectAtIndex:6] isEqualToString:@"b"])
        {
            [iphonePerson addObject:[newIphoneArray objectAtIndex:i]];
        }
    }
    
    if ([newIphoneArray count] > 0)
    {
        [[NSUserDefaults standardUserDefaults] setObject:iphonePerson forKey:@"addPersonPlay"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.ticketPersonArray = iphonePerson;
        //        NSLog(@"=========ticketPersonArray=======%@",self.ticketPersonArray);
    }
    else
    {
        self.ticketPersonArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"addPersonPlay"];
        //        NSLog(@"=========ticketPersonArray00=======%@",self.ticketPersonArray);
    }
    
    
    _boardingImage.frame = CGRectMake(10, 25+SingleHighBack, 300, 90+40*[self.ticketPersonArray count]);
    _contactImage.frame = CGRectMake(10, 15+_boardingImage.frame.origin.y+_boardingImage.frame.size.height, 300, 90+40*[self.AddContactPersonAdrray count]);
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
    if ([newAddContactPerson count] > 0)
    {
        [[NSUserDefaults standardUserDefaults] setObject:ContactPerson forKey:@"addContactPerson"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.AddContactPersonAdrray = ContactPerson;
        //        NSLog(@"=========ticketPersonArray======%@",self.ticketPersonArray);
    }
    else
    {
        self.AddContactPersonAdrray = [[NSUserDefaults standardUserDefaults] objectForKey:@"addContactPerson"];
        //        NSLog(@"=========ticketPersonArray000======%@",self.ticketPersonArray);
        
    }
    
    _boardingImage.frame =CGRectMake(10, 25+SingleHighBack, 300, 90+40*[self.ticketPersonArray count]);
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
    _boardingImage.frame =CGRectMake(10, 25+SingleHighBack, 300, 90+40*[self.ticketPersonArray count]);
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
    _boardingImage.frame =CGRectMake(10, 25+SingleHighBack, 300, 90+40*[self.ticketPersonArray count]);
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
    
    
    
    self.infoTextView = [[UITextView alloc]initWithFrame:CGRectMake(320, 0, 320, self.view.frame.size.height)];
    self.infoTextView.editable = NO;
    self.infoTextView.backgroundColor = RGBACOLOR(10, 10, 10, 0.9);
    self.infoTextView.font = [UIFont systemFontOfSize:18];
    self.infoTextView.textColor = [UIColor whiteColor];
    
    UISwipeGestureRecognizer *swipe=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(moveView)];
    swipe.direction=UISwipeGestureRecognizerDirectionRight|UISwipeGestureRecognizerDirectionLeft;
    [self.infoTextView addGestureRecognizer:swipe];
    
    UITapGestureRecognizer *TapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moveView)];
    TapGestureRecognizer.numberOfTapsRequired = 1;
    [self.infoTextView addGestureRecognizer:TapGestureRecognizer];
    self.navigationController.view.backgroundColor = RGBACOLOR(10, 10, 10, 0.9);
    [self.navigationController.view addSubview:self.infoTextView ];
    
    if ([self.FlightType  isEqualToString:@"S"])
    {
        // 单返模块
        _desperAriView = [[PlayFromToView alloc]initWithFrame:CGRectMake(0, 0, 320, 278) infoArray:self.infoArray];
        _desperAriView.delegate = self;
        [_ticketInfoScrollView addSubview:_desperAriView];
//        NSString *allInfo = [rerNoteTicket stringByAppendingString:endNoteTicket];
//        self.infoTextView.text = [NSString stringWithFormat:@"\v%@",allInfo];
//        NSLog(@"=======allInfo=======%@",allInfo);
        
        NSArray *array=@[@"更改政策说明",rerNoteTicket,@"改签政策说明",endNoteTicket,@"退票政策说明",refNoteTicket];
        CGFloat firstHeigth = 30.0;
        for (int i=0; i<6; i++) {
            UILabel *weiXinLabel=[[UILabel alloc]init];
            weiXinLabel.text=array[i];
            weiXinLabel.textColor = [UIColor whiteColor];
            NSDictionary *dictionar=@{NSFontAttributeName: [UIFont systemFontOfSize:17]};
            CGSize weiSize=[array[i] boundingRectWithSize:CGSizeMake(280, 480) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:dictionar context:nil].size;
            weiXinLabel.frame=CGRectMake(0, firstHeigth, 320, weiSize.height+20);
            firstHeigth+=weiSize.height+20;
            
            weiXinLabel.tag=i;
            if (weiXinLabel.tag==0 || weiXinLabel.tag==2 || weiXinLabel.tag==4) {
                weiXinLabel.backgroundColor=RGBACOLOR(100, 100, 100, 0.6);
            }
            else{
                weiXinLabel.backgroundColor=[UIColor clearColor];
            }
            //换行
            weiXinLabel.numberOfLines=0;
            weiXinLabel.lineBreakMode=NSLineBreakByWordWrapping;
            [self.infoTextView addSubview:weiXinLabel];
        }
        

        
    }
    else
    {
        // 往返模块
        _ReturnPlayAriView = [[ReturnPlayView alloc]initWithFrame:CGRectMake(0, 0, 320, 350) firstSecondArray:self.allPlayInfo];
        _ReturnPlayAriView.delegate = self;
        [_ticketInfoScrollView addSubview:_ReturnPlayAriView];
//        NSString *allInfo = [[self.airPlayInfoArray objectAtIndex:3] stringByAppendingString:[self.airPlayInfoArray objectAtIndex:4]];
        
//        self.infoTextView.text =  [NSString stringWithFormat:@"\v%@",allInfo];;
//        NSLog(@"=======allInfo=======%@",allInfo);
        NSArray *array=@[@"更改政策说明",[self.airPlayInfoArray objectAtIndex:2],@"改签政策说明",[self.airPlayInfoArray objectAtIndex:3],@"退票政策说明",[self.airPlayInfoArray objectAtIndex:4]];
        CGFloat firstHeigth = 30.0;
        for (int i=0; i<6; i++) {
            UILabel *weiXinLabel=[[UILabel alloc]init];
            weiXinLabel.text=array[i];
            weiXinLabel.textColor = [UIColor whiteColor];
            NSDictionary *dictionar=@{NSFontAttributeName: [UIFont systemFontOfSize:17]};
            CGSize weiSize=[array[i] boundingRectWithSize:CGSizeMake(280, 480) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:dictionar context:nil].size;
            weiXinLabel.frame=CGRectMake(0, firstHeigth, 320, weiSize.height+20);
            firstHeigth+=weiSize.height+20;
            
            weiXinLabel.tag=i;
            if (weiXinLabel.tag==0 || weiXinLabel.tag==2 || weiXinLabel.tag==4) {
                weiXinLabel.backgroundColor=RGBACOLOR(100, 100, 100, 0.6);
            }
            else{
                weiXinLabel.backgroundColor=[UIColor clearColor];
            }
            //换行
            weiXinLabel.numberOfLines=0;
            weiXinLabel.lineBreakMode=NSLineBreakByWordWrapping;
            [self.infoTextView addSubview:weiXinLabel];
        }
    }
    
    SingleHighBack = [self.FlightType  isEqualToString:@"S"] ? (_desperAriView.frame.origin.y+_desperAriView.frame.size.height):(_ReturnPlayAriView.frame.origin.y+_ReturnPlayAriView.frame.size.height);
    
    // 登机人
    _boardingImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 25+SingleHighBack, 300, 90)];
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
            boardLabel.frame = CGRectMake(20, 40+SingleHighBack, 100, 20);
        }
        else if (boardLabel.tag == 1)
        {
            boardLabel.frame = CGRectMake(10, 75+SingleHighBack, 300, 1);
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
    boardButton.frame = CGRectMake(180,  40+SingleHighBack, 120, 30);
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
    contacButton.layer.masksToBounds = YES;
    contacButton.layer.cornerRadius = 3;
    [contacButton addTarget:self action:@selector(contacButton) forControlEvents:(UIControlEventTouchUpInside)];
    [_contactionIphone addSubview:contacButton];
    
    _sureButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _sureButton.frame = CGRectMake(10, _contactImage.frame.origin.y+_contactImage.frame.size.height + 20, 300, 45);
    _sureButton.layer.masksToBounds = YES;
    _sureButton.layer.cornerRadius = 5;
    _sureButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [_sureButton setTitle:@"下一步" forState:(UIControlStateNormal)];
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

#pragma mark ---- 确定支付界面
-(void)suerPay
{
    if ([self.ticketPersonArray count] > 0 && [AddContactPersonAdrray count] >0)
    {
        TicketBillsViewController *ticketInfoView  = [[TicketBillsViewController alloc] init];
        // 添加乘机人
        ticketInfoView.TicketBillsArray = self.ticketPersonArray;
        // 添加联系人
        ticketInfoView.TicketContactArray = self.AddContactPersonAdrray;
        
        if ([FlightType  isEqualToString:@"S"])
        {
            // 票的id
            ticketInfoView.TicketBillId = self.TicketdPicedId;
            // 价钱
            ticketInfoView.allPriceBillsArray = self.AllPriceArray;
            ticketInfoView.styGoBack = @"S";
//            NSLog(@"======AllPriceArray====%@",self.AllPriceArray);
            
            //        ticketInfoView.TicketBillFlightInformation = self.TicketdAllFlightInformation;
            
        }
        else
        {
            // 价钱
            ticketInfoView.goTicketArray = self.fromTicketPriceArray;
            ticketInfoView.backTicketArray = self.backTicketPrice;
            // 机票id
            ticketInfoView.TicketBillId = fromPriceTicketId;
            ticketInfoView.backTicketId = backPriceTicketId;
            ticketInfoView.styGoBack = @"D";
            
        }
        [self.navigationController pushViewController:ticketInfoView animated:YES];
    }
    else
    {
        UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:@"请填写完整信息" message:@"请添加乘机人或联系人" delegate:self cancelButtonTitle:@"退出" otherButtonTitles:nil, nil];
        [alerView show];
    }
}
-(void)playFromToViewInfoTuPiao
{
    [UIView animateWithDuration:0.3 animations:^{
        self.infoTextView .frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    }];
}
-(void)moveView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.infoTextView .frame = CGRectMake(320, 0, 320, self.view.frame.size.height);
    }];
    
}
-(void)ReturnPlayViewInfoTuPiao
{
    [UIView animateWithDuration:0.3 animations:^{
        self.infoTextView .frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    }];
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
