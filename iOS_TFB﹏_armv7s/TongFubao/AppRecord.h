

//定义一个保存xml解析数据类，该类使用了NSCoding协议
//可参考http://blog.csdn.net/perfect_promise/article/details/7696141
@interface AppRecord : NSObject<NSCoding>
{
    NSString *appName;
    UIImage *appIcon;
    NSString *artist;
    NSString *imageURLString;
    NSString *appURLString;
}

@property (nonatomic, retain) NSString *appName;
@property (nonatomic, retain) UIImage *appIcon;
@property (nonatomic, retain) NSString *artist;
@property (nonatomic, retain) NSString *imageURLString;
@property (nonatomic, retain) NSString *appURLString;

@end