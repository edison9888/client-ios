//
//  ImageCache.h
//  TongFubao
//
//  Created by 〝Cow﹏. on 14-8-19.
//  Copyright (c) 2014年 〝Cow﹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ImageCache : NSManagedObject

@property (nonatomic, retain) id image;
@property (nonatomic, retain) NSString * url;

@end
