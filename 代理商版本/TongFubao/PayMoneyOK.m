//
//  PhoneMoneyToOK.m
//  TongFubao
//
//  Created by  俊   on 14-4-29.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "PayMoneyOK.h"


@interface PayMoneyOK ()

@property (retain, nonatomic) IBOutlet UIView *STAlertView;
@property (retain, nonatomic) IBOutlet UIView *contentView;
@property (retain, nonatomic) IBOutlet UIButton *ItOKBtn;

@property (weak, nonatomic) IBOutlet UILabel *titleContent;
@property (weak, nonatomic) IBOutlet UILabel *content;

@end

@implementation PayMoneyOK

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
    
    self.contentView.layer.cornerRadius = 3.0f;
    
    self.contentView.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.9].CGColor;
    
    self.contentView.layer.borderWidth = 2.0f;
    
    _titleContent.text = _dict[BUY_SUC_TITLT];
    _content.text = _dict[BUY_SUC_CONTENT];
    _content.numberOfLines = 0;
    
    
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
    
    [self.navigationController popToRootViewControllerAnimated:YES];
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
