//
//  LLMessagesCell.m
//  ChuMian
//
//  Created by 颜 沛贤 on 13-10-27.
//
//

#import "LLMessagesCell.h"
#import <QuartzCore/QuartzCore.h>


#define CELL_HEIGHT self.contentView.frame.size.height
#define CELL_WIDTH self.contentView.frame.size.width


@implementation LLMessagesCell

@synthesize base64Data = _base64Data, voiceTimeLength = _voiceTimeLength;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        NSArray * _emojiArray = [[NSArray alloc]initWithObjects:
                                 @"f001@2x.png",
                                 @"f002@2x.png",
                                 @"f003@2x.png",
                                 @"f004@2x.png",
                                 @"f005@2x.png",
                                 @"f006@2x.png",
                                 @"f007@2x.png",
                                 @"f008@2x.png",
                                 @"f009@2x.png",
                                 @"f010@2x.png",
                                 @"f011@2x.png",
                                 @"f012@2x.png",
                                 @"f013@2x.png",
                                 @"f014@2x.png",
                                 @"f015@2x.png",
                                 @"f016@2x.png",
                                 @"f017@2x.png",
                                 @"f018@2x.png",
                                 @"f019@2x.png",
                                 @"f020@2x.png",
                                 @"f021@2x.png",
                                 @"f022@2x.png",
                                 @"f023@2x.png",
                                 @"f024@2x.png",
                                 @"f025@2x.png",
                                 @"f026@2x.png",
                                 @"f027@2x.png",
                                 @"f028@2x.png",
                                 @"f029@2x.png",
                                 @"f030@2x.png",
                                 @"f031@2x.png",
                                 @"f032@2x.png",
                                 @"f033@2x.png",
                                 @"f034@2x.png",
                                 @"f035@2x.png",
                                 @"f036@2x.png",
                                 @"f037@2x.png",
                                 @"f038@2x.png",
                                 @"f039@2x.png",
                                 @"f040@2x.png",
                                 @"f041@2x.png",
                                 @"f042@2x.png",
                                 @"f043@2x.png",
                                 @"f044@2x.png",
                                 @"f045@2x.png",
                                 @"f046@2x.png",
                                 @"f047@2x.png",
                                 @"f048@2x.png",
                                 @"f049@2x.png",
                                 @"f050@2x.png",
                                 @"f051@2x.png",
                                 @"f052@2x.png",
                                 @"f053@2x.png",
                                 @"f054@2x.png",
                                 @"f055@2x.png",
                                 @"f056@2x.png",
                                 @"f057@2x.png",
                                 @"f058@2x.png",
                                 @"f059@2x.png",
                                 @"f060@2x.png",
                                 @"f061@2x.png",
                                 @"f062@2x.png",
                                 @"f063@2x.png",
                                 @"f064@2x.png",
                                 @"f065@2x.png",
                                 @"f066@2x.png",
                                 @"f067@2x.png",
                                 @"f068@2x.png",
                                 @"f069@2x.png",
                                 @"f070@2x.png",
                                 @"f071@2x.png",
                                 @"f072@2x.png",
                                
                                 nil];
        
        
        NSArray * _symbolArray = [[NSArray alloc]initWithObjects:
                        @"[微笑]",@"[撇嘴]",@"[色色]",@"[发呆]",@"[得意]",@"[流泪]",@"[害羞]",@"[闭嘴]",@"[难过]",@"[大哭]",@"[尴尬]",@"[发怒]",@"[调皮]",@"[呲牙]",@"[惊讶]",@"[难过]",@"[酷酷]",@"[冷汗]",@"[抓狂]",@"[吐了]",@"[偷笑]",@"[愉快]",@"[白眼]",@"[傲慢]",@"[饥饿]",@"[困了]",@"[惊恐]",@"[流汗]",@"[憨笑]",@"[悠闲]",@"[奋斗]",@"[咒骂]",@"[疑问]",@"[嘘嘘]",@"[晕了]",@"[疯了]",@"[衰了]",@"[骷髅]",@"[敲打]",@"[再见]",@"[擦汗]",@"[抠鼻]",@"[鼓掌]",@"[出糗]",@"[坏笑]",@"[左哼]",@"[右哼]",@"[哈欠]",@"[鄙视]",@"[委屈]",@"[快哭]",@"[阴险]",@"[亲亲]",@"[吓吓]",@"[可怜]",@"[菜刀]",@"[西瓜]",@"[啤酒]",@"[篮球]",@"[乒乓]",@"[咖啡]",@"[饭饭]",@"[猪头]",@"[玫瑰]",@"[凋谢]",@"[嘴唇]",@"[爱心]",@"[心碎]",@"[蛋糕]",@"[闪电]",@"[炸弹]",@"[刀刀]", nil];
        self.m_emojiDic = [[NSDictionary alloc] initWithObjects:_emojiArray forKeys:_symbolArray];

        
        // Initialization code
        _userHead =[[UIImageView alloc]initWithFrame:CGRectZero];//头像
        _userHead.layer.cornerRadius = 6;
        _userHead.layer.masksToBounds = YES;
        _userHead.userInteractionEnabled = YES;

        _bubbleBg =[[UIImageView alloc]initWithFrame:CGRectZero];//气泡
        _bubbleBg.userInteractionEnabled = YES;
        
        _messageConent=[[OHAttributedLabel alloc]initWithFrame:CGRectZero];//主题内容的label
        _messageConent.numberOfLines = 0;
        
        _headMask =[[UIImageView alloc]initWithFrame:CGRectZero];
        _chatImage =[[UIImageView alloc]initWithFrame:CGRectZero];//聊天的图片
        _chatImage.userInteractionEnabled = YES;
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];//时间的label
         [_timeLabel setFont:[UIFont systemFontOfSize:15]];
        _timeLabel.adjustsFontSizeToFitWidth = YES;
        _timeLabel.backgroundColor = [UIColor clearColor];
        [_timeLabel setTextColor:[UIColor colorWithRed:108.0/255 green:108.0/255 blue:108.0/255 alpha:1.0]];
        
        //****************************************
        nickNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];//昵称的label
        [nickNameLabel setFont:[UIFont systemFontOfSize:11]];
        nickNameLabel.adjustsFontSizeToFitWidth = YES;
        nickNameLabel.backgroundColor = [UIColor clearColor];
        //[nickNameLabel setText:@"冯绍辉"];
        //[nickNameLabel setTextColor:[UIColor colorWithRed:108.0/255 green:108.0/255 blue:108.0/255 alpha:1.0]];
        [nickNameLabel setTextColor:[UIColor blackColor]];
        //********************************************************
        
        
        _locationImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _locationImage.userInteractionEnabled = YES;
        
        _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 59, 90-8, 30)];
        [_locationLabel setFont:[UIFont systemFontOfSize:9]];
        _locationLabel.numberOfLines = 0;
        _locationLabel.textAlignment = NSTextAlignmentCenter;
        _locationLabel.backgroundColor = [UIColor clearColor];
        [_locationLabel setTextColor:[UIColor whiteColor]];
        [_locationImage addSubview:_locationLabel];
        
        
        [_messageConent setBackgroundColor:[UIColor clearColor]];
        [_messageConent setFont:[UIFont systemFontOfSize:16]];
        [_messageConent setNumberOfLines:0];
        [self.contentView addSubview:_bubbleBg];
        [self.contentView addSubview:_userHead];
        [self.contentView addSubview:_headMask];
