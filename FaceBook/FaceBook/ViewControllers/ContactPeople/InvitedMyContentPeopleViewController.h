//
//  InvitedMyContentPeopleViewController.h
//  FaceBook
//
//  Created by fengshaohui on 14-8-11.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CfriendsItem : NSObject
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

+ (CfriendsItem*) friendsItem;

@end

@interface InvitedMyContentPeopleViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    NSMutableArray * _selectedFriendsArray;
    
    BOOL isSelected;
    
}

@property (nonatomic, strong) UITableView *friendTabelView;
@property (nonatomic,retain) NSMutableDictionary *dataDic;
@property (nonatomic,retain) NSMutableDictionary *friendsDic;

@property (strong, nonatomic) NSString *groupid;
@property (strong, nonatomic) NSMutableArray *listArray;
@property (strong, nonatomic) NSMutableArray * friendsArray;

@property (nonatomic, strong) NSString *fromString;


@end
