//
//  PrivateChatMessagesDB.h
//  ChuMian
//
//  Created by 颜 沛贤 on 13-11-1.
//
//
// 建立私聊的表

#import <Foundation/Foundation.h>

#import "MBDBManager.h"
#import "MessageObject.h"

@interface PrivateChatMessagesDB : NSObject


/**
 *   创建数据表
 */
- (void) createDataBase;

/**
 *   保存一条数据，这是两个人对话的记录
 */
- (BOOL)savePrivateMessageWithMessage:(MessageObject*)message;


/**
 *   查找聊天记录-根据messageChatType，fromid,toid
 */
- (NSMutableArray*)searchMessagesArrayWithmMssageChatType:(NSString*)messageChatType //消息的类型0是私聊，1是群聊
                                                andFromId:(NSString*)fid //来源的id，来自用户
                                                  andToId:(NSString*)toid andMessageWhereType:(NSString *)messageWhereType andMessageWhereId:(NSString *)messageWhereid; //target的id，私聊是用户的id，群聊是群的id


/**
 *   查找群的聊天记录聊天记录-根据groupid
 */
- (NSMutableArray*)searchMessagesArrayWithGroupID:(NSString*)groupid andMessageWhereType:(NSString *)messageWhereType andMessageWhereId:(NSString *)messageWhereid;

/**
 *   删除聊天记录-根据messageChatType，fromid,toid
 */
- (BOOL)delegeteMessagesArrayWithMssageChatType:(NSString*)messageChatType andFromId:(NSString*)fid andToId:(NSString*)toid andMessageWhereType:(NSString *)messageWhereType andMessageWhereId:(NSString *)messageWhereid;

/**
 *   删除群的聊天记录-根据groupid
 */
- (BOOL)delegeteMessagesArrayWithGroupID:(NSString*)groupid andMessageWhereType:(NSString *)messageWhereType andMessageWhereId:(NSString *)messageWhereid;
/**
 *删除所有聊天内容
 */
- (BOOL)delegeteMessageAllArray;

//取出所有的聊天记录
- (NSMutableArray*)getAllChatMessages;

/**
 * @brief 根据群的id 类型  消息的时间戳来判断是否存在
 *
 **/
- (BOOL)isHaveTheMessageWithGroupID:(NSString*)groupid andMessageWhereType:(NSString *)messageWhereType andMessageDate:(NSString *)messageDate;

@end
