//
//  addPersonViewController.m
//  TongFubao
//
//  Created by kin on 14-8-20.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "addPersonViewController.h"
#import "selectionPerson.h"
#import "PlayCustomActivityView.h"
@interface addPersonViewController ()<selectionPersondelegate>
@end

@implementation addPersonViewController
{
    UILabel *_selectionLable;
    selectionPerson *_personView;
    NSMutableArray *_textFieldArray;
    UIView *_textView;
    UIButton *_button;
    PlayCustomActivityView *_activityView;
    UIButton * timeButton;
    
    
}
@synthesize PassengerName,PassengerCardType,PassengerCardId,PassengerPersonIphone,selectionPersonIphone,unmberID,PassengerBirthDay,viewPicker,datePicker;


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
    
    // 导航
    [self navigationView];
    [self allControllerView];
    // 乘客类型
    self.PassengerType = 1;
}
-(void)navigationView{
    
    [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
    self.title= @"添加乘机人";
    [self addRightButtonItemWithTitle:@"确定"];
    
}
// 右边导航
-(void)rightItemClick:(id)sender
{
    self.viewPicker.frame =  CGRectMake(0, self.view.frame.size.height, 320, 230);
    UITextField *textFieldName = [_textFieldArray objectAtIndex:0];
    UITextField *textFieldcarsty = [_textFieldArray objectAtIndex:1];
    UITextField *textFieldcarId = [_textFieldArray objectAtIndex:2];

    [textFieldName resignFirstResponder];
    [textFieldcarsty resignFirstResponder];
    [textFieldcarId resignFirstResponder];
    
    self.PassengerName = textFieldName.text;
    self.PassengerCardType = textFieldcarsty.text;
    self.PassengerCardId = textFieldcarId.text;
    

     if ([self.PassengerName length] >0 && [self.PassengerCardId length] > 0 && [self.PassengerCardType length] > 0 && [self.PassengerBirthDay length] > 0)
    {
        _activityView = [[PlayCustomActivityView alloc] initWithFrame:CGRectMake(0, 0, 130, 130)];
        _activityView.center = self.view.center;
        [_activityView setTipsText:@"正在加提交数据..."];
        [_activityView starActivity];
        [self.view addSubview:_activityView];
        
        NSString* name = [NLUtils getNameForRequest:Notify_SavePassenger];
        REGISTER_NOTIFY_OBSERVER(self, GetSavePassengerNotify, name);
        [[[NLProtocolRequest alloc]initWithRegister:YES]savePassengerName:self.PassengerName savePassengerCardType:self.unmberID savePassengerCardId:self.PassengerCardId savePassengerPhoneNumber:@"" savePassengerPassengerType:[NSString stringWithFormat:@"%d",self.PassengerType] birthday:self.PassengerBirthDay];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"请正确填写信息！" delegate:nil cancelButtonTitle:@"退出" otherButtonTitles:nil, nil];
        [alert show];
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100)
    {
        if (buttonIndex == 1)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

// 回调
-(void)leftItemClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)GetSavePassengerNotify:(NSNotification *)senderFication
{
    NLProtocolResponse *response = (NLProtocolResponse *)senderFication.object;
    int error = response.errcode;
    NSString *string = response.detail;
//    NSLog(@"===string====%@",string);
//    REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_SavePassenger);
    
    if (error == RSP_NO_ERROR)
    {
        [self getApiAirticketSavePassenger:response];
        [_activityView performSelector:@selector(endActivity) withObject:_activityView afterDelay:0.7];
        [_activityView removeFromSuperview];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"成功添加乘机人!" message:@"" delegate:self cancelButtonTitle:@"添加乘机人" otherButtonTitles:@"退出", nil];
        alert.tag = 100;
        [alert show];
        
    }
    else if (error == RSP_TIMEOUT)
    {
        [_activityView performSelector:@selector(endActivity) withObject:_activityView afterDelay:0.7];
        [_activityView removeFromSuperview];
        return ;
    }
    else
    {
        [_activityView performSelector:@selector(endActivity) withObject:_activityView afterDelay:0.7];
        [_activityView removeFromSuperview];
        if ([string isEqualToString:@"请勿重复添加信息"])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"亲！请勿重复添加信息" delegate:self cancelButtonTitle:@"退出" otherButtonTitles:nil, nil];
            [alert show];
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"亲！加载数据失败！" delegate:self cancelButtonTitle:@"退出" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

- (void)getApiAirticketSavePassenger:(NLProtocolResponse *)response
{
    //获取数据标记，判断是否请求成功
    NLProtocolData *data = [response.data find:@"msgbody/result" index:0];
    NSString *result = data.value;
//    NSLog(@"======result======%@",result);
    NSRange range = [result rangeOfString:@"succ"];
    
    if (range.length <= 0)
    {
        //获取错误信息
        NLProtocolData *errorData = [response.data find:@"msgbody/message" index:0];
        NSLog(@"errorData = %@",errorData);
    }
    else if ([result isEqualToString:@"success"])
    {
        UITextField *textFieldName = [_textFieldArray objectAtIndex:0];
        textFieldName.text = @"";
        textFieldName.placeholder = @"请输入姓名";
        
        UITextField *textFieldcarsty = [_textFieldArray objectAtIndex:1];
        textFieldcarsty.text = @"";
        textFieldcarsty.placeholder = @"证件类型";
        
        UITextField *textFieldcarId = [_textFieldArray objectAtIndex:2];
        textFieldcarId.text = @"";
        textFieldcarId.placeholder = @"请输入证件号";
        [timeButton setTitle:@"请您选择生日" forState:(UIControlStateNormal)];
        
        [self.delegate UpdateTheDataUpPassengers];
    }
}



-(void)allControllerView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    _textView = [[UIView alloc]initWithFrame:CGRectMake(0, 109, 320, self.view.frame.size.height-109)];
    [self.view addSubview:_textView];
    
    _textFieldArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < 4; i++)
    {
        UIImageView *lineAccorIamge = [[UIImageView alloc]initWithFrame:CGRectMake(0, 61+i*60, 320, 1)];
        lineAccorIamge.image = [UIImage imageNamed:@"line@2x.png"];
        [_textView addSubview:lineAccorIamge];
    }
    
    NSArray *infoArray = @[@"请输入姓名",@"选择证件类型",@"请输入证件号"];
    for (int j = 0; j < 3; j++)
    {
        UITextField *infoField = [[UITextField alloc]initWithFrame:CGRectMake(15, j*60, 300, 60)];
        infoField.placeholder = [infoArray objectAtIndex:j];
        infoField.delegate = self;
        infoField.clearButtonMode=UITextFieldViewModeAlways;
        infoField.tag  = j;
        if (infoField.tag == 0)
        {
            self.PassengerName = infoField.text;
        }
        else if (infoField.tag == 1)
        {
            self.PassengerCardType = infoField.text;
        }
        else if (infoField.tag == 2)
        {
            self.PassengerCardId = infoField.text;
        }
//        else if (infoField.tag == 3)
//        {
//            self.PassengerBirthDay = infoField.text;
//            NSLog(@"=====PassengerBirthDay====%@",self.PassengerBirthDay);
//        }

        [_textFieldArray addObject:infoField];
        [_textView addSubview:infoField];
    }
    
    timeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    timeButton.frame = CGRectMake(10,180, 320, 60);
    [timeButton setTitle:@"请您选择生日" forState:(UIControlStateNormal)];
    [timeButton setTitleEdgeInsets:(UIEdgeInsetsMake(0, 0, 0, 210))];
    [timeButton setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    [timeButton addTarget:self action:@selector(timeButtonclike) forControlEvents:(UIControlEventTouchUpInside)];
    [_textView addSubview:timeButton];
    
    self.viewPicker = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, 320, 230)];
    self.viewPicker.backgroundColor = RGBACOLOR(204, 225, 152, 1);
    [self.view addSubview:self.viewPicker];
    
    UIButton * backButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    backButton.frame = CGRectMake(0,0, 320, 30);
    backButton.backgroundColor =RGBACOLOR(143, 195, 31, 1);
    [backButton setTitle:@"选择出生日期后请退回" forState:(UIControlStateNormal)];
    [backButton addTarget:self action:@selector(timeclike) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewPicker addSubview:backButton];
    //时间管理器
    self.datePicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 30, 320, 200)];
    self.datePicker.datePickerMode=UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(pickerDidchage) forControlEvents:(UIControlEventValueChanged)];
    [self.viewPicker addSubview:self.datePicker];



    
    
    NSArray *PersonArray = @[@"成人",@"儿童",@"婴儿"];
    UILabel *backLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, 320, 45)];
    backLable.backgroundColor = RGBACOLOR(204, 225, 152, 1);
    [self.view addSubview:backLable];
    _selectionLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, 320/3, 45)];
    _selectionLable.backgroundColor = RGBACOLOR(143, 195, 31, 1);
    [self.view addSubview:_selectionLable];
    for (int i = 0; i < 3; i++)
    {
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.frame = CGRectMake(320/3*i, 64, 320/3, 45);
        [button setTitle:[PersonArray objectAtIndex:i] forState:(UIControlStateNormal)];
        button.tag = i;
        button.selected = YES;
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(addClikButton:) forControlEvents:(UIControlEventTouchUpInside)];
        [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [self.view addSubview:button];
    }
    
    _button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _button.frame = CGRectMake(10, 60, 300, 60);
    _button.backgroundColor = [UIColor clearColor];
    [_button addTarget:self action:@selector(typeButton) forControlEvents:(UIControlEventTouchUpInside)];
    [_textView addSubview:_button];
    
    _personView = [[selectionPerson alloc] initWithFrame:CGRectMake(20,(self.view.frame.size.height-280)/2+20, 280, 280)];
    _personView.delegate = self;
    _personView.hidden = YES;
    [self.view addSubview:_personView];
    
}
-(void)addClikButton:(UIButton *)sender
{
    UIButton *senderButton = (UIButton *)sender;
    self.PassengerType = senderButton.tag+1;
    [UIView animateWithDuration:0.3 animations:^{
        _selectionLable.frame = CGRectMake(320/3*senderButton.tag, 64, 320/3, 45);
        self.viewPicker.frame =  CGRectMake(0, self.view.frame.size.height, 320, 230);
    }];

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[_textFieldArray objectAtIndex:0] resignFirstResponder];
    [[_textFieldArray objectAtIndex:2] resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        _textView.frame = CGRectMake(0, 109, _textView.frame.size.width, _textView.frame.size.height);
        self.viewPicker.frame =  CGRectMake(0, self.view.frame.size.height, 320, 230);

    }];
}
#pragma -mark日期按钮获取日期
-(void)pickerDidchage
{
    //判断选择器有没有滚动
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString=[formatter stringFromDate:self.datePicker.date];
    self.PassengerBirthDay = dateString;
    [timeButton setTitle:self.PassengerBirthDay forState:(UIControlStateNormal)];

//    NSLog(@"========%@",self.PassengerBirthDay);
}

