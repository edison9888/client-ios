//
//  VisaReader.m
//  VisaReader
//
//  Created by MD313 on 13-9-4.
//
//
#define DECRYPTION_DATA 1

#import "VisaReader.h"
#if DECRYPTION_DATA
#import "ToolKit.h"
#endif
#import <AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MediaPlayer.h>
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

static VisaReader* gVisaReader = nil;
static BOOL g_isBackGround1 = false;
static   NSString* g_PAN;/*卡号*/
static   NSString* g_KSN;/*刷卡器id*/
static   NSString* g_TrackInfo;/*卡号区分*/
static   NSString* g_Expiry;/*有效年月*/

static  BOOL isWakingUp = false;
static  BOOL isWakeUp = false;

@interface VisaReader()
{
    SwiperReader *swiperReader;
    NSTimer *callTimer;
    BOOL  isRuning;
    BOOL    palySounds;
}

-(void) willTerminate:(NSNotification *)notification;
-(void) readerCardInfo;
-(void) deviceUnavailable;
-(void) readerIsDecoding;
-(void) readerErrorDisplay:(NSString*)errorCode;
-(void) openReader;
-(void) setMaxVolume;
-(void) closeReader;
-(void) setBackRound:(BOOL)backGround;
-(void) openReader:(BOOL) open;

@end

//声音被干扰的监听
void interruptionListener(void *inClientData, UInt32 inInterruptionState)
{
    // 电话处理
    if (inClientData != NULL)
    {
        [(VisaReader*)inClientData closeReader];
    }
}

@implementation VisaReader

void ReaderCallback(SwiperReaderStatus state, void* tmp, void*userData)
{
    if (g_isBackGround1)
        return;
    
    if (SRS_OK == state)
    {
        //银行卡信息 线程结束后返回 测试
        [(VisaReader*)userData performSelectorOnMainThread:@selector(readerCardInfo) withObject:nil waitUntilDone:NO];
        
//        [(VisaReader*)userData performSelector:@selector(readerCardInfo) withObject:nil afterDelay:0.1f];
    }
    else if (SRS_DeviceUnavailable == state)
    {
        [(VisaReader*)userData performSelectorOnMainThread:@selector(deviceUnavailable) withObject:nil waitUntilDone:NO];
    }
    else if (SRS_Decoding == state)
    {
        [(VisaReader*)userData performSelectorOnMainThread:@selector(readerIsDecoding) withObject:nil waitUntilDone:NO];
    }
    else if (SRS_DeviceAvailable == state)
    {
        [(VisaReader*)userData performSelectorOnMainThread:@selector(openReader) withObject:nil waitUntilDone:NO];
    }
    else if (SRS_Timerout == state)
    {
        [(VisaReader*)userData performSelectorOnMainThread:@selector(timeroutHandler) withObject:nil waitUntilDone:NO];
    }
    else
    {
        NSString *msg = [NSString stringWithFormat:@"ERROR:%d", (int)state];
        [(VisaReader*)userData performSelectorOnMainThread:@selector(readerErrorDisplay:) withObject:msg waitUntilDone:NO];
        [msg release];
    }
}

-(void)resetVisaReader:(BOOL)open;
{
    if (!open && isRuning)
    {
        [swiperReader close];
        isRuning = NO;
    }
    else if (open && !isRuning)
    {
        // 调试release接口
        //swiperReader open] == [swiperReader open:YES]  args: playSounds  YES:play sounds, NO:stop sounds play.
        [self openReader];
        
    }
}

- (void)updateElapsedTime:(NSTimer *) timer
{
}

- (void)deviceChanged:(NSNotification *)note
{
}

- (void)displayInputInfo:(NSNotification *)note
{
}


#pragma mark - View lifecycle

+(id)initWithDelegate:(id<VisaReaderDelegate>)delegate
{
    if (gVisaReader == nil)
    {
        gVisaReader = [[VisaReader alloc] init];
    }
    gVisaReader.myDelegate = delegate;
    return gVisaReader;

//    self = [super init];
//    if (self)
//    {
//        //[self createVisaReader];
//        self.myDelegate = delegate;
//    }
//    return self;
}

