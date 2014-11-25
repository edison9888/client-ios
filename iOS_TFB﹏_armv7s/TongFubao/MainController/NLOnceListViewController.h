//
//  NLOnceListViewController.h
//  TongFubao
//
//  Created by MD313 on 13-10-10.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NLOnceListDelegate <NSObject>

- (void)doClickedEvent:(int)index object:(NSString*)object;

@end

@interface NLOnceListViewController : UIViewController

@property(nonatomic,strong)NSArray* myArry;
@property (nonatomic,assign)id<NLOnceListDelegate> myDelegate;
@property (nonatomic,assign)int myIndex;

@end
