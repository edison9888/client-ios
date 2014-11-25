//
//  DetailViewController.m
//  TongFubao
//
//  Created by  俊   on 14-8-4.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)dealloc {
    [_labelForPlace release];
    [_labelForCountry release];
    [_imageView release];
    [_textviewForDetail release];
    [_dictForData release];
    
    [_backgroundImageView release];
    [super dealloc];
}

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
    
    [self addRightButtonItemWithTitle:@"下载"];
    self.labelForPlace.text = [NSString stringWithFormat:@"%@",[self.dictForData objectForKey:@"Place"]];
    self.labelForCountry.text = [NSString stringWithFormat:@"%@",[self.dictForData objectForKey:@"Country"]];
    self.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[self.dictForData objectForKey:@"Image"]]];
    
    [self animateOnEntry];
}

- (void) animateOnEntry
{
    /*界面的显示*/
    self.backgroundImageView.alpha = 0;
    self.backgroundImageView.frame = CGRectMake(0, self.yOrigin + MAIN_LABEL_Y_ORIGIN, self.backgroundImageView.frame.size.height, self.labelForPlace.frame.size.height + self.labelForCountry.frame.size.height);
    
    self.labelForPlace.frame = CGRectMake(70, self.yOrigin + MAIN_LABEL_Y_ORIGIN+30, self.labelForPlace.frame.size.width, self.labelForPlace.frame.size.height);
    
    self.labelForCountry.frame = CGRectMake(70, self.labelForPlace.frame.origin.y + self.labelForPlace.frame.size.height, self.labelForCountry.frame.size.width, self.labelForCountry.frame.size.height);
    
    self.imageView.frame = CGRectMake(50, self.yOrigin + IMAGEVIEW_Y_ORIGIN, 60, 60);
    self.textviewForDetail.alpha = 0;
    self.textviewForDetail.frame = CGRectMake(self.textviewForDetail.frame.origin.x, self.textviewForDetail.frame.size.height + self.view.frame.size.height, self.textviewForDetail.frame.size.width, self.textviewForDetail.frame.size.height);
    
    /*动画效果的*/
    [UIView animateWithDuration:0.4f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void)
     {
         self.labelForPlace.frame = CGRectMake(35, 210, self.labelForPlace.frame.size.width, self.labelForPlace.frame.size.height);
         self.labelForCountry.frame = CGRectMake(35, 250, self.labelForCountry.frame.size.width, self.labelForCountry.frame.size.height);
         self.backgroundImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, 300);
         self.backgroundImageView.alpha = 1;
         
         self.textviewForDetail.frame = CGRectMake(self.textviewForDetail.frame.origin.x, self.view.frame.size.height - self.textviewForDetail.frame.size.height, self.textviewForDetail.frame.size.width, self.textviewForDetail.frame.size.height);
         self.textviewForDetail.alpha = 1;
         
         NSLog(@"width %f height %f",self.imageView.frame.size.width,self.imageView.frame.size.height);
         
         self.imageView.frame = CGRectMake(100, 80, self.imageView.frame.size.width * 2, self.imageView.frame.size.height * 2);
     }
                     completion:NULL];
}

/*下载*/
-(void)rightItemClick:(id)sender{
    NSString *temp;
    
    if (_numberTag== 101) {
        /*免费版本*/
        temp= @"https://itunes.apple.com/cn/app/51xin-yong-ka/id564713751?mt=8";
    }
    if (_numberTag== 102)
    {
        /*专业版本*/
        temp= @"https://itunes.apple.com/cn/app/51xin-yong-kapro/id564765093?mt=8";
    }
   
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:temp]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*返回动画效果*/
- (void)doneBtnPressed:(id)sender
{
    //animation on EXIT FROM CURRENT VIEW
    [UIView animateWithDuration:0.4f animations:^
     {
         self.backgroundImageView.frame = CGRectMake(0, self.yOrigin + MAIN_LABEL_Y_ORIGIN, self.view.frame.size.width, self.labelForPlace.frame.size.height + self.labelForCountry.frame.size.height);
         self.labelForPlace.frame = CGRectMake(70, self.yOrigin + MAIN_LABEL_Y_ORIGIN, self.labelForPlace.frame.size.width, self.labelForPlace.frame.size.height);
         self.labelForCountry.frame = CGRectMake(70, self.labelForPlace.frame.origin.y + self.labelForPlace.frame.size.height, self.labelForCountry.frame.size.width, self.labelForCountry.frame.size.height);
         self.imageView.frame = CGRectMake(10, self.yOrigin + IMAGEVIEW_Y_ORIGIN, CGRectGetWidth(self.imageView.frame) / 2, CGRectGetHeight(self.imageView.frame) / 2);
         self.textviewForDetail.frame = CGRectMake(self.textviewForDetail.frame.origin.x, self.textviewForDetail.frame.size.height + self.view.frame.size.height, self.textviewForDetail.frame.size.width, self.textviewForDetail.frame.size.height);
         self.textviewForDetail.alpha = 0;
         self.backgroundImageView.alpha = 0;
     }
                     completion:^(BOOL finished)
     {
         [self.navigationController popViewControllerAnimated:NO];
     }
     ];
}

@end
