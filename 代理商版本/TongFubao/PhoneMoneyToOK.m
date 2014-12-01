//
//  PhoneMoneyToOK.m
//  TongFubao
//
//  Created by  俊   on 14-4-29.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "PhoneMoneyToOK.h"


@interface PhoneMoneyToOK ()

@property (retain, nonatomic) IBOutlet UIView *STAlertView;
@property (retain, nonatomic) IBOutlet UIView *contentView;
@property (retain, nonatomic) IBOutlet UIButton *ItOKBtn;
@property (strong, nonatomic) IBOutlet UILabel *OKPhoneMoney;
@property (strong, nonatomic) IBOutlet UILabel *NumPhone;
@property (weak, nonatomic) IBOutlet UILabel *labletext;

@end

@implementation PhoneMoneyToOK
@synthesize OKPhoneStr,NumPhoneStr,phoneNumLable,labletextStr;
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
    self.title= @"操作成功";
    self.contentView.layer.cornerRadius = 3.0f;
    self.contentView.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.9].CGColor;
    self.contentView.layer.borderWidth = 2.0f;
    
    _labletext.text= labletextStr;
    _OKPhoneMoney.text= [NSString stringWithFormat:@"%@",OKPhoneStr];
    _OKPhoneMoney.textAlignment= UIControlContentVerticalAlignmentCenter;
    _NumPhone.text= [NSString stringWithFormat:@"%@:%@",_numInfo,phoneNumLable];
    _NumPhone.textAlignment= UIControlContentVerticalAlignmentCenter;
    [self show];
}

- (void)show{
    
    self.STAlertView.center = self.view.center;
    [self.view addSubview:self.STAlertView];
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)]];
    popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.STAlertView.layer addAnimation:popAnimation forKey:nil];

}

- (IBAction)PhoneMoneyBtn:(id)sender {
    
    CAKeyframeAnimation *hideAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    hideAnimation.duration = 0.4;
    hideAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)]];
    hideAnimation.delegate = self;
    [self.STAlertView.layer addAnimation:hideAnimation forKey:nil];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self.STAlertView removeFromSuperview];
}
@end
