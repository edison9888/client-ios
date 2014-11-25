//
//  tableBar.m
//  ZhiLian
//
//  Created by 5014 on 13-8-27.
//  Copyright (c) 2013年 Da Peng. All rights reserved.
//

#import "tableBar.h"

@interface tableBar ()
{
    UIView *tabBarView;

}
@end

@implementation tableBar

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
 /*
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self tabBarController];
}

#pragma mark- tabBar
-(void)tabBarController{
   
    resume= [[FirstViewController alloc]init];
    myView= [[SecondViewController alloc]init];
    search= [[ThirdViewController alloc]init];
    more= [[MoreViewController alloc]init];
  
    [self.tabBar setHidden:YES];
    
    tabBarView= [[UIView alloc]initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.size.height-49, 320, 49)];
    
    [tabBarView setBackgroundColor:[UIColor colorWithPatternImage:[BaseUImage redraw:[UIImage imageNamed:@"tabbg.png"] frame:CGRectMake(0, 0, 320, 55)]]];
    
    [self.view addSubview:tabBarView];
    
    [tabBarView setUserInteractionEnabled:YES];

    
    
    // 导航控制器
    NSMutableArray *navigationArray = [[NSMutableArray alloc] init];
    
    // tabBarItem对应的viewController
	
    NSArray *viewControllerArray=  @[resume,myView,search,more];
    image= @[@"tablock_1",@"tablock_2",@"tablock_3",@"tablock_4"];
    UnImage= @[@"personal_s",@"myzl_s",@"search_s",@"more_s"];
    
    for (int i =0; i < viewControllerArray.count; i++) {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewControllerArray[i]];
        CGRect imageFrame = CGRectZero;
        
        UITabBarItem *tabBarItem = [[UITabBarItem alloc] init];
        UIImage *finish = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[image objectAtIndex:i] ofType:@"png"]];
        UIImage *unFinish = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[UnImage objectAtIndex:i] ofType:@"png"]];
        
        if (i == 2) {
            imageFrame = CGRectMake(0, 0, 60, 40);
        }else{
            imageFrame = CGRectMake(0, 0, 60, 40);
        }
        
        [tabBarItem setFinishedSelectedImage:[BaseUImage redraw:unFinish frame:imageFrame] withFinishedUnselectedImage:[BaseUImage redraw:finish frame:imageFrame]];
        nav.tabBarItem = tabBarItem;
        [navigationArray addObject:nav];
     
     
        
    }
    [self setViewControllers:navigationArray animated:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
*/
@end
