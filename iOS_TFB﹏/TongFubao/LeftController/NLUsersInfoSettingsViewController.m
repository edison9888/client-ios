//
//  NLUsersInfoSettingsViewController.m
//  TongFubao
//
//  Created by MD313 on 13-8-1.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLUsersInfoSettingsViewController.h"
#import "NLBigImageViewController.h"
#import "NLUtils.h"
#import "NLUserInforSettingsCell.h"
#import "NLSandboxFile.h"
#import "NLContants.h"
#import "NLKeyboardAvoid.h"
#import "NLProgressHUD.h"
#import "NLProtocolRequest.h"
#import "NLRequestPostUploadHelper.h"


@interface NLUsersInfoSettingsViewController ()
{
    int _index;
    int _isModifyPic;
    int _upOrDown;
//    NSData* _upImageData;
//    NSData* _downImageData;
    UIImage* _upImage;
    UIImage* _downImage;
    NSString* _name;
    NSString* _id;
    NSString* _email;
    
    NSString* _company;
    NSString* _vestAdress;
    NSString* _abbr;
    NSString* _phone;
    NSString* _fax;
    NSString* _agenthttime;
    NSString* _agentbzmoney;
    NSString* _aucompany;
    NSString* _auvestAdress;
    NSString* _auabbr;
    NSString* _auphone;
    NSString* _aufax;
    NSString* _auagenthttime;
    NSString* _auagentbzmoney;
    
    NSString* _autruename;
    NSString* _autrueidcard;
    NSString* _auemail;
    NSString* _aumobile;
    NSString* _up_picid;
    NSString* _up_pictype;
    NSString* _up_picpath;
    NSString* _up_uploadpictype;
    NSString* _up_uploadurl;
    NSString* _up_uploadmethod;
    NSString* _up_uploadmark;
    NSString* _down_picid;
    NSString* _down_pictype;
    NSString* _down_picpath;
    NSString* _down_uploadpictype;
    NSString* _down_uploadurl;
    NSString* _down_uploadmethod;
    NSString* _down_uploadmark;
    NSString* _down_image_name;
    NSString* _up_image_name;
    NLProgressHUD* _hud;
    int _upPicIndex;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scroller;
@property(nonatomic,retain) IBOutlet NLKeyboardAvoidingTableView* myTableView;
@property(nonatomic,retain) NSString* myName;
@property(nonatomic,retain) NSString* myIDCord;
@property(nonatomic,retain) NSString* myEmail;

-(void)commitAndCheck;
//-(void)showAlertViewWithTextView:(int)tag  text:(NSString*)text preText:(NSString*)preText;

@end

@implementation NLUsersInfoSettingsViewController

@synthesize myTableView;
@synthesize myEmail;
@synthesize myIDCord;
@synthesize myName;

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
    // Do any additional setup after loading the view from its nib
    
    self.navigationController.topViewController.title=@"用户信息设置";
    
    [self navigation];
    
    [self initValue];
    
    [self readAuthorInfo];
   
    
}

-(void)navigation{
    
    if (_agentFlag==YES) {

        self.scroller.frame= CGRectMake(self.scroller.frame.origin.x, 0, 320, self.view.bounds.size.height+200);
        
        [self.scroller setContentSize:CGSizeMake(320,self.scroller.frame.size.height+200)];
        
        [self.view addSubview:self.scroller];
        
        myTableView.frame= CGRectMake(self.myTableView.frame.origin.x, self.myTableView.frame.origin.y, self.myTableView.frame.size.width, self.myTableView.frame.size.height+200);
        
        [self.scroller addSubview:myTableView];
        
    }else{
        
        myTableView.frame= CGRectMake(self.myTableView.frame.origin.x, self.myTableView.frame.origin.y+64, self.myTableView.frame.size.width, self.myTableView.frame.size.height);
        
        [self.view addSubview:myTableView];
    }
    
    UIButton* backButton = [NLUtils createNavigationLeftBarButtonImage];
    
    [backButton setBackgroundImage:[UIImage imageNamed:@"navigationLeftBtnBack2"] forState:UIControlStateNormal];
    
    [backButton addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"提交审核"
                                                                      style:UIBarButtonItemStyleBordered target:self
                                                                     action:@selector(commitAndCheck)];
	self.navigationItem.rightBarButtonItem = anotherButton;
}


