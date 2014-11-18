//
//  SettingCell.h
//  FaceBook
//
//  Created by fengshaohui on 14-5-11.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingCell : UITableViewCell

//cell背景
@property (strong, nonatomic) UIImageView *cellBackImageView;
//标题
@property (strong, nonatomic) UILabel *titleLabel;
//箭头
@property (strong, nonatomic) UIImageView *markImageView;
//下划线
@property (strong, nonatomic) UIImageView *lineImageView;

@end
