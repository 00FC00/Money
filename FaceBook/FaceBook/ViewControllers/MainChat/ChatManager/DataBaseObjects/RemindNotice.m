//
//  RemindNotice.m
//  LifeTogether
//
//  Created by fengshaohui on 14-4-10.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "RemindNotice.h"
#define RecentlyContacts @"recentlyContacts" //最近联系人消息数据库
@implementation RemindNotice
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
    FMResultSet * set = [_db executeQuery:[NSString stringWithFormat:@"select count(*) from sqlite_master where type ='table' and name = '%@'",RecentlyContacts]];
    
    [set next];
    
    NSInteger count = [set intForColumnIndex:0];
    
    BOOL existTable = !!count;
    
    if (existTable) {
        // TODO:是否更新数据表
        NSLog(@"数据库已存在");
    } else {
        // TODO: 插入新的数据表delete from NoticeTable  where ROW != 1  R_GroupNewMessage showMemberName
        NSString * sql = @"CREATE TABLE IF NOT EXISTS NoticeTable (ROW INTEGER PRIMARY KEY NOT NULL,voiceRemind VARCHAR  NOT NULL, sharkRemind VARCHAR  NOT NULL,partyReceiveRemind VARCHAR  NOT NULL,partyDynamicRemind VARCHAR  NOT NULL,friendsReceiveRemind VARCHAR  NOT NULL,R_GroupNewMessage VARCHAR  NOT NULL,showMemberName VARCHAR  NOT NULL)";
        BOOL res = [_db executeUpdate:sql];
        
        if (!res) {
            NSLog(@"数据表创建失败");
        } else {
            NSLog(@"数据表创建成功");
            NSString *voiceSql = @"INSERT INTO NoticeTable (voiceRemind,sharkRemind,partyReceiveRemind,partyDynamicRemind,friendsReceiveRemind,R_GroupNewMessage,showMemberName) VALUES('1','1','1','1','1','1','1')";
            NSLog(@"初始化一条数据");
            BOOL isvoiceSuccess = [_db executeUpdate:voiceSql];
            
            if (isvoiceSuccess) {
                NSLog(@"初始化成功");
            }

        }
    }
}
/**
 *获取消息提醒的参数
 */
- (void)UpdateTheRemindStyleWith:(NSString *)styles WithValues:(NSString *)values ;
{
    NSString * Updatessql = [NSString stringWithFormat:@"UPDATE NoticeTable SET %@ = %@ WHERE ROW = 1",styles,values];
    [_db executeUpdate:Updatessql];
}


- (RemindObject*)getAllRemindStyle
{
    NSString *updatetUser = [NSString stringWithFormat:@"delete from NoticeTable  where ROW != 1 "];
    [_db executeUpdate:updatetUser];

    FMResultSet *rs = [_db executeQuery:@"SELECT * FROM NoticeTable"];
//    NSMutableArray * remindArray = [[NSMutableArray alloc] initWithCapacity:0];
    //NSMutableDictionary * Dic = [NSMutableArray arrayWithCapacity:[rs columnCount]];
//    NSMutableDictionary *Dic = [[NSMutableDictionary alloc] initWithCapacity:100];
    RemindObject * rec_obj = [[RemindObject alloc] init];

    while ([rs next]){
        rec_obj.voiceRemind  = [rs stringForColumn:@"voiceRemind"];
        rec_obj.sharkRemind = [rs stringForColumn:@"sharkRemind"];
        rec_obj.partyReceiveRemind = [rs stringForColumn:@"partyReceiveRemind"];
        rec_obj.partyDynamicRemind = [rs stringForColumn:@"partyDynamicRemind"];
        rec_obj.friendsReceiveRemind = [rs stringForColumn:@"friendsReceiveRemind"];
        rec_obj.R_GroupNewMessage = [rs stringForColumn:@"R_GroupNewMessage"];
        rec_obj.showMemberName = [rs stringForColumn:@"showMemberName"];
        
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