-(void)backView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initValue
{
    _index = 0;
    _isModifyPic = 0;
    _upOrDown = -1;
    _upImage = nil;
    _downImage = nil;
    _name = nil;
    _id = nil;
    _email = nil;
    _company= nil;
    _vestAdress= nil;
    _abbr= nil;
    _phone= nil;
    _fax= nil;
    _agenthttime= nil;
    _agentbzmoney= nil;
    _aucompany= nil;
    _auvestAdress= nil;
    _auabbr= nil;
    _auphone= nil;
    _aufax= nil;
    _auagentbzmoney= nil;
    _auagenthttime= nil;
    
    _up_picid = nil;
    _up_pictype = nil;
    _up_picpath = nil;
    _up_uploadpictype = nil;
    _up_uploadurl = nil;
    _up_uploadmethod = nil;
    _up_uploadmark = nil;
    _down_picid = nil;
    _down_pictype = nil;
    _down_picpath = nil;
    _down_uploadpictype = nil;
    _down_uploadurl = nil;
    _down_uploadmethod = nil;
    _down_uploadmark = nil;
    _down_image_name = @"";
    _up_image_name = @"";
    _upPicIndex = -1;
}

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

-(BOOL)checkNoPictureInfo
{
    BOOL modify = YES;
    if (![_autruename isEqualToString:_name])
    {
        modify = YES;
        if (![NLUtils checkName:_name])
        {
            [self showErrorInfo:@"输入正确的姓名" status:NLHUDState_Error];
            return NO;
        }
    }
    
    if (![_autrueidcard isEqualToString:_id])
    {
        modify = YES;
        if (![NLUtils checkIdentity:_id])
        {
            [self showErrorInfo:@"输入正确的身份证号码" status:NLHUDState_Error];
            return NO;
        }
    }
    if (![_auemail isEqualToString:_email])
    {
        modify = YES;
        if (![NLUtils checkEmail:_email])
        {
            [self showErrorInfo:@"输入正确的电子邮箱" status:NLHUDState_Error];
            return NO;
        }
    }
    if (_agentFlag==YES) {
        
        if (_phone.length<7)
        {
            modify = YES;
            [self showErrorInfo:@"输入正确的联系座机/电话" status:NLHUDState_Error];
            return NO;
        }
        if (_fax.length<6)
        {
            modify = YES;
            [self showErrorInfo:@"输入正确的传真" status:NLHUDState_Error];
            return NO;
        }
        if (_company.length<4)
        {
            modify = YES;
            [self showErrorInfo:@"输入正确的公司名字" status:NLHUDState_Error];
            return NO;
        }
        if (_vestAdress.length<2)
        {
            modify = YES;
            [self showErrorInfo:@"输入正确的归属地" status:NLHUDState_Error];
            return NO;
        }
        if (_abbr.length<4)
        {
            modify = YES;
            [self showErrorInfo:@"输入正确的地址" status:NLHUDState_Error];
            return NO;
        }
    }
   
    return modify;
}

-(void)doUploadUserUpPictureInfor
{
    NSString* document = [NLSandboxFile GetDocumentPath];
    NSString* path = nil;
    NSDictionary* dic = nil;
    if (_up_image_name.length > 0)
    {
        _upPicIndex = 0;
        path = [NSString stringWithFormat:@"%@/%@",document,_up_image_name];
        dic = [NSDictionary dictionaryWithObjectsAndKeys:_up_uploadurl,@"url",path,@"path",nil];
        [NSThread detachNewThreadSelector:@selector(uploadPicture:) toTarget:self withObject:dic];
    }
    else
    {
        [self doUploadUserDownPictureInfor];
    }
}

