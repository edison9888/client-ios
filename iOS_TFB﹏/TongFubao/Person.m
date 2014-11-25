//
//  Person.m
//  Person
//
//  Created by 〝Cow﹏. on 14-7-3.
//  Copyright (c) 2014年 〝Cow﹏. All rights reserved.
//

#import "Person.h"

#define mnuorderkey    @"mnuorder"
#define mnunoKey       @"mnuno"
#define mnutypenameKey @"mnutypename"
#define mnunameKey     @"mnuname"
#define mnutypeidKey   @"mnutypeid"
#define mnuisconstKey  @"mnuisconst"
#define mnuidKey       @"mnuid"
#define pointnumKey    @"pointnum"
#define mainviewKey    @"mainview"

@implementation Person
@synthesize mnuid,mnuisconst,mnutypeid,mnutypename,pointnum,mnuname,mnuno,mnuorder;


-(NSString *)description{
    
    NSString *print= [NSString stringWithFormat:@"mnutypeid- %@, mnutypename=%@ mnuisconst=%@ mnuid=%@ pointnum=%@ mnuname=%@ mnuno=%@ mnuorder=%@ ",mnutypeid,mnutypename,mnuisconst,mnuid,pointnum,mnuname,mnuno,mnuorder];
    return print;
}


/*单个归档*/
#pragma mark-NSCoding
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:mnuorder forKey:mnuorderkey];
    [aCoder encodeObject:mnuno forKey:mnunoKey];
    [aCoder encodeObject:mnutypename forKey:mnutypenameKey];
    [aCoder encodeObject:mnuname forKey:mnunameKey];
    [aCoder encodeObject:mnutypeid forKey:mnutypeidKey];
    [aCoder encodeObject:mnuisconst forKey:mnuisconstKey];
    [aCoder encodeObject:mnuid forKey:mnuidKey];
    [aCoder encodeObject:pointnum forKey:pointnumKey];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self == [super init]) {
        mnuorder    =  [aDecoder decodeObjectForKey:mnuorderkey];
        mnuno       =  [aDecoder decodeObjectForKey:mnunoKey];
        mnutypename =  [aDecoder decodeObjectForKey:mnutypenameKey];
        mnuname     =  [aDecoder decodeObjectForKey:mnunameKey];
        mnutypeid   =  [aDecoder decodeObjectForKey:mnutypeidKey];
        mnuisconst  =  [aDecoder decodeObjectForKey:mnuisconstKey];
        mnuid       =  [aDecoder decodeObjectForKey:mnuidKey];
        pointnum    =  [aDecoder decodeObjectForKey:pointnumKey];
      }
    return self;
}

#pragma mark-NSCopying
-(id)copyWithZone:(NSZone *)zone{
    Person *copy     = [[[self class] allocWithZone:zone] init];
    copy.mnuorder    = [self.mnuorder copyWithZone:zone];
    copy.mnuno       = [self.mnuno copyWithZone:zone];
    copy.mnutypename = [self.mnutypename copyWithZone:zone];
    copy.mnuname     = [self.mnuname copyWithZone:zone];
    copy.mnutypeid   = [self.mnutypeid copyWithZone:zone];
    copy.mnuisconst  = [self.mnuisconst copyWithZone:zone];
    copy.mnuid       = [self.mnuid copyWithZone:zone];
    copy.pointnum    = [self.pointnum copyWithZone:zone];
    return copy;
}

-(void)dealloc
{
    [mnuorder release];
    [mnuno release];
    [mnutypename release];
    [mnuname release];
    [mnutypeid release];
    [mnuisconst release];
    [mnuid release];
    [pointnum release];
    [super dealloc];
}

@end

@implementation BankPayList

@synthesize bkcardbanks,bkcardbankmans,bkcardnos,bkcardids,bkcardbankids,Bkcardbanklogos,bkcardbankphones,bkcardyxmonths,bkcardyxyears,bkcardcvvs,bkcardidcards,bkcardisdefaults,bkcardcardtypes,bkcardbankcode;

-(NSString *)description{
    
    NSString *print= [NSString stringWithFormat:@"bkcardbanks- %@, bkcardbankmans=%@ bkcardnos=%@ bkcardids=%@ bkcardbankids=%@ Bkcardbanklogos=%@ bkcardbankphones=%@ bkcardyxmonths=%@ bkcardyxyears=%@ bkcardcvvs=%@ bkcardidcards=%@ bkcardisdefaults=%@ bkcardcardtypes=%@ bkcardbankcode = %@",bkcardbanks,bkcardbankmans,bkcardnos,bkcardids,bkcardbankids,Bkcardbanklogos,bkcardbankphones,bkcardyxmonths,bkcardyxyears,bkcardcvvs,bkcardidcards,bkcardisdefaults,bkcardcardtypes,bkcardbankcode];

    return print;
}

/*
-(void)dealloc
{
    [super dealloc];
    [bkcardbanks release];
    [bkcardbankmans release];
    [bkcardnos release];
    [bkcardids release];
    [bkcardbankids release];
    [Bkcardbanklogos release];
    [bkcardbankphones release];
    [bkcardyxmonths release];
    [bkcardyxyears release];
    [bkcardcvvs release];
    [bkcardidcards release];
    [bkcardisdefaults release];
    [bkcardcardtypes release];
    [bkcardbankcode release];
}
*/
@end

@implementation NSNumber (MySort)

- (NSComparisonResult) myCompare:(NSString *)other {
 
    int result = ([self intValue]>>1) - ([other intValue]>>1);

    return result < 0 ?NSOrderedDescending : result >0 ?NSOrderedAscending :NSOrderedSame;
}
@end

