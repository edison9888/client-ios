

#import "NLProtocolData.h"

@implementation NLProtocolData

@synthesize key=_key;
@synthesize attr = _attr;
@synthesize value=_value;
@synthesize children=_children;


-(id)initValue:(NSString*)value
        forKey:(NSString*)key
          attr:(NSString*)attr
      attrName:(NSString*)attrName
     valueType:(NLProtocolDataValueType)valueType
{
    self.key = key;
    self.value = value;
    self.attr = attr;
    self.attrName = attrName;
    self.valueType = valueType;
    
    return self;
}

//数据的请求并取里面key
- (NLProtocolData *)addChild:(NLProtocolData *)child
{
    if (self.children == nil)
    {
        self.children = [NSMutableDictionary dictionaryWithCapacity:30];
    }
    
    NSMutableArray* array = [self.children objectForKey:child.key];
    
    if(array == nil)
    {
        array = [NSMutableArray arrayWithCapacity:1];
        [self.children setValue:array forKey:child.key];
    }
    
    [array addObject:child];
    
    return child;
}

- (NSArray *)getChildren:(NSString *)key
{
     return [self.children objectForKey:key];
}

- (NLProtocolData *)getChild:(NSString *)key index:(int)i
{
    NSArray *child = [self getChildren:key];
    
    if ([child count] > i)
    {
        return [child objectAtIndex:i];
    }
    else 
    {
        return nil;
    }
}

- (NSArray *)find:(NSString *)path
{
    // TODO Auto-generated method stub
    NSRange pos=[path rangeOfString:@"/"];
    NSString *temp=path;
    
    if (pos.location == 0)
    {
        temp = [path substringFromIndex:pos.location+1];
        pos = [temp rangeOfString:@"/"];
    }
    if (pos.location >= [temp length])
    {
        return [self getChildren:temp];
    }
    else if (pos.location > 0)
    {
        NSString *cur = nil;
        cur = [temp substringToIndex:pos.location];
        
        if (self.children != nil)
        {
            NSArray *res = [self.children objectForKey:cur];
            
            if (res == nil || [res count] == 0)
            {
                return nil;
            }
            else
            {
                temp = [temp substringFromIndex:pos.location];
                NSMutableArray *datas = [NSMutableArray arrayWithCapacity:4];
                
                for (NLProtocolData* protocolData in res) 
                {
                    NSArray *t=[protocolData find:temp];
                    
                    if (t != nil && [t count] > 0)
                    {
                        for (NLProtocolData *d in t)
                        {
                            [datas addObject:d];
                        }
                    }
                }
                if ([datas count] > 0)
                {
                    return datas;
                }
                else
                {
                    return nil;
                }
            }
        }
        else
        {
            return nil;
        }
    }
    else
    {
        return nil;
    }
}

- (NLProtocolData *)find:(NSString *)path index:(int)i
{
    return [[self find:path] objectAtIndex:i];
}

@end
