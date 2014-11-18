//
//  MessageListDetialsViewController.h
//  FaceBook
//
//  Created by fengshaohui on 14-8-4.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageListDetialsViewController : UIViewController
@property (strong, nonatomic) NSDictionary *mySweepDictionary;//搜索出来的资料
@property (strong, nonatomic) NSString *friendIdString;//查看好友信息

@property (strong, nonatomic) NSString *isComment; //是否来自圈圈
@property (strong, nonatomic) NSDictionary *dic;

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *commentLabel;
@property (strong, nonatomic) UIButton *sureButton;
@property (strong, nonatomic) UIButton *cancleButton;
@end
