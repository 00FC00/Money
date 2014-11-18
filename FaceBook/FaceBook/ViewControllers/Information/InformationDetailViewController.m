//
//  InformationDetailViewController.m
//  FaceBook
//
//  Created by HMN on 14-6-26.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "InformationDetailViewController.h"
#import "InformationCommentViewController.h"
#import "BCHTTPRequest.h"
#import "DMCAlertCenter.h"
#import <ShareSDK/ShareSDK.h>

@interface InformationDetailViewController ()

@end

@implementation InformationDetailViewController
@synthesize nowPage;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _informationDic = [[NSMutableDictionary alloc] initWithCapacity:100];
        
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
    self.title = @"详情";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 40, 40);
    [backButton setBackgroundImage:[UIImage imageNamed:@"login_backButton@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;
    
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(0, 0, 40, 40);
    [shareButton setBackgroundImage:[UIImage imageNamed:@"zixunfenxiang@2x"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(clickShareButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shareButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    
    UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commentButton.frame = CGRectMake(0, 0, 40, 40);
    [commentButton setBackgroundImage:[UIImage imageNamed:@"zixunpinglun@2x"] forState:UIControlStateNormal];
    [commentButton addTarget:self action:@selector(clickCommentButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *commentButtonItem = [[UIBarButtonItem alloc] initWithCustomView:commentButton];
    
    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:commentButtonItem,spaceButtonItem,shareButtonItem,nil];
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, IS_IOS_7?self.view.frame.size.height-64:self.view.frame.size.height-44)];
    //[webView loadHTMLString:@"http://www.baidu.com" baseURL:nil];
    
    [self.view addSubview:webView];

    //默认
    //nowPage = 0;
    
    _informationId = _allNewsArray[nowPage][@"id"];
    _informationTitle = _allNewsArray[nowPage][@"title"];
    _informationAddTime = _allNewsArray[nowPage][@"add_time"];
    
    [BCHTTPRequest informationDetailWithInfo_id:_informationId usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",resultDic[@"detail_url"]]]]];
            _informationDic = [resultDic mutableCopy];
        }
    }];
    
    //左按钮
    leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 295/2, 88/2, 88/2);
    [leftButton setBackgroundColor:[UIColor clearColor]];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"leftbutton@2x"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(clickLeftButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    [self.view bringSubviewToFront:leftButton];
    leftButton.hidden = YES;
    
    //右按钮
    rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(552/2, 295/2, 88/2, 88/2);
    [rightButton setBackgroundColor:[UIColor clearColor]];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"rightbutton@2x"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(clickRightButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightButton];
    [self.view bringSubviewToFront:rightButton];
    rightButton.hidden = YES;
    
   // NSLog(@"%@",[NSString stringWithFormat:@"%@index.php?r=default/informations/getDetail&info_id=%@",kMainUrlString,_informationId]);
}

#pragma mark - 返回
-(void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 向左
- (void)clickLeftButton
{
    if (nowPage == 0) {
        //已经是第一篇
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"当前页面已经是第一篇"];
    }else
    {
        //--
        nowPage -= 1;
        _informationId = _allNewsArray[nowPage][@"id"];
        _informationTitle = _allNewsArray[nowPage][@"title"];
        _informationAddTime = _allNewsArray[nowPage][@"add_time"];
        
        [BCHTTPRequest informationDetailWithInfo_id:_informationId usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
                [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",resultDic[@"detail_url"]]]]];
                _informationDic = [resultDic mutableCopy];
            }
        }];

    }
}
#pragma mark - 向右
- (void)clickRightButton
{
    if (nowPage == _allNewsArray.count-1) {
        //已经是最后一遍
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"当前页面已经是最后一篇"];
    }else
    {
       //++
        nowPage += 1;
        _informationId = _allNewsArray[nowPage][@"id"];
        _informationTitle = _allNewsArray[nowPage][@"title"];
        _informationAddTime = _allNewsArray[nowPage][@"add_time"];
        
        [BCHTTPRequest informationDetailWithInfo_id:_informationId usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
                [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",resultDic[@"detail_url"]]]]];
                _informationDic = [resultDic mutableCopy];
            }
        }];

        
    }
}
#pragma mark - 分享
- (void)clickShareButton:(UIButton *)sender
{
    UIImage * image = [UIImage imageNamed:@"Icon@2x"];
    //NSData * imageData = UIImageJPEGRepresentation(image, 1);
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"%@ %@ %@",_informationDic[@"share_url"],_informationDic[@"title"],_informationDic[@"content"]]
                                       defaultContent:_informationDic[@"title"]
                                                image:[ShareSDK pngImageWithImage:image]
                                                title:nil
                                                  url:nil
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeNews];
    
    //定制微信好友
    [publishContent addWeixinSessionUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeNews]
                                         content:_informationDic[@"content"]
                                           title:_informationDic[@"title"]
                                             url:_informationDic[@"share_url"]
                                      thumbImage:[ShareSDK pngImageWithImage:image]
                                           image:nil
                                    musicFileUrl:nil
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];
    
    

    //定制微信朋友圈信息
    [publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeNews]
                                          content:_informationDic[@"content"]
                                            title:_informationDic[@"title"]
                                              url:_informationDic[@"share_url"]
                                       thumbImage:[ShareSDK pngImageWithImage:image]
                                            image:nil
                                     musicFileUrl:nil
                                          extInfo:nil
                                         fileData:nil
                                     emoticonData:nil];
    
    
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];

    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                    if (type == 1 ) {
                                        ///邀请类型（1.通讯录好友2.微信好友3.新浪微博）
                                        [BCHTTPRequest getTheGoldAfterShareInformationWithType:@"6" usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
                                        
                                            if (isSuccess == YES) {
                                                [[NSNotificationCenter defaultCenter] postNotificationName:@"shuGold" object:resultDic[@"coin"]];
                                            }
                                        }];
                                    }else if (type == 22 )
                                    {
                                        //22,     /**< 微信好友 */
                                        //23,    /**< 微信朋友圈 */
                                        ///邀请类型（1.通讯录好友2.微信好友3.新浪微博）
                                        [BCHTTPRequest getTheGoldAfterShareInformationWithType:@"5" usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
                                            
                                            if (isSuccess == YES) {
                                                [[NSNotificationCenter defaultCenter] postNotificationName:@"shuGold" object:resultDic[@"coin"]];
                                            }
                                        }];
                                    }

                                    
                                }else if (type == 23 )
                                {
                                    //22,     /**< 微信好友 */
                                    //23,    /**< 微信朋友圈 */
                                    ///邀请类型（1.通讯录好友2.微信好友3.新浪微博）
                                    [BCHTTPRequest getTheGoldAfterShareInformationWithType:@"4" usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
                                        
                                        if (isSuccess == YES) {
                                            [[NSNotificationCenter defaultCenter] postNotificationName:@"shuGold" object:resultDic[@"coin"]];
                                        }
                                    }];
                                
                                
                                
                            }else if (state == SSResponseStateFail)
                                {
                                    //NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                    NSLog(@"分享失败,错误码:%d,错误描述:%@",[error errorCode], [error errorDescription]);
                                }
                            }];
}
#pragma mark - 评论
- (void)clickCommentButton
{
    InformationCommentViewController *informationCommentViewController = [[InformationCommentViewController alloc] init];
    informationCommentViewController.informationId = _informationId;
    informationCommentViewController.informationTitle = _informationTitle;
    informationCommentViewController.informationAddTime = _informationAddTime;
    [self.navigationController pushViewController:informationCommentViewController animated:YES];
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
