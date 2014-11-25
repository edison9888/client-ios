//
//  TFAgentAddgoodsCtr.h
//  TongFubao
//
//  Created by ec on 14-5-16.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToLoadMore.h"
#import "PullToRefreshView.h"
#import "TFAgentAddgoodsCell.h"

@interface TFAgentAddgoodsCtr : UIViewController<UITableViewDataSource,UITableViewDelegate,PullToLoadMoreViewDelegate, PullToRefreshViewDelegate,AgentAddGoodsCellDelete>

@end
