

typedef enum
{
    NLProtocolDataValueNoCData = 0,
    NLProtocolDataValueCData
} NLProtocolDataValueType;

#import <Foundation/Foundation.h>

@interface NLProtocolData : NSObject

@property(nonatomic,retain) NSString* key;
@property(nonatomic,retain) NSString* attr;
@property(nonatomic,retain) NSString* attrName;
@property(nonatomic,retain) NSString* value;
@property(nonatomic,assign) NLProtocolDataValueType valueType;
@property(nonatomic,retain) NSMutableDictionary* children;

-(id)initValue:(NSString*)value
        forKey:(NSString*)key
          attr:(NSString*)attr
      attrName:(NSString*)attrName
     valueType:(NLProtocolDataValueType)valueType;
/**
 添加child
 */
-(NLProtocolData*)addChild:(NLProtocolData*)child;
-(NSArray*)getChildren:(NSString*)key;
-(NLProtocolData*)getChild:(NSString*)key index:(int)i;
/**
 根据路径查找节点,路径格式:/info/a
 @return NLProtocolData的数组
 */
-(NSArray*)find:(NSString*)path;
/**
 根据路径查找节点,路径格式:/info/a,并返回指定序号的节点
 @return NLProtocolData对象
 */
-(NLProtocolData*)find:(NSString*)path index:(int)i;

@end
