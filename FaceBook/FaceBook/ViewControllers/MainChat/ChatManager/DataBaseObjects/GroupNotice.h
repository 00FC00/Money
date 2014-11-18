//
//  GroupNotice.h
//  LifeTogether
//
//  Created by fengshaohui on 14-4-14.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBDBManager.h"
#import "GroupNoticeObject.h"
@interface GroupNotice : NSObject
/**
 *   创建数据表
 */
- (void) createDataBase;

/**
 *获取消息提醒的参数
 */
- (GroupNoticeObject* )getAllRemindStyleWithGid:(NSString *)Gid;

/**
 *   更新群组消息提醒的方式
 */

- (void)UpdateTheRemindStyleWith:(NSString *)styles WithValues:(NSString *)values WithGroupID:(NSString *)Gid;

- (void)insertTheRecordsWithGroupID:(NSString *)Gid;

@end
