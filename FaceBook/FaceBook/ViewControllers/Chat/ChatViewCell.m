//
//  ChatViewCell.m
//  FaceBook
//
//  Created by fengshaohui on 14-5-14.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "ChatViewCell.h"
#import <QuartzCore/QuartzCore.h>
@implementation ChatViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self myCellMarks];
    }
    return self;
}
- (void)myCellMarks
{
    //cell背景cellBackImageView;
    _cellBackImageView=[[UIImageView alloc]initWithFrame:CGRectMake(6, 0, 308, 148/2)];
    _cellBackImageView.backgroundColor=[UIColor whiteColor];
    _cellBackImageView.userInteractionEnabled = YES;
    [self addSubview:_cellBackImageView];
    
    //头像headImageView;
    _headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(2, 8, 52, 52)];
    _headImageView.backgroundColor = [UIColor clearColor];
    [_headImageView.layer setMasksToBounds:YES];
    [_headImageView.layer setCornerRadius:10.0f];
    _headImageView.userInteractionEnabled = YES;
    [_cellBackImageView addSubview:_headImageView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerTap:)];
    [_headImageView addGestureRecognizer:tap];
    
    
    //信息条数背景numberBackImageView;
    _numberBackImageView = [[UIImageView alloc]initWithFrame:CGRectMake(50, 4, 19, 19)];
    _numberBackImageView.backgroundColor = [UIColor clearColor];
    _numberBackImageView.userInteractionEnabled = YES;
    [_numberBackImageView.layer setMasksToBounds:YES];
    [_numberBackImageView.layer setCornerRadius:19.0f/2];
    [_cellBackImageView addSubview:_numberBackImageView];
    
    //信息数量numberLabel;
    _numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 19, 19)];
    _numberLabel.backgroundColor = [UIColor clearColor];
    _numberLabel.font = [UIFont systemFontOfSize:10];
    _numberLabel.textAlignment = NSTextAlignmentCenter;
//    [_numberLabel.layer setMasksToBounds:YES];
//    [_numberLabel.layer setCornerRadius:19.0f/2];
    _numberLabel.textColor = [UIColor whiteColor];
    [_numberBackImageView addSubview:_numberLabel];
    
    //名字nameLabel;
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 16, 308/2, 17)];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.font = [UIFont systemFontOfSize:15];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.textColor = [UIColor blackColor];
    [_cellBackImageView addSubview:_nameLabel];

    
    //信息messageLabel;
    _messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 42, 420/2, 14)];
    _messageLabel.backgroundColor = [UIColor clearColor];
    _messageLabel.font = [UIFont systemFontOfSize:13];
    _messageLabel.textAlignment = NSTextAlignmentLeft;
    _messageLabel.textColor = [UIColor blackColor];
    [_cellBackImageView addSubview:_messageLabel];
    
    //聊天类型chatImageView;
    _chatImageView = [[UIImageView alloc]initWithFrame:CGRectMake(448/2, 13, 18, 21)];
    _chatImageView.backgroundColor = [UIColor clearColor];
    _chatImageView.userInteractionEnabled = YES;
    [_cellBackImageView addSubview:_chatImageView];
    
    //聊天的时间dateLabel;
    _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(488/2, 17, 120/2, 13)];
    _dateLabel.backgroundColor = [UIColor clearColor];
    _dateLabel.font = [UIFont systemFontOfSize:13];
    _dateLabel.textAlignment = NSTextAlignmentLeft;
    _dateLabel.textColor = [UIColor blackColor];
    [_cellBackImageView addSubview:_dateLabel];
    
    //下划线lineImageView;
    _lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, _cellBackImageView.frame.size.height-1, _cellBackImageView.frame.size.width, 1)];
    _lineImageView.backgroundColor = [UIColor clearColor];
    _lineImageView.userInteractionEnabled = YES;
    [_cellBackImageView addSubview:_lineImageView];
    
}

-(void)setHeaderViewtap:(ChatViewCellBlock)aBlock
{
    chatViewCell_block = aBlock;
}

-(void)headerTap:(UITapGestureRecognizer *)sender
{
    chatViewCell_block(self);
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
