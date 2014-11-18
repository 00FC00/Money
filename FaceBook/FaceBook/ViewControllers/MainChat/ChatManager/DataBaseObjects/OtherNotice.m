//
//  OtherNotice.m
//  FaceBook
//
//  Created by fengshaohui on 14-7-9.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "OtherNotice.h"
#define NoticeContacts @"OthersNoticeContacts" //消息提示数据库
@implementation OtherNotice
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
        NSString * sql = @"CREATE TABLE IF NOT EXISTS OthersNoticeTable (num VARCHAR PRIMARY KEY NOT NULL,savePhoto VARCHAR  NOT NULL)";
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
- (void)insertTheRecordsWithNumber:(NSString *)num
{
    //NSString *voiceSql = @"INSERT INTO NoticeTable (Gid,N_newMsgRemind,showNikeName) VALUES('','1','1')";
    
    NSString *voiceSql = [NSString stringWithFormat:@"INSERT INTO OthersNoticeTable (num,savePhoto) VALUES('%@','1')",num];
    NSLog(@"初始化一条数据");
    BOOL isvoiceSuccess = [_db executeUpdate:voiceSql];
    
    if (isvoiceSuccess) {
        NSLog(@"初始化成功");
    }
    
}


/**
 *获取消息提醒的参数
 */
- (void)UpdateTheRemindStyleWith:(NSString *)styles WithValues:(NSString *)values WithNumber:(NSString *)num
{
    NSString * Updatessql = [NSString stringWithFormat:@"UPDATE OthersNoticeTable SET %@ = %@ WHERE num = %@",styles,values,num];
    NSLog(@"更新语句%@",Updatessql);
    [_db executeUpdate:Updatessql];
}


- (OtherNoticeObject*)getAllOthersRemindStyleWithNumber:(NSString *)num
{
    //    NSString *updatetUser = [NSString stringWithFormat:@"delete from GroupNoticeTable  where ROW != 1 "];
    //    [_db executeUpdate:updatetUser];
    //[NSString stringWithFormat:@"SELECT * FROM GroupNoticeTable WHERE Gid = %@",Gid];
    FMResultSet *rs = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM OthersNoticeTable WHERE num = %@",num]];
    NSLog(@"查询%@",[NSString stringWithFormat:@"SELECT * FROM OthersNoticeTable WHERE num = %@",num]);
    //    NSMutableArray * remindArray = [[NSMutableArray alloc] initWithCapacity:0];
    //NSMutableDictionary * Dic = [NSMutableArray arrayWithCapacity:[rs columnCount]];
    //    NSMutableDictionary *Dic = [[NSMutableDictionary alloc] initWithCapacity:100];
    OtherNoticeObject * rec_obj = [[OtherNoticeObject alloc] init];
    
    while ([rs next]){
        rec_obj.num  = [rs stringForColumn:@"num"];
        rec_obj.isSavePhoto = [rs stringForColumn:@"savePhoto"];
        
        
        
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
