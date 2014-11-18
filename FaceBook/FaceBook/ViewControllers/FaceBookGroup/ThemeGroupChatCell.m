//
//  ThemeGroupChatCell.m
//  FaceBook
//
//  Created by fengshaohui on 14-5-29.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "ThemeGroupChatCell.h"

@implementation ThemeGroupChatCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self cellMarks];
    }
    return self;
}
- (void)cellMarks
{
    //cell背景cellBackImageView;
    _cellBackImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 68/2)];
    _cellBackImageView.backgroundColor=[UIColor clearColor];
    _cellBackImageView.userInteractionEnabled = YES;
    [self addSubview:_cellBackImageView];
    
    //群名groupNameLabel;
    _groupNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(40/2, 20/2, 442/2, 32/2)];
    _groupNameLabel.backgroundColor = [UIColor clearColor];
    _groupNameLabel.textAlignment = NSTextAlignmentLeft;
    _groupNameLabel.textColor = [UIColor colorWithRed:71.0f/255.0f green:71.0f/255.0f blue:72.0f/255.0f alpha:1];
    _groupNameLabel.font = [UIFont systemFontOfSize:15];
    [_cellBackImageView addSubview:_groupNameLabel];
    
    //人数numberLabel;
    _numberLabel=[[UILabel alloc]initWithFrame:CGRectMake(484/2, 20/2, 130/2, 32/2)];
    _numberLabel.backgroundColor = [UIColor clearColor];
    _numberLabel.textAlignment = NSTextAlignmentRight;
    _numberLabel.textColor = [UIColor colorWithRed:71.0f/255.0f green:71.0f/255.0f blue:72.0f/255.0f alpha:1];
    _numberLabel.font = [UIFont systemFontOfSize:15];
    [_cellBackImageView addSubview:_numberLabel];
    
    _lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10,_cellBackImageView.frame.size.height-1, 600/2, 1)];
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
