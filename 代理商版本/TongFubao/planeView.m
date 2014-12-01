//
//  planeView.m
//  TongFubao
//
//  Created by  俊   on 14-7-1.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "planeView.h"
#import "NLProgressHUD.h"
#import "SVWebViewController.h"
/*
 -(void)readOrderUrl{
 
NSString *banktypeStr= @"";
if (_banKtype==YES) {
    banktypeStr= @"yibao";
}
NSString* name = [NLUtils getNameForRequest:Notify_readBankList];
REGISTER_NOTIFY_OBSERVER(self, readBankListNotify, name);
[[[NLProtocolRequest alloc] initWithRegister:YES]readBankListByPaging:self.myActivemobilesms msgstart:_msgstart msgdisplay:_msgdisplay querywhere:_querywhere banktype:banktypeStr];
[self showErrorInfo:@"请稍候" status:NLHUDState_None];

}
 */
@interface planeView ()
{
     NLProgressHUD  * _hud;
     NSURLConnection*connectionPOST;
}
@end

@implementation planeView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor= [UIColor whiteColor];
    
    [self asynchronizePost];
    
}

-(void)asynchronizePost
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self showErrorInfo:@"请稍候" status:NLHUDState_None];
        NSURL*url=[NSURL URLWithString:@"http://u.ctrip.com/union/CtripRedirect.aspx?TypeID=615&sid=451200&allianceid=20230&ouid="];
        NSMutableURLRequest*request=[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
        [request setHTTPMethod:@"POST"];
        connectionPOST=[NSURLConnection connectionWithRequest:request delegate:self];
        
        dispatch_async(dispatch_get_main_queue(), ^{
          
            UIWebView*webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, self.view.frame.origin.y+64, self.view.frame.size.width, self.view.frame.size.height-64)];
            [webview setOpaque:NO];//设置背景透明
            [webview setBackgroundColor:[UIColor clearColor]];
            [webview loadRequest:request];
            [_hud hide:YES];

            [self.view insertSubview:webview atIndex:0];
        });
    });
}



-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    

}

//判断信息是否正确
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
