//
//  NLCashHTCard.m
//  TongFubao
//
//  Created by  俊   on 14-9-9.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "NLCashHTCard.h"

@interface NLCashHTCard ()<UIWebViewDelegate,NSURLConnectionDelegate>
{
    bool _authenticated;
    NSURLConnection        *_urlConnection;
    NSMutableURLRequest    *_request;
    UIWebView              *webview;

}
@end

@implementation NLCashHTCard

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
    // Do any additional setup after loading the view from its nib.
    self.title= @"优惠卡";
    
    UIImage *contentImage = imageName(@"htcard", @"png");
    self.view.layer.contents = (__bridge id)contentImage.CGImage;
    [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
}

- (IBAction)OnbtnClick:(UIButton*)sender {
    
    UIButton *senderBtn= (UIButton *)sender;
    
    switch (senderBtn.tag) {
        case 1:
        {
            NLCashArriveMainViewController *pay= [[NLCashArriveMainViewController alloc]init];
            [self.navigationController pushViewController:pay animated:YES];
  
        }
            break;
        case 2:
        {
         
            NSURL*url=[NSURL URLWithString:@"https://pay.expresspay.cn/Paygateway/recharge/mobCardRecharge.do"];
            _request=[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
            [_request setHTTPMethod:@"POST"];
            [NSURLProtocol registerClass:[opURLProtocal class]];
            webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 64, 320, self.view.frame.size.height - 64)];
            webview.delegate = self;
            [self.view addSubview: webview];
            [webview loadRequest:_request];
        }
            break;
        default:
            break;
    }
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [NSURLProtocol registerClass:[opURLProtocal class]];
    NSLog(@"1111");
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"2222");
     [NSURLProtocol registerClass:[opURLProtocal class]];
    
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"3333");
     [NSURLProtocol registerClass:[opURLProtocal class]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
