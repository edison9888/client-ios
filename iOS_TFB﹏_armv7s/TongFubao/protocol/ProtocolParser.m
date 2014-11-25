

#import "ProtocolParser.h"
#import "NLProtocolData.h"
#import "NLContants.h"
#import <libxml/tree.h>
#import <libxml/parser.h>
#import <libxml/xpath.h>
#import <libxml/xpathInternals.h>
#import <libxml/xmlwriter.h>
#import <libxml/encoding.h>

#define RSP_XML_PARSER_ERROR 10000;

@interface ProtocolParser(private)

+(void)doParse:(xmlNodePtr)rootNode parent:(NLProtocolData*)parent;

+(int)doToXml:(NLProtocolData*)a write:(xmlTextWriterPtr)w;

@end

@implementation ProtocolParser(private)

//解析
+(void)doParse:(xmlNodePtr)rootNode parent:(NLProtocolData*)parent
{
    xmlNodePtr child=rootNode->children;
    if (child == NULL)
    {
        return;
    }
    
    while (child != NULL)
    {
        NSString* key = [NSString stringWithUTF8String:(char*)child->name];
        if ((xmlStrcmp(child->name, BAD_CAST"msgheader") == 0)
            || (xmlStrcmp(child->name, BAD_CAST"retinfo") == 0)
            || (xmlStrcmp(child->name, BAD_CAST"msgbody") == 0)
            || (xmlStrcmp(child->name, BAD_CAST"msgchild") == 0)
            || (xmlStrcmp(child->name, BAD_CAST"msproinfo") == 0)
            || (xmlStrcmp(child->name, BAD_CAST"msorder") == 0)
            || (xmlStrcmp(child->name, BAD_CAST"data") == 0)
            || (xmlStrcmp(child->name, BAD_CAST"clients") == 0)
            || (xmlStrcmp(child->name, BAD_CAST"paytype") == 0)
            || (xmlStrcmp(child->name, BAD_CAST"orderList") == 0)
            || (xmlStrcmp(child->name, BAD_CAST"order") == 0)
            || (xmlStrcmp(child->name, BAD_CAST"msgfile") == 0)
            || (xmlStrcmp(child->name, BAD_CAST"cityList") == 0)
            )
        {
            NLProtocolData* p = [[NLProtocolData alloc] initValue:nil
                                                           forKey:key
                                                             attr:nil
                                                         attrName:nil
                                                        valueType:NLProtocolDataValueNoCData];
            [parent addChild:p];
            [ProtocolParser doParse:child parent:p];
        }
        else if ((xmlStrcmp(child->name, BAD_CAST"req_seq") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"ope_seq") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"rettype") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"retcode") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"retmsg") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"result") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"message") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"smsmobile") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"adno") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"adpicurl") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"adtitle") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"adlinkurl") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"adallcount") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"bankid") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"bankno") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"bankname") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"apptype") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"appnewversion") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"appisnew") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"clearoldinfo") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"appdownurl") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"appnewcontent") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"appstrupdate") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"picid") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"pictype") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"picpath") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"uploadpictype") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"uploadurl") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"uploadmethod") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"authorid") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"agentid") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"agenttypeid") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"ispaypwd") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"smscode") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"helpid") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"helpcontent") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"helpdate") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"helpname") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"msgallcount") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"msgdiscount") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"accallmoney") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"acctypeid") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"acctypename") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"accmoney") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"accmonth") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"accincome") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"accpayout") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"accglistno") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"accgpaymode") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"accglistmoney") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"accglistdate") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"accglistid") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"accgstate") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"fee") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"feemoney") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"minfee") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"ccgno") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"ccgtime") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"huancardno") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"fucardno") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"paymoney") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"arrivemode") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"arrivetime") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"zhuancardno") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"allmoney") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"state") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"couponno") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"couponmoney") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"couponlimitnum") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"coupondate") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"paycardid") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"couponid") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"couponfee") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"appruleid") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"appruletitle") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"apprulecontent") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"updatetime") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"shopname") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"isshop") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"bkntno") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"payfee") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"arriveid") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"autruename") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"autrueidcard") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"auemail") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"aumobile") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"com") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"nu") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"state") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"status") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"time") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"context") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"version") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"mnuname") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"mnupic") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"mnuorder") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"mnuurl") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"mnuversion") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"comid") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"comname") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"apitype") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"comlogo") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"apiurl") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"orderstate") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"orderid") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"orderId") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"orderno") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"ordertime") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"ordermoney") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"orderpronum") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"orderpaytype") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"shman") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"shcmpyname") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"shaddress") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"fhstorage") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"fhwltype") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"ordermemo") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"allpromoney") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"fhwlmoney") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"proname") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"proprice") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"prounit") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"pronum") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"promoney") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"bankcardstar") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"activearriveid") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"smsmsg") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"smsphone") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"au_token") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"req_bkenv") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"mnuid") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"couponbank") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"couponcardno") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"huancardbank") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"fucardbank") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"accgcardno") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"accgcardbank") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"aushoucardbank") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"aushoucardman") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"aushoucardphone") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"aushoucardno") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"aushoucardstate") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"paytype") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"activememo") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"shoucardid") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"shoucardno") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"shoucardbank") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"shoucardman") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"shoucardmobile") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"rechaMoneyid") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"rechamoney") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"rechapaymoney") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"rechaisdefault") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"rechamemo") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"rechamobile") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"rechamobileprov") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"rechabkcardno") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"rechadatetime") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"rechastate") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"rechaqq") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"orderprodurename") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"ordernum") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"orderprice") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"ordershaddress") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"ordershman") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"ordershphone") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"orderpaystatus") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"wlno") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"kdcomanyid") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"yunmoney") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"produreid") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"produrename") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"produreprice") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"produrezheprice") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"produrememo") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"produrelimitnum") == 0)
                 
                 ||(xmlStrcmp(child->name, BAD_CAST"shaddressid") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"shaddress") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"shphone") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"shyunfei") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"shyunfeitype") == 0)
                 
                 ||(xmlStrcmp(child->name, BAD_CAST"shdefault") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"name") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"lastCheckTime") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"totalCheck") == 0)
                 
                 ||(xmlStrcmp(child->name, BAD_CAST"provinceName") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"city") == 0)
                 //游戏
                 ||(xmlStrcmp(child->name, BAD_CAST"gameId") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"gameName") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"gamename") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"platformId") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"platformName") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"area") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"server") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"totalPrice") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"account") == 0)
                 
                 //代理商
                 ||(xmlStrcmp(child->name, BAD_CAST"todayfenrun") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"areafenrun") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"salepaycardnum") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"areapaycardnum") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"areaauthornum") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"limitmaxnum") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"nowprice") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"limitminnum") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"orderdate") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"totalfenrun") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"appfunid") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"appfunname") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"allfenrun") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"agentno") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"agentname") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"agentmobile") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"prov") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"town") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"agentprotocol") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"custypeid") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"custypename") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"msgfile") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"pictypeid") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"pictypename") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"pictypeno") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"picuploadurl") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"relateAgent") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"agentcode") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"noticecontent") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"noticetitle") == 0)
                 //orderdate
                 
                 /*我的银行卡*/
                 ||(xmlStrcmp(child->name, BAD_CAST"bkcardid") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"bkcardno") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"bkcardbankid") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"bkcardbank") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"bkcardbanklogo") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"bkcardbankman") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"bkcardbankphone") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"bkcardyxyear") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"bkcardcvv") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"bkcardisdefault") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"bkcardcardtype") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"bkcardbankcode") == 0)
                 
                 ||(xmlStrcmp(child->name, BAD_CAST"bkcardshoudefault") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"bkcardfudefault") == 0)
                 
                 
                 
                 ||(xmlStrcmp(child->name, BAD_CAST"gesturepasswd") == 0
                    )
                 ||(xmlStrcmp(child->name, BAD_CAST"accountnumber") == 0
                    )
                 ||(xmlStrcmp(child->name, BAD_CAST"phonenumber") == 0
                    )
                 ||(xmlStrcmp(child->name, BAD_CAST"username") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"factBills") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"totalBill") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"factNumber") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"payNumber") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"company") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"proId") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"status") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"completeTime") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"price") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"quantity") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"queid") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"quecontent") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"que") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"answer") == 0)
                 
                 ||(xmlStrcmp(child->name, BAD_CAST"agentcompany") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"agentarea") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"agentaddress") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"agentmanphone") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"agentfax") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"agenthttime") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"agentbzmoney") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"cityCode") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"cityId") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"cityNameCh") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"cost") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"cityName") == 0)
                 
                 //主菜单的模板
                 ||(xmlStrcmp(child->name, BAD_CAST"isnew") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"mnutypeid") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"mnutypename") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"pointnum") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"mnuisconst") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"mnuno") == 0)
                 
                 /*易宝*/
                 ||(xmlStrcmp(child->name, BAD_CAST"verifyCode") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"bkcardbankname") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"bkordernumber") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"verifytoken") == 0)
                 
                 ||(xmlStrcmp(child->name, BAD_CAST"bkcardman") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"bkcardphone") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"bkcardtype") == 0)
               
                 /*读取快捷支付默认信用卡号*/
                 ||(xmlStrcmp(child->name, BAD_CAST"bkcardid") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"bkcardbank") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"Bkcardbanklogo") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"bkcardbankman") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"bkcardbankphone") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"bkcardyxmonth") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"bkcardidcard") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"bkcardisdefault") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"bkcardcardtype") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"paychalname") == 0)
                 
                 /* 飞机查询*/
                 ||(xmlStrcmp(child->name, BAD_CAST"airLineName") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"arriveTime") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"flight") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"craftType") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"airLineCode") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"aPortCode") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"price") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"quantity") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"dPortName") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"aPortName") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"takeOffTime") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"dPortCode") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"aPortCode") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"dCityCode") == 0)

                 
                 
                 /* 飞机舱位*/
                 ||(xmlStrcmp(child->name, BAD_CAST"id") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"price") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"standardPrice") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"oilFee") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"tax") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"standardPriceForChild") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"oilFeeForChild") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"taxForChild") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"standardPriceForBaby") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"oilFeeForBaby") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"taxForBaby") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"quantity") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"rerNote") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"endNote") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"refNote") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"class") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"expireYear") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"personCardId") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"receivePersonName") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"receiveBankName") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"receivePhone") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"requrl") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"flight") == 0)

                 
                 /*读取乘机人*/
                 ||(xmlStrcmp(child->name, BAD_CAST"msgchild") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"id") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"name") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"cardType") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"cardId") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"phoneNumber") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"passengerType") == 0)
                 
                 /*飞机生成订单号*/
                 ||(xmlStrcmp(child->name, BAD_CAST"orderId") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"verifyCode") == 0)
                 
                 /*飞机订单历史查询*/
                 ||(xmlStrcmp(child->name, BAD_CAST"departCity") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"arriveCity") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"createOrderTime") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"takeOffTime") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"flight") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"craftType") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"totalPrice") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"status") == 0)
                 
                 
                 
                 
                 
