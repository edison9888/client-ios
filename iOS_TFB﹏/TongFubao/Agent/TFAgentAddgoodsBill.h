//
//  TFAgentAddgoodsBill.h
//  TongFubao
//
//  Created by ec on 14-6-16.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VisaReader.h"
#import "UPPayPluginDelegate.h"

@interface TFAgentAddgoodsBill : UIViewController<UPPayPluginDelegate,VisaReaderDelegate,UITextFieldDelegate>

-(id)initWithInfor:(NSDictionary*)infor;

@end
