//
//  RecentlyContactsDB.h
//  ChuMian
//
//  Created by 颜 沛贤 on 13-10-31.
//
//

//  最近联系人

#import <Foundation/Foundation.h>
#import "MBDBManager.h"
#import "FMDBRecentlyContactsObject.h"

@interface RecentlyContactsDB : NSObject

/**
 *   创建数据表
 */
- (void) createDataBase;

/**
 *   保存一条数据，当两人的聊天记录有的时候替换，没有时插入--(返回YES：成功，返回NO：库中已存在该元素)
 */
- (void)saveRecentlyContactsWith:(FMDBRecentlyContactsObject*)recentlyObj;

/**
 *   清空该条信息的未读条数，清空为0
 */
- (BOOL)emptyisReadWithRecentlyObj:(FMDBRecentlyContactsObject*)recentlyObj;


/**
 *   删除改消息记录---记得同时删除两个人的聊天记录
 */
- (BOOL)delegateTrcentlyConMessageWithObj:(FMDBRecentlyContactsObject*)recentlyObj;



//取出所有的最近联系人
- (NSMutableArray*)getAllRecentlyContactsInfo;


@end
