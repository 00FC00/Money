//
//  LLRequest.m
//  WechatWall
//
//  Created by 牛方健 on 13-12-31.
//  Copyright (c) 2013年 BloveAmbition. All rights reserved.
//

#import "LLRequest.h"
#import "SynthesizeSingleton.h"
#import "SocketIO.h"
#import "SocketIOPacket.h"

#import "AppDelegate.h"
#import "BCHTTPRequest.h"

#import "BloveCache.h"

#import "MessageObject.h"
#import "PrivateChatMessagesDB.h"
#import "FMDBRecentlyContactsObject.h"
#import "RecentlyContactsDB.h"
#import <AudioToolbox/AudioToolbox.h>

#import "RemindNotice.h"
#import "RemindObject.h"

#import "GroupNotice.h"
#import "GroupNoticeObject.h"

//*********************************************************
//messageWhereType 是聊天所属的部门【0:机构 1:条线 2:主题 3:其他】【私聊最后统一改为3：其他】
//------------------------faceBook Project
//------------------------fengshaohui
//**********************************************************

static SystemSoundID shake_sound_male_id = 0;


@interface LLRequest ()<SocketIODelegate>
{
    RemindNotice *remindNotice;
    RemindObject *remindOBj;
    
    
    GroupNoticeObject *obj;
    GroupNotice * groupNotice;
    
    //是否是离线
    NSString *isOffLine;
}
@property (strong,nonatomic) SocketIO *socketIO;
@property (strong,nonatomic) NSString *weChatWallChannelID;
@property (strong,nonatomic) NSString *weChatWallChannelPassword;
@property (strong,nonatomic) NSString *weChatWallChannelToken;


@end

@implementation LLRequest

SYNTHESIZE_SINGLETON_FOR_CLASS(LLRequest);

//*************************
// 连接服务器,用户上线
//***************************
- (void)connect
{
    if (!self.socketIO) {
        self.socketIO = [[SocketIO alloc] initWithDelegate:self];
    }
    //203.195.181.21  //115.28.82.17
    [self.socketIO connectToHost:@"115.28.82.17" onPort:8188];

    
    //登录成功之后再addme,取id，
    if ([BCHTTPRequest isLogin] == YES) {
        NSLog(@"yanpeixian");
        NSDictionary * hello = @{@"user_id": [BCHTTPRequest getUserId]};
        [self.socketIO sendEvent:@"addme" withData:hello];
        
    }
    [self ReceiveTheOfflineMessageWithUserId:[BCHTTPRequest getUserId]];
    
}



//显示右侧栏目
- (void)sendMessage
{
    NSDictionary * chat = @{@"msgfrom":[BCHTTPRequest getUserId],@"msgto":@"1000011",@"msgcontent":@"yanpeixian"};
    
    NSLog(@"messagedata is %@",chat);
    
    [self.socketIO sendEvent:@"sendchat" withData:chat];
}


//***********************
//发送私聊信息    【faceBook 项目】
//***********************
- (void)sendMessageTargetID:(NSString *)targetID withContent:(NSString *)content andMessageType:(NSString*)msgtype andTimeLength:(NSString*)timelength andWithMessageWhereType:(NSString *)messageWhereType andWhereID:(NSString *)messageWhereid WithToLogo:(NSString *)toLogo WithTargetName:(NSString *)targetname
{
    NSString * currentDate = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]*1000];
     
    NSString *whereIdType = [[NSString alloc]init];
    NSString *eventStr = [[NSString alloc]init];
    if ([messageWhereType intValue]==0) {
        whereIdType = @"institution_id";
        eventStr = @"sendInstitutionChat";
    }else if([messageWhereType intValue]==1)
    {
        whereIdType = @"department_id";
        eventStr = @"sendDepartmentChat";
    }else if([messageWhereType intValue]==2)
    {
        whereIdType = @"theme_id";
        eventStr = @"sendThemeChat";
    }else if([messageWhereType intValue]==3)
    {
        whereIdType = @"other_id";
        eventStr = @"sendChat";
    }

    
    NSDictionary * chat = @{@"user_id":[BCHTTPRequest getUserId],@"target_id":targetID,@"content":content,@"user_logo":[BCHTTPRequest getUserLogo],@"message_type":msgtype,@"voice_length":timelength,@"messageDate":@"",@"user_name":[BCHTTPRequest getUserName],@"MessageWhereType":messageWhereType,whereIdType:messageWhereid,@"to_logo":toLogo,@"target_name":targetname};
    
    
    NSLog(@"messagedata is %@",chat);
    
    [self.socketIO sendEvent:eventStr withData:chat];
}

//***************************
//发送群聊消息    【faceBook 项目】
//***************************
- (void)sendGroupMessageTargetID:(NSString *)targetID withContent:(NSString *)content andMessageType:(NSString*)msgtype andTimeLength:(NSString*)timelength andWithMessageWhereType:(NSString *)messageWhereType andWhereID:(NSString *)messageWhereid WithtoLogo:(NSString *)toLogo WithTargetName:(NSString *)targetname
{
    NSString * currentDate = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]*1000];
    
    NSString *whereIdType = [[NSString alloc]init];
    NSString *groupEventStr = [[NSString alloc]init];
    if ([messageWhereType intValue]==0) {
        whereIdType = @"institution_id";
        groupEventStr = @"sendInstitutionGroup";
    }else if([messageWhereType intValue]==1)
    {
        whereIdType = @"department_id";
        groupEventStr = @"sendDepartmentGroup";
    }else if([messageWhereType intValue]==2)
    {
        whereIdType = @"theme_id";
        groupEventStr = @"sendThemeGroup";
    }else if([messageWhereType intValue]==3)
    {
        whereIdType = @"other_id";
        groupEventStr = @"sendGroup";
    }


    
    NSDictionary * chat = @{@"user_id":[BCHTTPRequest getUserId],@"target_id":targetID,@"content":content,@"user_logo":[BCHTTPRequest getUserLogo],@"message_type":msgtype,@"voice_length":timelength,@"messageDate":@"",@"user_name":[BCHTTPRequest getUserName],@"MessageWhereType":messageWhereType,whereIdType:messageWhereid,@"to_logo":toLogo,@"target_name":targetname};
    
    NSLog(@"group messagedata is %@",chat);
    
    [self.socketIO sendEvent:groupEventStr withData:chat];
}

////发送通知--群聊添加成员
//- (void)sendAddGroupNotificationWithGroupId:(NSString*)groupid UserId:(NSString*)userid Users:(NSString*)users
//{
//    NSDictionary * addGroupDict = @{@"userId":[BCHTTPRequest getUserId],@"users":users,@"groupId":groupid};
//    NSLog(@"add group notification is %@",addGroupDict);
//    
//    [self.socketIO sendEvent:@"adduser" withData:addGroupDict];
//}

