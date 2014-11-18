//
//  AddressBookCell.h
//  FaceBook
//
//  Created by HMN on 14-6-25.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressBookCell : UITableViewCell
//cell背景
@property (strong, nonatomic) UIImageView *cellBackImageView;
//头像
@property (strong, nonatomic) UIImageView *pictureImageView;
//名字
@property (strong, nonatomic) UILabel *nameLabel;
//按钮
@property (strong, nonatomic) UIButton *myButton;

//按钮
@property (strong, nonatomic) UIButton *inviteButton;

@property (strong, nonatomic) UIImageView *lineImageView;

@end
