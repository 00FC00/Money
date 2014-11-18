//
//  FaceBookinstitutionsViewController.h
//  FaceBook
//
//  Created by fengshaohui on 14-5-26.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"
#import "GoldBuyVisitedStatusViewController.h"
@interface FaceBookinstitutionsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIScrollViewDelegate,EGORefreshTableDelegate,checkgoldDelegate>
{
    UITableView *institutionsTableView;
    NSMutableArray *institutionsArray;
    
    UITableView *myBottomTableView;
    NSMutableArray *myBottomArray;
    
    //选项的id
    NSString *myClassID;
    NSString *bottomID;
    NSString *institutionID;
    
    NSInteger pageNumber;
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    BOOL _reloading;
    
    //请求加入群，的Type字段
    NSString *joinType;
    NSInteger checkCell;

    
}

@end
