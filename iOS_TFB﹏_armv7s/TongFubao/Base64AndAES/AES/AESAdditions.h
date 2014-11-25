//
//  AESAdditions.h
//  kvpioneer
//
//  Created by wu wangchun on 12-6-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AESAdditions : NSObject

+(NSString*)encryptString:(NSString*)src;
+(NSData*)encryptData:(NSData *)src;
+(NSData*)encrypt:(const void*)src length:(int)len;
+(NSData*)encrypt:(const void*)src length:(int)len key:(const char*)keyPtr;

+(NSData*)decryptString:(NSString*)src;
+(NSData*)decryptData:(NSData *)src;
+(NSData*)decrypt:(const void*)src length:(int)len;
+(NSData*)decrypt:(const void*)src length:(int)len key:(const char*)keyPtr;
+(NSString*)randIV;

@end
