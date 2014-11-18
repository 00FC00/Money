//
//  MyFaceBookGroupViewController.h
//  FaceBook
//
//  Created by HMN on 14-4-28.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyFaceBookGroupViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    //群列表
    UITableView *groupTableView;
    NSMutableArray *allGroupArray;
    
}

@end
