
#import <Foundation/Foundation.h>

@interface RADataObject : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *children;

- (id)initWithName:(NSString *)name children:(NSArray *)array;

+ (id)dataObjectWithName:(NSString *)name children:(NSArray *)children;

@end
