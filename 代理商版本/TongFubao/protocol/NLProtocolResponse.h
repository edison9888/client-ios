

#import <Foundation/Foundation.h>
#import "NLProtocolData.h"

@interface NLProtocolResponse : NSObject

@property(nonatomic,assign) int errcode;//错误码
@property(nonatomic,retain) NSString* name;//接口名字
@property(nonatomic,retain) NSString* detail;//错误描述
@property(nonatomic,retain) NLProtocolData* data;//接口中a的结构
@property(nonatomic,retain) NSString* uuid;//请求的流水号

-(id)initWithData:(NLProtocolData*)data error:(int)errcode name:(NSString*)name detail:(NSString*)detail uuid:(NSString*)uuid;

@end
