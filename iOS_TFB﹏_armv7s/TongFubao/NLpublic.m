//
//  NLpublic.m
//  TongFubao
//
//  Created by ec on 14-9-4.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "NLpublic.h"

@implementation NLpublic

- (void)dealloc
{
    
}

/**
 * @函数名    encrypt.
 *
 * @说明      http报文body的aes加密.
 *
 * @参数1     (NSString*)str 输入格式化后的http的body明文.
 *
 * @返回值    返回加密后的NSData类型数据.
 */
#pragma mark - 加密
- (NSData *)encrypt:(NSString *)str
{
    NSString* string = [AESAdditions encryptString:str];//加密数据
    NSData* data = [NLUtils stringToData:string];
    return data;
}

/**
 * @函数名    decrypt.
 *
 * @说明      http返回报文的aes解密.
 *
 * @参数1     (NSString*)data 输入为http响应后返回的报文.
 *
 * @返回值    返回解密后的NSString类型数据.
 */
#pragma mark - 解密
- (NSString *)decrypt:(NSString *)data
{
    Byte *bytes = (Byte *)[[data dataUsingEncoding: NSUTF8StringEncoding] bytes];
    NSString* string = [NLUtils dataToString:[data dataUsingEncoding: NSUTF8StringEncoding]];
    
    if (bytes[0]==239 && bytes[1]==187 && bytes[2]==191)
    {
        string = [string substringFromIndex:3];
    }
    
    NSData* str = [AESAdditions decryptString:string];
    NSString *decodeString = [[NSString alloc] initWithData: str encoding: NSUTF8StringEncoding];
    //NSLog(@"decodeString:  %@",decodeString);
    return decodeString;
}

/**
 * @函数名    xml_TO_dictionary.
 *
 * @说明      http返回报文以kiss方式遍历解析并且转成字典方便调用.
 *
 * @参数1     (NSString*)data 输入为需要解析的数据.
 *
 * @参数2     (NSString *)rolePath 输入为需要解析的搜索路径.
 *
 * @返回值    返回解析后的NSDictionary类型数据.
 */
#pragma mark - 解析
- (id)xml_TO_dictionary:(NSData *)data rolePath:(NSString *)rolePath type:(PublicType)type
{
    DDXMLDocument *xmlDoc = [[DDXMLDocument alloc] initWithData:data options:0 error: nil];
    NSArray *msgbody = [xmlDoc nodesForXPath:rolePath error:nil];
    
    if (msgbody.count != 0)
    {
        //列表与非列表
        if (type == PublicList)
        {
            NSMutableArray *muArray = [NSMutableArray arrayWithCapacity:6];
            
            for (int i = 0; i<msgbody.count; i++)
            {
                //NSLog(@"  %D",i);
                NSMutableDictionary * msgDictionary = [NSMutableDictionary dictionaryWithCapacity:5];
                
                DDXMLNode *aNode = [[msgbody objectAtIndex: i] nextNode];
                
                do
                {
                    NSString *nodeKey=[aNode  name];
                    
                    if (![nodeKey isEqualToString:@""])
                    {
                        NSString *nodeValue =[aNode  stringValue];
                        [msgDictionary setObject:[self replaceUnicode:nodeValue] forKey:nodeKey];
                    }
                }
                while((aNode = [aNode nextSibling]));
                
                [muArray insertObject:msgDictionary atIndex:i];
            }
            
            return muArray;
        }
        else
        {
            NSMutableDictionary *msgDictionary = [NSMutableDictionary dictionaryWithCapacity:5];
            
            DDXMLNode *aNode = [[msgbody objectAtIndex:0] nextNode];
            
            do
            {
                NSString *nodeKey=[aNode name];
                
                if (![nodeKey isEqualToString:@""])
                {
                    NSString *nodeValue =[aNode  stringValue];
                    //NSLog(@" nodeKey:%@   nodeValue:%@",nodeKey,nodeValue);
                    [msgDictionary setObject:nodeValue forKey:nodeKey];
                }
            }
            while((aNode = [aNode nextSibling]));
            
            return msgDictionary;
        }
    }
    
    return nil;
}

