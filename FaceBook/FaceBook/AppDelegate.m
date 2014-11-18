//
//  AppDelegate.m
//  FaceBook
//
//  Created by HMN on 14-4-25.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"

#import "SUNLeftMenuViewController.h"
#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"
#import "MyFaceBookGroupViewController.h"

#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import "AlixPayResult.h"

#import "LLRequest.h"
#import "GlobalVariable.h"
static const CGFloat kPublicLeftMenuWidth = 280.0f;

@implementation AppDelegate
@synthesize myTimer;
- (BOOL) isMultitaskingSupported{
    
    BOOL result = NO;
    
    if ([[UIDevice currentDevice]
         
         respondsToSelector:@selector(isMultitaskingSupported)]){ result = [[UIDevice currentDevice] isMultitaskingSupported];
        
    }
    
    return result;
    
}

- (void) timerMethod:(NSTimer *)paramSender{
    count++;
    if (count % 1 == 0) {
        NSLog(@"start new task:at %ds",count);
        UIApplication *application = [UIApplication sharedApplication];
        //开启一个新的后台
        backgroundTaskIdentifier = [application beginBackgroundTaskWithExpirationHandler:^{
        }];
        //结束旧的后台任务
        [application endBackgroundTask:backgroundTaskIdentifier];
        oldBackgroundTaskIdentifier = backgroundTaskIdentifier;
    }
    
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    if (IS_IOS_7) {
        [application setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    
    
    [ShareSDK registerApp:@"24117c6f49e0"];
    
    //添加新浪微博应用
    [ShareSDK connectSinaWeiboWithAppKey:@"2619562983"
                               appSecret:@"15d5da3acf519aedd256be4bac1ada04"
                             redirectUri:@"http://www.facebookChina.cn"];
    //http://ysh.iwdys.com
    /**
     *	@brief	连接微信朋友圈
     *
     *  @since  ver2.6.0
     *
     *	@param 	appId 	应用ID，必须要和好友传入ID一致
     *	@param 	wechatCls 	微信Api类型，引入WXApi.h后，将[WXApi class]传入此参数
     */
    [ShareSDK connectWeChatTimelineWithAppId:@"wx2da88cbc165ef4ca" wechatCls:[WXApi class] ];
    
    [ShareSDK connectWeChatSessionWithAppId:@"wx2da88cbc165ef4ca" wechatCls:[WXApi class]];
    //导入微信需要的外部库类型，如果不需要微信分享可以不调用此方法
    [ShareSDK importWeChatClass:[WXApi class]];
    
    
//    MyFaceBookGroupViewController *myFaceBookGroupViewController = [[MyFaceBookGroupViewController alloc] init];
//    UINavigationController *quickAccessNav = [[UINavigationController alloc] initWithRootViewController:myFaceBookGroupViewController];
    
    SUNLeftMenuViewController *leftVC = [[SUNLeftMenuViewController alloc] init];
    _drawerController = [[SUNViewController alloc]
                                            initWithCenterViewController:leftVC.navSlideSwitchVC
                                            leftDrawerViewController:leftVC
                                            rightDrawerViewController:nil];
    [_drawerController setMaximumLeftDrawerWidth:kPublicLeftMenuWidth];
    [_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [_drawerController setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
        MMDrawerControllerDrawerVisualStateBlock block;
        block = [MMDrawerVisualState parallaxVisualStateBlockWithParallaxFactor:2.0];
        block(drawerController, drawerSide, percentVisible);
    }];

    
    
    
    ViewController *rootViewController = [[ViewController alloc] init];
    self.window.rootViewController = rootViewController;
    [self.window makeKeyAndVisible];
    
    
    groupNotice = [[GroupNotice alloc] init];
    [groupNotice createDataBase];

    [groupNotice insertTheRecordsWithGroupID:@"1"];
    
    otherNotice = [[OtherNotice alloc]init];
    [otherNotice createDataBase];
    [otherNotice insertTheRecordsWithNumber:@"1"];
    
    application.applicationIconBadgeNumber = 0;
    
    
    
    [application registerForRemoteNotificationTypes:
     
     UIRemoteNotificationTypeBadge |
     
     UIRemoteNotificationTypeAlert |
     
     UIRemoteNotificationTypeSound];
    
    
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    
    return YES;
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"%@",deviceToken);
    NSString *pushToken = [[[[deviceToken description]
                             stringByReplacingOccurrencesOfString:@"<" withString:@""]
                            stringByReplacingOccurrencesOfString:@">" withString:@""]
                           stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"regisger success:%@", pushToken);
    if ([pushToken length]==0) {
        pushToken = @"";
    }
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserDeviceToken"];
    [[NSUserDefaults standardUserDefaults] setObject:pushToken forKey:@"UserDeviceToken"];
    
    
    NSLog(@"feng-->%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserDeviceToken"] );
    //注册成功，将deviceToken保存到应用服务器数据库中，因为在写向ios推送信息的服务器端程序时要用到这个

    
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    // 处理推送消息
    
    application.applicationIconBadgeNumber = 0;
    
    NSLog(@"userInfo == %@",userInfo);
    
    NSString *message = [[userInfo objectForKey:@"aps"]objectForKey:@"alert"];
    
    UIAlertView *createUserResponseAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    
    [createUserResponseAlert show];
    
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    NSLog(@"Regist fail%@",error);
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //开启一个后台任务
    
    backgroundTaskIdentifier = [application beginBackgroundTaskWithExpirationHandler:^{
    }];
    oldBackgroundTaskIdentifier = backgroundTaskIdentifier;
    if ([myTimer isValid]) {
        [myTimer invalidate];
    }
    count=0;
    myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerMethod:) userInfo:nil repeats:YES];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    if (backgroundTaskIdentifier != UIBackgroundTaskInvalid){
        [application endBackgroundTask:backgroundTaskIdentifier];
        if ([myTimer isValid]) {
            [myTimer invalidate];
        }
    }

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [self parse:url application:application];
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    
    [self parse:url application:application];
    
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

- (void)parse:(NSURL *)url application:(UIApplication *)application {
    
    //结果处理
    AlixPayResult* result = [self handleOpenURL:url];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ALIPAYRESULT object:result];
    
}

- (AlixPayResult *)resultFromURL:(NSURL *)url {
	NSString * query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#if ! __has_feature(objc_arc)
    return [[[AlixPayResult alloc] initWithString:query] autorelease];
#else
	return [[AlixPayResult alloc] initWithString:query];
#endif
}

- (AlixPayResult *)handleOpenURL:(NSURL *)url {
	AlixPayResult * result = nil;
	
	if (url != nil && [[url host] compare:@"safepay"] == 0) {
		result = [self resultFromURL:url];
	}
    
	return result;
}


@end
