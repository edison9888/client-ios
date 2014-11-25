//
//  Person.m
//  Person
//
//  Created by 〝Cow﹏. on 14-7-3.
//  Copyright (c) 2014年 〝Cow﹏. All rights reserved.
//

#import "Person.h"

#define mnuorderkey    @"mnuorder"
#define mnunoKey       @"mnuno"
#define mnutypenameKey @"mnutypename"
#define mnunameKey     @"mnuname"
#define mnutypeidKey   @"mnutypeid"
#define mnuisconstKey  @"mnuisconst"
#define mnuidKey       @"mnuid"
#define pointnumKey    @"pointnum"
#define mainviewKey    @"mainview"

@implementation Person
@synthesize mnuid,mnuisconst,mnutypeid,mnutypename,pointnum,mnuname,mnuno,mnuorder;

-(NSString *)description{
    
    NSString *print= [NSString stringWithFormat:@"mnutypeid- %@, mnutypename=%@ mnuisconst=%@ mnuid=%@ pointnum=%@ mnuname=%@ mnuno=%@ mnuorder=%@ ",mnutypeid,mnutypename,mnuisconst,mnuid,pointnum,mnuname,mnuno,mnuorder];
    return print;
}


/*单个归档*/
#pragma mark-NSCoding
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:mnuorder forKey:mnuorderkey];
    [aCoder encodeObject:mnuno forKey:mnunoKey];
    [aCoder encodeObject:mnutypename forKey:mnutypenameKey];
    [aCoder encodeObject:mnuname forKey:mnunameKey];
    [aCoder encodeObject:mnutypeid forKey:mnutypeidKey];
    [aCoder encodeObject:mnuisconst forKey:mnuisconstKey];
    [aCoder encodeObject:mnuid forKey:mnuidKey];
    [aCoder encodeObject:pointnum forKey:pointnumKey];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self == [super init]) {
        mnuorder    =  [aDecoder decodeObjectForKey:mnuorderkey];
        mnuno       =  [aDecoder decodeObjectForKey:mnunoKey];
        mnutypename =  [aDecoder decodeObjectForKey:mnutypenameKey];
        mnuname     =  [aDecoder decodeObjectForKey:mnunameKey];
        mnutypeid   =  [aDecoder decodeObjectForKey:mnutypeidKey];
        mnuisconst  =  [aDecoder decodeObjectForKey:mnuisconstKey];
        mnuid       =  [aDecoder decodeObjectForKey:mnuidKey];
        pointnum    =  [aDecoder decodeObjectForKey:pointnumKey];
      }
    return self;
}

#pragma mark-NSCopying
-(id)copyWithZone:(NSZone *)zone{
    Person *copy     = [[[self class] allocWithZone:zone] init];
    copy.mnuorder    = [self.mnuorder copyWithZone:zone];
    copy.mnuno       = [self.mnuno copyWithZone:zone];
    copy.mnutypename = [self.mnutypename copyWithZone:zone];
    copy.mnuname     = [self.mnuname copyWithZone:zone];
    copy.mnutypeid   = [self.mnutypeid copyWithZone:zone];
    copy.mnuisconst  = [self.mnuisconst copyWithZone:zone];
    copy.mnuid       = [self.mnuid copyWithZone:zone];
    copy.pointnum    = [self.pointnum copyWithZone:zone];
    return copy;
}

-(void)dealloc
{
    [mnuorder release];
    [mnuno release];
    [mnutypename release];
    [mnuname release];
    [mnutypeid release];
    [mnuisconst release];
    [mnuid release];
    [pointnum release];
    [super dealloc];
}

@end

@implementation BankPayList

@synthesize bkcardbanks,bkcardbankmans,bkcardnos,bkcardids,bkcardbankids,Bkcardbanklogos,bkcardbankphones,bkcardyxmonths,bkcardyxyears,bkcardcvvs,bkcardidcards,bkcardisdefaults,bkcardcardtypes,bkcardbankcode,bkcardisdefaultpayment;

