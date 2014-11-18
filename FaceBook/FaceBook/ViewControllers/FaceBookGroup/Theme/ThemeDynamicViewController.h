//
//  ThemeDynamicViewController.h
//  FaceBook
//
//  Created by fengshaohui on 14-5-27.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"

@interface ThemeDynamicViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableDelegate>
{
    //动态列表
    UITableView *themeDynamicTableView;
    //列表数组
    NSMutableArray *themeArray;
    
    //判断cell是否有图片
    NSMutableArray *pictureArray;
    
    NSInteger pageNumber;
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    BOOL _reloading;

}

//主题群id
@property (nonatomic, strong) NSString *themeIdString;
@end
