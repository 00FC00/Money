//
//  ActivityDetialsViewController.h
//  FaceBook
//
//  Created by fengshaohui on 14-5-21.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityDetialsViewController : UIViewController<UIScrollViewDelegate>
@property (strong, nonatomic) NSString *permissionStr;
@property (strong, nonatomic) NSString *activityId;
@property (strong, nonatomic) NSString *userIDstr;
@end
