//
//  CheckActivityCityViewController.h
//  FaceBook
//
//  Created by fengshaohui on 14-5-21.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol checkActivityCityDelegate<NSObject>

- (void)setActivityCityValueWith:(NSString *)cityDic;

@end

@interface CheckActivityCityViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *myCityTableView;
    
}
@property (strong, nonatomic) id<checkActivityCityDelegate>delegate;

@end
