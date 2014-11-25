//
//  GameChargeBill.h
//  TongFubao
//
//  Created by ec on 14-6-10.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VisaReader.h"
#import "UPPayPluginDelegate.h"

@interface GameChargeBill : UIViewController<UPPayPluginDelegate,VisaReaderDelegate,UITextFieldDelegate,UIAlertViewDelegate>

-(id)initWithInfor:(NSDictionary*)infor;

@end
