//
//  SUNLeftMenuViewController.m
//  SUNCommonComponent
//
//  Created by 麦志泉 on 13-9-4.
//  Copyright (c) 2013年 中山市新联医疗科技有限公司. All rights reserved.
//

#import "SUNLeftMenuViewController.h"
#import "SUNSlideSwitchDemoViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "MenuCell.h"
#import "QuickAccessViewController.h"
#import "ChatViewController.h"
#import "ContactPeopleViewController.h"
#import "FriendsCircleViewController.h"
#import "MyFaceBookGroupViewController.h"
#import "FaceBookGroupViewController.h"
#import "BusinessWallViewController.h"
#import "InformationViewController.h"
#import "MyActivityViewController.h"
#import "TownsmanViewController.h"
#import "MessageViewController.h"
#import "UpgradeVIPViewController.h"
#import "BCHTTPRequest.h"
#import "AFNetworking.h"
#import "DMCAlertCenter.h"

#import "AppDelegate.h"
#import "GlobalVariable.h"
#import "InformationMainViewController.h"
#import "AdvertisementDetialsViewController.h"

#import "RecentlyContactsDB.h"

#import "MyPersonCenterViewController.h"

@interface SUNLeftMenuViewController ()
{
    AdvertisementDetialsViewController *advertisementDetialsVC;
    
    NSTimer *timer_advertise;//广告
}

@end

@implementation SUNLeftMenuViewController

#pragma mark - 控制器初始化方法

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        MyFaceBookGroupViewController *myFaceBookGroupVC = [[MyFaceBookGroupViewController alloc] init];
        
        _navSlideSwitchVC = [[UINavigationController alloc] initWithRootViewController:myFaceBookGroupVC];
        
        menuArray = [[NSMutableArray alloc] initWithCapacity:100];
        remindDic = [[NSMutableDictionary alloc] initWithCapacity:100];
        allAdArray = [[NSMutableArray alloc] initWithCapacity:100];
        canClickDic = [[NSDictionary alloc] init];
        
        
    }
    return self;
}

//烧毁该
- (void)viewWillAppear:(BOOL)animated
{
    
    if (isP == NO) {
        isP = YES;
        
        [menuTableView reloadData];
    }
    
    [self getUnread];//部落未读消息
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REMIND_NEW_MESSAGE object:nil];
    
    //    GlobalVariable *globalVariable = [GlobalVariable sharedGlobalVariable];
    //    if (globalVariable.meduleDic != nil) {
    //        [menuArray addObject:globalVariable.meduleDic];
    //        [menuTableView reloadData];
    //
    //        globalVariable.meduleDic = nil;
    //
    //    }
}

#pragma mark - 获取部落未读消息

- (void)getUnread
{
    if ([BCHTTPRequest isLogin] == YES) {
        [BCHTTPRequest CheckTheNewRemindMessageUsingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
                remindDic = [resultDic mutableCopy];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"remindNew" object:remindDic[@"nums"]];
            }
        }];
    }
}


#pragma mark - 视图加载方法

- (void)viewWillLayoutSubviews
{
    //[super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:185.0f/255.0f green:190.0f/255.0f blue:197.0f/255.0f alpha:1.0f];
    self.navigationController.navigationBarHidden = YES;
    menuTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,IS_IOS_7?20:0, 280,IS_IOS_7?self.view.frame.size.height-20:self.view.frame.size.height) style:UITableViewStylePlain];
    menuTableView.delegate = self;
    menuTableView.dataSource = self;
    menuTableView.backgroundView = nil ;
    //menuTableView.backgroundColor =[UIColor colorWithRed:185.0f/255.0f green:190.0f/255.0f blue:197.0f/255.0f alpha:1.0f];
    
    menuTableView.backgroundColor =[UIColor colorWithRed:247.0f/255.0f green:247.0f/255.0f blue:247.0f/255.0f alpha:1.0f];
    
    menuTableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 360/2)];
    //    menuTableView.tableHeaderView.backgroundColor = [UIColor colorWithRed:206.0f/255.0f green:207.0f/255.0f blue:210.0f/255.0f alpha:1.0f];
    menuTableView.tableHeaderView.backgroundColor = [UIColor whiteColor];
    menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:menuTableView];
    
    
        isP = YES;
        [self getListData];
        
        
