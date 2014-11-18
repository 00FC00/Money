//
//  CMChatMainViewController.m
//  ChuMian
//
//  Created by 颜 沛贤 on 13-10-12.
//
//

#import "CMChatMainViewController.h"
#import "PrivateChatMessagesDB.h"
#import "FMDBRecentlyContactsObject.h"
#import "RecentlyContactsDB.h"
#import "BCHTTPRequest.h"
#import "DMCAlertCenter.h"
//#import "RecentlyContactsDB.h"
#import "PublicObject.h"
#import "CMChatMainViewController.h"
//#import "CreateGroupViewController.h"
#import "LLRequest.h"
//#import "GroupChatSettingViewController.h"
//#import "GroupMessageViewController.h"
#import "ChatImageScrollViewController.h"
#import "GroupMemberViewController.h"
#define INPUT_HEIGHT 46.0f

#define MinVoiceLength 0.6 //最少录音的时间
#define DefaultRecordButtonImage @"huatong0@2x.png"
#define TouchUpRecordButtonImage @"huatong1@2x.png"
#define VoiceButtonSize 142.0/2 //录音按钮的大小
#define VolumeImageSize 190.0/2 //音量提示图片的大小

#define USERNAME @"chumian"

//数组里面存放字典的字段
#define VoiceDate @"voiceDate"//录音的时间
#define VoiceFilePath @"voiceFilePath"//录音文件的路径
#define VoiceTimeLength @"voiceTimeLength"//录音的时长

#import "GroupNotice.h"
#import "GroupNoticeObject.h"
#import <AVFoundation/AVFoundation.h>

@interface CMChatMainViewController ()
{
    GroupNoticeObject *obj;
    GroupNotice * groupNotice;
    NSString * navTitle;
    UIImageView *navImageView;
}

@end

@implementation CMChatMainViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.messages = [[NSMutableArray alloc] init];
        self.toUserHeadLogo = @"http://yunshanghui.bloveambition.com/upload/users/default.jpg";
            }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    groupNotice = [[GroupNotice alloc] init];
    [groupNotice createDataBase];
    obj = [groupNotice getAllRemindStyleWithGid:self.toUserID];
    
//*********
//新加
//*********
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
    
    
    if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
        [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (granted) {
                // Microphone enabled code
            }
            else {
                // Microphone disabled code
            }
        }];
    }
    [audioRecorder prepareToRecord];
    audioRecorder.meteringEnabled = YES;
    [audioRecorder record];

    
    //背景
    self.view.backgroundColor = [UIColor colorWithRed:228.0f/255.0f green:228.0f/255.0f blue:228.0f/255.0f alpha:1.0];
    if (IS_IOS_7) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios7"] forBarMetrics:UIBarMetricsDefault];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios6"] forBarMetrics:UIBarMetricsDefault];
    }
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    navTitle = [[NSString alloc]init];
    navTitle = @"";
    if (self.toUserName != nil) {
    
//用
    navTitle = self.toUserName;
        //导航
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:245.0f/255.0f alpha:1]];
    self.title = navTitle;
    [self firstThings];
    
   }
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"refreshGroupName" object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSString *  mgNameStr = (NSString *)note.object;
        navTitle = mgNameStr;
        NSLog(@"-----%@",navTitle);
        //[self.view removeFromSuperview];
//        //背景
//        [self.view addSubview:[PublicObject backgroundImageViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)]];
//        //导航
//        [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:245.0f/255.0f alpha:1]];
        self.title = navTitle;