- (void)createVisaReader
{
    g_PAN = @"";/*银行号*/
    g_KSN = @"";/*卡类型*/
    g_TrackInfo= @"";/*卡类型*/
    g_Expiry= @"";/*卡有效年月*/
    AudioSessionInitialize(nil, nil, interruptionListener, self);// init system audio model before using the lib.
    g_isBackGround1 = NO;
    palySounds = false;
    if (NULL == swiperReader)
    {
        swiperReader = [SwiperReader new];
        [swiperReader setCallback:ReaderCallback userData:self];
        char buf[64] = {};
        [swiperReader getVersion:buf withBufSize:sizeof(buf)];
        [swiperReader setDebugOn:"<<gd-seed>>:" open:false];
//        [swiperReader setTimerout:(30*1000*60)]; 
    }
    
#if 0  // hide the volume system icono
    MPVolumeView *volumeView = [[[MPVolumeView alloc] initWithFrame:
                                 CGRectMake(-200, -200, 1, 1)] autorelease];
    [self.view addSubview:volumeView];
    [volumeView setHidden:NO];
#endif
    
    //[[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    callTimer = nil;
    isRuning = NO;
}

// Called when notified the application is exiting or becoming inactive.
- (void)willTerminate:(NSNotification *)notification
{
}

- (void)dealloc
{
    [swiperReader release];
    [super dealloc];
}

int lib_error_info(const unsigned char *inbuf, unsigned char *outbuf, int len)
{
    int line = 0;
    line += inbuf[1];
    line += inbuf[2] << 8;
    char buf[32] = {};
    sprintf((char*)outbuf, "Error Line:%d \n", line);
    sprintf((char*)buf, "Track1_len:%d \n", inbuf[3]);
    strcat((char*)outbuf, buf);
    sprintf((char*)buf, "Track2_len:%d \n", inbuf[4]);
    strcat((char*)outbuf, buf);
    int offset = 5;
    for(int i = 0; i < 20; i++) {
        if (0 != i && 0 == i % 4) {
            strcat((char*)outbuf, " ");
        }
        
        if (i % 16 == 0 && 0 != i) {
            strcat((char*)outbuf, "\n");
        }
        
        sprintf(buf, "%02x", inbuf[offset + i]);
        strcat((char*)outbuf, buf);
    }
    
    strcat((char*)outbuf, "\n \n");
    offset += 20;
    for(int i = 0; i < len - 4 - 20; i++) {
        if (0 != i && 0 == i % 4) {
            strcat((char*)outbuf, " ");
        }
        
        if (i % 16 == 0 && 0 != i) {
            strcat((char*)outbuf, "\n");
        }
        
        sprintf(buf, "%02x", inbuf[offset + i]);
        strcat((char*)outbuf, buf);
    }
    
    strcat((char*)outbuf, "\n\n");
    for (int i = 0; i < len - 4 - 20; i++) {
        if (0 != i && 0 == i % 4) {
            strcat((char*)outbuf, "\n");
        }
        
        unsigned char tmp = inbuf[i + offset];
        for(int j = 0; j < 8; j++) {
            if (0 == (tmp & (1 << j))) {
                strcat((char*)outbuf, "0");
            } else {
                strcat((char*)outbuf, "1");
            }
        }
    }
    
    return 0;
    
}

bool dataCheck(unsigned char* text, unsigned char* first6Pan, unsigned char* last4Pan, int panLen)
{
    unsigned char track2[64] = {0};
    unsigned char track3[128] = {0};
    int i = 0;
    ToolKit::resolve_data23(text, track2, track3);
    if (0x0b != track2[0]) {
        return false;
    }
    
    for(i = 0; i < 6; i++) {
        if (first6Pan[i] != track2[i + 1] + '0') {
            return false;
        }
    }
    
    for(i = 0; i < 4; i++) {
        if (last4Pan[i] != track2[panLen + 1 - 4 + i] + '0') {
            return false;
        }
    }
    
    return true;
}

