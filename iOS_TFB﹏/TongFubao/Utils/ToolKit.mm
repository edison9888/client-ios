//
//  Tools.mm
//  VisaReader
//
//  Created by macbook on 13-8-14.
//
//

#include "ToolKit.h"
#include <stdio.h>
#include <string.h>
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#import <Security/Security.h>
#import <CommonCrypto/CommonDigest.h>


#define  DES_ENCRYPT	0
#define  DES_DECRYPT	1

#define TRUE   1
#define FALSE   0

const unsigned char Table_Move_Left[16] =
{1, 1, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1};
const unsigned char Table_Move_Right[16] =
{0, 1, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1};


const unsigned char Table_SBOX[8][64] =
{
    {
        0xe,0x0,0x4,0xf,0xd,0x7,0x1,0x4,0x2,0xe,0xf,0x2,0xb,
        0xd,0x8,0x1,0x3,0xa,0xa,0x6,0x6,0xc,0xc,0xb,0x5,0x9,
        0x9,0x5,0x0,0x3,0x7,0x8,0x4,0xf,0x1,0xc,0xe,0x8,0x8,
        0x2,0xd,0x4,0x6,0x9,0x2,0x1,0xb,0x7,0xf,0x5,0xc,0xb,
        0x9,0x3,0x7,0xe,0x3,0xa,0xa,0x0,0x5,0x6,0x0,0xd
    },

    {
        0xf,0x3,0x1,0xd,0x8,0x4,0xe,0x7,0x6,0xf,0xb,0x2,0x3,

        //0x8,0x4,0xf,0x9,0xc,0x7,0x0,0x2,0x1,0xd,0xa,0xc,0x6,
        0x8,0x4,0xE,0x9,0xc,0x7,0x0,0x2,0x1,0xd,0xa,0xc,0x6,

        0x0,0x9,0x5,0xb,0xa,0x5,0x0,0xd,0xe,0x8,0x7,0xa,0xb,
        0x1,0xa,0x3,0x4,0xf,0xd,0x4,0x1,0x2,0x5,0xb,0x8,0x6,
        0xc,0x7,0x6,0xc,0x9,0x0,0x3,0x5,0x2,0xe,0xf,0x9
    },
    {
        0xa,0xd,0x0,0x7,0x9,0x0,0xe,0x9,0x6,0x3,0x3,0x4,0xf,
        0x6,0x5,0xa,0x1,0x2,0xd,0x8,0xc,0x5,0x7,0xe,0xb,0xc,
        0x4,0xb,0x2,0xf,0x8,0x1,0xd,0x1,0x6,0xa,0x4,0xd,0x9,
        0x0,0x8,0x6,0xf,0x9,0x3,0x8,0x0,0x7,0xb,0x4,0x1,0xf,
        0x2,0xe,0xc,0x3,0x5,0xb,0xa,0x5,0xe,0x2,0x7,0xc
    },
    {
        0x7,0xd,0xd,0x8,0xe,0xb,0x3,0x5,0x0,0x6,0x6,0xf,0x9,
        0x0,0xa,0x3,0x1,0x4,0x2,0x7,0x8,0x2,0x5,0xc,0xb,0x1,
        0xc,0xa,0x4,0xe,0xf,0x9,0xa,0x3,0x6,0xf,0x9,0x0,0x0,

        //0x6,0xc,0xa,0xb,0xa,0x7,0xd,0xd,0x8,0xf,0x9,0x1,0x4,
        0x6,0xc,0xa,0xb,0x1,0x7,0xd,0xd,0x8,0xf,0x9,0x1,0x4,

        0x3,0x5,0xe,0xb,0x5,0xc,0x2,0x7,0x8,0x2,0x4,0xe
    },
    {
        0x2,0xe,0xc,0xb,0x4,0x2,0x1,0xc,0x7,0x4,0xa,0x7,0xb,
        0xd,0x6,0x1,0x8,0x5,0x5,0x0,0x3,0xf,0xf,0xa,0xd,0x3,
        0x0,0x9,0xe,0x8,0x9,0x6,0x4,0xb,0x2,0x8,0x1,0xc,0xb,
        0x7,0xa,0x1,0xd,0xe,0x7,0x2,0x8,0xd,0xf,0x6,0x9,0xf,
        0xc,0x0,0x5,0x9,0x6,0xa,0x3,0x4,0x0,0x5,0xe,0x3
    },
    {
        0xc,0xa,0x1,0xf,0xa,0x4,0xf,0x2,0x9,0x7,0x2,0xc,0x6,
        0x9,0x8,0x5,0x0,0x6,0xd,0x1,0x3,0xd,0x4,0xe,0xe,0x0,
        0x7,0xb,0x5,0x3,0xb,0x8,0x9,0x4,0xe,0x3,0xf,0x2,0x5,
        0xc,0x2,0x9,0x8,0x5,0xc,0xf,0x3,0xa,0x7,0xb,0x0,0xe,
        0x4,0x1,0xa,0x7,0x1,0x6,0xd,0x0,0xb,0x8,0x6,0xd
    },
    {
        0x4,0xd,0xb,0x0,0x2,0xb,0xe,0x7,0xf,0x4,0x0,0x9,0x8,
        0x1,0xd,0xa,0x3,0xe,0xc,0x3,0x9,0x5,0x7,0xc,0x5,0x2,
        0xa,0xf,0x6,0x8,0x1,0x6,0x1,0x6,0x4,0xb,0xb,0xd,0xd,
        0x8,0xc,0x1,0x3,0x4,0x7,0xa,0xe,0x7,0xa,0x9,0xf,0x5,
        0x6,0x0,0x8,0xf,0x0,0xe,0x5,0x2,0x9,0x3,0x2,0xc
    },
    {
        0xd,0x1,0x2,0xf,0x8,0xd,0x4,0x8,0x6,0xa,0xf,0x3,0xb,
        0x7,0x1,0x4,0xa,0xc,0x9,0x5,0x3,0x6,0xe,0xb,0x5,0x0,
        0x0,0xe,0xc,0x9,0x7,0x2,0x7,0x2,0xb,0x1,0x4,0xe,0x1,
        0x7,0x9,0x4,0xc,0xa,0xe,0x8,0x2,0xd,0x0,0xf,0x6,0xc,
        0xa,0x9,0xd,0x0,0xf,0x3,0x3,0x5,0x5,0x6,0x8,0xb
    }
};

