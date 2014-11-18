//
//  MyPersonActivityViewController.m
//  FaceBook
//
//  Created by fengshaohui on 14-5-20.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "MyPersonActivityViewController.h"
#import "MyActivityCell.h"
#import "ActivityDetialsViewController.h"
#import "BCHTTPRequest.h"
#import "AFNetworking.h"
#import "DMCAlertCenter.h"

@interface MyPersonActivityViewController ()

@end

@implementation MyPersonActivityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        meActivityArray = [[NSMutableArray alloc]initWithCapacity:100];
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
    self.title = @"我的活动";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 22, 40, 40);
    [backButton setBackgroundImage:[UIImage imageNamed:@"login_backButton@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //[self.navigationController.view addSubview:backButton];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;
    
    //我的活动
    meActivityTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,IS_IOS_7?self.view.frame.size.height-64:self.view.frame.size.height-44) style:UITableViewStylePlain];
    meActivityTableView.delegate = self ;
    meActivityTableView.dataSource = self ;
    meActivityTableView.backgroundView = nil ;
    meActivityTableView.backgroundColor = [UIColor clearColor];
    meActivityTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:meActivityTableView];
    
    [BCHTTPRequest getMyActivityListWithUsingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            meActivityArray = resultDic[@"active"];
            [meActivityTableView reloadData];
        }
    }];
}
#pragma mark - 返回
- (void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return meActivityArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 336/2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimepleNewsListcell = @"SimpleNewsListcells";
    MyActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:SimepleNewsListcell];
    if (cell == nil) {
        cell = [[MyActivityCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimepleNewsListcell];
    }
//    if (indexPath.row%2==0) {
//        [cell.cellBackImageView setImage:[UIImage imageNamed:@"huodongcell1@2x"]];
//    }else
//    {
//        [cell.cellBackImageView setImage:[UIImage imageNamed:@"huodongcell2@2x"]];
//    }
    cell.backgroundColor = [UIColor clearColor];
    cell.cellBackImageView.backgroundColor = [UIColor whiteColor];
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = meActivityArray[indexPath.row];
    
    
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
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *diction = [[NSDictionary alloc]init];
    diction = meActivityArray[indexPath.row];
    //进入活动详情页面
    ActivityDetialsViewController *activityDetialsVC = [[ActivityDetialsViewController alloc]init];
    activityDetialsVC.activityId =diction[@"id"];
    [self.navigationController pushViewController:activityDetialsVC animated:YES];
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