int lib12_parseTrack(const unsigned char *inbuf, unsigned char *outbuf, int len, int *trackCount, int *errorCount, bool isSix)
{
    char firmwareVersion[16] = {};
    char encryptionMode[32] = {};
    int  panLen = 0;
    char panFirst6Byte[32] = {};
    char panLast4Byte[32] = {};
    char expiryDate[32] = {};
    char userName[32] = {};
    char ksn[32] = {};
    char encryptedData[256] = {};
    char trackInfo[16] = {};
    unsigned char byTrackInfo = 0;
    unsigned char byEncryptionMode = 0;
    char xx[32] = {};
    const unsigned char *tmp = inbuf;
    *trackCount = 0;
    char buf[32] = {};
    
    tmp++;
    sprintf(firmwareVersion, "%02d.%02d", tmp[0], tmp[1]);
    
    tmp += 2;
    byEncryptionMode = *tmp;
    if (!isSix) {
        if (0 == byEncryptionMode) {
            strcpy(encryptionMode, "unknown");
        } else if (1 == byEncryptionMode) {
            strcpy(encryptionMode, "fixed key");
        } else {
            strcpy(encryptionMode, "dukpt");
        }
    } else {
        if (0 == byEncryptionMode) {
            strcpy(encryptionMode, "fixed key");
        } else if (0xfe == byEncryptionMode) {
            strcpy(encryptionMode, "dukpt");
        } else if (0xfd == byEncryptionMode){
            strcpy(encryptionMode, "plain text");
        } else if (0x01 == byEncryptionMode) {
            strcpy(encryptionMode, "disperse I");
        } else {
            strcpy(encryptionMode, "unknown");
        }
    }
    tmp++;
    
    panLen = tmp[0];
    for (int i = 0; i < panLen - 8; i++) {
        xx[i] = 'X';
    }
    
    tmp++;
    for(int i = 0; i < 6; i++) {
        panFirst6Byte[i] = (*tmp >> 4) + '0';
        i++;
        panFirst6Byte[i] = (*tmp & 0x0f) + '0';
        tmp++;
    }
    
    for(int i = 0; i < 4; i++) {
        panLast4Byte[i] = (*tmp >> 4) + '0';
        i++;
        panLast4Byte[i] = (*tmp & 0x0f) + '0';
        tmp++;
    }
    
    sprintf(expiryDate, "%02x%02X", tmp[0], tmp[1]);
    tmp += 2;
    
    for(int i = 0; i < 26; i++) {
        userName[i] = tmp[i];
    }
    tmp += 26;
    
    for(int i = 0; i < 10; i ++) {
        sprintf(ksn + 2 * i, "%02X", tmp[i]);
    }
    tmp += 10;
    
    int enterCount = 0;
    for(int i = 0; i < 80; i++) {
        if (i % 16 == 0 && 0 != i) {
            sprintf(encryptedData + 2 * i + enterCount, "\n");
            enterCount++;
        }
        
        sprintf(encryptedData + 2 * i + enterCount, "%02x", tmp[i]);
    }
    tmp += 80;
    
    int index = 0;
    byTrackInfo = *tmp;
    for (int i = 0; i < 3; i++) {
        if (byTrackInfo & (0x01 << i)) {
            trackInfo[index] = '1' + i;
            index++;
            (*trackCount)++;
        }
    }
    
    tmp++;
    *errorCount = *tmp;
    sprintf(buf, "SwiperCount:%d\n", *errorCount);
    NSLog(@"cow buf %s",buf);
    strcpy((char*)outbuf, "Firmware Version:");
    strcat((char*)outbuf, firmwareVersion);
    //strcat((char*)outbuf, "\n");
    strcat((char*)outbuf, "|");
    strcat((char*)outbuf, "Encryption Mode:");
    strcat((char*)outbuf, encryptionMode);
    //strcat((char*)outbuf, "\n");
    strcat((char*)outbuf, "|");
    strcat((char*)outbuf, "Track Info:");//卡类型
    strcat((char*)outbuf, trackInfo);
    //strcat((char*)outbuf, "\n");
    strcat((char*)outbuf, "|");
    strcat((char*)outbuf, "PAN:");
    strcat((char*)outbuf, panFirst6Byte);
    strcat((char*)outbuf, xx);
    strcat((char*)outbuf, panLast4Byte);
    //strcat((char*)outbuf, "\n");
    strcat((char*)outbuf, "|");
    strcat((char*)outbuf, "Expiry Date:");
    strcat((char*)outbuf, expiryDate);
    //strcat((char*)outbuf, "\n");
    strcat((char*)outbuf, "|");
    strcat((char*)outbuf, "User Name:");
    strcat((char*)outbuf, userName);
    
    //strcat((char*)outbuf, "\n");
    strcat((char*)outbuf, "|");
    strcat((char*)outbuf, "KSN:");
    g_KSN = [NSString stringWithCString:ksn encoding:NSUTF8StringEncoding];//将pos序列号输出Scanf C的数值 转换为OC对象
    strcat((char*)outbuf, ksn);
    //strcat((char*)outbuf, "\n");
    strcat((char*)outbuf, "|");
    strcat((char*)outbuf, "Encrypted Data:");
    //strcat((char*)outbuf, "\n");
    strcat((char*)outbuf, "|");
    strcat((char*)outbuf, encryptedData);
    //strcat((char*)outbuf, "\n");
    strcat((char*)outbuf, "|");
    if (*errorCount != 0) {
        strcat((char*)outbuf, buf);
    }
    
#if DECRYPTION_DATA
    if (isSix) {
        if (0 != byEncryptionMode) return 0;
    } else {
        if (1 != byEncryptionMode) return 0;
    }
    
    strcat((char*)outbuf, "Track Data:");
    //strcat((char*)outbuf, "\n");
    strcat((char*)outbuf, "|");
    
    unsigned char track_data[128];
    unsigned char track1[128] = {};
    unsigned char track2[128] = {};
    unsigned char allPan[32] = {0};
    unsigned char tmp_key[16] = {0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef, 0xfe, 0xdc, 0xba, 0x98, 0x76, 0x54, 0x32, 0x10};
    unsigned char temp_key[16] = {0x53, 0xef, 0x0e, 0x3b, 0x07, 0x84, 0xcb, 0x17, 0xac, 0x40, 0xc7, 0xbd, 0xc8, 0x99, 0x21, 0xdf};
    
    int track_data_len = 0;
    track_data_len = ToolKit::get_encryption_data(inbuf, track_data);
    
    // decrypte by default key
    for(int i = 0; i < track_data_len / 8; i++)
    {
        ToolKit::decryptByTDes(track_data + i * 8, tmp_key);
    }
    
    if (!dataCheck(track_data, (unsigned char *)panFirst6Byte, (unsigned char*)panLast4Byte, panLen)) {
        // decrypt by new key
        track_data_len = ToolKit::get_encryption_data(inbuf, track_data);
        for(int i = 0; i < track_data_len / 8; i++) {
            ToolKit::decryptByTDes(track_data + i * 8, temp_key);
        }
    }
    
    if (byTrackInfo & 0x01)
    {
        ToolKit::resolve_data12(track_data, track1, track2);
    }
    else
    {
        ToolKit::resolve_data23(track_data, track2, track1);
    }
    
    ToolKit::get_pan_from_track2(track2, allPan);
    
    // 一轨
    if (byTrackInfo & 0x01) {
        int track1_len = ToolKit::get_track1_len(track1);
        for(int i = 0; i < track1_len; i++) {
            track1[i] += 0x20;
            if ('?' == track1[i])
            {
                track1[i + 1] = 0;
                break;
            }
        }
        
        strcat((char*)outbuf, "#1:");
        strcat((char*)outbuf, (char*)track1);
        //strcat((char*)outbuf, "\n");
        strcat((char*)outbuf, "|");
    }
    
    char rgServerCode[5] = {0};
    char rgCVV[5] = {0};
    char rgPan[32] = {0};
    
    // 二轨
    if (byTrackInfo & 0x02) {
        int track2_len = ToolKit::get_track23_len(track2);
        
        for(int i = 0; i < track2_len; i++) {
            if (0x0d == track2[i]) {
                rgServerCode[0] = track2[i + 5] + '0';
                rgServerCode[1] = track2[i + 6] + '0';
                rgServerCode[2] = track2[i + 7] + '0';
                break;
            }
        }
        
        ToolKit::get_pan_from_track2((const unsigned char *)track2, (unsigned char *)rgPan);
        for(int i = 0; i < track2_len; i++) {
            if (0x0f == track2[i]) {
                track2[i] = track2[i] + '0';
                track2[i + 1] = 0;
                break;
            }
            
            track2[i] += '0';
        }
        strcat((char*)outbuf, "#2:");
        NSLog(@"Cow #2 %s",strcat((char*)outbuf, "#2:"));
        strcat((char*)outbuf, (char*)track2);
        //strcat((char*)outbuf, "\n");
        strcat((char*)outbuf, "|");
    }
    
    ToolKit::getCVV((const unsigned char*)rgPan, (const unsigned char*)expiryDate, (const unsigned char*)rgServerCode, (unsigned char*)rgCVV);
    /*
     char *pPan = "4123456789012345";
     char *pExpird = "8701";
     char *pServerCode = "101";
     char rgTmp[5] = {0};
     ToolKit::getCVV((const unsigned char*)pPan, (const unsigned char*)pExpird, (const unsigned char*)pServerCode, ( unsigned char*)rgTmp);
     */
    // 三轨
    if (byTrackInfo & 0x04) {
        int track3_len = ToolKit::get_track23_len(track1);
        for(int i = 0; i < track3_len; i++) {
            if (0x0f == track1[i]) {
                track1[i] = track1[i] + '0';
                track1[i + 1] = 0;
                break;
            }
            
            track1[i] += '0';
        }
        
        strcat((char*)outbuf, "#3:");
        strcat((char*)outbuf, (char*)track1);
        //strcat((char*)outbuf, "\n");
        strcat((char*)outbuf, "|");
    }
    
    strcat((char*)outbuf, "PAN:");
    g_PAN = [NSString stringWithCString:rgPan encoding:NSUTF8StringEncoding];
    strcat((char*)outbuf, rgPan);
    //strcat((char*)outbuf, "\n");
    strcat((char*)outbuf, "|");
    
    /**/
     strcat((char*)outbuf, "Expiry:");
     g_Expiry= [NSString stringWithCString:expiryDate encoding:NSUTF8StringEncoding];
     strcat((char*)outbuf, expiryDate);
     strcat((char*)outbuf, "\n");
     
     strcat((char*)outbuf, "ServerCode:");
     strcat((char*)outbuf, rgServerCode);
     strcat((char*)outbuf, "\n");
     
     strcat((char*)outbuf, "CVV:");
     strcat((char*)outbuf, rgCVV);
     strcat((char*)outbuf, "\n");
    
     strcat((char*)outbuf, "Track Info:");
     g_TrackInfo= [NSString stringWithCString:trackInfo encoding:NSUTF8StringEncoding];
     strcat((char*)outbuf, trackInfo);
     strcat((char*)outbuf, "\n");
    
#endif
    return 0;
}