//-(void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    if(textField.tag == 1)
//    {
//        [UIView animateWithDuration:0.3 animations:^{
//            _textView.frame = CGRectMake(0, 109-60, _textView.frame.size.width, _textView.frame.size.height);
//        }];
//    }
//    if(textField.tag == 2)
//    {
//        [UIView animateWithDuration:0.3 animations:^{
//            _textView.frame = CGRectMake(0, 109-120, _textView.frame.size.width, _textView.frame.size.height);
//        }];
//    }
//}
//
-(void)typeButton
{
    [[_textFieldArray objectAtIndex:0] resignFirstResponder];
    [[_textFieldArray objectAtIndex:1] resignFirstResponder];
    [[_textFieldArray objectAtIndex:2] resignFirstResponder];
//    [[_textFieldArray objectAtIndex:3] resignFirstResponder];
    _personView.hidden = NO;
}
-(void)timeButtonclike
{
    [UIView animateWithDuration:0.5 animations:^{
        self.viewPicker.frame =  CGRectMake(0, self.view.frame.size.height-200, 320, 230);
    }];
}
-(void)timeclike
{
    [UIView animateWithDuration:0.5 animations:^{
        self.viewPicker.frame =  CGRectMake(0, self.view.frame.size.height, 320, 230);
    }];
}
-(void)selectionPersonstyUnmber:(NSString *)newstyUnmber selectionPersonstystyWorld:(NSString *)newstyWorld
{
    _personView.hidden = YES;
//    self.PassengerCardType = newstyUnmber;
    self.unmberID = newstyUnmber;
    UITextField *textField = [_textFieldArray objectAtIndex:1];
    textField.text = newstyWorld;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
//+ (BOOL) validateIdentityCard: (NSString *)identityCard
//{
//    BOOL flag;
//    if (identityCard.length <= 0) {
//        flag = NO;
//        return flag;
//    }
//    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
//    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
//    return [identityCardPredicate evaluateWithObject:identityCard];
//}

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


















