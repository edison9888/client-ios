//
//  FirstLeadView.m
//  TongFubao
//
//  Created by  俊   on 14-11-7.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "FirstLeadView.h"

@interface FirstLeadView ()
{
    NSInteger currentTag;
    CGPoint orginPoint;
}

@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;

@end

@implementation FirstLeadView
@synthesize mPoint;
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
    [self viewMain];
}

-(void)viewMain
{
    /*引导充话费页面的*/
    [NLUtils setleaderbool:@"leaderView"];
    
    UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOneClick:)];
    _leftView.tag= 101;
    _leftView.userInteractionEnabled = YES;
    _leftView.autoresizesSubviews = YES;
    [_leftView addGestureRecognizer:singleTap];
    [self.view addSubview:_leftView];
    
    UITapGestureRecognizer * singleTap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOneClick:)];
    _rightView.tag= 102;
    _rightView.userInteractionEnabled = YES;
    _rightView.autoresizesSubviews = YES;
    [_rightView addGestureRecognizer:singleTap2];
    [self.view addSubview:_rightView];
}

-(void)tapOneClick:(UITapGestureRecognizer *)gesture
{
    UIApplication * app = [UIApplication sharedApplication];
    NLAppDelegate * appDel = app.delegate;
    appDel.mTouchPoint = orginPoint;
    appDel.mTouchView = gesture.view;
    
    [UIView animateWithDuration:0.35 animations:^{
      
    } completion:^(BOOL finished) {
        switch (gesture.view.tag) {
            case 101:
            {
                PushViewController * sendView = [[PushViewController alloc]init];
                sendView.mPoint = self.mPoint;
                [self presentViewController:sendView animated:YES completion:nil];
            }
                break;
            case 102:
            {
                PhoneMoneyView * sendView = [[PhoneMoneyView alloc]init];
                sendView.mPoint = self.mPoint;
                sendView.leaderFlag= YES;
                [NLUtils presentModalViewController:self newViewController:sendView];
            }
                break;

            default:
                break;
        }
    }];
   
    
   
}

- (IBAction)OnClickBtn:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
        {
            /*
            id thisClass = [[NSClassFromString(@"PhoneMoneyView") alloc] initWithNibName:@"PhoneMoneyView" bundle:nil];
            [NLUtils presentModalViewController:self newViewController:thisClass];
            */
            PhoneMoneyView * sendView = [[PhoneMoneyView alloc]init];
            sendView.mPoint = self.mPoint;
            sendView.leaderFlag= YES;
            [NLUtils presentModalViewController:self newViewController:sendView];
        }
            break;
        {
            NLAppDelegate *delegateA = [[UIApplication sharedApplication] delegate];
            if ([[NLUtils getAgenttypeid] isEqualToString:@"0"])
            {
                [delegateA backToMain];
            }else{
                [delegateA backToTFAgent];
            }


        }
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
