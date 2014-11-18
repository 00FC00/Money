//
//  MyActivityCell.h
//  FaceBook
//
//  Created by fengshaohui on 14-5-14.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyActivityCell : UITableViewCell
//cell背景
@property (strong, nonatomic) UIImageView *cellBackImageView;

//活动图像
@property (strong, nonatomic) UIImageView *headImageView;

//活动标题
@property (strong, nonatomic) UILabel *titleLabel;

//时间标记字段
@property (strong, nonatomic) UIImageView *markDateImageView;
//时间
@property (strong, nonatomic) UILabel *dateLabel;

//地点标记字段
@property (strong, nonatomic) UIImageView *markPlaceImageView;
//地点
@property (strong, nonatomic) UILabel *placeLabel;

//活动类型标记图片
@property (strong, nonatomic) UIImageView *markStyleImageView;
//费用类型
@property (strong, nonatomic) UILabel *styleLabel;

//说明图片
@property (strong, nonatomic) UIImageView *markContenImageView;
//说明标记字段
@property (strong, nonatomic) UILabel *markContentLabel;
//说明
@property (strong, nonatomic) UILabel *contentLabel;


@end
