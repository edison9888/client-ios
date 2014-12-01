//
//  NLDataBase.h
//  TongFubao
//
//  Created by MD313 on 13-8-20.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataBase.h"

typedef enum
{
    NLDataBaseTable_BlankList = 0
}NLDataBaseTableType;

typedef enum
{
    NLDataBaseSearchBy_Default = 0,
    NLDataBaseSearchBy_Time,
    NLDataBaseSearchBy_Name
}NLDataBaseSearchByType;

@interface NLDataBase_bankListTable : NSObject
       
@property(nonatomic,retain) NSString* myID;
@property(nonatomic,retain) NSString* myNO;
@property(nonatomic,retain) NSString* myName;
@property(nonatomic,retain) NSString* myMemo1;  
@property(nonatomic,retain) NSString* myMemo2;
@property(nonatomic,retain) NSString* myMemo3;

-(id)initWithID:(NSString*)ID
            aNO:(NSString*)aNO
           name:(NSString*)name
          memo1:(NSString*)memo1
          memo2:(NSString*)memo2
          memo3:(NSString*)memo3;

@end

@class DataBase;

@interface NLDataBase : DataBase

+(id)shareNLDataBase;

-(void)cleanDataBase:(NLDataBaseTableType)type;
-(NSArray*)getAllDataBase:(NLDataBaseTableType)type by:(NLDataBaseSearchByType)by;
-(void)addDataBase:(NLDataBaseTableType)type  object:(id)object;

@end
