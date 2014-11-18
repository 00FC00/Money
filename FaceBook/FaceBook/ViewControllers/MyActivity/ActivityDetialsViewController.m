//
//  ActivityDetialsViewController.m
//  FaceBook
//
//  Created by fengshaohui on 14-5-21.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "ActivityDetialsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DMCAlertCenter.h"
#import "BCHTTPRequest.h"
#import "AFNetworking.h"
#import "MySweepViewController.h"
@interface ActivityDetialsViewController ()
{
    //背景
    UIScrollView *backScrollView;
    UIButton *_Button;
    //头像
    UIImageView *headerImageView;
    //发起人姓名
    UILabel *nameLabel;
    //手机号
    UILabel *markPhoneLabel;
    UILabel *phoneLabel;
    //公司
    UILabel *markCompanyLabel;
    UILabel *companyLabel;
    //职位
    UILabel *markPositionLabel;
    UILabel *positionLabel;
    
    /******************************/
    //活动信息背景
    UIImageView *activityMessageImageView;;
    //活动名称
    UILabel *markNameLabel;
    UILabel *activityNameLabel;
    //活动类型
    UILabel *markStyleLabel;
    UILabel *activityStyleLabel;
    //活动说明
    UILabel *markExplainLabel;
    UILabel *activityExplainLabel;
    CGSize size1;
    //活动时间
    UILabel *markDateLabel;
    UILabel *activityDateLabel;
    //地点
    UILabel *markAddressLabel;
    UILabel *addressLabel;
    //费用
    UILabel *markCostLabel;
    UILabel *activityCostLabel;
    
    /***************************/
    //标题
    UILabel *numberLabel;
    UIImageView *photoBackImageView;
    NSMutableArray *myArray ;
    
}
@end

