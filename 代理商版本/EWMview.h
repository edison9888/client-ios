//
//  EWMview.h
//  TongFubao
//
//  Created by  俊   on 14-7-30.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
#import <AVFoundation/AVFoundation.h> 

@interface EWMview : UIViewController<ZBarReaderViewDelegate,UIAlertViewDelegate,UINavigationControllerDelegate>
{
    int num;
    NSTimer * timer;
    BOOL upOrdown;
}

+ (id)singleton;

@property (nonatomic,assign) BOOL ewmToAPP;
@property (nonatomic,assign) CGRect selfFrame;
@property (nonatomic, strong) UIImageView * line;
@end
