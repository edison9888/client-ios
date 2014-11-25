//
//  ImageData.m
//  TongFubao
//
//  Created by 〝Cow﹏. on 14-8-19.
//  Copyright (c) 2014年 〝Cow﹏. All rights reserved.
//

#import "ImageData.h"

@implementation ImageData

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


+ (id)singleton
{
    static ImageData *imageData = nil;
    
    if(!imageData)
    {
        imageData = [[ImageData alloc] init];
    }
    
    return imageData;
}

#pragma mark - 保存图片
- (void)imageCacheWith:(NSString *)url image:(UIImage *)image
{
    ImageCache *imageCache = [NSEntityDescription insertNewObjectForEntityForName:@"ImageCache" inManagedObjectContext:self.managedObjectContext];
    
    if (imageCache)
    {
        //实体对象赋值
        imageCache.url = url;
        imageCache.image = image;
        
        //判断是否保存成功
        NSError *saveError = nil;
        
        if ([self.managedObjectContext save:&saveError])
        {
            NSLog(@"Successful operation");
        }
        else
        {
            NSLog(@"error = %@",saveError);
        }
    }
    else
    {
        NSLog(@"Failed to create a new person");
    }
    
    [self saveContext];
}

#pragma mark - 查询图片是否存在
- (NSArray *)queryImageWith:(NSString *)url
{
    NSFetchRequest *fetch = [self createFetchRequest];
    
    NSError *requestError = nil;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"url CONTAINS[cd] %@",url];
    [fetch setPredicate:predicate];
    
    NSArray *images = [self.managedObjectContext executeFetchRequest:fetch error:&requestError];
    
    if (images.count > 0)
    {
        return images;
    }
    
    return nil;
}

//创建请求上下文
- (NSFetchRequest *)createFetchRequest
{
    //读取实体对象请求
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //获取实体的管理对象上下文
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ImageCache" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    return fetchRequest;
}

- (void)saveContext
{
    NSLog(@"%s",__FUNCTION__);
    
    NSError *error = nil;
    
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack
- (NSManagedObjectContext *)managedObjectContext
{
    NSLog(@"%s",__FUNCTION__);
    
    if (_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }
    
    //通过NSPersistentStoreCoordinator对象生成新的NSManagedObjectContext对象
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    
    if (coordinator != nil)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    NSLog(@"%s",__FUNCTION__);
    
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    
    //数据模型路径
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ImageCache" withExtension:@"momd"];
    
    //通过"数据模型路径"对象生成新的NSManagedObjectModel对象
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    NSLog(@"%s",__FUNCTION__);
    
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ImageCache.sqlite"];
    
    NSError *error = nil;
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory
- (NSURL *)applicationDocumentsDirectory
{
    NSLog(@"%s",__FUNCTION__);
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end





