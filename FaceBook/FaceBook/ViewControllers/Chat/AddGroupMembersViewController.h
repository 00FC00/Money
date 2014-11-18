//
//  AddGroupMembersViewController.h
//  FaceBook
//
//  Created by fengshaohui on 14-7-21.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"

@interface FriendsItems : NSObject
{
    
    int friendId;//朋友的id
    NSString * headImageUrlString;//朋友图像的url
	NSString* name;//朋友的姓名
	BOOL checked;//是否被选中
}
@property (nonatomic, assign)		int		friendId;
@property (nonatomic, copy)		NSString*		headImageUrlString;
@property (nonatomic, copy)		NSString*		name;
@property (strong, nonatomic)   NSString *      userCompany;
@property (strong, nonatomic)   NSString *      userInstitutionID;
@property (nonatomic, assign)	BOOL			checked;

+ (FriendsItems*) friendsItem;

@end

@interface AddGroupMembersViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,EGORefreshTableDelegate>
{
    NSMutableArray * _selectedFriendsArray;
    
    BOOL isSelected;
    
    
    NSInteger pageNumber;
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    BOOL _reloading;
    
}

@property (nonatomic, strong) UITableView *friendTabelView;
@property (nonatomic,retain) NSMutableDictionary *dataDic;
@property (nonatomic,retain) NSMutableDictionary *friendsDic;

@property (strong, nonatomic) NSString *groupid; //部门的id
@property (strong, nonatomic) NSString *myGroupIds; //群的id号
@property (strong, nonatomic) NSMutableArray *listArray;
@property (strong, nonatomic) NSMutableArray * friendsArray;

@property (nonatomic, strong) NSString *fromString;//属于那个来源【机构，条线，主题】

@property (strong, nonatomic) NSMutableArray *myMemberArray;//已经在的成员

@end
