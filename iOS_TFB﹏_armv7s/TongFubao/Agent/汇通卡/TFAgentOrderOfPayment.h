//
//  TFAgentOrderOfPayment.h
//  TongFubao
//
//  Created by ec on 14-9-5.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VisaReader.h"
#import "UPPayPluginDelegate.h"

@interface TFAgentOrderOfPayment : UIViewController<UPPayPluginDelegate,VisaReaderDelegate,NLBankLisDelegate,UIAlertViewDelegate, BankPayListDelegate,UITextFieldDelegate>



-(id)initWithInfor:(NSDictionary*)infor;


@end
