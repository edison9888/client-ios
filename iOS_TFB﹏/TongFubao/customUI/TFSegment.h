//
//  TFSegment.h
//  TongFubao
//
//  Created by ec on 14-6-16.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TFSegmentDelegate <NSObject>
@optional
-(void)segmentValueChanged:(UIButton*)btn;

@end

@interface TFSegment : UIView

-(id)initWithFrame:(CGRect)frame items:(NSArray*)items;

@property (nonatomic, weak) id<TFSegmentDelegate>   delegate;

@property (nonatomic) NSInteger         selectIndex;

@end
