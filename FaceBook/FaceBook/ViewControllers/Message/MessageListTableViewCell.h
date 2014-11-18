//
//  MessageListTableViewCell.h
//  FaceBook
//
//  Created by fengshaohui on 14-5-16.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageListTableViewCell : UITableViewCell
@property (strong, nonatomic) UIImageView *cellBackImageView;
@property (strong, nonatomic) UILabel *contactLabel;
@property (strong, nonatomic) UIButton *passButton;
@property (strong, nonatomic) UIButton *refuseButton;
@property (strong, nonatomic) UIImageView *lineImageView;
@end
