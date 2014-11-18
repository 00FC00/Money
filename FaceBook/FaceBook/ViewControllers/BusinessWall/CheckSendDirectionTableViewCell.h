//
//  CheckSendDirectionTableViewCell.h
//  FaceBook
//
//  Created by HMN on 14-6-24.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckSendDirectionTableViewCell : UITableViewCell
{
    BOOL isSelected;
}
//cell的背景
@property (strong, nonatomic) UIImageView *lineImageView;
//头像
@property (strong, nonatomic) UIImageView *photoImageView;
//名字
@property (strong, nonatomic) UILabel *nameLabel;
//选择标记图片
@property (nonatomic,retain) UIImageView *selectedImageView;

- (void) setChecked:(BOOL)checked;

@end
