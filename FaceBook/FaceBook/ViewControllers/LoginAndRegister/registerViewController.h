//
//  registerViewController.h
//  FaceBook
//
//  Created by 虞海云 on 14-5-4.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkCityViewController.h"
#import "WorkAreaViewController.h"
@interface registerViewController : UIViewController<UITextFieldDelegate,UIScrollViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,WorkCityDelegate,WorkAreaDelegate>

@property (nonatomic, strong) NSString *fromString;

@end
