//
//  CheckPostConditionViewController.h
//  FaceBook
//
//  Created by fengshaohui on 14-5-20.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol checkDelegate<NSObject>

- (void)setStyleValueWith:(NSDictionary *)styleDic;
- (void)setIdentityValueWith:(NSString *)identityStr;

@end

@interface CheckPostConditionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSString *checkStr;
@property (nonatomic, strong) NSString *mycellCheck;

@property (strong, nonatomic) id<checkDelegate>delegate;
@end
