//
//  DetailViewController.h
//  TongFubao
//
//  Created by  俊   on 14-8-4.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MAIN_LABEL_Y_ORIGIN 70
#define IMAGEVIEW_Y_ORIGIN 15

@interface DetailViewController : UIViewController

@property (retain, nonatomic) IBOutlet UILabel *labelForPlace;
@property (retain, nonatomic) IBOutlet UILabel *labelForCountry;
@property (retain, nonatomic) IBOutlet UIImageView *imageView;
@property (retain, nonatomic) IBOutlet UITextView *textviewForDetail;
@property (retain, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (assign, nonatomic) int numberTag;
@property (readwrite, nonatomic) int yOrigin;
@property (retain, nonatomic) NSMutableDictionary *dictForData;

@end
