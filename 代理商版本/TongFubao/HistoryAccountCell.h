//
//  HistoryAccountCell.h
//  TongFubao
//
//  Created by Delpan on 14-9-24.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryAccountCell : UITableViewCell
{
    BOOL loadImage;
    //图片数据
    NSData *imageData;
    //logo图片
    UIImage *image;
}

//logo
@property (nonatomic, strong) UIImageView *logoView;
//卡信息
@property (nonatomic, strong) UILabel *infoLabel;

//下载logo
- (void)imageWitwURL:(NSString *)url;

@end
