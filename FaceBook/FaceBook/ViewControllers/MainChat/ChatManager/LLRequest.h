//
//  LLRequest.h
//  WechatWall
//
//  Created by 牛方健 on 13-12-31.
//  Copyright (c) 2013年 BloveAmbition. All rights reserved.
//

//1、CheckViewController监听LLRequestRefresh
//2、LoginViewController监听LLRequestLogin @{@"isLogin": @(isLogin)}


@protocol LLRequestDelegate <NSObject>

- (void)obtainAllUsers:(NSArray*)userArr;

@end

#import <Foundation/Foundation.h>

@interface LLRequest : NSObject

@property (assign, nonatomic) id <LLRequestDelegate> delegate;

+ (id) sharedLLRequest;

- (void)connect;


//***********************
//发送私聊信息    【faceBook 项目】
//***********************
- (void)sendMessageTargetID:(NSString *)targetID withContent:(NSString *)content andMessageType:(NSString*)msgtype andTimeLength:(NSString*)timelength andWithMessageWhereType:(NSString *)messageWhereType andWhereID:(NSString *)messageWhereid WithToLogo:(NSString *)toLogo WithTargetName:(NSString *)targetname;


//***************************
//发送群聊消息    【faceBook 项目】
//***************************
- (void)sendGroupMessageTargetID:(NSString *)targetID withContent:(NSString *)content andMessageType:(NSString*)msgtype andTimeLength:(NSString*)timelength andWithMessageWhereType:(NSString *)messageWhereType andWhereID:(NSString *)messageWhereid WithtoLogo:(NSString *)toLogo WithTargetName:(NSString *)targetname;


//***************************
//群聊添加成员    【faceBook 项目】
//***************************
//- (void)sendAddGroupNotificationWithGroupId:(NSString*)groupid UserId:(NSString*)userid Users:(NSString*)users;


//*****************************
//接收离线消息  【faceBook 项目】
//*****************************
- (void)ReceiveTheOfflineMessageWithUserId:(NSString *)userid;

//退出群/删除群
- (void)exitTheGroupChatWithUserID:(NSString *)userid GroupID:(NSString *)groupid;

- (void)sendMessage;
- (void)getAllUsers;

@end
