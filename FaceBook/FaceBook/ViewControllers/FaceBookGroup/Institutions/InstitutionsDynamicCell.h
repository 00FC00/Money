//
//  InstitutionsDynamicCell.h
//  FaceBook
//
//  Created by fengshaohui on 14-5-27.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstitutionsDynamicCell : UITableViewCell
//cell背景
@property (strong, nonatomic) UIImageView *cellBackImageView;
//头像背景
@property (strong, nonatomic) UIImageView *markHeaderBackImageView;
//头像
@property (strong, nonatomic) UIImageView *headerImageView;
//标题
@property (strong, nonatomic) UILabel *markTitleLabel;
//时间
@property (strong, nonatomic) UILabel *markTimeLabel;
//回复图标
@property (strong, nonatomic) UIImageView *replyImageView;
//内容
@property (strong, nonatomic) UILabel *contectLabel;
//照片背景
@property (strong, nonatomic) UIImageView *photoBackImageView;
//分割线
@property (strong, nonatomic) UIImageView *cutOffLineImageView;
@end
