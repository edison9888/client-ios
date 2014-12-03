//
//  NLUserSettingViewNew.m
//  TongFubao
//
//  Created by 〝Cow﹏.   on 14-11-27.
//  Copyright (c) 2014年 〝Cow﹏. All rights reserved.
//

#import "NLUserSettingViewNew.h"
#import "NLSandboxFile.h"
#import "NLRequestPostUploadHelper.h"
#import "NLBigImageViewController.h"
#import "NLAsynImageView.h"

@interface NLUserSettingViewNew ()
{
    NLProgressHUD* _hud;
   /*图片的张数*/
    int _index;
    int _upPicIndex;
    int _upOrDown;
    
    /*图片*/
    UIImage* _upImage;
    UIImage* _downImage;
    NLAsynImageView* myDownImage;
    UIImageView *imageModel;

    /*个人的基本信息*/
    NSString* _name;
    NSString* _cardid;
    NSString* _email;
    NSString* _up_image_name;
  

    /*图片信息*/
    NSMutableArray *array;
}

@property (weak, nonatomic) IBOutlet UIButton *knowLevelBtn;
@property (weak, nonatomic) IBOutlet UIButton *cardIdBtn;
@property (weak, nonatomic) IBOutlet UIButton *cardid2Btn;
@property (weak, nonatomic) IBOutlet UIButton *vipCardidBtn;
@property (weak, nonatomic) IBOutlet UIButton *viplicenseBtn;

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *cardidTF;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UITextField *licenseTF;

@property (strong, nonatomic) IBOutlet UIScrollView *scroller;
@property (weak, nonatomic) IBOutlet UIImageView *cardidIG;
@property (weak, nonatomic) IBOutlet UIImageView *cardid2IG;
@property (weak, nonatomic) IBOutlet UIImageView *vipCardidIG;
@property (weak, nonatomic) IBOutlet UIImageView *vipLicenseIG;


@end

@implementation NLUserSettingViewNew

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _up_image_name= @"";
      
         }
    return self;
}

/*下载图片*/
void UIImageFromURLUse( NSURL * URL, void (^imageBlock)(UIImage * image), void (^errorBlock)(void) )
{
    NSLog(@"URL = %@",URL);
    dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^(void)
                   {
                       NSData * data = [[NSData alloc] initWithContentsOfURL:URL];
                       UIImage * image = [[UIImage alloc] initWithData:data];
                       
                       dispatch_async( dispatch_get_main_queue(), ^(void){
                           
                           if(image != nil)
                           {
                               imageBlock(image);
                           }
                           else
                           {
                               errorBlock();
                           }
                       });
                   });
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self mainView];
    [self readAuthorInfo];
}

-(void)mainView
{
    self.title= @"用户信息登记";
    [self addRightButtonItemWithTitle:@"提交审核"];
    _scroller.contentSize = CGSizeMake(SelfWidth, 504);
    myDownImage = [[NLAsynImageView alloc]init];
    array       = [NSMutableArray array];
    imageModel  = [[UIImageView alloc]init];
    
}

- (IBAction)OnClickBtn:(UIButton*)sender {

    switch (sender.tag) {
        case 1:{[self peopleList];}
            break;
        case 2:{[self peoplePhoto:sender];}
        break;
        case 3:{[self peoplePhoto:sender];}
            break;
        case 4:{[self peoplePhoto:sender];}
            break;
        case 5:{[self peoplePhoto:sender];}
         break;
        default:
            break;
    }
}

/*用户权限及资质要求*/
-(void)peopleList
{
    NLPeopleLevel *pay= [[NLPeopleLevel alloc]init];
    [self.navigationController pushViewController:pay animated:YES];
}

/*身份证正反面*/
/*带身份证自拍照*/
/*营业执照扫描件*/
-(void)peoplePhoto:(UIButton*)sender
{
//    sender= (sender.tag == 2 ? _cardIdBtn : sender.tag == 3 ? _cardid2Btn : sender.tag == 4 ? _vipCardidBtn : _viplicenseBtn );

    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"从相册选取",@"立即拍照上传",@"查看大图",nil];
    [sheet showInView:_scroller withCompletionHandler:^(NSInteger buttonIndex) {
        NSLog(@"选择的按钮action:%d  %@",buttonIndex,sender);
        switch (buttonIndex) {
            case 0:{[self addByPhotosAlbm:sender.tag];}
                break;
            case 1:{[self addByCamel:sender.tag];}
                break;
            case 2:{[self showBigImageView:sender.tag];}
                break;
            default:
                break;
        }
        
    }];
}

