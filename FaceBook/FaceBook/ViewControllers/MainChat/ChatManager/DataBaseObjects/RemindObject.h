//
//  RemindObject.h
//  LifeTogether
//
//  Created by fengshaohui on 14-4-11.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RemindObject : NSObject
//铃声提醒
@property (strong, nonatomic) NSString *voiceRemind;
//震动提醒
@property (strong, nonatomic) NSString *sharkRemind;
//活动邀请
@property (strong, nonatomic) NSString *partyReceiveRemind;
//活动动态
@property (strong, nonatomic) NSString *partyDynamicRemind;
//好友请求
@property (strong, nonatomic) NSString *friendsReceiveRemind;


//群新消息通知
@property (strong, nonatomic) NSString *R_GroupNewMessage;
//显示群成员昵称
@property (strong, nonatomic) NSString *showMemberName;

@end