bool crcVerify(unsigned char *buf, int len)
{
    unsigned char crc = 0;
    for(int i = 0; i < len; i++) {
        crc ^= buf[i];
        for (int j = 0; j < 8; j++) {
            if ((crc & 0x80) > 0) {
                crc <<= 1;
                crc ^= 0x07;
            } else {
                crc <<= 1;
            }
        }
    }
    
    return crc == 0;
}

-(void) readerCardInfo
{
    int result = -1;
    char buf[1024] = {};
    char display[1024] = {};
    
    BOOL openReader = NO;
    int len = [swiperReader read:buf withBufferSize:sizeof(buf)];
    isRuning = NO;
    
    if (len < 1)
    {
        result = 1;
        sprintf(display, "Decode Error!");
        [swiperReader writeRecordToFile:"pad_DecodeError.raw"];
    }
//    else if (!crcVerify((unsigned char *)buf, len))
//    {
//        result = 2;
//        sprintf(display, "CRC Error!");
//        [swiperReader writeRecordToFile:"pad_CrcError.raw"];
//    }
    else if (   0x48 == buf[0]
               || 0x07 == buf[0]
               || 0x50 == buf[0]
               || 0x08 == buf[0]
               || 0x49 == buf[0])
    { // 2 3轨数据解析
        result = 3;
        sprintf(display, "Please update the lastest hardware !!");
    }
    else if (0x60 == buf[0])
    {
        result = 0;
        [swiperReader writeRecordToFile:"pad_NormalCode.raw"];
        int trackCount = 0;
        int errorCount = 0;
        lib12_parseTrack((unsigned char *)buf, (unsigned char *)display, len, &trackCount, &errorCount, !palySounds);
        openReader = YES;
        if (errorCount > 1)
            openReader = NO;
    }
    else if (0x66 == buf[0])
    {
        result = 4;
        lib_error_info((unsigned char *)buf, (unsigned char *)display, len);
    }
    else if(0x4D == buf[1])
    {
        openReader = YES;
        [self unLoadWakingUp];
    }
    else
    {
        result = 5;
        sprintf(buf, "Unknown format");
    }
    
    [swiperReader close];
    NSLog(@"Card Info: %s", display);
    if (openReader)
    {
        [self openReader:YES];
    }
    NSString* str = @"";
    if (strlen(display) <=0)
    {
        str = [NSString stringWithCString:display encoding:NSUTF8StringEncoding];
    }
   
    /*卡号 刷卡器id 信用那个卡类型 有效年月*/
    NSString* string = [NSString stringWithFormat:@"%@***@@@$$$%@***@@@$$$%@***@@@$$$%@***@@@$$$",g_PAN,g_KSN,g_TrackInfo,g_Expiry];

    NSLog(@"Card Info 插卡时间过久 这里奔溃: %@", string);
    NSLog(@"Cow 第一g_PAN %@ \n 第二g_KSN %@ \n xy2 df23卡号类型 %@ \n卡年月%@",g_PAN,g_KSN,g_TrackInfo,g_Expiry);
    [gVisaReader.myDelegate doVisaReaderEvent:SRS_OK object:string];
}

