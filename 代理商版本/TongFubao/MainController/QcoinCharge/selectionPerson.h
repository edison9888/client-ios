//
//  selectionPerson.h
//  TongFubao
//
//  Created by kin on 14-8-20.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol selectionPersondelegate <NSObject>

-(void)selectionPersonstyUnmber:(NSString *)newstyUnmber  selectionPersonstystyWorld:(NSString *)newstyWorld;

@end


@interface selectionPerson : UIView<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,retain)UITableView *selectionTableView;
@property (nonatomic,retain)NSArray *styUnmber;
@property (nonatomic,retain)NSArray *styWorld;
@property (nonatomic,retain)id<selectionPersondelegate>delegate;



@end
