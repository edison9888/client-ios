//
//  Tools.h
//  VisaReader
//
//  Created by macbook on 13-8-14.
//
//

#ifndef __VisaReader__ToolKit__
#define __VisaReader__ToolKit__

class ToolKit
{
public:
    static bool encryptByTDes(unsigned char* pSrc, unsigned char* pKey);
    static bool decryptByTDes(unsigned char* pSrc, unsigned char* pKey);
    
    static bool encryptByDes(unsigned char* pSrc, unsigned char* pKey);
    static bool decryptByDes(unsigned char* pSrc, unsigned char* pKey);
    
    static int get_encryption_data(const unsigned char *in, unsigned char *out);
    
    static void resolve_data12(const unsigned char *in, unsigned char *out_track1, unsigned char *out_track2);
    static void resolve_data23(const unsigned char *in, unsigned char *out_track2, unsigned char *out_track3);
    static int get_track1_len(const unsigned char *in);
    static int get_track23_len(const unsigned char *in);
    
    static int get_pan_from_track2(const unsigned char *inbuf, unsigned char* outbuf);
    static int get_pan_from_track1(const unsigned char *inbuf, unsigned char* outbuf);
    static int get_pan_from_track3(const unsigned char *inbuf, unsigned char* outbuf);
    
    static bool getCVV(const unsigned char* pPan, const unsigned char* pExpird, const unsigned char* pServerCode, unsigned char* pCVV);
};

#endif /* defined(__VisaReader__ToolKit__) */
