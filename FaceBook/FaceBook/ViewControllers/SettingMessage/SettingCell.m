//
//  SettingCell.m
//  FaceBook
//
//  Created by fengshaohui on 14-5-11.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "SettingCell.h"

@implementation SettingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self cellMarks];
    }
    return self;
}
-(void)cellMarks
{
    //cell背景
    _cellBackImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 580/2, 86/2)];
    _cellBackImageView.backgroundColor = [UIColor clearColor];
    _cellBackImageView.userInteractionEnabled = YES;
    [self addSubview:_cellBackImageView];

    //标题
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(28/2, 13, 346/2, 18)];
    _titleLabel.backgroundColor =[UIColor clearColor];
    _titleLabel.font = [UIFont systemFontOfSize:16];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.textColor = [UIColor blackColor];
    [_cellBackImageView addSubview:_titleLabel];
    
    //箭头
    _markImageView = [[UIImageView alloc]initWithFrame:CGRectMake(528/2, 17, 23/2, 25/2)];
    _markImageView.backgroundColor = [UIColor clearColor];
    _markImageView.userInteractionEnabled = YES;
    [_cellBackImageView addSubview:_markImageView];
    
    //下划线
    _lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, _cellBackImageView.frame.size.height-1, _cellBackImageView.frame.size.width, 2/2)];
    _lineImageView.backgroundColor = [UIColor clearColor];
    _lineImageView.userInteractionEnabled = YES;
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
