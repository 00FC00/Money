//
//  InformationMainCell.m
//  FaceBook
//
//  Created by fengshaohui on 14-7-28.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "InformationMainCell.h"

@implementation InformationMainCell

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
    //cell背景cellBackImageView;
    _cellBackImageView=[[UIImageView alloc]initWithFrame:CGRectZero];
    _cellBackImageView.backgroundColor=[UIColor whiteColor];
    _cellBackImageView.userInteractionEnabled = YES;
    [self addSubview:_cellBackImageView];
    
    //咨询图片
    _pictureImageView = [[UIImageView alloc] init];
    _pictureImageView.backgroundColor = [UIColor clearColor];
    _pictureImageView.userInteractionEnabled = YES;
    [_cellBackImageView addSubview:_pictureImageView];
    
    _titleBackImageView = [[UIImageView alloc] init];
    _titleBackImageView.backgroundColor = [UIColor blackColor ];
    _titleBackImageView.alpha = 0.4;
    _titleBackImageView.userInteractionEnabled = YES;
    [_cellBackImageView addSubview:_titleBackImageView];
    
    //cell标题titleLabel;
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.backgroundColor =[UIColor clearColor];
    _titleLabel.font = [UIFont boldSystemFontOfSize:16];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.textColor = [UIColor whiteColor];
    [_titleBackImageView addSubview:_titleLabel];
    
    //赞图标
    _praiseImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20/2, 242/2+21/2, 35/2, 35/2)];
    _praiseImageView.backgroundColor = [UIColor clearColor];
    [_cellBackImageView addSubview:_praiseImageView];
    
    //赞 数量 label;
    _praiseLabel = [[UILabel alloc]initWithFrame:CGRectMake(64/2, 242/2+21/2 + 3, 50, 32/2)];
    _praiseLabel.backgroundColor =[UIColor clearColor];
    _praiseLabel.font = [UIFont boldSystemFontOfSize:10];
    _praiseLabel.textAlignment = NSTextAlignmentLeft;
    _praiseLabel.textColor = [UIColor grayColor];
    [_cellBackImageView addSubview:_praiseLabel];
    
    
    //评论图标markImageView;
    _markImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_praiseLabel.right, 242/2+21/2, 35/2, 35/2)];
    _markImageView.backgroundColor = [UIColor clearColor];
    [_cellBackImageView addSubview:_markImageView];
    
    //评论数量numberLabel;
    _numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(_markImageView.right + 5, 242/2+21/2 + 3, 50, 32/2)];
    _numberLabel.backgroundColor =[UIColor clearColor];
    _numberLabel.font = [UIFont boldSystemFontOfSize:10];
    _numberLabel.textAlignment = NSTextAlignmentLeft;
    _numberLabel.textColor = [UIColor grayColor];
    [_cellBackImageView addSubview:_numberLabel];
    
    
    //照片背景_commentBackImageView;
    _commentBackImageView = [[UIImageView alloc]init];
    _commentBackImageView.backgroundColor = [UIColor clearColor];
    _commentBackImageView.userInteractionEnabled = YES;
    [_cellBackImageView addSubview:_commentBackImageView];
    
    _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _moreButton.frame = CGRectZero;
    [_moreButton setBackgroundColor:[UIColor clearColor]];
    [_cellBackImageView addSubview:_moreButton];
    
    _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _commentButton.frame = CGRectZero;
    [_commentButton setBackgroundColor:[UIColor clearColor]];
    [_cellBackImageView addSubview:_commentButton];
    
    //评论框 和 点赞按钮背景view
    self.commentActionBackView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_FRAME_WIDTH, 40)];
    _commentActionBackView.backgroundColor = RGBCOLOR(238, 238, 238);
    _commentActionBackView.userInteractionEnabled = YES;
    [_cellBackImageView addSubview:_commentActionBackView];
    
    //圆圈
    UIImageView *quan = [[UIImageView alloc]initWithFrame:CGRectMake(0 - 2, 0, 96/2.f, 40)];
    quan.image = [UIImage imageNamed:@"quan"];
    quan.contentMode = UIViewContentModeCenter;
    [_commentActionBackView addSubview:quan];
    
    //点赞按钮
    self.zan_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _zan_btn.frame = quan.frame;
    [_zan_btn setImage:[UIImage imageNamed:@"zan_no"] forState:UIControlStateNormal];
    [_zan_btn setImage:[UIImage imageNamed:@"zan_yes"] forState:UIControlStateSelected];
    [_commentActionBackView addSubview:_zan_btn];
    
    CGFloat aWidth = DEVICE_FRAME_WIDTH - quan.width - 10;
    UIButton *input_btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    input_btn.frame = CGRectMake(_zan_btn.right, (40 - 26)/2.f, aWidth, 26);
    input_btn.layer.borderWidth = 0.5f;
    input_btn.layer.borderColor = RGBCOLOR(153, 153, 153).CGColor;
    input_btn.backgroundColor = [UIColor whiteColor];
    [input_btn setTitle:@"添加评论" forState:UIControlStateNormal];
    input_btn.titleLabel.font = [UIFont systemFontOfSize:10];
    input_btn.titleEdgeInsets = UIEdgeInsetsMake(0, - aWidth/2.f - 60 - 10, 0, 0);
    [input_btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_commentActionBackView addSubview:input_btn];

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
