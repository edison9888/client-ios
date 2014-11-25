

#import "HttpBase.h"

@implementation HttpBase

@synthesize connection=_connection;
@synthesize isCancel=_isCancel;

+ (NSURL *)smartURLForString:(NSString *)str
{
    NSURL *     result;
    NSString *  trimmedStr;
    NSRange     schemeMarkerRange;
    NSString *  scheme;
    result = nil;
    
    trimmedStr = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ( (trimmedStr != nil) && (trimmedStr.length != 0) ) {
        schemeMarkerRange = [trimmedStr rangeOfString:@"://"];
        
        if (schemeMarkerRange.location == NSNotFound) {
            result = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", trimmedStr]];
        } else {
            scheme = [trimmedStr substringWithRange:NSMakeRange(0, schemeMarkerRange.location)];            
            if ( ([scheme compare:@"http"  options:NSCaseInsensitiveSearch] == NSOrderedSame)
				|| ([scheme compare:@"https" options:NSCaseInsensitiveSearch] == NSOrderedSame) ) {
                result = [NSURL URLWithString:trimmedStr];
            } else {
                
            }
        }
    }
    
    return result;
}

- (BOOL)requestGet:(NSString*)url  delegate:(id)delegate{
    NSMutableURLRequest * request = [self getRequest:url];
    if (request==nil) {
        return NO;
    }
    [self addParamsToRequest:request];
    return [self sendRequest:request delegate:delegate];
}

- (NSMutableURLRequest*)getRequest:(NSString*)url{
    NSURL * nurl = [HttpBase smartURLForString:url];
    if (nurl == nil) {
        return nil;
    } else {
        return [NSMutableURLRequest requestWithURL:nurl];
    }
}
- (BOOL)sendRequest:(NSURLRequest*)req delegate:(id)delegate
{
    self.connection = [NSURLConnection connectionWithRequest:req delegate:delegate];
    if (self.connection==nil) 
    {
        return NO;
    } 
    else 
    {
        return YES; 
    }
}

- (BOOL)requestPost:(NSString*) url 
            content:(NSData*)cont 
           delegate:(id<NSURLConnectionDataDelegate,NSURLConnectionDelegate>)delegate
{
    // Open a connection for the URL.
    NSMutableURLRequest * request = [self getRequest:url];
    if (request==nil) 
    {
        return NO;
    }
    [self addParamsToRequest:request];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:cont];
    return [self sendRequest:request delegate:delegate];
}

- (void)addParamsToRequest:(NSMutableURLRequest*)req
{
}

- (void)cancel{
    if (self.connection != nil) {
        [self.connection cancel];
        self.connection = nil;
    }
    self.isCancel=YES;
    [self onCancelled];
}

- (void)onCancelled{
    
}
@end
