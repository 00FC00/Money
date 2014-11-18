//
//  LineMemberCell.m
//  FaceBook
//
//  Created by fengshaohui on 14-5-29.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "LineMemberCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation LineMemberCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self markCellKit];
    }
    return self;
}
- (void)markCellKit
{
    
    //头像headerImageView;
    _headerImageView=[[UIImageView alloc]initWithFrame:CGRectMake(20/2, 20/2, 132/2, 132/2)];
    _headerImageView.backgroundColor=[UIColor clearColor];
    _headerImageView.userInteractionEnabled = YES;
    [_headerImageView.layer setMasksToBounds:YES];
    [_headerImageView.layer setCornerRadius:3.0f];
    [self addSubview:_headerImageView];
    
    //头像button
    _headButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _headButton.frame = CGRectMake(0, 0, 132/2, 132/2);
    [_headerImageView addSubview:_headButton];
    
    //标题titleLabel;
    _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(_headerImageView.frame.origin.x+_headerImageView.frame.size.width+20/2, 42/2, 430/2, 46/2)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:_titleLabel];
    
    //公司
    _companyLabel=[[UILabel alloc]initWithFrame:CGRectMake(_headerImageView.frame.origin.x+_headerImageView.frame.size.width+20/2, 88/2, 430/2, 40/2)];
    _companyLabel.backgroundColor = [UIColor clearColor];
    _companyLabel.textColor = [UIColor colorWithRed:53.0f/255.0f green:53.0f/255.0f blue:53.0f/255.0f alpha:1];
    _companyLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_companyLabel];

    //line
    _lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20/2, 169/2, 300, 1)];
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
