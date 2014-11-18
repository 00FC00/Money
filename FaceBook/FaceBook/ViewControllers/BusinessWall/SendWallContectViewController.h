//
//  SendWallContectViewController.h
//  FaceBook
//
//  Created by fengshaohui on 14-5-20.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckPostConditionViewController.h"
@interface SendWallContectViewController : UIViewController<UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate,checkDelegate>

@property (nonatomic, strong) NSString *titleString;
@property (nonatomic, strong) NSMutableDictionary *wallDetailDic;

@end
