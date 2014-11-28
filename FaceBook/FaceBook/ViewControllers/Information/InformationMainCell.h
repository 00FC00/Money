//
//  InformationMainCell.h
//  FaceBook
//
//  Created by fengshaohui on 14-7-28.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InformationMainCell : UITableViewCell
//cell背景
@property (strong, nonatomic) UIImageView *cellBackImageView;
//咨询图片
@property (strong, nonatomic) UIImageView *pictureImageView;
//标题背景
@property (strong, nonatomic) UIImageView *titleBackImageView;
//cell标题
@property (strong, nonatomic) UILabel *titleLabel;


//评论图标
@property (strong, nonatomic) UIImageView *markImageView;
//评论数量
@property (strong, nonatomic) UILabel *numberLabel;

//赞图标
@property (strong, nonatomic) UIImageView *praiseImageView;
//赞 数量
@property (strong, nonatomic) UILabel *praiseLabel;

//评论数量背景
@property (strong, nonatomic) UIImageView *commentBackImageView;

@property (strong, nonatomic) UIButton *moreButton;//详情
@property (strong, nonatomic) UIButton *commentButton;//评论

//评论触发区域背景

@property (strong, nonatomic) UIImageView *commentActionBackView;
@property (strong, nonatomic) UIButton *zan_btn;

@end
