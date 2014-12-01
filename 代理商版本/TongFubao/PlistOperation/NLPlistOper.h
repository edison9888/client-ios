//
//  PlistOper.h
//  kvpioneer
//
//  Created by Jiajun Xie on 13-5-6.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NLPlistOper : NSObject

+(id)readValue:(NSString*)key path:(NSString*)path;
+(BOOL)writeValue:(id)value key:(NSString*)key path:(NSString*)path;

@end
