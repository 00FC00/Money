//
//  InstitutionsDynamicViewController.h
//  FaceBook
//
//  Created by fengshaohui on 14-5-27.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"

@interface InstitutionsDynamicViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,EGORefreshTableDelegate>
{
    //动态列表
    UITableView *i_DynamicTableView;
    //列表数组
    NSMutableArray *listArray;
    
    //下方工具栏背景
    UIImageView *myToolBackImageView;
    NSMutableArray *myToolArray;
    //下方工具栏列表
    UITableView *myToolTableView;
    
    //判断cell是否有图片
    NSMutableArray *pictureArray;
    
    
    NSInteger pageNumber;
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    BOOL _reloading;
}
@property (strong, nonatomic) NSString *groupId;
@end
