//
//  NewFriendsCell.m
//  FaceBook
//
//  Created by fengshaohui on 14-5-13.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "NewFriendsCell.h"
#import <QuartzCore/QuartzCore.h>
@implementation NewFriendsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self cellForMe];
    }
    return self;
}
- (void)cellForMe
{
    _cellBackImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 170/2)];
    _cellBackImageView.backgroundColor=[UIColor clearColor];
    _cellBackImageView.userInteractionEnabled = YES;
    [self addSubview:_cellBackImageView];

    _photoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 132/2, 132/2)];
    _photoImageView.backgroundColor=[UIColor clearColor];
    [_photoImageView.layer setMasksToBounds:YES];
    [_photoImageView.layer setCornerRadius:3.0f];
    _photoImageView.userInteractionEnabled = YES;
    [_cellBackImageView addSubview:_photoImageView];
    //头像
    _photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _photoButton.frame = CGRectMake(0, 0, 132/2, 132/2);
    _photoButton.backgroundColor = [UIColor clearColor];
    [_photoButton.layer setMasksToBounds:YES];
    [_photoButton.layer setCornerRadius:3.0f];
    [_photoImageView addSubview:_photoButton];
    
    //名字
    _nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(172/2, 36/2, 286/2, 40/2)];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.font = [UIFont systemFontOfSize:18];
    [_cellBackImageView addSubview:_nameLabel];
    
    _infoLabel=[[UILabel alloc]initWithFrame:CGRectMake(172/2, 100/2, 286/2, 34/2)];
    _infoLabel.backgroundColor = [UIColor clearColor];
    _infoLabel.textAlignment = NSTextAlignmentLeft;
    _infoLabel.textColor = [UIColor blackColor];
    _infoLabel.font = [UIFont systemFontOfSize:16];
    [_cellBackImageView addSubview:_infoLabel];
    
    //按钮
    _passButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _passButton.frame = CGRectMake(462/2, 58/2, 152/2, 56/2);
    [_passButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _passButton.titleLabel.font = [UIFont systemFontOfSize:15];
    _passButton.backgroundColor = [UIColor clearColor];
    [_cellBackImageView addSubview:_passButton];
    
    //下划线
    _lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, _cellBackImageView.frame.size.height-1, 600/2, 1)];
    _lineImageView.backgroundColor = [UIColor clearColor];
    _lineImageView.userInteractionEnabled = YES;
    [_cellBackImageView addSubview:_lineImageView];
}
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
