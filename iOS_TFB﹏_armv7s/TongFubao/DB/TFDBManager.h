

#import <Foundation/Foundation.h>

@interface TFDBManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+(TFDBManager *)shareInstance;

-(void)loadDB;

- (void)saveContext;

//create object
-(NSManagedObject *)createObjectWithEntityName:(NSString*)entityName;

//Fetch objects
-(NSArray*)fetchObjectsWithEntityName:(NSString*)entityName;
-(NSArray*)fetchObjectsWithEntityName:(NSString*)entityName filter:(NSPredicate*)filter;
-(NSArray*)fetchObjectsWithEntityName:(NSString*)entityName sort:(NSArray*)descriptor;
-(NSArray*)fetchObjectsWithEntityName:(NSString*)entityName filter:(NSPredicate *)filter sort:(NSArray*)descriptor;
-(NSArray*)fetchObjectsWithEntityName:(NSString*)entityName filter:(NSPredicate *)filter sort:(NSArray*)descriptors pageCount:(int)count index:(int)index;

//Delete object
-(void)deleteObjectsWithEntityName:(NSString*)entityName filter:(NSPredicate*)filter;
//Batch delete
-(void)batchDeleteObjectsWithEntityName:(NSString*)entityName filter:(NSPredicate*)filter;

//Update object
-(void)updateObjectsWithEntityName:(NSString*)entityName infor:(NSDictionary*)infor filter:(NSPredicate*)filter;

//获取记录条数
-(NSUInteger)getRecordCountWithEntityName:(NSString*)entityName filter:(NSPredicate*)filter;

@end
