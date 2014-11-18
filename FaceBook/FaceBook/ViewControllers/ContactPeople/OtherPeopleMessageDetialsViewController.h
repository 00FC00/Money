//
//  OtherPeopleMessageDetialsViewController.h
//  FaceBook
//
//  Created by fengshaohui on 14-7-31.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtherPeopleMessageDetialsViewController : UIViewController

@property (strong, nonatomic) NSDictionary *mySweepDictionary;//搜索出来的资料
@property (strong, nonatomic) NSString *friendIdString;//查看好友信息

@property (strong, nonatomic) NSString *isCircle; //是否来自圈圈

///标题
@property (strong, nonatomic) UILabel *titleLabel;
///同事
@property (strong, nonatomic) UIButton *colleaguesButton;
///领导
@property (strong, nonatomic) UIButton *leaderButton;
///下属
@property (strong, nonatomic) UIButton *subordinatesButton;
///站内联系人
@property (strong, nonatomic) UIButton *instationButton;

//是否是外人
@property (strong, nonatomic) NSString *isInHere;

@property (strong, nonatomic) NSString * typeString;

@end