//        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],  UITextAttributeTextColor,[UIFont fontWithName:@"Arial" size:19.0], UITextAttributeFont, nil]];
        [self firstThings];

        
        
    }];
    
    
    
    if ([self.isContact isEqualToString:@"YES"]) {
        [self sendMessageText:@"Hello"];
        
        
        CGSize size = self.view.frame.size;
        CGRect inputFrame = CGRectMake(0.0f, size.height - INPUT_HEIGHT, size.width, INPUT_HEIGHT);
        // self.inputToolBarView = [[JSMessageInputView alloc] initWithFrame:inputFrame delegate:self];
        self.inputToolBarView.frame = inputFrame;
        self.inputToolBarView.textView.frame = CGRectMake(37.0f, 6.0f, 213, 33+3);
    }
    
}
- (void)firstThings
{
    //返回
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 22, 40, 40);
    [backButton setBackgroundImage:[UIImage imageNamed:@"login_backButton@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //[self.navigationController.view addSubview:backButton];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;
    
    
    if (self.isGroupChat == YES) {
        UIButton *groupSetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        groupSetButton.frame = CGRectMake(526/2, 0, 80/2, 80/2);
        [groupSetButton setBackgroundImage:[UIImage imageNamed:@"facebookqunchengyuan@2x"] forState:UIControlStateNormal];
        [groupSetButton setTitle:@"" forState:UIControlStateNormal];
        groupSetButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [groupSetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [groupSetButton addTarget:self action:@selector(groupSetButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:groupSetButton];
        self.navigationItem.rightBarButtonItem=rightbuttonitem;
    }
    

    
    
    //取一下自己的头像
    myUserImage = [self currentFaceHeadImage];
    
    
    CGSize size = self.view.frame.size;
	
    CGRect tableFrame = CGRectMake(0.0f, 0, size.width, IS_IOS_7?size.height-46:size.height-46);
    self.mainTableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    self.mainTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.mainTableView setBackgroundView:nil];
    [self.mainTableView setBackgroundColor:[UIColor colorWithRed:228.0f/255.0f green:228.0f/255.0f blue:228.0f/255.0f alpha:1.0]];
    //self.mainTableView.backgroundColor = [UIColor whiteColor];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.view addSubview:self.mainTableView];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //tableview图片单击事件
    UITapGestureRecognizer* singleTapGestureRecognizer =
    [[UITapGestureRecognizer alloc]
     initWithTarget:self action:@selector(tableViewClicked:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    [self.mainTableView addGestureRecognizer:singleTapGestureRecognizer];
    
    
    
    
    
    
    
    //页面底部的View
    CGRect inputFrame = CGRectMake(0.0f, size.height - INPUT_HEIGHT, size.width, INPUT_HEIGHT);
    self.inputToolBarView = [[JSMessageInputView alloc] initWithFrame:inputFrame delegate:self];
    [self.inputToolBarView setBackgroundColor:[UIColor clearColor]];
    [self.inputToolBarView.textView setFont:[UIFont systemFontOfSize:16]];
    // TODO: refactor
    self.inputToolBarView.textView.dismissivePanGestureRecognizer = self.mainTableView.panGestureRecognizer;
    self.inputToolBarView.textView.keyboardDelegate = self;
    self.inputToolBarView.textView.enablesReturnKeyAutomatically = YES;
    self.inputToolBarView.textView.delegate = self;
    
    //语音文字切换按钮
    UIButton *voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [voiceButton setBackgroundImage:[UIImage imageNamed:@"chatvoice@2x.png"] forState:UIControlStateNormal];
    voiceButton.frame = CGRectMake(-5.0f, 0.0f, 46.0f, 46.0f);
    [voiceButton addTarget:self action:@selector(voiceButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.inputToolBarView setVoiceButton:voiceButton];
    self.isVoiceButtonShow = NO;
    
    
    //表情按钮
    UIButton *faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [faceButton setBackgroundImage:[UIImage imageNamed:@"chatface@2x.png"] forState:UIControlStateNormal];
    faceButton.frame = CGRectMake(320-45.0f-35.0f, 0.0f, 46.0f, 46.0f);
    [faceButton addTarget:self action:@selector(faceButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.inputToolBarView setFaceButton:faceButton];
    
    //add按钮---此处没有
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setBackgroundImage:[UIImage imageNamed:@"chatother@2x.png"] forState:UIControlStateNormal];
    addButton.frame = CGRectMake(320-45.0f, 0.0f, 46.0f, 46.0f);
    [addButton addTarget:self action:@selector(addButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.inputToolBarView setAddButton:addButton];
    
    [self.view addSubview:self.inputToolBarView];
    
    //表情的view
    _faceView = [[FaceBoard alloc] init];
    _faceView.delegate = self;
    
    //更多的view
    _shareMoreView =[[WCChatSelectionView alloc]init];
    [_shareMoreView setFrame:CGRectMake(0, 0, 320, 215)];
    [_shareMoreView setDelegate:self];

    
    //音量提示的图片
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake((320-VolumeImageSize)/2.0, (self.view.bounds.size.height-VolumeImageSize)/2.0, VolumeImageSize, VolumeImageSize)];
    [self.view addSubview:self.imageView];
    
    
    //声音模式
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    
    //从数据库取聊天记录---获取数据
    [self refreshData];

}
#pragma mark - 群成员设置
- (void)groupSetButtonClicked
{
//    GroupChatSettingViewController *groupChatSettingVC = [[GroupChatSettingViewController alloc]init];
//    groupChatSettingVC.myGroupId = self.toUserID;
//    groupChatSettingVC.myGroupName = navTitle;
//    [self.navigationController pushViewController:groupChatSettingVC animated:YES];
    GroupMemberViewController *groupMemberVC = [[GroupMemberViewController alloc]init];
    groupMemberVC.whereType = self.messageWhereTypes;
    groupMemberVC.whereId = self.messageWhereIds; //部门id
    groupMemberVC.groupId = self.toUserID;//群id
    groupMemberVC.groupName = navTitle;
    [self.navigationController pushViewController:groupMemberVC animated:YES];

}
- (void)viewWillAppear:(BOOL)animated
{
    
   
    
//    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];

//    //接受消息刷新数据
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"showName" object:nil];
    
    [self scrollToBottomAnimated:NO];
    
    //接受消息刷新数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:FSHNewMessageNotifaction object:nil];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillShowKeyboard:)
												 name:UIKeyboardWillShowNotification
                                               object:nil];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillHideKeyboard:)
												 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.inputToolBarView resignFirstResponder];
    [self setEditing:NO animated:YES];
        
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark - ButtonClicked
//返回
- (void)backButtonClicked
{
    if ([self.isFromGroup isEqualToString:@"yes"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString * identifier=@"friendCell";
//    LLMessagesCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
//    if (!cell) {
//        cell=[[LLMessagesCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
//    }
    
    LLMessagesCell *cell=[[LLMessagesCell alloc]init];
    cell.delegate = self;
    cell.backgroundColor = [UIColor clearColor];
    MessageObject *msg=[self.messages objectAtIndex:indexPath.row];
    NSLog(@"--------%@",msg.messageFrom);
    cell.userID = msg.messageFrom;
    
    [cell setMessageObject:msg];
    if ([obj.showGroupName isEqualToString:@"1"]) {
      [cell setNickName:msg.messageFromName];
    }else
    {
       [cell setNickName:@""];
    }

    //[cell setNickName:msg.messageFromName];
    NSInteger style=[msg.messageCellStyle integerValue];
    NSLog(@"style is %d",style);
    //头像
    switch (style) {
        case LLMessageCellStyleMe:
            [cell setHeadImage:msg.headImage];
            break;
        case LLMessageCellStyleOther:
            [cell setHeadImage:msg.headImage];
            
            
            break;
        case LLMessageCellStyleMeWithImage:
        {
            [cell setHeadImage:msg.headImage];
        }
            break;
        case LLMessageCellStyleOtherWithImage:{
            [cell setHeadImage:msg.headImage];
            
        }
            break;
        case LLMessageCellStyleMeWithVoice:
        {
            [cell setHeadImage:msg.headImage];
            

        }
            break;
        case LLMessageCellStyleOtherWithVoice:{
            [cell setHeadImage:msg.headImage];

        }
            break;
        case LLMessageCellStyleMeWithLocation:
        {
            [cell setHeadImage:msg.headImage];
            
        }
            break;
        case LLMessageCellStyleOtherWithLocation:{
            [cell setHeadImage:msg.headImage];
            
        }
            break;
        default:
            break;
    }
    
    [cell setMsgStyle:[msg.messageCellStyle integerValue]];
    
    //图片
    if ([msg.messageType integerValue] ==LLMessageTypeImage) {
        
        UIImage * t_image = [UIImage imageWithData:[NSData dataFromBase64String:msg.content]];
        NSLog(@"image content is %@",msg.content);
        
        cell.base64Data = msg.content;
        //[cell setChatImage:[Photo string2Image:msg.content]];
        [cell setChatImage:t_image];
        
        //  [msg setMessageContent:@""];
        if ([msg.messageCellStyle integerValue] == 2) {
            [cell setMsgStyle:LLMessageCellStyleMeWithImage];
        }else if ([msg.messageCellStyle integerValue] == 3) {
            [cell setMsgStyle:LLMessageCellStyleOtherWithImage];
        }
        
    }
    
    //声音
    if ([msg.messageType integerValue] == LLMessageTypeVoice) {
        
        //base64转成声音文件，并保存到数据库
        NSData * data = [NSData dataFromBase64String:msg.content];
        //data转成语音
        NSFileManager * filemaneger = [NSFileManager defaultManager];
        NSString * amrpath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/audio%@.amr",@"yanpeixian"]];
        [filemaneger createFileAtPath:amrpath contents:data attributes:nil];
        
        cell.base64Data = msg.content;
        [cell setTimeLabel:msg.timelength];
        
        [cell setMsgStyle:[msg.messageCellStyle integerValue]];

    }
    //位置
    if ([msg.messageType integerValue] == LLMessageTypeLocation) {
        
        [cell setLocationImage:[UIImage imageNamed:@"chatlocation.png"]];
        
        NSLog(@"cell的地理位置信息是%@",msg.content);
        NSArray * locationArray = [msg.content componentsSeparatedByString:@";"];
        if (locationArray.count == 3) {
            
            NSString * locationTitle = [locationArray objectAtIndex:0];
            [cell setLocationLabel:locationTitle];
            [cell setLocationLat:[locationArray objectAtIndex:1] andLon:[locationArray objectAtIndex:2] andLocationTitle:locationTitle];
            //            [cell setVcardHeadImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[cardArray objectAtIndex:2]]]]];
        }
        
        [cell setMsgStyle:[msg.messageCellStyle integerValue]];
        
        
    }
    
   
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( [[self.messages[indexPath.row] messageType] integerValue]==LLMessageTypeImage)
    {
        return 55+120+5;
    }
    else if( [[self.messages[indexPath.row] messageType] integerValue]==LLMessageTypePlain)
    {
        //文字
        NSString *orgin=[self.messages[indexPath.row] content];
        CGSize textSize=[orgin sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake((320-HEAD_SIZE-3*INSETS-40), TEXT_MAX_HEIGHT) lineBreakMode:NSLineBreakByWordWrapping];
        //NSLog(@"height is %f",55+textSize.height);
        return 55+textSize.height;
    }else  if( [[self.messages[indexPath.row] messageType] integerValue]==LLMessageTypeVoice){
        //声音
        return 75;
    }else {
        //位置信息
        return 55+90;
    }
}

#pragma mark - others messages
- (void)setBackgroundColor:(UIColor *)color
{
    self.view.backgroundColor = color;
    self.mainTableView.backgroundColor = color;
    self.mainTableView.separatorColor = color;
}

- (void)scrollToBottomAnimated:(BOOL)animated
{
    NSInteger rows = [self.mainTableView numberOfRowsInSection:0];
    
    if(rows > 0) {
        [self.mainTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:animated];
    }
}

#pragma mark - Text view delegate --点发送按钮的时候

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        NSLog(@"msg is %@",self.inputToolBarView.textView.text);
        //发送文本信息
        [self sendMessageText:self.inputToolBarView.textView.text];
        [textView resignFirstResponder];
        
         CGSize size = self.view.frame.size;
        CGRect inputFrame = CGRectMake(0.0f, size.height - INPUT_HEIGHT, size.width, INPUT_HEIGHT);
       // self.inputToolBarView = [[JSMessageInputView alloc] initWithFrame:inputFrame delegate:self];
        self.inputToolBarView.frame = inputFrame;
        self.inputToolBarView.textView.frame = CGRectMake(37.0f, 6.0f, 213, 33+3);
        return NO;
    }else {
        
    }
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView becomeFirstResponder];
	
    if(!self.previousTextViewContentHeight)
		self.previousTextViewContentHeight = textView.contentSize.height;
    
    [self scrollToBottomAnimated:YES];
}


- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat maxHeight = [JSMessageInputView maxHeight];
    CGFloat textViewContentHeight = textView.contentSize.height;
    //NSLog(@"max height is %f,textcontent height is %f",maxHeight,textViewContentHeight);
    BOOL isShrinking = textViewContentHeight < self.previousTextViewContentHeight;
    CGFloat changeInHeight = textViewContentHeight - self.previousTextViewContentHeight;
    //NSLog(@"change height is %f,--%d,previous text content height is %f",changeInHeight,isShrinking,self.previousTextViewContentHeight);
    if(!isShrinking && self.previousTextViewContentHeight == maxHeight) {
        changeInHeight = 0;
    }
    else {
        changeInHeight = MIN(changeInHeight, maxHeight - self.previousTextViewContentHeight);
    }
    //NSLog(@"two change height is %f",changeInHeight);
    
    if(changeInHeight != 0.0f) {
        if(!isShrinking)
            [self.inputToolBarView adjustTextViewHeightBy:changeInHeight];
        
        [UIView animateWithDuration:0.25f
                         animations:^{
                             UIEdgeInsets insets = UIEdgeInsetsMake(0.0f,
                                                                    44.0f,
                                                                    self.mainTableView.contentInset.bottom + changeInHeight,
                                                                    0.0f);
                             
                             self.mainTableView.contentInset = insets;
                             self.mainTableView.scrollIndicatorInsets = insets;
                             [self scrollToBottomAnimated:NO];
                             
                             CGRect inputViewFrame = self.inputToolBarView.frame;
                             self.inputToolBarView.frame = CGRectMake(0.0f,
                                                                      inputViewFrame.origin.y - changeInHeight,
                                                                      inputViewFrame.size.width,
                                                                      inputViewFrame.size.height + changeInHeight);
                         }
                         completion:^(BOOL finished) {
                             if(isShrinking)
                                 [self.inputToolBarView adjustTextViewHeightBy:changeInHeight];
                         }];
        
        self.previousTextViewContentHeight = MIN(textViewContentHeight, maxHeight);
    }
    
    
}