-(void) deviceUnavailable
{
    [swiperReader close];
    isRuning = NO;
    if (gVisaReader.myDelegate!=nil) {
       
        if([gVisaReader.myDelegate respondsToSelector:@selector(doVisaReaderEvent:object:)])
            
        {
            [gVisaReader.myDelegate doVisaReaderEvent:SRS_DeviceUnavailable object:nil];
        }

    }
}

-(void) readerIsDecoding
{
    [gVisaReader.myDelegate doVisaReaderEvent:SRS_Decoding object:nil];
}

-(void) readerErrorDisplay:(NSString*)errorCode
{
    if (isWakingUp)
    {
        [swiperReader close];
        [self wakeUp];
        return;
    }
    [swiperReader writeRecordToFile:"pad_ErrorCode.raw"];
    [swiperReader close];
    isRuning = NO;
    [gVisaReader.myDelegate doVisaReaderEvent:SRS_Unknown object:nil];
}

-(void) openReader
{
    NSString* str = nil;
    printf("Function:%s \n", __FUNCTION__);
    if (isRuning)
    {
        str = @"1";
    }
    else if (SRS_OK == [swiperReader open:palySounds])
    {
        str = @"0";
        [self setMaxVolume];
        isRuning = YES;
    }
    [gVisaReader.myDelegate doVisaReaderEvent:SRS_DeviceAvailable object:str];
}

