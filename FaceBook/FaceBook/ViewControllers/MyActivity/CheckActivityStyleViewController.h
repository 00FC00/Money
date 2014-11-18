//
//  CheckActivityStyleViewController.h
//  FaceBook
//
//  Created by fengshaohui on 14-5-21.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol checkStyleDelegate<NSObject>

- (void)setStyleValueWith:(NSDictionary *)StyleDictionary;

@end

@interface CheckActivityStyleViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *checkStyleTableView;
    NSMutableArray *styleArray;
    
}

@property (strong, nonatomic) id<checkStyleDelegate>delegate;


@end
