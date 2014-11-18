//
//  QRCodeDetialsViewController.h
//  LifeTogether
//
//  Created by fengshaohui on 14-3-25.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QRCodeDetialsViewController : UIViewController<UIWebViewDelegate,UIScrollViewDelegate>

    

@property (strong, nonatomic)NSString *detialsUrls;
@property (strong, nonatomic)NSString *detialsType;
@end
