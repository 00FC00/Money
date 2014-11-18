//
//  WallDetialswCell.m
//  FaceBook
//
//  Created by fengshaohui on 14-5-19.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "WallDetialswCell.h"

@implementation WallDetialswCell

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
    //头像
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30/2, 2/2, 65/2, 65/2)];
    _headImageView.backgroundColor  = [UIColor clearColor];
    [_headImageView.layer setMasksToBounds:YES];
    [_headImageView.layer setCornerRadius:3.0f];
    _headImageView.userInteractionEnabled = YES;
    [self addSubview:_headImageView];
    
    //头像按钮
    _headButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _headButton.frame = CGRectMake(0, 0, 65/2, 65/2);
    _headButton.backgroundColor = [UIColor clearColor];
    [_headImageView addSubview:_headButton];
    
    _wcontectLabel=[[UILabel alloc]init];
    _wcontectLabel.backgroundColor = [UIColor clearColor];
    _wcontectLabel.textAlignment = NSTextAlignmentLeft;
    _wcontectLabel.textColor = [UIColor blackColor];
    _wcontectLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:_wcontectLabel];
    
    //下划线
    _lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, self.frame.size.height-1, 600/2, 1)];
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
