//
//  JYSegment.m
//  BossLink
//
//  Created by tangjie on 13-11-12.
//  Copyright (c) 2013年 JinYi. All rights reserved.
//

#import "TFSegment.h"

@interface TFSegment ()
@property (nonatomic) NSInteger             lastSelectedIndex;
@property (nonatomic, strong) NSArray       *items;

@property (nonatomic,strong) UIButton *btnLeft;
@property (nonatomic,strong) UIButton *btnMiddle;
@property (nonatomic,strong) UIButton *btnRight;

@property (nonatomic,strong) NSMutableArray *btnArray;

@property (nonatomic,strong) UIImageView *triangleImgView;

@end

@implementation TFSegment

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame items:(NSArray *)items{
    if (self = [super initWithFrame:frame]) {
        int count = [items count];
        
        _lastSelectedIndex = 0;
        _items = [NSArray arrayWithArray:items];
        int width = self.frame.size.width / count;
        
        
        UIImage *imgLeftHover = nil;
        UIImage *imgMiddleNor = nil;
        UIImage *imgRightNor = nil;
        UIColor *norColor = nil;
        
        imgLeftHover = [UIImage imageNamed:@"left_cv_selected"];
        imgMiddleNor = [NLUtils createImageWithColor:RGBACOLOR(149, 235, 252, 1.0) rect:CGRectMake(0, 0, 2, 39)];
        imgRightNor = [UIImage imageNamed:@"right_cv_normal"];
        norColor = RGBACOLOR(43, 196, 223, 1.0);
        
        _btnArray = [NSMutableArray array];
       
        _btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnLeft.tag = 0;
        _btnLeft.frame = CGRectMake(0, 0, width, self.frame.size.height);
        [_btnLeft setBackgroundImage:[NLUtils stretchImage:imgLeftHover edgeInsets:UIEdgeInsetsMake(15, 5, 15, 1)] forState:UIControlStateNormal];
        [_btnLeft setBackgroundImage:[NLUtils stretchImage:imgLeftHover edgeInsets:UIEdgeInsetsMake(15, 5, 15, 1)] forState:UIControlStateHighlighted];
        [_btnLeft setTitle:items[0] forState:UIControlStateNormal];
        [[_btnLeft titleLabel] setFont:[UIFont systemFontOfSize:14]];
        [_btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnLeft setImage:[UIImage imageNamed:@"date_selected"] forState:UIControlStateNormal];
        [_btnLeft setImageEdgeInsets:UIEdgeInsetsMake(5, -5, 5, 0)];
        [_btnLeft setTitleEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 0)];
        [_btnLeft addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnLeft];
        [_btnArray addObject:_btnLeft];
        
        _triangleImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"blue_triangle"]];
        _triangleImgView.frame = CGRectMake(_btnLeft.center.x-6, _btnLeft.center.y+19, 12, 6);
        [self addSubview:_triangleImgView];
        
        for (int i= 1; i < count - 1; ++i) {
            _btnMiddle = [UIButton buttonWithType:UIButtonTypeCustom];
            _btnMiddle.tag = i;
            _btnMiddle.frame = CGRectMake((width - 1) * i, 0, width, self.frame.size.height);
            [_btnMiddle setBackgroundImage:[NLUtils stretchImage:imgMiddleNor edgeInsets:UIEdgeInsetsMake(5, 3, 5, 3)]forState:UIControlStateNormal];
            [_btnMiddle setBackgroundImage:[NLUtils stretchImage:imgMiddleNor edgeInsets:UIEdgeInsetsMake(5, 3, 5, 3)]forState:UIControlStateHighlighted];
            [[_btnMiddle titleLabel] setFont:[UIFont systemFontOfSize:14]];
            [_btnMiddle setTitle:items[i] forState:UIControlStateNormal];
            [_btnMiddle setTitleColor:norColor forState:UIControlStateNormal];
            [_btnMiddle setImage:[UIImage imageNamed:@"month_normal"] forState:UIControlStateNormal];
            [_btnMiddle setImageEdgeInsets:UIEdgeInsetsMake(5, -5, 5, 0)];
            [_btnMiddle setTitleEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 0)];
            [_btnMiddle addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_btnMiddle];
            [_btnArray addObject:_btnMiddle];
        }
        
        _btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnRight.tag = count - 1;
        _btnRight.frame = CGRectMake((width - 1) * (count - 1) , 0, _btnLeft.frame.size.width, _btnLeft.frame.size.height);
        [_btnRight setBackgroundImage:[NLUtils stretchImage:imgRightNor edgeInsets:UIEdgeInsetsMake(15, 1, 15, 5)] forState:UIControlStateNormal];
        [_btnRight setBackgroundImage:[NLUtils stretchImage:imgRightNor edgeInsets:UIEdgeInsetsMake(15, 1, 15, 5)] forState:UIControlStateHighlighted];
        [[_btnRight titleLabel] setFont:[UIFont systemFontOfSize:14]];
        [_btnRight setTitle:items[count - 1] forState:UIControlStateNormal];
        [_btnRight setImage:[UIImage imageNamed:@"year_normal"] forState:UIControlStateNormal];
        [_btnRight setImageEdgeInsets:UIEdgeInsetsMake(5, -5, 5, 0)];
        [_btnRight setTitleEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 0)];
        [_btnRight setTitleColor:norColor forState:UIControlStateNormal];
        [_btnRight addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnRight];
        [_btnArray addObject:_btnRight];
    }
    
    return self;
}


