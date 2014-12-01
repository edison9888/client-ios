//
//  NLPassWordManagerViewController.m
//  TongFubao
//
//  Created by MD313 on 13-8-6.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLPassWordManagerViewController.h"
#import "NLLogonPWManagerViewController.h"
#import "NLFindPasswordViewController.h"
#import "NLUserInforSettingsCell.h"
#import "NLUtils.h"
#import "NLFindPasswordViewController.h"

@interface NLPassWordManagerViewController ()
{
    NSString* _ispaypwd;
}


@end

@implementation NLPassWordManagerViewController

@synthesize myTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//这样子传值 相对哪个也行哦 myBackToLogon
-(void)viewDidAppear:(BOOL)animated
{
    if (self.myBackToLogon)
    {
        [NLUtils enableSliderViewController:NO];
    }
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (self.myBackToLogon)
    {
        [NLUtils enableSliderViewController:YES];
    }
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.topViewController.title = @"密码管理";
    
    [self getNLPassWordIspaypwd];
    
    self.myMobile= [NLUtils getRegisterMobile];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getNLPassWordIspaypwd
{
    _ispaypwd = [NLUtils getIspaypwd];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.myBackToLogon)
    {
        return 1;
    }
    else
    {
        return 2;
    }
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NLUserInforSettingsCell *cell =nil;
    
    static NSString *kCellID = @"NLUsersInforSettingsCell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    
    if (cell == nil)
    {
        NSArray* temp = [[NSBundle mainBundle] loadNibNamed:kCellID owner:self options:nil];
        cell=[temp objectAtIndex:0];
    }
    
    cell.myHeaderLabel.hidden = NO;
    
    [cell.myHeaderLabel setFrame:CGRectMake(cell.myHeaderLabel.frame.origin.x, cell.myHeaderLabel.frame.origin.y, 200, cell.myHeaderLabel.frame.size.height)];
    
    cell.myContentLabel.hidden = YES;
    
    cell.myTextField.hidden = YES;
    
    cell.myDownrightBtn.hidden = YES;
    
    cell.myUprightBtn.hidden = YES;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    switch (indexPath.row)
    {
        
        case 0:
        {
            if ([_ispaypwd isEqualToString:@"0"])
            {
                cell.myHeaderLabel.text = @"设置登录密码";
            }
            else
            {
                cell.myHeaderLabel.text = @"修改登录密码";
            }
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
            break;
        case 1:
        {
            cell.myHeaderLabel.text = @"修改手势密码";
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self doSelectCellEvent:indexPath];
 
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark Rotation

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate
{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(void)doSelectCellEvent:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    if (row >= 2)
    {
        return;
    }
    TFBPasswordType type = (TFBPasswordType)(row+1);
    if (self.myBackToLogon)
    {
        NLFindPasswordViewController* vc =  [[NLFindPasswordViewController alloc] initWithNibName:@"NLFindPasswordViewController" bundle:nil];
        
        vc.myPasswordType = type;
        
        vc.myMobile = self.myMobile;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        if (0 == indexPath.row)
        {
            NLLogonPWManagerViewController *vc = [[NLLogonPWManagerViewController alloc] initWithNibName:@"NLLogonPWManagerViewController" bundle:nil];
            
            vc.myPasswordModifyVCType = TFBRegisterVCLogon;
            vc.mobile= self.myMobile;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            if ([_ispaypwd isEqualToString:@"0"])
            {
                TFBPasswordType type = (TFBPasswordType)(row+1);
                
                NLFindPasswordViewController* vc =  [[NLFindPasswordViewController alloc] initWithNibName:@"NLFindPasswordViewController" bundle:nil];
                
                vc.myPasswordType = type;

                vc.myMobile = self.myMobile;
                
                vc.isPaypwd = _ispaypwd;
                
                vc.NLPassWordDetegate = self;
                
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                //手势密码的修改
                GestureToLogin *vc = [[GestureToLogin alloc] init];
                vc.settingFlag= YES;
               [NLUtils presentModalViewController:self newViewController:vc];
            }
        }
    }

}


@end
