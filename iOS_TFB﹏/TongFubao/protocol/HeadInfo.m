

#import "HeadInfo.h"


static HeadInfo* gHeadInfo=nil;

@implementation HeadInfo

-(id)init
{
    self = [super init];
    if (self) 
    {
    }
    return self;
}

+(id)headInfo
{
    if (gHeadInfo==nil) 
    {
        gHeadInfo=[[HeadInfo alloc] init];
    }
    return gHeadInfo;
}

-(void)addHeadParam:(NSMutableURLRequest*)req
{
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",@"0xKhTmLbOuNdArY"];
    //设置HTTPHeader
    [req setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
//    [request setValue:[NSString stringWithFormat:@"%d", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
}
@end
