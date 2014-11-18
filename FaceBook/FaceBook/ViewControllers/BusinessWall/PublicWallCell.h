//
//  PublicWallCell.h
//  FaceBook
//
//  Created by fengshaohui on 14-5-19.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublicWallCell : UITableViewCell

//cell背景
@property (strong, nonatomic) UIImageView *cellBackImageView;
//头像
@property (strong, nonatomic) UIImageView *headImageView;

//标题
@property (strong, nonatomic) UILabel *titleLabel;
//公司
@property (strong, nonatomic) UILabel *companyLabel;
//部门
@property (strong, nonatomic) UILabel *departmentLabel;
//认可
@property (strong, nonatomic) UILabel *numberLabel;
//地点
@property (strong, nonatomic) UILabel *addressLabel;
//标记字段
@property (strong, nonatomic) UILabel *markContentLabel;

//内容
@property (strong, nonatomic) UILabel *contectLabel;
//分割线
@property (strong, nonatomic) UIImageView *cutOffLineImageView;

@end
