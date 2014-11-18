//
//  ProjectExperienceViewController.h
//  FaceBook
//
//  Created by 虞海云 on 14-5-6.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectExperienceViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate>

@property (strong, nonatomic)UITextView* contentTextView;
@property (strong, nonatomic)UILabel* placeHolderLabel;
@property (strong, nonatomic)NSString *editStyle;//标识出来是修改还是新加的

@property (strong, nonatomic) NSDictionary *projectDiction;
@end
