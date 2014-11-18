//
//  FaceBookLineCell.m
//  FaceBook
//
//  Created by fengshaohui on 14-5-26.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "FaceBookLineCell.h"
#import <QuartzCore/QuartzCore.h>
@implementation FaceBookLineCell

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
    _cellBackImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 300, 120/2)];
    _cellBackImageView.backgroundColor=[UIColor whiteColor];
    _cellBackImageView.userInteractionEnabled = YES;
    [self addSubview:_cellBackImageView];
    
    //头像headerImageView;
    _headerImageView=[[UIImageView alloc]initWithFrame:CGRectMake(20/2, 10/2, 80/2, 80/2)];
    _headerImageView.backgroundColor=[UIColor clearColor];
    _headerImageView.userInteractionEnabled = YES;
    [_headerImageView.layer setMasksToBounds:YES];
    [_headerImageView.layer setCornerRadius:3.0f];
    [_cellBackImageView addSubview:_headerImageView];
    
    //标题titleLabel;
    _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(120/2, 16, 400/2, 18)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.font = [UIFont systemFontOfSize:16];
    [_cellBackImageView addSubview:_titleLabel];

    //人数peopleNumberLabel;
    _peopleNumberLabel=[[UILabel alloc]initWithFrame:CGRectMake(150/2, 84/2, 192/2, 32/2)];
    _peopleNumberLabel.backgroundColor = [UIColor clearColor];
    _peopleNumberLabel.textAlignment = NSTextAlignmentLeft;
    _peopleNumberLabel.textColor = [UIColor lightGrayColor];
    _peopleNumberLabel.font = [UIFont systemFontOfSize:15];
    [_cellBackImageView addSubview:_peopleNumberLabel];

    //访客visiterLabel;
    _visiterLabel=[[UILabel alloc]initWithFrame:CGRectMake(342/2, 84/2, 170/2, 32/2)];
    _visiterLabel.backgroundColor = [UIColor clearColor];
    _visiterLabel.textAlignment = NSTextAlignmentLeft;
    _visiterLabel.textColor = [UIColor lightGrayColor];
    _visiterLabel.font = [UIFont systemFontOfSize:15];
    [_cellBackImageView addSubview:_visiterLabel];
    
    //添加按钮addButton;
    _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _addButton.frame = CGRectMake(520/2, 20/2, 80/2, 80/2);
    [_addButton setBackgroundColor:[UIColor clearColor]];
    [_addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _addButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_cellBackImageView addSubview:_addButton];
    
    //下划线
    _bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(3, _cellBackImageView.frame.size.height-1, _cellBackImageView.frame.size.width-6, 1)];
    _bottomImageView.backgroundColor = [UIColor clearColor];
    [_cellBackImageView addSubview:_bottomImageView];
    
    
    
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
