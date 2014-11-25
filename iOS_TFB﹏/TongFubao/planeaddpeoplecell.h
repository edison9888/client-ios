//
//  planeaddpeople.h
//  TongFubao
//
//  Created by  俊   on 14-7-22.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

@class planeaddpeoplecell;
@protocol planeaddpeoplecellDelegate <NSObject>
@optional
/*删除的*/
@end

@interface planeaddpeoplecell : UITableViewCell
@property (nonatomic, weak) id<planeaddpeoplecellDelegate>  listCellDelegate;
@property (nonatomic,strong) UIButton *BtnIson;
@property (nonatomic,strong) UIButton *BtnModification;

@property (nonatomic,strong) UILabel *name;
@property (nonatomic,strong) UILabel *peopleid;
@property (nonatomic,strong) UILabel *peonumber;

@property (nonatomic,strong) UIImageView *bgImageView;
@property (nonatomic,strong) UIView *contentBg;
-(void)setData:(NSDictionary *)dict;
-(void)btnIsonAciton:(UIButton*)sender;

@end
