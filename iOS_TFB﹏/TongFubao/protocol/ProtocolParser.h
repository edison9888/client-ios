

#import <Foundation/Foundation.h>
#import "ProtocolRsp.h"
#import "NLProtocolData.h"

@interface ProtocolParser : NSObject<NSXMLParserDelegate>

/**
 解析xml
 */
+(ProtocolRsp*)parse:(const char*)data length:(int)len;

/**
 多个ProtocolData生成xml
 @parameter as  ProtocolData的数组
 */
+(NSData*)reqArrayToXml:(NSArray*)as needCDATA:(BOOL)cdata;

/**
 单个ProtocolData生成xml
 */
+(NSData*)reqToXml:(NLProtocolData*)a;// needCDATA:(BOOL)cdata;

@end
