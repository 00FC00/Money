//
//  PictureDetialsViewController.h
//  FaceBook
//
//  Created by fengshaohui on 14-5-26.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureDetialsViewController : UIViewController
{
    //整体背景
    UIImageView *backImageView;
    
    //轮播图部分
    NSMutableDictionary *companyDictionary;
    NSMutableDictionary *myCompanyDiction;
    //轮播
    UIScrollView *imageScrollView;
    UIView *pageview;
    UIPageControl *pageControl;
    NSMutableArray *moreimageArray ;
    int TimeNum;
    BOOL Tend;

}
@property (nonatomic, nonatomic) NSString *myPage;
@property (strong, nonatomic) NSMutableArray *allPicArray;
@end
