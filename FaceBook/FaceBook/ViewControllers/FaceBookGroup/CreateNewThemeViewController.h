//
//  CreateNewThemeViewController.h
//  FaceBook
//
//  Created by fengshaohui on 14-5-29.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateNewThemeViewController : UIViewController<UITextFieldDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    NSString *headImageUrl;
}

@end
