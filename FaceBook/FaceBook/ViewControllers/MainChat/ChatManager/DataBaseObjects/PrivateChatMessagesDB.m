//
//  PrivateChatMessagesDB.m
//  ChuMian
//
//  Created by 颜 沛贤 on 13-11-1.
//
//

#import "PrivateChatMessagesDB.h"
#import "BCHTTPRequest.h"

#define PrivateChatMessages @"privateChatMessages" //私人聊天的数据表


/*
 //聊天的消息数据表字段说明
 
 messageChatType -- 消息是私聊的还是群聊的

 messageFromName -- 消息的发送者的名字
 messageFrom -- 消息的发送者的id
 messageTo -- 消息的接受者的id
 content -- 消息的内容
 timelength -- 时间长度（只有是语音的时候有值，其他都为0）
 messageDate -- 时间
 messageType -- 消息的类型
 
 */


@implementation PrivateChatMessagesDB
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
    FMResultSet * set = [_db executeQuery:[NSString stringWithFormat:@"select count(*) from sqlite_master where type ='table' and name = '%@'",PrivateChatMessages]];
    
    [set next];
    
    NSInteger count = [set intForColumnIndex:0];
    
    BOOL existTable = !!count;
    
    if (existTable) {
        // TODO:是否更新数据表
        NSLog(@"私人聊天数据库已存在");
    } else {
        // TODO: 插入新的数据表
        NSString * sql = @"CREATE TABLE IF NOT EXISTS PrivateChatMessagesTable (cmid INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL, messageChatType VARCHAR  NOT NULL, messageFromName VARCHAR  NOT NULL,messageFrom VARCHAR  NOT NULL,GroupName VARCHAR  NOT NULL,messageTo VARCHAR  NOT NULL,headImage VARCHAR  DEFAULT NULL,content VARCHAR NOT NULL,timelength VARCHAR  DEFAULT NULL,messageDate VARCHAR  NOT NULL,messageType INTEGER  NOT NULL, messageCellStyle INTEGER  NOT NULL,messageWhereType INTEGER  NOT NULL,messageWhereId INTEGER  NOT NULL)";
        BOOL res = [_db executeUpdate:sql];
        if (!res) {
            NSLog(@"私人聊天数据表创建失败");
        } else {
            NSLog(@"私人聊天数据表创建成功");
        }
    }
}

/**
 *   保存一条数据，这是两个人对话的记录
 */