#pragma mark - 解析子节点数组
- (NSMutableArray *)xml_TO_dictionary_child:(NSData*)data :(NSString *)rolePath
{
    DDXMLDocument *xmlDoc = [[DDXMLDocument alloc] initWithData:data options:0 error: nil];
    NSArray *msgbody = [xmlDoc nodesForXPath:rolePath error:nil];
    NSMutableArray *muArray = [NSMutableArray arrayWithCapacity:6];
    
    if (msgbody.count != 0)
    {
        
        for (int i = 0; i<msgbody.count; i++)
        {
            //NSLog(@"  %D",i);
            NSMutableDictionary * msgDictionary = [NSMutableDictionary dictionaryWithCapacity:5];
            DDXMLNode *aNode = [[msgbody objectAtIndex: i] nextNode];
            
            do
            {
                NSString *nodeKey=[aNode  name];
                
                if (![nodeKey isEqualToString:@""])
                {
                    NSString *nodeValue =[aNode  stringValue];
                    [msgDictionary setObject:[self replaceUnicode:nodeValue] forKey:nodeKey];
                }
            }
            while((aNode = [aNode nextSibling]));
            
            [muArray insertObject:msgDictionary atIndex:i];
        }
        
    }
    
    return muArray;
}

#pragma mark - utf解码
-(NSString *)replaceUnicode:(NSString *)unicodeStr {
    
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2]stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
    
}

/**
 * @函数名    msgbody.
 *
 * @说明      http请求报文body部分格式化.
 *
 * @参数1     (NSMutableDictionary *)input 输入为body消息内容部分格式化的数据.
 *
 * @参数2     (NSString *)api_name 输入为body头部api_name的数据.
 *
 * @参数3     (NSString *)api_name_func 输入为body头部api_name_func的数据.
 *
 * @返回值    返回格式化后的NSString类型数据.
 */
