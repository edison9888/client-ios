//
//  PlayFromToView.h
//  TongFubao
//
//  Created by kin on 14-8-28.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PlayFromToViewdelegate <NSObject>

-(void)playFromToViewInfoTuPiao;

@end
@interface PlayFromToView : UIView


@property(retain,nonatomic)id<PlayFromToViewdelegate>delegate;
- (id)initWithFrame:(CGRect)frame infoArray:(NSArray *)newIfoArray;


@end