-(void)doUploadUserDownPictureInfor
{
    NSString* document = [NLSandboxFile GetDocumentPath];
    NSString* path = nil;
    NSDictionary* dic = nil;
   if (_down_image_name.length > 0)
    {
        _upPicIndex = 1;
        path = [NSString stringWithFormat:@"%@/%@",document,_down_image_name];
        dic = [NSDictionary dictionaryWithObjectsAndKeys:_down_uploadurl,@"url",path,@"path",nil];
        //图片加载
        [NSThread detachNewThreadSelector:@selector(uploadPicture:) toTarget:self withObject:dic];
    }
}

-(void)commitAndCheck
{
    [self oneFingerTwoTaps];
    if ([self checkNoPictureInfo])
    {
//        [self showErrorInfo:@"请稍候" status:NLHUDState_None];
        [self modifyAuthorInfo];
    }
}

-(void)doModifyAuthorInfoNotify:(NLProtocolResponse*)response
{
    if (_isModifyPic > 0)
    {
        [self doUploadUserUpPictureInfor];
    }
    else
    {
        NLProtocolData* data = [response.data find:@"msgbody/message" index:0];
        NSString* message = data.value;
        [self showErrorInfo:message status:NLHUDState_NoError];
    }
}

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
            detail = @"请求失败，请检查网络";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

//修改用户信息
-(void)modifyAuthorInfo
{
    NSString* name = [NLUtils getNameForRequest:Notify_modifyAuthorInfo];
    REGISTER_NOTIFY_OBSERVER(self, modifyAuthorInfoNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] modifyAuthorInfo:_name
                                                                idCard:_id
                                                                 email:_email agentcompany:_company agentarea:_vestAdress agentaddress:_abbr agentmanphone:_phone agentfax:_fax];
}

-(void)doUploadAuthorPicNotify:(NLProtocolResponse*)response
{
    if (_isModifyPic > 0)
    {
        _isModifyPic--;
    }
    if (0 == _isModifyPic)
    {
        [self showErrorInfo:@"恭喜您,用户修改成功" status:NLHUDState_NoError];
    }
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
            detail = @"请求失败，请检查网络";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

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

- (void)finishedUploadPicture:(NSNumber *)object
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
    if (0 == _upPicIndex)
    {
         NSString* path = [NSString stringWithFormat:@"%@%@",_up_uploadurl,_up_image_name];
        [self uploadAuthorPic:_up_picid
                      picpath:path
                 uploadmethod:_up_uploadmethod
                uploadpictype:_up_uploadpictype
                   uploadmark:uploadmark];

        [self doUploadUserDownPictureInfor];
    }
    else if (1 == _upPicIndex)
    {
        NSString* path = [NSString stringWithFormat:@"%@%@",_down_uploadurl,_down_image_name];
        [self uploadAuthorPic:_down_picid
                      picpath:path
                 uploadmethod:_down_uploadmethod
                uploadpictype:_down_uploadpictype
                   uploadmark:uploadmark];
    }
    _index++;
    if (_index == 2)
    {
        _index = 0;
        _isModifyPic = 0;
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
        [self performSelectorOnMainThread:@selector(finishedUploadPicture:) withObject:object waitUntilDone:NO];
    }
}

-(NSString*)getNoNilStr:(NSString*)str
{
    //NSLog(@"str = %@, length = %d, null = %d",str,str.length,[str isEqual:[NSNull null]]);
    if (str == nil)
    {
        return @"";
    }
    return str;
}

//图片的上传
-(void)getUpInfo:(NLProtocolData*)d
{
    NLProtocolData* data = [d find:@"picid" index:0];
    _up_picid = [self getNoNilStr:data.value];// data.value;
    data = [d find:@"pictype" index:0];
    _up_pictype = [self getNoNilStr:data.value];//data.value;
    data = [d find:@"picpath" index:0];
    _up_picpath = [self getNoNilStr:data.value];//data.value;
    data = [d find:@"uploadpictype" index:0];
    _up_uploadpictype = [self getNoNilStr:data.value];//data.value;
    data = [d find:@"uploadurl" index:0];
    _up_uploadurl = [self getNoNilStr:data.value];//data.value;
    data = [d find:@"uploadmethod" index:0];
    _up_uploadmethod = [self getNoNilStr:data.value];//data.value;
}

