//
//  SimpleXMLViewController.m
//  SimpleXML
//
//  Created by 王 松 on 12-6-27.
//  Copyright 2012 __MyCompanyName__. All rights reserved.


#import "SimpleXMLViewController.h"

@implementation SimpleXMLViewController
@synthesize xmlData;
@synthesize parserXML;
@synthesize  dataToParse, workingArray, workingEntry,workingPropertyString, elementsToParse;

//定义需要从xml中解析的元素
static NSString *kIDStr     = @"id";
static NSString *kNameStr   = @"name";
static NSString *kImageStr  = @"image";
static NSString *kArtistStr = @"artist";


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	//初始化用来临时存储从xml中读取到的字符串
	self.workingPropertyString = [NSMutableString string];
	
	//初始化用来存储解析后的xml文件
	self.workingArray = [NSMutableArray array];
	
	//从资源文件中获取images.xml文件
    /*获取数据转为data类型*/
	NSString *strPathXml = [[NSBundle mainBundle] pathForResource:@"images" ofType:@"xml"];
	
    
	//将xml文件转换成data类型
	self.xmlData = [[NSData alloc] initWithContentsOfFile:strPathXml];
	
	//初始化待解析的xml
	self.parserXML = [[NSXMLParser alloc] initWithData:xmlData];
	
	//初始化需要从xml中解析的元素
	self.elementsToParse = [NSArray arrayWithObjects:kIDStr, kNameStr, kImageStr, kArtistStr, nil];	
	
	//设置xml解析代理为self
	[parserXML setDelegate:self];
	
	//开始解析
	[parserXML parse];//调用解析的代理方法
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	[super viewDidUnload];
	self.xmlData = nil;
	self.parserXML = nil;
	self.dataToParse = nil;
	self.workingArray = nil;
	self.workingEntry = nil;
	self.workingPropertyString = nil;
	self.elementsToParse = nil;
}


- (void)dealloc {
	[xmlData release];
	[parserXML release];
	[dataToParse release];
	[workingArray release];
	[workingEntry release];
	[workingPropertyString release];
	[elementsToParse release];
    [super dealloc];
}
//遍例xml的节点
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
	attributes:(NSDictionary *)attributeDict
{
    // entry: { id (link), im:name (app name), im:image (variable height) }
    //判断elementName与images是否相等
    if ([elementName isEqualToString:@"images"])
	{
        //相等的话,重新初始化workingEntry
		self.workingEntry = [[[AppRecord alloc] init] autorelease];
    }
	//查询指定对象是否存在，我们需要保存的那四个对象，开头定义的四个static
    storingCharacterData = [elementsToParse containsObject:elementName];
}

//节点有值则调用此方法
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (storingCharacterData)
    {
		//string添加到workingPropertyString中
        [workingPropertyString appendString:string];
    }
}
//当遇到结束标记时，进入此句
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
	//判断workingEntry是否为空
	if (self.workingEntry)
	{
        if (storingCharacterData)
        {
			//NSString的方法，去掉字符串前后的空格
			NSString *trimmedString = [workingPropertyString stringByTrimmingCharactersInSet:
                                       [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            //将字符串置空
			[workingPropertyString setString:@""]; 
			//根据元素名，进行相应的存储
			if ([elementName isEqualToString:kIDStr])
            {
                self.workingEntry.appURLString = trimmedString;
            }
            else if ([elementName isEqualToString:kNameStr])
            {        
                self.workingEntry.appName = trimmedString;
            }
            else if ([elementName isEqualToString:kImageStr])
            {
                self.workingEntry.imageURLString = trimmedString;
            }
            else if ([elementName isEqualToString:kArtistStr])
            {
                self.workingEntry.artist = trimmedString;
            }
			
		}
	}
	//遇到images时，将本次解析的数据存入数组workingArray中，AppRecord对象置空
    if ([elementName isEqualToString:@"images"])
	{
		[self.workingArray addObject:self.workingEntry];  
		self.workingEntry = nil;
		//用于检测数组中是否已保存，实际使用时可去掉，保存的是AppRecord的地址
		NSLog(@"workingArray %@",workingArray);
	}
}


@end
