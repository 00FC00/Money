//
//  InvitedPeopleCell.h
//  FaceBook
//
//  Created by fengshaohui on 14-5-29.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvitedPeopleCell : UITableViewCell
{
    BOOL isSelected;
}
//cell背景
@property (strong, nonatomic) UIImageView *cellBackImageView;
//头像
@property (strong, nonatomic) UIImageView *pictureImageView;
//名字
@property (strong, nonatomic) UILabel *nameLabel;
//选择的标记图片
@property (nonatomic,retain) UIImageView *selectedImageView;
@property (strong, nonatomic) UIImageView *lineImageView;

- (void) setChecked:(BOOL)checked;

@end
