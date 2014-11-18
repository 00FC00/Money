//
//  SUNLeftMenuViewController.h
//  SUNCommonComponent
//
//  Created by 麦志泉 on 13-9-4.
//  Copyright (c) 2013年 中山市新联医疗科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SUNLeftMenuViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *menuTableView;
    NSMutableArray *menuArray;
    //头像
    UIImageView *headImageView;
    UIButton *headButton;
    //姓名
    UILabel *nameLabel;
    UILabel *faceBookNumberLabel; //脸谱号
    UILabel *positionLabel;
    UILabel *goldLabel;
    BOOL isP;
    
    UIActionSheet *photoActionSheet;
    
    NSMutableDictionary *remindDic;
    UIImageView *redPoint;
    
    UIImageView *markVipImageView;
    
    //广告背景
    UIImageView *adBackImageView;
    UIImageView *adImageView1;
    UIImageView *adHeadImageView1;
    UILabel *adTitleLabel1;
    UILabel *adContentLabel1;
    
    UIImageView *adImageView2;
    UIImageView *adHeadImageView2;
    UILabel *adTitleLabel2;
    UILabel *adContentLabel2;
    
    //广告列表数组
    NSMutableArray *allAdArray;
    //广告默认数目
    int adNow;
    
    //可点击的广告按钮和字典信息
    NSDictionary *canClickDic;
    UIButton *canClickButton;
    
    UIImageView *msgBackImageView;
    
    UINavigationController *_navSlideSwitchVC;
    UINavigationController *quickAccessNav;
    UINavigationController *MyFaceBookGroupNav;
    UINavigationController *ChatViewNav;
    
    UINavigationController *ContactPeopleNav;
    UINavigationController *FriendsCircleNav;
    UINavigationController *FaceBookGroupNav;
    
    UINavigationController *BusinessWallNav;
    UINavigationController *InformationMainNav;
    UINavigationController *MyActivityNav;
    
    UINavigationController *TownsmanNav;
    UINavigationController *MessageNav;
    UINavigationController *UpgradeVIPNav;
    
    //
    UINavigationController *AdvertisementDetialsNav;
    
}
@property (nonatomic, strong) UINavigationController *navSlideSwitchVC;
@end
