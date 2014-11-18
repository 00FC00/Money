//
//  EducationExperienceViewController.h
//  FaceBook
//
//  Created by 虞海云 on 14-5-6.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewWithBlock.h"
#import "SelectionCell.h"

@interface EducationExperienceViewController : UIViewController<UITextFieldDelegate>
{
    UIDatePicker *datePicker;
    UIView *bgView;
    UIToolbar *toolbar;
    NSString *timeMark;
}
@property (retain, nonatomic) TableViewWithBlock *filterTableView;
@property (strong, nonatomic)NSString *editStyle;//标识出来是修改还是新加的


@property (strong, nonatomic) NSDictionary *eduDiction;
@end
