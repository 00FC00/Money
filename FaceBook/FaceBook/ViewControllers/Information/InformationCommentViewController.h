//
//  InformationCommentViewController.h
//  FaceBook
//
//  Created by HMN on 14-6-26.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"

@interface InformationCommentViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableDelegate,UITextViewDelegate>
{
    UITableView *commentTabelView;
    NSMutableArray *commentArray;
    
    NSInteger pageNumber;
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    BOOL _reloading;
    
    UIImageView *commentBackgroundImageView;
    UITextView *commentTextView;
    UILabel *placeHolderLabel;

}

@property (nonatomic, strong) NSString *informationId;
@property (nonatomic, strong) NSString *informationTitle;
@property (nonatomic, strong) NSString *informationAddTime;

@end