-(NSString *)description{
    
    NSString *print= [NSString stringWithFormat:@"bkcardbanks- %@, bkcardbankmans=%@ bkcardnos=%@ bkcardids=%@ bkcardbankids=%@ Bkcardbanklogos=%@ bkcardbankphones=%@ bkcardyxmonths=%@ bkcardyxyears=%@ bkcardcvvs=%@ bkcardidcards=%@ bkcardisdefaults=%@ bkcardcardtypes=%@ bkcardbankcode = %@ bkcardisdefaultpayment = %@",bkcardbanks,bkcardbankmans,bkcardnos,bkcardids,bkcardbankids,Bkcardbanklogos,bkcardbankphones,bkcardyxmonths,bkcardyxyears,bkcardcvvs,bkcardidcards,bkcardisdefaults,bkcardcardtypes,bkcardbankcode,bkcardisdefaultpayment];

    return print;
}

/*
-(void)dealloc
{
    [super dealloc];
    [bkcardbanks release];
    [bkcardbankmans release];
    [bkcardnos release];
    [bkcardids release];
    [bkcardbankids release];
    [Bkcardbanklogos release];
    [bkcardbankphones release];
    [bkcardyxmonths release];
    [bkcardyxyears release];
    [bkcardcvvs release];
    [bkcardidcards release];
    [bkcardisdefaults release];
    [bkcardcardtypes release];
    [bkcardbankcode release];
}
 //先取不重复的子集，然后计算总和
 
 //注意@distinctUnionOfObjects和@sum不能直接在一个keyPath中连接，所以需要两次调用valueForKeyPath
 NSArray *array = @[@1, @2, @2, @2, @2, @3];
 
 NSLog(@"%@", [[array valueForKeyPath:@"@distinctUnionOfObjects.self"]valueForKeyPath:@"@sum.self"]);
*/
@end

/*发工资*/
@implementation WageInfo
@synthesize wagemonth;

-(NSString *)description{
    
    NSString *print= [NSString stringWithFormat:@"wagemonth=%@",wagemonth];
    return print;
}

-(void)dealloc
{
    [wagemonth release];
    [super dealloc];
}

@end

@implementation NSNumber (MySort)

- (NSComparisonResult) myCompare:(NSString *)other {
 
    int result = ([self intValue]>>1) - ([other intValue]>>1);

    return result < 0 ?NSOrderedDescending : result >0 ?NSOrderedAscending :NSOrderedSame;
}
@end


@implementation opHttpsRequest

+ (SecIdentityRef)identityWithTrust

{
    
    SecIdentityRef identity = NULL;
    
    SecTrustRef trust = NULL;
    
    //绑定证书，证书放在Resources文件夹中
    
    //NSData *PKCS12Data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"yunwei" ofType:@"p12"]];//证书文件名和文件类型
    
    NSData *PKCS12Data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"yunwei" ofType:@"p12"]];//证书文件名和文件类型
    
    if (!PKCS12Data) {
        
        //没有文件证书
        
        NSLog(@"Can not load pkcs12 cert , plz check !");
        
        return nil;
        
    }
    
    //NSLog(@"pkcs12Data is %@",PKCS12Data);
    
    [[self class] extractIdentity:&identity andTrust:&trust fromPKCS12Data:PKCS12Data];
    
    return identity;
    
}

+ (SecIdentityRef)identityWithCert

{
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"yunwei" ofType:@"p12"];
    
    NSData *p12data = [NSData dataWithContentsOfFile:path];
    
    SecIdentityRef identity = NULL; SecCertificateRef certificate = NULL;
    
    if (!p12data) {
        
        //没有文件证书
        
        NSLog(@"Can not load pkcs12 cert , plz check !");
        
        return nil;
        
    }
    
    [[self class] identity:&identity andCertificate:&certificate fromPKCS12Data:p12data];
    
    //NSArray *certArray = [NSArray arrayWithObject:(id)certificate];
    
    //NSLog(@"cert array is %@",certArray);
    
    return identity;
    
}

+ (BOOL)extractIdentity:(SecIdentityRef *)outIdentity andTrust:(SecTrustRef*)outTrust fromPKCS12Data:(NSData *)inPKCS12Data

{
    
    OSStatus securityError = errSecSuccess;
    
    NSDictionary *optionsDictionary = [NSDictionary dictionaryWithObject:@"1234" forKey:(__bridge id)kSecImportExportPassphrase];
    
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL); securityError = SecPKCS12Import((__bridge CFDataRef)inPKCS12Data,(__bridge CFDictionaryRef)optionsDictionary,&items);
    
    if (securityError == 0) {
        
        CFDictionaryRef myIdentityAndTrust = CFArrayGetValueAtIndex (items, 0);
        
        const void *tempIdentity = NULL;
        
        tempIdentity = CFDictionaryGetValue (myIdentityAndTrust, kSecImportItemIdentity);
        
        *outIdentity = (SecIdentityRef)tempIdentity;
        
        const void *tempTrust = NULL;
        
        tempTrust = CFDictionaryGetValue (myIdentityAndTrust, kSecImportItemTrust);
        
        *outTrust = (SecTrustRef)tempTrust;
        
    } else {
        
        NSLog(@"SSSSLLLL Failed with error code %d",(int)securityError);
        
        return NO;
        
    }
    
    return YES;
    
}

