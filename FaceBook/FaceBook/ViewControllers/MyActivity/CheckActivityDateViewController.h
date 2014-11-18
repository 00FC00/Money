//
//  CheckActivityDateViewController.h
//  FaceBook
//
//  Created by fengshaohui on 14-5-21.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol checkDateDelegate<NSObject>

- (void)setDateValueWith:(NSDictionary *)dateDictionary;

@end

@interface CheckActivityDateViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *checkDateTableView;
    NSMutableArray *dateArray;
}

@property (strong, nonatomic) id<checkDateDelegate>delegate;

//活动类型id
@property (strong, nonatomic) NSString *styleId;

@end
