//
//  keyView.h
//  keyBrob
//
//  Created by kin on 14/10/24.
//  Copyright (c) 2014年 kin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol keyviewdelegate <NSObject>

-(void)keybrodBack;
-(void)textFelid:(NSString *)numberText;

@end


@interface keyView : UIView

@property(retain,nonatomic)id <keyviewdelegate>delegate;
@property(retain,nonatomic)NSMutableArray *numberArray;
-(void)deleteNumber;
@end
