

#import "AppRecord.h"

@implementation AppRecord

@synthesize appName;
@synthesize appIcon;
@synthesize imageURLString;
@synthesize artist;
@synthesize appURLString;

- (void)dealloc
{
    [appName release];
    [appIcon release];
    [imageURLString release];
	[artist release];
    [appURLString release];
    
    [super dealloc];
}
//编码，当对象需要保存自身时调用
-(void)encodeWithCoder:(NSCoder*)coder{
	[coder encodeObject:self.appName forKey:@"appName"];
	[coder encodeObject:self.appIcon forKey:@"appIcon"];
	[coder encodeObject:self.imageURLString forKey:@"imageURLString"];
	[coder encodeObject:self.artist forKey:@"artist"];
	[coder encodeObject:self.appURLString forKey:@"appURLString"];
	
}
//解码并初始化，当对象需要加载自身时调用
-(id)initWithCoder:(NSCoder *)coder{
	if(self=[super init]){
		self.appName=[coder decodeObjectForKey:@"appName"];
		self.appIcon=[coder decodeObjectForKey:@"appIcon"];
		self.imageURLString=[coder decodeObjectForKey:@"imageURLString"];
		self.artist=[coder decodeObjectForKey:@"artist"];
		self.appURLString=[coder decodeObjectForKey:@"appURLString"];
	}
	return self;
}


@end