#pragma mark - Keyboard notifications
- (void)handleWillShowKeyboard:(NSNotification *)notification
{
    [self keyboardWillShowHide:notification];
}

- (void)handleWillHideKeyboard:(NSNotification *)notification
{
    [self keyboardWillShowHide:notification];
}

- (void)keyboardWillShowHide:(NSNotification *)notification
{
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
	double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:[UIView animationOptionsForCurve:curve]
                     animations:^{
                         CGFloat keyboardY = [self.view convertRect:keyboardRect fromView:nil].origin.y;
                         
                         CGRect inputViewFrame = self.inputToolBarView.frame;
                         CGFloat inputViewFrameY = keyboardY - inputViewFrame.size.height;
                         
                         // for ipad modal form presentations
                         CGFloat messageViewFrameBottom = self.view.frame.size.height - INPUT_HEIGHT;
                         if(inputViewFrameY > messageViewFrameBottom)
                             inputViewFrameY = messageViewFrameBottom;
                         
                         self.inputToolBarView.frame = CGRectMake(inputViewFrame.origin.x,
                                                                  inputViewFrameY,
                                                                  inputViewFrame.size.width,
                                                                  inputViewFrame.size.height);
                         
                         UIEdgeInsets insets = UIEdgeInsetsMake(0.0f,
                                                                0.0f,
                                                                self.view.frame.size.height - self.inputToolBarView.frame.origin.y - INPUT_HEIGHT,
                                                                0.0f);
                         
                         self.mainTableView.contentInset = insets;
                         self.mainTableView.scrollIndicatorInsets = insets;
                         self.mainTableView.frame = CGRectMake(0,0, 320,IS_IOS_7?self.view.frame.size.height-46:self.view.frame.size.height-46);
                     }
                     completion:^(BOOL finished) {
                     }];
}

#pragma mark - Dismissive text view delegate
- (void)keyboardDidScrollToPoint:(CGPoint)pt
{
    CGRect inputViewFrame = self.inputToolBarView.frame;
    CGPoint keyboardOrigin = [self.view convertPoint:pt fromView:nil];
    inputViewFrame.origin.y = keyboardOrigin.y - inputViewFrame.size.height;
    self.inputToolBarView.frame = inputViewFrame;
}

- (void)keyboardWillBeDismissed
{
    CGRect inputViewFrame = self.inputToolBarView.frame;
    inputViewFrame.origin.y = self.view.bounds.size.height - inputViewFrame.size.height;
    self.inputToolBarView.frame = inputViewFrame;
}

- (void)keyboardWillSnapBackToPoint:(CGPoint)pt
{
    CGRect inputViewFrame = self.inputToolBarView.frame;
    CGPoint keyboardOrigin = [self.view convertPoint:pt fromView:nil];
    inputViewFrame.origin.y = keyboardOrigin.y - inputViewFrame.size.height;
    self.inputToolBarView.frame = inputViewFrame;
}


