//
//  LineGroupChatViewController.h
//  FaceBook
//
//  Created by fengshaohui on 14-5-27.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineGroupChatViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

//条线群id
@property (nonatomic, strong) NSString *departmentIdString;

@end
