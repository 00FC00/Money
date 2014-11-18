//
//  QRCodeReadViewController.h
//  LifeTogether
//
//  Created by fengshaohui on 14-2-27.
//  Copyright (c) 2014年 HMN. All rights reserved.
//  二维码扫描

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
@interface QRCodeReadViewController : UIViewController
<ZBarReaderDelegate,ZBarReaderViewDelegate,UIImagePickerControllerDelegate>
{
    
        UIImageView *readLineView;
        BOOL is_have;
        BOOL is_Anmotion;
        
        ZBarReaderView  *readview;
    

}

@end