//    }
    //接受模块添加通知
    [[NSNotificationCenter defaultCenter] addObserverForName:@"moduleAdd" object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        //        [menuArray removeAllObjects];
        //        [menuArray addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"ModuleMenu"]];
        //
        //        [menuTableView reloadData];
        [self getListData];
        
        
    }];
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"shuGold" object:resultDic[@"gold"]];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"shuGold" object:nil queue:nil usingBlock:^(NSNotification *note) {
        goldLabel.text = [NSString stringWithFormat:@"金币（%@）",note.object];
    }];
    
    //ShowVIP
    //    [[NSNotificationCenter defaultCenter] addObserverForName:@"ShowVIP" object:nil queue:nil usingBlock:^(NSNotification *note) {
    //        [markVipImageView setImage:[UIImage imageNamed:@"viptupian@2x"]];
    //    }];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(tableviewCellLongPressed:)];
    
    longPress.minimumPressDuration = 1.0;
    [menuTableView addGestureRecognizer:longPress];
    
    //三秒轮训获取部落未读消息
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3.f target:self selector:@selector(getUnread) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
    
}

- (void)targetMethod
{
    
    // NSLog(@"all---%@",allAdArray);
    if (adImageView1.frame.origin.y == 0) {
        [UIView animateWithDuration:1.0 animations:^{
            
            adImageView2.frame = CGRectMake(0,0, 320, 182/2);
            adImageView1.frame = CGRectMake(0,-182/2, 320, 182/2);
            
        } completion:^(BOOL finished){
            adImageView1.frame = CGRectMake(0,182/2, 320, 182/2);
            canClickDic = allAdArray[adNow];
            //  NSLog(@"++++++++%@",canClickDic);
            
            if (adNow < allAdArray.count-1) {
                adNow +=1;
            }else
            {
                adNow = 0;
            }
            
            //        NSLog(@"广告image-%d-%@",adNow,allAdArray[adNow]);
            [adHeadImageView1 setImageWithURL:[NSURL URLWithString:allAdArray[adNow][@"logo"]] placeholderImage:[UIImage imageNamed:@"morentouxiang@2x"]];
            adTitleLabel1.text = allAdArray[adNow][@"title"];
            NSString *str4 = allAdArray[adNow][@"intro"];
            CGSize size2;
            //***********ios7的方法
            if (IS_IOS_7)
            {
                NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:13]};
                size2 = [str4 boundingRectWithSize:CGSizeMake(344/2, 66/2) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
            }else
            {
                //***********ios6的方法
                size2 = [str4 sizeWithFont:[UIFont systemFontOfSize:13]constrainedToSize:CGSizeMake(344/2,66/2) lineBreakMode:NSLineBreakByWordWrapping];
            }
            
            adContentLabel1.frame = CGRectMake(188/2, 78/2, 344/2, size2.height);
            adContentLabel1.text = str4;
            
        }];
        
    }else if (adImageView2.frame.origin.y == 0) {
        [UIView animateWithDuration:1.0 animations:^{
            
            adImageView2.frame = CGRectMake(0,-182/2, 320, 182/2);
            adImageView1.frame = CGRectMake(0,0, 320, 182/2);
        } completion:^(BOOL finished){
            adImageView2.frame = CGRectMake(0,182/2, 320, 182/2);
            
            canClickDic = allAdArray[adNow];
            //           NSLog(@"++++++++%@",canClickDic);
            
            if (adNow < allAdArray.count-1) {
                adNow +=1;
            }else
            {
                adNow = 0;
            }
            
            //           NSLog(@"广告image-%d-%@",adNow,allAdArray[adNow]);
            [adHeadImageView2 setImageWithURL:[NSURL URLWithString:allAdArray[adNow][@"logo"]] placeholderImage:[UIImage imageNamed:@"morentouxiang@2x"]];
            adTitleLabel2.text = allAdArray[adNow][@"title"];
            NSString *str3 = allAdArray[adNow][@"intro"];
            CGSize size3;
            //***********ios7的方法
            if (IS_IOS_7)
            {
                NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:13]};
                size3 = [str3 boundingRectWithSize:CGSizeMake(344/2, 66/2) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
            }else
            {
                //***********ios6的方法
                size3 = [str3 sizeWithFont:[UIFont systemFontOfSize:13]constrainedToSize:CGSizeMake(344/2,66/2) lineBreakMode:NSLineBreakByWordWrapping];
            }
            
            adContentLabel2.frame = CGRectMake(188/2, 78/2, 344/2, size3.height);
            adContentLabel2.text = str3;
            
            
        }];
        
    }
    
}
#pragma mark - 广告详情页
- (void)clickCanButton
{
    
    
   // if (!AdvertisementDetialsNav) {
     advertisementDetialsVC = [[AdvertisementDetialsViewController alloc] init];
        advertisementDetialsVC.dic = canClickDic;
        AdvertisementDetialsNav = [[UINavigationController alloc] initWithRootViewController:advertisementDetialsVC];
//    }else{
//        advertisementDetialsVC.dic = canClickDic;
//         //AdvertisementDetialsNav = [[UINavigationController alloc] initWithRootViewController:advertisementDetialsVC];
//    }
    //[self.mm_drawerController setCenterViewController:AdvertisementDetialsNav
     //                              withCloseAnimation:YES completion:nil];
    [self.mm_drawerController presentViewController:AdvertisementDetialsNav animated:YES completion:^{
        ;
    }];
}

