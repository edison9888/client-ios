//
//  NLButtonViewController.m
//  TongFubao
//
//  Created by MD313 on 13-9-25.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLButtonViewController.h"

@interface NLButtonViewController ()
{
    NSString* _title;
    UIImage* _image;
    int _tag;
}

@property(nonatomic, strong)IBOutlet UIImageView* myImageView;
@property(nonatomic, strong)IBOutlet UILabel* myLabel;
@property(nonatomic, strong)IBOutlet UIButton* myButton;

-(IBAction)onBtnClicked:(id)sender;

@end

@implementation NLButtonViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithTitle:(NSString*)title image:(UIImage*)image tag:(int)tag
{
    self = [super initWithNibName:@"NLButtonViewController" bundle:nil];
    if (self) {
        // Custom initialization
        _title = title;
        _tag = tag;
        _image = image;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.myButton.tag = _tag;
    self.myLabel.text = _title;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)onBtnClicked:(id)sender
{
     if ([self.myDelegate respondsToSelector:@selector(onNLButtonClicked:)])
     {
         [self.myDelegate onNLButtonClicked:sender];
     }
}

@end