#define TST_BIT(p_in, bit_num)	(p_in[(bit_num-1)>>3] & (0x80>>((bit_num-1)&0x07))  )

#define PERMUTATION_ONE_BYTE(p_in,b_num1,b_num2,b_num3,b_num4,b_num5,b_num6,b_num7,b_num8, cout)		\
{	\
cout = 0;									\
if(TST_BIT(p_in, b_num1))	cout |= 0x80;	\
if(TST_BIT(p_in, b_num2))	cout |= 0x40;	\
if(TST_BIT(p_in, b_num3))	cout |= 0x20;	\
if(TST_BIT(p_in, b_num4))	cout |= 0x10;	\
if(TST_BIT(p_in, b_num5))	cout |= 0x08;	\
if(TST_BIT(p_in, b_num6))	cout |= 0x04;	\
if(TST_BIT(p_in, b_num7))	cout |= 0x02;	\
if(TST_BIT(p_in, b_num8))	cout |= 0x01;	\
}


#define		PermutationDataFirst(p_in, p_out, cout)		\
{	\
PERMUTATION_ONE_BYTE(p_in,	58, 50, 42, 34, 26, 18, 10, 2, p_out[0]);	\
PERMUTATION_ONE_BYTE(p_in,	60, 52, 44, 36, 28, 20, 12, 4, p_out[1]);	\
PERMUTATION_ONE_BYTE(p_in,	62, 54, 46, 38, 30, 22, 14, 6, p_out[2]);	\
PERMUTATION_ONE_BYTE(p_in,	64, 56, 48, 40, 32, 24, 16, 8, p_out[3]);	\
PERMUTATION_ONE_BYTE(p_in,	57, 49, 41, 33, 25, 17,  9, 1, p_out[4]);	\
PERMUTATION_ONE_BYTE(p_in,	59, 51, 43, 35, 27, 19, 11, 3, p_out[5]);	\
PERMUTATION_ONE_BYTE(p_in,	61, 53, 45, 37, 29, 21, 13, 5, p_out[6]);	\
PERMUTATION_ONE_BYTE(p_in,	63, 55, 47, 39, 31, 23, 15, 7, p_out[7]);	\
}


