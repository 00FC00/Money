//
//  JSMessagesViewController.m
//


#import "JSMessagesViewController.h"
#import "NSString+JSMessagesView.h"
#import "UIView+AnimationOptionsForCurve.h"
#import "UIColor+JSMessagesView.h"
#import "JSDismissiveTextView.h"

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


@interface JSMessagesViewController () <JSDismissiveTextViewDelegate>

- (void)setup;

@end



@implementation JSMessagesViewController

#pragma mark - Initialization
- (void)setup
{
    if([self.view isKindOfClass:[UIScrollView class]]) {
        // fix for ipad modal form presentations
        ((UIScrollView *)self.view).scrollEnabled = NO;
    }
    
    CGSize size = self.view.frame.size;
	
    CGRect tableFrame = CGRectMake(0.0f, 0, size.width, size.height - INPUT_HEIGHT);
	self.tableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
	self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.tableView.dataSource = self;
	self.tableView.delegate = self;
	[self.view addSubview:self.tableView];
    
    [self.tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 91.0/2)]];
    
	
    [self setBackgroundColor:[UIColor messagesBackgroundColor]];
    
    CGRect inputFrame = CGRectMake(0.0f, size.height - INPUT_HEIGHT, size.width, INPUT_HEIGHT);
    self.inputToolBarView = [[JSMessageInputView alloc] initWithFrame:inputFrame delegate:self];
    [self.inputToolBarView setBackgroundColor:[UIColor clearColor]];
    // TODO: refactor
    self.inputToolBarView.textView.dismissivePanGestureRecognizer = self.tableView.panGestureRecognizer;
    self.inputToolBarView.textView.keyboardDelegate = self;
    self.inputToolBarView.textView.enablesReturnKeyAutomatically = YES;

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
    faceButton.frame = CGRectMake(320-75.0f, 0.0f, 46.0f, 46.0f);
    [faceButton addTarget:self
                    action:@selector(faceButtonPressed:)
          forControlEvents:UIControlEventTouchUpInside];
    [self.inputToolBarView setFaceButton:faceButton];

    //add按钮
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setBackgroundImage:[UIImage imageNamed:@"chatother@2x.png"] forState:UIControlStateNormal];
    addButton.frame = CGRectMake(320-45.0f, 0.0f, 46.0f, 46.0f);
    [addButton addTarget:self
                   action:@selector(addButtonPressed:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.inputToolBarView setAddButton:addButton];

    [self.view addSubview:self.inputToolBarView];
    
    
    //音量提示的图片
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake((320-VolumeImageSize)/2.0, (self.view.bounds.size.height-VolumeImageSize)/2.0, VolumeImageSize, VolumeImageSize)];
    [self.view addSubview:self.imageView];

}



#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self scrollToBottomAnimated:NO];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"*** %@: didReceiveMemoryWarning ***", self.class);
}

- (void)dealloc
{
    self.delegate = nil;
    self.dataSource = nil;
    self.tableView = nil;
    self.inputToolBarView = nil;
}

#pragma mark - View rotation
- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self.tableView reloadData];
    [self.tableView setNeedsLayout];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma mark - Messages view controller
- (BOOL)shouldHaveTimestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([self.delegate timestampPolicy]) {
        case JSMessagesViewTimestampPolicyAll:
            return YES;
            
        case JSMessagesViewTimestampPolicyAlternating:
            return indexPath.row % 2 == 0;
            
        case JSMessagesViewTimestampPolicyEveryThree:
            return indexPath.row % 3 == 0;
            
        case JSMessagesViewTimestampPolicyEveryFive:
            return indexPath.row % 5 == 0;
            
        case JSMessagesViewTimestampPolicyCustom:
            if([self.delegate respondsToSelector:@selector(hasTimestampForRowAtIndexPath:)])
                return [self.delegate hasTimestampForRowAtIndexPath:indexPath];
            
        default:
            return NO;
    }
}



- (void)finishSend
{
    [self.inputToolBarView.textView setText:nil];
    [self textViewDidChange:self.inputToolBarView.textView];
    [self.tableView reloadData];
    [self scrollToBottomAnimated:YES];
}

