//
//  FaceBookLineCell.h
//  FaceBook
//
//  Created by fengshaohui on 14-5-26.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FaceBookLineCell : UITableViewCell

//cell背景
@property (strong, nonatomic) UIImageView *cellBackImageView;
//头像
@property (strong, nonatomic) UIImageView *headerImageView;
//标题
@property (strong, nonatomic) UILabel *titleLabel;
//人数
@property (strong, nonatomic) UILabel *peopleNumberLabel;
//访客
@property (strong, nonatomic) UILabel *visiterLabel;
//添加按钮
@property (strong, nonatomic) UIButton *addButton;
//下划线
@property (strong, nonatomic) UIImageView *bottomImageView;

@end
