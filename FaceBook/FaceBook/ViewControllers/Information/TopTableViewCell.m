//
//  TopTableViewCell.m
//  CircleTest
//
//  Created by 颜沛贤 on 14-6-25.
//  Copyright (c) 2014年 颜沛贤. All rights reserved.
//

#import "TopTableViewCell.h"

#define TopViewWidth self.frame.size.width-30


@implementation TopTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 1, TopViewWidth-66, 20)];
        self.contentLabel.font = [UIFont systemFontOfSize:13];
        self.contentLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.contentLabel];
        
        self.liuyanImageView = [[UIImageView alloc] initWithFrame:CGRectMake(TopViewWidth-50, (22-11.5)/2, 12, 11.5)];
        self.liuyanImageView.image = [UIImage imageNamed:@"liuyanbiaozhi"];
        [self addSubview:self.liuyanImageView];
        
        self.leaveWordLabel = [[UILabel alloc] initWithFrame:CGRectMake(TopViewWidth-35, 1, 27, 20)];
        self.leaveWordLabel.font = [UIFont systemFontOfSize:12];
        self.leaveWordLabel.backgroundColor = [UIColor clearColor];
        self.leaveWordLabel.textColor = [UIColor colorWithRed:163.0/255 green:192.0/255 blue:235.0/255 alpha:1.0];
        [self addSubview:self.leaveWordLabel];

        
    }
    return self;
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