////////////////////////////////////////

#define		PermutationDataLast(p_in, p_out, cout)		\
{	\
PERMUTATION_ONE_BYTE(p_in,	40, 8, 48, 16, 56, 24, 64, 32, p_out[0]);	\
PERMUTATION_ONE_BYTE(p_in,	39, 7, 47, 15, 55, 23, 63, 31, p_out[1]);	\
PERMUTATION_ONE_BYTE(p_in,	38, 6, 46, 14, 54, 22, 62, 30, p_out[2]);	\
PERMUTATION_ONE_BYTE(p_in,	37, 5, 45, 13, 53, 21, 61, 29, p_out[3]);	\
PERMUTATION_ONE_BYTE(p_in,	36, 4, 44, 12, 52, 20, 60, 28, p_out[4]);	\
PERMUTATION_ONE_BYTE(p_in,	35, 3, 43, 11, 51, 19, 59, 27, p_out[5]);	\
PERMUTATION_ONE_BYTE(p_in,	34, 2, 42, 10, 50, 18, 58, 26, p_out[6]);	\
PERMUTATION_ONE_BYTE(p_in,	33, 1, 41,  9, 49, 17, 57, 25, p_out[7]);	\
}


#define		PermutationKeyFirst(p_in, p_out, cout)		\
{	\
PERMUTATION_ONE_BYTE(p_in,	57, 49, 41, 33, 25, 17,  9,  1, p_out[0]);	\
PERMUTATION_ONE_BYTE(p_in,	58, 50, 42, 34, 26, 18, 10,  2, p_out[1]);	\
PERMUTATION_ONE_BYTE(p_in,	59, 51, 43, 35, 27, 19, 11,  3, p_out[2]);	\
PERMUTATION_ONE_BYTE(p_in,	60, 52, 44, 36, 63, 55, 47, 39, p_out[3]);	\
PERMUTATION_ONE_BYTE(p_in,	31, 23, 15,  7, 62, 54, 46, 38, p_out[4]);	\
PERMUTATION_ONE_BYTE(p_in,	30, 22, 14,  6, 61, 53, 45, 37, p_out[5]);	\
PERMUTATION_ONE_BYTE(p_in,	29, 21, 13,  5, 28, 20, 12,  4, p_out[6]);	\
}


#define		PermutationSubkey(p_in, p_out, cout)		\
{	\
PERMUTATION_ONE_BYTE(p_in,	14, 17, 11, 24,  1,  5,  3, 28, p_out[0]);	\
PERMUTATION_ONE_BYTE(p_in,	15,  6, 21, 10, 23, 19, 12,  4, p_out[1]);	\
PERMUTATION_ONE_BYTE(p_in,	26,  8, 16,  7, 27, 20, 13,  2, p_out[2]);	\
PERMUTATION_ONE_BYTE(p_in,	41, 52, 31, 37, 47, 55, 30, 40, p_out[3]);	\
PERMUTATION_ONE_BYTE(p_in,	51, 45, 33, 48, 44, 49, 39, 56, p_out[4]);	\
PERMUTATION_ONE_BYTE(p_in,	34, 53, 46, 42, 50, 36, 29, 32, p_out[5]);	\
}


#define		PermutationAndExtend(p_in, p_out, cout)		\
{	\
PERMUTATION_ONE_BYTE(p_in,	32,  1,  2,  3,  4,  5,  4,  5, p_out[0]);		\
PERMUTATION_ONE_BYTE(p_in,	 6,  7,  8,  9,  8,  9, 10, 11, p_out[1]);		\
PERMUTATION_ONE_BYTE(p_in,	12, 13, 12, 13, 14, 15, 16, 17, p_out[2]);		\
PERMUTATION_ONE_BYTE(p_in,	16, 17, 18, 19, 20, 21, 20, 21, p_out[3]);		\
PERMUTATION_ONE_BYTE(p_in,	22, 23, 24, 25, 24, 25, 26, 27, p_out[4]);		\
PERMUTATION_ONE_BYTE(p_in,	28, 29, 28, 29, 30, 31, 32,  1, p_out[5]);		\
}


