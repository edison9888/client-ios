//
//  EWMview.m
//  TongFubao
//
//  Created by  俊   on 14-7-30.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "EWMview.h"

@interface EWMview ()
{
    BOOL       saferflag;

    ZBarReaderView *readerView;
    ZBarSymbol     *symbol;
  
    NSString       *temp;
    AVAudioPlayer  *player;
    UIImageView    *captureimage;
}
@end

static EWMview *mView = nil;

@implementation EWMview

+ (id)singleton
{
    if (!mView)
    {
        mView = [[EWMview alloc]init];
    }
    return mView;
}

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
    // Do any additional setup after loading the view.
    
    self.selfFrame=self.view.frame;
   
    /*二维码页面*/
    if (_ewmToAPP==YES) {
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        
        ViewControllerProperty;
        
#endif
        NSInteger currentHeight;
        //获取当前屏幕size
        currentHeight = iphoneSize;
        self.title= @"APP下载";
        self.view.backgroundColor= RGBACOLOR(245, 245, 245, 1);
        [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 80, 250, 250)];
        imageView.image = imageName(@"ewm", @"jpg");
        [self.view addSubview:imageView];
        
        UILabel *lable= [[UILabel alloc]initWithFrame:CGRectMake(30, 370, 260, 30)];
        lable.text= @"扫描二维码，免费下载通付宝";
        lable.font= [UIFont systemFontOfSize:18];
        [self.view addSubview:lable];
    }else{
        
       [self moreViewToApp]; 
    }
    
    
}

-(void)rightItemClick:(id)sender{
    
}

-(void)moreViewToApp{
    
    self.view.backgroundColor= RGBACOLOR(245, 245, 245, 1);
    UISwipeGestureRecognizer *swipe1=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(removeSelfEWM)];
    swipe1.numberOfTouchesRequired=1;
    swipe1.direction=UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipe1];
    
    num = 0;
    upOrdown = NO;
    
    readerView = [[ZBarReaderView alloc]init];
    readerView.frame = CGRectMake(0, self.view.bounds.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    readerView.center=self.view.center;
    readerView.readerDelegate = self;
   
    //扫描区域
    CGRect scanMaskRect = CGRectMake(60, CGRectGetMidY(readerView.frame) - 126, 200, 200);
    
    //处理模拟器

    ZBarCameraSimulator *cameraSimulator
        = [[ZBarCameraSimulator alloc]initWithViewController:self];
        cameraSimulator.readerView = readerView;
    
    [self.view addSubview:readerView];
    //扫描区域计算
    //    readerView.scanCrop = [self getScanCrop:scanMaskRect readerViewBounds:readerView.bounds];
    
    UILabel *labe= [[UILabel alloc]initWithFrame:CGRectMake(30, 405, 260, 30) ];
    labe.textColor= [UIColor colorWithHex:0xFBC429];
    labe.backgroundColor= [UIColor clearColor];
    labe.text= @"将扫描框对准二维码图片即可扫描";
    [self.view addSubview:labe];
    
    captureimage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"capture.png"]];
    captureimage.frame = scanMaskRect;
    [self.view addSubview:captureimage];
    
    /*界面返回nav效果替换dissmiss下收效果*/
    UIButton *leftbtn= [BaseButton ButtonWithFrame:CGRectMake(20, 30, 30, 30) Target:self Selector:@selector(removeSelfEWM) Image:[UIImage imageNamed:@"navigationLeftBtnBack2"] Title:nil TitleColor:nil TitleColorSate:UIControlStateNormal];
