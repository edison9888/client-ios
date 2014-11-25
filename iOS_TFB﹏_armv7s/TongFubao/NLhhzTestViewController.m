//
//  NLhhzTestViewController.m
//  TongFubao
//
//  Created by ec on 14-9-2.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "NLhhzTestViewController.h"
#import "NLpublic.h"

@interface NLhhzTestViewController ()
{
    NSData                *_data ;
    NSDictionary                 *_proCitys;
    NSMutableArray                      *_provinces;
    NSMutableDictionary                       *_cityLists;
}

@end

@implementation NLhhzTestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
    
    self.title= @"测试接口demo";
    
    UIButton *hhz = [[UIButton alloc]init];
    [hhz setFrame:CGRectMake(50, 70, 80, 50)];
    [hhz setBackgroundColor:[UIColor grayColor]];
    [hhz setTitle:@"测试" forState:UIControlStateNormal];
    [hhz addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:hhz];
    
    UIButton *hhz2 = [[UIButton alloc]init];
    [hhz2 setFrame:CGRectMake(150, 70, 80, 50)];
    [hhz2 setBackgroundColor:[UIColor grayColor]];
    [hhz2 setTitle:@"测试2" forState:UIControlStateNormal];
    [hhz2 addTarget:self action:@selector(test2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:hhz2];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];

    
    UIButton *yyy = [[UIButton alloc]init];
    [yyy setFrame:CGRectMake(50, 140, 80, 50)];
    [yyy setBackgroundColor:[UIColor grayColor]];
    [yyy setTitle:@"测试3" forState:UIControlStateNormal];
    [yyy addTarget:self action:@selector(yyy) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:yyy];
    
    UIButton *xxx = [[UIButton alloc]init];
    [xxx setFrame:CGRectMake(150, 140, 80, 50)];
    [xxx setBackgroundColor:[UIColor grayColor]];
    [xxx setTitle:@"测试4" forState:UIControlStateNormal];
    [xxx addTarget:self action:@selector(xxx) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:xxx];
    
    /*模擬xml測試*/
     NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"provinceList" ofType:@"xml"];
     _data  = [[NSData alloc] initWithContentsOfFile:plistPath];
    _cityLists =[[NSMutableDictionary alloc] initWithCapacity:30];
    [self parsedDataFromData:_data];
}

static NSString *kXML =@"//msc//provinces//province";
//取特定省份下包含所有城市
-(void) parsedDataFromData:(NSData *)data andProvince:(NSString *)province
{
    DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:data options:0 error:nil];
    /////解析
    
    NSArray*  items = [doc nodesForXPath:kXML error:nil];
    
    for (DDXMLElement *obj in items)
    {
        DDXMLNode *aUser = [obj attributeForName:@"value"];//取属性Name的值
        if ([aUser.stringValue isEqualToString:province])
        {
            NSArray * _temp_cityLists = [obj elementsForName:@"city"];//取城市点点列表，保存到数组中
            if(_temp_cityLists.count>0)//第二层
            {
                for (DDXMLElement *citys in _temp_cityLists)
                {
                    DDXMLNode *citynode=[citys attributeForName:@"value"];
                    DDXMLNode *cityCode=[citys attributeForName:@"cid"];
                    NSLog(@"%@",citynode.stringValue); //这里填充一个字典
                    [_cityLists setObject:cityCode.stringValue forKey:citynode.stringValue];
                }
            }
        }
    }
}


-(void)parsedDataFromData:(NSData *)data{
    DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:data options:0 error:nil];
    /////解析
    
    NSArray*  items = [doc nodesForXPath:kXML error:nil];
    
    for (DDXMLElement *obj in items) {
        DDXMLNode *aUser = [obj attributeForName:@"value"];
        [_provinces addObject:aUser.stringValue];
    }
}

-(void)yyy
{
    SingPayMoney *vc= [[SingPayMoney alloc]init];
    [NLUtils presentModalViewController:self newViewController:vc];
}

-(void)xxx
{
    [self parsedDataFromData:_data andProvince:[_provinces objectAtIndex:1]];
}

