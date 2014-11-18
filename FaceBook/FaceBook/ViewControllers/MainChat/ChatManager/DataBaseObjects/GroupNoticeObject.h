//
//  GroupNoticeObject.h
//  LifeTogether
//
//  Created by fengshaohui on 14-4-14.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupNoticeObject : NSObject
//群id
@property (strong, nonatomic) NSString *GroupID;

//新消息提醒
@property (strong, nonatomic) NSString *isNewMessageRemind;

//是否显示群昵称
@property (strong, nonatomic) NSString *showGroupName;



@end
