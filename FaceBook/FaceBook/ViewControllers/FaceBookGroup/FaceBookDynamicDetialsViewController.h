//
//  FaceBookDynamicDetialsViewController.h
//  FaceBook
//
//  Created by fengshaohui on 14-5-30.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"

@interface FaceBookDynamicDetialsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,EGORefreshTableDelegate>
{
    UITableView *dynamicetialsTableView;
    NSMutableArray *dynamicDetialsArray;
    NSMutableArray *pictureArray;
    
    NSInteger pageNumber;
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    BOOL _reloading;

    UIImageView *_lineImageView;
    UIImageView *imgView;
    
    UIImageView *commentBackgroundImageView;
    UITextView *commentTextView;
    UILabel *placeHolderLabel;
}

@property (nonatomic, strong) NSString *aidString;

@property (nonatomic, strong) NSString *fromString;

@property (nonatomic, strong) NSString *iIdString;


@end
