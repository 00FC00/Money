//
//  ThemeGroupChatViewController.h
//  FaceBook
//
//  Created by fengshaohui on 14-5-27.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeGroupChatViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

//主题群id
@property (nonatomic, strong) NSString *themeIdString;

@end
