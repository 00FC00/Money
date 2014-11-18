//
//  InstitutionsFaceBookViewController.h
//  FaceBook
//
//  Created by fengshaohui on 14-5-27.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstitutionsFaceBookViewController : UIViewController<UIScrollViewDelegate>
{
    UIScrollView * _mainScrollView;
    
    CGSize finSize;
    UIImageView * imageView;
    UITapGestureRecognizer * imageTap;
    
    CGFloat coord_x;///圆心x的坐标
    CGFloat coord_y;///圆心y的坐标
}

@end
