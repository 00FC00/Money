  //
//  CMChatMainViewController.h
//  ChuMian
//
//  Created by 颜 沛贤 on 13-10-12.
//
//

#import "JSMessagesViewController.h"
#import "UIView+AnimationOptionsForCurve.h"
#import "NSData+Base64.h"
#import "AppDelegate.h"
#import "MessageObject.h"

#import "JSMessageInputView.h"
#import "Photo.h"
#import "LLMessagesCell.h"

#import "LLRequest.h"
#import "WCChatSelectionView.h"
#import "FaceBoard.h"

#import "MySweepViewController.h"


//#import "CreateGroupViewController.h"
@interface CMChatMainViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,JSDismissiveTextViewDelegate,AVAudioRecorderDelegate,AVAudioPlayerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,LLMessageCellDelegate,FaceBoardDelegate,UIActionSheetDelegate,WCShareMoreDelegate>
{
    UIImage *_myHeadImage,*_userHeadImage;
    
    WCChatSelectionView *_shareMoreView;//更多view
    //表情的view
    FaceBoard *_faceView;
    BOOL isFaceViewShow;

    BOOL isShareViewShow;
    
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
    
//    NSInteger channelIndex;//取channel是第几个
    UIImage * myUserImage;
    
    
    //邀请入群的人
    NSString *receivedChatStr;
    //被邀请的人的信息字段
    NSString *receivedChatDetialsStr;
    
}

@property (assign, nonatomic) BOOL isGroupChat;//判断是不是群聊，YES是群聊，NO是私聊

@property (strong, nonatomic) NSString * toUserID;//对方的userid，如果是群聊的话，就是群的id
@property (strong, nonatomic) NSString * toUserName;//对方的名字
@property (strong, nonatomic) NSString *toUserHeadLogo;
@property (strong, nonatomic) NSString * filePath;

//消息所属部门
@property (strong, nonatomic) NSString * messageWhereTypes;
//消息所属部门的id
@property (strong, nonatomic) NSString * messageWhereIds;


@property (strong, nonatomic) UITableView * mainTableView;//聊天的tableview

@property (strong, nonatomic) NSMutableArray *messages;//消息的数组


@property (strong, nonatomic) JSMessageInputView *inputToolBarView;//下面的输入框
@property (assign, nonatomic) CGFloat previousTextViewContentHeight;//textview的高度监听

@property (assign, nonatomic) BOOL isVoiceButtonShow;
@property (nonatomic,retain) UIImageView * imageView;//音量提示的图片


@property (strong, nonatomic) NSString *isFromGroup;

@property (strong,nonatomic)NSString *isContact;

@end
