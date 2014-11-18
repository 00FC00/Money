//
//  MyActivityCell.m
//  FaceBook
//
//  Created by fengshaohui on 14-5-14.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "MyActivityCell.h"

@implementation MyActivityCell

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
    //self.高度-->210
    //cell背景cellBackImageView;
    _cellBackImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 300, 316/2)];
    _cellBackImageView.backgroundColor=[UIColor whiteColor];
    _cellBackImageView.userInteractionEnabled = YES;
    [self addSubview:_cellBackImageView];
    
    //图片
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 202/2, 316/2)];
    _headImageView.backgroundColor = [UIColor clearColor];
    [_cellBackImageView addSubview:_headImageView];
    
    //活动标题titleLabel;
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(214/2, 10, 368/2, 15)];
    _titleLabel.backgroundColor =[UIColor clearColor];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.textColor = [UIColor blackColor];
    [_cellBackImageView addSubview:_titleLabel];
    
    //时间
    _markDateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(210/2, 34, 30/2, 28/2)];
    _markDateImageView.backgroundColor = [UIColor clearColor];
    [_cellBackImageView addSubview:_markDateImageView];
    
    _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(244/2, 34, 338/2, 14)];
    _dateLabel.backgroundColor =[UIColor clearColor];
    _dateLabel.font = [UIFont systemFontOfSize:14];
    _dateLabel.textAlignment = NSTextAlignmentLeft;
    _dateLabel.textColor = [UIColor lightGrayColor];
    [_cellBackImageView addSubview:_dateLabel];
    
    //地点
    _markPlaceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(210/2, 54, 30/2, 32/2)];
    _markPlaceImageView.backgroundColor = [UIColor clearColor];
    [_cellBackImageView addSubview:_markPlaceImageView];
    
    //地点placeLabel;
    _placeLabel = [[UILabel alloc]initWithFrame:CGRectMake(244/2, 54, 338/2, 16)];
    _placeLabel.backgroundColor =[UIColor clearColor];
    _placeLabel.font = [UIFont systemFontOfSize:14];
    _placeLabel.textAlignment = NSTextAlignmentLeft;
    _placeLabel.textColor = [UIColor lightGrayColor];
    [_cellBackImageView addSubview:_placeLabel];

    //类型
    _markStyleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(210/2, 154/2, 30/2, 30/2)];
    _markStyleImageView.backgroundColor = [UIColor clearColor];
    [_cellBackImageView addSubview:_markStyleImageView];
   
    _styleLabel = [[UILabel alloc]initWithFrame:CGRectMake(244/2, 154/2, 338/2, 15)];
    _styleLabel.backgroundColor =[UIColor clearColor];
    _styleLabel.font = [UIFont systemFontOfSize:14];
    _styleLabel.textAlignment = NSTextAlignmentLeft;
    _styleLabel.textColor = [UIColor lightGrayColor];
    [_cellBackImageView addSubview:_styleLabel];
    
    //说明
    _markContenImageView = [[UIImageView alloc] initWithFrame:CGRectMake(210/2, 198/2, 30/2, 30/2)];
    _markContenImageView.backgroundColor = [UIColor clearColor];
    [_cellBackImageView addSubview:_markContenImageView];
    
    _markContentLabel = [[UILabel alloc]initWithFrame:CGRectMake(244/2, 198/2, 338/2, 15)];
    _markContentLabel.backgroundColor =[UIColor clearColor];
    _markContentLabel.font = [UIFont systemFontOfSize:14];
    _markContentLabel.textAlignment = NSTextAlignmentLeft;
    _markContentLabel.textColor = [UIColor lightGrayColor];
    [_cellBackImageView addSubview:_markContentLabel];

    _contentLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _contentLabel.backgroundColor =[UIColor clearColor];
    
    _contentLabel.font = [UIFont systemFontOfSize:12];
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    //66 122 256
    _contentLabel.textColor = [UIColor colorWithRed:98.0f/255.0f green:153.0f/255.0f blue:226.0f/255.0f alpha:1.0];
    [_cellBackImageView addSubview:_contentLabel];

    
    
    
   
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