#pragma mark -
#pragma mark SocketIO Delegate

- (void) socketIODidConnect:(SocketIO *)socket
{
    NSLog(@"Socket connect");
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    appDelegate.stateLabel.hidden = YES;
    
}
- (void) socketIODidDisconnect:(SocketIO *)socket disconnectedWithError:(NSError *)error
{
    NSLog(@"Socket disconnect!");
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    appDelegate.stateLabel.hidden = NO;
//    appDelegate.stateLabel.text = @"网络不给力，加载中...";
    [self connect];
}

- (void) socketIO:(SocketIO *)socket onError:(NSError *)error
{
    NSLog(@"Socket onError");
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    appDelegate.stateLabel.hidden = NO;
//    appDelegate.stateLabel.text = @"网络不给力，加载中...";
    [self connect];
}




- (void) socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet
{
    
    NSLog(@"recevive is %@",packet.name);
    
//********************
//1.  接收私聊消息
//**********************
    //机构私聊
    if ([packet.name isEqualToString:@"transmitInstitutionChat"]) {
        
        NSDictionary * stringData = (NSDictionary *) [NSJSONSerialization JSONObjectWithData:[packet.data dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:NULL];
        NSDictionary * messageData = [[stringData objectForKey:@"args"] objectAtIndex:0];
        NSLog(@"messageData is %@",messageData);
        
        //防止丢包事件**************
        NSDictionary * hello = @{@"dataId":[messageData objectForKey:@"dataId"]};
        [self.socketIO sendEvent:@"RemoveInstitutionOffline" withData:hello];
        //******************
        
        if ([((AppDelegate *)[[UIApplication sharedApplication]delegate]).myTimer isValid]) {
            NSLog(@"大大大大");
            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            //localNotification.alertAction = @"Ok";
            localNotification.soundName= UILocalNotificationDefaultSoundName;
            localNotification.alertBody = [NSString stringWithFormat:@"你收到:%@ 的一条新消息",[messageData objectForKey:@"user_name"]];
            
            [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
        }else {
           
             //   [self playSound];
            

        }

        //数据库保存私聊信息
        [self saveMessageToDB:messageData andChatType:0 WithMessageWhereType:@"transmitInstitutionChat"];
        
    }else if ([packet.name isEqualToString:@"transmitDepartmentChat"]) //条线私聊
    {
        NSDictionary * stringData = (NSDictionary *) [NSJSONSerialization JSONObjectWithData:[packet.data dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:NULL];
        NSDictionary * messageData = [[stringData objectForKey:@"args"] objectAtIndex:0];
        NSLog(@"messageData is %@",messageData);
        
        //防止丢包事件**************
        NSDictionary * hello = @{@"dataId":[messageData objectForKey:@"dataId"]};
        [self.socketIO sendEvent:@"RemoveDepartmentOffline" withData:hello];
        //******************

        
        if ([((AppDelegate *)[[UIApplication sharedApplication]delegate]).myTimer isValid]) {
            NSLog(@"大大大大");
            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            //localNotification.alertAction = @"Ok";
            localNotification.soundName= UILocalNotificationDefaultSoundName;
            localNotification.alertBody = [NSString stringWithFormat:@"你收到:%@ 的一条新消息",[messageData objectForKey:@"user_name"]];
            
            [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
        }else {
           
               // [self playSound];
            

        }
        
        //数据库保存私聊信息
        [self saveMessageToDB:messageData andChatType:0 WithMessageWhereType:@"transmitDepartmentChat"];
        
    }else if ([packet.name isEqualToString:@"transmitThemeChat"]) //主题私聊
    {
        NSDictionary * stringData = (NSDictionary *) [NSJSONSerialization JSONObjectWithData:[packet.data dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:NULL];
        NSDictionary * messageData = [[stringData objectForKey:@"args"] objectAtIndex:0];
        NSLog(@"messageData is %@",messageData);
        //防止丢包事件**************
        NSDictionary * hello = @{@"dataId":[messageData objectForKey:@"dataId"]};
        [self.socketIO sendEvent:@"RemoveThemeOffline" withData:hello];
        //******************

        if ([((AppDelegate *)[[UIApplication sharedApplication]delegate]).myTimer isValid]) {
            NSLog(@"大大大大");
            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            //localNotification.alertAction = @"Ok";
            localNotification.soundName= UILocalNotificationDefaultSoundName;
            localNotification.alertBody = [NSString stringWithFormat:@"你收到:%@ 的一条新消息",[messageData objectForKey:@"user_name"]];
            
            [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
        }else {
            
               // [self playSound];
            

        }
        
        //数据库保存私聊信息
        [self saveMessageToDB:messageData andChatType:0 WithMessageWhereType:@"transmitThemeChat"];
        
    }else if ([packet.name isEqualToString:@"transmitChat"]) //第四种私聊
    {
        NSLog(@"第四种小苹果🍎1");
        NSDictionary * stringData = (NSDictionary *) [NSJSONSerialization JSONObjectWithData:[packet.data dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:NULL];
         NSLog(@"第四种🍎Data is %@",stringData);
        NSDictionary * messageData = [[stringData objectForKey:@"args"] objectAtIndex:0];
        NSLog(@"第四种 messageData is %@",messageData);
        
        //防止丢包事件**************
        NSDictionary * hello = @{@"dataId":[messageData objectForKey:@"dataId"]};
        [self.socketIO sendEvent:@"RemoveOffline" withData:hello];
        //******************
        PrivateChatMessagesDB * privateChat = [[PrivateChatMessagesDB alloc] init];
        [privateChat createDataBase];
        if ([privateChat isHaveTheMessageWithGroupID:[messageData objectForKey:@"target_id"] andMessageWhereType:[messageData objectForKey:@"MessageWhereType"] andMessageDate:[messageData objectForKey:@"message_date"]]==NO) {
            
            if ([((AppDelegate *)[[UIApplication sharedApplication]delegate]).myTimer isValid]) {
                NSLog(@"大大大大");
                UILocalNotification *localNotification = [[UILocalNotification alloc] init];
                //localNotification.alertAction = @"Ok";
                localNotification.soundName= UILocalNotificationDefaultSoundName;
                localNotification.alertBody = [NSString stringWithFormat:@"你收到:%@ 的一条新消息",[messageData objectForKey:@"user_name"]];
                
                [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
            }else {
                
//                [self playSound];
                
                
            }
            
            //数据库保存私聊信息
            [self saveMessageToDB:messageData andChatType:0 WithMessageWhereType:@"transmitChat"];

        }
        
    }

//******************************
//2. 接收群聊消息
//******************************
    //机构群聊
    if ([packet.name isEqualToString:@"transmitInstitutionGroup"]) {
        NSDictionary * stringData = (NSDictionary *) [NSJSONSerialization JSONObjectWithData:[packet.data dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:NULL];
        NSDictionary * messageData = [[stringData objectForKey:@"args"] objectAtIndex:0];
        NSLog(@"messageData1111 is %@",messageData);
        
        if ([[messageData objectForKey:@"user_id"] isEqualToString:[BCHTTPRequest getUserId]] == YES) {
            //自己发的就不显示了
            
        }else {
            PrivateChatMessagesDB * privateChat = [[PrivateChatMessagesDB alloc] init];
            [privateChat createDataBase];
            if ([privateChat isHaveTheMessageWithGroupID:[messageData objectForKey:@"target_id"] andMessageWhereType:[messageData objectForKey:@"MessageWhereType"] andMessageDate:[messageData objectForKey:@"message_date"]]==NO) {
                //数据库保存私聊信息
                if ([((AppDelegate *)[[UIApplication sharedApplication]delegate]).myTimer isValid]) {
                    NSLog(@"大大大大");
                    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
                    //localNotification.alertAction = @"Ok";
                    localNotification.soundName= UILocalNotificationDefaultSoundName;
                    NSLog(@"全部群信息%@",messageData);
                    
                    //防止丢包事件**************
                    NSDictionary * hello = @{@"dataId":[messageData objectForKey:@"dataId"]};
                    [self.socketIO sendEvent:@"RemoveInstitutionOffline" withData:hello];
                    //******************
                    
                    
                    localNotification.alertBody = [NSString stringWithFormat:@"你收到:%@ 的一条群消息",[messageData objectForKey:@"user_name"]];
                    // localNotification.alertBody = [NSString stringWithFormat:@"你收到:%@ 的一条群消息",messageData ];
                    
                    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
                }else {
                    //                //设置【如果群新消息要通知执行playSound方法】target
                    //                groupNotice = [[GroupNotice alloc] init];
                    //                [groupNotice createDataBase];
                    //                obj = [groupNotice getAllRemindStyleWithGid:[messageData objectForKey:@"target"]];
                    //
                    //                if ([obj.isNewMessageRemind isEqualToString:@"1"]) {
                    //[self playSound];
                    //                }
                    
                }
                
                [self saveMessageToDB:messageData andChatType:1 WithMessageWhereType:@"transmitInstitutionGroup"];
                
            }
            
            
        }

    }else if ([packet.name isEqualToString:@"transmitDepartmentGroup"])   //条线群聊消息
    {
        NSDictionary * stringData = (NSDictionary *) [NSJSONSerialization JSONObjectWithData:[packet.data dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:NULL];
        NSDictionary * messageData = [[stringData objectForKey:@"args"] objectAtIndex:0];
        NSLog(@"messageData1111 is %@",messageData);
        
        if ([[messageData objectForKey:@"user_id"] isEqualToString:[BCHTTPRequest getUserId]] == YES) {
            //自己发的就不显示了
            
        }else {
            PrivateChatMessagesDB * privateChat = [[PrivateChatMessagesDB alloc] init];
            [privateChat createDataBase];
            if ([privateChat isHaveTheMessageWithGroupID:[messageData objectForKey:@"target_id"] andMessageWhereType:[messageData objectForKey:@"MessageWhereType"] andMessageDate:[messageData objectForKey:@"message_date"]]==NO) {
                
                //数据库保存私聊信息
                if ([((AppDelegate *)[[UIApplication sharedApplication]delegate]).myTimer isValid]) {
                    NSLog(@"大大大大");
                    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
                    //localNotification.alertAction = @"Ok";
                    localNotification.soundName= UILocalNotificationDefaultSoundName;
                    NSLog(@"全部群信息%@",messageData);
                    
                    //防止丢包事件**************
                    NSDictionary * hello = @{@"dataId":[messageData objectForKey:@"dataId"]};
                    [self.socketIO sendEvent:@"RemoveDepartmentOffline" withData:hello];
                    //******************
                    
                    localNotification.alertBody = [NSString stringWithFormat:@"你收到:%@ 的一条群消息",[messageData objectForKey:@"user_name"]];
                    // localNotification.alertBody = [NSString stringWithFormat:@"你收到:%@ 的一条群消息",messageData ];
                    
                    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
                }else {
                    //                //设置【如果群新消息要通知执行playSound方法】target
                    //                groupNotice = [[GroupNotice alloc] init];
                    //                [groupNotice createDataBase];
                    //                obj = [groupNotice getAllRemindStyleWithGid:[messageData objectForKey:@"target"]];
                    
                    //                if ([obj.isNewMessageRemind isEqualToString:@"1"]) {
                    //[self playSound];
                    //                }
                    
                }
                
                [self saveMessageToDB:messageData andChatType:1 WithMessageWhereType:@"transmitDepartmentGroup"];
                
            }
            
            
        }

    }else if ([packet.name isEqualToString:@"transmitThemeGroup"])    //主题群消息
    {
        NSDictionary * stringData = (NSDictionary *) [NSJSONSerialization JSONObjectWithData:[packet.data dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:NULL];
        NSDictionary * messageData = [[stringData objectForKey:@"args"] objectAtIndex:0];
        NSLog(@"messageData1111 is %@",messageData);
        
        if ([[messageData objectForKey:@"user_id"] isEqualToString:[BCHTTPRequest getUserId]] == YES) {
            //自己发的就不显示了
            
        }else {
            PrivateChatMessagesDB * privateChat = [[PrivateChatMessagesDB alloc] init];
            [privateChat createDataBase];
             if ([privateChat isHaveTheMessageWithGroupID:[messageData objectForKey:@"target_id"] andMessageWhereType:[messageData objectForKey:@"MessageWhereType"] andMessageDate:[messageData objectForKey:@"message_date"]]==NO) {
                 
                 //数据库保存私聊信息
                 if ([((AppDelegate *)[[UIApplication sharedApplication]delegate]).myTimer isValid]) {
                     NSLog(@"大大大大");
                     UILocalNotification *localNotification = [[UILocalNotification alloc] init];
                     //localNotification.alertAction = @"Ok";
                     localNotification.soundName= UILocalNotificationDefaultSoundName;
                     NSLog(@"全部群信息%@",messageData);
                     
                     //防止丢包事件**************
                     NSDictionary * hello = @{@"dataId":[messageData objectForKey:@"dataId"]};
                     [self.socketIO sendEvent:@"RemoveThemeOffline" withData:hello];
                     //******************
                     
                     localNotification.alertBody = [NSString stringWithFormat:@"你收到:%@ 的一条群消息",[messageData objectForKey:@"user_name"]];
                     // localNotification.alertBody = [NSString stringWithFormat:@"你收到:%@ 的一条群消息",messageData ];
                     
                     [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
                 }else {
                     //                //设置【如果群新消息要通知执行playSound方法】target
                     //                groupNotice = [[GroupNotice alloc] init];
                     //                [groupNotice createDataBase];
                     //                obj = [groupNotice getAllRemindStyleWithGid:[messageData objectForKey:@"target"]];
                     //
                     //                if ([obj.isNewMessageRemind isEqualToString:@"1"]) {
                    // [self playSound];
                     //                }
                     
                 }
                 
                 [self saveMessageToDB:messageData andChatType:1 WithMessageWhereType:@"transmitThemeGroup"];
             }
            
            
        }

    }else if ([packet.name isEqualToString:@"transmitGroup"])    //第四种群消息
    {
        NSDictionary * stringData = (NSDictionary *) [NSJSONSerialization JSONObjectWithData:[packet.data dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:NULL];
        NSDictionary * messageData = [[stringData objectForKey:@"args"] objectAtIndex:0];
        NSLog(@"messageData1111 is %@",messageData);
        
        if ([[messageData objectForKey:@"user_id"] isEqualToString:[BCHTTPRequest getUserId]] == YES) {
            //自己发的就不显示了
            
        }else {
            PrivateChatMessagesDB * privateChat = [[PrivateChatMessagesDB alloc] init];
            [privateChat createDataBase];
            if ([privateChat isHaveTheMessageWithGroupID:[messageData objectForKey:@"target_id"] andMessageWhereType:[messageData objectForKey:@"MessageWhereType"] andMessageDate:[messageData objectForKey:@"message_date"]]==NO) {
                
                //数据库保存私聊信息
                if ([((AppDelegate *)[[UIApplication sharedApplication]delegate]).myTimer isValid]) {
                    NSLog(@"大大大大");
                    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
                    //localNotification.alertAction = @"Ok";
                    localNotification.soundName= UILocalNotificationDefaultSoundName;
                    NSLog(@"全部群信息%@",messageData);
                    
                    //防止丢包事件**************
                    NSDictionary * hello = @{@"dataId":[messageData objectForKey:@"dataId"]};
                    [self.socketIO sendEvent:@"RemoveOffline" withData:hello];
                    //******************
                    
                    
                    localNotification.alertBody = [NSString stringWithFormat:@"你收到:%@ 的一条群消息",[messageData objectForKey:@"user_name"]];
                    // localNotification.alertBody = [NSString stringWithFormat:@"你收到:%@ 的一条群消息",messageData ];
                    
                    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
                }else {
                    //                //设置【如果群新消息要通知执行playSound方法】target
                    //                groupNotice = [[GroupNotice alloc] init];
                    //                [groupNotice createDataBase];
                    //                obj = [groupNotice getAllRemindStyleWithGid:[messageData objectForKey:@"target"]];
                    //
                    //                if ([obj.isNewMessageRemind isEqualToString:@"1"]) {
                   // [self playSound];
                    //                }
                    
                }
                
                [self saveMessageToDB:messageData andChatType:1 WithMessageWhereType:@"transmitGroup"];
                
            }
           
            
        }
        
    }

//**************************
//3. 接受离线消息
//**************************
    //机构离线
    if ([packet.name isEqualToString:@"institutionOfflineMessage"]) {
        NSDictionary * stringData = (NSDictionary *) [NSJSONSerialization JSONObjectWithData:[packet.data dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:NULL];
        NSDictionary * messageData = [[stringData objectForKey:@"args"] objectAtIndex:0];
        NSLog(@"-----%@",messageData);
        //
        if ([messageData[@"flag"] integerValue] == 1) {
            NSLog(@"离线消息");
            
            //数据库保存离线信息
            for (int q = 0; q < [messageData[@"data"] count]; q++) {
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:200];
                dic = messageData[@"data"][q];
                NSString *style = [[NSString alloc]init];
                style = dic[@"type"];
                
                NSMutableDictionary *diction = [[NSMutableDictionary alloc]initWithCapacity:300];
                
                [diction setValue:dic[@"user_id"] forKey:@"user_id"];
                [diction setValue:dic[@"owner_id"] forKey:@"owner_id"];
                [diction setValue:dic[@"content"] forKey:@"content"];
                [diction setValue:dic[@"target_id"] forKey:@"target_id"];
                
                [diction setValue:dic[@"user_name"] forKey:@"user_name"];
                [diction setValue:dic[@"user_logo"] forKey:@"user_logo"];
                
                [diction setValue:dic[@"message_type"] forKey:@"message_type"];
                [diction setValue:dic[@"voice_length"] forKey:@"voice_length"];
                [diction setValue:dic[@"message_date"] forKey:@"message_date"];
                [diction setValue:dic[@"type"] forKey:@"type"];
                [diction setValue:dic[@"institution_id"] forKey:@"institution_id"];
                //@"target_name":targetname
                [diction setValue:dic[@"target_name"] forKey:@"target_name"];
                [diction setValue:dic[@"institutionOfflineMessage"] forKey:@"messageWhereType"];
                
                
                NSLog(@"离线消息%@",diction);
                isOffLine = @"off";
                
                if ([style isEqualToString:@"users"]) {
                    [self saveMessageToDB:diction andChatType:0 WithMessageWhereType:@"institutionOfflineMessage"];
                 //   [self playSound];
                }else
                {
                    [self saveMessageToDB:diction andChatType:1 WithMessageWhereType:@"institutionOfflineMessage"];
                //    [self playSound];
                }
                
                
            }
            
        }
        
        
    }else if ([packet.name isEqualToString:@"departmentOfflineMessage"])    //条线离线消息
    {
        
        NSDictionary * stringData = (NSDictionary *) [NSJSONSerialization JSONObjectWithData:[packet.data dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:NULL];
        NSDictionary * messageData = [[stringData objectForKey:@"args"] objectAtIndex:0];
        NSLog(@"-----%@",messageData);
        //
 //       if ([messageData[@"flag"] integerValue] == 1) {
            NSLog(@"离线消息");
            
            //数据库保存离线信息
            for (int q = 0; q < [messageData[@"data"] count]; q++) {
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:200];
                dic = messageData[@"data"][q];
                NSString *style = [[NSString alloc]init];
                style = dic[@"type"];
                
                NSMutableDictionary *diction = [[NSMutableDictionary alloc]initWithCapacity:300];
                
                [diction setValue:dic[@"user_id"] forKey:@"user_id"];
                [diction setValue:dic[@"owner_id"] forKey:@"owner_id"];
                [diction setValue:dic[@"content"] forKey:@"content"];
                [diction setValue:dic[@"target_id"] forKey:@"target_id"];
                
                [diction setValue:dic[@"user_name"] forKey:@"user_name"];
                [diction setValue:dic[@"user_logo"] forKey:@"user_logo"];
                
                [diction setValue:dic[@"message_type"] forKey:@"message_type"];
                [diction setValue:dic[@"voice_length"] forKey:@"voice_length"];
                [diction setValue:dic[@"message_date"] forKey:@"message_date"];
                [diction setValue:dic[@"type"] forKey:@"type"];
                [diction setValue:dic[@"department_id"] forKey:@"department_id"];
                [diction setValue:dic[@"target_name"] forKey:@"target_name"];
                [diction setValue:dic[@"departmentOfflineMessage"] forKey:@"messageWhereType"];
                
                
                NSLog(@"离线消息%@",diction);
                isOffLine = @"off";
                
                if ([style isEqualToString:@"users"]) {
                    [self saveMessageToDB:diction andChatType:0 WithMessageWhereType:@"departmentOfflineMessage"];
                   // [self playSound];
                }else
                {
                    [self saveMessageToDB:diction andChatType:1 WithMessageWhereType:@"departmentOfflineMessage"];
                  //  [self playSound];
                }
                
                
            }
            
//        }

        
    }else if ([packet.name isEqualToString:@"themeOfflineMessage"])    //主题离线消息
    {
        
        NSDictionary * stringData = (NSDictionary *) [NSJSONSerialization JSONObjectWithData:[packet.data dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:NULL];
        NSDictionary * messageData = [[stringData objectForKey:@"args"] objectAtIndex:0];
        NSLog(@"-----%@",messageData);
        //
//        if ([messageData[@"flag"] integerValue] == 1) {
            NSLog(@"离线消息");
            
            //数据库保存离线信息
            for (int q = 0; q < [messageData[@"data"] count]; q++) {
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:200];
                dic = messageData[@"data"][q];
                NSString *style = [[NSString alloc]init];
                style = dic[@"type"];
                
                NSMutableDictionary *diction = [[NSMutableDictionary alloc]initWithCapacity:300];
                
                [diction setValue:dic[@"user_id"] forKey:@"user_id"];
                [diction setValue:dic[@"owner_id"] forKey:@"owner_id"];
                [diction setValue:dic[@"content"] forKey:@"content"];
                [diction setValue:dic[@"target_id"] forKey:@"target_id"];
                
                [diction setValue:dic[@"user_name"] forKey:@"user_name"];
                [diction setValue:dic[@"user_logo"] forKey:@"user_logo"];
                
                [diction setValue:dic[@"message_type"] forKey:@"message_type"];
                [diction setValue:dic[@"voice_length"] forKey:@"voice_length"];
                [diction setValue:dic[@"message_date"] forKey:@"message_date"];
                [diction setValue:dic[@"type"] forKey:@"type"];
                [diction setValue:dic[@"theme_id"] forKey:@"theme_id"];
                [diction setValue:dic[@"target_name"] forKey:@"target_name"];
                [diction setValue:dic[@"themeOfflineMessage"] forKey:@"messageWhereType"];
                
                
                NSLog(@"离线消息-=-=-=-=-=-%@",diction);
                isOffLine = @"off";
                
                if ([style isEqualToString:@"users"]) {
                    [self saveMessageToDB:diction andChatType:0 WithMessageWhereType:@"themeOfflineMessage"];
                //    [self playSound];
                }else
                {
                    [self saveMessageToDB:diction andChatType:1 WithMessageWhereType:@"themeOfflineMessage"];
               //     [self playSound];
                }
                
                
            }
            
    }else if ([packet.name isEqualToString:@"offlineMessage"])    //第四种离线消息
    {
        NSLog(@"第四种小苹果🍎2");
        NSDictionary * stringData = (NSDictionary *) [NSJSONSerialization JSONObjectWithData:[packet.data dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:NULL];
        NSDictionary * messageData = [[stringData objectForKey:@"args"] objectAtIndex:0];
        NSLog(@"-----%@",messageData);
        //
        //        if ([messageData[@"flag"] integerValue] == 1) {
        NSLog(@"离线消息");
        
        //数据库保存离线信息
        for (int q = 0; q < [messageData[@"data"] count]; q++) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:200];
            dic = messageData[@"data"][q];
            NSString *style = [[NSString alloc]init];
            style = dic[@"type"];
            
//            PrivateChatMessagesDB * privateChat = [[PrivateChatMessagesDB alloc] init];
//            [privateChat createDataBase];
//            if ([privateChat isHaveTheMessageWithGroupID:[dic objectForKey:@"target_id"] andMessageWhereType:[dic objectForKey:@"MessageWhereType"] andMessageDate:[dic objectForKey:@"message_date"]]==NO) {
            
                
                NSMutableDictionary *diction = [[NSMutableDictionary alloc]initWithCapacity:300];
                
                [diction setValue:dic[@"user_id"] forKey:@"user_id"];
                [diction setValue:dic[@"owner_id"] forKey:@"owner_id"];
                [diction setValue:dic[@"content"] forKey:@"content"];
                [diction setValue:dic[@"target_id"] forKey:@"target_id"];
                
                [diction setValue:dic[@"user_name"] forKey:@"user_name"];
                [diction setValue:dic[@"user_logo"] forKey:@"user_logo"];
                
                [diction setValue:dic[@"message_type"] forKey:@"message_type"];
                [diction setValue:dic[@"voice_length"] forKey:@"voice_length"];
                [diction setValue:dic[@"message_date"] forKey:@"message_date"];
                [diction setValue:dic[@"type"] forKey:@"type"];
                [diction setValue:dic[@"other_id"] forKey:@"other_id"];
                [diction setValue:dic[@"target_name"] forKey:@"target_name"];
                [diction setValue:dic[@"offlineMessage"] forKey:@"messageWhereType"];
                
                
                NSLog(@"离线消息-=-=-=-=-=-%@",diction);
                isOffLine = @"off";
                
                
                
                if ([style isEqualToString:@"users"]) {
                    [self saveMessageToDB:diction andChatType:0 WithMessageWhereType:@"offlineMessage"];
                    NSLog(@"次奥");
                 //   [self playSound];
                }else
                {
                    [self saveMessageToDB:diction andChatType:1 WithMessageWhereType:@"offlineMessage"];
                //    [self playSound];
                }

                
 //           }

          
            
            
        }
        
    }

    
    
 //   }

}

-(void) playSound

{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"shake_sound_male" ofType:@"caf"];
    if (path) {
        //注册声音到系统
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&shake_sound_male_id);
       // AudioServicesPlaySystemSound(shake_sound_male_id);
        //        AudioServicesPlaySystemSound(shake_sound_male_id);//如果无法再下面播放，可以尝试在此播放
    }
    
    //根据设置播放声音或震动
    groupNotice = [[GroupNotice alloc] init];
    [groupNotice createDataBase];
    obj = [groupNotice getAllRemindStyleWithGid:@"1"];
    
    if ([obj.isNewMessageRemind isEqualToString:@"1"]) {
        AudioServicesPlaySystemSound(shake_sound_male_id);   //播放注册的声音，（此句代码，可以在本类中的任意位置调用，不限于本方法中）
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);   //让手机震动
        

    }else
    {
         AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);   //让手机震动
    }
    
    
    
   // AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);   //让手机震动
}
//
- (void)getAllUsers
{
    [self.socketIO sendEvent:@"setallusers" withData:nil];

}

//**********************************************
// 发送/接收的消息存入数据库
//传0为私聊，传1为群聊
//messageWhereType【消息来源0:机构 1:条线 2:主题】
//**********************************************
- (void)saveMessageToDB:(NSDictionary*)msgDict andChatType:(NSInteger)chatType WithMessageWhereType:(NSString *)messageWhereType
{
    NSLog(@"fengshaohui %@",msgDict);
    NSLog(@"fengshaohui chatType is %i",chatType);
    NSLog(@"fengshaohui 部门 is %@",messageWhereType);
    MessageObject * mesobj = [[MessageObject alloc] init];
    
    //最近联系人
    FMDBRecentlyContactsObject * recentlyObj = [[FMDBRecentlyContactsObject alloc] init];//
    recentlyObj.messageChatType = [NSNumber numberWithInt:chatType]; //
    
    
    //私聊
    if (chatType == 0) {
        
        mesobj.messageChatType = [NSNumber numberWithInt:chatType];
        mesobj.messageFromName = [msgDict objectForKey:@"user_name"];
       // mesobj.messageDate = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
        mesobj.messageDate = [msgDict objectForKey:@"message_date"];
        mesobj.messageFrom = [msgDict objectForKey:@"user_id"];
        mesobj.timelength = [msgDict objectForKey:@"voice_length"];
        mesobj.content = [msgDict objectForKey:@"content"];
        mesobj.groupNames = [msgDict objectForKey:@"target_name"];
        
        mesobj.messageTo = [msgDict objectForKey:@"target_id"];
//**********************************************最近联系人****************
        recentlyObj.messageFaceId = [msgDict objectForKey:@"user_id"];
        recentlyObj.messageFaceName = [msgDict objectForKey:@"user_name"];
//**************************************
        if ([msgDict objectForKey:@"user_logo"] == nil || [[msgDict objectForKey:@"user_logo"] isEqualToString:@""]) {
            //没有头像
            mesobj.headImage = [UIImage imageNamed:@"icon@2x.png"];
            recentlyObj.faceHeadLogo = @"";
            
        }else {
            NSData * iamgeDate = [NSData dataWithContentsOfURL:[NSURL URLWithString:[msgDict objectForKey:@"user_logo"]]];
            mesobj.headImage = [UIImage imageWithData:iamgeDate];
            recentlyObj.faceHeadLogo = msgDict[@"user_logo"];
        }

        //机构
        if ([messageWhereType isEqualToString:@"transmitInstitutionChat"]||[messageWhereType isEqualToString:@"institutionOfflineMessage"]) {
            //机构的私聊消息(包括离线消息)
            mesobj.messageWhereType = [NSString stringWithFormat:@"0"];
            mesobj.messageWhereId = [msgDict objectForKey:@"institution_id"];
            
        }else if ([messageWhereType isEqualToString:@"transmitDepartmentChat"]||[messageWhereType isEqualToString:@"departmentOfflineMessage"]) //条线
        {
            //条线的私聊消息(包括离线消息)
            mesobj.messageWhereType = [NSString stringWithFormat:@"1"];
            mesobj.messageWhereId = [msgDict objectForKey:@"department_id"];
            
        }else if ([messageWhereType isEqualToString:@"transmitThemeChat"]||[messageWhereType isEqualToString:@"themeOfflineMessage"])  //主题
        {
            //主题的私聊消息(包括离线消息)
            mesobj.messageWhereType = [NSString stringWithFormat:@"2"];
            mesobj.messageWhereId = [msgDict objectForKey:@"theme_id"];
        }else if ([messageWhereType isEqualToString:@"transmitChat"]||[messageWhereType isEqualToString:@"offlineMessage"])  //第四种
        {
            //主题的私聊消息(包括离线消息)
            mesobj.messageWhereType = [NSString stringWithFormat:@"3"];
            mesobj.messageWhereId = [msgDict objectForKey:@"other_id"];
            
            recentlyObj.messageWhereType = [NSString stringWithFormat:@"3"];
            recentlyObj.messageWhereId = [msgDict objectForKey:@"other_id"];
        }

        
    }else if (chatType == 1) //群聊
    {
        mesobj.messageChatType = [NSNumber numberWithInt:chatType];
        mesobj.messageFromName = [msgDict objectForKey:@"user_name"];
        // mesobj.messageDate = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
        mesobj.messageDate = [msgDict objectForKey:@"message_date"];
        mesobj.messageFrom = [msgDict objectForKey:@"user_id"];
        mesobj.timelength = [msgDict objectForKey:@"voice_length"];
        mesobj.content = [msgDict objectForKey:@"content"];
        mesobj.groupNames = [msgDict objectForKey:@"target_name"];
        mesobj.messageTo = [msgDict objectForKey:@"target_id"];
        
//************************************
        recentlyObj.messageFaceId = [msgDict objectForKey:@"target_id"];
        recentlyObj.messageFaceName = [msgDict objectForKey:@"target_name"];
//***************************************
        if ([msgDict objectForKey:@"user_logo"] == nil || [[msgDict objectForKey:@"user_logo"] isEqualToString:@""]) {
            //没有头像
            mesobj.headImage = [UIImage imageNamed:@"icon@2x.png"];
            recentlyObj.faceHeadLogo = @"";

        }else {
            NSData * iamgeDate = [NSData dataWithContentsOfURL:[NSURL URLWithString:[msgDict objectForKey:@"user_logo"]]];
            mesobj.headImage = [UIImage imageWithData:iamgeDate];
            recentlyObj.faceHeadLogo = msgDict[@"user_logo"];

        }

        //机构
        if ([messageWhereType isEqualToString:@"transmitInstitutionGroup"]||[messageWhereType isEqualToString:@"institutionOfflineMessage"]) {
            //机构的群聊消息(包括离线消息)
            mesobj.messageWhereType = [NSString stringWithFormat:@"0"];
            mesobj.messageWhereId = [msgDict objectForKey:@"institution_id"];
            
            recentlyObj.messageWhereType = [NSString stringWithFormat:@"0"];
            recentlyObj.messageWhereId = [msgDict objectForKey:@"institution_id"];
            
        }else if ([messageWhereType isEqualToString:@"transmitDepartmentGroup"]||[messageWhereType isEqualToString:@"departmentOfflineMessage"]) //条线
        {
            //条线的群聊消息(包括离线消息)
            mesobj.messageWhereType = [NSString stringWithFormat:@"1"];
            mesobj.messageWhereId = [msgDict objectForKey:@"department_id"];
            
            recentlyObj.messageWhereType = [NSString stringWithFormat:@"1"];
            recentlyObj.messageWhereId = [msgDict objectForKey:@"department_id"];
            
        }else if ([messageWhereType isEqualToString:@"transmitThemeGroup"]||[messageWhereType isEqualToString:@"themeOfflineMessage"])  //主题
        {
            //主题的群聊消息(包括离线消息)
            mesobj.messageWhereType = [NSString stringWithFormat:@"2"];
            mesobj.messageWhereId = [msgDict objectForKey:@"theme_id"];
            
            recentlyObj.messageWhereType = [NSString stringWithFormat:@"2"];
            recentlyObj.messageWhereId = [msgDict objectForKey:@"theme_id"];
            
        }else if ([messageWhereType isEqualToString:@"transmitGroup"]||[messageWhereType isEqualToString:@"offlineMessage"])  //主题
        {
            //主题的私聊消息(包括离线消息)
            mesobj.messageWhereType = [NSString stringWithFormat:@"3"];
            mesobj.messageWhereId = [msgDict objectForKey:@"other_id"];
            
            recentlyObj.messageWhereType = [NSString stringWithFormat:@"3"];
            recentlyObj.messageWhereId = [msgDict objectForKey:@"other_id"];
        }


       
        
    }
    
    //根据chatType判断信息的类型是文本语音还是图片******************
    if ([[msgDict objectForKey:@"message_type"] isEqualToString:@"text"]) {
        //文本
        mesobj.messageCellStyle = [NSNumber numberWithInt:LLMessageCellStyleOther];
        mesobj.messageType = [NSNumber numberWithInt:LLMessageTypePlain];
        
        recentlyObj.messageCellStyle = [NSNumber numberWithInt:LLMessageCellStyleOther];
        recentlyObj.messageType = [NSNumber numberWithInt:LLMessageTypePlain];
        
    }else if ([[msgDict objectForKey:@"message_type"] isEqualToString:@"voice"]) {
        //声音
        mesobj.messageCellStyle = [NSNumber numberWithInt:LLMessageCellStyleOtherWithVoice];
        mesobj.messageType = [NSNumber numberWithInt:LLMessageTypeVoice];
        
        recentlyObj.messageCellStyle = [NSNumber numberWithInt:LLMessageCellStyleOtherWithVoice];
        recentlyObj.messageType = [NSNumber numberWithInt:LLMessageTypeVoice];
        
    }else if ([[msgDict objectForKey:@"message_type"] isEqualToString:@"picture"]) {
        //图片
        mesobj.messageCellStyle = [NSNumber numberWithInt:LLMessageCellStyleOtherWithImage];
        mesobj.messageType = [NSNumber numberWithInt:LLMessageTypeImage];
        
        recentlyObj.messageCellStyle = [NSNumber numberWithInt:LLMessageCellStyleOtherWithImage];
        recentlyObj.messageType = [NSNumber numberWithInt:LLMessageTypeImage];
        
    }else if ([[msgDict objectForKey:@"message_type"] isEqualToString:@"location"]) {
        //地点
        mesobj.messageCellStyle = [NSNumber numberWithInt:LLMessageCellStyleOtherWithLocation];
        mesobj.messageType = [NSNumber numberWithInt:LLMessageTypeLocation];
        
        recentlyObj.messageCellStyle = [NSNumber numberWithInt:LLMessageCellStyleOtherWithLocation];
        recentlyObj.messageType = [NSNumber numberWithInt:LLMessageTypeLocation];
        
    }else if ([[msgDict objectForKey:@"message_type"] isEqualToString:@"vcard"]) {
        //卡片-名片
        mesobj.messageCellStyle = [NSNumber numberWithInt:LLMessageCellStyleOtherWithVCard];
        mesobj.messageType = [NSNumber numberWithInt:LLMessageTypeVCard];
        
        recentlyObj.messageCellStyle = [NSNumber numberWithInt:LLMessageCellStyleOtherWithVCard];
        recentlyObj.messageType = [NSNumber numberWithInt:LLMessageTypeVCard];
        
    }

    
//*****************************************************************************************************************************
//    NSLog(@"yanpeixian is %@",msgDict);
//    NSLog(@"fengshaohui is %i",chatType);
//    
//    MessageObject * mesobj = [[MessageObject alloc] init];
//    mesobj.messageChatType = [NSNumber numberWithInt:chatType];
//    mesobj.messageFromName = [msgDict objectForKey:@"user_name"];
//    mesobj.messageDate = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
//    mesobj.messageFrom = [msgDict objectForKey:@"user_id"];
//    mesobj.timelength = [msgDict objectForKey:@"voice_length"];
//    mesobj.content = [msgDict objectForKey:@"content"];
//    
//    if ([isOffLine isEqualToString:@"off"]) {
//        mesobj.messageTo = [msgDict objectForKey:@"to_id"];
//    }else
//    {
//        mesobj.messageTo = [msgDict objectForKey:@"target_id"];
//    }
//    
//    
//    mesobj.groupNames = [msgDict objectForKey:@"group_name"];
//    
//    
//    //最近联系人
//    FMDBRecentlyContactsObject * recentlyObj = [[FMDBRecentlyContactsObject alloc] init];
//    recentlyObj.messageChatType = [NSNumber numberWithInt:chatType];
//    
//    if (chatType ==0) {
//        recentlyObj.messageFaceId = [msgDict objectForKey:@"user_id"];
//        recentlyObj.messageFaceName = [msgDict objectForKey:@"user_name"];
//        
//        if ([msgDict objectForKey:@"user_logo"] == nil || [[msgDict objectForKey:@"user_logo"] isEqualToString:@""]) {
//            //没有头像
//            mesobj.headImage = [UIImage imageNamed:@"icon@2x.png"];
//            recentlyObj.faceHeadLogo = @"";
//            
//        }else {
//            NSData * iamgeDate = [NSData dataWithContentsOfURL:[NSURL URLWithString:[msgDict objectForKey:@"user_logo"]]];
//            
//            mesobj.headImage = [UIImage imageWithData:iamgeDate];
//            
//            recentlyObj.faceHeadLogo = msgDict[@"user_logo"];
//            
//            
//        }
//        
//        
//        
//    }else if(chatType == 1)
//    {
//        recentlyObj.messageFaceId = [msgDict objectForKey:@"group_id"];
//        recentlyObj.messageFaceName = [msgDict objectForKey:@"group_name"];
//        
//        NSData * iamgeDate = [NSData dataWithContentsOfURL:[NSURL URLWithString:[msgDict objectForKey:@"user_logo"]]];
//        
//        mesobj.headImage = [UIImage imageWithData:iamgeDate];
//        
//        recentlyObj.faceHeadLogo = msgDict[@"user_logo"];
//        
//    }
//    
    recentlyObj.messageDate = [msgDict objectForKey:@"message_date"];
    
    recentlyObj.timelength = [msgDict objectForKey:@"voice_length"];
    recentlyObj.content = [msgDict objectForKey:@"content"];
//    
//    //recentlyObj.faceHeadLogo = [msgDict objectForKey:@"target_id"];
//    //recentlyObj.unReadNumber = [msgDict objectForKey:@"group_name"];
//    
//    
//    
//    
//    //    if ([msgDict objectForKey:@"group_logo"] == nil || [[msgDict objectForKey:@"group_logo"] isEqualToString:@""]) {
//    //
//    //    }else {
//    //        NSLog(@"头像走起%@",msgDict[@"group_logo"]);
//    //
//    //       // NSData * iamgeDate = [NSData dataWithContentsOfURL:[NSURL URLWithString:[msgDict objectForKey:@"group_logo"]]];
//    //
//    //        recentlyObj.faceHeadLogo = msgDict[@"group_logo"];
//    //
//    //
//    //    }
//    
//    
//    //根据chatType判断信息的类型是文本语音还是图片******************
//    if ([[msgDict objectForKey:@"message_type"] isEqualToString:@"text"]) {
//        //文本
//        mesobj.messageCellStyle = [NSNumber numberWithInt:LLMessageCellStyleOther];
//        mesobj.messageType = [NSNumber numberWithInt:LLMessageTypePlain];
//        
//        //用        recentlyObj.messageCellStyle = [NSNumber numberWithInt:LLMessageCellStyleOther];
//        recentlyObj.messageType = [NSNumber numberWithInt:LLMessageTypePlain];
//        
//    }else if ([[msgDict objectForKey:@"message_type"] isEqualToString:@"voice"]) {
//        //声音
//        mesobj.messageCellStyle = [NSNumber numberWithInt:LLMessageCellStyleOtherWithVoice];
//        mesobj.messageType = [NSNumber numberWithInt:LLMessageTypeVoice];
//        
//        //用        recentlyObj.messageCellStyle = [NSNumber numberWithInt:LLMessageCellStyleOtherWithVoice];
//        recentlyObj.messageType = [NSNumber numberWithInt:LLMessageTypeVoice];
//        
//    }else if ([[msgDict objectForKey:@"message_type"] isEqualToString:@"picture"]) {
//        //图片
//        mesobj.messageCellStyle = [NSNumber numberWithInt:LLMessageCellStyleOtherWithImage];
//        mesobj.messageType = [NSNumber numberWithInt:LLMessageTypeImage];
//        
//        //用        recentlyObj.messageCellStyle = [NSNumber numberWithInt:LLMessageCellStyleOtherWithImage];
//        recentlyObj.messageType = [NSNumber numberWithInt:LLMessageTypeImage];
//        
//    }else if ([[msgDict objectForKey:@"message_type"] isEqualToString:@"location"]) {
//        //地点
//        mesobj.messageCellStyle = [NSNumber numberWithInt:LLMessageCellStyleOtherWithLocation];
//        mesobj.messageType = [NSNumber numberWithInt:LLMessageTypeLocation];
//        
//        //用        recentlyObj.messageCellStyle = [NSNumber numberWithInt:LLMessageCellStyleOtherWithLocation];
//        recentlyObj.messageType = [NSNumber numberWithInt:LLMessageTypeLocation];
//        
//    }else if ([[msgDict objectForKey:@"message_type"] isEqualToString:@"vcard"]) {
//        //卡片-名片
//        mesobj.messageCellStyle = [NSNumber numberWithInt:LLMessageCellStyleOtherWithVCard];
//        mesobj.messageType = [NSNumber numberWithInt:LLMessageTypeVCard];
//        
//        //用        recentlyObj.messageCellStyle = [NSNumber numberWithInt:LLMessageCellStyleOtherWithVCard];
//        recentlyObj.messageType = [NSNumber numberWithInt:LLMessageTypeVCard];
//        
//    }
//    
//
    PrivateChatMessagesDB * privateChat = [[PrivateChatMessagesDB alloc] init];
    [privateChat createDataBase];
    if ([privateChat isHaveTheMessageWithGroupID:mesobj.messageTo andMessageWhereType:mesobj.messageWhereType andMessageDate:mesobj.messageDate]==NO) {
        [self playSound];
        [privateChat savePrivateMessageWithMessage:mesobj];
        
        //最近联系人数据库
        RecentlyContactsDB *recentlyContactsDB = [[RecentlyContactsDB alloc]init];
        [recentlyContactsDB createDataBase];
        [recentlyContactsDB saveRecentlyContactsWith:recentlyObj];
        
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:FSHNewMessageNotifaction object:nil];
        
        //发送全局通知--发送通知刷新最近联系人
        //创建通知，刷新最近联系人
        [[NSNotificationCenter defaultCenter] postNotificationName:@"recentlyList" object:nil];

        
    }
    
[[NSNotificationCenter defaultCenter] postNotificationName:FSHNewMessageNotifaction object:nil];

    
}
//接收离线消息
- (void)ReceiveTheOfflineMessageWithUserId:(NSString *)userid
{
    if ([BCHTTPRequest isLogin] == YES) {
        NSLog(@"yanpeixian");
        NSDictionary * hello = @{@"user_id":userid};
        
        [self.socketIO sendEvent:@"getInstitutionOffline" withData:hello];
        [self.socketIO sendEvent:@"getDepartmentOffline" withData:hello];
        [self.socketIO sendEvent:@"getThemeOffline" withData:hello];
        [self.socketIO sendEvent:@"getOffline" withData:hello];
    }

}
//退出群/删除群
- (void)exitTheGroupChatWithUserID:(NSString *)userid GroupID:(NSString *)groupid
{
    NSDictionary *exitGroupDic = @{@"userId": [BCHTTPRequest getUserId],@"groupId":groupid};
    [self.socketIO sendEvent:@"exitgroup" withData:exitGroupDic];
}
@end
