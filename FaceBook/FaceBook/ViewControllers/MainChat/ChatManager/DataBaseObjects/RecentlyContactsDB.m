//
//  RecentlyContactsDB.m
//  ChuMian
//
//  Created by 颜 沛贤 on 13-10-31.
//
//

/*
 //最近联系人数据表字段说明
 
 channelId -- 频道的Id，
 fromUid -- 私聊的话就是来自于谁的id，群聊就是群的id
 fromName -- 私聊的话就是来自于个人的名字，群聊的话就是群的名字
 faceId -- 此条消息是我收到的，那么这是对方的面的id；如果此条消息是我发的，那么这条消息是对方的面的id；【此处按消息来，不区分群聊和私聊】
 toUid -- msgto(私聊是发给谁的id，群聊是*)
 headLogoUrl -- 头像的url
 chatType -- 消息的类型(0是私聊，1是群聊)
 chatMsgType -- 消息内容的类型，
 LLChatMessageTypePlain = 0,//文本
 LLChatMessageTypeImage = 1,//图片
 LLChatMessageTypeVoice =2,//声音
 LLChatMessageTypeLocation=3,//地点
 LLChatMessageTypeVcard=4,//名片
 LLChatMessageTypePlaceWall=5,//地点墙
 LLChatMessageTypeNotification=6//通知-加入群退出群等
 
 recentlyMessageContent -- 内容【群聊私聊一致】
 recentlyDate -- 时间（时间戳，此处为服务端返回的时间戳）
 
 */



#import "RecentlyContactsDB.h"


#define RecentlyContacts @"recentlyContacts" //最近联系人消息数据库

@implementation RecentlyContactsDB
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
    NSLog(@"❤❤❤❤❤❤❤");
    FMResultSet * set = [_db executeQuery:[NSString stringWithFormat:@"select count(*) from sqlite_master where type ='table' and name = '%@'",RecentlyContacts]];
    
    [set next];
    
    NSInteger count = [set intForColumnIndex:0];
    
    BOOL existTable = !!count;
    
    if (existTable) {
        // TODO:是否更新数据表
        NSLog(@"数据库已存在");
    } else {
        // TODO: 插入新的数据表
        NSString * sql = @"CREATE TABLE IF NOT EXISTS RecentlyMessage (cmid INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL, messageChatType VARCHAR  NOT NULL, content VARCHAR  NOT NULL,timelength VARCHAR  NOT NULL,messageFaceId VARCHAR  NOT NULL,faceHeadLogo VARCHAR  DEFAULT NULL,messageFaceName VARCHAR NOT NULL,messageDate VARCHAR  DEFAULT NULL,messageType VARCHAR  NOT NULL,unReadNumber INTEGER  NOT NULL,messageWhereType INTEGER  NOT NULL,messageWhereId INTEGER  NOT NULL)";
        BOOL res = [_db executeUpdate:sql];
        if (!res) {
            NSLog(@"数据表创建失败");
        } else {
            NSLog(@"数据表创建成功");
        }
    }
}


/**
 *   保存一条数据，当两人的聊天记录有的时候替换，没有时插入
        --(返回YES：成功，返回NO：库中已存在该元素)
 */
- (void)saveRecentlyContactsWith:(FMDBRecentlyContactsObject*)recentlyObj
{
    if ([[self findUnitWithObject:recentlyObj] count] == 0) {
        //库中没有改元素，插入
        NSLog(@"%@",[self toSaveRecentlyMessage:recentlyObj] ? @"插入数据库成功":@"插入数据库失败");
    }else{
        //库中有该元素，更改
        //更改数据库中的数据
        NSLog(@"%@",[self changeRecentlyInfoWith:recentlyObj] ? @"更改数据库成功":@"更改数据库失败");
    }

    
}


