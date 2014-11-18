//
//  GoldBuyVisitedStatusCell.m
//  FaceBook
//
//  Created by fengshaohui on 14-7-1.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "GoldBuyVisitedStatusCell.h"

@implementation GoldBuyVisitedStatusCell

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
    _contectLabel=[[UILabel alloc]initWithFrame:CGRectMake(72/2, 11, 500/2, 34/2)];
    _contectLabel.backgroundColor = [UIColor clearColor];
    _contectLabel.textAlignment = NSTextAlignmentLeft;
    _contectLabel.textColor = [UIColor blackColor];
    
    _contectLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_contectLabel];
    
    //下划线
    _lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 70/2, 280, 1)];
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
