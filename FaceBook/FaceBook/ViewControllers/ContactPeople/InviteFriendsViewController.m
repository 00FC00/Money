//
//  InviteFriendsViewController.m
//  FaceBook
//
//  Created by fengshaohui on 14-5-13.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "InviteFriendsViewController.h"
#import "BCHTTPRequest.h"
#import "DMCAlertCenter.h"
#import "MySweepViewController.h"
#import "AddressBookViewController.h"
#import <ShareSDK/ShareSDK.h>

@interface InviteFriendsViewController ()
{
    UITextField *searchField;
}
@end

@implementation InviteFriendsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    if (IS_IOS_7) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios7"] forBarMetrics:UIBarMetricsDefault];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios6"] forBarMetrics:UIBarMetricsDefault];
    }
    self.title = @"邀请好友";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 22, 40, 40);
    [backButton setBackgroundImage:[UIImage imageNamed:@"login_backButton@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //[self.navigationController.view addSubview:backButton];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;
    
    //搜索框背景
    UIImageView *searchImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 112/2)];
    searchImageView.backgroundColor = [UIColor clearColor];
    searchImageView.userInteractionEnabled = YES;
    [searchImageView setImage:[UIImage imageNamed:@"yaoqinghaoyoukuang@2x"]];
    [self.view addSubview:searchImageView];
    
    //搜索框
    searchField = [[UITextField alloc]initWithFrame:CGRectMake(48/2, 10, 536/2, 72/2)];
    searchField.backgroundColor = [UIColor clearColor];
    searchField.delegate = self;
    searchField.textAlignment = NSTextAlignmentLeft;
    searchField.textColor = [UIColor blackColor];
    searchField.placeholder = @"搜索手机号";
    searchField.font = [UIFont systemFontOfSize:15];
    searchField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    searchField.keyboardType = UIKeyboardTypeASCIICapable;
    searchField.returnKeyType =UIReturnKeySearch;
    [searchImageView addSubview:searchField];
    
    //邀请新浪微博好友
    UIButton *inviteSinaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    inviteSinaButton.frame = CGRectMake(86/2, searchImageView.frame.origin.y+searchImageView.frame.size.height+62/2, 222/2, 222/2);
    [inviteSinaButton setBackgroundImage:[UIImage imageNamed:@"weibohaoyou@2x"] forState:UIControlStateNormal];
    [inviteSinaButton addTarget:self action:@selector(clickInviteSinaButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:inviteSinaButton];
    
    //邀请通讯录好友
    UIButton *inviteAddressBookButton = [UIButton buttonWithType:UIButtonTypeCustom];
    inviteAddressBookButton.frame = CGRectMake(inviteSinaButton.frame.origin.x+inviteSinaButton.frame.size.width+25/2, inviteSinaButton.frame.origin.y, 222/2, 222/2);
    [inviteAddressBookButton setBackgroundImage:[UIImage imageNamed:@"tongxunluhaoyou@2x"] forState:UIControlStateNormal];
    [inviteAddressBookButton addTarget:self action:@selector(clickInviteAddressBookButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:inviteAddressBookButton];
    
    //邀请微信好友
    UIButton *inviteWchatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    inviteWchatButton.frame = CGRectMake(86/2, inviteSinaButton.frame.origin.y+inviteSinaButton.frame.size.height+23/2, 222/2, 222/2);
    [inviteWchatButton setBackgroundImage:[UIImage imageNamed:@"weixinhaoyou@2x"] forState:UIControlStateNormal];
    [inviteWchatButton addTarget:self action:@selector(clickInviteWchatButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:inviteWchatButton];
    
    //邀请微信朋友圈
    UIButton *inviteWLineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    inviteWLineButton.frame = CGRectMake(inviteWchatButton.frame.origin.x+inviteWchatButton.frame.size.width+25/2, inviteWchatButton.frame.origin.y, 222/2, 222/2);
    [inviteWLineButton setBackgroundImage:[UIImage imageNamed:@"pengyouquanhaoyou@2x"] forState:UIControlStateNormal];
    [inviteWLineButton addTarget:self action:@selector(clickInviteWLineButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:inviteWLineButton];

}
#pragma mark - 返回
-(void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - keyboard---delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        
        [searchField resignFirstResponder];
        if ([searchField.text length] > 0) {
            [BCHTTPRequest getSearchTheFriendsWithPhone:searchField.text usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
                if (isSuccess == YES) {
                    
                    //如果搜出结果跳转页面
                    MySweepViewController *mySweepVC = [[MySweepViewController alloc]init];
                    mySweepVC.mySweepDictionary = resultDic;
                    mySweepVC.fromString = @"搜索";
                    [self.navigationController pushViewController:mySweepVC animated:YES];
                    
                }
            }];
        }else
        {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"输入框不能为空"];
        }

        
        return NO;
        
    }
    
    return YES;
}
#pragma mark - 通讯录
- (void)clickInviteAddressBookButton
{
    AddressBookViewController *addressBookViewController = [[AddressBookViewController alloc] init];
    [self.navigationController pushViewController:addressBookViewController animated:YES];
}
#pragma mark - 微信好友
-(void)clickInviteWchatButton
{
    UIImage * image = [UIImage imageNamed:@"Icon@2x"];
    
    NSString *weiStr = [NSString stringWithFormat:@"http://wx.facebookchina.cn/index.php?ivcode=%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInformation"] objectForKey:@"invitation"]];
    NSLog(@"邀请码1：%@",weiStr);
    //@"http://www.facebookchina.cn"
    id<ISSContent> publishContent = [ShareSDK content:@"金融部落覆盖几十类、数百家机构的上千万金融从业者，如银行、证券、信托、AMC、租赁、基金、小贷、典当、担保、互联网金融等"
                                       defaultContent:@""
                                                image:[ShareSDK pngImageWithImage:image]
                                                title:@"脸谱科技推出中国金融职场社交平台【itsFinance·金融部落】"
                                                  url:weiStr
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeNews];
    
    
    [ShareSDK shareContent:publishContent
                      type:ShareTypeWeixiSession
               authOptions:nil
             statusBarTips:YES
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        if (state == SSPublishContentStateSuccess)
                        {
                            NSLog(@"分享成功");
                            
                            ///邀请类型（1.通讯录好友2.微信好友3.新浪微博）
                            [BCHTTPRequest inviteWithType:@"2" usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
                                if (isSuccess == YES) {
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"shuGold" object:resultDic[@"coin"]];
                                }
                            }];
                            
                        }
                        else if (state == SSPublishContentStateFail)
                        {
                            NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode],  [error errorDescription]);
                        }
                    }];
}
#pragma mark - 新浪好友
- (void)clickInviteSinaButton:(UIButton *)button
{
    button.userInteractionEnabled = NO;
    UIImage * image = [UIImage imageNamed:@"Icon@2x"];
    
    id<ISSContent> publishContent = [ShareSDK content:@"http://www.facebookchina.cn 脸谱科技推出中国金融职场社交平台【itsFinance·金融部落】 金融部落覆盖几十类、数百家机构的上千万金融从业者，如银行、证券、信托、AMC、租赁、基金、小贷、典当、担保、互联网金融等"
                                       defaultContent:@""
                                                image:[ShareSDK pngImageWithImage:image]
                                                title:@""
                                                  url:@""
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeNews];
    
    
    [ShareSDK shareContent:publishContent
                      type:ShareTypeSinaWeibo
               authOptions:nil
             statusBarTips:YES
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        button.userInteractionEnabled = YES;
                        
                        if (state == SSPublishContentStateSuccess)
                        {
                            NSLog(@"分享成功");
                            ///邀请类型（1.通讯录好友2.微信好友3.新浪微博）
                            [BCHTTPRequest inviteWithType:@"3" usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
                                if (isSuccess == YES) {
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"shuGold" object:resultDic[@"coin"]];
                                }
                            }];
                        }
                        else if (state == SSPublishContentStateFail)
                        {
                            NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode],  [error errorDescription]);
                            if ([error errorCode] == 20016 || [error errorCode] == 10024) {
                                UIAlertView *cleanalertView = [[UIAlertView alloc]initWithTitle:@"" message:@"您发布的太快了，请稍后再试" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil];
                                [cleanalertView show];
                            }
                        }
                    }];

}

