//
//  GroupNotice.m
//  LifeTogether
//
//  Created by fengshaohui on 14-4-14.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "GroupNotice.h"
#define NoticeContacts @"NoticeContacts" //消息提示数据库
@implementation GroupNotice
{
    FMDatabase * _db;
    BOOL isSuccessSave;
}



- (id) init
{
    self = [super init];
    if (self) {
        //=== 首先查看有没有建立数据库，如果未建立，则建立数据库
        _db = [MBDBManager defaultMBDBManager].dataBase;
        
    }
    return self;
}

/**
 *   创建数据表
 */
- (void) createDataBase
{
    FMResultSet * set = [_db executeQuery:[NSString stringWithFormat:@"select count(*) from sqlite_master where type ='table' and name = '%@'",NoticeContacts]];
    
    [set next];
    
    NSInteger count = [set intForColumnIndex:0];
    
    BOOL existTable = !!count;
    
    if (existTable) {
        // TODO:是否更新数据表
        NSLog(@"数据库已存在");
    } else {
        // TODO: 插入新的数据表delete from NoticeTable  where ROW != 1  R_GroupNewMessage showMemberName
        NSString * sql = @"CREATE TABLE IF NOT EXISTS GroupNoticeTable (Gid VARCHAR PRIMARY KEY NOT NULL,N_newMsgRemind VARCHAR  NOT NULL, showNikeName VARCHAR  NOT NULL)";
        BOOL res = [_db executeUpdate:sql];
        
        if (!res) {
            NSLog(@"数据表创建失败");
        } else {
            NSLog(@"数据表创建成功");
            
        }
    }
}
/**
 *向数据库存入数据
 **/
- (void)insertTheRecordsWithGroupID:(NSString *)Gid
{
    //NSString *voiceSql = @"INSERT INTO NoticeTable (Gid,N_newMsgRemind,showNikeName) VALUES('','1','1')";
    
    NSString *voiceSql = [NSString stringWithFormat:@"INSERT INTO GroupNoticeTable (Gid,N_newMsgRemind,showNikeName) VALUES('%@','1','1')",Gid];
    NSLog(@"初始化一条数据");
    BOOL isvoiceSuccess = [_db executeUpdate:voiceSql];
    
    if (isvoiceSuccess) {
        NSLog(@"初始化成功");
    }

}
/**
 *获取消息提醒的参数
 */
- (void)UpdateTheRemindStyleWith:(NSString *)styles WithValues:(NSString *)values WithGroupID:(NSString *)Gid
{
    NSString * Updatessql = [NSString stringWithFormat:@"UPDATE GroupNoticeTable SET %@ = %@ WHERE Gid = %@",styles,values,Gid];
    NSLog(@"更新语句%@",Updatessql);
    [_db executeUpdate:Updatessql];
}


- (GroupNoticeObject*)getAllRemindStyleWithGid:(NSString *)Gid
{
//    NSString *updatetUser = [NSString stringWithFormat:@"delete from GroupNoticeTable  where ROW != 1 "];
//    [_db executeUpdate:updatetUser];
    //[NSString stringWithFormat:@"SELECT * FROM GroupNoticeTable WHERE Gid = %@",Gid];
    FMResultSet *rs = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM GroupNoticeTable WHERE Gid = %@",Gid]];
    NSLog(@"查询%@",[NSString stringWithFormat:@"SELECT * FROM GroupNoticeTable WHERE Gid = %@",Gid]);
    //    NSMutableArray * remindArray = [[NSMutableArray alloc] initWithCapacity:0];
    //NSMutableDictionary * Dic = [NSMutableArray arrayWithCapacity:[rs columnCount]];
    //    NSMutableDictionary *Dic = [[NSMutableDictionary alloc] initWithCapacity:100];
    GroupNoticeObject * rec_obj = [[GroupNoticeObject alloc] init];
    
    while ([rs next]){
        rec_obj.GroupID  = [rs stringForColumn:@"Gid"];
        rec_obj.isNewMessageRemind = [rs stringForColumn:@"N_newMsgRemind"];
        rec_obj.showGroupName = [rs stringForColumn:@"showNikeName"];
        
        
        //    NSLog(@"------设置的值---%@",rec_obj.voiceRemind);
        //      NSLog(@"------设置的值---%@",rec_obj.sharkRemind);
        //        NSLog(@"------设置的值---%@",rec_obj.partyReceiveRemind);
        //        NSLog(@"------设置的值---%@",rec_obj.partyDynamicRemind);
        //         NSLog(@"------设置的值---%@",rec_obj.friendsReceiveRemind);
        //        rec_obj.channelId = [rs stringForColumn:@"channelId"];
        //        rec_obj.fromUid = [rs stringForColumn:@"fromUid"];
        //        rec_obj.fromName = [rs stringForColumn:@"fromName"];
        //        rec_obj.faceId = [rs stringForColumn:@"faceId"];
        //        rec_obj.toUid = [rs stringForColumn:@"toUid"];
        //        rec_obj.headLogoUrl = [rs stringForColumn:@"headLogoUrl"];
        //        rec_obj.chatType = [rs stringForColumn:@"chatType"];
        //        rec_obj.chatMsgType = [rs stringForColumn:@"chatMsgType"];
        //        rec_obj.recentlyMessageContent = [rs stringForColumn:@"recentlyMessageContent"];
        //        rec_obj.recentlyDate = [rs stringForColumn:@"recentlyDate"];
        //        rec_obj.unreadNumber = [rs stringForColumn:@"unreadNumber"];
        
        
        //       [array addObject:rec_obj];
        
        
    }
    [rs close];
    
    //此处的array 按时间排序
    //NSMutableArray * tarr = [self sortReloadArrayWithArray:array];
    
    //  return array;
    
    return rec_obj;
}

@end
