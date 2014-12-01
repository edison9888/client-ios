//
//  PersonView.h
//  TongFubao
//
//  Created by kin on 14-9-7.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PersonViewdelegate <NSObject>

-(void)deletSelectionButtonTag:(NSInteger)newTage;

@end

@interface PersonView : UIView



@property (retain,nonatomic)id<PersonViewdelegate>delegate;

- (id)initWithFrame:(CGRect)frame nameLabel:(NSString *)newNameLabel iphoneLabel:(NSString *)newiphoneLabel buttonTag:(NSInteger)newTag;


@end
