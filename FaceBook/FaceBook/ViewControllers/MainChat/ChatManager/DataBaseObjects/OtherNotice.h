//
//  OtherNotice.h
//  FaceBook
//
//  Created by fengshaohui on 14-7-9.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBDBManager.h"
#import "OtherNoticeObject.h"

@interface OtherNotice : NSObject
/**
 *   创建数据表
 */
- (void) createDataBase;

/**
 *获取消息提醒的参数
 */
- (OtherNoticeObject* )getAllOthersRemindStyleWithNumber:(NSString *)num;

/**
 *   更新群组消息提醒的方式
 */

- (void)UpdateTheRemindStyleWith:(NSString *)styles WithValues:(NSString *)values WithNumber:(NSString *)num;

- (void)insertTheRecordsWithNumber:(NSString *)num;

@end
