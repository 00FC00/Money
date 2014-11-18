//
//  GroupMemberViewController.h
//  FaceBook
//
//  Created by fengshaohui on 14-5-14.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupMemberViewController : UIViewController<UIScrollViewDelegate>

@property (strong, nonatomic) NSString *whereType; //所属部门
@property (strong, nonatomic) NSString *whereId;   //部门id
@property (strong, nonatomic) NSString *groupId;   //群id
@property (strong, nonatomic) NSString *groupName; //群名称
@end
