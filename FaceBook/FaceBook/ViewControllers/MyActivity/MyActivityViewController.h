//
//  MyActivityViewController.h
//  FaceBook
//
//  Created by HMN on 14-4-29.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckActivityCityViewController.h"
@interface MyActivityViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,checkActivityCityDelegate>
{
    //群列表
    UITableView *myActivityTableView;
    
    NSMutableArray *myActivityArray;
    
    //下方工具条
    UITableView *bottomTableView;
    NSMutableArray *bottomArray;
    
    //筛选条件
    NSString *typeId;
    NSString *areaName;
    
    //标记是否刷新活动类型的表
    NSString *isRefreshBottom;
    
}


@end
