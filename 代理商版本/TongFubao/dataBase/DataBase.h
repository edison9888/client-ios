

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DataBase : NSObject
{
	sqlite3* database_;
}
@property(nonatomic,readonly) BOOL isOpen;//数据库是否打开

/**
 初始化指定的数据库,参数为相对数据库文件名,如果数据库存在,则打开数据库,如果数据库不存在,则创建数据库,并调用createTable函数,创建表,索引等.如果要创建表,createTable需要子类继承实现
 */
-(id) initWithName:(NSString*)name;
-(bool) openDataStore:(NSString*)name;
-(void) closeDataStore;
/**
 创建表
 */
-(bool)createTable;
@end