//    leftbtn.tag= 501;
    [self.view addSubview:leftbtn];
    
    /*
    UIButton *rightbtn= [BaseButton ButtonWithFrame:CGRectMake(130, 30, 30, 30) Target:self Selector:@selector(removeSelfEWM:) Image:[UIImage imageNamed:@"btnmore_6"] Title:nil TitleColor:[UIColor lightGrayColor] TitleColorSate:UIControlStateNormal];
    [rightbtn setTitleColor:[UIColor colorWithHex:0xF9DB7B] forState:UIControlStateHighlighted];
    rightbtn.tag= 502;
    [self.view addSubview:rightbtn];
    
    UIButton *lightbtn= [BaseButton ButtonWithFrame:CGRectMake(260, 30, 30, 30) Target:self Selector:@selector(removeSelfEWM:) Image:[UIImage imageNamed:@"btnmore_2"] Title:nil TitleColor:[UIColor lightGrayColor] TitleColorSate:UIControlStateNormal];
    lightbtn.tag= 503;
    [self.view addSubview:lightbtn];
*/
    [readerView start];
    
    readerView.torchMode = 0;
    
    self.line = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 140, 3)];
    _line.image = [UIImage imageNamed:@"lineEWM.png"];
    [captureimage addSubview:_line];
    
    /*定时器，设定时间过1*/
    if (saferflag!=YES) {
        timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    }
}

-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(30, 10+2*num, 140, 2);
        if (2*num == 180) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(30, 10+2*num, 140, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
}

- (void)readerView:(ZBarReaderView *)MreaderView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image{
    
    //显示小的图片切图
    //    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 420, 70, 70)];
    //    imageView.image=image;
    //    [self.view addSubview:imageView];
    
    for (symbol in symbols) {
    
        temp = symbol.data;
    
        NSString *jap = @"http://";
        NSString *txmStr = @".";/*只扫描条形码的*/
        NSRange foundObj=[temp rangeOfString:jap options:NSCaseInsensitiveSearch];
        
        if(foundObj.length>0) {
            
         [NLUtils showAlertView:@"无法确定网址安全性，是否访问？" message:[NSString stringWithFormat:@"二维码内容：\n%@",temp] delegate:self tag:1 cancelBtn:@"取消" other:@"确定"];
            
        } else {
                       /*搜素是否有.*/
                       if ([temp rangeOfString:txmStr].location == NSNotFound) {
                           [NLUtils showAlertView:@"提示" message:[NSString stringWithFormat:@"您当前的条形码为:\n%@",temp] delegate:self tag:2 cancelBtn:@"取消" other:nil];
                           
                       }else{
                           temp= [NSString stringWithFormat:@"http://%@",symbol.data];
                          [NLUtils showAlertView:@"无法确定网址安全性，是否访问？" message:[NSString stringWithFormat:@"二维码内容：\n%@",temp] delegate:self tag:1 cancelBtn:@"取消" other:@"确定"];
                       }

                   }
      
        break;
        
       
    }
    
    [MreaderView stop];
    
}

- (void)initSound
{
    NSString *soundPath=[[NSBundle mainBundle] pathForResource:@"beep" ofType:@"ogg"];
    NSURL *soundUrl=[[NSURL alloc] initFileURLWithPath:soundPath];
    player=[[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    [player prepareToPlay];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (1 == buttonIndex)
    {
        [readerView start];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:temp]];
        
    }else{
        
        [readerView start];
    }
    
}

-(void)saferintoMain
{
    saferflag= YES;
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ApplicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:app];
}

-(void) ApplicationWillResignActive:(NSNotification*) notification
{
    [self viewDidLoad];
}

-(void)removeSelfEWM{
    
    [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        CGRect frame=self.view.frame;
        frame.origin.y-=frame.size.height;
        self.view.frame=frame;
    } completion:^(BOOL finished) {
       
    }];
}

-(void)removeSelfEWM:(UIButton*)sender
{
    switch (sender.tag) {
        case 501:
        {
            [self removeSelfEWM];
        }
            break;
        case 502:
        {
            [self addByPhotosAlbm];
          
        }
            break;
        case 503:
        {
            
            sender.selected=!sender.selected;
            
            if (sender.selected) {
              
                readerView.torchMode = 0;

            }else{
              
                readerView.torchMode = 1;
            }
            
        }
            break;
        default:
            break;
    }
}

/*相册*/
-(void)addByPhotosAlbm
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
		sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	}
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self performSelector:@selector(saveImageEWM:)
               withObject:image
               afterDelay:0.5];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)saveImageEWM:(UIImage*)image{
    
    UIImageView *ima= [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, captureimage.frame.size.width-10, captureimage.frame.size.height-10)];
    ima.image= image;
    ima.alpha= 0;
    [captureimage addSubview:ima];
    [readerView start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
