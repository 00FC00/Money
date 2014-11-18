//
//  LineMainMemberCell.m
//  FaceBook
//
//  Created by fengshaohui on 14-8-1.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "LineMainMemberCell.h"
#import <QuartzCore/QuartzCore.h>
@implementation LineMainMemberCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //背景图
        self.cellBackImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.cellBackImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.cellBackImageView];
        
        //头像
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _headImageView.backgroundColor = [UIColor clearColor];
        [_headImageView.layer setMasksToBounds:YES];
        [_headImageView.layer setCornerRadius:8.0f];
        [self addSubview:_headImageView];
        
        //名字
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_nameLabel];

    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
