//
//  keyView.m
//  keyBrob
//
//  Created by kin on 14/10/24.
//  Copyright (c) 2014年 kin. All rights reserved.
//

#import "keyView.h"

@implementation keyView
@synthesize numberArray;

- (id)initWithFrame:(CGRect)frame
{
    self.numberArray = [[NSMutableArray alloc]init];
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *unmber = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"C",@"0",@"V"];
        NSInteger hangteger = 0;
        NSInteger lieteger = 0;

        for (int i = 0; i < 12; i++)
        {
            if (i%3 == 0 && i !=0 )
            {
                hangteger++;
                lieteger = 0;
            }
            else
            {
                if (i == 0)
                {
                    lieteger = 0;
                }
                else
                {
                    lieteger++;
                }
            }
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            button.layer.borderWidth = 0.3;
            button.tag = i;
            button.layer.borderColor = [UIColor whiteColor].CGColor;
            button.frame = CGRectMake(lieteger*(325/3), 60*hangteger, 325/3, 60);
            button.backgroundColor = [UIColor colorWithRed:(3) / 255.0 green:(198) / 255.0 blue:(230) / 255.0 alpha:1];
//            [button setBackgroundImage:[UIImage imageNamed:@"keyTu.png"] forState:(UIControlStateNormal)];
            button.titleLabel.text =[unmber objectAtIndex:i];
            button.titleLabel.font = [UIFont boldSystemFontOfSize:35];
            [button setTitle:button.titleLabel.text forState:(UIControlStateNormal)];
            [button addTarget:self action:@selector(addNumber:) forControlEvents:(UIControlEventTouchUpInside)];
            [self addSubview:button];
            
            }
    }
    return self;
}
-(void)addNumber:(UIButton *)sender
{
    UIButton *button = (UIButton *)sender;
    NSString *numberString = [[NSMutableString alloc]init];

    if (button.tag != 9 && button.tag != 11)
    {
        NSString *string ;
        if (button.tag == 10)
        {
           string = [[NSString alloc ]initWithFormat:@"%d",0];
        }
        else
        {
            string = [[NSString alloc ]initWithFormat:@"%d",button.tag+1];

        }
        [self.numberArray addObject:string];
        for (NSString *seleString in self.numberArray)
        {
            numberString = (NSMutableString*)[numberString stringByAppendingString:seleString];
        }
        NSLog(@"======numberString====%@",numberString);
        [self.delegate textFelid:numberString];

    }
    else
    {
        if (button.tag == 9)
        {
            [self.numberArray removeLastObject];
            for (NSString *seleString in self.numberArray)
            {
                numberString = (NSMutableString*)[numberString stringByAppendingString:seleString];
            }
            NSLog(@"======numberString====%@",numberString);
            [self.delegate textFelid:numberString];
        }
        else if (button.tag == 11)
        {
            [self.delegate keybrodBack];
        }
    }
}
-(void)deleteNumber
{
    [self.numberArray removeAllObjects];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
