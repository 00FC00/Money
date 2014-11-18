//
//  PublicWallViewController.h
//  FaceBook
//
//  Created by fengshaohui on 14-5-16.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"


@interface PublicWallViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableDelegate>
{
    UITableView *topToolTableView;
    UITableView *publicWallTableView;
    
    NSMutableArray *topToolArray;
    NSMutableArray *dataArray;
    
    
    NSInteger pageNumber;
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    BOOL _reloading;

    NSString *classificationString;
}

@end
