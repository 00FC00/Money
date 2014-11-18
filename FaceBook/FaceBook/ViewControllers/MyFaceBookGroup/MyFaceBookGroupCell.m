//
//  MyFaceBookGroupCell.m
//  FaceBook
//
//  Created by fengshaohui on 14-5-9.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "MyFaceBookGroupCell.h"
#import <QuartzCore/QuartzCore.h>
@implementation MyFaceBookGroupCell

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
    //cell背景
    _cellBackImageView = [[UIImageView alloc]initWithFrame:CGRectMake(6, 0, 308, 100/2)];
    _cellBackImageView.backgroundColor = [UIColor whiteColor];
    _cellBackImageView.userInteractionEnabled = YES;
    [self addSubview:_cellBackImageView];
    
    //群头像
    _groupImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20/2, 10/2, 80/2, 80/2)];
    _groupImageView.backgroundColor = [UIColor lightGrayColor];
    _groupImageView.userInteractionEnabled = YES;
    [_groupImageView.layer setMasksToBounds:YES];
    [_groupImageView.layer setCornerRadius:3.0f];
    [_cellBackImageView addSubview:_groupImageView];
    
    //群名称
    _groupNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(120/2, 16, 400/2, 18)];
    _groupNameLabel.backgroundColor =[UIColor clearColor];
    _groupNameLabel.font = [UIFont systemFontOfSize:16];
    _groupNameLabel.textAlignment = NSTextAlignmentLeft;
    _groupNameLabel.textColor = [UIColor darkGrayColor];
    [_cellBackImageView addSubview:_groupNameLabel];
    
    //底边线
    _bottomLineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, _cellBackImageView.frame.size.height-1, 600/2, 1)];
    _bottomLineImageView.userInteractionEnabled = YES;
    _bottomLineImageView.backgroundColor = [UIColor clearColor];
    [_cellBackImageView addSubview:_bottomLineImageView];
    
}
- (void)awakeFromNib
{
    // Initialization code
}
//- (void)drawRect:(CGRect)rect
//{
//    //NSLog(@"--gg%f",rect.size.height);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
//    CGContextFillRect(context, rect);
//    
//    //    //上分割线，
//    //    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
//    //    CGContextStrokeRect(context, CGRectMake(5, -1, rect.size.width - 10, 1));
//    
//    //下分割线
//    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:223.0f/255.0f green:223.0f/255.0f  blue:223.0f/255.0f  alpha:1.0].CGColor);
//    CGContextStrokeRect(context, CGRectMake(10, rect.size.height-1, rect.size.width-20 , 0.5));
//    
//    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:254.0f/255.0f green:254.0f/255.0f  blue:254.0f/255.0f  alpha:1.0].CGColor);
//    CGContextStrokeRect(context, CGRectMake(10, rect.size.height-0.5, rect.size.width-20 , 0.5));
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