#pragma mark - ButtonClicked
- (void)voiceButtonPressed:(UIButton*)sender
{
    
    if (self.isVoiceButtonShow == NO) {
        
        if (self.inputToolBarView.textView.text == nil || [self.inputToolBarView.textView.text isEqualToString:@""]) {
            [self.inputToolBarView.textView resignFirstResponder];
        }else {
            _storageContent = self.inputToolBarView.textView.text;
            
            [self.inputToolBarView.textView resignFirstResponder];
            [self.inputToolBarView.textView setText:nil];
            [self textViewDidChange:self.inputToolBarView.textView];
            [self scrollToBottomAnimated:YES];

        }        
        //语音按钮出现
        [sender setBackgroundImage:[UIImage imageNamed:@"chatpan@2x.png"] forState:UIControlStateNormal];
        if (recordVoiceButton == nil) {
            recordVoiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [recordVoiceButton setFrame:CGRectMake(35, (46-73.0/2)/2, 216, 73.0/2)];
            [recordVoiceButton setBackgroundImage:[UIImage imageNamed:@"chatvoicebutton@2x.png"] forState:UIControlStateNormal];
            [recordVoiceButton setTitle:@"按住 语音" forState:UIControlStateNormal];
            recordVoiceButton.titleLabel.font = [UIFont systemFontOfSize:16];
            [self.inputToolBarView setRecordVoiceButton:recordVoiceButton];
            
            
            //按钮触控事件
            [recordVoiceButton addTarget:self action:@selector(startRecord:) forControlEvents:UIControlEventTouchDown];//按钮按下开始录音的事件
            [recordVoiceButton addTarget:self action:@selector(endRecord:) forControlEvents:UIControlEventTouchUpInside];//在按钮上松手时触控的事件
            [recordVoiceButton addTarget:self action:@selector(cancelRecord:) forControlEvents:UIControlEventTouchUpOutside];//不在按钮上松手时触控的事件
            [recordVoiceButton addTarget:self action:@selector(leaveRecordButton:) forControlEvents:UIControlEventTouchDragOutside];//检测手指不在按钮上的事件（这个方法应该出现，松开手指取消发送）
            
        }else {
            [recordVoiceButton setHidden:NO];
        }
        
    }else {
        //输入文字框出现
        [sender setBackgroundImage:[UIImage imageNamed:@"chatvoice@2x.png"] forState:UIControlStateNormal];
        
        [self.inputToolBarView.textView setInputView:nil];
        
        [self.inputToolBarView.textView reloadInputViews];
        [self.inputToolBarView.textView becomeFirstResponder];

        
        if (_storageContent == nil || [_storageContent isEqualToString:@""]) {
            [self.inputToolBarView.textView becomeFirstResponder];
        }else {
            [self.inputToolBarView.textView becomeFirstResponder];
            [self.inputToolBarView.textView setText:_storageContent];
            [self textViewDidChange:self.inputToolBarView.textView];
            [self scrollToBottomAnimated:YES];
        }
        
        [recordVoiceButton setHidden:YES];
    }
    
    self.isVoiceButtonShow = !self.isVoiceButtonShow;
    
    
}



#pragma mark - voice model
//录音按钮
#pragma mark - voice
- (void)startRecord:(UIButton*)voiceButton
{
    NSLog(@"开始录音");
    self.imageView.hidden = NO;
    
    recordedFile = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:[NSString stringWithFormat:@"RecordedFile.wav"]]];
    NSLog(@"recordFile is %@",recordedFile);
    
    [self startRecording];
    
    //设置定时检测
    timer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(detectionVoice) userInfo:nil repeats:YES];
    
}

//松手时触控的事件
- (void)endRecord:(UIButton*)voiceButton
{
    NSLog(@"完成录音");
    [timer invalidate];
    
    [self stopRecording];
    
    NSLog(@"voice time is %f",audioPlayer.duration);
    
    
    voiceTime = [NSString stringWithFormat:@"%.3f",audioPlayer.duration];
    if (audioPlayer.duration < MinVoiceLength) {
        self.imageView.image = [UIImage imageNamed:@"shijiantaiduan@2x.png"];
        [self performSelector:@selector(imageViewHidden) withObject:self afterDelay:1.0];
    }else {
        self.imageView.hidden = YES;
        
        //这这里应该把音频压缩
        NSString * voicePath = [NSTemporaryDirectory() stringByAppendingString:[NSString stringWithFormat:@"RecordedFile.wav"]];
        //amr压缩,返回压缩后的文件名路径
        NSString * fileNamePath = [self wavToAmrVoice:voicePath];
        
        //发送语音信息
        NSData * voiceData = [NSData dataWithContentsOfFile:fileNamePath];
        
        NSString * message = [voiceData base64EncodedString];
        
        [self sendMessageVoice:message andTimeLength:voiceTime];
        //发送语音信息
        
    }
    
    
}

//不在按钮上松手时触控的事件
- (void)cancelRecord:(UIButton*)button
{
    NSLog(@"取消录音");
    [timer invalidate];
    self.imageView.hidden = YES;
    
}

//检测手指不在按钮上的事件（这个方法应该出现，松开手指取消发送）
- (void)leaveRecordButton:(UIButton*)recordButton
{
    NSLog(@"手指离开按钮");
    //self.imageView.hidden = YES;
}


- (void)playRecord:(UIButton*)voiceButton
{
    [self stopRecording];
    [self playRecording];
}


//开始录音
- (void)startRecording
{
    NSLog(@"startRecording");
    NSMutableDictionary * recordSettings = [[NSMutableDictionary alloc] initWithCapacity:0];
    [recordSettings setObject:[NSNumber numberWithInt: kAudioFormatLinearPCM] forKey: AVFormatIDKey];
    [recordSettings setObject:[NSNumber numberWithFloat:8000.0] forKey: AVSampleRateKey]; //采样率
    [recordSettings setObject:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];//通道的数目
    [recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];//采样位数 默认 16
    //    [recordSettings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    //    [recordSettings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    
    
    audioRecorder = [[AVAudioRecorder alloc] initWithURL:recordedFile settings:recordSettings error:nil];
    [audioRecorder prepareToRecord];
    [audioRecorder record];
    //开启音量检测
    audioRecorder.meteringEnabled = YES;
    audioRecorder.delegate = self;
}


//停止录音
- (void)stopRecording
{
    NSLog(@"stopRecording");
    [audioRecorder stop];
    
    audioRecorder = nil;
    
    NSError *playerError;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:recordedFile error:&playerError];
    
    if (audioPlayer == nil)
    {
        NSLog(@"ERror creating player: %@", [playerError description]);
    }
    audioPlayer.delegate = self;
    
    
}

//播放类的一些方法
- (void)playRecording
{
    audioPlayer.volume=1;
}

#pragma mark - 播放已经代理

- (void)finishPlay
{
    [audioPlayer play];
}

#pragma mark - AMR压缩
- (NSString*)wavToAmrVoice:(NSString*)tmpFileString {
    if (tmpFileString.length > 0){
        NSString * fileNameString = USERNAME;
        
        NSString * voiceFileNameString = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/audio%@%d.amr",fileNameString,self.messages.count]];
        //转格式
        [VoiceConverter wavToAmr:tmpFileString amrSavePath:voiceFileNameString];
        
        return voiceFileNameString;
    }else {
        return tmpFileString;
    }
}




- (void)tfinishPlay
{
    [t_audioPlayer play];
}


#pragma mark - 出现的提示页面
//声音大小的页面
- (void)detectionVoice
{
    [audioRecorder updateMeters];//刷新音量数据
    //获取音量的平均值  [audioRecorder averagePowerForChannel:0];
    //音量的最大值  [audioRecorder peakPowerForChannel:0];
    
    double lowPassResults = pow(10, (0.05 * [audioRecorder peakPowerForChannel:0]));
    //NSLog(@"**%lf",lowPassResults);
    //最大50  0
    //图片 小-》大
    if (0<lowPassResults<=0.02) {
        [self.imageView setImage:[UIImage imageNamed:@"yinliang0@2x.png"]];
    }else if (0.02<lowPassResults<=0.04) {
        [self.imageView setImage:[UIImage imageNamed:@"yinliang0@2x.png"]];
    }else if (0.04<lowPassResults<=0.06) {
        [self.imageView setImage:[UIImage imageNamed:@"yinliang2@2x.png"]];
    }else if (0.06<lowPassResults<=0.08) {
        [self.imageView setImage:[UIImage imageNamed:@"yinliang3@2x.png"]];
    }else {
        [self.imageView setImage:[UIImage imageNamed:@"yinliang4@2x.png"]];
    }
}

- (void) updateImage
{
    [self.imageView setImage:[UIImage imageNamed:@"yinliang0@2x.png"]];
}

- (void)imageViewHidden
{
    self.imageView.hidden = YES;
}




