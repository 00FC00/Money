//
//  createActivityViewController.h
//  FaceBook
//
//  Created by fengshaohui on 14-5-21.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckActivityDateViewController.h"
#import "CheckActivityStyleViewController.h"
#import "CheckActivityCityViewController.h"
@interface createActivityViewController : UIViewController<UIScrollViewDelegate,checkDateDelegate,checkStyleDelegate,UITextViewDelegate,checkActivityCityDelegate>

@end
