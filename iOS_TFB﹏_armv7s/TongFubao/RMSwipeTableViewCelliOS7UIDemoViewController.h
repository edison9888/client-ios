//
//  RMSwipeTableViewCelliOS7UIDemoViewController.h
//  RMSwipeTableViewCelliOS7UIDemo
//
//  Created by Rune Madsen on 2013-06-16.
//  Copyright (c) 2013 The App Boutique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMSwipeTableViewCelliOS7UIDemoTableViewCell.h"
#import "RMHeard.h"

@interface RMSwipeTableViewCelliOS7UIDemoViewController : UITableViewController <RMSwipeTableViewCellDelegate, RMSwipeTableViewCelliOS7UIDemoTableViewCellDelegate,HeadViewDelegate>

@property (nonatomic, strong) NSMutableArray *messagesArray;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end