- (void)getListData
{
//    if (menuArray.count > 0) {
//        [menuArray removeAllObjects];
//    }
    [BCHTTPRequest getMyMainMessageWithUsingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            
            
            NSMutableArray  *mArray = [[NSMutableArray alloc]initWithCapacity:100];
            mArray = resultDic[@"ads_list"];
            allAdArray = [mArray mutableCopy];
            
            if (canClickDic) {
                canClickDic = nil;
            }
            if (adBackImageView) {
                [adBackImageView removeFromSuperview];
                adBackImageView = nil;
                
                [timer_advertise invalidate];
                
                timer_advertise  = nil;
            }
            
            
            if (allAdArray.count>0) {
                
                canClickDic = allAdArray[0];
                
                adNow = 1;
                adBackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 182/2)];
                adBackImageView.backgroundColor = [UIColor colorWithRed:247.0f/255.0f green:247.0f/255.0f blue:247.0f/255.0f alpha:1.0f];
//                adBackImageView.backgroundColor = [UIColor orangeColor];
                
                adBackImageView.userInteractionEnabled = YES;
                [menuTableView.tableHeaderView addSubview:adBackImageView];
                
                adImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 182/2)];
                adImageView1.backgroundColor = [UIColor clearColor];
                adImageView1.userInteractionEnabled = YES;
                [adBackImageView addSubview:adImageView1];
                
                adHeadImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(20/2, 26/2, 152/2, 152/2)];
                adHeadImageView1.backgroundColor = [UIColor clearColor];
                [adHeadImageView1 setImageWithURL:[NSURL URLWithString:allAdArray[0][@"logo"]] placeholderImage:[UIImage imageNamed:@"morentouxiang@2x"]];
                [adHeadImageView1 setClipsToBounds:YES];
                adHeadImageView1.contentMode = UIViewContentModeScaleAspectFit;
                [adImageView1 addSubview:adHeadImageView1];
                
                
                adTitleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(188/2, 26/2, 344/2, 34/2)];
                adTitleLabel1.backgroundColor = [UIColor clearColor];
                adTitleLabel1.font = [UIFont systemFontOfSize:16];
                adTitleLabel1.textAlignment = NSTextAlignmentLeft;
                adTitleLabel1.textColor = [UIColor blackColor];
                adTitleLabel1.text = allAdArray[0][@"title"];
                [adImageView1 addSubview:adTitleLabel1];
                
                adContentLabel1 = [[UILabel alloc] init];
                adContentLabel1.backgroundColor = [UIColor clearColor];
                adContentLabel1.textAlignment = NSTextAlignmentLeft;
                adContentLabel1.textColor = [UIColor darkGrayColor];
                adContentLabel1.font = [UIFont systemFontOfSize:13];
                adContentLabel1.numberOfLines = 0;
                
                
                NSString *str2 = allAdArray[0][@"intro"];
                CGSize size2;
                //***********ios7的方法
                if (IS_IOS_7)
                {
                    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:13]};
                    size2 = [str2 boundingRectWithSize:CGSizeMake(344/2, 66/2) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
                }else
                {
                    //***********ios6的方法
                    size2 = [str2 sizeWithFont:[UIFont systemFontOfSize:13]constrainedToSize:CGSizeMake(344/2,66/2) lineBreakMode:NSLineBreakByWordWrapping];
                }
                
                adContentLabel1.frame = CGRectMake(188/2, 78/2, 344/2, size2.height);
                adContentLabel1.text = str2;
                [adImageView1 addSubview:adContentLabel1];
                
                if (allAdArray.count > 1) {
                    //*******************
                    adImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, adImageView1.frame.origin.y+91, 320, 182/2)];
                    adImageView2.backgroundColor = [UIColor clearColor];
                    adImageView2.userInteractionEnabled = YES;
                    [adBackImageView addSubview:adImageView2];
                    
                    adHeadImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(20/2, 26/2, 152/2, 152/2)];
                    adHeadImageView2.backgroundColor = [UIColor clearColor];
                    [adHeadImageView2 setImageWithURL:[NSURL URLWithString:allAdArray[1][@"logo"]] placeholderImage:[UIImage imageNamed:@"morentouxiang@2x"]];
                    [adHeadImageView2 setClipsToBounds:YES];
                    adHeadImageView2.contentMode = UIViewContentModeScaleAspectFit;
                    [adImageView2 addSubview:adHeadImageView2];
                    
                    adTitleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(188/2, 26/2, 344/2, 34/2)];
                    adTitleLabel2.backgroundColor = [UIColor clearColor];
                    adTitleLabel2.font = [UIFont systemFontOfSize:16];
                    adTitleLabel2.textAlignment = NSTextAlignmentLeft;
                    adTitleLabel2.textColor = [UIColor blackColor];
                    adTitleLabel2.text = allAdArray[1][@"title"];
                    [adImageView2 addSubview:adTitleLabel2];
                    
                    adContentLabel2 = [[UILabel alloc] init];
                    adContentLabel2.backgroundColor = [UIColor clearColor];
                    adContentLabel2.textAlignment = NSTextAlignmentLeft;
                    adContentLabel2.textColor = [UIColor darkGrayColor];
                    adContentLabel2.font = [UIFont systemFontOfSize:13];
                    adContentLabel2.numberOfLines = 0;
                    
                    
                    NSString *str3 = allAdArray[1][@"intro"];
                    CGSize size3;
                    //***********ios7的方法
                    if (IS_IOS_7)
                    {
                        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:13]};
                        size3 = [str3 boundingRectWithSize:CGSizeMake(344/2, 66/2) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
                    }else
                    {
                        //***********ios6的方法
                        size3 = [str3 sizeWithFont:[UIFont systemFontOfSize:13]constrainedToSize:CGSizeMake(344/2,66/2) lineBreakMode:NSLineBreakByWordWrapping];
                    }
                    
                    adContentLabel2.frame = CGRectMake(188/2, 78/2, 344/2, size3.height);
                    adContentLabel2.text = str3;
                    [adImageView2 addSubview:adContentLabel2];
                    
                    
                    canClickButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    canClickButton.frame = CGRectMake(0, 0, 320, 182/2);
                    canClickButton.backgroundColor = [UIColor clearColor];
                    [canClickButton addTarget:self action:@selector(clickCanButton) forControlEvents:UIControlEventTouchUpInside];
                    [adBackImageView addSubview:canClickButton];
                    
                    if (timer_advertise == nil) {
                        timer_advertise = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                                           target:self
                                                                         selector:@selector(targetMethod)
                                                                         userInfo:nil
                                                                          repeats:YES];
                        
                        [[NSRunLoop currentRunLoop]addTimer:timer_advertise forMode:NSRunLoopCommonModes];
                    }
                    
                }
                
            }
            
            
            
            //头像headImageView;headButton;
            msgBackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 91, 320, 178/2)];
            msgBackImageView.backgroundColor = [UIColor colorWithRed:247.0f/255.0f green:247.0f/255.0f blue:247.0f/255.0f alpha:1.0f];
            msgBackImageView.userInteractionEnabled = YES;
            [menuTableView.tableHeaderView addSubview:msgBackImageView];
            
            UIImageView *mxianImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 4, 640/2, 1)];
            [mxianImageView setImage:[UIImage imageNamed:@"shouyecellxian@2x"]];
            [msgBackImageView addSubview:mxianImageView];
            
            headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(22/2,30/2, 121/2, 121/2)];
            [headImageView.layer setMasksToBounds: YES];
            [headImageView.layer setCornerRadius:3];
            headImageView.userInteractionEnabled = YES;
            [msgBackImageView addSubview:headImageView];
            
            
            
            
            // 是VIP加V 不是的话不加
            markVipImageView = [[UIImageView alloc]initWithFrame:CGRectMake(92/2, 3, 25/2, 22/2)];
            markVipImageView.backgroundColor = [UIColor clearColor];
            [headImageView addSubview:markVipImageView];
            
            NSString *VipStr = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInformation"] objectForKey:@"is_vip"];
            if ([VipStr intValue] == 1) {
                [markVipImageView setImage:[UIImage imageNamed:@"viptupian@2x"]];
            }else
            {
                [markVipImageView setImage:[UIImage imageNamed:@""]];
            }
            
            headButton = [UIButton buttonWithType:UIButtonTypeCustom];
            headButton.frame = CGRectMake(0, 0, 121/2, 121/2);
            [headButton addTarget:self action:@selector(clickHeadButton) forControlEvents:UIControlEventTouchUpInside];
            [headImageView addSubview:headButton];
            
            //姓名nameLabel;
            nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(170/2, 20/2, 330/2, 40/2)];
            nameLabel.backgroundColor = [UIColor clearColor];
            nameLabel.font = [UIFont systemFontOfSize:16];
            nameLabel.textAlignment = NSTextAlignmentLeft;
            nameLabel.textColor = [UIColor colorWithRed:56.0f/255.0f green:56.0f/255.0f blue:58.0f/255.0f alpha:1];
            
            [msgBackImageView addSubview:nameLabel];
            
            //脸谱号
            faceBookNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(170/2,60/2, 330/2, 30/2)];
            faceBookNumberLabel.backgroundColor = [UIColor clearColor];
            
            faceBookNumberLabel.font = [UIFont systemFontOfSize:14];
            faceBookNumberLabel.textColor = [UIColor grayColor];
            [msgBackImageView addSubview:faceBookNumberLabel];
            
            //职位
            positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(170/2, 92/2, 330/2, 30/2)];
            positionLabel.backgroundColor = [UIColor clearColor];
            //    positionLabel.text = [NSString stringWithFormat:@"职位：%@",@"ui设计师"];
            positionLabel.font = [UIFont systemFontOfSize:14];
            positionLabel.textColor = [UIColor grayColor];
            [msgBackImageView addSubview:positionLabel];
            
            //金币
            goldLabel = [[UILabel alloc] initWithFrame:CGRectMake(170/2, 122/2, 330/2, 30/2)];
            goldLabel.backgroundColor = [UIColor clearColor];
            //    goldLabel.text = [NSString stringWithFormat:@"金币（%@）",@"999999"];
            goldLabel.font = [UIFont systemFontOfSize:14];
            goldLabel.textColor = [UIColor grayColor];
            [msgBackImageView addSubview:goldLabel];

            //分割线
            UIImageView *txianImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 176/2, 640/2, 1)];
            [txianImageView setImage:[UIImage imageNamed:@"shouyecellxian@2x"]];
            [msgBackImageView addSubview:txianImageView];

            
            //[UIImage imageNamed:@"morentouxiang@2x"]
            //头像
            [headImageView setImageWithURL:[NSURL URLWithString:resultDic[@"logo"]] placeholderImage:[UIImage imageNamed:@"morentouxiang@2x"]];
            //名字
            nameLabel.text = resultDic[@"name"];
            //脸谱号
            faceBookNumberLabel.text = [NSString stringWithFormat:@"脸谱号：%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInformation"] objectForKey:@"lp_sn"]];
            //职位
            positionLabel.text = [NSString stringWithFormat:@"业务部门：%@",resultDic[@"department"]];
            //金币数
            goldLabel.text = [NSString stringWithFormat:@"金币（%@）",resultDic[@"gold_coins"]];
            
            NSArray *moduleNameArray = [[NSArray alloc] init];
            moduleNameArray = resultDic[@"list"];
            