/*相册选取*/
-(void)addByPhotosAlbm:(int)sender
{
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	picker.allowsEditing = YES;
	picker.view.tag= sender;
	picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
	{
        //混合类型 photo + movie
		picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    }
	[self presentViewController:picker animated:YES completion:nil];
    
}

/*照相获取*/
- (void) addByCamel:(int)sender
{
    /*先设定sourceType为相机，然后判断相机是否可用（ipod）没相机，不可用将sourceType设定为相片库*/
	UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
		sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	}
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    picker.view.tag= sender;
    [self presentViewController:picker animated:YES completion:nil];
}
/*查看大图*/
-(void)showBigImageView:(int)sender
{
    NLBigImageViewController* vc = [[NLBigImageViewController alloc] initWithNibName:@"NLBigImageViewController" bundle:nil];
    UIImageView *imageStr = (sender == 2 ? _cardidIG : sender == 3 ? _cardid2IG : sender == 4 ? _vipCardidIG : _vipLicenseIG );
    vc.myImage= imageStr.image;
    [self.navigationController pushViewController:vc animated:YES];
}


/*旧接口获取数据*/
-(void)readAuthorInfo
{
    NSString* name = [NLUtils getNameForRequest:Notify_readAuthorInfo];
    REGISTER_NOTIFY_OBSERVER(self, readAuthorInfoNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] readAuthorInfo];
}

