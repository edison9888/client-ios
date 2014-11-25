

#import "Httper.h"
#import "NLContants.h"

@implementation Httper

@synthesize data=_data;
@synthesize delegate=_delegate;

+(id)httperWithDelegate:(id<HTTPResponseDelegate>)delegate
{
    return [[Httper alloc] initWithDelegate:delegate];
}

-(id)initWithDelegate:(id<HTTPResponseDelegate>)delegate
{
    self.data = [NSMutableData dataWithLength:0];
    self.delegate=delegate;
    return self;
}

- (void)addParamsToRequest:(NSMutableURLRequest*)req
{

    if ([self.delegate respondsToSelector:@selector(addParamsToRequest:)] == YES )
    {
        [self.delegate addParamsToRequest:req];
    }
}

-(BOOL)requestGet:(NSString *)url
{
    return [self requestGet:url delegate:self];
}

-(BOOL)requestPost:(NSString *)url content:(NSData *)cont
{
    return [self requestPost:url content:cont delegate:self];
}

//#pragma NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (self.isCancel) 
    {
        return;
    }
    NSHTTPURLResponse* httprsp=(NSHTTPURLResponse*)response;
    BOOL isContinun=NO;
    if ([self.delegate respondsToSelector:@selector(didReceiveResponse:head:)]== NO ){
        
        if(httprsp.statusCode>=200&&httprsp.statusCode<300){
            isContinun=YES;
        }
    }
    else 
    {
        isContinun=[self.delegate didReceiveResponse:self head:httprsp];
    }
    if (isContinun) 
    {
        NSString *lengthNumber=(NSString*)[httprsp.allHeaderFields objectForKey:@"Content-Length"];
        NSUInteger contentLength = [lengthNumber intValue];
        if (contentLength==0) 
        {
            self.data=[NSMutableData dataWithCapacity:1024];
        }
        else 
        {
            self.data=[NSMutableData dataWithCapacity:contentLength];
        }
    }
    else 
    {
    
        NSError* error=[NSError errorWithDomain:[NSString stringWithFormat:@"错误http头信息:%d",httprsp.statusCode] code:-1 userInfo:nil];
        [[self delegate] didFinishLoading:self data:nil error:error];
        [self.data setLength:0];
        [self cancel];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //NLLogNoLocation(@"%s", [data bytes]);
    [self.data appendData:data];
}

- (void)connection:(NSURLConnection *)connection   
   didSendBodyData:(NSInteger)bytesWritten
 totalBytesWritten:(NSInteger)totalBytesWritten
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    if (self.isCancel)
    {
        return;
    }
    [[self delegate] didFinishLoading:self data:self.data error:nil];
    self.data = nil;
    [self cancel];
}

//#pragma NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (self.isCancel) 
    {
        return;
    }
    [[self delegate] didFinishLoading:self data:nil error:error];
    self.data = nil;
    [self cancel];
}

-(void)onCancelled
{
    self.delegate=nil;
}
@end