- (BOOL)savePrivateMessageWithMessage:(MessageObject*)message
{

//    NSMutableString * query = [NSMutableString stringWithFormat:@"INSERT INTO PrivateChatMessagesTable"];
//    NSMutableString * keys = [NSMutableString stringWithFormat:@" ("];
//    NSMutableString * values = [NSMutableString stringWithFormat:@" ( "];
//    NSMutableArray * arguments = [NSMutableArray arrayWithCapacity:5];
//    if (message.messageChatType) {
//        [keys appendString:@"messageChatType,"];
//        [values appendString:@"?,"];
//        [arguments addObject:message.messageChatType];
//    }
//    
//    if (message.messageFromName) {
//        [keys appendString:@"messageFromName,"];
//        [values appendString:@"?,"];
//        [arguments addObject:message.messageFromName];
//    }
//    if (message.messageFrom) {
//        [keys appendString:@"messageFrom,"];
//        [values appendString:@"?,"];
//        [arguments addObject:message.messageFrom];
//    }
//    if (message.messageTo) {
//        [keys appendString:@"messageTo,"];
//        [values appendString:@"?,"];
//        [arguments addObject:message.messageTo];
//    }
//    if (message.headImage) {
//        [keys appendString:@"headImage,"];
//        [values appendString:@"?,"];
//        NSData * imagedata = UIImageJPEGRepresentation(message.headImage, 0.1);
////        [arguments addObject:[imagedata base64EncodedString]];
//        [arguments addObject:@"logologo"];
//
//    }
//    if (message.content) {
//        [keys appendString:@"content,"];
//        [values appendString:@"?,"];
//        [arguments addObject:message.content];
//    }
//    if (message.timelength) {
//        [keys appendString:@"timelength,"];
//        [values appendString:@"?,"];
//        [arguments addObject:message.timelength];
//    }
//    if (message.messageDate) {
//        [keys appendString:@"messageDate,"];
//        [values appendString:@"?,"];
//        [arguments addObject:message.messageDate];
//    }
//    if (message.messageType) {
//        [keys appendString:@"messageType,"];
//        [values appendString:@"?,"];
//        [arguments addObject:message.messageType];
//    }
//    if (message.messageCellStyle) {
//        [keys appendString:@"messageCellStyle,"];
//        [values appendString:@"?,"];
//        [arguments addObject:message.messageCellStyle];
//    }
//   
//    [keys appendString:@")"];
//    [values appendString:@")"];
//    [query appendFormat:@" %@ VALUES%@",
//     [keys stringByReplacingOccurrencesOfString:@",)" withString:@")"],
//     [values stringByReplacingOccurrencesOfString:@",)" withString:@")"]];
//    NSLog(@"私人聊天%@,%@---,%@",query,arguments,values);
    
    NSData * imagedata = UIImageJPEGRepresentation(message.headImage, 0.1);
    
    NSString * saveString = [NSString stringWithFormat:@"insert into PrivateChatMessagesTable (messageChatType,messageFromName,messageFrom,messageTo,headImage,content,timelength,messageDate,messageType,messageCellStyle,GroupName,messageWhereType,messageWhereId) values('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",message.messageChatType,message.messageFromName,message.messageFrom,message.messageTo,[imagedata base64EncodedString],message.content,message.timelength,message.messageDate,message.messageType,message.messageCellStyle,message.groupNames,message.messageWhereType,message.messageWhereId];
    
    NSLog(@"save is %@",saveString);
//    BOOL isInsertSuccess = [_db executeUpdate:query withArgumentsInArray:arguments];
    
    BOOL isInsertSuccess = [_db executeUpdate:saveString];
    
    NSLog(@"私人聊天插入一条数据--%d",isInsertSuccess);
    
    return isInsertSuccess;
}


/**
 *   查找聊天记录-根据messageChatType，fromid,toid
 */
