//
//  NLDataBaseSQL.m
//  TongFubao
//
//  Created by MD313 on 13-8-20.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLDataBaseSQL.h"
#import "NLDataBaseContants.h"

static NLDataBaseSQL* gNLDataBaseSQL = nil;

@implementation NLDataBaseSQL

+(id)shareNLDataBaseSQL
{
    if (gNLDataBaseSQL == nil)
    {
        gNLDataBaseSQL = [[NLDataBaseSQL alloc] init];
    }
    return gNLDataBaseSQL;
}

-(NSString*)createSQL:(NLDataBaseTableType)type
{
    NSString* sql = nil;
    switch (type)
    {
        case NLDataBaseTable_BlankList:
        {
            sql = [NSString stringWithFormat:@"CREATE TABLE %@(_id integer,id_ VARCHAR(128), no_ VARCHAR(128),name_ VARCHAR(128),memo1_ VARCHAR(128),memo2_ VARCHAR(128),memo3_ VARCHAR(128),PRIMARY KEY(_id));",TFBDataBase_bankListTable];
        }
            break;
            
        default:
            break;
    }
    
    return sql;
}

-(NSString*)cleanSQL:(NLDataBaseTableType)type
{
    NSString* sql = nil;
    switch (type)
    {
        case NLDataBaseTable_BlankList:
            {
                sql = [NSString stringWithFormat:@"DELETE from %@",TFBDataBase_bankListTable];
            }
            break;
            
        default:
            break;
    }
    
    return sql;
}

-(NSString*)addSQL:(NLDataBaseTableType)type object:(id)object
{
    NSString* sql = nil;
    switch (type)
    {
        case NLDataBaseTable_BlankList:
        {
            NLDataBase_bankListTable* n = (NLDataBase_bankListTable*)object;
            char *zSQL = sqlite3_mprintf("insert into bankListTable (id_,no_,name_,memo1_,memo2_,memo3_) VALUES('%q','%q','%q','%q','%q','%q')", [n.myID UTF8String],[n.myNO UTF8String],[n.myName UTF8String],[n.myMemo1 UTF8String],[n.myMemo2 UTF8String],[n.myMemo3 UTF8String]);
            sql=[NSString stringWithCString:zSQL  encoding:NSUTF8StringEncoding];
            sqlite3_free(zSQL);
        }
            break;
            
        default:
            break;
    }
    
    return sql;
}

-(NSString*)searchSQL:(NLDataBaseTableType)type by:(NLDataBaseSearchByType)by
{
    NSString* sql = nil;
    switch (type)
    {
        case NLDataBaseTable_BlankList:
        {
           sql = [NSString stringWithFormat:@"select id_,no_,name_,memo1_,memo2_,memo3_ from %@",TFBDataBase_bankListTable];
        }
            break;
            
        default:
            break;
    }
    
    return sql;
}

@end
