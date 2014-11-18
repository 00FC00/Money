//
//  InstitutionsDynamicCell.m
//  FaceBook
//
//  Created by fengshaohui on 14-5-27.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "InstitutionsDynamicCell.h"
#import <QuartzCore/QuartzCore.h>
@implementation InstitutionsDynamicCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self markMeCell];
    }
    return self;
}
- (void)markMeCell
{
    //cell背景cellBackImageView;
    _cellBackImageView=[[UIImageView alloc]init];
    _cellBackImageView.backgroundColor=[UIColor whiteColor];
    _cellBackImageView.userInteractionEnabled = YES;
    [self addSubview:_cellBackImageView];
    
    //头像背景markHeaderBackImageView;
    _markHeaderBackImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    _markHeaderBackImageView.backgroundColor=[UIColor whiteColor];
    _markHeaderBackImageView.userInteractionEnabled = YES;
    [_markHeaderBackImageView.layer setMasksToBounds:YES];
    [_markHeaderBackImageView.layer setCornerRadius:3.0f];
    [_cellBackImageView addSubview:_markHeaderBackImageView];
    
    //头像headerImageView;
    _headerImageView=[[UIImageView alloc]initWithFrame:CGRectMake(2, 2, 40, 40)];
    _headerImageView.backgroundColor=[UIColor whiteColor];
    _headerImageView.userInteractionEnabled = YES;
    [_headerImageView.layer setMasksToBounds:YES];
    [_headerImageView.layer setCornerRadius:1.0f];
    [_markHeaderBackImageView addSubview:_headerImageView];
    
    //标题markTitleLabel;
    _markTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(47, 18/2, 302/2, 38/2)];
    _markTitleLabel.backgroundColor = [UIColor clearColor];
    _markTitleLabel.textAlignment = NSTextAlignmentLeft;
    _markTitleLabel.textColor = [UIColor colorWithRed:129.0f/255.0f green:129.0f/255.0f blue:129.0f/255.0f alpha:1.0f];
    _markTitleLabel.font = [UIFont systemFontOfSize:16];
    [_cellBackImageView addSubview:_markTitleLabel];
    
    //时间markTimeLabel;
    _markTimeLabel=[[UILabel alloc]initWithFrame:CGRectMake(412/2, 22/2, 130/2, 28/2)];
    _markTimeLabel.backgroundColor = [UIColor clearColor];
    _markTimeLabel.textAlignment = NSTextAlignmentRight;
    _markTimeLabel.textColor = [UIColor lightGrayColor];
    _markTimeLabel.font = [UIFont systemFontOfSize:14];
    [_cellBackImageView addSubview:_markTimeLabel];
    
    //回复图标replyImageView;
    _replyImageView=[[UIImageView alloc]initWithFrame:CGRectMake(548/2, 22/2, 32/2, 32/2)];
    _replyImageView.backgroundColor=[UIColor clearColor];
    _replyImageView.userInteractionEnabled = YES;
    [_cellBackImageView addSubview:_replyImageView];
    
    //分割线
    _cutOffLineImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _cutOffLineImageView.backgroundColor = [UIColor clearColor];
    [_cellBackImageView addSubview:_cutOffLineImageView];
    
    //内容contectLabel;
    _contectLabel=[[UILabel alloc]initWithFrame:CGRectMake(47, 46, 252, 66/2)];
    _contectLabel.backgroundColor = [UIColor clearColor];
    _contectLabel.textAlignment = NSTextAlignmentLeft;
    _contectLabel.textColor = [UIColor lightGrayColor];
    _contectLabel.font = [UIFont systemFontOfSize:14];
    [_cellBackImageView addSubview:_contectLabel];
    
    //照片背景photoBackImageView;
    _photoBackImageView=[[UIImageView alloc]initWithFrame:CGRectZero];
    _photoBackImageView.backgroundColor=[UIColor clearColor];
    _photoBackImageView.userInteractionEnabled = YES;
    [_cellBackImageView addSubview:_photoBackImageView];
    
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
