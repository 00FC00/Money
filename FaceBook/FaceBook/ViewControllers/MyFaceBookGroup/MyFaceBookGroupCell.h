//
//  MyFaceBookGroupCell.h
//  FaceBook
//
//  Created by fengshaohui on 14-5-9.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyFaceBookGroupCell : UITableViewCell
//cell背景
@property (strong, nonatomic) UIImageView *cellBackImageView;
//群头像
@property (strong, nonatomic) UIImageView *groupImageView;
//群名称
@property (strong, nonatomic) UILabel *groupNameLabel;
//底边线
@property (strong, nonatomic) UIImageView *bottomLineImageView;

@end