#define		PermutationPbox(p_in, p_out, cout)		\
{	\
PERMUTATION_ONE_BYTE(p_in,	16, 7, 20, 21, 29, 12, 28, 17, p_out[0]);	\
PERMUTATION_ONE_BYTE(p_in,	 1,15, 23, 26,  5, 18, 31, 10, p_out[1]);	\
PERMUTATION_ONE_BYTE(p_in,	 2, 8, 24, 14, 32, 27,  3,  9, p_out[2]);	\
PERMUTATION_ONE_BYTE(p_in,	19,13, 30,  6, 22, 11,  4, 25, p_out[3]);	\
}


#define move_left_rotation(key_tmp,cin,cout,offset)		\
do	\
{	\
cin = key_tmp[0];	cout = key_tmp[3];	\
\
key_tmp[0] <<= 1;	{ if(key_tmp[1] & 0x80)	key_tmp[0] |= 0x01;	}	\
key_tmp[1] <<= 1;	{ if(key_tmp[2] & 0x80)	key_tmp[1] |= 0x01;	}	\
key_tmp[2] <<= 1;	{ if(key_tmp[3] & 0x80)	key_tmp[2] |= 0x01;	}	\
\
key_tmp[3] <<= 1;	key_tmp[3] &= (~0x10);	\
{ if(cin & 0x80)	key_tmp[3] |= (0x01<<4);	}	{ if(key_tmp[4] & 0x80)	key_tmp[3] |= 0x01;	}	\
\
key_tmp[4] <<= 1;	{ if(key_tmp[5] & 0x80)	key_tmp[4] |= 0x01;	}	\
key_tmp[5] <<= 1;	{ if(key_tmp[6] & 0x80)	key_tmp[5] |= 0x01;	}	\
key_tmp[6] <<= 1;	{ if(cout & 0x08)		key_tmp[6] |= 0x01;	}	\
}	\
while(--offset);

#define move_rigth_rotation(key_tmp,cin,cout,offset)		\
while(offset--)		\
{		\
cin = key_tmp[6];	cout = key_tmp[3];		\
\
key_tmp[6] >>= 1;	{ if(key_tmp[5] & 0x01)	key_tmp[6] |= 0x80;	}		\
key_tmp[5] >>= 1;	{ if(key_tmp[4] & 0x01)	key_tmp[5] |= 0x80;	}		\
key_tmp[4] >>= 1;	{ if(key_tmp[3] & 0x01)	key_tmp[4] |= 0x80;	}		\
\
key_tmp[3] >>= 1;	key_tmp[3] &= (~0x08);		\
{ if(cin & 0x01)	key_tmp[3] |= 0x08;	}	{ if(key_tmp[2] & 0x01)	key_tmp[3] |= 0x80;	}		\
\
key_tmp[2] >>= 1;	{ if(key_tmp[1] & 0x01)	key_tmp[2] |= 0x80;	}		\
key_tmp[1] >>= 1;	{ if(key_tmp[0] & 0x01)	key_tmp[1] |= 0x80;	}		\
key_tmp[0] >>= 1;	{ if(cout & 0x10)		key_tmp[0] |= 0x80;	}		\
}


