//
//  MyPersonActivityViewController.h
//  FaceBook
//
//  Created by fengshaohui on 14-5-20.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPersonActivityViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    //群列表
    UITableView *meActivityTableView;
    
    NSMutableArray *meActivityArray;
}


@end
