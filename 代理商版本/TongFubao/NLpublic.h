//
//  NLpublic.h
//  TongFubao
//
//  Created by ec on 14-9-4.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDXML.h"
#import "DDXMLElementAdditions.h"
#import "AFNetworking.h"
#import "NLUtils.h"
#import "AESAdditions.h"
#import "ASIHTTPRequest.h"

#import <zlib.h>

typedef enum
{
    PublicList = 0,
    PublicCommon = 1
}PublicType;

@interface NLpublic : NSObject <ASIHTTPRequestDelegate>

- (NSData *)encrypt:(NSString *)str;

- (NSString *)decrypt:(NSString *)data;

- (NSMutableArray *)xml_TO_dictionary_child:(NSData*)data :(NSString *)rolePath;

- (id)xml_TO_dictionary:(NSData *)data rolePath:(NSString *)rolePath type:(PublicType)type;

- (NSString *)msgbody:(NSDictionary *)input api_name:(NSString *)api_name api_name_func:(NSString *)api_name_func;

@end