#pragma mark - 发送信息
- (void)sendMessageText:(NSString*)textContent
{
    //此处发送消息要判断是群发还是私聊
    NSString * contentStr = [NSString stringWithString:textContent];
    
    if (self.isGroupChat == NO) {
        //私聊
        [[LLRequest sharedLLRequest] sendMessageTargetID:self.toUserID withContent:contentStr andMessageType:@"text" andTimeLength:@"0" andWithMessageWhereType:self.messageWhereTypes andWhereID:self.messageWhereIds WithToLogo:self.toUserHeadLogo WithTargetName:self.toUserName];
        
    }else {
        //群聊
        [[LLRequest sharedLLRequest] sendGroupMessageTargetID:self.toUserID withContent:contentStr andMessageType:@"text" andTimeLength:@"0" andWithMessageWhereType:self.messageWhereTypes andWhereID:self.messageWhereIds WithtoLogo:@"" WithTargetName:self.toUserName];
        
    }
    self.inputToolBarView.textView.text = nil;
    _storageContent = nil;
    
    MessageObject * mesobj = [[MessageObject alloc] init];
    mesobj.messageFromName = [BCHTTPRequest getUserName];
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    long long dTime = [[NSNumber numberWithDouble:time] longLongValue]; // 将double转为long long型
    NSString *curTime = [NSString stringWithFormat:@"%llu",dTime]; // 输出long long型
    
    NSString *sendTime = [NSString stringWithFormat:@"%llu",[curTime longLongValue]*1000];
    //mesobj.messageDate = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]*1000];
    mesobj.messageDate = sendTime;
    
    NSLog(@"-----发送时间-------%@",sendTime);
    mesobj.messageFrom = [BCHTTPRequest getUserId];
    mesobj.timelength = @"0";
    mesobj.content = textContent;
    if (self.isGroupChat == YES) {
        mesobj.groupNames = [NSString stringWithFormat:@"%@",self.toUserName];
        mesobj.messageChatType = [NSNumber numberWithInt:JJGroupChat];
    }else
    {
        mesobj.groupNames = [NSString stringWithFormat:@"%@",self.toUserName];;
        mesobj.messageChatType = [NSNumber numberWithInt:JJPrivateChat];
    }
    //用         self.toUserID
    mesobj.messageTo = self.toUserID;
    mesobj.headImage = myUserImage;
    mesobj.messageCellStyle = [NSNumber numberWithInt:LLMessageCellStyleMe];
    mesobj.messageType = [NSNumber numberWithInt:LLMessageTypePlain];
   
    mesobj.messageWhereType = [NSString stringWithFormat:@"%@",self.messageWhereTypes];
    mesobj.messageWhereId = [NSString stringWithFormat:@"%@",self.messageWhereIds];
    
    [self.messages addObject:mesobj];
    
    
    [self finishSend];
    
    PrivateChatMessagesDB * privateChat = [[PrivateChatMessagesDB alloc] init];
    [privateChat createDataBase];
    [privateChat savePrivateMessageWithMessage:mesobj];

//*********
// 待修改
//***************
    //最近联系人数据库
    FMDBRecentlyContactsObject * recentlyObj = [[FMDBRecentlyContactsObject alloc] init];
    if (self.isGroupChat == YES) {
        recentlyObj.messageChatType = [NSNumber numberWithInt:JJGroupChat];
    }else
    {
        recentlyObj.messageChatType = [NSNumber numberWithInt:JJPrivateChat];
    }
    
    NSLog(@"-------->%@",recentlyObj.messageChatType);
    recentlyObj.messageFaceName = self.toUserName;
    
    NSTimeInterval time1 = [[NSDate date] timeIntervalSince1970];
    long long dTime1 = [[NSNumber numberWithDouble:time1] longLongValue]; // 将double转为long long型
    NSString *curTime1 = [NSString stringWithFormat:@"%llu",dTime1]; // 输出long long型
    
    NSString *sendTime1 = [NSString stringWithFormat:@"%llu",[curTime1 longLongValue]*1000];
    //mesobj.messageDate = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]*1000];
    recentlyObj.messageDate = sendTime1;

    recentlyObj.messageFaceId = self.toUserID;
    recentlyObj.timelength = @"0";
    recentlyObj.content = textContent;
    
    //用         self.toUserID
    recentlyObj.faceHeadLogo = self.toUserHeadLogo;
    recentlyObj.messageFaceName = self.toUserName;
 //   recentlyObj.messageCellStyle = [NSNumber numberWithInt:LLMessageCellStyleMe];
    recentlyObj.messageType = [NSNumber numberWithInt:LLMessageTypePlain];
    recentlyObj.messageWhereType = [NSString stringWithFormat:@"%@",self.messageWhereTypes];
    recentlyObj.messageWhereId = [NSString stringWithFormat:@"%@",self.messageWhereIds];
//    [self.messages addObject:recentlyObj];
//    
//    
//    [self finishSend];
    
    RecentlyContactsDB * recentlyContactsDB = [[RecentlyContactsDB alloc] init];
    [recentlyContactsDB createDataBase];
    [recentlyContactsDB saveRecentlyContactsWith:recentlyObj];

    [recentlyContactsDB emptyisReadWithRecentlyObj:recentlyObj];
    
    //创建通知，刷新最近联系人
    [[NSNotificationCenter defaultCenter] postNotificationName:@"recentlyList" object:nil];
    
    
    
}