+ (BOOL)identity:(SecIdentityRef *)outIdentity andCertificate:(SecCertificateRef*)outCert fromPKCS12Data:(NSData *)inPKCS12Data

{
    
    //NSLog(@"验证证书");
    
    OSStatus securityError = errSecSuccess;
    
    NSDictionary *optionsDictionary = [NSDictionary dictionaryWithObject:@"1234" forKey:(__bridge id)kSecImportExportPassphrase];
    
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL); securityError = SecPKCS12Import((__bridge CFDataRef)inPKCS12Data,(__bridge CFDictionaryRef)optionsDictionary,&items);
    
    if (securityError == 0) {
        
        CFDictionaryRef myIdentityAndTrust = CFArrayGetValueAtIndex (items, 0);
        
        const void *tempIdentity = NULL;
        
        tempIdentity = CFDictionaryGetValue (myIdentityAndTrust, kSecImportItemIdentity);
        
        *outIdentity = (SecIdentityRef)tempIdentity;
        
        const void *tempCert = NULL;
        
        tempCert = CFDictionaryGetValue (myIdentityAndTrust, kSecImportItemCertChain);
        
        *outCert = (SecCertificateRef)tempCert;
        
    } else {
        
        NSLog(@"SSSSLLLL Failed with error code %d",(int)securityError);
        
        return NO;
        
    }
    
    //NSLog(@"验证完毕");
    
    return YES;
    
}

@end

#define kOpCenterAPI_url @"https://pay.expresspay.cn/Paygateway/recharge/mobCardRecharge.do"

@implementation opURLProtocal
{
    //可以在此定义数据容器，连接等
}
static NSString *cachingURLHeader = @"hadInURLProtocal";
- (void)startLoading
{
    //NSLog(@"1.start loading");
    //可以这样子拿到原来的请求，用以拼装自己的请求
    NSMutableURLRequest *proxyRequest = [self.request mutableCopy];
    //NSLog(@"protocal url is %@",[[proxyRequest URL] absoluteString]);
    [proxyRequest setValue:@"" forHTTPHeaderField:cachingURLHeader];
    //connection = [NSURLConnection connectionWithRequest:proxyRequest delegate:self];
    connection = [[NSURLConnection alloc] initWithRequest:proxyRequest delegate:self startImmediately:NO];
    [connection start];
}

