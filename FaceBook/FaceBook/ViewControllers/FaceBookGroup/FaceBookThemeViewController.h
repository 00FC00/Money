//
//  FaceBookThemeViewController.h
//  FaceBook
//
//  Created by fengshaohui on 14-5-26.
//  Copyright (c) 2014年 HMN. All rights reserved.
//脸谱群主题群列表

#import <UIKit/UIKit.h>
#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"
#import "GoldBuyVisitedStatusViewController.h"

@interface FaceBookThemeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UITextFieldDelegate,EGORefreshTableDelegate,checkgoldDelegate>
{
    UITableView *institutionsTableView;
    NSMutableArray *institutionsArray;
    
    NSInteger pageNumber;
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    BOOL _reloading;
    
    NSString *keyString;
    
    NSInteger groupTypeId;
    NSInteger rowTag;
}


@end
