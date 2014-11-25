//
//  Person.h
//  Person
//
//  Created by 〝Cow﹏. on 14-7-3.
//  Copyright (c) 2014年 〝Cow﹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject<NSCoding,NSCopying>

@property (nonatomic,retain)NSString *mnutypeid;  /*功能分类id*/
@property (nonatomic,retain)NSString *mnuname;    /*功能名*/
@property (nonatomic,retain)NSString *mnutypename;/*功能分类名*/
@property (nonatomic,retain)NSString *mnuisconst; /*固定功能图标*/
@property (nonatomic,retain)NSString *mnuid;      /*固定id*/
@property (nonatomic,retain)NSString *pointnum;   /*使用次数*/
@property (nonatomic,retain)NSString *mnuno;      /*编号*/
@property (nonatomic,retain)NSString *mnuorder;   /*排序*/

@end


@interface BankPayList : NSObject

@property (nonatomic,retain)NSString *bkcardbanks;      /*银行卡名*/
@property (nonatomic,retain)NSString *bkcardbankmans;   /*用户名*/
@property (nonatomic,retain)NSString *bkcardnos;        /*卡号*/
@property (nonatomic,retain)NSString *bkcardids;        /*银行卡id*/
@property (nonatomic,retain)NSString *bkcardbankids;    /*所属银行id*/
@property (nonatomic,retain)NSString *Bkcardbanklogos;  /*银行logo*/
@property (nonatomic,retain)NSString *bkcardbankphones; /*预留电话*/
@property (nonatomic,retain)NSString *bkcardyxmonths;   /*有效月*/
@property (nonatomic,retain)NSString *bkcardyxyears;    /*有效年*/
@property (nonatomic,retain)NSString *bkcardcvvs;       /*cvv*/
@property (nonatomic,retain)NSString *bkcardidcards;    /*身份证*/
@property (nonatomic,retain)NSString *bkcardisdefaults; /*默认*/
@property (nonatomic,retain)NSString *bkcardcardtypes;  /*卡类型*/
@property (nonatomic, copy) NSString *bkcardbankcode;

@end

@interface NSNumber (MySort)

- (NSComparisonResult) myCompare:(NSString *)other;

@end