//                 /*飞机验证码*/
//                 ||(xmlStrcmp(child->name, BAD_CAST"msgchild") == 0)
//                 ||(xmlStrcmp(child->name, BAD_CAST"departCity") == 0)
//                 ||(xmlStrcmp(child->name, BAD_CAST"arriveCity") == 0)
//                 ||(xmlStrcmp(child->name, BAD_CAST"createOrderTime") == 0)
//                 ||(xmlStrcmp(child->name, BAD_CAST"flight") == 0)
//                 ||(xmlStrcmp(child->name, BAD_CAST"craftType") == 0)
//                 ||(xmlStrcmp(child->name, BAD_CAST"totalPrice") == 0)
//                 ||(xmlStrcmp(child->name, BAD_CAST"status") == 0)
                 

                 






                 
                 
                 
                 
    
                 /*酒店*/
                 ||(xmlStrcmp(child->name, BAD_CAST"districtId") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"districtName") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"zoneId") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"zoneName") == 0)
           
                 /*119 pay money people histoy*/
                 ||(xmlStrcmp(child->name, BAD_CAST"wagestanum") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"wageallmoney") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"wagemonth") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"wagepaymoney") == 0)
                 
                 ||(xmlStrcmp(child->name, BAD_CAST"ilist") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"staname") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"wagemoney") == 0)
                 ||(xmlStrcmp(child->name, BAD_CAST"wagepaymoney") == 0)
            )
        {
            xmlChar* valueChar = xmlNodeGetContent(child);
            NSString* value = nil;
            if (valueChar != NULL && xmlStrlen(valueChar) > 0)
            {
                value = [NSString stringWithUTF8String:(char*)valueChar];
            }
            free(valueChar);
            NLProtocolData* a = [[NLProtocolData alloc] initValue:value
                                                           forKey:key
                                                             attr:nil
                                                         attrName:nil
                                                        valueType:NLProtocolDataValueNoCData];
            [parent addChild:a];
        }
        child = child->next;
    }
}

