//
//  MessageObject.h
//  TongDao
//
//  Created by 颜 沛贤 on 13-9-18.
//  Copyright (c) 2013年 BC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSMessagesViewController.h"

typedef enum {
    JJPrivateChat = 0,//私人聊天
    JJGroupChat = 1,//群组聊天
    JJManyPeopleChat =2,//多人聊天
} LLChatType;//聊天的类型

typedef enum {
    LLMessageTypePlain = 0,//文本
    LLMessageTypeImage = 1,//图片
    LLMessageTypeVoice =2,//声音
    LLMessageTypeLocation=3,//地点
    LLMessageTypeVCard=4//名片
} LLMessageType;


typedef enum {
    LLMessageCellStyleMe = 0,
    LLMessageCellStyleOther = 1,
    LLMessageCellStyleMeWithImage=2,
    LLMessageCellStyleOtherWithImage=3,
    LLMessageCellStyleMeWithVoice=4,
    LLMessageCellStyleOtherWithVoice=5,
    LLMessageCellStyleMeWithLocation=6,
    LLMessageCellStyleOtherWithLocation=7,
    LLMessageCellStyleMeWithVCard=8,
    LLMessageCellStyleOtherWithVCard=9
} LLMessageCellStyle;

@interface MessageObject : NSObject


@property (nonatomic,strong) NSNumber * messageChatType;//判断是私聊还是群聊，还是多人对话

//用户的信息
@property (nonatomic,strong) NSString * userId;
@property (nonatomic,strong) UIImage * headImage;

//消息来源部门【0:机构 1:条线 2:主题 3:其他】
@property (strong, nonatomic) NSString *messageWhereType;
@property (strong, nonatomic) NSString *messageWhereId;//来源部门id

//消息的信息
@property (strong, nonatomic) NSString *messageId;


@property (nonatomic,strong) NSString * content;//消息的内容,图片和语音的时候是base64

@property (nonatomic,strong) NSString * timelength;//声音的时间长度（只有语音有）

@property (nonatomic,strong) NSString *messageFrom;//消息发送者的id
@property (nonatomic,strong) NSString *messageFromName;//消息发送者的昵称
@property (nonatomic,strong) NSString *messageTo;

@property (nonatomic,strong) NSString *messageDate;
@property (nonatomic,assign) NSNumber * messageType;//消息的类型

@property (nonatomic,assign) NSNumber * messageCellStyle;//消息的类型

@property (nonatomic,strong) NSString * isRead;//0是已读，1是未读


@property (nonatomic, strong) NSString *groupNames;

@end
