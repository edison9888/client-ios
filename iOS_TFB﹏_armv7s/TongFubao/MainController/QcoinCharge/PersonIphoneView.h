//
//  PersonIphoneView.h
//  TongFubao
//
//  Created by kin on 14-9-9.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PersonIphoneViewdelegate <NSObject>

-(void)deletSelectionPersonIphoneButtonTag:(NSInteger)newTage;

@end



@interface PersonIphoneView : UIView



@property (retain,nonatomic)id<PersonIphoneViewdelegate>delegate;

- (id)initWithFrame:(CGRect)frame nameLabel:(NSString *)newNameLabel iphoneLabel:(NSString *)newiphoneLabel buttonTag:(NSInteger)newTag;


@end
