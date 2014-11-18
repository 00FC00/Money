//
//  LoginViewController.h
//  FaceBook
//
//  Created by HMN on 14-4-25.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) NSString *isNotFirst;

@property (nonatomic, strong) NSString *fromString;

@end