void des( unsigned char  p_data[],  unsigned char  p_key[], unsigned char mode)
{
#define p_left	p_output
#define p_right	((unsigned char *)(p_output+4))
    unsigned char cin,cout;
    unsigned char offset;

    unsigned char loop = 0;
    unsigned char key_tmp[8];
    unsigned char sub_key[6];

    unsigned char p_right_ext[8];
    unsigned char p_right_s[4];
    unsigned char p_output[8];

    p_right_ext[0] = p_data[0];		p_right_ext[1] = p_data[1];		p_right_ext[2] = p_data[2];		p_right_ext[3] = p_data[3];
    p_right_ext[4] = p_data[4];		p_right_ext[5] = p_data[5];		p_right_ext[6] = p_data[6];		p_right_ext[7] = p_data[7];
    PermutationDataFirst(p_right_ext, p_output, cout);

    p_right_ext[0] = p_key[0];		p_right_ext[1] = p_key[1];		p_right_ext[2] = p_key[2];		p_right_ext[3] = p_key[3];
    p_right_ext[4] = p_key[4];		p_right_ext[5] = p_key[5];		p_right_ext[6] = p_key[6];		p_right_ext[7] = p_key[7];
    PermutationKeyFirst(p_right_ext, key_tmp,cout);


    for(loop = 0; loop < 16; loop++)
    {
        if(mode == DES_ENCRYPT)
        {
            offset = Table_Move_Left[loop];
            move_left_rotation(key_tmp,cin,cout,offset);
        }
        else
        {
            offset = Table_Move_Right[loop];
            move_rigth_rotation(key_tmp,cin,cout,offset);
        }

        PermutationSubkey(key_tmp, sub_key, cout);
        PermutationAndExtend(p_right, p_right_ext, cout);


        p_right_ext[0] ^= sub_key[0];		p_right_ext[1] ^= sub_key[1];	p_right_ext[2] ^= sub_key[2];
        p_right_ext[3] ^= sub_key[3];		p_right_ext[4] ^= sub_key[4];	p_right_ext[5] ^= sub_key[5];


        {
            p_right_s[0] = (Table_SBOX[0][p_right_ext[0]>>2]<<4);
            offset = ((p_right_ext[0]&0x3)<<4);		p_right_s[0] |= Table_SBOX[1][(p_right_ext[1]>>4) | offset ]; //byte0

            offset = (p_right_ext[1]<<4);	offset |= (p_right_ext[2]>>4);		offset >>= 2;	p_right_s[1] = (Table_SBOX[2][offset]<<4);
            p_right_s[1] |= Table_SBOX[3][p_right_ext[2] & 0x3f]; //byte1

            p_right_s[2] = (Table_SBOX[4][p_right_ext[3]>>2]<<4);
            offset = ((p_right_ext[3]&0x3)<<4);		p_right_s[2] |= Table_SBOX[5][(p_right_ext[4]>>4) | offset ]; //byte2

            offset = (p_right_ext[4]<<4);	offset |= (p_right_ext[5]>>4);		offset >>= 2;	p_right_s[3] = (Table_SBOX[6][offset]<<4);
            p_right_s[3] |= Table_SBOX[7][p_right_ext[5] & 0x3f]; //byte3
        }

        PermutationPbox(p_right_s, p_right_ext, cout);

        p_right_ext[0] ^= p_left[0];		p_right_ext[1] ^= p_left[1];	p_right_ext[2] ^= p_left[2];	  p_right_ext[3] ^= p_left[3];

        p_left[0] = p_right[0];		p_left[1] = p_right[1];		p_left[2] = p_right[2];		p_left[3] = p_right[3];
        p_right[0] = p_right_ext[0];	p_right[1] = p_right_ext[1];		p_right[2] = p_right_ext[2];		p_right[3] = p_right_ext[3];
    }

    //memcpy(p_right_ext,   p_right, 4);
    p_right_ext[0] = p_right[0];	p_right_ext[1] = p_right[1];	p_right_ext[2] = p_right[2];	p_right_ext[3] = p_right[3];

    //memcpy(&p_right_ext[4], p_left, 4);
    p_right_ext[4] = p_left[0];	p_right_ext[5] = p_left[1];	p_right_ext[6] = p_left[2];	p_right_ext[7] = p_left[3];


    PermutationDataLast(p_right_ext, p_output, cout);

    p_data[0] = p_output[0];	p_data[1] = p_output[1];	p_data[2] = p_output[2];	p_data[3] = p_output[3];
    p_data[4] = p_output[4];	p_data[5] = p_output[5];	p_data[6] = p_output[6];	p_data[7] = p_output[7];
}

bool ToolKit::encryptByTDes(unsigned char* pSrc, unsigned char* pKey) {
    des(pSrc, pKey,		DES_ENCRYPT);
    des(pSrc, pKey+8,	DES_DECRYPT);
    des(pSrc, pKey,		DES_ENCRYPT);
    return true;
}