- (NSMutableArray*)searchMessagesArrayWithmMssageChatType:(NSString*)messageChatType andFromId:(NSString*)fid andToId:(NSString*)toid andMessageWhereType:(NSString *)messageWhereType andMessageWhereId:(NSString *)messageWhereid
{
    
    NSLog(@"SELECT messageChatType is %@,fid is %@,toid is %@",messageChatType,fid,toid);
    
    NSString * sql = @"";
    if (messageChatType.integerValue == 0) {
        //私聊
        NSLog(@"SELECT * FROM PrivateChatMessagesTable where (messageChatType = '%@' and messageFrom = '%@' and messageTo = '%@' and messageWhereType = '%@' and messageWhereId = '%@') or (messageChatType = '%@' and messageTo = '%@' and messageFrom = '%@' and messageWhereType = '%@' and messageWhereId = '%@')",messageChatType,fid,toid,messageWhereType,messageWhereid,messageChatType,fid,toid,messageWhereType,messageWhereid);
        
       sql = [NSString stringWithFormat:@"SELECT * FROM PrivateChatMessagesTable where (messageChatType = '%@' and messageFrom = '%@' and messageTo = '%@' and messageWhereType = '%@' and messageWhereId = '%@') or (messageChatType = '%@' and messageTo = '%@' and messageFrom = '%@' and messageWhereType = '%@' and messageWhereId = '%@')",messageChatType,fid,toid,messageWhereType,messageWhereid,messageChatType,fid,toid,messageWhereType,messageWhereid];

    }else if (messageChatType.integerValue == 1) {
        //群聊
        NSLog(@"SELECT * FROM PrivateChatMessagesTable where (messageChatType = '%@' and messageTo = '%@' and messageWhereType = '%@' and messageWhereId = '%@')",messageChatType,toid,messageWhereType,messageWhereid);
        
        sql = [NSString stringWithFormat:@"SELECT * FROM PrivateChatMessagesTable where (messageChatType = '%@' and messageTo = '%@' and messageWhereType = '%@' and messageWhereId = '%@')",messageChatType,toid,messageWhereType,messageWhereid];

    }
    
    

    
    
    FMResultSet *rs = [_db executeQuery:sql];
    
    NSMutableArray * msgArray = [[NSMutableArray alloc] initWithCapacity:[rs columnCount]];
    
    while ([rs next]){
        MessageObject * messageobj = [[MessageObject alloc] init];
        messageobj.messageChatType = [NSNumber numberWithInt:[rs intForColumn:@"messageChatType"]];
        messageobj.messageFromName = [rs stringForColumn:@"messageFromName"];
        messageobj.messageFrom = [rs stringForColumn:@"messageFrom"];
        messageobj.messageTo = [rs stringForColumn:@"messageTo"];
        NSData * imageData = [NSData dataFromBase64String:[rs stringForColumn:@"headImage"]];
        messageobj.headImage = [UIImage imageWithData:imageData];//此处存base64的字符串
        messageobj.content = [rs stringForColumn:@"content"];
        messageobj.timelength = [rs stringForColumn:@"timelength"];
        messageobj.messageDate = [rs stringForColumn:@"messageDate"];
        messageobj.messageType = [NSNumber numberWithInt:[rs intForColumn:@"messageType"]];
        messageobj.messageCellStyle = [NSNumber numberWithInt:[rs intForColumn:@"messageCellStyle"]];
        messageobj.groupNames = [rs stringForColumn:@"GroupName"];
        messageobj.messageWhereType = [rs stringForColumn:@"messageWhereType"];
        messageobj.messageWhereId = [rs stringForColumn:@"messageWhereId"];
        
        [msgArray addObject:messageobj];
    }
    [rs close];
    
    //此处的array 按时间排序
//    NSMutableArray * tarr = [self sortReloadArrayWithArray:msgArray];
//    
//    return tarr;
    return msgArray;
}


/**
 *   查找群的聊天记录聊天记录-根据groupid
 */
- (NSMutableArray*)searchMessagesArrayWithGroupID:(NSString*)groupid andMessageWhereType:(NSString *)messageWhereType andMessageWhereId:(NSString *)messageWhereid
{
    NSString * sql = [NSString stringWithFormat:@"SELECT * FROM PrivateChatMessagesTable where messageTo = '%@' and messageWhereType = '%@' and messageWhereId = '%@'",groupid,messageWhereType,messageWhereid];
    FMResultSet *rs = [_db executeQuery:sql];
    
    NSMutableArray * msgArray = [[NSMutableArray alloc] initWithCapacity:[rs columnCount]];
    
    while ([rs next]){
        MessageObject * messageobj = [[MessageObject alloc] init];
        messageobj.messageChatType = [NSNumber numberWithInt:[rs intForColumn:@"messageChatType"]];
        messageobj.messageFromName = [rs stringForColumn:@"messageFromName"];
        messageobj.messageFrom = [rs stringForColumn:@"messageFrom"];
        messageobj.messageTo = [rs stringForColumn:@"messageTo"];
        NSData * imageData = [NSData dataFromBase64String:[rs stringForColumn:@"headImage"]];
        messageobj.headImage = [UIImage imageWithData:imageData];//此处存base64的字符串
        messageobj.content = [rs stringForColumn:@"content"];
        messageobj.timelength = [rs stringForColumn:@"timelength"];
        messageobj.messageDate = [rs stringForColumn:@"messageDate"];
        messageobj.messageType = [NSNumber numberWithInt:[rs intForColumn:@"messageType"]];
        messageobj.messageCellStyle = [NSNumber numberWithInt:[rs intForColumn:@"messageCellStyle"]];
        messageobj.groupNames = [rs stringForColumn:@"GroupName"];
        messageobj.messageWhereType = [rs stringForColumn:@"messageWhereType"];
        messageobj.messageWhereId = [rs stringForColumn:@"messageWhereId"];
        
        [msgArray addObject:messageobj];
    }
    [rs close];
    
    //此处的array 按时间排序
//    NSMutableArray * tarr = [self sortReloadArrayWithArray:msgArray];
//    
//    return tarr;
    
    return msgArray;

}