@implementation ActivityDetialsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        myArray = [[NSMutableArray alloc] initWithCapacity:100];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:218.0f/255.0f green:218.0f/255.0f blue:218.0f/255.0f alpha:1.0];
    if (IS_IOS_7) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios7"] forBarMetrics:UIBarMetricsDefault];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios6"] forBarMetrics:UIBarMetricsDefault];
    }
    self.title = @"活动详情";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 22, 40, 40);
    [backButton setBackgroundImage:[UIImage imageNamed:@"login_backButton@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //[self.navigationController.view addSubview:backButton];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;
    
    //右边功能按钮
    _Button = [UIButton buttonWithType:UIButtonTypeCustom];
    _Button.frame = CGRectMake(526/2, 22, 84/2, 42/2);
    [_Button setBackgroundImage:[UIImage imageNamed:@"login_RegistrationButton_03@2x"] forState:UIControlStateNormal];
//    if ([self.permissionStr isEqualToString:@"me"]) {
//        [_Button setTitle:@"删除" forState:UIControlStateNormal];
//    }else if ([self.permissionStr isEqualToString:@"other"])
//    {
//        [_Button setTitle:@"加入" forState:UIControlStateNormal];
//    }
    _Button.titleLabel.font = [UIFont systemFontOfSize:15];
    [_Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_Button addTarget:self action:@selector(ButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:_Button];
    self.navigationItem.rightBarButtonItem=rightbuttonitem;
    
    //背景
    backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 10, [[UIScreen mainScreen] bounds].size.width-20, [[UIScreen mainScreen] bounds].size.height-64-10)];
    backScrollView.backgroundColor = [UIColor colorWithRed:226.0f/255.0f green:226.0f/255.0f blue:226.0f/255.0f alpha:1.0];
    backScrollView.delegate = self;
    backScrollView.showsHorizontalScrollIndicator = NO;
    backScrollView.showsVerticalScrollIndicator = NO;
    [backScrollView setContentSize:CGSizeMake(0, [[UIScreen mainScreen] bounds].size.height)];
    backScrollView.userInteractionEnabled = YES;
    [self.view addSubview:backScrollView];

//**********************
// 获取数据
//****************************
    [BCHTTPRequest getTheActivityDetialsWithActivityID:self.activityId usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            self.userIDstr = resultDic[@"uid"];
            
            if ([resultDic[@"is_user"] integerValue]==0) {
                if ([resultDic[@"is_join"] integerValue]==0) {
                    _Button.hidden = NO;
                    [_Button setTitle:@"加入" forState:UIControlStateNormal];
                }else
                {
                    _Button.hidden = YES;
                }
                
            }else
            {
                [_Button setTitle:@"删除" forState:UIControlStateNormal];
            }
            
//            [headerImageView setImageWithURL:[NSURL URLWithString:resultDic[@"pic"]] placeholderImage:[UIImage imageNamed:@"ceshi@2x"]];
//            nameLabel.text = resultDic[@"name"];
//            if (resultDic[@"phone"]) {
//                phoneLabel.text = resultDic[@"phone"];
//            }else
//            {
//                phoneLabel.text = @"不能查看";
//            }
//             companyLabel.text = resultDic[@"company"];
//            positionLabel.text = resultDic[@"department"];
            
//==================
//     活动信息
//==================
            //活动信息背景activityMessageImageView;;[0,196/2,]
            activityMessageImageView = [[UIImageView alloc]init];
            activityMessageImageView.backgroundColor = [UIColor clearColor];
            activityMessageImageView.userInteractionEnabled = YES;
//            [activityMessageImageView.layer setMasksToBounds:YES];
//            [activityMessageImageView.layer setCornerRadius:3.0f];
//            activityMessageImageView.layer.borderWidth = 1.0f;
//            activityMessageImageView.layer.borderColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0].CGColor;
            [backScrollView addSubview:activityMessageImageView];
            
            //活动图片
           UIImageView *adImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 160/2, 160/2)];
            adImageView.backgroundColor = [UIColor clearColor];
            [adImageView setClipsToBounds:YES];
            adImageView.contentMode = UIViewContentModeScaleAspectFit;
            [activityMessageImageView addSubview:adImageView];
            
            if ([resultDic[@"type"] isEqualToString:@"派对"]) {
                [adImageView setImage:[UIImage imageNamed:@"paidui13.jpg"]];
            }else if ([resultDic[@"type"] isEqualToString:@"商旅"]){
                [adImageView setImage:[UIImage imageNamed:@"shanglv14.jpg"]];
            }else if ([resultDic[@"type"] isEqualToString:@"体育健身"]){
                [adImageView setImage:[UIImage imageNamed:@"tiyu15.jpg"]];
            }else if ([resultDic[@"type"] isEqualToString:@"郊游-户外-探险"]){
                [adImageView setImage:[UIImage imageNamed:@"jiaoyou12.jpg"]];
            }else if ([resultDic[@"type"] isEqualToString:@"公开课-讲座"]){
                [adImageView setImage:[UIImage imageNamed:@"gongkaike11.jpg"]];
            }else if ([resultDic[@"type"] isEqualToString:@"观影-话剧-舞台剧"]){
                [adImageView setImage:[UIImage imageNamed:@"dianying10.jpg"]];
            }else if ([resultDic[@"type"] isEqualToString:@"慈善-社会活动"]){
                [adImageView setImage:[UIImage imageNamed:@"cishan9.jpg"]];
            }else if ([resultDic[@"type"] isEqualToString:@"晚宴"]){
                [adImageView setImage:[UIImage imageNamed:@"wanyan16.jpg"]];
            }else if ([resultDic[@"type"] isEqualToString:@"午餐会"]){
                [adImageView setImage:[UIImage imageNamed:@"wucan17.jpg"]];
            }else if ([resultDic[@"type"] isEqualToString:@"下午茶"]){
                [adImageView setImage:[UIImage imageNamed:@"xiawucha18.jpg"]];
            }else if ([resultDic[@"type"] isEqualToString:@"研讨沙龙"]){
                [adImageView setImage:[UIImage imageNamed:@"yantao19.jpg"]];
            }else if ([resultDic[@"type"] isEqualToString:@"音乐会"]){
                [adImageView setImage:[UIImage imageNamed:@"yinyue20.jpg"]];
            }else if ([resultDic[@"type"] isEqualToString:@"早餐早茶会"]){
                [adImageView setImage:[UIImage imageNamed:@"zaocan21.jpg"]];
            }

            
            
            //活动名称markNameLabel;//activityNameLabel;
            markNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(180/2, 10, 402/2, 32/2)];
            markNameLabel.backgroundColor = [UIColor clearColor];
            markNameLabel.textAlignment = NSTextAlignmentLeft;
            markNameLabel.textColor = [UIColor blackColor];
            markNameLabel.font = [UIFont systemFontOfSize:16];
            markNameLabel.text = resultDic[@"title"];
            [activityMessageImageView addSubview:markNameLabel];
            
            //类型
            UIImageView *namelineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(180/2, 68/2, 30/2, 30/2)];
            namelineImageView.backgroundColor = [UIColor clearColor];
            [namelineImageView setImage:[UIImage imageNamed:@"huodongleixing1@2x"]];
            [activityMessageImageView addSubview:namelineImageView];
            
            //活动类型markStyleLabel;//activityStyleLabel;
            markStyleLabel = [[UILabel alloc]initWithFrame:CGRectMake(216/2, 34, 128/2, 30/2)];
            markStyleLabel.backgroundColor = [UIColor clearColor];
            markStyleLabel.textAlignment = NSTextAlignmentLeft;
            markStyleLabel.textColor = [UIColor blackColor];
            markStyleLabel.font = [UIFont systemFontOfSize:14];
            markStyleLabel.text = @"活动类型:";
            [activityMessageImageView addSubview:markStyleLabel];
            
            activityStyleLabel = [[UILabel alloc]initWithFrame:CGRectMake(344/2, 34, 242/2, 30/2)];
            activityStyleLabel.backgroundColor = [UIColor clearColor];
            activityStyleLabel.textAlignment = NSTextAlignmentLeft;
            activityStyleLabel.textColor = [UIColor blackColor];
            activityStyleLabel.font = [UIFont systemFontOfSize:14];
            activityStyleLabel.text = resultDic[@"type"];
            [activityMessageImageView addSubview:activityStyleLabel];
            
            //发起人
            UIImageView *createrImageView = [[UIImageView alloc]initWithFrame:CGRectMake(180/2, 112/2, 30/2, 30/2)];
            createrImageView.backgroundColor = [UIColor clearColor];
            [createrImageView setImage:[UIImage imageNamed:@"huodongfaqiren1@2x"]];
            //[createrImageView setImageWithURL:[NSURL URLWithString:resultDic[@"pic"]] placeholderImage:[UIImage imageNamed:@"ceshi@2x"]];
            [activityMessageImageView addSubview:createrImageView];
            
            nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(216/2, 112/2, 90/2, 34/2)];
            nameLabel.backgroundColor = [UIColor clearColor];
            nameLabel.textAlignment = NSTextAlignmentLeft;
            nameLabel.textColor = [UIColor blackColor];
            nameLabel.font = [UIFont systemFontOfSize:14];
            nameLabel.text = @"发起人";
            [activityMessageImageView addSubview:nameLabel];
            
            headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(314/2, 52, 50/2, 50/2)];
            [headerImageView setImageWithURL:[NSURL URLWithString:resultDic[@"pic"]] placeholderImage:[UIImage imageNamed:@"ceshi@2x"]];
            headerImageView.userInteractionEnabled = YES;
            [activityMessageImageView addSubview:headerImageView];
            
            UIButton *userHeadButton = [UIButton buttonWithType:UIButtonTypeCustom];
            userHeadButton.frame = CGRectMake(0, 0, 50/2, 50/2);
            userHeadButton.backgroundColor = [UIColor clearColor];
            [userHeadButton addTarget:self action:@selector(clickUserHeadButton) forControlEvents:UIControlEventTouchUpInside];
            [headerImageView addSubview:userHeadButton];

            
            //活动时间markDateLabel;//activityDateLabel;
            UIImageView *datelineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20/2, 202/2, 30/2, 15)];
            datelineImageView.backgroundColor = [UIColor clearColor];
            [datelineImageView setImage:[UIImage imageNamed:@"huodongshijian1@2x"]];
            [activityMessageImageView addSubview:datelineImageView];
            
            activityDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(54/2, 202/2, 530/2, 30/2)];
            activityDateLabel.backgroundColor = [UIColor clearColor];
            activityDateLabel.textAlignment = NSTextAlignmentLeft;
            activityDateLabel.textColor = [UIColor blackColor];
            activityDateLabel.font = [UIFont systemFontOfSize:14];
            activityDateLabel.text = resultDic[@"time"];
            [activityMessageImageView addSubview:activityDateLabel];
            
            //地点markAddressLabel;//addressLabel;
            UIImageView *markAddressImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20/2, 242/2, 30/2, 15)];
            markAddressImageView.backgroundColor = [UIColor clearColor];
            [markAddressImageView setImage:[UIImage imageNamed:@"huodongdizhi1@2x"]];
            [activityMessageImageView addSubview:markAddressImageView];

            
            addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(54/2, 242/2, 530/2, 30/2)];
            addressLabel.backgroundColor = [UIColor clearColor];
            addressLabel.textAlignment = NSTextAlignmentLeft;
            addressLabel.textColor = [UIColor blackColor];
            addressLabel.font = [UIFont systemFontOfSize:14];
            addressLabel.text = resultDic[@"area_name"];
            [activityMessageImageView addSubview:addressLabel];
            
           //费用
            UIImageView *markPayImageView = [[UIImageView alloc]initWithFrame:CGRectMake(16/2, 282/2, 30/2, 15)];
            markPayImageView.backgroundColor = [UIColor clearColor];
            [markPayImageView setImage:[UIImage imageNamed:@"huodongfeiyong@2x"]];
            [activityMessageImageView addSubview:markPayImageView];
            
            UILabel *payLabel = [[UILabel alloc]initWithFrame:CGRectMake(54/2, 282/2, 530/2, 30/2)];
            payLabel.backgroundColor = [UIColor clearColor];
            payLabel.textAlignment = NSTextAlignmentLeft;
            payLabel.textColor = [UIColor blackColor];
            payLabel.font = [UIFont systemFontOfSize:14];
            payLabel.text = resultDic[@"payment_method"];
            [activityMessageImageView addSubview:payLabel];


            
            
            //活动说明//markExplainLabel;//activityExplainLabel;
            UIImageView *explainlineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20/2, 328/2, 30/2, 15)];
            explainlineImageView.backgroundColor = [UIColor clearColor];
            [explainlineImageView setImage:[UIImage imageNamed:@"huodongshuoming1@2x"]];
            [activityMessageImageView addSubview:explainlineImageView];

            
            markExplainLabel = [[UILabel alloc]initWithFrame:CGRectMake(54/2, 328/2, 300/2, 15)];
            markExplainLabel.backgroundColor = [UIColor clearColor];
            markExplainLabel.textAlignment = NSTextAlignmentLeft;
            markExplainLabel.textColor = [UIColor blackColor];
            markExplainLabel.font = [UIFont systemFontOfSize:16];
            markExplainLabel.text = @"活动说明:";
            [activityMessageImageView addSubview:markExplainLabel];
            
            activityExplainLabel = [[UILabel alloc]init];
            activityExplainLabel.backgroundColor = [UIColor colorWithRed:213.0f/255.0f green:213.0f/255.0f blue:213.0f/255.0f alpha:1.0];
            activityExplainLabel.textAlignment = NSTextAlignmentLeft;
            activityExplainLabel.textColor = [UIColor blackColor];
            activityExplainLabel.font = [UIFont systemFontOfSize:14];
            [activityExplainLabel.layer setMasksToBounds:YES];
            [activityExplainLabel.layer setCornerRadius:3.0f];
            [activityExplainLabel.layer setBorderColor:[UIColor colorWithRed:199.0f/255.0f green:199.0f/255.0f blue:199.0f/255.0f alpha:1.0].CGColor];
            [activityExplainLabel.layer setBorderWidth:1.0f];
            activityExplainLabel.numberOfLines = 0;
            NSString *str1 =resultDic[@"content"];
            
            //***********ios7的方法
            if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7)
            {
                NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
                size1 = [str1 boundingRectWithSize:CGSizeMake(562/2, 500) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
            }else
            {
                //***********ios6的方法
                size1 = [str1 sizeWithFont:[UIFont systemFontOfSize:14]constrainedToSize:CGSizeMake(562/2,500) lineBreakMode:NSLineBreakByWordWrapping];
            }
            //********************
            activityExplainLabel.frame =CGRectMake(22/2, 374/2, 562/2, size1.height+8);
            activityExplainLabel.text = str1;
            [activityMessageImageView addSubview:activityExplainLabel];
            
            
            
            
           
            
            
            
            
            
            
            activityMessageImageView.frame = CGRectMake(0, 4/2, [[UIScreen mainScreen] bounds].size.width-20, 334/2+activityExplainLabel.frame.size.height+15);
            
            //==========================
            //     参加聚会者的头像
            //==========================
            
            UIImageView *markNumberImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0/2, activityExplainLabel.frame.origin.y+activityExplainLabel.frame.size.height+15, activityMessageImageView.frame.size.width, 0.5)];
            markNumberImageView.backgroundColor = [UIColor lightGrayColor];
            
            [activityMessageImageView addSubview:markNumberImageView];
            //标题numberLabel;
            numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(18/2, activityExplainLabel.frame.origin.y+activityExplainLabel.frame.size.height+25, 370/2, 34/2)];
            numberLabel.backgroundColor = [UIColor clearColor];
            numberLabel.textAlignment = NSTextAlignmentLeft;
            numberLabel.textColor = [UIColor blackColor];
            numberLabel.font = [UIFont systemFontOfSize:16];
            numberLabel.text = [NSString stringWithFormat:@"参与人:"];
            [backScrollView addSubview:numberLabel];
            
            if ([resultDic[@"num"] isEqualToString:@"0"]) {
                ;
            }else
             {
            //头像背景photoBackImageView;
            photoBackImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, numberLabel.frame.origin.y+numberLabel.frame.size.height+10, [[UIScreen mainScreen]bounds].size.width, 48)];
            photoBackImageView.backgroundColor = [UIColor clearColor];
                
            photoBackImageView.userInteractionEnabled = YES;
            [backScrollView addSubview:photoBackImageView];
            [backScrollView setContentSize:CGSizeMake(0, photoBackImageView.frame.origin.y+photoBackImageView.frame.size.height+100)];
           // NSMutableArray *myArray = [[NSMutableArray alloc]init];
                 myArray = resultDic[@"user"];
            [self addPhotoToPhotoBackImageViewWithAyyay:myArray];
             }

            
            
            
        }
    }];
    
    
}
- (void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 点击头像
- (void)clickUserHeadButton
{
    MySweepViewController *otherPeopleMessageDetialsVC1 = [[MySweepViewController alloc] init];
    otherPeopleMessageDetialsVC1.friendIdString = self.userIDstr;
    [self.navigationController pushViewController:otherPeopleMessageDetialsVC1 animated:YES];
}

- (void)addPhotoToPhotoBackImageViewWithAyyay:(NSMutableArray *)array
{
    if (array.count > 5) {
        for (int i = 0; i<5; i++) {
            if (i == 4) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame =CGRectMake(5+60*(i%5), 0, 51, 51);
                [button setBackgroundColor:[UIColor clearColor]];
                [button setBackgroundImage:[UIImage imageNamed:@"renshu@2x"] forState:UIControlStateNormal];
                [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 12, 0, 0)];
                [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                NSString *str = [NSString stringWithFormat:@"%d",array.count-5];
                [button setTitle:str forState:UIControlStateNormal];
                [photoBackImageView addSubview:button];
            }else
            {
            UIImageView *userPhotoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5+60*(i%5), 0, 51, 51)];
            userPhotoImageView.backgroundColor = [UIColor clearColor];
                userPhotoImageView.userInteractionEnabled = YES;
            [userPhotoImageView.layer setMasksToBounds:YES];
            [userPhotoImageView.layer setCornerRadius:3.0f];
            [userPhotoImageView setImageWithURL:[NSURL URLWithString:array[i][@"pic"]] placeholderImage:[UIImage imageNamed:@"ceshi@2x"]];
            [photoBackImageView addSubview:userPhotoImageView];
                
                UIButton *userButton = [UIButton buttonWithType:UIButtonTypeCustom];
                userButton.frame = CGRectMake(0, 0, 51, 51);
                userButton.backgroundColor = [UIColor clearColor];
                [userButton addTarget:self action:@selector(clickUserButton:) forControlEvents:UIControlEventTouchUpInside];
                userButton.tag = 6000+i;
                [userPhotoImageView addSubview:userButton];
            }
        }

    }else
    {
        for (int k = 0; k<array.count; k++) {
            UIImageView *userPhotoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5+60*(k%5), 0, 51, 51)];
            userPhotoImageView.backgroundColor = [UIColor cyanColor];
            userPhotoImageView.userInteractionEnabled = YES;
            [userPhotoImageView.layer setMasksToBounds:YES];
            [userPhotoImageView.layer setCornerRadius:3.0f];
            [userPhotoImageView setImageWithURL:[NSURL URLWithString:array[k][@"pic"]] placeholderImage:[UIImage imageNamed:@"ceshi@2x"]];
            [photoBackImageView addSubview:userPhotoImageView];
            
            UIButton *usersButton = [UIButton buttonWithType:UIButtonTypeCustom];
            usersButton.frame = CGRectMake(0, 0, 51, 51);
            usersButton.backgroundColor = [UIColor clearColor];
            [usersButton addTarget:self action:@selector(clickUserButton:) forControlEvents:UIControlEventTouchUpInside];
            usersButton.tag = 6000+k;
            [userPhotoImageView addSubview:usersButton];

        }
    }
}
#pragma mark - 点击参与者头像
- (void)clickUserButton:(UIButton *)button
{
    MySweepViewController *otherPeopleMessageDetialsVC = [[MySweepViewController alloc] init];
    otherPeopleMessageDetialsVC.friendIdString = myArray[button.tag-6000][@"id"];
    [self.navigationController pushViewController:otherPeopleMessageDetialsVC animated:YES];
}
#pragma mark - 有功能按钮
- (void)ButtonClicked
{
    if ([_Button.titleLabel.text isEqualToString:@"加入"]) {
        
        [BCHTTPRequest joinTheActivityWithActivityID:self.activityId UsingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
                [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"请求已发送"];
            }
        }];
        
    }else if ([_Button.titleLabel.text isEqualToString:@"删除"])
    {
        [BCHTTPRequest deleteTheActivityOfMeWithActivityID:self.activityId usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
                //弹出框要自定义
                
                [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"删除"];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
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
