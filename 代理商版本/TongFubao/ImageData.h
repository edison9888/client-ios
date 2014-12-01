//
//  ImageData.h
//  TongFubao
//
//  Created by Delpan on 14-8-19.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageCache.h"

@interface ImageData : NSObject

@property (readonly,nonatomic,strong) NSManagedObjectContext *managedObjectContext;

@property (readonly,nonatomic,strong) NSManagedObjectModel *managedObjectModel;

@property (readonly,nonatomic,strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (id)singleton;

//保存图片
- (void)imageCacheWith:(NSString *)url image:(UIImage *)image;

//查询图片是否存在
- (NSArray *)queryImageWith:(NSString *)url;

@end
