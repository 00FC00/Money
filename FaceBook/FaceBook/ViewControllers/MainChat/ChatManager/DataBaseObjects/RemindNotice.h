//
//  RemindNotice.h
//  LifeTogether
//
//  Created by fengshaohui on 14-4-10.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBDBManager.h"
#import "RemindObject.h"
@interface RemindNotice : NSObject

/**
 *   创建数据表
 */
- (void) createDataBase;

/**
 *获取消息提醒的参数
 */
- (RemindObject* )getAllRemindStyle;

/**
 *   更新消息提醒的方式
 */

- (void)UpdateTheRemindStyleWith:(NSString *)styles WithValues:(NSString *)values ;




@end
