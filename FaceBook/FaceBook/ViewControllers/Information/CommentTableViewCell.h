//
//  CommentTableViewCell.h
//  FaceBook
//
//  Created by HMN on 14-6-26.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLable;
@property (nonatomic, strong) UIImageView *lineImageView;

@end