#pragma mark - 格式化
- (NSString *)msgbody:(NSDictionary *)input api_name:(NSString *)api_name api_name_func:(NSString *)api_name_func
{
    NSMutableString *szMuMyString = [NSMutableString stringWithString:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><operation_request><msgbody>"];
    NSEnumerator *enumerator = [input keyEnumerator];
    
    id object;
    
    NSString *tempStr;
    
    while(object = [enumerator nextObject])//遍历输出
    {
        id objectValue = [input objectForKey:object];
        
        if(objectValue != nil)
        {
            //            NSLog(@"%@所对应的value是 %@",object,objectValue);
            tempStr = [NSString stringWithFormat:@"<%@>%@</%@>",object,objectValue,object];
        }
        
        [szMuMyString appendFormat:[NSString stringWithFormat:@"%@",tempStr],nil];
    }
    
    NSString *header = [NSString stringWithFormat:@"</msgbody><msgheader version=%@><req_bkenv>00</req_bkenv><au_token>%@</au_token><req_time>%@</req_time><channelinfo><api_name>%@</api_name><api_name_func>%@</api_name_func><agentid>%@</agentid><authorid>%@</authorid></channelinfo><req_token>%@</req_token><req_version>%@</req_version><req_appenv>3</req_appenv></msgheader></operation_request>",[NSString stringWithFormat:@"\"%@\"",TFBVersion],[NLUtils get_au_token],[NLUtils get_req_time],api_name,api_name_func,[NLUtils getAgentid],[NLUtils getAuthorid],[NLUtils get_req_token],TFBVersion];
    
    [szMuMyString appendFormat:[NSString stringWithFormat:@"%@",header],nil];
    NSLog(@"reqXML%@",szMuMyString);
    
    return szMuMyString;
}


#pragma mark - zlib解压
-(NSData *)uncompressZippedData:(NSData *)compressedData
{
    if ([compressedData length] == 0) return compressedData;
    unsigned full_length = [compressedData length];
    unsigned half_length = [compressedData length] / 2;
    NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
    BOOL done = NO;
    int status;
    z_stream strm;
    strm.next_in = (Bytef *)[compressedData bytes];
    strm.avail_in = [compressedData length];
    strm.total_out = 0;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    
    if (inflateInit2(&strm, (15+32)) != Z_OK) return nil;
    while (!done) {
        // Make sure we have enough room and reset the lengths.
        if (strm.total_out >= [decompressed length]) {
            [decompressed increaseLengthBy: half_length];
        }
        
        uLong total_out = strm.total_out;
        strm.next_out = (Bytef*)[decompressed bytes]+total_out;
        strm.avail_out = [decompressed length]-total_out;
        // Inflate another chunk.
        status = inflate (&strm, Z_SYNC_FLUSH);
        if (status == Z_STREAM_END) {
            done = YES;
        } else if (status != Z_OK) {
            break;
        }
    }
    if (inflateEnd (&strm) != Z_OK) return nil;
    // Set real length.
    if (done) {
        [decompressed setLength: strm.total_out];
        return [NSData dataWithData: decompressed];
    } else {
        return nil;
    }
}

#pragma mark  zlib压缩
-(NSData*)compressZippedData: (NSData*)pUncompressedData
{
    if (!pUncompressedData || [pUncompressedData length] == 0)
    {
        NSLog(@"%s: Error: Can't compress an empty or null NSData object.", __func__);
        return nil;
    }
    z_stream zlibStreamStruct;
    zlibStreamStruct.zalloc    = Z_NULL; // Set zalloc, zfree, and opaque to Z_NULL so
    zlibStreamStruct.zfree     = Z_NULL; // that when we call deflateInit2 they will be
    //zlibStreamStruct.opaque    = Z_NULL; // updated to use default allocation functions.
    zlibStreamStruct.total_out = 0; // Total number of output bytes produced so far
    zlibStreamStruct.next_in   = (Bytef*)[pUncompressedData bytes]; // Pointer to input bytes
    zlibStreamStruct.avail_in  = [pUncompressedData length]; // Number of input bytes left to process
    int initError = deflateInit(&zlibStreamStruct, Z_DEFAULT_COMPRESSION);
    if (initError != Z_OK)
    {
        NSString *errorMsg = nil;
        switch (initError)
        {
            case Z_STREAM_ERROR:
                errorMsg = @"Invalid parameter passed in to function.";
                break;
            case Z_MEM_ERROR:
                errorMsg = @"Insufficient memory.";
                break;
            case Z_VERSION_ERROR:
                errorMsg = @"The version of zlib.h and the version of the library linked do not match.";
                break;
            default:
                errorMsg = @"Unknown error code.";
                break;
        }
        NSLog(@"%s: deflateInit2() Error: \"%@\" Message: \"%s\"", __func__, errorMsg, zlibStreamStruct.msg);
        return nil;
    }
    NSMutableData *compressedData = [NSMutableData dataWithLength:[pUncompressedData length]*1.01+12];
    int deflateStatus;
    do
    {
        zlibStreamStruct.next_out = [compressedData mutableBytes] - zlibStreamStruct.total_out;
        zlibStreamStruct.avail_out = [compressedData length] + zlibStreamStruct.total_out;
        deflateStatus = deflate(&zlibStreamStruct, Z_FINISH);
        
    } while ( deflateStatus == Z_OK );
    if (deflateStatus != Z_STREAM_END)
    {
        NSString *errorMsg = nil;
        switch (deflateStatus)
        {
            case Z_ERRNO:
                errorMsg = @"Error occured while reading file.";
                break;
            case Z_STREAM_ERROR:
                errorMsg = @"The stream state was inconsistent (e.g., next_in or next_out was NULL).";
                break;
            case Z_DATA_ERROR:
                errorMsg = @"The deflate data was invalid or incomplete.";
                break;
            case Z_MEM_ERROR:
                errorMsg = @"Memory could not be allocated for processing.";
                break;
            case Z_BUF_ERROR:
                errorMsg = @"Ran out of output buffer for writing compressed bytes.";
                break;
            case Z_VERSION_ERROR:
                errorMsg = @"The version of zlib.h and the version of the library linked do not match.";
                break;
            default:
                errorMsg = @"Unknown error code.";
                break;
        }
        NSLog(@"%s: zlib error while attempting compression: \"%@\" Message: \"%s\"", __func__, errorMsg, zlibStreamStruct.msg);
        deflateEnd(&zlibStreamStruct);
        return nil;
    }
    
    deflateEnd(&zlibStreamStruct);
    [compressedData setLength: zlibStreamStruct.total_out];
    return compressedData;
}


@end
