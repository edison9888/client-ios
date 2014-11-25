//
//  TFData.h
//  TongFubao
//
//  Created by ec on 14-5-20.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ADD_SKQ_ADDRESS_FLAG @"add_skq_address_flag"
#define MAIN_IS_ON_GESTURESE @"main_is_on_gesturese"
#define MAIN_IS_ON_NEWLOGINGESTURE @"main_is_on_newlogingesturese"


#define PLANE_ADD_PEOPLE @"plane_add_people"

@interface TFData : NSObject

+(TFData *)Instance;

+(NSMutableDictionary*)getTempData;

@end
