//
//  WallDetialsViewController.h
//  FaceBook
//
//  Created by fengshaohui on 14-5-19.
//  Copyright (c) 2014年 HMN. All rights reserved.
//详情

#import <UIKit/UIKit.h>
#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"

@interface WallDetialsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,EGORefreshTableDelegate>
{
    UITableView *wallDetialsTableView;
    NSMutableArray *wallDetialsArray;
    
    UIImageView *lineImageView;
    UIImageView *imgView;
    UIButton *_Button;
    
    NSInteger pageNumber;
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    BOOL _reloading;
    
    //要回复的id
    NSString *targetId;

    
}

@property (nonatomic, strong) NSString *wallIdString;
@property (nonatomic, strong) NSString *userIdStr;

@end