//            NSMutableArray *tempNameArr = [NSMutableArray array];
//            
//            for (NSString *name in moduleNameArray) {
//                
//                if ([name isEqualToString:@"朋友圈"] || [name isEqualToString:@"同乡校友"] ||[name isEqualToString:@"部落活动"]) {
//                    
//                }else
//                {
//                    [tempNameArr addObject:name];
//                }
//                
//            }
//            
//            moduleNameArray = tempNameArr;
            
            NSMutableArray *moduleUserArray = [[NSMutableArray alloc] initWithCapacity:100];
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ModuleMenu"] ) {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ModuleMenu"];
            }
            for (int i = 0; i< moduleNameArray.count; i++) {
                
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:100];
                [dic setObject:moduleNameArray[i] forKey:@"moduleName"];
                // [dic setObject:moduleImageArray[i] forKey:@"moduleImage"];
                if ([moduleNameArray[i] isEqualToString:@"快捷访问"]) {
                    [dic setObject:@"kuaijiefangwen@2x" forKey:@"moduleImage"];
                }else if([moduleNameArray[i] isEqualToString:@"我的部落"])
                {
                    [dic setObject:@"wodelianpuqun@2x" forKey:@"moduleImage"];
                }else if([moduleNameArray[i] isEqualToString:@"聊天"])
                {
                    [dic setObject:@"liaotian@2x" forKey:@"moduleImage"];
                }else if([moduleNameArray[i] isEqualToString:@"联系人"])
                {
                    [dic setObject:@"lianxiren@2x" forKey:@"moduleImage"];
                }
                
                else if([moduleNameArray[i] isEqualToString:@"朋友圈"])
                {
                    [dic setObject:@"pengyouquan@2x" forKey:@"moduleImage"];
                }
                
                else if([moduleNameArray[i] isEqualToString:@"部落群"])
                {
                    [dic setObject:@"lianpuqun@2x" forKey:@"moduleImage"];
                }else if([moduleNameArray[i] isEqualToString:@"部落墙"])
                {
                    [dic setObject:@"yewuqiang@2x" forKey:@"moduleImage"];
                }else if([moduleNameArray[i] isEqualToString:@"部落资讯"])
                {
                    [dic setObject:@"zixun@2x" forKey:@"moduleImage"];
                    
                }
                
                else if([moduleNameArray[i] isEqualToString:@"部落活动"])
                {
                    [dic setObject:@"wodehuodong@2x" forKey:@"moduleImage"];
                }
                else if([moduleNameArray[i] isEqualToString:@"同乡校友"])
                {
                    [dic setObject:@"tongchenglaoxiang@2x" forKey:@"moduleImage"];
                }
                
                else if([moduleNameArray[i] isEqualToString:@"部落消息"])
                {
                    [dic setObject:@"xiaoxi@2x" forKey:@"moduleImage"];
                }else if([moduleNameArray[i] isEqualToString:@"升级为VIP"])
                {
                    [dic setObject:@"shengjiVip@2x" forKey:@"moduleImage"];
                }
                
                
                
                
                [moduleUserArray addObject:dic];
                
            }
            [[NSUserDefaults standardUserDefaults] setObject:moduleUserArray forKey:@"ModuleMenu"];
            
        }
        
        if (menuArray.count > 0) {
            [menuArray removeAllObjects];
        }
        
        [menuArray addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"ModuleMenu"]];
        [menuTableView reloadData];
        
        
    }];
    
}

