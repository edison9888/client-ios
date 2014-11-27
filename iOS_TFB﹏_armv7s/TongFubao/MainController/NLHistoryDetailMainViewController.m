//
//  NLHistoryDetailMainViewController.m
//  TongFubao
//
//  Created by MD313 on 13-8-12.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLHistoryDetailMainViewController.h"
#import "NLHistoryDetailViewController.h"

@interface NLHistoryDetailMainViewController ()

@property(nonatomic,retain) IBOutlet UIScrollView* myScrollView;
@property(nonatomic,retain) IBOutlet UIButton* myBuyBtn;
@property(nonatomic,retain) IBOutlet UIButton* myCashBtn;
@property(nonatomic,retain) IBOutlet UIImageView* myBuyImageView;
@property(nonatomic,retain) IBOutlet UIImageView* myCashImageView;

@property(nonatomic,retain) NLHistoryDetailViewController* myBuyCouponsViewController;
@property(nonatomic,retain) NLHistoryDetailViewController* myCashCouponsViewController;

- (IBAction)onBuyBtnClicked:(id)sender;
- (IBAction)onCashBtnClicked:(id)sender;

- (void)loadScrollViewWithPage:(int)page;
- (void)initController;

@end

@implementation NLHistoryDetailMainViewController

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
    // Do any additional setup after loading the view from its nib.
    self.navigationController.topViewController.title = @"历史记录";
    [self initController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
}

- (void)loadScrollViewWithPage:(int)page
{
    CGRect frame = self.myScrollView.frame;
    frame.origin.x = frame.size.width * (page);
    
    if (0 == page)
    {
        self.myBuyCouponsViewController = [[NLHistoryDetailViewController alloc] initWithNibName:@"NLHistoryDetailViewController" bundle:nil];
        self.myBuyCouponsViewController.myHistoryDetailType = NLHistoryDetailBuy;
        self.myBuyCouponsViewController.view.frame = CGRectOffset(self.myBuyCouponsViewController.view.frame, page*frame.size.width, 0);
        [self.myScrollView addSubview:self.myBuyCouponsViewController.view];
    }
    else if (1 == page)
    {
        self.myCashCouponsViewController = [[NLHistoryDetailViewController alloc] initWithNibName:@"NLHistoryDetailViewController" bundle:nil];
        self.myCashCouponsViewController.myHistoryDetailType = NLHistoryDetailCash;
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
