//
//  FriendsCircleCell.h
//  FaceBook
//
//  Created by fengshaohui on 14-5-22.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttributedLabel.h"
@interface FriendsCircleCell : UITableViewCell
//用户的头像背景
@property (strong, nonatomic) UIImageView *marksImageView;
//用户头像
@property (strong, nonatomic) UIImageView *userImageView;
@property (strong, nonatomic) UIButton *userImageButton;
//名字
@property (strong, nonatomic) UILabel *userNameLabel;
//时间
@property (strong, nonatomic) UILabel *postDateTimeLabel;
//横线
@property (strong, nonatomic) UIImageView *horizontalLineImageView;
//照片背景
@property (strong, nonatomic) UIImageView *photoBackImageView;
//说说内容
@property (strong, nonatomic) UILabel *messageLabel;
//操作按钮
@property (strong, nonatomic) UIButton *operationButton;
//操作框
@property (strong, nonatomic) UIImageView *operationBackImageView;
//评论
@property (strong, nonatomic) UIButton *commentButton;
//赞
@property (strong, nonatomic) UIButton *lovesButton;
//评论背景
@property (strong, nonatomic) UIImageView *commentsBackImageView;
//@property (strong, nonatomic) AttributedLabel *commentContentLabel;
//竖线
//@property (strong, nonatomic) UIImageView *verticalLineImageView;

//显示操作框
- (void)showOperationBackImageView;
//隐藏操作框
- (void)hidenOperationBackImageView;

@end
