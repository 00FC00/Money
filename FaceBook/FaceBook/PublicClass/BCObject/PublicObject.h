//
//  PublicObject.h
//  Education
//
//  Created by HMN on 13-12-5.
//  Copyright (c) 2013年 HMN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublicObject : NSObject

/*
 *  导航栏标题；
 */
+ (UIImageView *)navigationImageViewWithFrame:(CGRect)frame WithTitle:(NSString *)title;

/*
 *  页面背景图片；
 */
+ (UIImageView *)backgroundImageViewWithFrame:(CGRect)frame;

/*
 *  导航返回按钮；
 */
+ (UIButton *)backButtonWithFrame:(CGRect)frame;

/*
 *  导航右按钮；
 */
+ (UIButton *)rightButtonWithFrame:(CGRect)frame WithTitle:(NSString *)title;


@end
