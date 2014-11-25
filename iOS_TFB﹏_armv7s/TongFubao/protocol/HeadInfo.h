

#import <Foundation/Foundation.h>

@interface HeadInfo : NSObject


+(id)headInfo;

/**
 向http请求的头中添加参数
 */
-(void)addHeadParam:(NSMutableURLRequest*)req;

@end