bool ToolKit::decryptByTDes(unsigned char* pSrc, unsigned char* pKey) {
    des(pSrc, pKey,		DES_DECRYPT);
    des(pSrc, pKey+8,	DES_ENCRYPT);
    des(pSrc, pKey,		DES_DECRYPT);
    return true;
}


bool ToolKit::encryptByDes(unsigned char* pSrc, unsigned char* pKey) {
    des(pSrc, pKey,		DES_ENCRYPT);
    return true;
}

bool ToolKit::decryptByDes(unsigned char* pSrc, unsigned char* pKey) {
    des(pSrc, pKey,		DES_DECRYPT);
    return true;
}

int ToolKit::get_encryption_data(const unsigned char *inbuf, unsigned char *outbuf)
{
    int len = 80;
    int offset = 48;
    memcpy(outbuf, inbuf + offset, len);
    return len;
}

void ToolKit::resolve_data12(const unsigned char *inbuf, unsigned char *out_track1, unsigned char *out_track2)
{
    int byte_count = 0;
    for(int i = 0; i < 20; i++) {
        out_track2[byte_count] = (inbuf[i] >> 4);
        byte_count++;
        out_track2[byte_count] = (inbuf[i] & 0x0f);
        byte_count++;
    }
    
    int bit_count = 0;
    byte_count = 0;
    unsigned char cur_byte = 0;
    for(int i = 20; i < 80; i++) {
        unsigned char tmp = inbuf[i];
        for(int j = 0; j < 8; j++) {
            if (0x00 != (tmp & 0x80)) {
                cur_byte |= (0x01 << (5 - bit_count));
            }
            
            bit_count++;
            if (6 == bit_count) {
                out_track1[byte_count] = cur_byte;
                byte_count++;
                bit_count = 0;
                cur_byte = 0;
            }
            
            tmp <<= 1;
        }
    }
    
    
}

void ToolKit::resolve_data23(const unsigned char *inbuf, unsigned char *out_track2, unsigned char *out_track3)
{
    int byte_count = 0;
    for(int i = 0; i < 20; i++) {
        out_track2[byte_count] = (inbuf[i] >> 4);
        byte_count++;
        out_track2[byte_count] = (inbuf[i] & 0x0f);
        byte_count++;
    }
    
    byte_count = 0;
    for(int i = 20; i < 80; i++) {
        out_track3[byte_count] = (inbuf[i] >> 4);
        byte_count++;
        out_track3[byte_count] = (inbuf[i] & 0x0f);
        byte_count++;
    }
}

int ToolKit::get_track1_len(const unsigned char *inbuf)
{
    for(int i = 0; i < 128; i++) {
        if (0x1f == inbuf[i]) {
            return i + 1;
        }
    }
    
    return 0;
}

int ToolKit::get_track23_len(const unsigned char *inbuf)
{
    for (int i = 0; i < 128; i++) {
        if (0x0f == inbuf[i]) {
            return i + 1;
        }
    }
    
    return 0;
}

int ToolKit::get_pan_from_track2(const unsigned char *inbuf, unsigned char* outbuf)
{
    for(int i = 0; i < 19; i++) {
        unsigned char curByte = inbuf[i + 1];
        if (0x0d == curByte) break;
        outbuf[i] = '0' + curByte;
    }
    
    return 0;
}

int ToolKit::get_pan_from_track1(const unsigned char *inbuf, unsigned char* outbuf)
{
    int index = 2;
    if ('B' != inbuf[1]) {
        index = 3;
    }
    
    for(int i = 0; i < 19; i++) {
        if ('^' == inbuf[i + index]) {
            break;
        }
        
        outbuf[i] = inbuf[i + index];
    }
    
    return 0;
}

int ToolKit::get_pan_from_track3(const unsigned char *inbuf, unsigned char* outbuf)
{
    for(int i = 0; i < 19; i++) {
        unsigned char curByte = inbuf[i + 3];
        if (0x0d == curByte) break;
        outbuf[i] = '0' + curByte;
    }
    
    return 0;
}

bool ToolKit::getCVV(const unsigned char* pPan, const unsigned char* pExpird, const unsigned char* pServerCode, unsigned char* pCVV)
{
    return true;
}


