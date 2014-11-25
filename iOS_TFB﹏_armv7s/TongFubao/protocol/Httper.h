

#import <Foundation/Foundation.h>
#import "HttpBase.h"
#import "HTTPResponseDelegate.h"

@interface Httper : HttpBase<NSURLConnectionDataDelegate,NSURLConnectionDelegate>

@property(nonatomic,retain) NSMutableData* data;
@property(nonatomic,retain) id<HTTPResponseDelegate> delegate;

+(id)httperWithDelegate:(id<HTTPResponseDelegate>)delegate;
-(id)initWithDelegate:(id<HTTPResponseDelegate>)delegate;
-(BOOL)requestGet:(NSString *)url;
-(BOOL)requestPost:(NSString *)url content:(NSData *)cont;
@end
