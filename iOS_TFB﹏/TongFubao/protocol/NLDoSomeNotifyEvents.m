//
//  NLDoSomeNotifyEvents.m
//  TongFubao
//
//  Created by MD313 on 13-8-30.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLDoSomeNotifyEvents.h"
#import "NLProtocolRequest.h"
#import "NLUtils.h"

static NLDoSomeNotifyEvents* gDoSomeNotifyEvents = nil;

@interface NLDoSomeNotifyEvents()

@property(nonatomic,retain) NSString* myNewVersionURl;

@end

@implementation NLDoSomeNotifyEvents

+(id)shareDoSomeNotifyEvents
{
    if (gDoSomeNotifyEvents == nil)
    {
        gDoSomeNotifyEvents=[[NLDoSomeNotifyEvents alloc] init];
    }
    return gDoSomeNotifyEvents;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    [UIMenuController sharedMenuController].menuVisible = NO;  //donot display the menu
    //[self resignFirstResponder];                      //do not allow the user to selected anything
    return NO;
}

- (UITextView *)plainTextView:(NSString*)content
{ 
	UITextView*	plainTextView = [[UITextView alloc] initWithFrame:CGRectMake(14, 45, 256,75)];
    plainTextView.backgroundColor = [UIColor whiteColor];
    plainTextView.font = [UIFont boldSystemFontOfSize:15];
    plainTextView.text = content;
    plainTextView.editable = NO;
	return plainTextView;
}

//检测版本
-(void)doCheckAppVersionNotify:(NSString*)appnewversion
                clearoldinfo:(BOOL)clearoldinfo
                  appdownurl:(NSString*)appdownurl
               appnewcontent:(NSString*)appnewcontent
                  appstrupdate:(BOOL)appstrupdate
{
    self.myNewVersionURl = appdownurl;
    NSString* title = [NSString stringWithFormat:@"发现新版本:%@",appnewversion];
    NSString* message = [NSString stringWithFormat:@"%@",appnewcontent];
    if (appstrupdate)
    {
        [NLUtils showAlertView:title
                       message:message
                      delegate:self
                           tag:0
                     cancelBtn:@"确定"
                         other:nil];
    }
    else
    {
        [NLUtils showAlertView:title
                       message:message
                      delegate:self
                           tag:1
                     cancelBtn:@"取消"
                         other:@"确定",nil];
    }
}

-(void)doDownUpdateNewVersion
{
////    https://itunes.apple.com/us/app/tong-fu-bao-qian-bao/id740276926?ls=1&mt=8
//    
    NSArray* array = [self.myNewVersionURl componentsSeparatedByString:@"@@@"];
    int count = [array count];
    if (count == 2)
    {
        self.myNewVersionURl = [NSString stringWithFormat:@"%@&%@",[array objectAtIndex:0],[array objectAtIndex:1]];
    }
    NSURL* url = [[ NSURL alloc ] initWithString :self.myNewVersionURl];
    [[UIApplication sharedApplication ] openURL: url];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ((1 == buttonIndex && alertView.tag == 1)
        || (0 == buttonIndex && alertView.tag == 0))
    {
        [self doDownUpdateNewVersion];
    }
}

@end
