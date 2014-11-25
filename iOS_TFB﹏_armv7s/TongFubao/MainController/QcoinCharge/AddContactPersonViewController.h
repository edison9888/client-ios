//
//  AddContactPersonViewController.h
//  TongFubao
//
//  Created by kin on 14-8-21.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddContactPersondelegate <NSObject>

-(void)AddContactPersonArray:(NSMutableArray *)newAddContactPerson;

@end

@interface AddContactPersonViewController : UIViewController
{
    BOOL contactRequest;
}

@property (retain,nonatomic) id<AddContactPersondelegate>delegate;
@property (retain,nonatomic) NSMutableArray *CellDateArray;
@property (assign,nonatomic) NSInteger teger;
@property (retain,nonatomic) NSArray *ticketArray;


-(void)DownloadOnlineContacts;

@end
