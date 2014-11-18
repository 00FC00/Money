//
//  SendInstitutionDynamicViewController.h
//  FaceBook
//
//  Created by fengshaohui on 14-7-2.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendInstitutionDynamicViewController : UIViewController<UIScrollViewDelegate,UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIScrollView *backScrollView;
    
    
    NSMutableArray *pictureArray;
    NSMutableArray *pictureUrlArray;
    UIImageView *photoImageView;
    UIButton *pictureButton;
    UIImageView *imagesView;
    UIButton *deleagtePictureButton;
}
@property (strong, nonatomic) NSString *myInstitutionID;

@property (strong, nonatomic) NSString *fromString;

@end
