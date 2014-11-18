//
//  WorkCityViewController.h
//  FaceBook
//
//  Created by 虞海云 on 14-5-6.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WorkCityDelegate <NSObject>

- (void)getWorkCity:(NSDictionary*)cityDict;

@end

@interface WorkCityViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableDictionary * _provinceDict;
}

@property (nonatomic,assign) id <WorkCityDelegate> delegete;

@end