//查找该表中有没有该元素
- (NSMutableArray*)findUnitWithObject:(FMDBRecentlyContactsObject*)recentlyObj
{
    if ([recentlyObj.messageChatType integerValue] == LLPrivateChat) {
        FMResultSet *rs = [_db executeQuery:@"SELECT * FROM RecentlyMessage where messageFaceId = ?",recentlyObj.messageFaceId];
        NSLog(@"rs is %@,==%d  iiii---%@",rs,[rs columnCount],recentlyObj.messageFaceId);
        NSMutableArray * resultArr = [[NSMutableArray alloc] initWithCapacity:[rs columnCount]];
        while ([rs next]){
            FMDBRecentlyContactsObject * f_reobj = [[FMDBRecentlyContactsObject alloc] init];
            f_reobj.messageFaceId = [rs stringForColumn:@"messageFaceId"];
            f_reobj.messageWhereType = [rs stringForColumn:@"messageWhereType"];
            f_reobj.messageWhereId = [rs stringForColumn:@"messageWhereId"];
            [resultArr addObject: f_reobj];
        }
        [rs close];
        return resultArr;
    }else {
        FMResultSet *rs = [_db executeQuery:@"SELECT * FROM RecentlyMessage where messageFaceId = ?",recentlyObj.messageFaceId];
        NSLog(@"rs is %@,==%d  iiii---%@",rs,[rs columnCount],recentlyObj.messageFaceId);
        NSMutableArray * resultArr = [[NSMutableArray alloc] initWithCapacity:[rs columnCount]];
        while ([rs next]){
            FMDBRecentlyContactsObject * f_reobj = [[FMDBRecentlyContactsObject alloc] init];
            f_reobj.messageFaceId = [rs stringForColumn:@"messageFaceId"];
            f_reobj.messageWhereType = [rs stringForColumn:@"messageWhereType"];
            f_reobj.messageWhereId = [rs stringForColumn:@"messageWhereId"];

            [resultArr addObject: f_reobj];
        }
        [rs close];
        return resultArr;
    }
    
    
    
//    if ([rs columnCount] == 0) {
//        //没有该元素
//        [rs close];
//        return NO;
//    }else {
//        //有该元素
//        [rs close];
//        return NO;
//    }
}


