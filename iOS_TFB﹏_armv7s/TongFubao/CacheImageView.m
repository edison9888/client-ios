//
//  CacheImageView.m
//  TxIphoneClient
//
//  Created by Delpan on 14-2-19.
//
//

#import "CacheImageView.h"

@implementation CacheImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.userInteractionEnabled = YES;
        
        //拖拽手势
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
        [self addGestureRecognizer:panGesture];
        
        //旋转手势
        UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationGestureAction:)];
        [self addGestureRecognizer:rotationGesture];
        
        //捏合手势
        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureAction:)];
        [self addGestureRecognizer:pinchGesture];
    }
    
    return self;
}

#pragma mark - 拖拽图片
- (void)panGestureAction:(UIPanGestureRecognizer *)sender
{
    if (UIGestureRecognizerStateChanged == sender.state)
    {
        CGPoint translation = [sender translationInView:sender.view];
        
        [sender.view setTransform:CGAffineTransformTranslate(sender.view.transform, translation.x, translation.y)];
        
        [sender setTranslation:CGPointMake(0, 0) inView:sender.view];
    }
}

#pragma mark - 旋转手势
- (void)rotationGestureAction:(UIRotationGestureRecognizer *)sender
{
    if (UIGestureRecognizerStateChanged == sender.state)
    {
        [sender.view setTransform:CGAffineTransformRotate(sender.view.transform, sender.rotation)];
        
        sender.rotation = 0;
    }
}

#pragma mark - 捏合手势
- (void)pinchGestureAction:(UIPinchGestureRecognizer *)sender
{
    if (UIGestureRecognizerStateChanged == sender.state)
    {
        [sender.view setTransform:CGAffineTransformScale(sender.view.transform, sender.scale, sender.scale)];
        
        sender.scale = 1.0;
    }
}

@end










