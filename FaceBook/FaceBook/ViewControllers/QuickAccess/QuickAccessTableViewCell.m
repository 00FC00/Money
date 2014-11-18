//
//  QuickAccessTableViewCell.m
//  FaceBook
//
//  Created by HMN on 14-7-4.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "QuickAccessTableViewCell.h"

@implementation QuickAccessTableViewCell

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
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(80/2, 30/2, 40/2, 40/2)];
    [self addSubview:_headImageView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(148/2, 32/2, 300/2, 34/2)];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_titleLabel];
    
    //bottomXian
    _lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(53/2, 78/2, 545/2, 1)];
    [self.contentView addSubview:_lineImageView];
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