//插入元素
- (BOOL)toSaveRecentlyMessage:(FMDBRecentlyContactsObject*)recentlyObj
{
    
//    NSMutableString * query = [NSMutableString stringWithFormat:@"INSERT INTO RecentlyMessage"];
//    NSMutableString * keys = [NSMutableString stringWithFormat:@" ("];
//    NSMutableString * values = [NSMutableString stringWithFormat:@" ( "];
//    NSMutableArray * arguments = [NSMutableArray arrayWithCapacity:5];
//    if (recentlyObj.messageTo) {
//        [keys appendString:@"messageTo,"];
//        [values appendString:@"?,"];
//        [arguments addObject:recentlyObj.messageTo];
//    }
////    if (recentlyObj.faceId) {
////        [keys appendString:@"faceId,"];
////        [values appendString:@"?,"];
////        [arguments addObject:recentlyObj.faceId];
////    }
//    if (recentlyObj.messageFrom) {
//        [keys appendString:@"messageFrom,"];
//        [values appendString:@"?,"];
//        [arguments addObject:recentlyObj.messageFrom];
//    }
//    if (recentlyObj.messageFromName) {
//        [keys appendString:@"messageFromName,"];
//        [values appendString:@"?,"];
//        [arguments addObject:recentlyObj.messageFromName];
//    }
//    if (recentlyObj.messageTo) {
//        [keys appendString:@"messageTo,"];
//        [values appendString:@"?,"];
//        [arguments addObject:recentlyObj.messageTo];
//    }
//    if (recentlyObj.messageTo) {
//        [keys appendString:@"toUid,"];
//        [values appendString:@"?,"];
//        [arguments addObject:recentlyObj.messageTo];
//    }
//    if (recentlyObj.headImage) {
//        [keys appendString:@"headImage,"];
//        [values appendString:@"?,"];
//        [arguments addObject:recentlyObj.headImage];
//    }
//    //聊天类型
//    if (recentlyObj.messageChatType) {
//        [keys appendString:@"messageChatType,"];
//        [values appendString:@"?,"];
//        [arguments addObject:recentlyObj.messageChatType];
//    }
//    //信息类型
//    if (recentlyObj.messageType) {
//        [keys appendString:@"messageType,"];
//        [values appendString:@"?,"];
//        [arguments addObject:recentlyObj.messageType];
//    }
//    //内容
//    if (recentlyObj.content) {
//        [keys appendString:@"content,"];
//        [values appendString:@"?,"];
//        [arguments addObject:recentlyObj.content];
//    }
//    //
//    if (recentlyObj.messageDate) {
//        [keys appendString:@"messageDate,"];
//        [values appendString:@"?,"];
//        [arguments addObject:recentlyObj.messageDate];
//    }
//    if (recentlyObj.isRead) {
//        [keys appendString:@"isRead,"];
//        [values appendString:@"?,"];
//        [arguments addObject:recentlyObj.isRead];
//    }
//    [keys appendString:@")"];
//    [values appendString:@")"];
//    [query appendFormat:@" %@ VALUES%@",
//     [keys stringByReplacingOccurrencesOfString:@",)" withString:@")"],
//     [values stringByReplacingOccurrencesOfString:@",)" withString:@")"]];
//    NSLog(@"%@",query);
//    NSLog(@"插入一条数据");
//   BOOL isInsertSuccess = [_db executeUpdate:query withArgumentsInArray:arguments];
//
//    return isInsertSuccess;
//    NSData * imagedata = UIImageJPEGRepresentation(recentlyObj.faceHeadLogo, 0.1);
   
    NSString * saveString = [NSString stringWithFormat:@"insert into RecentlyMessage (messageChatType,content,timelength,messageFaceId,messageFaceName,faceHeadLogo,messageDate,messageType,unReadNumber,messageWhereType,messageWhereId) values('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",recentlyObj.messageChatType,recentlyObj.content,recentlyObj.timelength,recentlyObj.messageFaceId,recentlyObj.messageFaceName,recentlyObj.faceHeadLogo,recentlyObj.messageDate,recentlyObj.messageType,recentlyObj.unReadNumber,recentlyObj.messageWhereType,recentlyObj.messageWhereId];
    
    NSLog(@"save is %@",saveString);
    //    BOOL isInsertSuccess = [_db executeUpdate:query withArgumentsInArray:arguments];
    
    BOOL isInsertSuccess = [_db executeUpdate:saveString];
    
    NSLog(@"私人聊天插入一条数据--%d",isInsertSuccess);
    
    return isInsertSuccess;

}


//更改信息
- (BOOL)changeRecentlyInfoWith:(FMDBRecentlyContactsObject*)recentlyObj
{
    
    //查找到原来的未读条数，再次基础上加1
    NSString * formerUnread = [self checkisReadWithContactObj:recentlyObj];
    
    NSString * unread = [NSString stringWithFormat:@"%d",[formerUnread integerValue]+1];
//    NSLog(@"yan is %@,unread is %@",recentlyObj.isRead,unread);
    
    //@"CREATE TABLE IF NOT EXISTS PrivateChatMessagesTable (cmid INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL, messageChatType VARCHAR  NOT NULL, messageFromName VARCHAR  NOT NULL,messageFrom VARCHAR  NOT NULL,messageTo VARCHAR  NOT NULL,headImage VARCHAR  DEFAULT NULL,content VARCHAR NOT NULL,timelength VARCHAR  DEFAULT NULL,messageDate VARCHAR  NOT NULL,messageType INTEGER  NOT NULL, messageCellStyle INTEGER  NOT NULL)";
    
    
    NSString * sql = @"UPDATE RecentlyMessage SET messageChatType = ?, messageType = ?, content = ?, messageDate = ?, unReadNumber = ? WHERE messageFaceId = ?";
    
    
    BOOL isChangeSuccess = [_db executeUpdate:sql,recentlyObj.messageChatType,recentlyObj.messageType,recentlyObj.content,recentlyObj.messageDate,unread,recentlyObj.messageFaceId];
    
    return isChangeSuccess;
}


