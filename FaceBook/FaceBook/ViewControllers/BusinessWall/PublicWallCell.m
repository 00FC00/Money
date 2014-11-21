//
//  PublicWallCell.m
//  FaceBook
//
//  Created by fengshaohui on 14-5-19.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "PublicWallCell.h"
#define TEXT_COLOR RGBCOLOR(13,92,221)

@implementation PublicWallCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self myMarkCell];
    }
    return self;
}
- (void)myMarkCell
{
    //cell背景cellBackImageView;//174
    _cellBackImageView=[[UIImageView alloc]initWithFrame:CGRectZero];
    _cellBackImageView.backgroundColor=[UIColor clearColor];
    _cellBackImageView.userInteractionEnabled = YES;
    [self addSubview:_cellBackImageView];
    
    //头像headImageView;
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _headImageView.backgroundColor = [UIColor lightGrayColor];
    [_headImageView.layer setMasksToBounds:YES];
    [_headImageView.layer setCornerRadius:3.0f];
    [_cellBackImageView addSubview:_headImageView];
    
    //标题titleLabel;
    _titleLabel=[[UILabel alloc]init];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.textColor = TEXT_COLOR;
    _titleLabel.font = [UIFont systemFontOfSize:15];
    [_cellBackImageView addSubview:_titleLabel];
    
    //公司companyLabel;
    _companyLabel=[[UILabel alloc]initWithFrame:CGRectZero];
    _companyLabel.backgroundColor = [UIColor clearColor];
    _companyLabel.textAlignment = NSTextAlignmentLeft;
    _companyLabel.textColor = TEXT_COLOR;
    _companyLabel.font = [UIFont systemFontOfSize:13];
    [_cellBackImageView addSubview:_companyLabel];

    //部门departmentLabel;
//    _departmentLabel=[[UILabel alloc]initWithFrame:CGRectZero];
//    _departmentLabel.backgroundColor = [UIColor clearColor];
//    _departmentLabel.textAlignment = NSTextAlignmentLeft;
//    _departmentLabel.textColor = [UIColor blackColor];
//    _departmentLabel.font = [UIFont systemFontOfSize:13];
//    [_cellBackImageView addSubview:_departmentLabel];
//    
//    //认可numberLabel;
//    _numberLabel=[[UILabel alloc]initWithFrame:CGRectZero];
//    _numberLabel.backgroundColor = [UIColor clearColor];
//    _numberLabel.textAlignment = NSTextAlignmentLeft;
//    _numberLabel.textColor = [UIColor blackColor];
//    _numberLabel.font = [UIFont systemFontOfSize:13];
//    [_cellBackImageView addSubview:_numberLabel];

    //地点addressLabel;
    _addressLabel=[[UILabel alloc]initWithFrame:CGRectZero];
    _addressLabel.backgroundColor = [UIColor clearColor];
    _addressLabel.textAlignment = NSTextAlignmentLeft;
    _addressLabel.textColor = TEXT_COLOR;
    _addressLabel.font = [UIFont systemFontOfSize:13];
    [_cellBackImageView addSubview:_addressLabel];
    
    //标记字段markContentLabel;
    _markContentLabel=[[UILabel alloc]initWithFrame:CGRectZero];
    _markContentLabel.backgroundColor = [UIColor clearColor];
    _markContentLabel.textAlignment = NSTextAlignmentLeft;
    _markContentLabel.textColor = TEXT_COLOR;
    _markContentLabel.font = [UIFont systemFontOfSize:15];
    [_cellBackImageView addSubview:_markContentLabel];

    
    //内容contectLabel;
    _contectLabel=[[UILabel alloc]init];
    _contectLabel.backgroundColor = [UIColor clearColor];
    _contectLabel.textColor = [UIColor blackColor];
    _contectLabel.font = [UIFont systemFontOfSize:14];
    [_contectLabel setNumberOfLines:0];
    [_cellBackImageView addSubview:_contectLabel];
    
    //分割线
    _cutOffLineImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _cutOffLineImageView.backgroundColor = [UIColor clearColor];
    [_cellBackImageView addSubview:_cutOffLineImageView];
    
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
