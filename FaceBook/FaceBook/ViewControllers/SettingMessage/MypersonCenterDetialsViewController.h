//
//  MypersonCenterDetialsViewController.h
//  FaceBook
//
//  Created by fengshaohui on 14-5-15.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewWithBlock.h"
#import "SelectionCell.h"
#import "WorkCityViewController.h"
#import "WorkAreaViewController.h"


@interface MypersonCenterDetialsViewController : UIViewController<UITextFieldDelegate,UIScrollViewDelegate,WorkCityDelegate,WorkAreaDelegate>
{
    NSString *dtitleStr;
    NSString *didStr;
    BOOL isShowDList;
}
@property (retain, nonatomic) TableViewWithBlock *filterTableView;

@end