//查看此联系人的未读条数
- (NSString*)checkisReadWithContactObj:(FMDBRecentlyContactsObject*)recentlyObj
{
    FMResultSet *rs = [_db executeQuery:@"SELECT * FROM RecentlyMessage where messageFaceId = ?",recentlyObj.messageFaceId];
    NSString * unreadstring;
    while ([rs next]){
        
        unreadstring = [rs stringForColumn:@"unReadNumber"];
    }
    [rs close];
   
    return unreadstring;
}


/**
 *   清空该条信息的未读条数，清空为0
 */
- (BOOL)emptyisReadWithRecentlyObj:(FMDBRecentlyContactsObject*)recentlyObj;
{
    //创建通知，刷新最近联系人
    [[NSNotificationCenter defaultCenter] postNotificationName:@"emptyNumber" object:nil];
    NSLog(@"发送通知，刷心跳数");
    
    NSString * sql = @"UPDATE RecentlyMessage SET unReadNumber = ? WHERE messageFaceId = ?";
    
    
    BOOL isChangeSuccess = [_db executeUpdate:sql,@"0",recentlyObj.messageFaceId];
    
    return isChangeSuccess;
    
    

}


/**
 *   删除改消息记录---记得同时删除两个人的聊天记录
 */
- (BOOL)delegateTrcentlyConMessageWithObj:(FMDBRecentlyContactsObject*)recentlyObj
{
    //同时要删除两个人的聊天记录
    NSString * sql = @"DELETE FROM RecentlyMessage WHERE messageFaceId = ?";

    BOOL isDelegateSuccess = [_db executeUpdate:sql,recentlyObj.messageFaceId];
    
    return isDelegateSuccess;
    
}

//取出所有的最近联系人
- (NSMutableArray*)getAllRecentlyContactsInfo
{
    FMResultSet *rs = [_db executeQuery:@"SELECT * FROM RecentlyMessage"];
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:[rs columnCount]];
    while ([rs next]){
        FMDBRecentlyContactsObject * rec_obj = [[FMDBRecentlyContactsObject alloc] init];
        rec_obj.messageFaceId = [rs stringForColumn:@"messageFaceId"];
        rec_obj.messageFaceName = [rs stringForColumn:@"messageFaceName"];
        rec_obj.faceHeadLogo = [rs stringForColumn:@"faceHeadLogo"];
        
        //rec_obj.messageTo = [rs stringForColumn:@"messageTo"];
        rec_obj.messageChatType = [rs stringForColumn:@"messageChatType"];
        rec_obj.content = [rs stringForColumn:@"content"];
        rec_obj.timelength = [rs stringForColumn:@"timelength"];
         rec_obj.messageDate = [rs stringForColumn:@"messageDate"];
        rec_obj.messageType = [NSNumber numberWithInt:[rs intForColumn:@"messageType"]];
        
        rec_obj.messageWhereType = [rs stringForColumn:@"messageWhereType"];
        rec_obj.messageWhereId = [rs stringForColumn:@"messageWhereId"];
        
        rec_obj.unReadNumber = [rs stringForColumn:@"unReadNumber"];
        
        
        [array addObject:rec_obj];
    }
    [rs close];
    
    //此处的array 按时间排序
    //NSMutableArray * tarr = [self sortReloadArrayWithArray:array];
    
    return array;
}

//排序
- (NSMutableArray*)sortReloadArrayWithArray:(NSMutableArray *)array
{
    NSMutableArray * t_arr = [[NSMutableArray alloc] initWithCapacity:0];
    t_arr = array;
    
    for (int i = 0; i<[t_arr count]; i++)
    {
        for(int j=i+1; j<[t_arr count];j++)
        {
            float a = [((FMDBRecentlyContactsObject*)[t_arr objectAtIndex:i]).messageDate floatValue];
                          //NSLog(@"a= %f",a);
            float b = [((FMDBRecentlyContactsObject*)[t_arr objectAtIndex:j]).messageDate floatValue];
                          //NSLog(@"b= %f",b);
            //             NSLog(@"------");
            if (a < b)
            {
                [t_arr exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
            
        }
        
    }
    
    return t_arr;
}

@end