+(int)doAddValue:(xmlTextWriterPtr)w valueType:(NLProtocolDataValueType)type value:(NSString*)value
{
    int rc = -1;
    switch (type)
    {
        case NLProtocolDataValueNoCData:
        {
            rc = xmlTextWriterWriteString(w, BAD_CAST[value UTF8String]);
            if (rc < 0)
            {
                return rc;
            }
        }
            break;
            
        case NLProtocolDataValueCData:
        {
            rc = xmlTextWriterStartCDATA(w);
            if (rc < 0)
            {
                return rc;
            }
            rc = xmlTextWriterWriteString(w, BAD_CAST[value UTF8String]);
            if (rc < 0)
            {
                return rc;
            }
            rc = xmlTextWriterEndCDATA(w);
            if (rc < 0)
            {
                return rc;
            }
        }
            break;
            
        default:
            break;
    }
    return rc;
}

+(int)doToXml:(NLProtocolData*)r write:(xmlTextWriterPtr)w
{
    if (r.key && [r.key length] > 0)
    {
        int rc = xmlTextWriterStartElement(w, BAD_CAST[r.key UTF8String]);
        if (rc < 0)
        {
            return rc;
        }
        if (r.attr && [r.attr length] > 0)
        {
            rc = xmlTextWriterWriteAttribute(w, BAD_CAST[r.attrName UTF8String], BAD_CAST[r.attr UTF8String]);
            if (rc < 0)
            {
                return rc;
            }
        }
        if (r.value && [r.value length] > 0)
        {
            [self doAddValue:w valueType:r.valueType value:r.value];
        }
        else
        {
            for (NSArray* cs in [r.children allValues])
            {
                for (NLProtocolData* c in cs)
                {
                    rc = [self doToXml:c write:w];
                    if (rc < 0)
                    {
                        return rc;
                    }
                }
            }
        }
        rc = xmlTextWriterEndElement(w);
        return rc;
    }
    return -1;
}

