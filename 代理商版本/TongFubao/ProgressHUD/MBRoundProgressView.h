//
//  MBRoundProgressView.h
//  NLUitlsLib
//
//  Created by MD313 on 13-8-14.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBRoundProgressView : UIView
{
	float _progress;
	BOOL _annular;
}

/**
 * Progress (0.0 to 1.0)
 */
@property (nonatomic, assign) float progress;

/*
 * Display mode - NO = round or YES = annular. Defaults to round.
 */
@property (nonatomic, assign, getter = isAnnular) BOOL annular;

@property (nonatomic, retain) UILabel* lable;

- (id)initWithLable:(BOOL)lable;

@end
