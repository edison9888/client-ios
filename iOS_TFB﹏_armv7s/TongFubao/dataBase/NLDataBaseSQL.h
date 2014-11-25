//
//  NLDataBaseSQL.h
//  TongFubao
//
//  Created by MD313 on 13-8-20.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NLDataBase.h"

@interface NLDataBaseSQL : NSObject

+(id)shareNLDataBaseSQL;

-(NSString*)createSQL:(NLDataBaseTableType)type;
-(NSString*)cleanSQL:(NLDataBaseTableType)type;
-(NSString*)searchSQL:(NLDataBaseTableType)type by:(NLDataBaseSearchByType)by;
-(NSString*)addSQL:(NLDataBaseTableType)type object:(id)object;

@end