-(void)getDownInfo:(NLProtocolData*)d
{
    NLProtocolData* data = [d find:@"picid" index:0];
    _down_picid = [self getNoNilStr:data.value];//data.value;
    data = [d find:@"pictype" index:0];
    _down_pictype = [self getNoNilStr:data.value];//data.value;
    data = [d find:@"picpath" index:0];
    _down_picpath = [self getNoNilStr:data.value];//data.value;
    data = [d find:@"uploadpictype" index:0];
    _down_uploadpictype = [self getNoNilStr:data.value];//data.value;
    data = [d find:@"uploadurl" index:0];
    _down_uploadurl = [self getNoNilStr:data.value];//data.value;
    data = [d find:@"uploadmethod" index:0];
    _down_uploadmethod = [self getNoNilStr:data.value];//data.value;
}

//读取用户信息(代理商)
-(void)doReadAuthorInfoNotify:(NLProtocolResponse*)response
{
    NLProtocolData* data = [response.data find:@"msgbody/autruename" index:0];
    _name = data.value;
    _autruename = _name;
    data = [response.data find:@"msgbody/autrueidcard" index:0];
    _id = data.value;
    _autrueidcard = _id;
    data = [response.data find:@"msgbody/auemail" index:0];
    _email = data.value;
    _auemail = _email;
    data = [response.data find:@"msgbody/agentcompany" index:0];
    _company = data.value;
    _aucompany = _company;
    data = [response.data find:@"msgbody/agentarea" index:0];
    _vestAdress = data.value;
    _auvestAdress = _vestAdress;
    data = [response.data find:@"msgbody/agentaddress" index:0];
    _abbr = data.value;
    _auabbr = _abbr;
    data = [response.data find:@"msgbody/agentmanphone" index:0];
    _phone = data.value;
    _auphone = _phone;
    data = [response.data find:@"msgbody/agentfax" index:0];
    _fax = data.value;
    _aufax = _fax;
    data = [response.data find:@"msgbody/agentbzmoney" index:0];
    _agentbzmoney = data.value;
    _auagentbzmoney = _agentbzmoney;
    data = [response.data find:@"msgbody/agenthttime" index:0];
    _agenthttime = data.value;
    _auagenthttime = _agenthttime;

    
    //图片的存放及上传
    NSArray* msgchild = [response.data find:@"msgbody/msgchild"];
    int index = 0;
    for (NLProtocolData* d in msgchild)
    {
        if (0 ==index)
        {
            [self getUpInfo:d];
        }
        else if (1 == index)
        {
            [self getDownInfo:d];
        }
        index++;
    }
}

-(void)readAuthorInfoNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        [self doReadAuthorInfoNotify:response];
        [[self myTableView] reloadData];
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
            detail = @"请求失败，请检查网络";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

