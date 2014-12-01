//
//  UIViewController+NavigationItem.h
//  BossLink
//
//

#import <UIKit/UIKit.h>

@interface UIViewController (NavigationItem)

-(void)addBackButtonItemWithTitle:(NSString *)title;

-(void)addBackButtonItemWithImage:(UIImage *)img;

- (void)setNavBackItemByLastControllerBackTitle;

- (void)setNavBackItemByLastControllerTitle;

/*left文字*/
-(void)addleftButtonItemWithTitle:(NSString *)title useEnabled:(BOOL)useEnabled;

-(void)addRightButtonItemWithTitle:(NSString *)title;

-(void)addRightButtonItemWithImage:(UIImage *)img;

-(void)setNavRightArrowItemWithTitle:(NSString*)title;

-(void)setNavRightItemWithImage:(UIImage*)img;
@end
