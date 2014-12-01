

#import "TFDBManager.h"

@implementation TFDBManager

static TFDBManager *dbManager = nil;

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        _managedObjectContext.undoManager = nil;
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Record" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Record.sqlite"];
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - save context

- (void)saveContext{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

+(TFDBManager *)shareInstance{
    static dispatch_once_t dbManagerOnceToken;
    dispatch_once(&dbManagerOnceToken, ^{
        if (!dbManager) {
            dbManager = [[self alloc] init];
        }
    });
    return dbManager;
}

+(id)allocWithZone:(NSZone *)zone{
    @synchronized(self){
        if (!dbManager) {
            dbManager = [super allocWithZone:zone];
        }
    }
    return dbManager;
}

#pragma mark - user methods
//加载数据库
-(void)loadDB{
    static BOOL beLoadDB = YES;
    
    if (!beLoadDB) {
        return;
    }
    
    [self persistentStoreCoordinator];
}

#pragma mark - db methods
//创建一个对象
-(NSManagedObject *)createObjectWithEntityName:(NSString *)entityName{
    @try {
        NSManagedObjectContext *context = [self managedObjectContext];
        NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
        return object;
    }
    @catch (NSException *exception) {
        DLog(@"Create NSManagedObject exception : %@", [exception description]);
        return nil;
    }
}

//查询数据
-(NSArray*)fetchObjectsWithEntityName:(NSString *)entityName{
    if (!entityName) {
        return nil;
    }
    
    return [self fetchObjectsWithEntityName:entityName filter:nil];
}

-(NSArray*)fetchObjectsWithEntityName:(NSString *)entityName filter:(NSPredicate *)filter{
    return [self fetchObjectsWithEntityName:entityName filter:filter sort:nil];
}

-(NSArray*)fetchObjectsWithEntityName:(NSString *)entityName sort:(NSArray *)descriptor{
    return [self fetchObjectsWithEntityName:entityName filter:nil sort:descriptor];
}

-(NSArray*)fetchObjectsWithEntityName:(NSString *)entityName filter:(NSPredicate *)filter sort:(NSArray *)sortDescriptors{
    return  [self fetchObjectsWithEntityName:entityName filter:filter sort:sortDescriptors pageCount:0 index:0];
}

-(NSArray*)fetchObjectsWithEntityName:(NSString *)entityName filter:(NSPredicate *)filter sort:(NSArray *)descriptors pageCount:(int)count index:(int)index{
    NSArray *result = nil;
    @try {
        NSManagedObjectContext *context = [self managedObjectContext];
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
        
        if (filter) {
            [fetchRequest setPredicate:filter];
        }
        
        if ([descriptors count] > 0) {
            [fetchRequest setSortDescriptors:descriptors];
        }
        
        if (count > 0 && index >= 0) {
            [fetchRequest setFetchLimit:count];
            [fetchRequest setFetchOffset:index];
        }
        
        NSError *error = nil;
        
        result = [context executeFetchRequest:fetchRequest error:&error];
    }
    @catch (NSException *exception) {
        result = nil;
        DLog(@"Fetch objects exception : %@",[exception description]);
    }
    
    return result;
}

//删除记录
-(void)deleteObjectsWithEntityName:(NSString *)entityName filter:(NSPredicate *)filter{
    @try {
        NSManagedObjectContext *context = [self managedObjectContext];
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
        if (filter) {
            [fetchRequest setPredicate:filter];
        }
        
        NSError *error = nil;
        
        NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
        for (NSManagedObject *object in result) {
            [context deleteObject:object];
        }
        
        // Save the context
        if (![self.managedObjectContext save:&error]) {
            DLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    @catch (NSException *exception) {
        DLog(@"Delete object exception : %@",[exception description]);
    }
}

//批量删除
-(void)batchDeleteObjectsWithEntityName:(NSString *)entityName filter:(NSPredicate *)filter{
    @try {
        NSManagedObjectContext *context = [self managedObjectContext];
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
        if (filter) {
            [fetchRequest setPredicate:filter];
        }
        
        NSError *error = nil;
        
        NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
        for (NSManagedObject *object in result) {
            [context deleteObject:object];
        }
        
        // Save the context
//        if (![self.managedObjectContext save:&error]) {
//            JYDLog(@"Unresolved error %@, %@", error, [error userInfo]);
//            abort();
//        }
    }
    @catch (NSException *exception) {
        DLog(@"Delete object exception : %@",[exception description]);
    }
}

//更新记录
-(void)updateObjectsWithEntityName:(NSString *)entityName infor:(NSDictionary *)infor filter:(NSPredicate *)filter{
    @try {
        NSManagedObjectContext *context = [self managedObjectContext];
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
        if (filter) {
            [fetchRequest setPredicate:filter];
        }
        
        NSError *error = nil;
        NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
        for (NSManagedObject *object in result) {
            for (NSString *key in [infor allKeys]) {
                id strValue = [infor valueForKey:key];
                [object setValue:strValue forKey:key];
            }
        }
    }
    @catch (NSException *exception) {
        DLog(@"Update object exception : %@", [exception description]);
    }
}

//获取记录条数
-(NSUInteger)getRecordCountWithEntityName:(NSString *)entityName filter:(NSPredicate *)filter{
    NSUInteger count = 0;
    @try {
        NSManagedObjectContext *context = [self managedObjectContext];
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
        
        if (filter) {
            [fetchRequest setPredicate:filter];
        }
        [fetchRequest setResultType:NSCountResultType];
        
        NSError *error = nil;
        
        count = [context countForFetchRequest:fetchRequest error:&error];
    }
    @catch (NSException *exception) {
        DLog(@"get record count exception:%@", exception);
    }
    
    return count;
}

@end