- (void)finishReceived
{
    [self.inputToolBarView.textView setText:nil];
    [self.tableView reloadData];
    [self scrollToBottomAnimated:YES];
}

- (void)setBackgroundColor:(UIColor *)color
{
    self.view.backgroundColor = color;
    self.tableView.backgroundColor = color;
    self.tableView.separatorColor = color;
}

- (void)scrollToBottomAnimated:(BOOL)animated
{
    NSInteger rows = [self.tableView numberOfRowsInSection:0];
    
    if(rows > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:animated];
    }
}

#pragma mark - Text view delegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        NSLog(@"msg is %@",self.inputToolBarView.textView.text);
        [self.delegate sendPressed:nil
                          withText:[self.inputToolBarView.textView.text trimWhitespace]];
        [textView resignFirstResponder];
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
    NSLog(@"max height is %f,textcontent height is %f",maxHeight,textViewContentHeight);
    BOOL isShrinking = textViewContentHeight < self.previousTextViewContentHeight;
    CGFloat changeInHeight = textViewContentHeight - self.previousTextViewContentHeight;
    NSLog(@"change height is %f,--%d,previous text content height is %f",changeInHeight,isShrinking,self.previousTextViewContentHeight);
    if(!isShrinking && self.previousTextViewContentHeight == maxHeight) {
        changeInHeight = 0;
    }
    else {
        changeInHeight = MIN(changeInHeight, maxHeight - self.previousTextViewContentHeight);
    }
    NSLog(@"two change height is %f",changeInHeight);
    
    if(changeInHeight != 0.0f) {
        if(!isShrinking)
            [self.inputToolBarView adjustTextViewHeightBy:changeInHeight];
        
        [UIView animateWithDuration:0.25f
                         animations:^{
                             UIEdgeInsets insets = UIEdgeInsetsMake(0.0f,
                                                                    0.0f,
                                                                    self.tableView.contentInset.bottom + changeInHeight,
                                                                    0.0f);
                             
                             self.tableView.contentInset = insets;
                             self.tableView.scrollIndicatorInsets = insets;
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
                         
                         self.tableView.contentInset = insets;
                         self.tableView.scrollIndicatorInsets = insets;
                         self.tableView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height-INPUT_HEIGHT);
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
            
        }else {
            _storageContent = self.inputToolBarView.textView.text;
            
        }
        
        //语音按钮出现
        [sender setBackgroundImage:[UIImage imageNamed:@"chatpan@2x.png"] forState:UIControlStateNormal];
        if (recordVoiceButton == nil) {
            recordVoiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [recordVoiceButton setFrame:CGRectMake(37, (46-73.0/2)/2, 214, 73.0/2)];
            [recordVoiceButton setBackgroundImage:[UIImage imageNamed:@"chatvoicebutton@2x.png"] forState:UIControlStateNormal];
            [recordVoiceButton setTitle:@"按住 语音" forState:UIControlStateNormal];
            recordVoiceButton.titleLabel.font = [UIFont systemFontOfSize:16];
            [self.inputToolBarView setRecordVoiceButton:recordVoiceButton];
            
//            [recordVoiceButton addTarget:self action:@selector(startRecord:) forControlEvents:UIControlEventTouchDown];
//            [recordVoiceButton addTarget:self action:@selector(endRecord:) forControlEvents:UIControlEventTouchUpInside];
//            [recordVoiceButton addTarget:self action:@selector(playRecord:) forControlEvents:UIControlEventTouchUpOutside];
            
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
        
        [recordVoiceButton setHidden:YES];
    }
    
    self.isVoiceButtonShow = !self.isVoiceButtonShow;
    

}

- (void)faceButtonPressed:(id)sender
{
    
}

- (void)addButtonPressed:(id)sender
{
    
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
        
        [self.delegate sendPressed:nil withSound:message andVoiceTime:voiceTime];

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

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    
}

- (void)finishPlay
{
    [audioPlayer play];
}

#pragma mark - AMR压缩
- (NSString*)wavToAmrVoice:(NSString*)tmpFileString {
    if (tmpFileString.length > 0){
        NSString * fileNameString = USERNAME;
        
        NSString * voiceFileNameString = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/audio%@%d.amr",fileNameString,[self.dataSource resourceArray].count]];
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


@end