//
//  MyPersonCenterViewController.h
//  FaceBook
//
//  Created by fengshaohui on 14-5-15.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkCityViewController.h"
#import "WorkAreaViewController.h"
@interface MyPersonCenterViewController : UIViewController<UITextFieldDelegate,UIScrollViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,WorkCityDelegate,WorkAreaDelegate>


{
   
    UIActionSheet *photoActionSheet;
}
@end
