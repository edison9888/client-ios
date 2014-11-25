

#import <Foundation/Foundation.h>

@protocol HTTPResponseDelegate <NSObject>
@required
/**
 http请求完成时调用该接口
 */
-(void)didFinishLoading:(id)sender data:(NSData*)data error:(NSError*)errorcode;

@optional
/**
 收到http头信息时的调用接口
 */
-(BOOL)didReceiveResponse:(id)sender head:(NSHTTPURLResponse*)rsp;
/**
 添加HTTP头的调用接口
 */
- (void)addParamsToRequest:(NSMutableURLRequest*)req;
@end
