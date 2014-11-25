//
//  GameDetailInfoChoiceCtr.h
//  TongFubao
//
//  Created by ec on 14-6-10.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameDetailInfoChoiceCtr : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>

-(id)initWithInfor:(NSDictionary*)infor;

@end
