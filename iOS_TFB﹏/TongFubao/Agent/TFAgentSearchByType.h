//
//  TFAgentSearchByDay.h
//  TongFubao
//
//  Created by ec on 14-6-16.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SearchTypeDay = 1,
    SearchTypeMonth = 2,
    SearchTypeYear = 3,
} TFAgentSearchType;

@protocol TFAgentSearchByTypeDelegate <NSObject>

-(void)clickSearchBt:(TFAgentSearchType)type;

@end

@interface TFAgentSearchByType : UIViewController

@property (nonatomic,strong) UITextField *searchField;

@property (nonatomic,assign) BOOL isCurrent;

@property (nonatomic,strong) NSString *recordTime;

@property (nonatomic,assign) id<TFAgentSearchByTypeDelegate> delegate;

-(id)initWithType:(TFAgentSearchType)type;

-(void)searchByTime:(NSString *)time;

-(void)clickType;

@end