/**
 * @brief 根据群的id 类型  消息的时间戳来判断是否存在
 *
 **/
- (BOOL)isHaveTheMessageWithGroupID:(NSString*)groupid andMessageWhereType:(NSString *)messageWhereType andMessageDate:(NSString *)messageDate
{
    NSString * sql = [NSString stringWithFormat:@"SELECT * FROM PrivateChatMessagesTable where messageTo = '%@' and messageWhereType = '%@' and messageDate = '%@'",groupid,messageWhereType,messageDate];
    NSLog(@"我的SQL语句%@",sql);
    FMResultSet *rs = [_db executeQuery:sql];
    NSLog(@"小🍎%@",rs);
    NSMutableArray * msgArray = [[NSMutableArray alloc] initWithCapacity:[rs columnCount]];
    
    while ([rs next]){
        MessageObject * messageobj = [[MessageObject alloc] init];
        messageobj.messageChatType = [NSNumber numberWithInt:[rs intForColumn:@"messageChatType"]];
        messageobj.messageFromName = [rs stringForColumn:@"messageFromName"];
        messageobj.messageFrom = [rs stringForColumn:@"messageFrom"];
        messageobj.messageTo = [rs stringForColumn:@"messageTo"];
        NSData * imageData = [NSData dataFromBase64String:[rs stringForColumn:@"headImage"]];
        messageobj.headImage = [UIImage imageWithData:imageData];//此处存base64的字符串
        messageobj.content = [rs stringForColumn:@"content"];
        messageobj.timelength = [rs stringForColumn:@"timelength"];
        messageobj.messageDate = [rs stringForColumn:@"messageDate"];
        messageobj.messageType = [NSNumber numberWithInt:[rs intForColumn:@"messageType"]];
        messageobj.messageCellStyle = [NSNumber numberWithInt:[rs intForColumn:@"messageCellStyle"]];
        messageobj.groupNames = [rs stringForColumn:@"GroupName"];
        messageobj.messageWhereType = [rs stringForColumn:@"messageWhereType"];
        messageobj.messageWhereId = [rs stringForColumn:@"messageWhereId"];
        
        [msgArray addObject:messageobj];
    }
    [rs close];
    
    //此处的array 按时间排序
    //    NSMutableArray * tarr = [self sortReloadArrayWithArray:msgArray];
    //
    //    return tarr;
    NSLog(@"--消息条数--%d",msgArray.count);
    if (msgArray.count > 0) {
        return YES;
    }else{
        return NO;
    }

   
}
/**
 *   删除聊天记录-根据messageChatType，fromid,toid
 */
- (BOOL)delegeteMessagesArrayWithMssageChatType:(NSString*)messageChatType andFromId:(NSString*)fid andToId:(NSString*)toid andMessageWhereType:(NSString *)messageWhereType andMessageWhereId:(NSString *)messageWhereid
{
    NSLog(@"delegate messageChatType is %@,fid is %@,toid is %@,messageWhereType is %@, messageWhereid is %@",messageChatType,fid,toid,messageWhereType,messageWhereid);
    
    NSString * currentMid = [BCHTTPRequest getUserId];
    
    //NSString * sql = [NSString stringWithFormat:@"DELETE * FROM PrivateChatMessagesTable where (channelId = '%@' and faceId = '%@' and messageFrom = '%@' and messageTo = '%@') or (channelId = '%@' and faceId = '%@' and messageTo = '%@' and messageFrom = '%@') or (channelId = '%@' and faceId = '%@' and messageFrom = '%@' and messageTo = '%@') or (channelId = '%@' and faceId = '%@' and messageTo = '%@' and messageFrom = '%@')",cid,mid,fid,toid,cid,mid,fid,toid,cid,currentMid,fid,toid,cid,currentMid,fid,toid];
    
    NSString * sql = @"DELETE * FROM PrivateChatMessagesTable where (messageChatType = '?' and messageFrom = '?' and messageTo = '?' and messageWhereType = '?' and messageWhereId = '?') or (messageChatType = '?' and messageTo = '?' and messageFrom = '?' and messageWhereType = '?' and messageWhereId = '?') or (messageChatType = '?' and messageFrom = '?' and messageTo = '?' and messageWhereType = '?' and messageWhereId = '?') or (messageChatType = '?' and messageTo = '?' and messageFrom = '?' and messageWhereType = '?' and messageWhereId = '?')";
    
    BOOL isDelegateSuccess = [_db executeUpdate:sql,messageChatType,fid,toid,messageWhereType,messageWhereid,messageChatType,fid,toid,messageWhereType,messageWhereid,messageChatType,currentMid,fid,toid,messageWhereType,messageWhereid,
        messageChatType,currentMid,fid,toid,messageWhereType,messageWhereid];
    
        
    return isDelegateSuccess;

}