- (void)sendMessageVoice:(NSString*)voiceBase andTimeLength:(NSString*)timeLength
{
    //用
    
    NSString * contentString = voiceBase;
    if (self.isGroupChat == NO) {
        
        [[LLRequest sharedLLRequest] sendMessageTargetID:self.toUserID withContent:contentString andMessageType:@"voice" andTimeLength:timeLength andWithMessageWhereType:self.messageWhereTypes andWhereID:self.messageWhereIds WithToLogo:self.toUserHeadLogo WithTargetName:self.toUserName];
    }else
    {
        
        
        [[LLRequest sharedLLRequest] sendGroupMessageTargetID:self.toUserID withContent:contentString andMessageType:@"voice" andTimeLength:timeLength andWithMessageWhereType:self.messageWhereTypes andWhereID:self.messageWhereIds WithtoLogo:@"" WithTargetName:self.toUserName];
   }
    
    

    
    MessageObject * mesobj = [[MessageObject alloc] init];
    mesobj.messageFromName = [BCHTTPRequest getUserName];
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    long long dTime = [[NSNumber numberWithDouble:time] longLongValue]; // 将double转为long long型
    NSString *curTime = [NSString stringWithFormat:@"%llu",dTime]; // 输出long long型
    
    NSString *sendTime = [NSString stringWithFormat:@"%llu",[curTime longLongValue]*1000];
    //mesobj.messageDate = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]*1000];
    mesobj.messageDate = sendTime;
    
    NSLog(@"-----发送时间-------%@",sendTime);

    mesobj.messageFrom = [BCHTTPRequest getUserId];
    mesobj.timelength = timeLength;
    mesobj.content = contentString;
    if (self.isGroupChat == YES) {
        mesobj.groupNames = [NSString stringWithFormat:@"%@",self.toUserName];
        mesobj.messageChatType = [NSNumber numberWithInt:JJGroupChat];

    }else
    {
        mesobj.groupNames = [NSString stringWithFormat:@"%@",self.toUserName];
        mesobj.messageChatType = [NSNumber numberWithInt:JJPrivateChat];

    }

    //用------self.toUserID
    mesobj.messageTo = self.toUserID;
    mesobj.headImage = myUserImage;
    mesobj.messageCellStyle = [NSNumber numberWithInt:LLMessageCellStyleMeWithVoice];
    mesobj.messageType = [NSNumber numberWithInt:LLMessageTypeVoice];
    
    mesobj.messageWhereType = [NSString stringWithFormat:@"%@",self.messageWhereTypes];
    mesobj.messageWhereId = [NSString stringWithFormat:@"%@",self.messageWhereIds];
    
    
    [self.messages addObject:mesobj];
    [self.mainTableView reloadData];
    
    [self scrollToBottomAnimated:YES];

    PrivateChatMessagesDB * privateChat = [[PrivateChatMessagesDB alloc] init];
    [privateChat createDataBase];
    [privateChat savePrivateMessageWithMessage:mesobj];

//************
// 待修改
//*****************
    //最近联系人数据库
    FMDBRecentlyContactsObject * recentlyObj = [[FMDBRecentlyContactsObject alloc] init];
    if (self.isGroupChat == YES) {
        recentlyObj.messageChatType = [NSNumber numberWithInt:JJGroupChat];
    }else
    {
        recentlyObj.messageChatType = [NSNumber numberWithInt:JJPrivateChat];
    }
    
    recentlyObj.messageFaceName = self.toUserName;
    
    recentlyObj.messageDate = sendTime;
    
    recentlyObj.messageFaceId = self.toUserID;
    recentlyObj.timelength = timeLength;
    recentlyObj.content = contentString;
    
    //用         self.toUserID
    recentlyObj.faceHeadLogo = self.toUserHeadLogo;
    //   recentlyObj.messageCellStyle = [NSNumber numberWithInt:LLMessageCellStyleMe];
    recentlyObj.messageType = [NSNumber numberWithInt:LLMessageTypeVoice];
    recentlyObj.messageWhereType = [NSString stringWithFormat:@"%@",self.messageWhereTypes];
    recentlyObj.messageWhereId = [NSString stringWithFormat:@"%@",self.messageWhereIds];

    //    [self.messages addObject:recentlyObj];
    //
    //
    //    [self finishSend];
    
    RecentlyContactsDB * recentlyContactsDB = [[RecentlyContactsDB alloc] init];
    [recentlyContactsDB createDataBase];
    [recentlyContactsDB saveRecentlyContactsWith:recentlyObj];
    [recentlyContactsDB emptyisReadWithRecentlyObj:recentlyObj];

    //创建通知，刷新最近联系人
   [[NSNotificationCenter defaultCenter] postNotificationName:@"recentlyList" object:nil];

}

//feng
- (void)sendMessageImage:(NSString*)imageBase
{
    NSString * contentString = imageBase;
    
    if (self.isGroupChat == NO) {
        
        
        [[LLRequest sharedLLRequest] sendMessageTargetID:self.toUserID withContent:contentString andMessageType:@"picture" andTimeLength:@"0" andWithMessageWhereType:self.messageWhereTypes andWhereID:self.messageWhereIds WithToLogo:self.toUserHeadLogo WithTargetName:self.toUserName];

    }else
    {
        
        [[LLRequest sharedLLRequest] sendGroupMessageTargetID:self.toUserID withContent:contentString andMessageType:@"picture" andTimeLength:@"0" andWithMessageWhereType:self.messageWhereTypes andWhereID:self.messageWhereIds WithtoLogo:@"" WithTargetName:self.toUserName];
    }
    
    
    MessageObject * mesobj = [[MessageObject alloc] init];
   
    mesobj.messageFromName = [BCHTTPRequest getUserName];
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    long long dTime = [[NSNumber numberWithDouble:time] longLongValue]; // 将double转为long long型
    NSString *curTime = [NSString stringWithFormat:@"%llu",dTime]; // 输出long long型
    
    NSString *sendTime = [NSString stringWithFormat:@"%llu",[curTime longLongValue]*1000];
    //mesobj.messageDate = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]*1000];
    mesobj.messageDate = sendTime;
    
    NSLog(@"-----发送时间-------%@",sendTime);

    mesobj.messageFrom = [BCHTTPRequest getUserId];
    mesobj.timelength = @"0";
    mesobj.content = contentString;
    
    if (self.isGroupChat == YES) {
        mesobj.groupNames = navTitle;
         mesobj.messageChatType = [NSNumber numberWithInt:JJGroupChat];
    }else
    {
        mesobj.groupNames = @"";
         mesobj.messageChatType = [NSNumber numberWithInt:JJPrivateChat];
    }

    //用------self.toUserID
    mesobj.messageTo = self.toUserID;
    mesobj.headImage = myUserImage;
    mesobj.messageCellStyle = [NSNumber numberWithInt:LLMessageCellStyleMeWithImage];
    mesobj.messageType = [NSNumber numberWithInt:LLMessageTypeImage];
    
    mesobj.messageWhereType = [NSString stringWithFormat:@"%@",self.messageWhereTypes];
    mesobj.messageWhereId = [NSString stringWithFormat:@"%@",self.messageWhereIds];
    
    [self.messages addObject:mesobj];
    [self.mainTableView reloadData];
    
    [self scrollToBottomAnimated:YES];
    
    PrivateChatMessagesDB * privateChat = [[PrivateChatMessagesDB alloc] init];
    [privateChat createDataBase];
    [privateChat savePrivateMessageWithMessage:mesobj];

//***************
// 待修改
//********************
    
    //最近联系人
    FMDBRecentlyContactsObject * recentlyObj = [[FMDBRecentlyContactsObject alloc] init];
    if (self.isGroupChat == YES) {
        recentlyObj.messageChatType = [NSNumber numberWithInt:JJGroupChat];
    }else
    {
        recentlyObj.messageChatType = [NSNumber numberWithInt:JJPrivateChat];
    }
    
    recentlyObj.messageFaceName = self.toUserName;
    recentlyObj.messageDate = sendTime;
    recentlyObj.messageFaceId = self.toUserID;
    recentlyObj.timelength = @"0";
    recentlyObj.content = contentString;
    //用------self.toUserID
   
    recentlyObj.faceHeadLogo = self.toUserHeadLogo;
    recentlyObj.messageCellStyle = [NSNumber numberWithInt:LLMessageCellStyleMeWithImage];
    recentlyObj.messageType = [NSNumber numberWithInt:LLMessageTypeImage];
    recentlyObj.messageWhereType = [NSString stringWithFormat:@"%@",self.messageWhereTypes];
    recentlyObj.messageWhereId = [NSString stringWithFormat:@"%@",self.messageWhereIds];
//    [self.messages addObject:recentlyObj];
//    [self.mainTableView reloadData];
//    
//    [self scrollToBottomAnimated:YES];
    
    RecentlyContactsDB * recentlyContactsDB = [[RecentlyContactsDB alloc] init];
    [recentlyContactsDB createDataBase];
    [recentlyContactsDB saveRecentlyContactsWith:recentlyObj];
    [recentlyContactsDB emptyisReadWithRecentlyObj:recentlyObj];

    //创建通知，刷新最近联系人
   [[NSNotificationCenter defaultCenter] postNotificationName:@"recentlyList" object:nil];
    
    
    
   

}

