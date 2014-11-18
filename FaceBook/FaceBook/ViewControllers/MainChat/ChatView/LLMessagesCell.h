//
//  LLMessagesCell.h
//  ChuMian
//
//  Created by 颜 沛贤 on 13-10-27.
//
//

#import <UIKit/UIKit.h>
#import "MessageObject.h"

//coreText
#import "OHAttributedLabel.h"
#import "MarkupParser.h"
#import "CustomMethod.h"
#import "NSAttributedString+Attributes.h"


//头像大小
#define HEAD_SIZE 40.0f
#define TEXT_MAX_HEIGHT 500.0f
//间距
#define INSETS 11.0f

@protocol LLMessageCellDelegate <NSObject>

- (void)showChatImagesWith:(NSString*)imageBase;//传图片
- (void)playVoiceWithBase64Data:(NSString *)basedata;//传base64

- (void)showLocationWithLat:(NSString*)lat andLon:(NSString*)lon andLocationTitle:(NSString*)locationTitle;//传经纬度地理位置消息

- (void)checkOtherInfomationWithUserId:(NSString*)userid;//查看别人的信息


@end


@interface LLMessagesCell : UITableViewCell <OHAttributedLabelDelegate>
{
    UIImageView *_userHead;
    UIImageView *_bubbleBg;
    UIImageView *_headMask;
    UIImageView *_chatImage;//传的图片
    //coretext
    OHAttributedLabel *_messageConent;
    NSString * contentString;
    
    UILabel * nickNameLabel;
    NSString *nickNameString;
    
    NSString * _voiceFilePath;//传的声音的路径
    NSString * _voiceTimeLength;//传的声音的秒数
    UILabel * _timeLabel;//描述的label
    
    UIImageView * _locationImage;//地点的图片
    UILabel * _locationLabel;//地点的label
    NSString * _latitude;//纬度记录
    NSString * _longitude;//经度记录
    NSString * _locationTitle;//标题
    
}



@property (nonatomic,assign) id<LLMessageCellDelegate> delegate;

@property (nonatomic) LLMessageCellStyle msgStyle;
@property (nonatomic) int height;
-(void)setMessageObject:(MessageObject*)aMessage;//设置文本消息的内容
-(void)setHeadImage:(UIImage*)headImage;//设置头像的图片
-(void)setChatImage:(UIImage *)chatImage;//设置聊天发动的图片
-(void)setTimeLabel:(NSString*)timelength;//设置聊天图片的长度
//******************
- (void)setNickName:(NSString *)nickname;
//****************************
-(void)setLocationImage:(UIImage*)locationImg;//设置地点的图片
-(void)setLocationLabel:(NSString*)locationStr;//设置地点的位置信息
-(void)setLocationLat:(NSString*)lat andLon:(NSString*)lon andLocationTitle:(NSString*)locationTitle;//获取地理位置经纬度


@property (nonatomic,strong) NSString * base64Data;
@property (nonatomic,strong) NSString * voiceTimeLength;

@property (nonatomic,strong) NSString * userID;


//coretext
@property (nonatomic, strong) NSDictionary *m_emojiDic;


@end
