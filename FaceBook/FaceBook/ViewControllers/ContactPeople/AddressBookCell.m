//
//  AddressBookCell.m
//  FaceBook
//
//  Created by HMN on 14-6-25.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "AddressBookCell.h"
#import <QuartzCore/QuartzCore.h>
@implementation AddressBookCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self cellmeMarks];
    }
    return self;
}
- (void)cellmeMarks
{
    //cell背景cellBackImageView;
    _cellBackImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 144/2)];
    _cellBackImageView.backgroundColor = [UIColor clearColor];
    _cellBackImageView.userInteractionEnabled = YES;
    [self addSubview:_cellBackImageView];
    
    //头像pictureImageView;
    _pictureImageView = [[UIImageView alloc]initWithFrame:CGRectMake(16/2, 7, 114/2, 114/2)];
    _pictureImageView.backgroundColor = [UIColor clearColor];
    _pictureImageView.userInteractionEnabled = YES;
    [_pictureImageView.layer setMasksToBounds:YES];
    [_pictureImageView.layer setCornerRadius:8.0f];
    [_cellBackImageView addSubview:_pictureImageView];
    
    
    //名字nameLabel;
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(140/2, 54/2, 350/2, 30/2)];
    _nameLabel.backgroundColor =[UIColor clearColor];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.textColor = [UIColor blackColor];
    [_cellBackImageView addSubview:_nameLabel];
    
    //按钮_myButton
    _myButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _myButton.frame = CGRectMake(470/2, 44/2, 152/2, 56/2);
    _myButton.backgroundColor = [UIColor clearColor];
    _myButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [_myButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:_myButton];
    
    
    //按钮_myButton
    _inviteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _inviteButton.frame = CGRectMake(480/2, 42/2, 137/2, 58/2);
    _inviteButton.backgroundColor = [UIColor clearColor];
    _inviteButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [_inviteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:_inviteButton];
    
    _lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 142/2, 320, 1)];
    [self addSubview:_lineImageView];
    
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
