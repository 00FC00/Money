//
//  ContactPeopleCell.m
//  FaceBook
//
//  Created by fengshaohui on 14-5-13.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "ContactPeopleCell.h"

@implementation ContactPeopleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self marksMyCell];
    }
    return self;
}
- (void)marksMyCell
{
    _cellBackImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 76/2)];
    _cellBackImageView.backgroundColor=[UIColor clearColor];
    _cellBackImageView.userInteractionEnabled = YES;
    [self addSubview:_cellBackImageView];
    
    self.photoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(28, 6, 28, 28)];
    self.photoImageView.backgroundColor=[UIColor clearColor];
    self.photoImageView.userInteractionEnabled = YES;
    [_cellBackImageView addSubview:self.photoImageView];
    
    self.titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(70, 11, 200, 32/2)];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    [_cellBackImageView addSubview:self.titleLabel];
    
    _lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(25, 78/2, 548/2, 1)];
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