-(void)readAuthorInfoNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        [self doReadAuthorInfoNotify:response];
      
    }
    else if (error == RSP_TIMEOUT)
    {
        [self showErrorInfo:@"请求超时,需要重新登录" status:NLHUDState_Error];
        [self performSelector:@selector(doPush) withObject:nil afterDelay:2.0f];
        return;
    }
    else
    {
        NSString* detail = response.detail;
        if (!detail || detail.length <= 0)
        {
            detail = @"服务器繁忙，请稍候再试";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

/*读取用户信息 现在值需要几个就懒得写那么多了*/
-(void)doReadAuthorInfoNotify:(NLProtocolResponse*)response
{
    _name = [response.data find:@"msgbody/autruename" index:0].value;
    _nameTF.text= _name;
    _cardid = [response.data find:@"msgbody/autrueidcard" index:0].value;
    _cardidTF.text= _cardid;
    _email = [response.data find:@"msgbody/auemail" index:0].value;
    _emailTF.text= _email;
    
    //图片的存放及上传
    NSArray* uploadmethod = [response.data find:@"msgbody/msgchild/uploadmethod"];
    NSString* uploadmethodStr = nil;
  
    NSArray* pictype = [response.data find:@"msgbody/msgchild/pictype"];
    NSString* pictypeStr = nil;
  
    NSArray* picpath = [response.data find:@"msgbody/msgchild/picpath"];
    NSString* picpathStr = nil;
   
    NSArray* uploadpictype = [response.data find:@"msgbody/msgchild/uploadpictype"];
    NSString* uploadpictypeStr = nil;
   
    NSArray* uploadurl = [response.data find:@"msgbody/msgchild/uploadurl"];
    NSString* uploadurlStr = nil;
    
    NSArray* picid = [response.data find:@"msgbody/msgchild/picid"];
    NSString* picidStr = nil;
    
    /*对应图片的下载*/
    for (int i=0; i<[uploadurl count]; i++)
    {
        NLProtocolData* data = [uploadmethod objectAtIndex:i];
        uploadmethodStr = data.value;
        data = [pictype objectAtIndex:i];
        pictypeStr = data.value;
        data = [picpath objectAtIndex:i];
        picpathStr = data.value;
        data = [uploadpictype objectAtIndex:i];
        uploadpictypeStr = data.value;
        data = [uploadurl objectAtIndex:i];
        uploadurlStr = data.value;
        data = [picid objectAtIndex:i];
        picidStr = data.value;
        
        [array addObject:[NSDictionary dictionaryWithObjectsAndKeys:uploadmethodStr,@"uploadmethod",pictypeStr,@"pictype",picpathStr,@"picpath",uploadpictypeStr,@"uploadpictype",uploadurlStr,@"uploadurl",picidStr,@"picid",nil]];
        
        UIImageFromURLUse([NSURL URLWithString:picpathStr], ^(UIImage *image) {
           
            /*1正面 2反面 9自拍 4营业执照*/
            imageModel = ([uploadpictypeStr isEqualToString:@"1"] ? _cardidIG : [uploadpictypeStr isEqualToString:@"2"] ? _cardid2IG : [uploadpictypeStr isEqualToString:@"9"] ? _vipCardidIG : _vipLicenseIG );
       
            imageModel.image= image;
          
        }, ^{
            NSLog(@"array %@",array);
        });
    }
}

/*提交审核*/
-(void)rightItemClick:(id)sender
{
    if ([self checkNoPictureInfo])
    {
         [self modifyAuthorInfo];
  
    }
}

/*上传图片*/
-(void)doUploadUserUpPictureInforNew
{
    NSString* document = [NLSandboxFile GetDocumentPath];
    NSString* path = nil;
    NSDictionary* dic = nil;
    /*是否选取图片*/
    if (_up_image_name.length > 0)
    {
        path = [NSString stringWithFormat:@"%@/%@",document,_up_image_name];
        dic = [NSDictionary dictionaryWithObjectsAndKeys:[array valueForKey:@"uploadurl"][0],@"url",path,@"path",nil];
        [NSThread detachNewThreadSelector:@selector(uploadPicture:) toTarget:self withObject:dic];
    }

}

-(void)uploadPicture:(NSDictionary *)dic
{
    @autoreleasepool
    {
        NSString* url = [dic objectForKey:@"url"];
        NSString* path = [dic objectForKey:@"path"];
        NSArray *nameAry=[path componentsSeparatedByString:@"/"];
        NSString* name = [nameAry objectAtIndex:[nameAry count]-1];
        NSString* result = [NLRequestPostUploadHelper postRequestWithURL:url postParems:nil picFilePath:path picFileName:name];
        NSNumber* object;
        NSRange range = [result rangeOfString:@"has been uploaded"];
        if (range.location > 0)
        {
            object = [NSNumber numberWithBool:YES];
        }
        else
        {
            object = [NSNumber numberWithBool:NO];
        }
        [self performSelectorOnMainThread:@selector(finishedUploadPictureNew:) withObject:object waitUntilDone:NO];
    }
}

/*图片加载*/
-(void)finishedUploadPictureNew:(NSNumber *)object
{
    
    NSString* uploadmark = nil;
    if ([object boolValue])
    {
        uploadmark = [NSString stringWithFormat:@"%d",1];
    }
    else
    {
        uploadmark = [NSString stringWithFormat:@"%d",0];
    }
    for (int i=0; i<array.count; i++) {
        
        NSString* path = [NSString stringWithFormat:@"%@%@",[array valueForKey:@"uploadurl"][i],_up_image_name];
        
        [self uploadAuthorPic:[array valueForKey:@"picid"][i]
                      picpath:path
                 uploadmethod:[array valueForKey:@"uploadmethod"][i]
                uploadpictype:[array valueForKey:@"uploadpictype"][i]
                   uploadmark:uploadmark];
        
    }
}

-(void)doUploadUserDownPictureInfor
{
    NSString* document = [NLSandboxFile GetDocumentPath];
    NSString* path = nil;
    NSDictionary* dic = nil;
    
    if (_up_image_name.length > 0) {
        
        for (int i=0; i<array.count; i++)
        {
            path = [NSString stringWithFormat:@"%@/%@",document,_up_image_name];
            dic = [NSDictionary dictionaryWithObjectsAndKeys:[array valueForKey:@"uploadurl"][i],@"url",path,@"path",nil];
            [NSThread detachNewThreadSelector:@selector(uploadPicture:) toTarget:self withObject:dic];
        }
    }
   
}

/*图片上传*/
-(void)uploadAuthorPic:(NSString*)picid picpath:(NSString*)picpath uploadmethod:(NSString*)uploadmethod uploadpictype:(NSString*)uploadpictype uploadmark:(NSString*)uploadmark
{
    NSString* name = [NLUtils getNameForRequest:Notify_uploadAuthorPic];
    REGISTER_NOTIFY_OBSERVER(self, uploadAuthorPicNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] uploadAuthorPic:picid
                                                              picpath:picpath
                                                         uploadmethod:uploadmethod
                                                        uploadpictype:uploadpictype
                                                           uploadmark:uploadmark];
}

-(void)uploadAuthorPicNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        //[_hud hide:YES];
        [self doUploadAuthorPicNotify:response];
    }
    else if (error == RSP_TIMEOUT)
    {
        [self showErrorInfo:@"请求超时,需要重新登录" status:NLHUDState_Error];
        [self performSelector:@selector(doPush) withObject:nil afterDelay:2.0f];
        return;
    }
    else
    {
        NSString* detail = response.detail;
        if (!detail || detail.length <= 0)
        {
            detail = @"服务器繁忙，请稍候再试";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

-(void)doUploadAuthorPicNotify:(NLProtocolResponse*)response
{
    
    [self showErrorInfo:@"提交成功，请等待审核完成" status:NLHUDState_NoError];
    [_hud hide:YES afterDelay:2];
    [self performSelector:@selector(backBar) withObject:nil afterDelay:2];
    
}

/*修改审核的信息进行提交 代理商信息新版不需要 暂不写*/
-(void)modifyAuthorInfo
{
    NSString* name = [NLUtils getNameForRequest:Notify_modifyAuthorInfo];
    REGISTER_NOTIFY_OBSERVER(self, modifyAuthorInfoNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] modifyAuthorInfo:_nameTF.text
                                                                idCard:_cardidTF.text
                                                                 email:_emailTF.text agentcompany:@"" agentarea:@"" agentaddress:@"" agentmanphone:@"" agentfax:@""];
}

/*修改的*/
-(void)modifyAuthorInfoNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [self doModifyAuthorInfoNotify:response];
    }
    else if (error == RSP_TIMEOUT)
    {
        [self showErrorInfo:@"请求超时,需要重新登录" status:NLHUDState_Error];
        [self performSelector:@selector(doPush) withObject:nil afterDelay:2.0f];
        return;
    }
    else
    {
        NSString* detail = response.detail;
        if (!detail || detail.length <= 0)
        {
            detail = @"服务器繁忙，请稍候再试";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

-(void)doModifyAuthorInfoNotify:(NLProtocolResponse*)response
{
    /*上传图片*/
    [self doUploadUserUpPictureInfor];
    
    NLProtocolData* data = [response.data find:@"msgbody/message" index:0];
    NSString* message = data.value;
    [self showErrorInfo:message status:NLHUDState_NoError];
    
    [self performSelector:@selector(viewToLastView) withObject:nil afterDelay:2];
}

-(void)viewToLastView
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)doUploadUserUpPictureInfor
{
    NSLog(@"array --%@ ==imageModel",array);
  
   NSString* document = [NLSandboxFile GetDocumentPath];
    
        for (int i=0; i<array.count; i++) {
            
            NSString *url = [array valueForKey:@"uploadurl"][i];
            NSString *upname= [ NSString stringWithFormat:@"%@_%@_%@.jpg",[NLUtils getRegisterMobile],[array valueForKey:@"uploadpictype"][i],[NLUtils get_req_time]];
            NSString *path = [NSString stringWithFormat:@"%@/%@",document,upname];
            
            NSArray *nameAry=[path componentsSeparatedByString:@"/"];
            NSString *name = [nameAry objectAtIndex:[nameAry count]-1];
            NSString *result = [NLRequestPostUploadHelper postRequestWithURL:url postParems:nil picFilePath:path picFileName:name];
            NSString* object;
            NSRange range = [result rangeOfString:@"has been uploaded"];
            if (range.location > 0)
            {
                object = @"1";
            }
            else
            {
                object = @"0";
            }
            
            [self performSelectorOnMainThread:@selector(finishedUploadPictureNew:) withObject:object waitUntilDone:NO];
            NSData* data = UIImageJPEGRepresentation(imageModel.image, 1.0);
            [data writeToFile:path atomically:YES];
        }

}


-(void)backBar
{
     [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*调用相机等*/
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self saveImage:image sender:picker.view.tag];

}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

/*保存图片 截图的*/
- (void)saveImage:(UIImage *)image sender:(int)sender
{
    NSString* document = [NLSandboxFile GetDocumentPath];
    NSString* path = nil;
  
    /*我感觉我太机智了*/
    UIImageView *imageMore = (sender == 2 ? _cardidIG : sender == 3 ? _cardid2IG : sender == 4 ? _vipCardidIG : _vipLicenseIG );
    imageMore.image= image;
    
    NSString *imageStr;
    if ((imageStr = (sender == 2 ? [array valueForKey:@"uploadpictype"][0] : sender == 3 ? [array valueForKey:@"uploadpictype"][1] : sender == 4 ? [array valueForKey:@"uploadpictype"][2] : [array valueForKey:@"uploadpictype"][3] )))
    {
        _up_image_name = [NSString stringWithFormat:@"%@_%@_%@.jpg",[NLUtils getRegisterMobile], imageStr,[NLUtils get_req_time]];
        path = [NSString stringWithFormat:@"%@/%@",document,_up_image_name];
        NSData* data = UIImageJPEGRepresentation(image, 1.0);
        [data writeToFile:path atomically:YES];
    }
    
//  for (int i=0; i<array.count; i++) {
//  
//      _up_image_name = [NSString stringWithFormat:@"%@_%@_%@.jpg",[NLUtils getRegisterMobile], [array valueForKey:@"picid"][i],[NLUtils get_req_time]];
//      path = [NSString stringWithFormat:@"%@/%@",document,_up_image_name];
//      NSData* data = UIImageJPEGRepresentation(imageStr.image, 1.0);
//      [data writeToFile:path atomically:YES];
//  }
}

-(void)setDownImage:(UIImage *)image pathUrl:(NSString *)pathUrl
{

}

/*错误的状态*/
-(void)showErrorInfo:(NSString*)detail status:(NLHUDState)status
{
    [_hud hide:YES];
    _hud = [[NLProgressHUD alloc] initWithParentView:self.view];
    switch (status)
    {
        case NLHUDState_Error:
        {
            _hud.detailsLabelText = detail;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unCheckmark.png"]] ;
            _hud.mode = MBProgressHUDModeCustomView;
            [_hud show:YES];
            [_hud hide:YES afterDelay:2];
        }
            break;
            
        case NLHUDState_NoError:
        {
            _hud.labelText = detail;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.png"]] ;
            _hud.mode = MBProgressHUDModeCustomView;
            [_hud show:YES];
            [_hud hide:YES afterDelay:2];
        }
            break;
            
        case NLHUDState_None:
        {
            _hud.labelText = detail;
            [_hud show:YES];
        }
            
        default:
            break;
    }
    return;
}

-(NSString*)getNoNilStr:(NSString*)str
{
    if (str == nil)
    {
        return @"";
    }
    return str;
}

/*验证审核信息*/
-(BOOL)checkNoPictureInfo
{
    BOOL modify = YES;
    if (![_name isEqualToString:_nameTF.text])
    {
        modify = YES;
        if (![NLUtils checkName:_nameTF.text])
        {
            [self showErrorInfo:@"输入正确的姓名" status:NLHUDState_Error];
            return NO;
        }
    }
    if (![_cardid isEqualToString:_cardidTF.text])
    {
        modify = YES;
        if (![NLUtils checkIdentity:_cardidTF.text])
        {
            [self showErrorInfo:@"输入正确的身份证号码" status:NLHUDState_Error];
            return NO;
        }
    }
    if (![_email isEqualToString:_emailTF.text])
    {
        modify = YES;
        if (![NLUtils checkEmail:_emailTF.text])
        {
            [self showErrorInfo:@"输入正确的电子邮箱" status:NLHUDState_Error];
            return NO;
        }
    }
     return modify;
}

@end
