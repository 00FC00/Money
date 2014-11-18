//
//  GoldcoinsTableViewCell.m
//  FaceBook
//
//  Created by HMN on 14-7-10.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "GoldcoinsTableViewCell.h"

@implementation GoldcoinsTableViewCell

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
    _goldcoinsLabel = [[UILabel alloc] initWithFrame:CGRectMake(40/2, 16/2, 160/2, 40/2)];
    _goldcoinsLabel.textColor = [UIColor colorWithRed:164.0f/225.0f green:192.0f/255.0f blue:235.0f/255.0f alpha:1];
    _goldcoinsLabel.font = [UIFont systemFontOfSize:14];
    _goldcoinsLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_goldcoinsLabel];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(300/2, 16/2, 130/2, 40/2)];
    _priceLabel.textColor = [UIColor colorWithRed:164.0f/225.0f green:192.0f/255.0f blue:235.0f/255.0f alpha:1];
    _priceLabel.font = [UIFont systemFontOfSize:14];
    _priceLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_priceLabel];
    
    _lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20/2, 68/2, 600/2, 1)];
    [self addSubview:_lineImageView];
    
    //选中和未选中的图片
    self.selectedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(516/2, 4/2, 74/2, 74/2)];
    self.selectedImageView.image = [UIImage imageNamed:@""];
    [self addSubview:self.selectedImageView];
    
}


- (void) setChecked:(BOOL)checked
{
	if (checked)
	{
		self.selectedImageView.image = [UIImage imageNamed:@"duihao1@2x"];
	}
	else
	{
		self.selectedImageView.image = [UIImage imageNamed:@""];
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