@end

static NSString *kIDStr     = @"msgheader";
static NSString *kNameStr   = @"msgbody";
static NSString *kImageStr  = @"retmsg";
static NSString *kArtistStr = @"rettype";
static NSArray  *elementsToParse;

@implementation ProtocolParser

//遍例xml的节点
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
	attributes:(NSDictionary *)attributeDict
{
    // entry: { id (link), im:name (app name), im:image (variable height) }
    //判断elementName与images是否相等
    if ([elementName isEqualToString:@"operation_response"])
	{
        //相等的话,重新初始化workingEntry
		workingEntry = [[AppRecord alloc] init];
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
	if (workingEntry)
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
                workingEntry.appURLString = trimmedString;
            }
            else if ([elementName isEqualToString:kNameStr])
            {
                workingEntry.appName = trimmedString;
            }
            else if ([elementName isEqualToString:kImageStr])
            {
                workingEntry.imageURLString = trimmedString;
            }
            else if ([elementName isEqualToString:kArtistStr])
            {
                workingEntry.artist = trimmedString;
            }
			
		}
	}
	//遇到images时，将本次解析的数据存入数组workingArray中，AppRecord对象置空
    if ([elementName isEqualToString:@"operation_response"])
	{
		[workingArray addObject:workingEntry];
		workingEntry = nil;
		//用于检测数组中是否已保存，实际使用时可去掉，保存的是AppRecord的地址
		NSLog(@"workingArray %@",workingArray);
	}
}


