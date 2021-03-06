//
//  NLShowTextViewController.m
//  TongFubao
//
//  Created by MD313 on 13-8-29.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLShowTextViewController.h"
#import "NLPlistOper.h"
#import "NLContants.h"

@interface NLShowTextViewController ()

@property(nonatomic,assign) IBOutlet UITextView* myTextView;

@end

@implementation NLShowTextViewController

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
    self.myTextView.editable = NO;
    NSArray *arr = [self.myTextView gestureRecognizers];
    [self dissMiss];
    int x =[arr count];
    for (int i = 2; i < x; i++)
    {
        [self.myTextView removeGestureRecognizer:[arr objectAtIndex:i]];
    }
    [self initTitleAndText];
}

-(void)dissMiss{
    
    UIButton* backButton = [NLUtils createNavigationLeftBarButtonImage];
    
    [backButton setBackgroundImage:[UIImage imageNamed:@"navigationLeftBtnBack2"] forState:UIControlStateNormal];
    
    [backButton addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

-(void)backTo
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)loadText
{
    NSString* path = [NLPlistOper readValue:TFBC_readAppruleList_path path:FETCH_ABS_FILE_NAME(TFBConfigurator)];
    NSString* str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    self.myTextView.text = str;
}

-(void)initTitleAndText
{
    switch (self.myType)
    {
        case 0:
        {
            self.navigationController.topViewController.title = self.myTitle;
            self.myTextView.text = self.myText;
        }
            break;
        case 1:
        {
            self.navigationController.topViewController.title = @"通付宝服务协议";
            [self loadText];
        }
            break;
        case 2:
        {
            self.navigationController.topViewController.title = @"通付宝钱包服务协议";
            [self loadText];
        }
            break;
        case 3:
        {
            self.navigationController.topViewController.title = @"通付宝注册协议";
            [self loadText];
        }
            break;
        case 4:
        {
            self.navigationController.topViewController.title = @"关于我们";
            [self loadText];
        }
            break;
        case 5:
        {
            self.navigationController.topViewController.title = @"通付宝转账汇款服务协议";
            [self loadText];
        }
            break;
        case 6:
        {
            self.navigationController.topViewController.title = @"通付宝默认支付协议";
            [self loadText];
        }
            break;
        default:
            break;
    }
    //self.myTextView.editable = NO;
    //self.myTextView.userInteractionEnabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
