//
//  InformationMainCell.m
//  FaceBook
//
//  Created by fengshaohui on 14-7-28.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "InformationMainCell.h"

@implementation InformationMainCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self marksCell];
    }
    return self;
}
- (void)marksCell
{
    //cell背景cellBackImageView;
    _cellBackImageView=[[UIImageView alloc]initWithFrame:CGRectZero];
    _cellBackImageView.backgroundColor=[UIColor whiteColor];
    _cellBackImageView.userInteractionEnabled = YES;
    [self addSubview:_cellBackImageView];
    
    //咨询图片
    _pictureImageView = [[UIImageView alloc] init];
    _pictureImageView.backgroundColor = [UIColor clearColor];
    _pictureImageView.userInteractionEnabled = YES;
    [_cellBackImageView addSubview:_pictureImageView];
    
    _titleBackImageView = [[UIImageView alloc] init];
    _titleBackImageView.backgroundColor = [UIColor blackColor ];
    _titleBackImageView.alpha = 0.4;
    _titleBackImageView.userInteractionEnabled = YES;
    [_cellBackImageView addSubview:_titleBackImageView];
    
    //cell标题titleLabel;
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.backgroundColor =[UIColor clearColor];
    _titleLabel.font = [UIFont boldSystemFontOfSize:16];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.textColor = [UIColor whiteColor];
    [_titleBackImageView addSubview:_titleLabel];
    
    
    //评论图标markImageView;
    _markImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20/2, 242/2+21/2, 35/2, 35/2)];
    _markImageView.backgroundColor = [UIColor clearColor];
    [_cellBackImageView addSubview:_markImageView];
    
    //评论数量numberLabel;
    _numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(64/2, 242/2+21/2, 280/2, 32/2)];
    _numberLabel.backgroundColor =[UIColor clearColor];
    _numberLabel.font = [UIFont boldSystemFontOfSize:13];
    _numberLabel.textAlignment = NSTextAlignmentLeft;
    _numberLabel.textColor = [UIColor blackColor];
    [_cellBackImageView addSubview:_numberLabel];
    
    //照片背景_commentBackImageView;
    _commentBackImageView = [[UIImageView alloc]init];
    _commentBackImageView.backgroundColor = [UIColor clearColor];
    _commentBackImageView.userInteractionEnabled = YES;
    [_cellBackImageView addSubview:_commentBackImageView];
    
    _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _moreButton.frame = CGRectZero;
    [_moreButton setBackgroundColor:[UIColor clearColor]];
    [_cellBackImageView addSubview:_moreButton];
    
    _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _commentButton.frame = CGRectZero;
    [_commentButton setBackgroundColor:[UIColor clearColor]];
    [_cellBackImageView addSubview:_commentButton];
    

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