#pragma mark - ChatLocationDelegate--发送位置信息
//发送位置信息
- (void)showChatLocation:(NSString*)locationTitle andLat:(NSString*)lat andLon:(NSString*)lon
{
    NSLog(@"当前位置为==%@",locationTitle);
   // NSString * locationMessage = [NSString stringWithFormat:@"%@;%@;%@",locationTitle,lat,lon];

//    [[LLRequest sharedLLRequest] sendMessageToDDID:self.tFaceId withContent:locationMessage andMessageType:@"location" andTimeLength:@"0"];
//
//
//    
//    MessageObject * mesobj = [[MessageObject alloc] init];
//    
//    mesobj.channelId = CHANNELID;
//    mesobj.faceId = [CMHTTPRequest getLocationDDID];
//    mesobj.messageFromName = [CMHTTPRequest getLocationUserName];
//    mesobj.messageDate = (NSString*)[NSDate date];
//    mesobj.messageFrom = [CMHTTPRequest getLocationDDID];
//    mesobj.messageTo = self.tFaceId;
//    mesobj.content = locationMessage;
//    mesobj.timelength = @"0";
//    mesobj.messageCellStyle = [NSNumber numberWithInt:LLMessageCellStyleMeWithLocation];
//    mesobj.messageType = [NSNumber numberWithInt:LLMessageTypeLocation];
//    mesobj.headImage = myUserImage;
//
//
//    
//    [self.messages addObject:mesobj];
//    
//    [self.mainTableView reloadData];
//    [self scrollToBottomAnimated:YES];
//    
//    PrivateChatMessagesDB * privateChat = [[PrivateChatMessagesDB alloc] init];
//    [privateChat createDataBase];
//    [privateChat savePrivateMessageWithMessage:mesobj];
//
    
}

- (void)finishSend
{
    [self.inputToolBarView.textView setText:nil];
//    self.inputToolBarView.textView.frame = CGRectMake(37.0f, 6.0f, 213+35, 33.0f);
    [self textViewDidChange:self.inputToolBarView.textView];
    [self.mainTableView reloadData];
    [self scrollToBottomAnimated:YES];
}

- (void)finishReceived
{
    [self.inputToolBarView.textView setText:nil];
    [self.mainTableView reloadData];
    [self scrollToBottomAnimated:YES];
}


#pragma mark - sharemore按钮组协议

-(void)pickPhoto
{
    UIImagePickerController *imgPicker=[[UIImagePickerController alloc]init];
    [imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [imgPicker setDelegate:self];
    //[imgPicker setAllowsEditing:YES];
    [self presentViewController:imgPicker animated:YES completion:^{
    }];
    
}

-(void)pickCameraPhoto
{
    UIImagePickerController *imgPicker=[[UIImagePickerController alloc]init];
    [imgPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [imgPicker setDelegate:self];
    //[imgPicker setAllowsEditing:YES];
    [self presentViewController:imgPicker animated:YES completion:^{
    }];
}

- (void)locationViewShow
{
//    ChatLocationViewController * chatLocation = [[ChatLocationViewController alloc] init];
//    chatLocation.delegate = self;
//   // [self.navigationController pushViewController:chatLocation animated:YES];
//    
//    [self presentViewController:chatLocation animated:YES completion:^{
//        
//    }];
}



#pragma mark ----------图片选择完成-------------
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage  * chosedImage=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    NSData * imageData = UIImageJPEGRepresentation(chosedImage, 0.00001);
    
    NSLog(@"imagedata is %@",imageData);
    
    [self dismissViewControllerAnimated:YES completion:^{
        //
    [self sendMessageImage:[imageData base64EncodedString]];
        
        
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{
        //
    }];
}

#pragma mark - TSEmojiViewDelegate




#pragma mark - LLMessageCellDelegate
//展示图片
- (void)showChatImagesWith:(NSString*)imageBase
{
    ChatImageScrollViewController * chatImageView = [[ChatImageScrollViewController alloc] init];
    
    NSInteger index=0;
    
    NSMutableArray * imgArr = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray * other_imgArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (MessageObject * msg in self.messages) {
        if ([msg.messageType integerValue] == 1) {
            //            NSData * data = [NSData dataFromBase64String:msg.content];
            //            [imgArr addObject:[UIImage imageWithData:data]];
            [imgArr addObject:msg.content];
        }
    }
    
    for (NSInteger i = 0; i < imgArr.count; i ++) {
        if ([[imgArr objectAtIndex:i] isEqualToString:imageBase]) {
            index = i;
        }
        
         //NSData * data = [NSData dataFromBase64String:[imgArr objectAtIndex:i]];
        //[other_imgArr addObject:[UIImage imageWithData:data]];
        [other_imgArr addObject:[imgArr objectAtIndex:i]];
    }
    
    chatImageView.indexrow = index;
    chatImageView.imagesArray = other_imgArr;
    [self.navigationController pushViewController:chatImageView animated:YES];
    
    
}


//播放语音
- (void)playVoiceWithBase64Data:(NSString *)basedata
{
    NSLog(@"base data is %@",basedata);
    
    //base64转成声音文件，并保存到数据库
    NSData * data = [NSData dataFromBase64String:basedata];
    //data转成语音
    NSFileManager * filemaneger = [NSFileManager defaultManager];
    NSString * amrpath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/audio%@.amr",@"yanpeixian"]];
    [filemaneger createFileAtPath:amrpath contents:data attributes:nil];
    
    NSString * tmp_path = [NSTemporaryDirectory() stringByAppendingString:[NSString stringWithFormat:@"voiceFile.wav"]];
    //转格式
    [VoiceConverter amrToWav:amrpath wavSavePath:tmp_path];
    
    //初始化播放器的时候如下设置
//    UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
//    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory,
//                            sizeof(sessionCategory),
//                            &sessionCategory);
//    
//    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
//    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
//                             sizeof (audioRouteOverride),
//                             &audioRouteOverride);
    
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];

    
    UInt32 doChangeDefaultRoute = 1;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker,sizeof(doChangeDefaultRoute),&doChangeDefaultRoute);
    
    NSError *playerError;
    t_audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:tmp_path] error:&playerError];
    t_audioPlayer.meteringEnabled = YES;
    t_audioPlayer.delegate = self;
    
    
    if (t_audioPlayer == nil)
    {
        NSLog(@"ERror creating player: %@", [playerError description]);
    }
    
    [self handleNotification:YES];
    [t_audioPlayer play];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"播放结束");
    [self handleNotification:NO];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];

}

//查看别人的信息
- (void)checkOtherInfomationWithUserId:(NSString*)userid
{
    MySweepViewController *otherPeopleMessageDetialsVC = [[MySweepViewController alloc] init];
    otherPeopleMessageDetialsVC.friendIdString = userid;
    otherPeopleMessageDetialsVC.fromString = @"聊天";
    [self.navigationController pushViewController:otherPeopleMessageDetialsVC animated:YES];
}


#pragma mark - 监听听筒or扬声器
- (void) handleNotification:(BOOL)state
{
    [[UIDevice currentDevice] setProximityMonitoringEnabled:state]; //建议在播放之前设置yes，播放结束设置NO，这个功能是开启红外感应
    
    if(state)//添加监听
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(sensorStateChange:) name:@"UIDeviceProximityStateDidChangeNotification"
                                                   object:nil];
    else//移除监听
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
}

