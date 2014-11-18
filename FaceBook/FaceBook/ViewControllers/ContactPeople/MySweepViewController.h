//
//  MySweepViewController.h
//  ContactGroup
//
//  Created by 蓝凌 on 14-5-13.
//  Copyright (c) 2014年 蓝凌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MySweepViewController : UIViewController

@property (strong, nonatomic) NSDictionary *mySweepDictionary;//搜索出来的资料

@property (strong, nonatomic) NSString *fromString;//来自

@property (strong, nonatomic) NSString *friendIdString;//查看好友信息


@property (strong, nonatomic) NSString *groupIdString;

@property (strong, nonatomic) NSString *groupTypeString;


@property (strong, nonatomic) NSDictionary *otherResumeDictionary;//其他人的个人简历字典


@end
