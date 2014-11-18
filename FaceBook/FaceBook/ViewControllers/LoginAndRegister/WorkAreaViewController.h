//
//  WorkAreaViewController.h
//  FaceBook
//
//  Created by 虞海云 on 14-5-6.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WorkAreaDelegate <NSObject>

- (void)getWorkArea:(NSDictionary*)areaDict;

@end

@interface WorkAreaViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _areaTableView;
}

@property (nonatomic, assign) id <WorkAreaDelegate> delegate;

@property (strong, nonatomic) NSString * workCity;//传过来的省


@end
