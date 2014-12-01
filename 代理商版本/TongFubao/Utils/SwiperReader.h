//
//  SwiperReader.h
//  SwiperReader
//
//  Created by 敬丹 张 on 12-5-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum __SwiperReaderStatus
{
    SRS_OK = 0,
    SRS_DeviceAvailable,
    SRS_DeviceUnavailable,
    SRS_AudioSessionInitError,
    SRS_Decoding,
    SRS_DecodeError,
    SRS_DeviceColsed,
    SRS_DeviceStoped,
    SRS_DataVerifyError,
    SRS_MemoryError,
    SRS_Timerout, 
    SRS_Unknown
}SwiperReaderStatus;

// 回调函数第一个为状态值, 第二个为当前状态下的数据, 第三个是用户自己的数据
typedef void(*CALLBACK)(SwiperReaderStatus, void*, void*);

@interface SwiperReader : NSObject {
@private
    SwiperReaderStatus state;
    float volume;
    NSTimer *timer;
    int timerout;
}

// 打开设备
-(SwiperReaderStatus)open;
-(SwiperReaderStatus)open:(Boolean) playSounds;

// 关闭设备
-(void)close;

// buffer 外部申请内存  size为buffer的大小单位为byte
// 返回值为读取的数据字节数
-(int)read:(void*)buffer withBufferSize:(int)size;
-(int)write:(char*)buf withWriteLen:(int)len;

// 设置回调函数,当读取到数据,或者设备状态发变时此函数会被调用.
-(void)setCallback:(CALLBACK)callback userData:(void *)data;

-(BOOL)getVersion:(char*)buf withBufSize:(int)size;

-(void)writeRecordToFile:(char*) fileName;

-(void)setTimerout:(int) millisec;

-(void)setDebugOn:(const char*)tag open:(bool)on;
@end














