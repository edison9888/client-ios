//
//  NLProtocolRegister.m
//  TongFubao
//
//  Created by MD313 on 13-8-17.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLProtocolRegister.h"

static NLProtocolRegister* gProtocolRegister = nil;

@interface NLProtocolRegister ()

@property(nonatomic,retain) NSMutableArray* myRequestArray;

@end

@implementation NLProtocolRegister

+(id)shareProtocolRegister
{
    if (gProtocolRegister == nil)
    {
        gProtocolRegister=[[NLProtocolRegister alloc] init];
    }
    return gProtocolRegister;
}

-(id)init
{
    self = [super init];
    if (self != nil)
    {
        [self initRequestArray];
    }
    return self;
}

-(void)initRequestArray
{
    self.myRequestArray = [NSMutableArray arrayWithCapacity:ProtocolRequestCount];
    for (int i = 0; i < ProtocolRequestCount; i++)
    {
        [self.myRequestArray addObject:[NSNumber numberWithBool:NO]];
    }
}

#pragma mark - regist or unregist

-(BOOL)registRequest:(NLProtocolRequestType)type
{
    int index = (int)type;
    BOOL result = [[self.myRequestArray objectAtIndex:index] boolValue];
    if (!result)
    {
        [self.myRequestArray replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:YES]];
    }
    return result;
}

-(BOOL)unRegistRequest:(NLProtocolRequestType)type
{
    int index = (int)type;
    BOOL result = [[self.myRequestArray objectAtIndex:index] boolValue];
    if (result)
    {
        [self.myRequestArray replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:NO]];
    }
    return result;
}

@end
