//
//  CreateInstitutionGroupNameViewController.h
//  FaceBook
//
//  Created by fengshaohui on 14-7-2.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateInstitutionGroupNameViewController : UIViewController<UITextFieldDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

//邀请到的人的id

@property (strong, nonatomic) NSString *receiveId;

@property (strong, nonatomic) NSString *institutionID;

@property (nonatomic, strong) NSString *fromString;

@end