#pragma mark - 【测试2】按钮事件响应 ASIHTTPRequest方式请求实例
- (void)test2
{
    NSMutableDictionary * msgDictionary = [NSMutableDictionary dictionaryWithCapacity:5];
    [msgDictionary setObject:@"1" forKey:@"payMoney"];//支付金额
    [msgDictionary setObject:@"1" forKey:@"rechargemoney"];//充值金额
    [msgDictionary setObject:@"1" forKey:@"RechargeQQ"];//充值QQ
    [msgDictionary setObject:@"1" forKey:@"bkCardno"];//银行卡号
    [msgDictionary setObject:@"1" forKey:@"bkcardman"];//执卡人
    [msgDictionary setObject:@"1" forKey:@"bkcardexpireMonth"];//有效月份
    [msgDictionary setObject:@"1" forKey:@"bkcardmanidcard"];//执卡人身份证
    [msgDictionary setObject:@"1" forKey:@"bankid"];//银行id
    [msgDictionary setObject:@"1" forKey:@"bkcardexpireYear"];//有效年份
    [msgDictionary setObject:@"1" forKey:@"bkcardPhone"];//预留手机号码
    [msgDictionary setObject:@"1" forKey:@"bkcardcvv"];//有效年份
    [msgDictionary setObject:@"1" forKey:@"bkcardexpireYear"];//CVV
    [msgDictionary setObject:@"1" forKey:@"paytype"];//业务类型	默认：qqrecharge
    [msgDictionary setObject:@"1" forKey:@"paycardid"];//刷卡器设备号	读取刷卡器设备号，无为空
    
    [LoadDataWithASI loadDataWithMsgbody:msgDictionary apiName:@"ApiyibaoPayInfo" apiNameFunc:@"qqrechargeReq" rolePath:@"//operation_response/msgbody" type:PublicCommon completionBlock:^(id data, NSError *error) {
        
        NSLog(@"请求成功");
    }];
}

#pragma mark - ASIHTTPRequest方式的http请求成功回调
- (void)requestFinished:(ASIHTTPRequest *)request
{
//    NSString *temp3 = [[NLpublic new] decrypt: [request responseString]];
//    NSDictionary *msg = [[NLpublic new] xml_TO_dictionary:[temp3 dataUsingEncoding: NSUTF8StringEncoding] :@"//operation_response/msgbody"];
//    NSLog(@"获取到的数据为：  %@",msg);
//    NSLog(@"requestFinished  %@",temp3);
}

#pragma mark - ASIHTTPRequest方式的http请求失败回调
- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
	NSLog(@"send feedback error: %@", request.error.description);
}

#pragma mark - 【测试】按钮事件响应 AFNetWorking方式请求实例
- (void)test
{
    NSString *str=[NSString stringWithFormat:SERVER_URL];
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
   NSDictionary *dataDictionary = @{ @"querytype" : @"", @"querywhere" : @""  };
    
    NSData *bodyData = [[NLpublic new] encrypt:[[NLpublic new] msgbody:dataDictionary api_name:@"ApiWageInfo" api_name_func:@"readwagelists"]];
    [request setHTTPBody:bodyData];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = operation.responseString;
        NSString *temp3 = [[NLpublic new] decrypt: html];
        NSDictionary *msg = [[NLpublic new] xml_TO_dictionary:[temp3 dataUsingEncoding: NSUTF8StringEncoding] rolePath:@"//operation_response/msgbody" type:PublicCommon];
        if ([msg[@"result"]isEqualToString:@"success"]) {
        NSLog(@"获取到的数据为：  %@",msg);
           NSMutableArray *dataArr = [[NLpublic new] xml_TO_dictionary_child:[temp3 dataUsingEncoding: NSUTF8StringEncoding] :@"//operation_response/msgbody/msgchild/ilist/msgchild"];
         
        }
       
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@",error);
         [NLUtils showTosatViewWithMessage:@"获取列表失败！" inView:self.view hideAfterDelay:1.0 beIndeter:NO];
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
}

#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
