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
    
    
}
@synthesize PassengerName,PassengerCardType,PassengerCardId,PassengerPersonIphone,selectionPersonIphone,unmberID;


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
    
    UITextField *textFieldName = [_textFieldArray objectAtIndex:0];
    UITextField *textFieldcarsty = [_textFieldArray objectAtIndex:1];
    UITextField *textFieldcarId = [_textFieldArray objectAtIndex:2];
    
    [textFieldName resignFirstResponder];
    [textFieldcarsty resignFirstResponder];
    [textFieldcarId resignFirstResponder];
    
    self.PassengerName = textFieldName.text;
    self.PassengerCardType = textFieldcarsty.text;
    self.PassengerCardId = textFieldcarId.text;
    NSLog(@"=====unmberID====%@",self.unmberID);
    if ([self.PassengerName length] >0 && [self.PassengerCardId length] > 0 && [self.PassengerCardType length] > 0)
    {
        _activityView = [[PlayCustomActivityView alloc] initWithFrame:CGRectMake(0, 0, 130, 130)];
        _activityView.center = self.view.center;
        [_activityView setTipsText:@"正在加提交数据..."];
        [_activityView starActivity];
        [self.view addSubview:_activityView];
        
        NSString* name = [NLUtils getNameForRequest:Notify_SavePassenger];
        REGISTER_NOTIFY_OBSERVER(self, GetSavePassengerNotify, name);
        [[[NLProtocolRequest alloc]initWithRegister:YES]savePassengerName:self.PassengerName savePassengerCardType:self.unmberID savePassengerCardId:self.PassengerCardId savePassengerPhoneNumber:@"" savePassengerPassengerType:[NSString stringWithFormat:@"%d",self.PassengerType]];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"请填写完整的信息！" delegate:nil cancelButtonTitle:@"退出" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}
// 回调
-(void)leftItemClick:(id)sender
{
    //    [self.delegate returPersonIphoneDate:self.selectionPersonIphone];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)GetSavePassengerNotify:(NSNotification *)senderFication
{
    NLProtocolResponse *response = (NLProtocolResponse *)senderFication.object;
    int error = response.errcode;
    
    if (error == RSP_NO_ERROR)
    {
        [self getApiAirticket:response];
        
    }
    else if (error == RSP_TIMEOUT)
    {
        return ;
    }
    else
    {
        NSString *string = response.detail;
        NSLog(@"===string====%@",string);
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

- (void)getApiAirticket:(NLProtocolResponse *)response
{
    //获取数据标记，判断是否请求成功
    NLProtocolData *data = [response.data find:@"msgbody/result" index:0];
    NSString *result = data.value;
    NSRange range = [result rangeOfString:@"succ"];
    
    if (range.length <= 0)
    {
        //获取错误信息
        NLProtocolData *errorData = [response.data find:@"msgbody/message" index:0];
        NSLog(@"errorData = %@",errorData);
    }
    else
    {
        // 机票实际价格
        //        self.priceArray = [response.data find:@"msgbody/msgchild/price"];
        [_activityView performSelector:@selector(endActivity) withObject:_activityView afterDelay:0.7];
        [_activityView removeFromSuperview];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"亲！加载数据成功！" delegate:self cancelButtonTitle:@"退出添加乘机人" otherButtonTitles:nil, nil];
        [alert show];
        
        UITextField *textFieldName = [_textFieldArray objectAtIndex:0];
        textFieldName.text = nil;
        textFieldName.placeholder = @"请输入姓名";
        
        UITextField *textFieldcarsty = [_textFieldArray objectAtIndex:1];
        textFieldcarsty.text = nil;
        textFieldcarsty.placeholder = @"证件类型";
        
        UITextField *textFieldcarId = [_textFieldArray objectAtIndex:2];
        textFieldcarId.text = nil;
        textFieldcarId.placeholder = @"请输入证件号";
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(personMessage:) name:@"添加乘机人" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"添加乘机人" object:nil];
    }
    
}
-(void)personMessage:(NSNotificationCenter *)sender
{
    NSLog(@"=====添加乘机人添加乘机人添加乘机人添加乘机人===");
}


-(void)allControllerView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    _textView = [[UIView alloc]initWithFrame:CGRectMake(0, 109, 320, self.view.frame.size.height-109)];
    [self.view addSubview:_textView];
    
    _textFieldArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < 3; i++)
    {
        UIImageView *lineAccorIamge = [[UIImageView alloc]initWithFrame:CGRectMake(0, 61+i*60, 320, 1)];
        lineAccorIamge.image = [UIImage imageNamed:@"line@2x.png"];
        [_textView addSubview:lineAccorIamge];
    }
    
    NSArray *infoArray = @[@"请输入姓名",@"证件类型",@"请输入证件号"];
    for (int j = 0; j < 3; j++)
    {
        UITextField *infoField = [[UITextField alloc]initWithFrame:CGRectMake(10, j*60, 300, 60)];
        infoField.placeholder = [infoArray objectAtIndex:j];
        infoField.delegate = self;
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
        [_textFieldArray addObject:infoField];
        [_textView addSubview:infoField];
    }
    
    
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
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[_textFieldArray objectAtIndex:0] resignFirstResponder];
    [[_textFieldArray objectAtIndex:2] resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        _textView.frame = CGRectMake(0, 109, _textView.frame.size.width, _textView.frame.size.height);
    }];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField.tag == 1)
    {
        [UIView animateWithDuration:0.3 animations:^{
            _textView.frame = CGRectMake(0, 109-60, _textView.frame.size.width, _textView.frame.size.height);
        }];
    }
    if(textField.tag == 2)
    {
        [UIView animateWithDuration:0.3 animations:^{
            _textView.frame = CGRectMake(0, 109-120, _textView.frame.size.width, _textView.frame.size.height);
        }];
    }
}

-(void)typeButton
{
    [[_textFieldArray objectAtIndex:0] resignFirstResponder];
    [[_textFieldArray objectAtIndex:1] resignFirstResponder];
    [[_textFieldArray objectAtIndex:2] resignFirstResponder];
    _personView.hidden = NO;
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


















