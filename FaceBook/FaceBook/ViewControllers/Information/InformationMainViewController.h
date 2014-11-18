//
//  InformationMainViewController.h
//  FaceBook
//
//  Created by fengshaohui on 14-7-28.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"
@interface InformationMainViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableDelegate>
{
    UITableView *informationMainTableView;//咨询表
    NSMutableArray *inforArray;
    
    NSArray *listArray;
    UIButton *newsClassButton;//分类按钮
    
    UIImageView *listBackImageView;//下拉框背景
    UITableView *listTableView;//下拉表
   
    BOOL isListShow;
    
    NSInteger pageNumber;
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    BOOL _reloading;
   __block NSString *typeStrId;

}
@property (strong, nonatomic) NSArray *listArray;
@end