-(void)itemClicked:(UIButton*)btn{
    
    UIImage *imgLeftNor = nil;
    UIImage *imgLeftHover = nil;
    UIImage *imgMiddleNor = nil;
    UIImage *imgMiddleHover = nil;
    UIImage *imgRightNor = nil;
    UIImage *imgRightHover = nil;
    UIColor *norColor = nil;
    
    imgLeftNor = [UIImage imageNamed:@"left_cv_normal"];
    imgLeftHover = [UIImage imageNamed:@"left_cv_selected"];
    imgMiddleNor = [NLUtils createImageWithColor:RGBACOLOR(149, 235, 252, 1.0) rect:CGRectMake(0, 0, 2, 39)];
    imgMiddleHover = [NLUtils createImageWithColor:RGBACOLOR(44, 196, 233, 1.0) rect:CGRectMake(0, 0, 2, 39)];
    imgRightNor = [UIImage imageNamed:@"right_cv_normal"];
    imgRightHover = [UIImage imageNamed:@"right_cv_selected"];
    norColor = RGBACOLOR(43, 196, 223, 1.0);
   
    if (_lastSelectedIndex != btn.tag) {
        for (UIButton *button in _btnArray) {
            if (button.tag != btn.tag) {//未选中状态按钮
                if (0 == button.tag) {
                    [button setBackgroundImage:[NLUtils stretchImage:imgLeftNor edgeInsets:UIEdgeInsetsMake(15, 5, 15, 1)] forState:UIControlStateNormal];
                    [button setBackgroundImage:[NLUtils stretchImage:imgLeftNor edgeInsets:UIEdgeInsetsMake(15, 5, 15, 1)] forState:UIControlStateHighlighted];
                }else if ([_items count] - 1 == button.tag){
                    [button setBackgroundImage:[NLUtils stretchImage:imgRightNor edgeInsets:UIEdgeInsetsMake(15, 1, 15, 5)] forState:UIControlStateNormal];
                    [button setBackgroundImage:[NLUtils stretchImage:imgRightNor edgeInsets:UIEdgeInsetsMake(15, 1, 15, 5)] forState:UIControlStateHighlighted];
                }else{
                    [button setBackgroundImage:[NLUtils stretchImage:imgMiddleNor edgeInsets:UIEdgeInsetsMake(5, 3, 5, 3)] forState:UIControlStateNormal];
                    [button setBackgroundImage:[NLUtils stretchImage:imgMiddleNor edgeInsets:UIEdgeInsetsMake(5, 3, 5, 3)] forState:UIControlStateHighlighted];
                }
                
                [button setTitleColor:norColor forState:UIControlStateNormal];
            }else{//选中状态按钮
                if (0 == button.tag) {
                    [button setBackgroundImage:[NLUtils stretchImage:imgLeftHover edgeInsets:UIEdgeInsetsMake(15, 5, 15, 1)] forState:UIControlStateNormal];
                    [button setBackgroundImage:[NLUtils stretchImage:imgLeftHover edgeInsets:UIEdgeInsetsMake(15, 5, 15, 1)] forState:UIControlStateHighlighted];
                    [_btnLeft setImage:[UIImage imageNamed:@"date_selected"] forState:UIControlStateNormal];
                    [_btnMiddle setImage:[UIImage imageNamed:@"month_normal"] forState:UIControlStateNormal];
                    [_btnRight setImage:[UIImage imageNamed:@"year_normal"] forState:UIControlStateNormal];
                    _triangleImgView.frame = CGRectMake(_btnLeft.center.x-6, _btnLeft.center.y+19, 12, 6);

                }else if ([_items count] - 1 == button.tag){
                    [button setBackgroundImage:[NLUtils stretchImage:imgRightHover edgeInsets:UIEdgeInsetsMake(15, 1, 15, 5)] forState:UIControlStateNormal];
                    [button setBackgroundImage:[NLUtils stretchImage:imgRightHover edgeInsets:UIEdgeInsetsMake(15, 1, 15, 5)] forState:UIControlStateHighlighted];
                    [_btnLeft setImage:[UIImage imageNamed:@"date_normal"] forState:UIControlStateNormal];
                    [_btnMiddle setImage:[UIImage imageNamed:@"month_normal"] forState:UIControlStateNormal];
                    [_btnRight setImage:[UIImage imageNamed:@"year_selected"] forState:UIControlStateNormal];
                    _triangleImgView.frame = CGRectMake(_btnRight.center.x-6, _btnRight.center.y+19, 12, 6);

                }else{
                    [button setBackgroundImage:[NLUtils stretchImage:imgMiddleHover edgeInsets:UIEdgeInsetsMake(5, 3, 5, 3)] forState:UIControlStateNormal];
                    [button setBackgroundImage:[NLUtils stretchImage:imgMiddleHover edgeInsets:UIEdgeInsetsMake(5, 3, 5, 3)] forState:UIControlStateHighlighted];
                    [_btnLeft setImage:[UIImage imageNamed:@"date_normal"] forState:UIControlStateNormal];
                    [_btnMiddle setImage:[UIImage imageNamed:@"month_selected"] forState:UIControlStateNormal];
                    [_btnRight setImage:[UIImage imageNamed:@"year_normal"] forState:UIControlStateNormal];
                    _triangleImgView.frame = CGRectMake(_btnMiddle.center.x-6, _btnMiddle.center.y+19, 12, 6);
                }
                
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
        
        }
    }
    
    _lastSelectedIndex = btn.tag;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentValueChanged:)]) {
        [self.delegate segmentValueChanged:btn];
    }
}
@end
