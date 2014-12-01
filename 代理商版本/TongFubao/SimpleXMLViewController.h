//
//  SimpleXMLViewController.h
//  SimpleXML
//
//  Created by 王 松 on 12-6-27.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppRecord.h"
//添加xml解析协议，该协议必须实现三个方法
//可参考http://blog.csdn.net/perfect_promise/article/details/7696185
//xml是一种很简单的可扩展语言，具体可参考http://www.w3school.com.cn/xml/
@protocol NSXMLParserDelegate;

@interface SimpleXMLViewController : UIViewController 
	<NSXMLParserDelegate>{
		NSData *xmlData;
		NSXMLParser *parserXML;		
		NSData          *dataToParse;		
		NSMutableArray  *workingArray;
		NSMutableString *workingPropertyString;
		NSArray         *elementsToParse;
		BOOL            storingCharacterData;
		AppRecord       *workingEntry;
}
@property (nonatomic,retain) NSXMLParser *parserXML;
@property (nonatomic,retain) NSData *xmlData;
@property (nonatomic,retain) NSData          *dataToParse;	
@property (nonatomic,retain) NSMutableArray  *workingArray;
@property (nonatomic,retain) NSMutableString *workingPropertyString;
@property (nonatomic,retain) NSArray         *elementsToParse;
@property (nonatomic,retain) AppRecord       *workingEntry;

@end

