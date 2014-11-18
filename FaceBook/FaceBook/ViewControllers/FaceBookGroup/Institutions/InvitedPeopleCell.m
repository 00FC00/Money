//
//  InvitedPeopleCell.m
//  FaceBook
//
//  Created by fengshaohui on 14-5-29.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "InvitedPeopleCell.h"
#import <QuartzCore/QuartzCore.h>
@implementation InvitedPeopleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        isSelected = NO;
        [self makeKit];
    }
    return self;
}
- (void)makeKit
{
    //cell背景cellBackImageView;
    _cellBackImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 174/2)];
    _cellBackImageView.backgroundColor = [UIColor clearColor];
    _cellBackImageView.userInteractionEnabled = YES;
    [self addSubview:_cellBackImageView];
    
    //头像pictureImageView;
    _pictureImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20/2, 14, 134/2, 134/2)];
    _pictureImageView.backgroundColor = [UIColor clearColor];
    _pictureImageView.userInteractionEnabled = YES;
    [_pictureImageView.layer setMasksToBounds:YES];
    [_pictureImageView.layer setCornerRadius:3.0f];
    [_cellBackImageView addSubview:_pictureImageView];
    
    //名字nameLabel;
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(172/2, 76/2, 340/2, 38/2)];
    _nameLabel.backgroundColor =[UIColor clearColor];
    _nameLabel.font = [UIFont systemFontOfSize:15];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.textColor = [UIColor blackColor];
    [_cellBackImageView addSubview:_nameLabel];
    
    //选中和未选中的图片
    self.selectedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(547/2, 30, 74/2, 74/2)];
    self.selectedImageView.image = [UIImage imageNamed:@""];
    [_cellBackImageView addSubview:self.selectedImageView];
    
    _lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(25, _cellBackImageView.frame.size.height-1, 548/2, 1)];
    _lineImageView.backgroundColor = [UIColor clearColor];
    _lineImageView.userInteractionEnabled = YES;
    [_cellBackImageView addSubview:_lineImageView];
}
- (void) setChecked:(BOOL)checked
{
	if (checked)
	{
		self.selectedImageView.image = [UIImage imageNamed:@"duihao1@2x"];
		//self.backgroundView.backgroundColor = [UIColor colorWithRed:198.0f/255.0f green:220.0f/255.0f blue:238.0f/255.0f alpha:1.0f];
	}
	else
	{
		self.selectedImageView.image = [UIImage imageNamed:@"duihao2@2x"];
		//self.backgroundView.backgroundColor = [UIColor colorWithRed:198.0f/255.0f green:220.0f/255.0f blue:238.0f/255.0f alpha:1.0f];
	}
	isSelected = checked;
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
