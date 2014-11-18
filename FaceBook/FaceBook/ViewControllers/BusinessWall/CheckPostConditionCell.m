//
//  CheckPostConditionCell.m
//  FaceBook
//
//  Created by fengshaohui on 14-5-20.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "CheckPostConditionCell.h"

@implementation CheckPostConditionCell

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
    _wcontectLabel=[[UILabel alloc]initWithFrame:CGRectMake(72/2, 17, 462/2, 34/2)];
    _wcontectLabel.backgroundColor = [UIColor clearColor];
    _wcontectLabel.textAlignment = NSTextAlignmentLeft;
    _wcontectLabel.textColor = [UIColor colorWithRed:119.0f/255.0f green:153.0f/255.0f blue:208.0f/255.0f alpha:1.0];
    
    _wcontectLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:_wcontectLabel];
    
    //下划线
    _lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 88/2, 280, 1)];
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
