//
//  DetailInfoViewController.h
//  FaceBook
//
//  Created by 虞海云 on 14-5-6.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewWithBlock.h"
#import "SelectionCell.h"
#import "WorkCityViewController.h"
#import "WorkAreaViewController.h"
@interface DetailInfoViewController : UIViewController<UITextFieldDelegate,UIScrollViewDelegate,WorkCityDelegate,WorkAreaDelegate>
{
    NSString *dtitleStr;
    NSString *didStr;
    BOOL isShowDList;
    
     NSString *titleStr; //投资偏好名称
}
@property (retain, nonatomic) TableViewWithBlock *filterTableView;
@end
