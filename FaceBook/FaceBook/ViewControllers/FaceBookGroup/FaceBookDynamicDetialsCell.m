//
//  FaceBookDynamicDetialsCell.m
//  FaceBook
//
//  Created by fengshaohui on 14-5-30.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "FaceBookDynamicDetialsCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation FaceBookDynamicDetialsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self mark];
    }
    return self;
}
- (void)mark
{
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20/2, 20/2, 132/2, 132/2)];
    _headImageView.layer.cornerRadius = 3;
    [_headImageView.layer setMasksToBounds:YES];
    [self addSubview:_headImageView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headImageView.frame.origin.x+_headImageView.frame.size.width+20/2, _headImageView.frame.origin.y, 200/2, 30/2)];
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.font = [UIFont systemFontOfSize:13];
    _nameLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_nameLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(394/2, _nameLabel.frame.origin.y, 200/2, 30/2)];
    _timeLabel.textColor = [UIColor colorWithRed:206.0f/255.0f green:206.0f/255.0f blue:206.0f/255.0f alpha:1];
    _timeLabel.font = [UIFont systemFontOfSize:13];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_timeLabel];
    
    _contentLable = [[UILabel alloc] initWithFrame:CGRectZero];
    _contentLable.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1];
    _contentLable.font = [UIFont systemFontOfSize:15];
    _contentLable.backgroundColor = [UIColor clearColor];
    [self addSubview:_contentLable];
    
    _lineImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
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
