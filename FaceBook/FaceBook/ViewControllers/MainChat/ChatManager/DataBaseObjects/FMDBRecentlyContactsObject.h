//
//  FMDBRecentlyContactsObject.h
//  ChuMian
//
//  Created by 颜 沛贤 on 13-10-31.
//
//

#import <Foundation/Foundation.h>

#import "MessageObject.h"


typedef enum {
    LLPrivateChat = 0,//私人聊天
    LLGroupChat = 1,//群组聊天
    LLManyPeopleChat =2,//多人聊天
} ChatType;//聊天的类型


typedef enum {
    LLChatMessageTypePlain = 0,//文本
    LLChatMessageTypeImage = 1,//图片
    LLChatMessageTypeVoice =2,//声音
    LLChatMessageTypeLocation=3,//地点
    LLChatMessageTypeVcard=4//地点
} LLChatMessageType;//最后一条消息的类型



@interface FMDBRecentlyContactsObject : NSObject



//消息来源部门【0:机构 1:条线 2:主题 3:其他】
@property (strong, nonatomic) NSString *messageWhereType;
@property (strong, nonatomic) NSString *messageWhereId;//来源部门id

//
@property (nonatomic) NSNumber *messageChatType;//1判断是私聊还是群聊，还是多人对话1
//
@property (nonatomic,strong) NSString * content;//4消息的内容,【图片】【语音】
//
@property (nonatomic,strong) NSString * timelength;//5声音的时间长度（只有语音有）

// 不管发送还是接收，相对于我，对方的id
@property (nonatomic,strong) NSString *messageFaceId;//2对方的id（私聊是人的，群聊是群的）
// 不管发送还是接收，相对于我，对方的昵称
@property (nonatomic,strong) NSString *messageFaceName;//3对方昵称（私聊是人的，群聊是群的）
// 信息时间
@property (nonatomic,strong) NSString *messageDate;  //6
// 消息类型
@property (nonatomic,assign) NSNumber * messageType;//7消息的类型
//是否已读
@property (nonatomic,strong) NSString * isRead;//0是已读，1是未读
//未读条数
@property (nonatomic, strong) NSString *unReadNumber; //未读条数
//对方头像
@property (strong, nonatomic) NSString *faceHeadLogo;





////用户的信息
//@property (nonatomic,strong) NSString * userId;//
//@property (nonatomic,strong) UIImage * headImage;//
////消息的信息
//@property (nonatomic,strong) NSString * messageId;//消息的id
//@property (nonatomic,strong) NSString *messageTo;
@property (nonatomic,assign) NSNumber * messageCellStyle;//cell消息的类型



@end