//读取用户信息的（代理商）
-(void)readAuthorInfo
{
    NSString* name = [NLUtils getNameForRequest:Notify_readAuthorInfo];
    REGISTER_NOTIFY_OBSERVER(self, readAuthorInfoNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] readAuthorInfo];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section)
    {
        return 70;
    }
    return 44;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section)
    {
        return 1;
    }
    else
    {
        if (_agentFlag==YES) {
            return 10;
        }else{
            return 3;
        }
        
    }
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NLUserInforSettingsCell *cell =nil;
    static NSString *kCellID = @"NLUsersInforSettingsCell";
    cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (cell == nil)
    {
        NSArray* temp = [[NSBundle mainBundle] loadNibNamed:kCellID owner:self options:nil];
        cell=[temp objectAtIndex:0];
    }
    
    [cell.myTextField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
    cell.myDownrightImage.myNLUsersInfoSettingsViewControllerDelegate =self;
    cell.myUprightImage.myNLUsersInfoSettingsViewControllerDelegate =self;
    switch (indexPath.section)
    {
        case 0:
        {
            [cell setFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, 70)];
            cell.myContainer = self;
            [cell.myHeaderLabel setFrame:CGRectMake(cell.myHeaderLabel.frame.origin.x, cell.myHeaderLabel.frame.origin.y+13, cell.myHeaderLabel.frame.size.width, cell.myHeaderLabel.frame.size.height)];
            [self addTapGestureRecognizer:cell.myHeaderLabel];
            cell.myHeaderLabel.text = @"身份证照片";
            [cell.myDownrightBtn setFrame:CGRectMake(120, 5, 60, 60)];
            cell.myDownrightBtn.hidden = NO;
            cell.myDownrightImage.hidden = NO;
            [cell.myDownrightImage setFrame:CGRectMake(120, 5, 60, 60)];
            if (_downImage)
            {
                cell.myDownrightImage.image = _downImage;
            }
            else if ([_down_picpath rangeOfString:@"http://"].length > 0/*_down_picpath.length > 0*/)
            {
                cell.myDownrightImage.placeholderImage = [UIImage imageNamed:@"addUsersPhoto.png"];
                cell.myDownrightImage.imageURL = _down_picpath;
//                _downImage = cell.myDownrightImage.image;
            }
            else
            {
                 cell.myDownrightImage.image = [UIImage imageNamed:@"addUsersPhoto.png"];;
            }
            [cell.myUprightBtn setFrame:CGRectMake(200, 5, 60, 60)];
            cell.myUprightBtn.hidden = NO;
            cell.myUprightImage.hidden = NO;
            [cell.myUprightImage setFrame:CGRectMake(200, 5, 60, 60)];
            if (_upImage)
            {
                cell.myUprightImage.image = _upImage;
            }
            else if ([_up_picpath rangeOfString:@"http://"].length > 0/*_up_picpath.length > 0*/)
            {
                cell.myUprightImage.placeholderImage = [UIImage imageNamed:@"addUsersPhoto.png"];
                cell.myUprightImage.imageURL = _up_picpath;
//              _upImage = cell.myUprightImage.image;
            }
            else
            {
                cell.myUprightImage.image = [UIImage imageNamed:@"addUsersPhoto.png"];;
            }
            cell.myContentLabel.hidden = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
            break;
            
        case 1:
        {
            [self addTapGestureRecognizer:cell.myHeaderLabel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            switch (indexPath.row)
            {
                case 0:
                {
                    cell.myHeaderLabel.text = @"*姓名";
                    cell.myContentLabel.hidden = YES;
                    cell.myTextField.hidden = NO;
                    cell.myTextField.tag = 0;
                    if (_name.length > 0)
                    {
                        cell.myTextField.text = _name;
                    }
                    else
                    {
                        cell.myTextField.placeholder = @"请输入姓名";
                    }
                }
                    break;
                case 1:
                {
                    cell.myHeaderLabel.text = @"*身份证号码";
                    cell.myContentLabel.hidden = YES;
                    cell.myTextField.hidden = NO;
                    cell.myTextField.tag = 1;
                    if (_id.length > 0)
                    {
                        cell.myTextField.text = _id;
                    }
                    else
                    {
                        cell.myTextField.placeholder = @"请输入身份证号码";
                    }
                }
                    break;
                case 2:
                {
                    cell.myHeaderLabel.text = @"*电子邮箱";
                    cell.myContentLabel.text = @"aobama@sina.com";
                    cell.myContentLabel.hidden = YES;
                    cell.myTextField.hidden = NO;
                    cell.myTextField.tag = 2;
                    if (_email.length > 0)
                    {
                        cell.myTextField.text = _email;
                    }
                    else
                    {
                        cell.myTextField.placeholder = @"请输入电子邮箱";
                    }
                }
                    break;
                    
            if (_agentFlag==YES) {
                
                case 3:
                {
                    cell.myHeaderLabel.text = @"*公司名称";
                    cell.myContentLabel.hidden = YES;
                    cell.myTextField.hidden = NO;
                    cell.myTextField.tag = 3;
                    if (_company.length > 0)
                    {
                        cell.myTextField.text = _company;
                    }
                    else
                    {
                        cell.myTextField.placeholder = @"请输入公司名称";
                    }
                }
                break;
                
                case 4:
                    {
                        cell.myHeaderLabel.text = @"*归属地";
                        cell.myContentLabel.hidden = YES;
                        cell.myTextField.hidden = NO;
                        cell.myTextField.tag = 4;
                        if (_vestAdress.length > 0)
                        {
                            cell.myTextField.text = _vestAdress;
                        }
                        else
                        {
                            cell.myTextField.placeholder = @"请输入归属地";
                        }
                    }
                    break;
            case 5:
                {
                    cell.myHeaderLabel.text = @"*地址";
                    cell.myContentLabel.hidden = YES;
                    cell.myTextField.hidden = NO;
                    cell.myTextField.tag = 5;
                    if (_abbr.length > 0)
                    {
                        cell.myTextField.text = _abbr;
                    }
                    else
                    {
                        cell.myTextField.placeholder = @"请输入地址";
                    }
                }
                break;
            case 6:
                {
                    cell.myHeaderLabel.text = @"*联系电话";
                    cell.myContentLabel.hidden = YES;
                    cell.myTextField.hidden = NO;
                    cell.myTextField.tag = 6;
                    if (_phone.length > 0)
                    {
                        cell.myTextField.text = _phone;
                    }
                    else
                    {
                        cell.myTextField.placeholder = @"请输入联系电话";
                    }
                }
                break;
            case 7:
                {
                    cell.myHeaderLabel.text = @"*传真";
                    cell.myContentLabel.hidden = YES;
                    cell.myTextField.hidden = NO;
                    cell.myTextField.tag = 7;
                    if (_fax.length > 0)
                    {
                        cell.myTextField.text = _fax;
                    }
                    else
                    {
                        cell.myTextField.placeholder = @"请输入传真";
                    }
                }
                break;
            case 8:
                {
                    cell.myHeaderLabel.text = @"合同起止时间";
                    cell.myContentLabel.hidden = YES;
                    cell.myTextField.hidden = NO;
                    cell.myTextField.tag = 8;
                    cell.userInteractionEnabled= NO;
                    if (_agenthttime.length > 0)
                    {
                        cell.myTextField.text = [NSString stringWithFormat:@"    %@",_agenthttime];
                    }
                    else
                    {
                        cell.myTextField.placeholder = @"";
                    }
        }
                break;
            case 9:
                {
                    cell.myHeaderLabel.text = @"风险保证余额";
                    cell.myContentLabel.hidden = YES;
                    cell.myTextField.hidden = NO;
                    cell.myTextField.tag = 9;
                    cell.userInteractionEnabled= NO;
                    if (_agentbzmoney.length > 0)
                    {
                       cell.myTextField.text = [NSString stringWithFormat:@"     %@",_agentbzmoney];
                    }
                    else
                    {
                        cell.myTextField.placeholder = @"";
                    }
                }
                break;
                }
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    return cell;    
}


#pragma mark - keyboard hide event

-(void)oneFingerTwoTaps
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UITextField *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    [firstResponder resignFirstResponder];
}


-(void)doDownrightBtnClicked:(id)sender
{
    _upOrDown = 0;
    [self adding:0];
    return;
}

-(void)doUprightBtnClicked:(id)sender
{
    _upOrDown = 1;
    [self adding:1];
    return;
}

-(void)addByPhotosAlbm
{
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	picker.allowsEditing = YES;
	
	picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
	{
        //混合类型 photo + movie
		picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    }
	[self presentViewController:picker animated:YES completion:nil];

}

- (void) addByCamel
{
   //先设定sourceType为相机，然后判断相机是否可用（ipod）没相机，不可用将sourceType设定为相片库
	UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
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
- (void)saveImage:(UIImage *)image
{
    NSString* document = [NLSandboxFile GetDocumentPath];
    NSString* path = nil;
    if (1 == _upOrDown)
    {
        _upImage = image;
        _up_image_name = [NSString stringWithFormat:@"%@_%@_%@.jpg",[NLUtils getRegisterMobile],_up_uploadpictype,[NLUtils get_req_time]];
        path = [NSString stringWithFormat:@"%@/%@",document,_up_image_name];
        //path = [NSString stringWithFormat:@"%@/%@",document,TFBUsersInfoUpImage];
        if (_isModifyPic < 2)
        {
            _isModifyPic++;
        }
    }
    else
    {
        _downImage = image;
        _down_image_name = [NSString stringWithFormat:@"%@_%@_%@.jpg",[NLUtils getRegisterMobile],_down_uploadpictype,[NLUtils get_req_time]];
        path = [NSString stringWithFormat:@"%@/%@",document,_down_image_name];
         //path = [NSString stringWithFormat:@"%@/%@",document,TFBUsersInfoDownImage];
        if (_isModifyPic < 2)
        {
            _isModifyPic++;
        }
    }
    
    NSData* data = UIImageJPEGRepresentation(image, 1.0);
    [data writeToFile:path atomically:YES];
    NSArray *arr = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]];
    [self.myTableView reloadRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark -
#pragma mark Camera View Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self performSelector:@selector(saveImage:)
               withObject:image
               afterDelay:0.5];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)showBigImageView
{
    NLBigImageViewController* vc = [[NLBigImageViewController alloc] initWithNibName:@"NLBigImageViewController" bundle:nil];
    if (0 == _upOrDown && _downImage)
    {
        vc.myImage = _downImage;
    }
    else if (1 == _upOrDown && _upImage)
    {
        vc.myImage = _upImage;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)adding:(int)tag
{
    UIActionSheet *menu = nil;
    
    if ((0 == _upOrDown && _downImage) || (1 == _upOrDown && _upImage))
    {
        menu = [[UIActionSheet alloc]
                initWithTitle: nil
                delegate:self
                cancelButtonTitle:@"取消"
                destructiveButtonTitle:nil
                otherButtonTitles:@"从相册选取",@"立即拍照上传",@"查看大图", nil];
    }
    else 
    {
        menu = [[UIActionSheet alloc]
                initWithTitle: nil
                delegate:self
                cancelButtonTitle:@"取消"
                destructiveButtonTitle:nil
                otherButtonTitles:@"从相册选取",@"立即拍照上传", nil];
    }
    menu.actionSheetStyle = UIActionSheetStyleDefault;
    menu.tag = tag;
    [menu showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //if (actionSheet.tag == 0) //Downright
    {
        switch (buttonIndex)
        {
            case 0:
            {
                [self addByPhotosAlbm];
            }
                break;
            case 1:
            {
                [self addByCamel];
            }
                break;
            case 2:
            {
                if ((0 == _upOrDown && _downImage) || (1 == _upOrDown && _upImage))
                {
                    [self showBigImageView];
                }
            }
                break;
            default:
                break;
        }
    }
}

- (void)textFieldWithText:(UITextField *)textField
{
    switch (textField.tag)
    {
        case 0://name
            _name = textField.text;
            break;
        case 1://id
            _id = textField.text;
            break;
        case 2://email
            _email = textField.text;
            break;
        if (_agentFlag==YES) {
        case 3://name
            _company = textField.text;
            break;
        case 4://id
            _vestAdress = textField.text;
            break;
        case 5://email
            _abbr = textField.text;
            break;
        case 6://id
            _phone = textField.text;
            break;
        case 7://email
            _fax = textField.text;
            break;
      }
        default:
            break;
    }
}

- (void) doPush
{
    [_hud hide:YES];
    [NLUtils popToLogonVCByHTTPError:self feedOrLeft:0];
}

-(void)addTapGestureRecognizer:(UIView*)view
{
    UITapGestureRecognizer *oneFingerTwoTaps = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(oneFingerTwoTaps)];
    // Set required taps and number of touches
    [oneFingerTwoTaps setNumberOfTapsRequired:1];
    [oneFingerTwoTaps setNumberOfTouchesRequired:1];
    [view addGestureRecognizer:oneFingerTwoTaps];
}

-(void)setDownImage:(UIImage *)image pathUrl:(NSString *)pathUrl
{
    if ([pathUrl isEqualToString:_down_picpath])
    {
        _downImage = image;
    }
    else if([pathUrl isEqualToString:_up_picpath])
    {
        _upImage = image;
    }
}

@end
