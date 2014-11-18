//
//  LineMemberCell.h
//  FaceBook
//
//  Created by fengshaohui on 14-5-29.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineMemberCell : UITableViewCell
//头像
@property (strong, nonatomic) UIImageView *headerImageView;
@property (strong, nonatomic) UIButton *headButton;

//标题
@property (strong, nonatomic) UILabel *titleLabel;
//公司
@property (strong, nonatomic) UILabel *companyLabel;

//line
@property (strong, nonatomic) UIImageView *lineImageView;

@end