#pragma mark - 朋友圈好友
- (void)clickInviteWLineButton
{
    
    UIImage * image = [UIImage imageNamed:@"Icon@2x"];
     NSString *weipStr = [NSString stringWithFormat:@"http://wx.facebookchina.cn/index.php?ivcode=%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInformation"] objectForKey:@"invitation"]];
    NSLog(@"邀请码：%@",weipStr);
    //@"http://www.facebookchina.cn"
    id<ISSContent> publishContent = [ShareSDK content:@""
                                       defaultContent:@""
                                                image:[ShareSDK pngImageWithImage:image]
                                                title:@"脸谱科技推出中国金融职场社交平台【金融部落】，邀请码注册与抢注联系人开始"
                                                  url:weipStr
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeNews];
    
    
    [ShareSDK shareContent:publishContent
                      type:ShareTypeWeixiTimeline 
               authOptions:nil
             statusBarTips:YES
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        if (state == SSPublishContentStateSuccess)
                        {
                            NSLog(@"分享成功");
                            ///邀请类型（1.通讯录好友2.微信好友3.新浪微博）
                            [BCHTTPRequest inviteWithType:@"2" usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
                                if (isSuccess == YES) {
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"shuGold" object:resultDic[@"coin"]];
                                }
                            }];
                        }
                        else if (state == SSPublishContentStateFail)
                        {
                            NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode],  [error errorDescription]);
                        }
                    }];
    
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
