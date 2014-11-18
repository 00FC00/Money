//
//  ThemeMembersViewController.h
//  FaceBook
//
//  Created by fengshaohui on 14-5-27.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"

@interface ThemeMembersViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,EGORefreshTableDelegate>
{
    UITableView *themeTableView;
    NSMutableArray *themeArray;
    
    NSInteger pageNumber;
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    BOOL _reloading;

}
//主题群id
@property (nonatomic, strong) NSString *themeIdString;

@end
