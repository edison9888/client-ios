//
//  AESAdditions.m
//  kvpioneer
//
//  Created by wu wangchun on 12-6-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AESAdditions.h"
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"
#import "NLUtils.h"
const static char aKeyValue[10][16] =
{
    {'r','w','g','D','i','q','M','3','2','v','5','@','9','C','R','!'},
    {'T','b','C','Y','$','Q','G','m','s','%','p','Z','6','&','c','r'},
    {'e','w','8','N','7','P','j','W','u','k','@','1','!','D','3','V'},
    {'9','m','7','J','W','a','P','H','*','p','n','I','8','B','j','$'},
    {'%','R','C','F','s','W','c','B','2','d','A','z','G','U','H','y'},
    {'H','s','d','8','4','w','P','z','5','e','q','p','g','@','X','j'},
    {'D','b','!','$','5','h','A','S','0','N','3','9','Z','U','I','P'},
    {'w','3','8','A','E','5','Y','*','d','N','k','U','O','i','W','!'},
    {'J','c','p','W','F','E','y','1','L','5','e','I','4','O','&','g'},
    {'C','9','i','j','n','H','u','L','D','e','d','!','3','7','&','V'}
};

@implementation AESAdditions

+(NSString*)encryptString:(NSString*)src
{
    const char * d=[src UTF8String];
    int index = [NLUtils rand1:9];
    NSData* data=[AESAdditions encrypt:d length:strlen(d) index:index];
    if (data==nil)
    {
        return nil;
    }
    NSString* str = [GTMBase64 stringByEncodingData:data];
    NSString* ret=[NSString stringWithFormat:@"%d%@",index,str];
    return ret;
}

+(NSData*)encryptData:(NSData *)src
{
    NSData* data=[AESAdditions encrypt:[src bytes] length:src.length];
    return data;
}

+(NSData*)encrypt:(const void*)src length:(int)len index:(int)index
{
    NSData *adata = [[NSData alloc] initWithBytes:aKeyValue[index] length:16];
    NSString* str = [NLUtils dataToString:adata];
    return [AESAdditions myEncrypt:src length:len key:str];
}

+(NSData*)myEncrypt:(const void*)src length:(int)len key:(NSString*)key
{
    char keyPtr[kCCKeySizeAES128+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    size_t bufferSize = len + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          src, len,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess)
    {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}

+(NSData*)encrypt:(const void*)src length:(int)len
{
    unsigned char index[1]={[NLUtils rand1:9]};
    char keyPtr[kCCKeySizeAES128]; // room for terminator (unused)
    bzero(keyPtr, kCCKeySizeAES128); // fill with zeroes (for padding)
    memcpy(keyPtr, aKeyValue[index[0]], kCCKeySizeAES128);
    NSData* en=[AESAdditions encrypt:src length:len key:keyPtr];
    return en;
    
    
    NSMutableData* ret=[NSMutableData dataWithCapacity:en.length+1];
    [ret appendBytes:index length:1];
    [ret appendData:en];
    return ret;
}

+(NSData*)encrypt:(const void*)src length:(int)len key:(const char*)keyPtr
{
    size_t bufferSize = len + kCCBlockSizeAES128;
    void* buffer = malloc(bufferSize);
    //bzero(buffer, bufferSize+1);
    bzero(buffer, bufferSize);
    size_t numBytesEncrypted = 0;
    char iv[16]={0};
    [[AESAdditions randIV] getCString:iv maxLength:16 encoding:NSUTF8StringEncoding];
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES128,
                                          NULL,
                                          src, len, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess)
    {
        NSMutableData* data=[NSMutableData dataWithCapacity:numBytesEncrypted];
        //[data appendBytes:iv length:16];
        [data appendBytes:buffer length:numBytesEncrypted];
        free(buffer);
        return data;
    }
    
    free(buffer); //free the buffer;
    return nil;
}

+(NSData*)decryptString:(NSString*)src
{
    NSRange range = NSMakeRange (0, 1);
   
    int index = [[src substringWithRange:range] intValue];
   
    NSString* str = [src substringFromIndex:1];
  
    NSData* data=[GTMBase64 decodeString:str];
    
    data=[AESAdditions decryptData:data lenght:data.length index:index];
    
    if (data==nil)
    {
        return nil;
    }
    
    return data;
}

+(NSData*)decryptData:(NSData *)src lenght:(int)len index:(int)index
{
    NSData *adata = [[NSData alloc] initWithBytes:aKeyValue[index] length:16];
    NSString* str = [NLUtils dataToString:adata];
    return [AESAdditions myDecrypt:[src bytes] length:len key:str];
}

+(NSData*)myDecrypt:(const void*)src length:(int)len key:(NSString*)key
{
    char keyPtr[kCCKeySizeAES128+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    size_t bufferSize = len + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          src, len,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess)
    {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer);
    return nil;
}

+(NSData*)decryptData:(NSData *)src
{
    NSData* data=[AESAdditions decrypt:[src bytes] length:src.length];
    return data;
}

+(NSData*)decrypt:(const void*)src length:(int)len
{
    if (len<16)
    {
        return nil;
    }
    const char* content = (const char*)src;
    unsigned char index=(unsigned)*(content+0);
    
    char keyPtr[kCCKeySizeAES128]; // room for terminator (unused)
    bzero(keyPtr, kCCKeySizeAES128); // fill with zeroes (for padding)
    memcpy(keyPtr, aKeyValue[index], kCCKeySizeAES128);    
    return [AESAdditions decrypt:content+1 length:len-1 key:keyPtr];

}

+(NSData*)decrypt:(const void*)src length:(int)len key:(const char*)keyPtr
{
    size_t bufferSize = len + kCCBlockSizeAES128;
    void* buffer = malloc(bufferSize);
    bzero(buffer, bufferSize);
    size_t numBytesDecrypted = 0;
    char iv[16]={0};
    memcpy(iv, src, 16);
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                          0,
                                          keyPtr, kCCKeySizeAES128,
                                          NULL ,
                                          src, len, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess)
    {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer); //free the buffer;
    return nil;
}

+(NSString*)randIV
{
    return [NLUtils createUUID];
}

@end