#pragma mark - 表格视图数据源代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(void)tableviewCellLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        //        NSLog(@"UIGestureRecognizerStateBegan");
        //        CGPoint ponit=[gestureRecognizer locationInView:menuTableView];
        //        NSLog(@" CGPoint ponit=%f %f",ponit.x,ponit.y);
        //        NSIndexPath* path=[menuTableView indexPathForRowAtPoint:ponit];
        //        NSLog(@"row:%d",path.row);
        //currRow=path.row;
        isP = NO;
        [menuTableView reloadData];
        
    }else if(gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        //未用
    }
    else if(gestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        //未用
    }
}

#pragma mark - 点击头像

- (void)clickHeadButton
{
    NSLog(@"照片");
    
    
    UIViewController * rootController =((AppDelegate*)[UIApplication sharedApplication].delegate).drawerController;
    MyPersonCenterViewController *myPersonCenterVC = [[MyPersonCenterViewController alloc]init];
    
    [rootController.navigationController pushViewController:myPersonCenterVC animated:YES];
    
}

#pragma mark -

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#define macro ===========tableView============
//选中Cell响应事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
    
	// set the root controller
    DDMenuController * rootController = ((AppDelegate*)[UIApplication sharedApplication].delegate).menuController;
    ///这里是快捷访问
    if ([menuArray[indexPath.row][@"moduleName"] isEqualToString:@"快捷访问"]) {
        
        if (!quickAccessNav) {
            QuickAccessViewController *quickAccessViewController = [[QuickAccessViewController alloc] init];
            quickAccessNav = [[UINavigationController alloc] initWithRootViewController:quickAccessViewController];
        }
        [self setCenterviewController:quickAccessNav];
        
    }else if ([menuArray[indexPath.row][@"moduleName"] isEqualToString:@"我的部落"]) {
        if (!MyFaceBookGroupNav) {
            MyFaceBookGroupViewController *myFaceBookGroupViewController = [[MyFaceBookGroupViewController alloc] init];
            MyFaceBookGroupNav = [[UINavigationController alloc] initWithRootViewController:myFaceBookGroupViewController];
        }
        [self setCenterviewController:MyFaceBookGroupNav];
        
        
    }else if ([menuArray[indexPath.row][@"moduleName"] isEqualToString:@"聊天"]) {
        
        if (!ChatViewNav) {
            ChatViewController *chatViewController = [[ChatViewController alloc] init];
            ChatViewNav = [[UINavigationController alloc] initWithRootViewController:chatViewController];
        }
        [self setCenterviewController:ChatViewNav];
        
    }else if ([menuArray[indexPath.row][@"moduleName"] isEqualToString:@"联系人"]) {
        
        if (!ContactPeopleNav) {
            ContactPeopleViewController *contactPeopleViewController = [[ContactPeopleViewController alloc] init];
            ContactPeopleNav = [[UINavigationController alloc] initWithRootViewController:contactPeopleViewController];
        }
        [self setCenterviewController:ContactPeopleNav];
        
        
    }else if ([menuArray[indexPath.row][@"moduleName"] isEqualToString:@"朋友圈"]) ///这里是朋友圈
    {
        if (!FriendsCircleNav) {
            FriendsCircleViewController *friendsCircleViewController = [[FriendsCircleViewController alloc] init];
            FriendsCircleNav = [[UINavigationController alloc] initWithRootViewController:friendsCircleViewController];
        }
        [self setCenterviewController:FriendsCircleNav];
        
    }else if ([menuArray[indexPath.row][@"moduleName"] isEqualToString:@"部落群"]) {
        if (!FaceBookGroupNav) {
            FaceBookGroupViewController *faceBookGroupViewController = [[FaceBookGroupViewController alloc] init];
            FaceBookGroupNav = [[UINavigationController alloc] initWithRootViewController:faceBookGroupViewController];
        }
        [self setCenterviewController:FaceBookGroupNav];
        
    }else if ([menuArray[indexPath.row][@"moduleName"] isEqualToString:@"部落墙"]) {
        if (!BusinessWallNav) {
            BusinessWallViewController *businessWallViewController = [[BusinessWallViewController alloc] init];
            BusinessWallNav = [[UINavigationController alloc] initWithRootViewController:businessWallViewController];
        }
        [self setCenterviewController:BusinessWallNav];
        
    }else if ([menuArray[indexPath.row][@"moduleName"] isEqualToString:@"部落资讯"]) {
        if (!InformationMainNav) {
            InformationMainViewController *informationViewController = [[InformationMainViewController alloc] init];
            InformationMainNav = [[UINavigationController alloc] initWithRootViewController:informationViewController];
        }
        [self setCenterviewController:InformationMainNav];
        
    }else if ([menuArray[indexPath.row][@"moduleName"] isEqualToString:@"部落活动"]) {
        if (!MyActivityNav) {
            MyActivityViewController *myActivityViewController = [[MyActivityViewController alloc] init];
            MyActivityNav = [[UINavigationController alloc] initWithRootViewController:myActivityViewController];
        }
        [self setCenterviewController:MyActivityNav];
        
    }else if ([menuArray[indexPath.row][@"moduleName"] isEqualToString:@"同乡校友"]) {
        if (!TownsmanNav) {
            TownsmanViewController *townsmanViewController = [[TownsmanViewController alloc] init];
            TownsmanNav = [[UINavigationController alloc] initWithRootViewController:townsmanViewController];
        }
        [self setCenterviewController:TownsmanNav];
        
    }else if ([menuArray[indexPath.row][@"moduleName"] isEqualToString:@"部落消息"]) {
        if (!MessageNav) {
            MessageViewController *messageViewController = [[MessageViewController alloc] init];
            MessageNav = [[UINavigationController alloc] initWithRootViewController:messageViewController];
        }
        [self setCenterviewController:MessageNav];
        
        
    }else if ([menuArray[indexPath.row][@"moduleName"] isEqualToString:@"升级为VIP"]) {
        if (!UpgradeVIPNav) {
            UpgradeVIPViewController *upgradeVIPViewController = [[UpgradeVIPViewController alloc] init];
            upgradeVIPViewController.isMenu = @"yes";
            UpgradeVIPNav = [[UINavigationController alloc] initWithRootViewController:upgradeVIPViewController];
        }
        
        [self setCenterviewController:UpgradeVIPNav];
    }
    
}

