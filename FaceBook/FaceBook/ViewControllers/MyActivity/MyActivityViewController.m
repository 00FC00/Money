//
//  MyActivityViewController.m
//  FaceBook
//
//  Created by HMN on 14-4-29.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "MyActivityViewController.h"
#import "AppDelegate.h"

#import "SettingViewController.h"
#import "MyActivityCell.h"
#import "MyPersonActivityViewController.h"
#import "TopToolCell.h"
#import "ActivityDetialsViewController.h"
#import "createActivityViewController.h"
#import "BCHTTPRequest.h"

#import "CheckActivityCityViewController.h"

#import "SUNViewController.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"

@interface MyActivityViewController ()
{
    UILabel *cityLabel;
}
@end

@implementation MyActivityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        myActivityArray = [[NSMutableArray alloc]initWithCapacity:100];
        bottomArray = [[NSMutableArray alloc]initWithCapacity:100];
        typeId =@"";
        areaName = @"北京";
        isRefreshBottom = @"yes";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:219.0f/255.0f green:219.0f/255.0f blue:219.0f/255.0f alpha:1.0];
    
    if (IS_IOS_7) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios7"] forBarMetrics:UIBarMetricsDefault];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios6"] forBarMetrics:UIBarMetricsDefault];
    }
    self.title = @"部落活动";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame = CGRectMake(0, 22, 40, 40);
    [menuButton setBackgroundImage:[UIImage imageNamed:@"caidan@2x"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(menuButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //[self.navigationController.view addSubview:backButton];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:menuButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;
    
    //登录
    UIButton *setButton = [UIButton buttonWithType:UIButtonTypeCustom];
    setButton.frame = CGRectMake(526/2, 22, 80/2, 80/2);
    [setButton setBackgroundImage:[UIImage imageNamed:@"shezhianniu@2x"] forState:UIControlStateNormal];
    //[setButton setTitle:@"登录" forState:UIControlStateNormal];
    //setButton.titleLabel.font = [UIFont systemFontOfSize:15];
    //[setButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [setButton addTarget:self action:@selector(setButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:setButton];
    self.navigationItem.rightBarButtonItem=rightbuttonitem;
    
    //表格上方蓝色工具栏
    UIImageView *topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -1, 320, 72/2)];
    topImageView.backgroundColor = [UIColor clearColor];
    //wodehuodongbeijing@2x
    [topImageView setImage:[UIImage imageNamed:@"huodongdibutoumingtiao@2x"]];
    topImageView.userInteractionEnabled = YES;
    [self.view addSubview:topImageView];
    
    //城市
    cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(16/2, 20/2, 84/2, 16)];
    cityLabel.backgroundColor =[UIColor clearColor];
    cityLabel.font = [UIFont systemFontOfSize:14];
    cityLabel.textAlignment = NSTextAlignmentLeft;
    cityLabel.textColor = [UIColor whiteColor];
    cityLabel.text = @"北京";
    [topImageView addSubview:cityLabel];
    
    //选择城市按钮
    UIButton *cityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cityButton.frame = CGRectMake(2/2, 0, 164/2, 72/2);
    [cityButton setBackgroundImage:[UIImage imageNamed:@"xuanzechengshi@2x"] forState:UIControlStateNormal];
    [cityButton addTarget:self action:@selector(clickCityButton) forControlEvents:UIControlEventTouchUpInside];
    [topImageView addSubview:cityButton];
    
    //发帖按钮
    UIButton *sendPostButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendPostButton.frame = CGRectMake(262, 0, 116/2, 73/2);
    [sendPostButton setBackgroundImage:[UIImage imageNamed:@"xinjianhuodong@2x"] forState:UIControlStateNormal];
    [sendPostButton addTarget:self action:@selector(clicksendPostButton) forControlEvents:UIControlEventTouchUpInside];
    [topImageView addSubview:sendPostButton];
    
    //我的活动
    UIButton *myActivityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    myActivityButton.frame = CGRectMake(100, 0, 120, 36);
    myActivityButton.backgroundColor = [UIColor clearColor];
    [myActivityButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [myActivityButton setTitle:@"我的活动" forState:UIControlStateNormal];
    myActivityButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [myActivityButton addTarget:self action:@selector(clickMyActivityButton) forControlEvents:UIControlEventTouchUpInside];
    [topImageView addSubview:myActivityButton];
    
    //我的活动列表
    myActivityTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 36, self.view.frame.size.width,IS_IOS_7?self.view.frame.size.height-100:self.view.frame.size.height-100-19+40) style:UITableViewStylePlain];
    myActivityTableView.delegate = self ;
    myActivityTableView.dataSource = self ;
    myActivityTableView.backgroundView = nil ;
    myActivityTableView.tag = 4007;
    
    myActivityTableView.backgroundColor = [UIColor clearColor];
    myActivityTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myActivityTableView];
    
    
    //底部的工具条
    UIImageView *bottomBackImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-40-63, 320, 40)];
    bottomBackImageView.backgroundColor = [UIColor clearColor];
    bottomBackImageView.userInteractionEnabled = YES;
    [bottomBackImageView setImage:[UIImage imageNamed:@"huodongdibutoumingtiao@2x"]];
    [self.view addSubview:bottomBackImageView];
    
    bottomTableView  = [[UITableView alloc] init];
    bottomTableView.backgroundColor = [UIColor clearColor];
    [bottomTableView.layer setAnchorPoint:CGPointMake(0.0, 0.0)];
    bottomTableView.transform = CGAffineTransformMakeRotation(M_PI/-2);
    bottomTableView.showsVerticalScrollIndicator = NO;
    bottomTableView.frame = CGRectMake(0, 40, 320, 40);
    bottomTableView.rowHeight = 100.0;
    bottomTableView.tag = 2007;
    NSLog(@"%f,%f,%f,%f",bottomTableView.frame.origin.x,bottomTableView.frame.origin.y,bottomTableView.frame.size.width,bottomTableView.frame.size.height);
    bottomTableView.delegate = self;
    bottomTableView.dataSource = self;
    bottomTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [bottomBackImageView addSubview:bottomTableView];
    bottomBackImageView.hidden = YES;
    bottomTableView.hidden = YES;
    [self getTheData];

}
#pragma mark - 获取数据
- (void)getTheData
{
    [BCHTTPRequest getTheActivityListWithTypeID:typeId WithAreaName:[areaName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            
            cityLabel.text =resultDic[@"area"];
            myActivityArray = resultDic[@"list"];
            [myActivityTableView reloadData];
            if ([isRefreshBottom isEqualToString:@"yes"]) {
                bottomArray = resultDic[@"type"];
                [bottomTableView reloadData];
            }
        }
    }];
}
#pragma mark - 菜单
- (void)menuButtonClicked
{
    SUNViewController *drawerController = (SUNViewController *)self.navigationController.mm_drawerController;
    
    if (drawerController.openSide == MMDrawerSideNone) {
        [drawerController openDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
            
        }];
    }else if  (drawerController.openSide == MMDrawerSideLeft) {
        [drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
            
        }];
    }

}
#pragma mark - 设置
- (void)setButtonClicked
{
    SettingViewController *settingVC = [[SettingViewController alloc]init];
    [self.navigationController pushViewController:settingVC animated:YES];
}
#pragma mark - 选择城市
- (void)clickCityButton
{
    CheckActivityCityViewController *checkActivityCityVC = [[CheckActivityCityViewController alloc]init];
    checkActivityCityVC.delegate = self;
    [self.navigationController pushViewController:checkActivityCityVC animated:YES];
}
#pragma mark - 代理传值-选择城市
- (void)setActivityCityValueWith:(NSString *)cityDic
{
    cityLabel.text = cityDic;
    areaName = cityDic;
    isRefreshBottom = @"no";
    [self getTheData];
}
#pragma mark - 发帖
- (void)clicksendPostButton
{
    createActivityViewController *createActivityVC = [[createActivityViewController alloc]init];
    [self.navigationController pushViewController:createActivityVC animated:YES];
}
#pragma mark - 我的活动
- (void)clickMyActivityButton
{
    MyPersonActivityViewController *myPersonActivityVC = [[MyPersonActivityViewController alloc]init];
    [self.navigationController pushViewController:myPersonActivityVC animated:YES];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return myActivityArray.count;
    if (tableView.tag == 4007) {
        return myActivityArray.count;
    }else if (tableView.tag == 2007)
    {
        return bottomArray.count;
    }
    return NO;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 4007) {
        return 336/2;
    }else if (tableView.tag == 2007)
    {
        return 100;
    }
    return NO;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 4007) {
        static NSString *SimepleNewsListcell = @"SimpleNewsListcells";
        MyActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:SimepleNewsListcell];
        if (cell == nil) {
            cell = [[MyActivityCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimepleNewsListcell];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
//        if (indexPath.row%2==0) {
//            [cell.cellBackImageView setImage:[UIImage imageNamed:@"huodongcell1@2x"]];
//        }else
//        {
//            [cell.cellBackImageView setImage:[UIImage imageNamed:@"huodongcell2@2x"]];
//        }
        
        cell.backgroundColor = [UIColor clearColor];
        cell.cellBackImageView.backgroundColor = [UIColor whiteColor];
        
        
        
        NSDictionary *dic = [[NSDictionary alloc]init];
        dic = myActivityArray[indexPath.row];
        
        //headimageView
        if ([dic[@"type"] isEqualToString:@"派对"]) {
            [cell.headImageView setImage:[UIImage imageNamed:@"paidui13.jpg"]];
        }else if ([dic[@"type"] isEqualToString:@"商旅"]){
           [cell.headImageView setImage:[UIImage imageNamed:@"shanglv14.jpg"]];
        }else if ([dic[@"type"] isEqualToString:@"体育健身"]){
            [cell.headImageView setImage:[UIImage imageNamed:@"tiyu15.jpg"]];
        }else if ([dic[@"type"] isEqualToString:@"郊游-户外-探险"]){
            [cell.headImageView setImage:[UIImage imageNamed:@"jiaoyou12.jpg"]];
        }else if ([dic[@"type"] isEqualToString:@"公开课-讲座"]){
            [cell.headImageView setImage:[UIImage imageNamed:@"gongkaike11.jpg"]];
        }else if ([dic[@"type"] isEqualToString:@"观影-话剧-舞台剧"]){
            [cell.headImageView setImage:[UIImage imageNamed:@"dianying10.jpg"]];
        }else if ([dic[@"type"] isEqualToString:@"慈善-社会活动"]){
            [cell.headImageView setImage:[UIImage imageNamed:@"cishan9.jpg"]];
        }else if ([dic[@"type"] isEqualToString:@"晚宴"]){
            [cell.headImageView setImage:[UIImage imageNamed:@"wanyan16.jpg"]];
        }else if ([dic[@"type"] isEqualToString:@"午餐会"]){
            [cell.headImageView setImage:[UIImage imageNamed:@"wucan17.jpg"]];
        }else if ([dic[@"type"] isEqualToString:@"下午茶"]){
            [cell.headImageView setImage:[UIImage imageNamed:@"xiawucha18.jpg"]];
        }else if ([dic[@"type"] isEqualToString:@"研讨沙龙"]){
            [cell.headImageView setImage:[UIImage imageNamed:@"yantao19.jpg"]];
        }else if ([dic[@"type"] isEqualToString:@"音乐会"]){
            [cell.headImageView setImage:[UIImage imageNamed:@"yinyue20.jpg"]];
        }else if ([dic[@"type"] isEqualToString:@"早餐早茶会"]){
            [cell.headImageView setImage:[UIImage imageNamed:@"zaocan21.jpg"]];
        }

        cell.titleLabel.text = dic[@"title"];
        
        [cell.markDateImageView setImage:[UIImage imageNamed:@"huodongshijian1@2x"]];
        cell.dateLabel.text = dic[@"time"];
        
        [cell.markPlaceImageView setImage:[UIImage imageNamed:@"huodongdizhi1@2x"]];
        cell.placeLabel.text = dic[@"area_name"];
        
        [cell.markStyleImageView setImage:[UIImage imageNamed:@"huodongleixing1@2x"]];
        cell.styleLabel.text = dic[@"type"];
        
        [cell.markContenImageView setImage:[UIImage imageNamed:@"huodongshuoming1@2x"]];
        cell.markContentLabel.text = @"活动说明";
        
        cell.contentLabel.numberOfLines = 2;
        NSString *str2 = [NSString stringWithFormat:@"%@",dic[@"content"]];
        
        CGSize size2;
        //***********ios6的方法
        size2 = [str2 sizeWithFont:[UIFont systemFontOfSize:12]constrainedToSize:CGSizeMake(322/2,1000) lineBreakMode:NSLineBreakByWordWrapping];
        cell.contentLabel.frame = CGRectMake(258/2, 242/2, 322/2, 30);
        
        cell.contentLabel.text = str2;
        
        return cell;

    }else if (tableView.tag == 2007)
    {
        static NSString *CellIdentifier = @"Cell";
        TopToolCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[TopToolCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
            cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
            cell.markTitleLabel.frame = CGRectMake(0, 7, 100, 26);
            cell.markTitleLabel.textColor = [UIColor whiteColor];
            cell.markTitleLabel.textAlignment = NSTextAlignmentCenter;
            cell.markTitleLabel.backgroundColor = [UIColor clearColor];
            cell.markTitleLabel.font = [UIFont systemFontOfSize:15];
            cell.markTitleLabel.highlightedTextColor = [UIColor colorWithRed:146.0f/255.0f green:172.0f/255.0f blue:215.0f/255.0f alpha:1.0];
            
        }
        NSDictionary *bottomDic = [[NSDictionary alloc]init];
        bottomDic = bottomArray[indexPath.row];
        cell.markTitleLabel.text = bottomDic[@"name"];
        return cell;

    }
    return NO;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView.tag == 2007) {
        //刷新UITableViewCellSeparatorStyleNone
        NSDictionary *bottomDics = [[NSDictionary alloc]init];
        bottomDics = bottomArray[indexPath.row];
        typeId = bottomDics[@"id"];
        isRefreshBottom = @"no";
        [self getTheData];
        
    }else if (tableView.tag == 4007)
    {
        NSDictionary *diction = [[NSDictionary alloc]init];
        diction = myActivityArray[indexPath.row];
        //进入活动详情页面
        ActivityDetialsViewController *activityDetialsVC = [[ActivityDetialsViewController alloc]init];
        
        //activityDetialsVC.permissionStr = @"other";
        activityDetialsVC.activityId = diction[@"id"];
        [self.navigationController pushViewController:activityDetialsVC animated:YES];
    }
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
