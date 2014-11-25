

#import <Foundation/Foundation.h>

@interface HttpBase : NSObject
@property (nonatomic, retain) NSURLConnection * connection;
@property (nonatomic, assign) BOOL isCancel;

/**
 发送http GET请求
 */
- (BOOL)requestGet:(NSString*) url  delegate:(id<NSURLConnectionDataDelegate,NSURLConnectionDelegate>)delegate;
/**
 发送http POST请求
 */
- (BOOL)requestPost:(NSString*) url content:(NSData*)cont delegate:(id<NSURLConnectionDataDelegate,NSURLConnectionDelegate>)delegate;
/**
 通过url字符串生成URLRequest对象
 */
- (NSMutableURLRequest*)getRequest:(NSString*)url;
- (BOOL)sendRequest:(NSURLRequest*)req delegate:(id<NSURLConnectionDataDelegate,NSURLConnectionDelegate>)delegate;
/**
 取消请求
 */
- (void)cancel;
/**
 取消请求后调用该函数
 */
- (void)onCancelled;
/**
 分析URL地址,并声称NSURL对象
 */
+ (NSURL *)smartURLForString:(NSString *)str;
/**
 添加HTTP头信息
 */
- (void)addParamsToRequest:(NSMutableURLRequest*)req;
@end
