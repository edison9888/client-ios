

#import "NLProtocolResponse.h"

@implementation NLProtocolResponse

@synthesize errcode=_errcode;
@synthesize name = _name;
@synthesize detail=_detail;
@synthesize data=_data;
@synthesize uuid=_uuid;


-(id)initWithData:(NLProtocolData*)data error:(int)errcode name:(NSString*)name detail:(NSString*)detail uuid:(NSString *)uuid
{
    self.data=data;
    self.errcode=errcode;
    self.name = name;
    self.detail=detail;
    self.uuid=uuid;
    return self;
}
@end