//处理监听触发事件
-(void)sensorStateChange:(NSNotificationCenter *)notification;
{
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗（省电啊）
    if ([[UIDevice currentDevice] proximityState] == YES)
    {
        NSLog(@"Device is close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }
    else
    {
        NSLog(@"Device is not close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}


//显示地理位置
- (void)showLocationWithLat:(NSString*)lat andLon:(NSString*)lon andLocationTitle:(NSString *)locationTitle
{
    NSLog(@"纬度%@，经度%@",lat,lon);
    
    
}

#pragma mark - popUpViewButtonClicked
- (void)clickControlsPopupButton:(UIButton*)sender
{
    if (sender.tag == 200) {
        //详细资料
    }else if (sender.tag == 201) {
        //设置背景
    }else if (sender.tag == 202) {
        //声音模式
    }else if (sender.tag == 203) {
        //信息通知
    }else if (sender.tag == 204) {
        //清空记录
    }
}


#pragma mark - 数据刷新
- (void)refreshData
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        PrivateChatMessagesDB * privateChat = [[PrivateChatMessagesDB alloc] init];
        [privateChat createDataBase];
        
        if (self.isGroupChat == NO) {
            //私聊
            NSMutableArray * dataArray = [privateChat searchMessagesArrayWithmMssageChatType:@"0" andFromId:[BCHTTPRequest getUserId] andToId:self.toUserID andMessageWhereType:self.messageWhereTypes andMessageWhereId:self.messageWhereIds];
            NSLog(@"data array is %@",dataArray);
            self.messages = dataArray;
        }else {
            NSMutableArray * dataArray = [privateChat searchMessagesArrayWithGroupID:self.toUserID andMessageWhereType:self.messageWhereTypes andMessageWhereId:self.messageWhereIds];
            NSLog(@"data array is %@",dataArray);
            self.messages = dataArray;
        }
        
        
        [self.mainTableView reloadData];
        [self scrollToBottomAnimated:YES];
    });
    


    
//    NSMutableArray * dataArray = [privateChat searchMessagesArrayWithChannelId:self.channelId andFromId:self.userId andToId:[NSString stringWithFormat:@"%d",[CMHTTPRequest getLocalUserID]]];
    
}

#pragma mark - 点击表情按钮
- (void)faceButtonPressed:(id)sender
{
    //表情
    if (isFaceViewShow == NO) {
        [self.inputToolBarView.textView setInputView:_faceView];
        
    }else {
        [self.inputToolBarView.textView setInputView:nil];
        
    }
    
    isFaceViewShow = !isFaceViewShow;

    [self.inputToolBarView.textView reloadInputViews];
    [self.inputToolBarView.textView becomeFirstResponder];
    //图片
//    UIActionSheet * photoActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"照片",@"拍照", nil];
//    [photoActionSheet showInView:self.view];
    
}
- (void)addButtonPressed:(id)sender
{
    isFaceViewShow = NO;
    if (isShareViewShow == NO) {
        [self.inputToolBarView.textView setInputView:_shareMoreView];
        
    }else {
        [self.inputToolBarView.textView setInputView:nil];
        
    }
    
    isShareViewShow = !isShareViewShow;
    
    [self.inputToolBarView.textView reloadInputViews];
    [self.inputToolBarView.textView becomeFirstResponder];
    
}


#pragma mark - 点击小表情
- (void)faceWithBoardView:(FaceBoard*)fView andFaceText:(NSString*)facetext
{
    self.inputToolBarView.textView.text = [NSString stringWithFormat:@"%@%@", self.inputToolBarView.textView.text, facetext];
    [self textViewDidChange:self.inputToolBarView.textView];
    [self scrollToBottomAnimated:YES];
    
}


- (void)sendFaceBoard
{
    if (self.inputToolBarView.textView.text == nil || [self.inputToolBarView.textView.text isEqualToString:@""]) {
        //
    }else {
        [self sendMessageText:self.inputToolBarView.textView.text];
        
    }
    [self.inputToolBarView.textView resignFirstResponder];
     [self.inputToolBarView.textView setInputView:nil];
    isFaceViewShow = NO;
    CGSize size = self.view.frame.size;
    CGRect inputFrame = CGRectMake(0.0f, size.height - INPUT_HEIGHT, size.width, INPUT_HEIGHT);
    // self.inputToolBarView = [[JSMessageInputView alloc] initWithFrame:inputFrame delegate:self];
    self.inputToolBarView.frame = inputFrame;
    self.inputToolBarView.textView.frame = CGRectMake(37.0f, 6.0f, 213, 33+3);
}



#pragma mark - 获取当前面的头像
- (UIImage*)currentFaceHeadImage
{
    
    if ([BCHTTPRequest getUserLogo] == nil || [[BCHTTPRequest getUserLogo] isEqualToString:@""]) {
        //没有头像
        return [UIImage imageNamed:@"Icon.png"];
        
    }else {
        NSData * iamgeDate = [NSData dataWithContentsOfURL:[NSURL URLWithString:[BCHTTPRequest getUserLogo]]];
        return [UIImage imageWithData:iamgeDate];
    }
    
}

#pragma mark - tableview触控事件
- (void)tableViewClicked:(UITapGestureRecognizer*)tap
{
    [self.inputToolBarView.textView resignFirstResponder];
    
    //位置按钮被按
    NSLog(@"tableViewClicked");
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"照片");
        [self pickPhoto];
    }else if (buttonIndex == 1) {
        NSLog(@"拍照");
        [self pickCameraPhoto];
    }
}

#pragma mark - 邀请
- (void)rightButtonClicked:(UIButton*)sender
{
//    if (self.isGroupChat == YES) {
//        GroupMessageViewController *groupMessageVC = [[GroupMessageViewController alloc]init];
//        groupMessageVC.myGroupId = self.toUserID;
//        [self.navigationController pushViewController:groupMessageVC animated:YES];
// 
//    }else
//    {
//    CreateGroupViewController *createGroupVC = [[CreateGroupViewController alloc]init];
//    createGroupVC.delegate = self;
//    //[self.navigationController pushViewController:createGroupVC animated:YES];
//    [self presentViewController:createGroupVC animated:YES completion:^{
//        ;
//    }];
//    }
}
#pragma mark -获得邀请入群的人
- (void)getTheChatFriendsArray:(NSMutableArray *)myReceiveArray
{
//    NSLog(@"❤❤%@",myReceiveArray);
//    
//    receivedChatStr = @"";
//    if (myReceiveArray.count>0) {
//        FriendsItem *receivefriends = myReceiveArray[0];
//        receivedChatStr = [NSString stringWithFormat:@"%d",receivefriends.friendId];
//        receivedChatDetialsStr = [NSString stringWithFormat:@"%d&%@&%@",receivefriends.friendId,receivefriends.name,receivefriends.headImageUrlString];
//    }
//    
//    for (int i = 1; i< myReceiveArray.count; i++) {
//        FriendsItem *receivefriends = myReceiveArray[i];
//        receivedChatStr = [NSString stringWithFormat:@"%@,%@",receivedChatStr,[NSString stringWithFormat:@"%d",receivefriends.friendId]];
//        
//        receivedChatDetialsStr = [NSString stringWithFormat:@"%@,%d&%@&%@",receivedChatDetialsStr,receivefriends.friendId,receivefriends.name,receivefriends.headImageUrlString];
//        
//    }
//    
//    receivedChatStr = [NSString stringWithFormat:@"%@,%@",receivedChatStr,self.toUserID];
//    receivedChatStr = [NSString stringWithFormat:@"%@,%@",receivedChatStr,[BCHTTPRequest getUserId]];
//    NSLog(@"--------%@",receivedChatStr);
//    [BCHTTPRequest CreateTheGroupChatViewWithUsersIds:receivedChatStr usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
//        if (isSuccess == 1) {
//            
//            CMChatMainViewController *groupChatMainVC = [[CMChatMainViewController alloc]init];
//            groupChatMainVC.isGroupChat = YES;
//            NSLog(@"---群组id---%@",resultDic[@"groupId"]);
//            groupChatMainVC.toUserID = [resultDic objectForKey:@"groupId"];
//            
//            [self.navigationController pushViewController:groupChatMainVC animated:YES];
//        }else
//        {
//            [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"创建群失败"];
//        }
//    }];

}
@end
