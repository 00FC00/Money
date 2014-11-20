//
//  FriendsCircleCell.m
//  FaceBook
//
//  Created by fengshaohui on 14-5-22.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "FriendsCircleCell.h"
#import <QuartzCore/QuartzCore.h>
@implementation FriendsCircleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        [self cellsMark];
    }
    return self;
}
-(void)cellsMark
{
//    //用户的头像背景marksImageView;
//    _marksImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20/2, 12/2, 92/2, 92/2)];
//    _marksImageView.backgroundColor = [UIColor clearColor];
//    _marksImageView.userInteractionEnabled = YES;
//    [_marksImageView.layer setMasksToBounds:YES];
//    [_marksImageView.layer setCornerRadius:3.0f];
//    [self addSubview:_marksImageView];
    
    //用户头像userImageButton
    _userImageView = [[UIImageView alloc]initWithFrame:CGRectMake(9,16,42,42)];
    _userImageView.backgroundColor = [UIColor clearColor];
    _userImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:_userImageView];
    
    
    _userImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _userImageButton.frame = CGRectMake(0, 0, 84/2, 84/2);
    _userImageButton.backgroundColor = [UIColor clearColor];
    [_userImageView addSubview:_userImageButton];

    //名字userNameLabel;
    _userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(120/2,16,220/2, 18)];
    _userNameLabel.backgroundColor =[UIColor clearColor];
    _userNameLabel.font = [UIFont boldSystemFontOfSize:16];
    _userNameLabel.textAlignment = NSTextAlignmentLeft;
    _userNameLabel.textColor = [UIColor colorWithRed:86/255.0f green:104/255.0f blue:151/255.0f alpha:1];
    [self addSubview:_userNameLabel];
    
    //时间postDateTimeLabel;
    _postDateTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(60,16,200,24)];
    _postDateTimeLabel.backgroundColor =[UIColor clearColor];
    _postDateTimeLabel.font = [UIFont systemFontOfSize:13];
    _postDateTimeLabel.textAlignment = NSTextAlignmentLeft;
    _postDateTimeLabel.textColor = [UIColor darkGrayColor];
    [self.contentView addSubview:_postDateTimeLabel];

    
//    //横线horizontalLineImageView;
//    _horizontalLineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_marksImageView.frame.origin.x+_marksImageView.frame.size.width, 33, 600/2, 1)];
//    _horizontalLineImageView.backgroundColor = [UIColor clearColor];
//    _horizontalLineImageView.userInteractionEnabled = YES;
//    [self addSubview:_horizontalLineImageView];
    
    //照片背景photoBackImageView;
    _photoBackImageView = [[UIImageView alloc]init];
    _photoBackImageView.backgroundColor = [UIColor clearColor];
    _photoBackImageView.userInteractionEnabled = YES;
    [self addSubview:_photoBackImageView];

    
    //说说内容messageLabel;
    _messageLabel = [[OHAttributedLabel alloc]initWithFrame:CGRectMake(60,40,492/2,0)];
    _messageLabel.backgroundColor =[UIColor redColor];
    _messageLabel.font = [UIFont systemFontOfSize:15];
    _messageLabel.textAlignment = NSTextAlignmentLeft;
    _messageLabel.textColor = [UIColor darkGrayColor];
    [self addSubview:_messageLabel];
    
    //操作按钮operationButton;
    _operationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _operationButton.backgroundColor = [UIColor clearColor];
    [_operationButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [self addSubview:_operationButton];
    
    _operationBackImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    _operationBackImageView.backgroundColor = [UIColor clearColor];
    _operationBackImageView.userInteractionEnabled = YES;
    _operationBackImageView.clipsToBounds = YES;
//    [_operationBackImageView setImage:[UIImage imageNamed:@"caozuokuang@2x"]];
    _operationBackImageView.backgroundColor = [UIColor colorWithRed:74/255.0f green:81/255.0f blue:84/255.0f alpha:1];
    _operationBackImageView.layer.cornerRadius = 8;
    [self addSubview:_operationBackImageView];
//    _operationBackImageView.hidden = YES;
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(89,7,0.5,26)];
    lineView.backgroundColor = [UIColor colorWithRed:54/255.0f green:61/255.0f blue:64/255.0f alpha:1];
    [_operationBackImageView addSubview:lineView];

    //评论
    _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _commentButton.frame = CGRectMake(10,7.5,70,25);
    _commentButton.backgroundColor = [UIColor clearColor];
    [_operationBackImageView addSubview:_commentButton];
    
    
    //赞
    _lovesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _lovesButton.frame = CGRectMake(100,7.5,70,25);
    [_lovesButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    
    _lovesButton.backgroundColor = [UIColor clearColor];
    [_operationBackImageView addSubview:_lovesButton];
    
    //评论背景commentsBackImageView;
    _commentsBackImageView = [[UIImageView alloc]init];
    _commentsBackImageView.backgroundColor = [UIColor clearColor];
    _commentsBackImageView.userInteractionEnabled = YES;
    [self addSubview:_commentsBackImageView];
    
//    _commentContentLabel = [[AttributedLabel alloc]initWithFrame:CGRectZero];
//    _commentContentLabel.backgroundColor = [UIColor clearColor];
//    [_commentsBackImageView addSubview:_commentContentLabel];

    
//    //竖线verticalLineImageView;
//    _verticalLineImageView = [[UIImageView alloc]init];
//    _verticalLineImageView.backgroundColor = [UIColor clearColor];
//    _verticalLineImageView.userInteractionEnabled = YES;
//    [self addSubview:_verticalLineImageView];

    

}
////显示操作框
//- (void)showOperationBackImageView
//{
//    [self addSubview:_operationBackImageView];
//}
//隐藏操作框
- (void)hidenOperationBackImageView
{
    [_operationBackImageView removeFromSuperview];
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
