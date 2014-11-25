

#import <Foundation/Foundation.h>

@class NLProtocolData;

@interface ProtocolRsp : NSObject

@property(nonatomic,assign) int code;//错误码
@property(nonatomic,retain) NSArray* actions;//ProtocolData数组

@end
