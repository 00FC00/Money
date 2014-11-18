//
//  ThemeGroupChatCell.h
//  FaceBook
//
//  Created by fengshaohui on 14-5-29.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeGroupChatCell : UITableViewCell

//cell背景
@property (strong, nonatomic) UIImageView *cellBackImageView;
//群名
@property (strong, nonatomic) UILabel *groupNameLabel;
//人数
@property (strong, nonatomic) UILabel *numberLabel;

@property (strong, nonatomic) UIImageView *lineImageView;

@end