- (void)setCenterviewController:(UIViewController *)viewController
{
    [self.mm_drawerController.view addGestureRecognizer:self.mm_drawerController.tap];
    [self.mm_drawerController.view addGestureRecognizer:self.mm_drawerController.pan];
    [self.mm_drawerController setupGestureRecognizers];
    [self.mm_drawerController setCenterViewController:viewController withCloseAnimation:YES completion:nil];
}

//改变行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80/2;
    
}
//返回TableView中有多少数据
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return menuArray.count;
    
}
//组装每一条的数据
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CustomCellIdentifier =@"CellIdentifier";
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier: CustomCellIdentifier];
    if (cell ==nil) {
		cell = [[MenuCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CustomCellIdentifier];
        
        cell.backgroundView = nil;
        cell.backgroundColor = [UIColor colorWithRed:247.0f/255.0f green:247.0f/255.0f blue:247.0f/255.0f alpha:1.0f];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shouyecellxuanzhong@2x"]];
        
        
    }
    
    cell.titleLabel.text = menuArray[indexPath.row][@"moduleName"];
    [cell.markImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",menuArray[indexPath.row][@"moduleImage"]]]];
    [cell.xianImageView setImage:[UIImage imageNamed:@"shouyecellxian@2x"]];
    
    if (isP == YES) {
        
        [cell.deleteButton setImage:[UIImage imageNamed:@"shanchu"] forState:UIControlStateNormal];
        cell.deleteButton.hidden = YES;
        
    }else
    {
        if (indexPath.row == menuArray.count-1) {
            [cell.deleteButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            cell.deleteButton.hidden = YES;
        }else
        {
            [cell.deleteButton setImage:[UIImage imageNamed:@"shanchu"] forState:UIControlStateNormal];
            cell.deleteButton.hidden = NO;
            cell.deleteButton.tag = indexPath.row;
            [cell.deleteButton addTarget:self action:@selector(clickDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
    
    
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"remindNew" object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        
        
        if ([cell.titleLabel.text isEqualToString:@"部落消息"]) {
            if (redPoint) {
                [redPoint setBackgroundColor:[UIColor clearColor]];
            }else
            {
                redPoint = [[UIImageView alloc]initWithFrame:CGRectMake(200/2, 34/2, 40/4, 40/4)];
                [redPoint setBackgroundColor:[UIColor clearColor]];
                [cell.contentView addSubview:redPoint];
            }
        }
        NSString *myStr = [NSString stringWithFormat:@"%@",note.object];
        if ([myStr intValue] == 0) {
            [redPoint setImage:[UIImage imageNamed:@""]];
        }else
        {
            [redPoint setImage:[UIImage imageNamed:@"newRemind@2x"]];
        }
    }];
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NOTIFICATION_REMIND_NEW_MESSAGE object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        if ([cell.titleLabel.text isEqualToString:@"聊天"]) {
            if (redPoint_chat) {
                [redPoint_chat setBackgroundColor:[UIColor clearColor]];
            }else
            {
                redPoint_chat = [[UIImageView alloc]initWithFrame:CGRectMake(60 + 20, 34/2, 40/4, 40/4)];
                [redPoint_chat setBackgroundColor:[UIColor clearColor]];
                [cell.contentView addSubview:redPoint_chat];
            }
        }
        
        if ([self getUnreadCount] == 0) {
            [redPoint_chat setImage:[UIImage imageNamed:@""]];
        }else
        {
            [redPoint_chat setImage:[UIImage imageNamed:@"newRemind@2x"]];
        }
        
    }];
    
    
    return cell;
    
}

#pragma mark - 获取未读消息

- (int)getUnreadCount
{
    RecentlyContactsDB * recentlyContactsDB = [[RecentlyContactsDB alloc] init];
    [recentlyContactsDB createDataBase];
    
    NSArray *arr  = [recentlyContactsDB getAllRecentlyContactsInfo];
    
    int sum = 0;
    for (FMDBRecentlyContactsObject  *recentlyObj in arr) {
        
        sum += [recentlyObj.unReadNumber intValue];
    }
    
    return sum;
}

//删除
- (void)clickDeleteButton:(UIButton *)button
{
    
    
    
    //去除本地模块
    [BCHTTPRequest dellTheMenuWithMenuName:[menuArray[button.tag][@"moduleName"]  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            [menuArray removeObjectAtIndex:button.tag];
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ModuleMenu"];
            [[NSUserDefaults standardUserDefaults] setObject:menuArray forKey:@"ModuleMenu"];
            
            
            //            //添加快捷访问模块
            //            NSMutableArray *moduleArray = [[NSMutableArray alloc] initWithCapacity:100];
            //            [moduleArray addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"ModuleUser"]];
            //            [moduleArray addObject:menuArray[button.tag]];
            //
            //            //重新存储
            //            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ModuleUser"];
            //            [[NSUserDefaults standardUserDefaults] setObject:moduleArray forKey:@"ModuleUser"];
            
            
            //通知模块刷新
            [[NSNotificationCenter defaultCenter] postNotificationName:@"moduleQuickAccess" object:nil];
            
            NSIndexPath *deletePath = [NSIndexPath indexPathForRow:button.tag inSection:0];
            
            [menuTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:deletePath] withRowAnimation:UITableViewRowAnimationFade];
            
            [self performSelector:@selector(tableViewReloadData) withObject:nil afterDelay:0.3];
            
        }
    }];
    
    
    
    
    
    
}

- (void)tableViewReloadData
{
    [menuTableView reloadData];
}
#pragma mark - 销毁内存方法

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
