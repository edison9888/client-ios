//
//  VisaReader.h
//  VisaReader
//
//  Created by MD313 on 13-9-4.
//
//

#import <Foundation/Foundation.h>
#import "SwiperReader.h"

@protocol VisaReaderDelegate <NSObject>

-(void)doVisaReaderEvent:(SwiperReaderStatus)event object:(NSString*)object;

@end

@interface VisaReader : NSObject

@property(nonatomic,assign) id<VisaReaderDelegate> myDelegate;

+(id)initWithDelegate:(id<VisaReaderDelegate>)delegate;
-(void)createVisaReader;
-(void)resetVisaReader:(BOOL)open;
-(void)resetModel:(BOOL)MS6xx;

-(SwiperReaderStatus)open;
-(int)wakeUp;
-(void)loadWakingUp;
-(void)unLoadWakingUp;

@end
