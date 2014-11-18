//
//  MessageListTableViewCell.m
//  FaceBook
//
//  Created by fengshaohui on 14-5-16.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "MessageListTableViewCell.h"

@implementation MessageListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self cellmark];
    }
    return self;
}
- (void)cellmark
{
    _cellBackImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 72/2)];
    _cellBackImageView.backgroundColor=[UIColor clearColor];
    _cellBackImageView.userInteractionEnabled = YES;
    [self addSubview:_cellBackImageView];
    
    //_contactLabel
    _contactLabel=[[UILabel alloc]initWithFrame:CGRectMake(22, 15, 416/2, 34/2)];
    _contactLabel.backgroundColor = [UIColor clearColor];
    _contactLabel.textAlignment = NSTextAlignmentLeft;
    _contactLabel.textColor = [UIColor blackColor];
    _contactLabel.font = [UIFont systemFontOfSize:15];
    [_cellBackImageView addSubview:_contactLabel];
    
    //passButton
    _passButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _passButton.frame = CGRectMake(474/2, 0, 70/2, 72/2);
//    [_passButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    _passButton.titleLabel.font = [UIFont systemFontOfSize:16];
    _passButton.backgroundColor = [UIColor clearColor];
    [_cellBackImageView addSubview:_passButton];
    
    //refuseButton
    _refuseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _refuseButton.frame = CGRectMake(552/2, 0, 70/2, 72/2);
    //    [_refuseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    _refuseButton.titleLabel.font = [UIFont systemFontOfSize:16];
    _refuseButton.backgroundColor = [UIColor clearColor];
    [_cellBackImageView addSubview:_refuseButton];

    
    //_lineImageView
    _lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(22, _cellBackImageView.frame.size.height-1, 556/2, 1)];
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
