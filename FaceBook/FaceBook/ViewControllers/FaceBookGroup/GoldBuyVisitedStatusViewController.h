//
//  GoldBuyVisitedStatusViewController.h
//  FaceBook
//
//  Created by fengshaohui on 14-7-1.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol checkgoldDelegate<NSObject>

- (void)setStyleValueWith:(NSString *)goldStyle;


@end


@interface GoldBuyVisitedStatusViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *checkTableView;
//    NSMutableArray *checkArray;
    NSIndexPath *lastIndexPath;
    UIButton *finishButton;
    NSString *checkStr;
}

@property (strong, nonatomic) NSDictionary *diction;

@property (strong, nonatomic) id<checkgoldDelegate>delegate;


@end