- (void)stopLoading
{
    //请求在这里该结束了，在此终止自己的请求吧
    //NSLog(@"stop it");
    [connection cancel];
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    //NSLog(@"2.in willSendRequest");
    if(response!=nil)
    {
        NSMutableURLRequest *redirectableRequest = [request mutableCopy];
        [redirectableRequest setValue:nil forHTTPHeaderField:cachingURLHeader];
        [self.client URLProtocol:self wasRedirectedToRequest:redirectableRequest redirectResponse:response];
        return redirectableRequest ;
    }
    return request;
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    //NSLog(@"3.We are checking protection Space!");
    return YES;
    if([protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
    {
        //NSLog(@"Can Auth Secure Requestes!");
        return YES;
    }
    else if([protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodHTTPBasic])
    {
        //NSLog(@"Can Auth Basic Requestes!");
        return YES;
        //return NO;
    }
    NSLog(@"Cannot Auth!");
    return NO;
    
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
// A CustomHTTPProtocol delegate callback, called when the protocol has an authenticate
// challenge that the delegate accepts via - customHTTPProtocol:canAuthenticateAgainstProtectionSpace:.
// In this specific case it's only called to handle server trust authentication challenges.
// It evaluates the trust based on both the global set of trusted anchors and the list of trusted
// anchors returned by the CredentialsManager.
{
    //NSLog(@"4.!!!!!!!!!!!! didReceiveAuthenticationChallenge method");
    OSStatus err;
    NSURLCredential * credential;
    
    assert(challenge != nil);
    
    credential = nil;
    
    // Handle ServerTrust and Client Certificate challenges
    
    NSString *authenticationMethod = [[challenge protectionSpace] authenticationMethod];
    if ([authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        //NSLog(@"Trust Challange");
        SecTrustResultType trustResultType;
        err = SecTrustEvaluate(challenge.protectionSpace.serverTrust, &trustResultType);
        
        //NSLog(@"SecTrustResult %u %d",trustResultType, (int)err);
        
        if (trustResultType == kSecTrustResultProceed || trustResultType == kSecTrustResultUnspecified) {
            credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            assert(credential != nil);
        }
    } else {
        //NSLog(@"self signed trust challange");
        
        credential = [NSURLCredential credentialWithIdentity:[opHttpsRequest identityWithCert] certificates:nil persistence:NSURLCredentialPersistencePermanent]; //到呢一步，certificates需要喺nil先过到
    }
    //NSLog(@"credential is %@",credential);
    [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
    //[protocol resolveAuthenticationChallenge:challenge withCredential:credential];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //这里是收到响应的头部信息，比如HTTP Header，可视情况做对self.client做相应操作，也可以不做处理
    //NSLog(@"5.didReceiveResponse lalala");
    //NSLog(@"response is %@",response);
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

//这几个不是Protocol的方法，是自发起的URLConnection的回调
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)sourceData
{
    //NSLog(@"sourceData is %@",sourceData);
    //此方法会收到一部分或者全部的数据，可以这样子丢给原始请求的发起者
    //NSLog(@"6.in didReceiveData method");
    if (proRespData == nil) {
        proRespData = [sourceData mutableCopy];
    } else {
        [proRespData appendData:sourceData];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //和上一个方法类似，这里作为错误通知
    //NSLog(@"7.1in didFailWithError method %@",error);
    [self.client URLProtocol:self didFailWithError:error];
    //这里可以弹出一个错误提示
//    [toastView hideToast];
//    NSString *msg = [@"网络错误 - " stringByAppendingString:[error description]];
//    [toastView showToastWithOK:msg];
    return;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //自己的请求加载完成了，这样子可以通知self.client
    //[self.client URLProtocolDidFinishLoading:self];
    //NSString *proRespStr = [[NSString alloc] initWithData:proRespData encoding:1];
    //NSData *sourceData = [NSData dataWithBase64EncodedString:proRespStr];
    //NSLog(@"8.in connectionDidFinishLoading method");
    NSData *getData = proRespData ;
    [self.client URLProtocol:self didLoadData:getData];
    [self.client URLProtocolDidFinishLoading:self];
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    //根据request来决定要不要劫持
    //需要特别注意的是，如果你用NSURLConnection来发起代理请求，那么那个代理请求的request也同样会经过这里来做判决，所以一定要判断是不是代理请求，然后返回NO
    if ([request.URL.absoluteString rangeOfString:kOpCenterAPI_url].location != NSNotFound && [request valueForHTTPHeaderField:cachingURLHeader] == nil) return YES;
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    //这里是干嘛的，我还没研究清楚，就简单的返回了原始值，有兴趣的话你可以研究一下
    return request;
}

/*
 + (BOOL)identity:(SecIdentityRef *)outIdentity andCertificate:(SecCertificateRef*)outCert fromPKCS12Data:(NSData *)inPKCS12Data
 {
 //NSLog(@"验证证书");
 OSStatus securityError = errSecSuccess;
 
 NSDictionary *optionsDictionary = [NSDictionary dictionaryWithObject:@"1234" forKey:(id)kSecImportExportPassphrase];
 
 CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
 securityError = SecPKCS12Import((CFDataRef)inPKCS12Data,(CFDictionaryRef)optionsDictionary,&items);
 
 if (securityError == 0) {
 CFDictionaryRef myIdentityAndTrust = CFArrayGetValueAtIndex (items, 0);
 const void *tempIdentity = NULL;
 tempIdentity = CFDictionaryGetValue (myIdentityAndTrust, kSecImportItemIdentity);
 *outIdentity = (SecIdentityRef)tempIdentity;
 const void *tempCert = NULL;
 tempCert = CFDictionaryGetValue (myIdentityAndTrust, kSecImportItemCertChain);
 *outCert = (SecCertificateRef)tempCert;
 } else {
 NSLog(@"SSSSLLLL Failed with error code %d",(int)securityError);
 return NO;
 }
 //NSLog(@"验证完毕");
 return YES;
 }
 */

@end