-(void) openReader:(BOOL) open
{
    printf("Function:%s \n", __FUNCTION__);
    if (isRuning) return;
    if (SRS_OK == [swiperReader open:palySounds]) {
        [self setMaxVolume];
        isRuning = YES;
    }
}

-(void) closeReader
{
    printf("Function:%s \n", __FUNCTION__);
    if (NULL != swiperReader) {
        if (isRuning) [swiperReader close];
        //[SwiperReader delete:swiperReader];
        //swiperReader = NULL;
    }
    
    isRuning = NO;
}

- (void) setMaxVolume
{
    float volume = [[MPMusicPlayerController applicationMusicPlayer] volume];
    if (volume < 1) {
        [[MPMusicPlayerController applicationMusicPlayer] setVolume:1];
    }
}

-(void) setBackRound:(BOOL)backGround
{
    g_isBackGround1 = backGround;
}

-(void) timeroutHandler
{
    [self closeReader];
    [gVisaReader.myDelegate doVisaReaderEvent:SRS_Timerout object:nil];
}

-(void)resetModel:(BOOL)MS6xx;
{
    if (MS6xx)
    {
        palySounds = false;
    }
    else
    {
        palySounds = true;
    }

    if (isRuning)
    {
        [swiperReader close];
        [swiperReader open:palySounds];
    }
}

-(SwiperReaderStatus)open
{
    return [swiperReader open:false];
}
-(int)wakeUp
{
    if (!isWakeUp)
    {
        [swiperReader close];
        char buf[1] = {0x0c};
        [swiperReader open:false];
        return [swiperReader write:buf withWriteLen:1];
    }
    else
    {
        return 0;
    }
}

-(void)loadWakingUp
{
    isWakingUp = true;
}

-(void)unLoadWakingUp
{
    isWakingUp = NO;
    isWakeUp = true;
}

@end
