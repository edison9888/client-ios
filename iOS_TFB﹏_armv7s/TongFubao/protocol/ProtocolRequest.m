
#import <CommonCrypto/CommonCryptor.h>
#import "ProtocolRequest.h"
#import "ProtocolParser.h"
#import "NLProtocolResponse.h"
#import "ProtocolDefine.h"
#import "HeadInfo.h"
#import "NLUtils.h"
#import "NLContants.h"
#import "AESAdditions.h"


@interface ProtocolRequest(private)
//{
//    int _lenght;
//}

-(NSString*)startRequestForData:(NSData*)data;
-(void)startTimeoutTimer;
-(void)stopTimeoutTimer;
-(void)doTimeout;

/**
 处理服务器返回的,并且已经解密后的xml文档
 */
-(void)processResult:(id)sender data:(NSData*)data error:(NSError*)errorcode;

@end


@implementation ProtocolRequest

@synthesize http = _http;
@synthesize uuid = _uuid;
@synthesize actions = _actions;
@synthesize timeoutTimer = _timeoutTimer;

-(id)init
{
    self=[super init];
    if (self)
    {
        self.uuid = [NLUtils createUUID];
        self.actions = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

-(NSString*)startRequestError:(NSString*)action
{
    [[self actions] addObject:action];
    int error = RSP_HAS_EXIST;
    [self postNotify:nil error:error detail:nil];
    return nil;
}

/*Notify_*/
-(NSString*)startRequest:(NLProtocolData*)a action:(NSString*)action
{
    [[self actions] addObject:action];
    NSData* data=[ProtocolParser reqToXml:a];
    //    NSData* dataA=[ProtocolParser ];
    NLLogNoLocation(@"＝＝＝＝＝＝＝＝＝＝reqToXml=%s", [data bytes]);
    return [self startRequestForData:data];
}

-(NSData*)encrypt:(NSString*)str
{
    NSString* string = [AESAdditions encryptString:str];//加密数据
    //    NSLog(@"encryptString**%@",string);
    NSData* data = [NLUtils stringToData:string];
    //    NSLog(@"stringToData**%@",data);
    return data;
}

//链接
-(NSString*)startRequestForData:(NSData*)data
{
    [self startTimeoutTimer];
    _http=[[Httper alloc] initWithDelegate:self];
    NSString* string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSData* d = [self encrypt:string];
    [self.http requestPost:SERVER_URL content:d];//url接口
    //    NSLog(@"encrypt发字段%@",string);
    //    NLLogNoLocation(@"reqXML = %@",[NLUtils dataToString:data]);
    //[self.http requestPost:SERVER_URL content:data];
    return self.uuid;
}

-(NSString*)startRequestWithURL:(NSString *)url content:(NSData *)content
{
    _http=[[Httper alloc] initWithDelegate:self];
    [self.http requestPost:url content:content];
    return self.uuid;
}

-(void)stopRequest:(NSString*)flag
{
    [self stopTimeoutTimer];
    [self.http cancel];
    int error = RSP_CANCEL;
    [self postNotify:nil error:error detail:nil];
}

#pragma 网络超时的 改过的
-(void)startTimeoutTimer
{
	[self stopTimeoutTimer];
	self.timeoutTimer = [NSTimer scheduledTimerWithTimeInterval: 120//kTimeoutSeconds
                                                         target: self
                                                       selector: @selector(doTimeout)
                                                       userInfo: nil
                                                        repeats: NO];
}

-(void)stopTimeoutTimer
{
	if (self.timeoutTimer != nil && [self.timeoutTimer isValid])
	{
		[self.timeoutTimer invalidate];
	}
}

-(void)doTimeout
{
    if (self.timeoutTimer != nil && [self.timeoutTimer isValid])
	{
		[self.timeoutTimer invalidate];
        [self.http cancel];
        int error = RSP_TIMEOUT;
        [self postNotify:nil error:error detail:@"网络连接超时"];
	}
}

-(void)addParamsToRequest:(NSMutableURLRequest*)req
{
    if (NLProtocolRequestPost_Picture == self.PostType)
    {
        NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",@"0xKhTmLbOuNdArY"];
        //设置HTTPHeader
        [req setValue:content forHTTPHeaderField:@"Content-Type"];
        //设置Content-Length
        [req setValue:[NSString stringWithFormat:@"%d", self.myLength] forHTTPHeaderField:@"Content-Length"];
        //[[HeadInfo headInfo] addHeadParam:req];
    }
}

-(void)processResult:(id)sender data:(NSData*)data error:(NSError*)errorcode
{
    
    [self stopTimeoutTimer];
    if (errorcode==nil&&data!=nil)
    {
        Byte *bytes = (Byte *)[data bytes];
        //NLLogNoLocation(@"rspToXml=%s, byte0 = %d,byte1 = %d,byte2 = %d", [data bytes],bytes[0],bytes[1],bytes[2]); /*2 Q T*/
        NSString* string = [NLUtils dataToString:data];
        if (bytes[0]==239 && bytes[1]==187 && bytes[2]==191)
        {
            string = [string substringFromIndex:3];
        }
        
        NSData* str = [AESAdditions decryptString:string];
        NLLogNoLocation(@"rspToXml = \n    %s", [str bytes]);
        //        NSData* d = [NLUtils dataToString:str];
        //        NLLogNoLocation(@"rspToXml=%s", [data bytes]);
        ProtocolRsp* rsp= [ProtocolParser parse:[str bytes] length:[str length]];
        //        [self showRsp:rsp];
        int error = RSP_NO_ERROR;
        [self postNotify:[rsp.actions objectAtIndex:0] error:error detail:nil];
    }
    else
    {
        int error = RSP_IS_NULL;
        [self postNotify:nil error:error detail:nil];
    }
}

-(void)didFinishLoading:(id)sender data:(NSData*)data error:(NSError*)errorcode
{
    [self processResult:sender data:data error:errorcode];
}

-(void)postNotify:(NLProtocolData*)data error:(int)error detail:(NSString*)detail
{
    NLProtocolResponse* pn = [[NLProtocolResponse alloc] initWithData:data error:error name:nil detail:detail uuid:self.uuid];
    for (NSString* a in self.actions)
    {
        pn.name = [NSString stringWithFormat:@"%@%@",Notify_finished,a];
        POST_NOTIFY_FOR_NAME(a,pn);
        [self.actions removeObject:a];
    }
}

-(void)showRsp:(ProtocolRsp*)rsp
{
    //    for (NLProtocolData* data in rsp.actions)
    {
        NLProtocolData* data = [rsp.actions objectAtIndex:0];
        NLLogNoLocation(@"key = %@, value = %@, attr = %@",data.key,data.value,data.attr);
        int index1 = 1;
        for (NSArray* cs in [data.children allValues])
        {
            for (NLProtocolData* d in cs)
            {
                NLLogNoLocation(@"children = %d,d.key = %@, d.value = %@, d.attr = %@",index1,d.key,d.value,d.attr);
                int index2 = 1;
                for (NSArray* css in [d.children allValues])
                {
                    for (NLProtocolData* dd in css)
                    {
                        NLLogNoLocation(@"children = %d,dd.key = %@, dd.value = %@, dd.attr = %@",index2,dd.key,dd.value,dd.attr);
                        index2++;
                        int index3 = 1;
                        for (NSArray* csss in [dd.children allValues])
                        {
                            for (NLProtocolData* ddd in csss)
                            {
                                NLLogNoLocation(@"children = %d,ddd.key = %@, ddd.value = %@, ddd.attr = %@",index3,ddd.key,ddd.value,ddd.attr);
                                index3++;
                            }
                        }
                    }
                }
                index1++;
            }
        }
    }
}


@end
