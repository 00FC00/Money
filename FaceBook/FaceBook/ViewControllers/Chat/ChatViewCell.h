//
//  ChatViewCell.h
//  FaceBook
//
//  Created by fengshaohui on 14-5-14.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViewCell : UITableViewCell
//cell背景
@property (strong, nonatomic) UIImageView *cellBackImageView;
//头像
@property (strong, nonatomic) UIImageView *headImageView;
//信息条数背景
@property (strong, nonatomic) UIImageView *numberBackImageView;
//信息数量
@property (strong, nonatomic) UILabel *numberLabel;
//名字
@property (strong, nonatomic) UILabel *nameLabel;
//信息
@property (strong, nonatomic) UILabel *messageLabel;
//聊天类型
@property (strong, nonatomic) UIImageView *chatImageView;
//聊天的时间
@property (strong, nonatomic) UILabel *dateLabel;
//下划线
@property (strong, nonatomic) UIImageView *lineImageView;

@end
