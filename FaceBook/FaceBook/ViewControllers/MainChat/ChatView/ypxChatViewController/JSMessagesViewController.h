//
//  JSMessagesViewController.h
//


#import <UIKit/UIKit.h>
#import "JSMessageInputView.h"
#import "JSMessageSoundEffect.h"
#import "UIButton+JSMessagesView.h"

//#import "MessageObject.h"

#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <MapKit/MapKit.h>
#import "VoiceConverter.h"

#import "NSData+Base64.h"


typedef enum {
    JSMessagesViewTimestampPolicyAll = 0,
    JSMessagesViewTimestampPolicyAlternating,
    JSMessagesViewTimestampPolicyEveryThree,
    JSMessagesViewTimestampPolicyEveryFive,
    JSMessagesViewTimestampPolicyCustom
} JSMessagesViewTimestampPolicy;//时间戳


typedef enum {
    JSMessagesViewAvatarPolicyIncomingOnly = 0,
    JSMessagesViewAvatarPolicyBoth,
    JSMessagesViewAvatarPolicyNone
} JSMessagesViewAvatarPolicy;//头像的显示不显示

typedef enum {
    JSMessagesText = 0,
    JSMessagesVoice,
    JSMessagesImage
} JSMessagesType;//信息的类型


@protocol JSMessagesViewDelegate <NSObject>
@required
//传文本
- (void)sendPressed:(UIButton *)sender withText:(NSString *)text;
//传声音
- (void)sendPressed:(UIButton *)sender withSound:(NSString *)voiceBase andVoiceTime:(NSString*)voicetime;
//传图片
- (void)sendPressed:(UIButton *)sender withImage:(NSString *)imageBase;

- (JSMessagesViewTimestampPolicy)timestampPolicy;
- (JSMessagesViewAvatarPolicy)avatarPolicy;
- (JSMessagesType)messagesTypeForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (BOOL)hasTimestampForRowAtIndexPath:(NSIndexPath *)indexPath;

@end



@protocol JSMessagesViewDataSource <NSObject>
@required
- (NSMutableArray *)resourceArray;
- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath;//文本
- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath;//时间
- (NSString *)voiceLengthForRowAtIndexPath:(NSIndexPath *)indexPath;//声音长度
- (UIImage *)avatarImageForIncomingMessage;
- (UIImage *)avatarImageForOutgoingMessage;
@end



@interface JSMessagesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate,AVAudioRecorderDelegate,AVAudioPlayerDelegate>
{
    //声音部分
    AVAudioPlayer * audioPlayer;
    AVAudioRecorder * audioRecorder;
    int recordEncoding;
    BOOL isRecording;
    NSURL * recordedFile;
    
    NSString * voiceTime;//录音时间字符串
    
    NSTimer *timer;//起个定时器始终检测声音的大小
    
    UIButton * recordVoiceButton;//按住录音按钮
    
    //临时
    AVAudioPlayer * t_audioPlayer;
    
    //存储的文字
    NSString * _storageContent;
}

@property (assign, nonatomic) BOOL isVoiceButtonShow;
@property (nonatomic,retain) UIImageView * imageView;//音量提示的图片

@property (weak, nonatomic) id<JSMessagesViewDelegate> delegate;
@property (weak, nonatomic) id<JSMessagesViewDataSource> dataSource;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) JSMessageInputView *inputToolBarView;
@property (assign, nonatomic) CGFloat previousTextViewContentHeight;


#pragma mark - Messages view controller
- (BOOL)shouldHaveTimestampForRowAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)shouldHaveAvatarForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)finishSend;
- (void)finishReceived;
- (void)setBackgroundColor:(UIColor *)color;
- (void)scrollToBottomAnimated:(BOOL)animated;

#pragma mark - Keyboard notifications
- (void)handleWillShowKeyboard:(NSNotification *)notification;
- (void)handleWillHideKeyboard:(NSNotification *)notification;
- (void)keyboardWillShowHide:(NSNotification *)notification;

@end