//        [self.contentView addSubview:_messageConent];
        [self.contentView addSubview:_chatImage];
        [self.contentView addSubview:_timeLabel];
        //*************************************
        [self.contentView addSubview:nickNameLabel];
        //*********************************************************
        [self.contentView addSubview:_locationImage];
        [_chatImage setBackgroundColor:[UIColor redColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [_headMask setImage:[[UIImage imageNamed:@"UserHeaderImageBox"]stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
    }
    return self;
}

-(void)layoutSubviews
{
    
    [super layoutSubviews];
    
    NSString *orgin=contentString;
    
    CGSize textSize=[orgin sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake((320-HEAD_SIZE-3*INSETS-40), TEXT_MAX_HEIGHT) lineBreakMode:NSLineBreakByWordWrapping];
    
    
     nickNameLabel.frame =CGRectMake(10, 0, 200, 30.0/2);
    switch (_msgStyle) {
        case LLMessageCellStyleMe:
            //发送文本
        {
            [_chatImage setHidden:YES];
            [_messageConent setHidden:NO];
            [_locationImage setHidden:YES];
            UIView * maincontentView = [[UIView alloc] initWithFrame:CGRectMake(CELL_WIDTH-INSETS*2-HEAD_SIZE-textSize.width-13, (CELL_HEIGHT-textSize.height)/2, textSize.width, textSize.height)];
            maincontentView.backgroundColor = [UIColor clearColor];
            [self addSubview:maincontentView];
//            [_messageConent setFrame:CGRectMake(CELL_WIDTH-INSETS*2-HEAD_SIZE-textSize.width-13, (CELL_HEIGHT-textSize.height)/2, textSize.width, textSize.height)];
          
            
            [_messageConent setFrame:CGRectMake(0, 0, maincontentView.frame.size.width, maincontentView.frame.size.height)];
            //_messageConent.text = contentString;
            [self creatAttributedLabel:orgin Label:_messageConent];
            
           // [CustomMethod drawImage:_messageConent];

            [maincontentView addSubview:_messageConent];
            
            
           // [self creatAttributedLabel:contentString Label:_messageConent andSize:maincontentView.frame.size];
            [CustomMethod drawImage:_messageConent];

            
            [_userHead setFrame:CGRectMake(CELL_WIDTH-INSETS-HEAD_SIZE, INSETS+6,HEAD_SIZE , HEAD_SIZE)];
            
            [_bubbleBg setImage:[[UIImage imageNamed:@"bubble-square-outgoing"]stretchableImageWithLeftCapWidth:18 topCapHeight:19]];
            _bubbleBg.frame=CGRectMake(maincontentView.frame.origin.x-8, maincontentView.frame.origin.y-8, textSize.width+25,_messageConent.frame.size.height+16);
        }
            break;
            
        case LLMessageCellStyleOther:
            //接受文本
        {
            [_chatImage setHidden:YES];
            [_messageConent setHidden:NO];
            [_locationImage setHidden:YES];
            [_userHead setFrame:CGRectMake(INSETS, INSETS+4,HEAD_SIZE , HEAD_SIZE)];
            UIView * maincontentView = [[UIView alloc] initWithFrame:CGRectMake(2*INSETS+HEAD_SIZE+13, (CELL_HEIGHT-textSize.height)/2, textSize.width, textSize.height)];
            maincontentView.backgroundColor = [UIColor clearColor];
            [self addSubview:maincontentView];
            [_messageConent setFrame:CGRectMake(0, 0, maincontentView.frame.size.width, maincontentView.frame.size.height)];
            [nickNameLabel setBackgroundColor:[UIColor clearColor]];
            //_messageConent.text = contentString;
            [nickNameLabel setText:nickNameString];
            
            [self creatAttributedLabel:contentString Label:_messageConent];
            [maincontentView addSubview:_messageConent];
            [CustomMethod drawImage:_messageConent];

//
            
            //图片头像事件
            UITapGestureRecognizer* userHeadsingleTapGestureRecognizer =
            [[UITapGestureRecognizer alloc]
             initWithTarget:self action:@selector(userHeadButtonClicked:)];
            userHeadsingleTapGestureRecognizer.numberOfTapsRequired = 1;
            [_userHead addGestureRecognizer:userHeadsingleTapGestureRecognizer];
            
//            [_messageConent setFrame:CGRectMake(2*INSETS+HEAD_SIZE+13, (CELL_HEIGHT-textSize.height)/2, textSize.width, textSize.height)];
//            _messageConent.text = contentString;
            
//            [self creatAttributedLabel:contentString Label:_messageConent andSize:textSize];
//            //NSNumber *heightNum = [[NSNumber alloc] initWithFloat:label.frame.size.height];
//            [CustomMethod drawImage:_messageConent];

            
            [_bubbleBg setImage:[[UIImage imageNamed:@"bubble-square-incoming"]stretchableImageWithLeftCapWidth:20 topCapHeight:21]];
            _bubbleBg.frame=CGRectMake(maincontentView.frame.origin.x-15, maincontentView.frame.origin.y-8, textSize.width+25,_messageConent.frame.size.height+16);
        }
            break;
            
        case LLMessageCellStyleMeWithImage:
            //发送图片
        {
            NSLog(@"5555555");
            //[_messageConent setFrame:CGRectMake(CELL_WIDTH-INSETS*2-HEAD_SIZE-textSize.width-15, (CELL_HEIGHT-textSize.height)/2, textSize.width, textSize.height)];
            [_chatImage setHidden:NO];
            [_messageConent setHidden:YES];
            [_locationImage setHidden:YES];
            [_chatImage setFrame:CGRectMake(CELL_WIDTH-INSETS*2-HEAD_SIZE-115, (CELL_HEIGHT-120)/2, 100, 120)];
            [_userHead setFrame:CGRectMake(CELL_WIDTH-INSETS-HEAD_SIZE, INSETS+6,HEAD_SIZE , HEAD_SIZE)];
            
            [_bubbleBg setImage:[[UIImage imageNamed:@"bubble-square-outgoing"]stretchableImageWithLeftCapWidth:20 topCapHeight:21]];
            _bubbleBg.frame=CGRectMake(_chatImage.frame.origin.x-7, _chatImage.frame.origin.y-7, 100+22, 120+15);
            
            //图片单击事件
            UITapGestureRecognizer* singleTapGestureRecognizer =
            [[UITapGestureRecognizer alloc]
             initWithTarget:self action:@selector(imageButtonClicked:)];
            singleTapGestureRecognizer.numberOfTapsRequired = 1;
            [_chatImage addGestureRecognizer:singleTapGestureRecognizer];

        }
            break;
            
        case LLMessageCellStyleOtherWithImage:
            //接受图片
        {
            NSLog(@"666666");
            [_chatImage setHidden:NO];
            [_messageConent setHidden:YES];
            [_locationImage setHidden:YES];
            [_chatImage setFrame:CGRectMake(2*INSETS+HEAD_SIZE+15, (CELL_HEIGHT-120)/2,100,120)];
            [_userHead setFrame:CGRectMake(INSETS, INSETS+6,HEAD_SIZE , HEAD_SIZE)];
            // [nickNameLabel setText:nickNameString];
            [_bubbleBg setImage:[[UIImage imageNamed:@"bubble-square-incoming"]stretchableImageWithLeftCapWidth:20 topCapHeight:21]];
            [nickNameLabel setText:nickNameString];
            _bubbleBg.frame=CGRectMake(_chatImage.frame.origin.x-15, _chatImage.frame.origin.y-7, 100+22, 120+15);
            
            //图片头像事件
            UITapGestureRecognizer* userHeadsingleTapGestureRecognizer =
            [[UITapGestureRecognizer alloc]
             initWithTarget:self action:@selector(userHeadButtonClicked:)];
            userHeadsingleTapGestureRecognizer.numberOfTapsRequired = 1;
            [_userHead addGestureRecognizer:userHeadsingleTapGestureRecognizer];
            
            //图片单击事件
            UITapGestureRecognizer* singleTapGestureRecognizer =
            [[UITapGestureRecognizer alloc]
             initWithTarget:self action:@selector(imageButtonClicked:)];
            singleTapGestureRecognizer.numberOfTapsRequired = 1;
            [_chatImage addGestureRecognizer:singleTapGestureRecognizer];

        }
            break;
            
        case LLMessageCellStyleMeWithVoice:
            //发送声音
        {
            NSLog(@"发送声音");
            [_chatImage setHidden:NO];
            [_messageConent setHidden:YES];
            [_chatImage setHidden:YES];
            [_locationImage setHidden:YES];
            [_userHead setFrame:CGRectMake(CELL_WIDTH-INSETS-HEAD_SIZE, INSETS+6,HEAD_SIZE , HEAD_SIZE)];
            
            [_bubbleBg setImage:[[UIImage imageNamed:@"shengdaoyuyin"]stretchableImageWithLeftCapWidth:20 topCapHeight:21]];

            //声音按钮的边长
            if (1.5 > self.voiceTimeLength.floatValue > 0) {
                
                _bubbleBg.frame=CGRectMake(CELL_WIDTH-INSETS-HEAD_SIZE-7-146.0/2, INSETS+4, 146.0/2, 86.0/2);

            }
            else if (10.0 > self.voiceTimeLength.floatValue > 1.5) {
                
                int i = [self.voiceTimeLength floatValue];
                
                _bubbleBg.frame=CGRectMake(CELL_WIDTH-INSETS-HEAD_SIZE-7-146.0/2-i*10, INSETS+4, 146.0/2+i*10, 86.0/2);

            }else if (10 <= self.voiceTimeLength.floatValue < 60) {
                
                int j = [self.voiceTimeLength floatValue] - 10;
                
                _bubbleBg.frame=CGRectMake(CELL_WIDTH-INSETS-HEAD_SIZE-7-146.0/2-50-j*1, INSETS+4, 146.0/2+50+j*1, 86.0/2);

            }

            _timeLabel.frame = CGRectMake(CELL_WIDTH-INSETS-HEAD_SIZE-7-_bubbleBg.frame.size.width-53, INSETS+4, 50, 86.0/2);
            //_timeLabel.text = self.voiceTimeLength;
            _timeLabel.textAlignment = NSTextAlignmentRight;

            //图片单击事件
            UITapGestureRecognizer* singleTapGestureRecognizer =
            [[UITapGestureRecognizer alloc]
             initWithTarget:self action:@selector(voiceButtonClicked:)];
            singleTapGestureRecognizer.numberOfTapsRequired = 1;
            [_bubbleBg addGestureRecognizer:singleTapGestureRecognizer];

        }
            break;
        case LLMessageCellStyleOtherWithVoice:
            //接受声音
        {
            [_chatImage setHidden:NO];
            [_messageConent setHidden:YES];
            [_chatImage setHidden:YES];
            [_locationImage setHidden:YES];
            [_userHead setFrame:CGRectMake(INSETS, INSETS+6,HEAD_SIZE , HEAD_SIZE)];
            
            [_bubbleBg setImage:[[UIImage imageNamed:@"dasongyuyin"]stretchableImageWithLeftCapWidth:40 topCapHeight:21]];
            
            //声音按钮的边长
            if (1.5 > self.voiceTimeLength.floatValue > 0) {
                
                _bubbleBg.frame=CGRectMake(INSETS+HEAD_SIZE+7, INSETS+4, 146.0/2, 86.0/2);
                
            }
            else if (10.0 > self.voiceTimeLength.floatValue > 1.5) {
                
                int i = [self.voiceTimeLength floatValue];
                
                _bubbleBg.frame=CGRectMake(INSETS+HEAD_SIZE+7, INSETS+4, 146.0/2+i*10, 86.0/2);
                
            }else if (10 <= self.voiceTimeLength.floatValue < 60) {
                
                int j = [self.voiceTimeLength floatValue] - 10;
                
                _bubbleBg.frame=CGRectMake(INSETS+HEAD_SIZE+7, INSETS+4, 146.0/2+50+j*1, 86.0/2);
                
            }
            [nickNameLabel setText:nickNameString];
            _timeLabel.frame = CGRectMake(_bubbleBg.frame.size.width+_bubbleBg.frame.origin.x+5, INSETS+4, 50, 86.0/2);
                       //_timeLabel.text = self.voiceTimeLength;
            
            
            //图片头像事件
            UITapGestureRecognizer* userHeadsingleTapGestureRecognizer =
            [[UITapGestureRecognizer alloc]
             initWithTarget:self action:@selector(userHeadButtonClicked:)];
            userHeadsingleTapGestureRecognizer.numberOfTapsRequired = 1;
            [_userHead addGestureRecognizer:userHeadsingleTapGestureRecognizer];
            
            //图片单击事件
            UITapGestureRecognizer* singleTapGestureRecognizer =
            [[UITapGestureRecognizer alloc]
             initWithTarget:self action:@selector(voiceButtonClicked:)];
            singleTapGestureRecognizer.numberOfTapsRequired = 1;
            [_bubbleBg addGestureRecognizer:singleTapGestureRecognizer];

        }
            break;
        case LLMessageCellStyleMeWithLocation:
            //发送地理位置
        {
            //[_messageConent setFrame:CGRectMake(CELL_WIDTH-INSETS*2-HEAD_SIZE-textSize.width-15, (CELL_HEIGHT-textSize.height)/2, textSize.width, textSize.height)];
            [_chatImage setHidden:NO];
            [_messageConent setHidden:YES];
            [_chatImage setHidden:YES];
            [_locationImage setFrame:CGRectMake(CELL_WIDTH-INSETS*2-HEAD_SIZE-100, (CELL_HEIGHT-90)/2, 90, 90)];
            [_userHead setFrame:CGRectMake(CELL_WIDTH-INSETS-HEAD_SIZE, INSETS+6,HEAD_SIZE , HEAD_SIZE)];
            
            [_bubbleBg setImage:[[UIImage imageNamed:@"bubble-square-outgoing"]stretchableImageWithLeftCapWidth:20 topCapHeight:21]];
            _bubbleBg.frame=CGRectMake(_locationImage.frame.origin.x-7, _locationImage.frame.origin.y-7, 90+22, 90+12);
            
            //图片单击事件
            UITapGestureRecognizer* singleTapGestureRecognizer =
            [[UITapGestureRecognizer alloc]
             initWithTarget:self action:@selector(locationButtonClicked:)];
            singleTapGestureRecognizer.numberOfTapsRequired = 1;
            [_locationImage addGestureRecognizer:singleTapGestureRecognizer];
            
        }
            break;
            
        case LLMessageCellStyleOtherWithLocation:
            //接受地理位置
        {
            [_chatImage setHidden:NO];
            [_messageConent setHidden:YES];
            [_chatImage setHidden:YES];
            [_locationImage setFrame:CGRectMake(2*INSETS+HEAD_SIZE+12, (CELL_HEIGHT-90)/2,90,90)];
            [_userHead setFrame:CGRectMake(INSETS, INSETS+6,HEAD_SIZE , HEAD_SIZE)];
            
            [_bubbleBg setImage:[[UIImage imageNamed:@"bubble-square-incoming"]stretchableImageWithLeftCapWidth:20 topCapHeight:21]];
            
            _bubbleBg.frame=CGRectMake(_locationImage.frame.origin.x-15, _locationImage.frame.origin.y-7, 90+22, 90+12);
            [nickNameLabel setText:nickNameString];
            
            //图片头像事件
            UITapGestureRecognizer* userHeadsingleTapGestureRecognizer =
            [[UITapGestureRecognizer alloc]
             initWithTarget:self action:@selector(userHeadButtonClicked:)];
            userHeadsingleTapGestureRecognizer.numberOfTapsRequired = 1;
            [_userHead addGestureRecognizer:userHeadsingleTapGestureRecognizer];
            
            //图片单击事件
            UITapGestureRecognizer* singleTapGestureRecognizer =
            [[UITapGestureRecognizer alloc]
             initWithTarget:self action:@selector(locationButtonClicked:)];
            singleTapGestureRecognizer.numberOfTapsRequired = 1;
            [_locationImage addGestureRecognizer:singleTapGestureRecognizer];
            
        }
            break;

        default:
        break;
    }
    
    
    _headMask.frame=CGRectMake(_userHead.frame.origin.x-3, _userHead.frame.origin.y-1, HEAD_SIZE+6, HEAD_SIZE+6);
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setMessageObject:(MessageObject*)aMessage
{
//    [self creatAttributedLabel:aMessage.content Label:_messageConent];
//    //NSNumber *heightNum = [[NSNumber alloc] initWithFloat:label.frame.size.height];
   // [CustomMethod drawImage:_messageConent];

    contentString = aMessage.content;
    
//    [_messageConent setText:aMessage.content];
    
}
-(void)setHeadImage:(UIImage*)headImage
{
    [_userHead setImage:headImage];
}
-(void)setChatImage:(UIImage *)chatImage
{
    [_chatImage setImage:chatImage];
}

- (void)setTimeLabel:(NSString *)timelength
{
    _timeLabel.text = [NSString stringWithFormat:@"%.0f\"",[timelength floatValue]];
    self.voiceTimeLength = _timeLabel.text;
}

- (void)setNickName:(NSString *)nickname
{
    nickNameString = nickname;
}
-(void)setLocationImage:(UIImage*)locationImg
{
    [_locationImage setImage:locationImg];
}

-(void)setLocationLabel:(NSString*)locationStr
{
    _locationLabel.text = locationStr;
}

-(void)setLocationLat:(NSString*)lat andLon:(NSString*)lon andLocationTitle:(NSString*)locationTitle
{
    _latitude = lat;
    _longitude = lon;
    _locationTitle = locationTitle;
}

#pragma mark - 单击事件

- (void)imageButtonClicked:(UITapGestureRecognizer*)tap
{
    //图片按钮被按
    NSLog(@"imageButtonClicked");
//   ChatImageScrollViewController * chatImageView = [[ChatImageScrollViewController alloc] init];
//    
//    [[self viewController].navigationController pushViewController:chatImageView animated:YES];
//    
//    UIImage * t_image = ((UIImageView*)[tap view]).image;
    
    [_delegate showChatImagesWith:self.base64Data];
    
}
- (void)voiceButtonClicked:(UITapGestureRecognizer*)tap
{
    //声音按钮被按
    NSLog(@"voiceButtonClicked");
    //这里应该传什么
    [_delegate playVoiceWithBase64Data:self.base64Data];
}

- (void)locationButtonClicked:(UITapGestureRecognizer*)tap
{
    //位置按钮被按
    NSLog(@"locationButtonClicked");
    [_delegate showLocationWithLat:_latitude andLon:_longitude andLocationTitle:_locationTitle];
}

- (void)userHeadButtonClicked:(UITapGestureRecognizer*)tap
{
    //查看别人的信息
    NSLog(@"userHeadButtonClicked---%@",self.userID);
    [_delegate checkOtherInfomationWithUserId:self.userID];

}

#pragma mark - 获得view的父视图的viewcontroller
- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}


#pragma mark - coretext
//- (void)creatAttributedLabel:(NSString *)o_text Label:(OHAttributedLabel *)label  andSize:(CGSize)size
//{
//    [label setNeedsDisplay];
//    
//    NSMutableArray *httpArr = [CustomMethod addHttpArr:o_text];
//    NSMutableArray *phoneNumArr = [CustomMethod addPhoneNumArr:o_text];
//    NSMutableArray *emailArr = [CustomMethod addEmailArr:o_text];
//    
//    NSString *text = [CustomMethod transformString:o_text emojiDic:self.m_emojiDic];//匹配表情，将表情转化为html格式,方法里面可以调大小
//    
//    text = [NSString stringWithFormat:@"<font color='black' strokeColor='gray' face='Palatino-Roman'>%@",text];
//    
//    NSLog(@"emojidic is %@",text);
//
//    
//    MarkupParser *wk_markupParser = [[MarkupParser alloc] init];
//    NSMutableAttributedString* attString = [wk_markupParser attrStringFromMarkup: text];
//    [attString setFont:[UIFont systemFontOfSize:16.0f]];//字体大小
//    [label setBackgroundColor:[UIColor redColor]];//背景颜色
//    [label setAttString:attString withImages:wk_markupParser.images];
//    
//    NSString *string = attString.string;
//    
//    if ([emailArr count]) {
//        for (NSString *emailStr in emailArr) {
//            [label addCustomLink:[NSURL URLWithString:emailStr] inRange:[string rangeOfString:emailStr]];
//        }
//    }
//    
//    if ([phoneNumArr count]) {
//        for (NSString *phoneNum in phoneNumArr) {
//            [label addCustomLink:[NSURL URLWithString:phoneNum] inRange:[string rangeOfString:phoneNum]];
//        }
//    }
//    
//    if ([httpArr count]) {
//        for (NSString *httpStr in httpArr) {
//            [label addCustomLink:[NSURL URLWithString:httpStr] inRange:[string rangeOfString:httpStr]];
//        }
//    }
//    
//    label.delegate = self;
//    
//
//    //= label.frame
//    CGRect labelRect ;
//    
//    labelRect.size.width = [label sizeThatFits:CGSizeMake(size.width, CELL_WIDTH)].width; //size.width;//
//    labelRect.size.height =[label sizeThatFits:CGSizeMake(size.height, CELL_HEIGHT)].height;//size.height;//
//    label.frame = CGRectMake(0, 0, labelRect.size.width, labelRect.size.height);
//    label.underlineLinks = YES;//链接是否带下划线
//    [label.layer display];
//}

- (void)creatAttributedLabel:(NSString *)o_text Label:(OHAttributedLabel *)label
{
    [label setNeedsDisplay];
    NSMutableArray *httpArr = [CustomMethod addHttpArr:o_text];
    NSMutableArray *phoneNumArr = [CustomMethod addPhoneNumArr:o_text];
    NSMutableArray *emailArr = [CustomMethod addEmailArr:o_text];
    
    NSString *text = [CustomMethod transformString:o_text emojiDic:self.m_emojiDic];
    text = [NSString stringWithFormat:@"<font color='black' strokeColor='gray' face='Palatino-Roman'>%@",text];
    
    MarkupParser *wk_markupParser = [[MarkupParser alloc] init];
    NSMutableAttributedString* attString = [wk_markupParser attrStringFromMarkup: text];
    [attString setFont:[UIFont systemFontOfSize:16]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setAttString:attString withImages:wk_markupParser.images];
    
    NSString *string = attString.string;
    
    if ([emailArr count]) {
        for (NSString *emailStr in emailArr) {
            [label addCustomLink:[NSURL URLWithString:emailStr] inRange:[string rangeOfString:emailStr]];
        }
    }
    
    if ([phoneNumArr count]) {
        for (NSString *phoneNum in phoneNumArr) {
            [label addCustomLink:[NSURL URLWithString:phoneNum] inRange:[string rangeOfString:phoneNum]];
        }
    }
    
    if ([httpArr count]) {
        for (NSString *httpStr in httpArr) {
            [label addCustomLink:[NSURL URLWithString:httpStr] inRange:[string rangeOfString:httpStr]];
        }
    }
    
    label.delegate = self;
    CGRect labelRect = label.frame;
    labelRect.size.width = [label sizeThatFits:CGSizeMake(200, CGFLOAT_MAX)].width;
    labelRect.size.height = [label sizeThatFits:CGSizeMake(200, CGFLOAT_MAX)].height;
    label.frame = labelRect;
    label.underlineLinks = YES;//链接是否带下划线
    [label.layer display];
}

#pragma mark - OHAttributedLabelDelegate
- (BOOL)attributedLabel:(OHAttributedLabel *)attributedLabel shouldFollowLink:(NSTextCheckingResult *)linkInfo
{
    NSString *requestString = [linkInfo.URL absoluteString];
    NSLog(@"%@",requestString);
    if ([[UIApplication sharedApplication]canOpenURL:linkInfo.URL]) {
        [[UIApplication sharedApplication]openURL:linkInfo.URL];
    }
    
    return NO;
}




@end
