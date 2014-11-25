

#import <Foundation/Foundation.h>
#import "Httper.h"
#import "NLProtocolData.h"
#import "ProtocolDefine.h"

@interface ProtocolRequest : NSObject<HTTPResponseDelegate>
{
}

@property(nonatomic,retain) Httper* http;//http对象
@property(nonatomic,retain) NSString* uuid;//流水号
@property(nonatomic,retain) NSMutableArray* actions;//请求的action
@property(nonatomic, readwrite, retain) NSTimer *timeoutTimer;
@property(nonatomic, assign) NLProtocolRequestPostType PostType;
@property(nonatomic, assign) int myLength;

/**
 开始请求一个远程服务
 */
-(NSString*)startRequest:(NLProtocolData*)a action:(NSString*)action;

/**
 开始请求一个错误的远程服务
 */
-(NSString*)startRequestError:(NSString*)action;
/**
 停止一个远程服务
 @parameter flag 停止原因
 */
-(void)stopRequest:(NSString*)flag;

-(NSString*)startRequestWithURL:(NSString *)url content:(NSData *)content;

@end
