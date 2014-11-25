//
//  SMSBankCell.m
//  TongFubao
//
//  Created by 通付宝MAC on 14-11-8.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "SMSBankCell.h"

@implementation SMSBankCell

//@synthesize bankLOGO = _bankLOGO;


- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


/*下载logo*/
/*
- (void)imageWitwURL:(NSString *)url
{
    NSLog(@"imageData = %@",url);
    
    if (![url isEqualToString:@""])
    {
        if (!_bankLOGO.image)
        {
            if (!loadImage)
            {
                loadImage = YES;
                
                //下载图片
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    
                    //图片数据
                    NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",url]]];
                    //logo图片
                    UIImage *image = [[UIImage alloc] initWithData:imageData];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        _bankLOGO.image = image;
                    });
                });
            }
        }
    }
}

*/


@end
