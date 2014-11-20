//
//  AppDelegate.h
//  FaceBook
//
//  Created by HMN on 14-4-25.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupNotice.h"
#import "GroupNoticeObject.h"
#import "OtherNoticeObject.h"
#import "OtherNotice.h"
#import "SUNViewController.h"

@class ViewController;
@class DDMenuController;
@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate>
{
    NSTimer *myTimer;
    UIBackgroundTaskIdentifier backgroundTaskIdentifier;
    UIBackgroundTaskIdentifier oldBackgroundTaskIdentifier;
    NSInteger count;
    
    GroupNoticeObject *obj;
    GroupNotice * groupNotice;
    
    OtherNotice *otherNotice;
    OtherNoticeObject *otherObj;
}
@property(nonatomic,retain)NSTimer *myTimer;


@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@property (strong ,nonatomic) UINavigationController *root_unvc;

@property (retain, nonatomic) DDMenuController *menuController;

@property (retain, nonatomic)  SUNViewController * drawerController;

@end
