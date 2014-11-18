//
//  PublicObject.m
//  Education
//
//  Created by HMN on 13-12-5.
//  Copyright (c) 2013年 HMN. All rights reserved.
//

#import "PublicObject.h"

@implementation PublicObject

/*
 *  导航栏标题；
 */
+ (UIImageView *)navigationImageViewWithFrame:(CGRect)frame WithTitle:(NSString *)title
{
    UIImageView *navigationImageView = [[UIImageView alloc] initWithFrame:frame];
    navigationImageView.userInteractionEnabled = YES;
    [navigationImageView setImage:[UIImage imageNamed:@"navbeijing@2x"]];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:19];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    [navigationImageView addSubview:titleLabel];
    
    return navigationImageView;
}

/*
 *  页面背景图片；
 */
+ (UIImageView *)backgroundImageViewWithFrame:(CGRect)frame
{
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:frame];
    backgroundImageView.userInteractionEnabled = YES;
    [backgroundImageView setImage:[UIImage imageNamed:@""]];
    return backgroundImageView;
}

/*
 *  导航返回按钮；
 */
+ (UIButton *)backButtonWithFrame:(CGRect)frame
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = frame;
    [backButton setBackgroundImage:[UIImage imageNamed:@"fanhui@2x"] forState:UIControlStateNormal];
    
    return backButton;
}
/*
 *  导航右按钮；
 */
+ (UIButton *)rightButtonWithFrame:(CGRect)frame WithTitle:(NSString *)title
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = frame;
    [rightButton setBackgroundImage:[UIImage imageNamed:@"rightanniu@2x"] forState:UIControlStateNormal];
    [rightButton setTitle:title forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    
    return rightButton;
}
@end
