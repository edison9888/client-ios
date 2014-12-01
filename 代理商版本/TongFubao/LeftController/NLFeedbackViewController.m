//
//  NLFeedbackViewController.m
//  TongFubao
//
//  Created by MD313 on 13-8-2.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLFeedbackViewController.h"
#import "NLUtils.h"
#import "NLKeyboardAvoid.h"
#import "NLToast.h"
#import "NLProtocolRequest.h"
#import "NLContants.h"
#import "ProtocolDefine.h"
#import "NLProtocolResponse.h"
#import "NLProgressHUD.h"

@interface NLFeedbackViewController ()
{
    NLProgressHUD* _hud;
}

@property(nonatomic,retain) NSString* myContent;
@property(nonatomic,retain) NSString* myContact;
@property(nonatomic,retain) IBOutlet UITextView* myContentTextView;
@property(nonatomic,retain) IBOutlet UITextView* myContactTextView;
@property(nonatomic,retain) IBOutlet UILabel* myContentLabel;
@property(nonatomic,retain) IBOutlet UILabel* myContactLabel;
@property(nonatomic,retain) IBOutlet NLKeyboardAvoidingScrollView* myScrollView;

-(void)commitAndFeedback;
-(void)commitAndFeedbackNotify:(NSNotification*)notify;

@end

@implementation NLFeedbackViewController

@synthesize myContact;
@synthesize myContent;
@synthesize myContactTextView;
@synthesize myContentTextView;
@synthesize myContentLabel;
@synthesize myContactLabel;
@synthesize myScrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//-(void)viewWillDisappear:(BOOL)animated
//{
//     REMOVE_NOTIFY_OBSERVER(self);
//    [super viewWillDisappear:animated];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.topViewController.title=@"意见反馈";
    
    //返回样式类型
    UIButton* backButton = [NLUtils createNavigationLeftBarButtonImage];
    
    [backButton setBackgroundImage:[UIImage imageNamed:@"navigationLeftBtnBack2"] forState:UIControlStateNormal];
    
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];


    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"提交反馈"
                                                                      style:UIBarButtonItemStyleBordered target:self
                                                                     action:@selector(commitAndFeedback)];
	self.navigationItem.rightBarButtonItem = anotherButton;
    [self.myContentTextView becomeFirstResponder];
    
    self.myContentTextView.delegate = self;
    self.myContactTextView.delegate = self;
    
    
    if (IOS_7)
    {
        CGRect rect = self.myScrollView.frame;
        [self.myScrollView setFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height + 64)];
    }

}


-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)commitAndFeedbackNotify:(NSNotification*)notify
{
    //NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    //NLLogNoLocation(@"error = %d, name = %@",response.errcode,response.detail);
}

-(void)doAuthorFeedbckNotify:(NLProtocolResponse*)response
{
    [self showErrorInfo:@"反馈成功" status:NLHUDState_NoError];
    //[self.navigationController popViewControllerAnimated:YES];
}

-(void)authorFeedbckNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [self doAuthorFeedbckNotify:response];
    }
    else if (error == RSP_TIMEOUT)
    {
        [self showErrorInfo:@"请求超时,需要重新登录" status:NLHUDState_Error];
        [self performSelector:@selector(doPush) withObject:nil afterDelay:2.0f];
        return;
    }
    else
    {
        NSString* detail = response.detail;
        if (!detail || detail.length <= 0)
        {
            detail = @"服务器繁忙，请稍候再试";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

-(void)commitAndFeedback
{
    if ([self.myContactTextView isFirstResponder])
    {
        [self.myContactTextView resignFirstResponder];        
    }
    else if ([self.myContentTextView isFirstResponder])
    {
        [self.myContentTextView resignFirstResponder];
    }
    
    NSString* content = [self.myContentTextView text];
    if ([content length] < 10)
    {
        [self showErrorInfo:@"请输入至少10个字的反馈意见" status:NLHUDState_Error];
        return;
    }
    
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    NSString* name = [NLUtils getNameForRequest:Notify_authorFeedbck];
    REGISTER_NOTIFY_OBSERVER(self, authorFeedbckNotify, name);
    NSString* contact = [self.myContactTextView text];
    [[[NLProtocolRequest alloc] initWithRegister:YES] authorFeedbck:content contact:contact];
//    [[[NLToast alloc] init] show:@"正在反馈"
//                         gravity:NLToastGravityBottom
//                        duration:NLToastDurationNormal];
}

-(void)hideKeyboard
{
    if ([self.myContactTextView isFirstResponder])
    {
        [self.myContactTextView resignFirstResponder];
        [self.myScrollView setScrollsToTop:YES];
    }
    else if ([self.myContentTextView isFirstResponder])
    {
        [self.myContentTextView resignFirstResponder];
        [self.myScrollView setScrollsToTop:YES];
    }
}

-(void)showErrorInfo:(NSString*)detail status:(NLHUDState)status
{
    [_hud hide:YES];
    _hud = [[NLProgressHUD alloc] initWithParentView:self.view];
    switch (status)
    {
        case NLHUDState_Error:
        {
            _hud.detailsLabelText = detail;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unCheckmark.png"]] ;
            _hud.mode = MBProgressHUDModeCustomView;
            [_hud show:YES];
            [_hud hide:YES afterDelay:2];
        }
            break;
            
        case NLHUDState_NoError:
        {
            _hud.labelText = detail;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.png"]] ;
            _hud.mode = MBProgressHUDModeCustomView;
            [_hud show:YES];
            [_hud hide:YES afterDelay:2];
        }
            break;
            
        case NLHUDState_None:
        {
            _hud.labelText = detail;
            [_hud show:YES];
        }
            
        default:
            break;
    }
    return;
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    if (textView == self.myContentTextView)
    {
        int length = [textView.text length] + [text length];
        if (range.length > 0)
        {
            length--;
        }
        if (length > 0)
        {
            self.myContentLabel.hidden = YES;
            if(length > 200)
            {
                return NO;
            }
        }
        else
        {
            self.myContentLabel.hidden = NO;
        }
        return YES;
    }
    else if (textView == self.myContactTextView)
    {
        int length = [textView.text length] + [text length];
        if (range.length > 0)
        {
            length--;
        }
        if (length > 0)
        {
            self.myContactLabel.hidden = YES;
        }
        else
        {
            self.myContactLabel.hidden = NO;
        }
    }
    return YES;
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

//#pragma mark - Text field delegate
//
//-(BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [self.myContactTextView resignFirstResponder];
//    return YES;
//}

#pragma mark - NLProgressHUDDelegate
- (void)hudWasHidden:(NLProgressHUD *)hud
{
}

- (void) doPush
{
    [_hud hide:YES];
    [NLUtils popToLogonVCByHTTPError:self feedOrLeft:0];
}


@end
