//
//  Person.h
//  Person
//
//  Created by 〝Cow﹏. on 14-7-3.
//  Copyright (c) 2014年 〝Cow﹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject <NSCoding,NSCopying>

@property (nonatomic,copy)NSString *mnutypeid;  /*功能分类id*/
@property (nonatomic,copy)NSString *mnuname;    /*功能名*/
@property (nonatomic,copy)NSString *mnutypename;/*功能分类名*/
@property (nonatomic,copy)NSString *mnuisconst; /*固定功能图标*/
@property (nonatomic,copy)NSString *mnuid;      /*固定id*/
@property (nonatomic,copy)NSString *pointnum;   /*使用次数*/
@property (nonatomic,copy)NSString *mnuno;      /*编号*/
@property (nonatomic,copy)NSString *mnuorder;   /*排序*/
@end


@interface BankPayList : NSObject

@property (nonatomic,copy)NSString *bkcardbanks;      /*银行卡名*/
@property (nonatomic,copy)NSString *bkcardbankmans;   /*用户名*/
@property (nonatomic,copy)NSString *bkcardnos;        /*卡号*/
@property (nonatomic,copy)NSString *bkcardids;        /*银行卡id*/
@property (nonatomic,copy)NSString *bkcardbankids;    /*所属银行id*/
@property (nonatomic,copy)NSString *Bkcardbanklogos;  /*银行logo*/
@property (nonatomic,copy)NSString *bkcardbankphones; /*预留电话*/
@property (nonatomic,copy)NSString *bkcardyxmonths;   /*有效月*/
@property (nonatomic,copy)NSString *bkcardyxyears;    /*有效年*/
@property (nonatomic,copy)NSString *bkcardcvvs;       /*cvv*/
@property (nonatomic,copy)NSString *bkcardidcards;    /*身份证*/
@property (nonatomic,copy)NSString *bkcardisdefaults; /*默认支付*/
@property (nonatomic,copy)NSString *bkcardisdefaultpayment; /*默认付款*/
@property (nonatomic,copy)NSString *bkcardcardtypes;  /*卡类型*/
@property (nonatomic,copy) NSString *bkcardbankcode;

@end

@interface NSNumber (MySort)

- (NSComparisonResult) myCompare:(NSString *)other;

@end

@interface WageInfo : NSObject

@property (nonatomic,copy)NSString *wagemonth;   /*发放页面 暂时只用月份就行*/

/*
@property (nonatomic,copy)NSString *wagemoney;   发放金额
@property (nonatomic,copy)NSString *isqianshou;  签收状况
@property (nonatomic,copy)NSString *wageid;      工资id
@property (nonatomic,copy)NSString *wagestanum;  人数
 */
@end


@interface opHttpsRequest : NSObject

+ (SecIdentityRef)identityWithTrust;

+ (SecIdentityRef)identityWithCert;

+ (BOOL)extractIdentity:(SecIdentityRef *)outIdentity andTrust:(SecTrustRef*)outTrust fromPKCS12Data:(NSData *)inPKCS12Data;

+ (BOOL)identity:(SecIdentityRef *)outIdentity andCertificate:(SecCertificateRef*)outCert fromPKCS12Data:(NSData *)inPKCS12Data;

@end 
@interface opURLProtocal : NSURLProtocol
{
    NSURLConnection *connection;
    NSMutableData *proRespData;
}

@end

