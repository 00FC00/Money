//
//  InformationDetailViewController.h
//  FaceBook
//
//  Created by HMN on 14-6-26.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InformationDetailViewController : UIViewController
{
    //左按钮
    UIButton *leftButton;
    //右按钮
    UIButton *rightButton;
    //当前所在的页面数
    int nowPage;
    
    UIWebView *webView;
}

@property (nonatomic, strong) NSString *informationId;
@property (nonatomic, strong) NSString *informationTitle;
@property (nonatomic, strong) NSString *informationAddTime;

@property (nonatomic, strong) NSMutableDictionary *informationDic;

//所有的新闻数组
@property (strong, nonatomic) NSMutableArray *allNewsArray;
@property (assign) int nowPage;
@end
