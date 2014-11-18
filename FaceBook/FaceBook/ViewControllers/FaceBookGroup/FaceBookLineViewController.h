//
//  FaceBookLineViewController.h
//  FaceBook
//
//  Created by fengshaohui on 14-5-26.
//  Copyright (c) 2014年 HMN. All rights reserved.
// 脸谱群条线列表

#import <UIKit/UIKit.h>
#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"
#import "GoldBuyVisitedStatusViewController.h"

@interface FaceBookLineViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,EGORefreshTableDelegate,checkgoldDelegate>
{
    UITableView *institutionsTableView;
    NSMutableArray *institutionsArray;
    
    UITableView *myBottomTableView;
    NSMutableArray *myBottomArray;
    
    NSInteger pageNumber;
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    BOOL _reloading;
    
    NSString *classificationString;
    
    NSInteger groupTypeId;
    
    NSInteger rowTag;
}


@end
