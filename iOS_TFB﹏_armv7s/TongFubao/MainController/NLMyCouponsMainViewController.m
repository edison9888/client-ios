//
//  NLMyCouponsMainViewController.m
//  TongFubao
//
//  Created by MD313 on 13-8-12.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLMyCouponsMainViewController.h"
#import "NLCashCouponsViewController.h"
#import "NLBuyCouponsViewController.h"
#import "NLHistoryDetailMainViewController.h"
#import "NLUtils.h"

@interface NLMyCouponsMainViewController ()

@property(nonatomic,retain) IBOutlet UIScrollView* myScrollView;
@property(nonatomic,retain) IBOutlet UIButton* myBuyBtn;
@property(nonatomic,retain) IBOutlet UIButton* myCashBtn;
@property(nonatomic,retain) IBOutlet UIImageView* myBuyImageView;
@property(nonatomic,retain) IBOutlet UIImageView* myCashImageView;

@property(nonatomic,retain) NLBuyCouponsViewController* myBuyCouponsViewController;
@property(nonatomic,retain) NLCashCouponsViewController* myCashCouponsViewController;

- (IBAction)onBuyBtnClicked:(id)sender;
- (IBAction)onCashBtnClicked:(id)sender;
- (void)onHistoryDetailBtnClicked:(id)sender;

- (void)loadScrollViewWithPage:(int)page;
- (void)initController;

@end

@implementation NLMyCouponsMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [NLUtils enableSliderViewController:NO];
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [NLUtils enableSliderViewController:YES];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.topViewController.title = @"我的优惠券";
    UIBarButtonItem *anotherButtonL = [[UIBarButtonItem alloc] initWithTitle:@"历史记录"
                                                                        style:UIBarButtonItemStyleBordered target:self
                                                                       action:@selector(onHistoryDetailBtnClicked:)] ;
    self.navigationItem.rightBarButtonItem = anotherButtonL;
    UITapGestureRecognizer *oneFingerTwoTaps = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(oneFingerTwoTaps)];
    // Set required taps and number of touches
    [oneFingerTwoTaps setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:oneFingerTwoTaps];
    [self initController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - keyboard hide event

-(void)oneFingerTwoTaps
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UITextField *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    [firstResponder resignFirstResponder];
}

- (IBAction)onBuyBtnClicked:(id)sender
{
    int page = 0;
    [self.myScrollView  setContentOffset:CGPointMake(self.myScrollView.frame.size.width * page, 0)];
}

- (IBAction)onCashBtnClicked:(id)sender
{
    int page = 1;
    [self.myScrollView  setContentOffset:CGPointMake(self.myScrollView.frame.size.width * page, 0)];
}

-(void)onHistoryDetailBtnClicked:(id)sender
{
    NLHistoryDetailMainViewController* vc = [[NLHistoryDetailMainViewController alloc] initWithNibName:@"NLHistoryDetailMainViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadScrollViewWithPage:(int)page
{
    CGRect frame = self.myScrollView.frame;
    frame.origin.x = frame.size.width * (page);

        if (0 == page)
        {
            self.myBuyCouponsViewController = [[NLBuyCouponsViewController alloc] initWithNibName:@"NLBuyCouponsViewController" bundle:nil];
            self.myBuyCouponsViewController.view.frame = CGRectOffset(self.myBuyCouponsViewController.view.frame, page*frame.size.width, 0);
            [self.myScrollView addSubview:self.myBuyCouponsViewController.view];
        }
        else if (1 == page)
        {
            self.myCashCouponsViewController = [[NLCashCouponsViewController alloc] initWithNibName:@"NLCashCouponsViewController" bundle:nil];
            self.myCashCouponsViewController.view.frame = CGRectOffset(self.myCashCouponsViewController.view.frame, page*frame.size.width, 0);
            [self.myScrollView addSubview:self.myCashCouponsViewController.view];
        }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.myScrollView.frame.size.width;
    int page = floor((self.myScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    if (0 == page)
    {
        self.myBuyImageView.hidden = NO;
        self.myCashImageView.hidden = YES;
    }
    else if (page == 1)
    {
        [self oneFingerTwoTaps];
        self.myBuyImageView.hidden = YES;
        self.myCashImageView.hidden = NO;
    }
}

- (void)pageTurn:(UIPageControl*)control
{
    int page = control.currentPage;
    [self.myScrollView  setContentOffset:CGPointMake(self.myScrollView.frame.size.width * page, 0)];
}

- (void)initController
{
    self.myBuyImageView.hidden = NO;
    self.myCashImageView.hidden = YES;
    self.myScrollView.pagingEnabled = YES;
    for (int i = 0; i < 2; i++)
    {
        [self loadScrollViewWithPage:i];
    }
    self.myScrollView.contentSize = CGSizeMake(self.myScrollView.frame.size.width*2, self.myScrollView.frame.size.height);
}


@end
