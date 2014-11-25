//
//  BlockText.h
//  TongFubao
//
//  Created by  俊   on 14-6-26.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^BlockTextIntheTFB)(NSArray *arrayment,NSString *error);

@interface BlockText : NSObject

@property (nonatomic, copy) BlockTextIntheTFB blocktextinthetfb;


@end
