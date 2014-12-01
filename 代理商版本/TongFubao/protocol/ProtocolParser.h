

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ProtocolRsp.h"
#import "NLProtocolData.h"
#import "AppRecord.h"

@protocol NSXMLParserDelegate;

@interface ProtocolParser : NSObject<NSXMLParserDelegate>
{
    BOOL            storingCharacterData;
    AppRecord       *workingEntry;
    NSMutableArray  *workingArray;
    NSMutableString *workingPropertyString;
}
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

















