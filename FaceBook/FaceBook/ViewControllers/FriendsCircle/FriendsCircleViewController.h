//
//  FriendsCircleViewController.h
//  FaceBook
//
//  Created by HMN on 14-4-28.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"
@interface FriendsCircleViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate,EGORefreshTableDelegate>

{
    UITableView *friendsCircleTableView;
    UIActionSheet *photoActionSheet;
    
    NSInteger pageNumber;
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    BOOL _reloading;
    
    //回复评论需要的字段
    //被评论人的id
    NSString *beReviewedID;
    //评论内容
    NSString *reviewContent;
    //商机id
    NSString *businessID;
    
    //区别是直接评论还是回复某人
    NSString *isReplyMe;
    int isCellNumber;

}

@end
