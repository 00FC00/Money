//
//  UpgradeVIPViewController.h
//  FaceBook
//
//  Created by HMN on 14-4-29.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpgradeVIPViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
{
    NSString *cardIdString;
    NSString *goldString;
    UIAlertView *alertView;
}

@property (strong, nonatomic) NSString *isSetting;
@property (strong, nonatomic) NSString *isMenu;
@end
