//
//  NLDataBase.m
//  TongFubao
//
//  Created by MD313 on 13-8-20.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLDataBase.h"
#import "NLDataBaseSQL.h"
#import "NLDataBaseContants.h"
#import "NLContants.h"

static NLDataBase* gNLDataBase = nil;

@implementation NLDataBase_bankListTable

-(id)initWithID:(NSString*)ID
            aNO:(NSString*)aNO
           name:(NSString*)name
          memo1:(NSString*)memo1
          memo2:(NSString*)memo2
          memo3:(NSString*)memo3
{
    self = [super init];
	if (self != nil)
    {
        self.myID = ID;
        self.myName = name;
        self.myNO = aNO;
        self.myMemo1 = memo1;
        self.myMemo2 = memo2;
        self.myMemo3 = memo3;
    }
    return self;
}

@end

@implementation NLDataBase

+(id)shareNLDataBase
{
    if (gNLDataBase == nil)
    {
        gNLDataBase = [[NLDataBase alloc] init];
    }
    return gNLDataBase;
}

-(id)init
{
    return [super initWithName:FETCH_ABS_FILE_NAME(TFBDataBase)];
}

-(bool)createTable
{
    [super createTable];
    
    //银行列表
    NSString* sql = [[NLDataBaseSQL shareNLDataBaseSQL] createSQL:NLDataBaseTable_BlankList];
    if (![self doSQL:sql])
    {
        return false;
    }
    
    return true;
}

-(bool)doCreateTable:(char*)table
{
    sqlite3_stmt *statement;
    
    if(sqlite3_prepare_v2(database_, table, -1, &statement, nil) != SQLITE_OK)
    {
        return false;
    }
    int success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    if ( success != SQLITE_DONE)
    {
        return false;
    }
    return true;
}

-(BOOL)doSQL:(NSString*)sql
{
    BOOL result = NO;
    const char *sql_stmt = [sql UTF8String];
    sqlite3_stmt *statement;
    int success = sqlite3_prepare_v2(database_, sql_stmt, -1, &statement, NULL);
    if (success != SQLITE_OK)
    {
        return result;
    }
    
    if (sqlite3_step(statement) == SQLITE_DONE)
    {
        result = YES;
    }
    else
    {
        result = NO;
    }
    sqlite3_finalize(statement);
    return result;
}

-(void)cleanDataBase:(NLDataBaseTableType)type
{
    switch (type)
    {
        case NLDataBaseTable_BlankList:
        {
            NSString* sql = [[NLDataBaseSQL shareNLDataBaseSQL] cleanSQL:NLDataBaseTable_BlankList];
            [self doSQL:sql];
        }
            break;
            
        default:
            break;
    }
}

-(NSArray*)getAllDataBase:(NLDataBaseTableType)type by:(NLDataBaseSearchByType)by
{
    switch (type)
    {
        case NLDataBaseTable_BlankList:
        {
            NSString* sql = [[NLDataBaseSQL shareNLDataBaseSQL] searchSQL:NLDataBaseTable_BlankList by:by];
            return [self doBlankListSearch:sql];
        }
            break;
            
        default:
            break;
    }
    return nil;
}

-(void)addDataBase:(NLDataBaseTableType)type object:(id)object
{
    switch (type)
    {
        case NLDataBaseTable_BlankList:
        {
            NSString* sql = [[NLDataBaseSQL shareNLDataBaseSQL] addSQL:NLDataBaseTable_BlankList object:object];
            [self doSQL:sql];
        }
            break;
            
        default:
            break;
    }
}

-(NSArray*)doBlankListSearch:(NSString*)sql
{
    const char *sql_stmt = [sql UTF8String];
    sqlite3_stmt *statement;
    int success = sqlite3_prepare_v2(database_, sql_stmt, -1, &statement, NULL);
    if (success != SQLITE_OK)
    {
        return nil;
    }
    
    NSMutableArray* arr = [NSMutableArray arrayWithCapacity:10];
    while (sqlite3_step(statement) == SQLITE_ROW)
    {
        NLDataBase_bankListTable* node = [[NLDataBase_bankListTable alloc] init];
        const char* temp= (const char*)sqlite3_column_text(statement,0);
        if (temp)
        {
            node.myID = [NSString stringWithUTF8String:temp];
		}
        temp= (const char*)sqlite3_column_text(statement,1);
        if (temp)
        {
            node.myNO = [NSString stringWithUTF8String:temp];
		}
        temp= (const char*)sqlite3_column_text(statement,2);
        if (temp)
        {
            node.myName = [NSString stringWithUTF8String:temp];
		}
        temp= (const char*)sqlite3_column_text(statement,3);
        if (temp)
        {
            node.myMemo1 = [NSString stringWithUTF8String:temp];
		}
        temp= (const char*)sqlite3_column_text(statement,4);
        if (temp)
        {
            node.myMemo2 = [NSString stringWithUTF8String:temp];
		}
        temp= (const char*)sqlite3_column_text(statement,5);
        if (temp)
        {
            node.myMemo3 = [NSString stringWithUTF8String:temp];
		}
        
        [arr addObject:node];
    }
    sqlite3_finalize(statement);
    return arr;
}


@end