/**
 *   删除群的聊天记录-根据groupid
 */
- (BOOL)delegeteMessagesArrayWithGroupID:(NSString*)groupid andMessageWhereType:(NSString *)messageWhereType andMessageWhereId:(NSString *)messageWhereid
{
    NSString * sql = [NSString stringWithFormat:@"DELETE FROM PrivateChatMessagesTable where messageTo = '%@' and messageWhereType = '%@' and messageWhereId = '%@'",groupid,messageWhereType,messageWhereid];
    NSLog(@"%@",sql);
    
    BOOL isDelegateSuccess = [_db executeUpdate:sql];
    
    
    return isDelegateSuccess;
    
    
}
/**
 *删除所有聊天内容
 */
- (BOOL)delegeteMessageAllArray
{
    NSString * sql = [NSString stringWithFormat:@"DELETE FROM PrivateChatMessagesTable"];
    NSLog(@"%@",sql);
    
    BOOL isDelegateSuccess = [_db executeUpdate:sql];
    
    
    return isDelegateSuccess;

}

//取出所有的聊天记录
- (NSMutableArray*)getAllChatMessages
{
    FMResultSet *rs = [_db executeQuery:@"SELECT * FROM PrivateChatMessagesTable order by cmid asc"];
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:[rs columnCount]];
    while ([rs next]){
        MessageObject * messageobj = [[MessageObject alloc] init];
        messageobj.messageChatType = [NSNumber numberWithInt:[rs intForColumn:@"messageChatType"]];
        messageobj.messageFromName = [rs stringForColumn:@"messageFromName"];
        messageobj.messageFrom = [rs stringForColumn:@"messageFrom"];
        messageobj.messageTo = [rs stringForColumn:@"messageTo"];
        NSData * imageData = [NSData dataFromBase64String:[rs stringForColumn:@"headImage"]];
        messageobj.headImage = [UIImage imageWithData:imageData];//此处存base64的字符串
        messageobj.content = [rs stringForColumn:@"content"];
        messageobj.timelength = [rs stringForColumn:@"timelength"];
        messageobj.messageDate = [rs stringForColumn:@"messageDate"];
        messageobj.messageType = [NSNumber numberWithInt:[rs intForColumn:@"messageType"]];
        messageobj.messageCellStyle = [NSNumber numberWithInt:[rs intForColumn:@"messageCellStyle"]];
        messageobj.groupNames = [rs stringForColumn:@"GroupName"];
        messageobj.messageWhereType = [rs stringForColumn:@"messageWhereType"];
        messageobj.messageWhereId = [rs stringForColumn:@"messageWhereId"];
        
        [array addObject:messageobj];
    }
    [rs close];
    
    //此处的array 按时间排序
  //  NSMutableArray * tarr = [self sortReloadArrayWithArray:array];
    
   // return tarr;
    
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
            float a = [((MessageObject*)[t_arr objectAtIndex:i]).messageDate floatValue];
            //NSLog(@"a= %f",a);
            float b = [((MessageObject*)[t_arr objectAtIndex:j]).messageDate floatValue];
            //NSLog(@"b= %f",b);
            //             NSLog(@"------");
            if (a > b)
            {
                [t_arr exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
            
        }
        
    }
    
    return t_arr;
}




@end