+(ProtocolRsp*)parse:(const char*)data length:(int)len
{
    ProtocolRsp* rsp = [[ProtocolRsp alloc] init];
 
    xmlDocPtr doc = xmlReadMemory(data, len, NULL, "UTF-8", XML_PARSE_RECOVER);
	if (NULL == doc)
    {
        rsp.code = RSP_XML_PARSER_ERROR;
		return rsp;
    }
	xmlNodePtr rootNode = xmlDocGetRootElement(doc); //确定文档根元素
	
    if (NULL == rootNode)
    {
        rsp.code = RSP_XML_PARSER_ERROR;
		xmlFreeDoc(doc);
		return rsp;
	}
    
    NSString* key = [NSString stringWithUTF8String:(char*)rootNode->name];
    NLProtocolData* a = [[NLProtocolData alloc] initValue:nil
                                                   forKey:key
                                                     attr:nil
                                                 attrName:nil
                                                valueType:NLProtocolDataValueNoCData];

    [ProtocolParser doParse:rootNode parent:a];
    rsp.actions = [NSArray arrayWithObject:a];
    
    xmlFreeDoc(doc);
    xmlCleanupParser();

    return rsp;
    
}

+(NSData*)reqArrayToXml:(NSArray*)as needCDATA:(BOOL)cdata
{
    int rc;
    xmlTextWriterPtr writer = NULL;
    xmlDocPtr doc = NULL;
    NSData* ret = nil;
    /* 创建一个新的xml Writer，无压缩*/
    writer = xmlNewTextWriterDoc(&doc, 0);
    if (writer == NULL)
    {
        goto RETURN;
    }
    
    /* 文档声明部分 */
    rc = xmlTextWriterStartDocument(writer, NULL, "UTF-8", NULL);
    if (rc < 0)
    {
        goto RETURN;
    }
    
    for (NLProtocolData* a in as)
    {
        rc = [self doToXml:a write:writer];
        if (rc < 0)
        {
            break;
        }
    }
    
    if (rc < 0)
    {
        goto RETURN;
    }
    
    rc = xmlTextWriterEndDocument(writer);
    if (rc < 0)
    {
        goto RETURN;
    }
    /*写XML文档（doc）到文件*/
    xmlChar* xmlMemory = 0;
    int size = 0;
    xmlDocDumpMemory(doc, &xmlMemory, &size);
    if (xmlMemory == NULL)
    {
        goto RETURN;
    }
    ret = [NSData dataWithBytesNoCopy:xmlMemory length:size freeWhenDone:YES];
    
RETURN:
    if (writer!=NULL)
    {
        xmlFreeTextWriter(writer);
    }
    if (doc!=NULL)
    {
        xmlFreeDoc(doc);
    }
    return ret;
}

+(NSData*)reqToXml:(NLProtocolData*)a// needCDATA:(BOOL)cdata
{
    int rc;
    xmlTextWriterPtr writer = NULL;
    xmlDocPtr doc = NULL;
    NSData* ret = nil;
    /* 创建一个新的xml Writer，无压缩*/
    writer = xmlNewTextWriterDoc(&doc, 0);
    if (writer == NULL)
    {
        goto RETURN;
    }
    
    /* 文档声明部分 */
    rc = xmlTextWriterStartDocument(writer, NULL, "UTF-8", NULL);
    if (rc < 0)
    {
        goto RETURN;
    }
    
    rc = [self doToXml:a write:writer];
    if (rc < 0)
    {
        goto RETURN;
    }
    
    rc = xmlTextWriterEndDocument(writer);
    if (rc < 0)
    {
        goto RETURN;
    }
    /*写XML文档（doc）到文件*/
    xmlChar* xmlMemory = 0;
    int size = 0;
    xmlDocDumpMemory(doc, &xmlMemory, &size);
    if (xmlMemory == NULL)
    {
        goto RETURN;
    }
    ret = [NSData dataWithBytesNoCopy:xmlMemory length:size];
    
RETURN:
    if (writer != NULL) 
    {
        xmlFreeTextWriter(writer);
    }
    if (doc != NULL) 
    {
        xmlFreeDoc(doc);
    }
    return ret;
}

@end
