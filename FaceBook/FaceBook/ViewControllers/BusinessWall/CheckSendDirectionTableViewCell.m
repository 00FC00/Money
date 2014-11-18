//
//  CheckSendDirectionTableViewCell.m
//  FaceBook
//
//  Created by HMN on 14-6-24.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "CheckSendDirectionTableViewCell.h"

@implementation CheckSendDirectionTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self mark];
    }
    return self;
}

- (void)mark
{
    _photoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 112/2, 112/2)];
    _photoImageView.backgroundColor=[UIColor clearColor];
    [_photoImageView.layer setMasksToBounds:YES];
    [_photoImageView.layer setCornerRadius:3.0f];
    _photoImageView.userInteractionEnabled = YES;
    [self addSubview:_photoImageView];
    
    //名字
    _nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(172/2, 66/2, 286/2, 36/2)];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:_nameLabel];
    
    
    //下划线
    _lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 168/2, 600/2, 1)];
    _lineImageView.backgroundColor = [UIColor clearColor];
    _lineImageView.userInteractionEnabled = YES;
    [self addSubview:_lineImageView];
    
    //选中和未选中的图片
    self.selectedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(516/2, 54/2, 42/2, 42/2)];
    self.selectedImageView.image = [UIImage imageNamed:@""];
    [self addSubview:self.selectedImageView];
}

- (void) setChecked:(BOOL)checked
{
	if (checked)
	{
		self.selectedImageView.image = [UIImage imageNamed:@"registration_agreeImage_03@2x"];
	}
	else
	{
		self.selectedImageView.image = [UIImage imageNamed:@"registration_unAgreeImage_03@2x"];
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
