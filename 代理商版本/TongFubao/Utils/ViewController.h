//
//  ViewController.h
//  eCardReader
//
//  Created by  on 12-3-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwiperReader.h"

@interface ViewController : UIViewController {
    IBOutlet UIButton *btnControl;
    IBOutlet UIButton *btnModel;
    IBOutlet UITextView *txtOutput;
    IBOutlet UILabel *lblVersion;
    SwiperReader *swiperReader;
    NSTimer *callTimer;
    BOOL  isRuning;
    BOOL    palySounds;
}
- (void)viewDidLoad1;
-(IBAction)playSoundPressed:(id)sender;
-(IBAction)modelBtnPressed:(id)sender;
-(void) willTerminate:(NSNotification *)notification;
-(void) readerCardInfo;
-(void) deviceUnavailable;
-(void) readerIsDecoding;
-(void) readerErrorDisplay:(NSString*)errorCode;
-(void) openReader;
-(void) remoteControlReceivedWithEvent:(UIEvent *)theEvent;
-(void) setMaxVolume;
-(void) closeReader;
-(void) setBackRound:(BOOL)backGround;
-(void) openReader:(BOOL) open;
@end
