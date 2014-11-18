//
//  createActivityViewController.m
//  FaceBook
//
//  Created by fengshaohui on 14-5-21.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "createActivityViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AFNetworking.h"
#import "BCHTTPRequest.h"
#import "DMCAlertCenter.h"

#import "CheckActivityCityViewController.h"

@interface createActivityViewController ()
{
    //背景
    UIScrollView *backScrollView;
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

    //活动信息背景
    UIImageView *sendActivityMessageImageView;
    //活动名称
    UITextField *activityNameField;
    //活动类型
    UIButton *styleButton;
    //活动时间
    UIButton *dateButton;
    //开始时间
    UIButton *startButton;
    //结束时间
    UIButton *endButton;
    //地点
    UITextField *placeField;
    //城市选择按钮
    UIButton *checkCityButton;
    //费用
    UITextField *costField;
    
    //活动说明
    UILabel *explanLabel;
    UILabel *markContectLabel;
    UITextView *contectView;
    
    
    UIDatePicker *datePicker;
    UIView *bgView;
    UIToolbar *toolbar;

    //选择时间标记字段
    NSString *isStart;
    //活动类型提示语
    NSString *isStyleContent;
    //类型id
    NSString *isStyleId;
    //时间段
    NSString *timeRange;
}
@end

@implementation createActivityViewController

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
    self.view.backgroundColor = [UIColor colorWithRed:248.0f/255.0f green:249.0f/255.0f blue:251.0f/255.0f alpha:1.0];
    if (IS_IOS_7) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios7"] forBarMetrics:UIBarMetricsDefault];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios6"] forBarMetrics:UIBarMetricsDefault];
    }
    self.title = @"发布活动";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 22, 40, 40);
    [backButton setBackgroundImage:[UIImage imageNamed:@"login_backButton@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //[self.navigationController.view addSubview:backButton];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;
    
    //发送
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.frame = CGRectMake(526/2, 22, 80/2, 80/2);
    //[sendButton setBackgroundImage:[UIImage imageNamed:@"fasongtiezi@2x"] forState:UIControlStateNormal];
    [sendButton setTitle:@"发布" forState:UIControlStateNormal];
    sendButton.titleLabel.font = [UIFont systemFontOfSize:15];
    //[sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:sendButton];
    self.navigationItem.rightBarButtonItem=rightbuttonitem;

    //背景
    backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-64)];
    backScrollView.backgroundColor = [UIColor clearColor];
    backScrollView.delegate = self;
    backScrollView.showsHorizontalScrollIndicator = NO;
    backScrollView.showsVerticalScrollIndicator = NO;
    if (IS_IOS_7) {
        [backScrollView setContentSize:CGSizeMake(0, [[UIScreen mainScreen] bounds].size.height+130)];
    }else
    {
        [backScrollView setContentSize:CGSizeMake(0, self.view.frame.size.height+130)];
    }
    
    
    backScrollView.userInteractionEnabled = YES;
    [self.view addSubview:backScrollView];
//===================
//    发起人信息
//===================
    //发起人的信息
    UIImageView *createrBackImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 174/2)];
    createrBackImageView.backgroundColor = [UIColor colorWithRed:219.0f/255.0f green:219.0f/255.0f blue:219.0f/255.0f alpha:1.0];
    createrBackImageView.userInteractionEnabled = YES;
    [backScrollView addSubview:createrBackImageView];
    
    //头像
    headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 132/2, 132/2)];
    headerImageView.backgroundColor = [UIColor colorWithRed:91.0f/255.0f green:91.0f/255.0f blue:91.0f/255.0f alpha:1.0];
    [headerImageView.layer setMasksToBounds:YES];
    [headerImageView.layer setCornerRadius:3.0f];
    [headerImageView setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInformation"][@"pic"]] placeholderImage:[UIImage imageNamed:@"ceshi@2x"]];
    [createrBackImageView addSubview:headerImageView];
    
    //发起人姓名nameLabel;
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(162/2, 10, 134/2, 34/2)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = [UIFont systemFontOfSize:16];
    nameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserInformation"][@"name"];
    [createrBackImageView addSubview:nameLabel];
    
    //手机号markPhoneLabel;//phoneLabel;
    markPhoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(298/2, 10, 106/2, 34/2)];
    markPhoneLabel.backgroundColor = [UIColor clearColor];
    markPhoneLabel.textAlignment = NSTextAlignmentLeft;
    markPhoneLabel.textColor = [UIColor blackColor];
    markPhoneLabel.font = [UIFont systemFontOfSize:16];
    markPhoneLabel.text = @"手机号:";
    [createrBackImageView addSubview:markPhoneLabel];
    
    phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(408/2, 10, 220/2, 34/2)];
    phoneLabel.backgroundColor = [UIColor clearColor];
    phoneLabel.textAlignment = NSTextAlignmentLeft;
    phoneLabel.textColor = [UIColor blackColor];
    phoneLabel.font = [UIFont systemFontOfSize:16];
    phoneLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserInformation"][@"phone"];
    [createrBackImageView addSubview:phoneLabel];
    
    UIImageView *linesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(160/2, 58/2, 462/2, 1)];
    linesImageView.backgroundColor = [UIColor clearColor];
    [linesImageView setImage:[UIImage imageNamed:@"xuxian@2x"]];
    [createrBackImageView addSubview:linesImageView];
    
    //公司markCompanyLabel;//companyLabel;
    markCompanyLabel = [[UILabel alloc]initWithFrame:CGRectMake(162/2, 37, 80/2, 34/2)];
    markCompanyLabel.backgroundColor = [UIColor clearColor];
    markCompanyLabel.textAlignment = NSTextAlignmentLeft;
    markCompanyLabel.textColor = [UIColor blackColor];
    markCompanyLabel.font = [UIFont systemFontOfSize:16];
    markCompanyLabel.text = @"公司:";
    [createrBackImageView addSubview:markCompanyLabel];
    
    companyLabel = [[UILabel alloc]initWithFrame:CGRectMake(242/2, 37, 382/2, 34/2)];
    companyLabel.backgroundColor = [UIColor clearColor];
    companyLabel.textAlignment = NSTextAlignmentLeft;
    companyLabel.textColor = [UIColor blackColor];
    companyLabel.font = [UIFont systemFontOfSize:16];
    companyLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserInformation"][@"company"];
    [createrBackImageView addSubview:companyLabel];
    
    UIImageView *linesImageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(160/2, 110/2, 462/2, 1)];
    linesImageView2.backgroundColor = [UIColor clearColor];
    [linesImageView2 setImage:[UIImage imageNamed:@"xuxian@2x"]];
    [createrBackImageView addSubview:linesImageView2];
    
    
    //职位markPositionLabel;//positionLabel;
    markPositionLabel = [[UILabel alloc]initWithFrame:CGRectMake(162/2, 63, 80/2, 34/2)];
    markPositionLabel.backgroundColor = [UIColor clearColor];
    markPositionLabel.textAlignment = NSTextAlignmentLeft;
    markPositionLabel.textColor = [UIColor blackColor];
    markPositionLabel.font = [UIFont systemFontOfSize:16];
    markPositionLabel.text = @"职位:";
    [createrBackImageView addSubview:markPositionLabel];
    
    positionLabel = [[UILabel alloc]initWithFrame:CGRectMake(242/2, 63, 382/2, 34/2)];
    positionLabel.backgroundColor = [UIColor clearColor];
    positionLabel.textAlignment = NSTextAlignmentLeft;
    positionLabel.textColor = [UIColor blackColor];
    positionLabel.font = [UIFont systemFontOfSize:16];
    positionLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserInformation"][@"department"];
    [createrBackImageView addSubview:positionLabel];
    
    UIImageView *linesImageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(160/2, 162/2, 462/2, 1)];
    linesImageView3.backgroundColor = [UIColor clearColor];
    [linesImageView3 setImage:[UIImage imageNamed:@"xuxian@2x"]];
    [createrBackImageView addSubview:linesImageView3];

//==================
//     活动信息
//==================
    //活动信息背景activityMessageImageView;;[0,196/2,320,180]
    sendActivityMessageImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 196/2, [[UIScreen mainScreen] bounds].size.width, 210)];
    sendActivityMessageImageView.userInteractionEnabled = YES;
    sendActivityMessageImageView.backgroundColor = [UIColor whiteColor];
    [sendActivityMessageImageView.layer setMasksToBounds:YES];
    [sendActivityMessageImageView.layer setCornerRadius:3.0f];
    sendActivityMessageImageView.layer.borderWidth = 1.0f;
    sendActivityMessageImageView.layer.borderColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0].CGColor;
    [backScrollView addSubview:sendActivityMessageImageView];
    
    //活动名称markNameLabel;//activityNameLabel;
    UILabel *markNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(30/2, 9, 140/2, 44/2)];
    markNameLabel.backgroundColor = [UIColor clearColor];
    markNameLabel.textAlignment = NSTextAlignmentLeft;
    markNameLabel.textColor = [UIColor blackColor];
    markNameLabel.font = [UIFont systemFontOfSize:16];
    markNameLabel.text = @"活动名称:";
    [sendActivityMessageImageView addSubview:markNameLabel];
    
    activityNameField = [[UITextField alloc]initWithFrame:CGRectMake(206/2, 9, 416/2, 44/2)];
    activityNameField.backgroundColor = [UIColor clearColor];
    activityNameField.font = [UIFont systemFontOfSize:16];
    activityNameField.textAlignment = NSTextAlignmentLeft;
    activityNameField.textColor = [UIColor blackColor];
    activityNameField.placeholder = @"请输入活动名称";
    [sendActivityMessageImageView addSubview:activityNameField];
    
    UIImageView *namelineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20/2, 62/2, 600/2, 1)];
    namelineImageView.backgroundColor = [UIColor clearColor];
    [namelineImageView setImage:[UIImage imageNamed:@"xuxian@2x"]];
    [sendActivityMessageImageView addSubview:namelineImageView];
    
    //活动类型
    UILabel *markStyleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30/2, 34, 140/2, 44/2)];
    markStyleLabel.backgroundColor = [UIColor clearColor];
    markStyleLabel.textAlignment = NSTextAlignmentLeft;
    markStyleLabel.textColor = [UIColor blackColor];
    markStyleLabel.font = [UIFont systemFontOfSize:16];
    markStyleLabel.text = @"活动类型:";
    [sendActivityMessageImageView addSubview:markStyleLabel];
    
    styleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    styleButton.frame = CGRectMake(206/2, 34, 416/2, 44/2);
    [styleButton setBackgroundColor:[UIColor clearColor]];
    [styleButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    styleButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [styleButton setTitle:@"点击选择活动类型" forState:UIControlStateNormal];
    [styleButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
    styleButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft ;
    [styleButton setTitleEdgeInsets:UIEdgeInsetsMake(4, 0, 0, 0)];
    [styleButton addTarget:self action:@selector(clickStyleButton) forControlEvents:UIControlEventTouchUpInside];
    [sendActivityMessageImageView addSubview:styleButton];
    
    UIImageView *stylelineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20/2, 112/2, 600/2, 1)];
    stylelineImageView.backgroundColor = [UIColor clearColor];
    [stylelineImageView setImage:[UIImage imageNamed:@"xuxian@2x"]];
    [sendActivityMessageImageView addSubview:stylelineImageView];

    
    //活动时间
    UILabel *markDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(30/2, 56, 140/2, 44/2)];
    markDateLabel.backgroundColor = [UIColor clearColor];
    markDateLabel.textAlignment = NSTextAlignmentLeft;
    markDateLabel.textColor = [UIColor blackColor];
    markDateLabel.font = [UIFont systemFontOfSize:16];
    markDateLabel.text = @"活动时间:";
    [sendActivityMessageImageView addSubview:markDateLabel];
    
    dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dateButton.frame = CGRectMake(206/2, 56, 416/2, 44/2);
    [dateButton setBackgroundColor:[UIColor clearColor]];
    [dateButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    dateButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [dateButton setTitle:@"点击选择活动时间" forState:UIControlStateNormal];
    [dateButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
    dateButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft ;
    [dateButton setTitleEdgeInsets:UIEdgeInsetsMake(4, 0, 0, 0)];
    dateButton.tag = 6006;
    //[dateButton addTarget:self action:@selector(clickDateButton) forControlEvents:UIControlEventTouchUpInside];
    [dateButton addTarget:self action:@selector(clickCheckTime:) forControlEvents:UIControlEventTouchUpInside];
    [sendActivityMessageImageView addSubview:dateButton];
    
    UIImageView *datelineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20/2, 156/2, 600/2, 1)];
    datelineImageView.backgroundColor = [UIColor clearColor];
    [datelineImageView setImage:[UIImage imageNamed:@"xuxian@2x"]];
    [sendActivityMessageImageView addSubview:datelineImageView];

    //开始时间
    UILabel *markStartTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(30/2, 80, 140/2, 44/2)];
    markStartTimeLabel.backgroundColor = [UIColor clearColor];
    markStartTimeLabel.textAlignment = NSTextAlignmentLeft;
    markStartTimeLabel.textColor = [UIColor blackColor];
    markStartTimeLabel.font = [UIFont systemFontOfSize:16];
    markStartTimeLabel.text = @"开始时间:";
    [sendActivityMessageImageView addSubview:markStartTimeLabel];
    
    
    startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    startButton.frame = CGRectMake(206/2, 80, 416/2, 44/2);
    [startButton setBackgroundColor:[UIColor clearColor]];
    [startButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    startButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [startButton setTitle:@"点击选择活动开始时间" forState:UIControlStateNormal];
    [startButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
    startButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft ;
    [startButton setTitleEdgeInsets:UIEdgeInsetsMake(4, 0, 0, 0)];
    startButton.tag = 3003;
    [startButton addTarget:self action:@selector(clickCheckTime:) forControlEvents:UIControlEventTouchUpInside];
    [sendActivityMessageImageView addSubview:startButton];
    
    UIImageView *startlineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20/2, 204/2, 600/2, 1)];
    startlineImageView.backgroundColor = [UIColor clearColor];
    [startlineImageView setImage:[UIImage imageNamed:@"xuxian@2x"]];
    [sendActivityMessageImageView addSubview:startlineImageView];
    
    //结束时间
    UILabel *markEndTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(30/2, 104, 140/2, 44/2)];
    markEndTimeLabel.backgroundColor = [UIColor clearColor];
    markEndTimeLabel.textAlignment = NSTextAlignmentLeft;
    markEndTimeLabel.textColor = [UIColor blackColor];
    markEndTimeLabel.font = [UIFont systemFontOfSize:16];
    markEndTimeLabel.text = @"结束时间:";
    [sendActivityMessageImageView addSubview:markEndTimeLabel];
    
    endButton = [UIButton buttonWithType:UIButtonTypeCustom];
    endButton.frame = CGRectMake(206/2, 104, 416/2, 44/2);
    [endButton setBackgroundColor:[UIColor clearColor]];
    [endButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    endButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [endButton setTitle:@"点击选择活动结束时间" forState:UIControlStateNormal];
    [endButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
    endButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft ;
    [endButton setTitleEdgeInsets:UIEdgeInsetsMake(4, 0, 0, 0)];
    endButton.tag = 3004;
    [endButton addTarget:self action:@selector(clickCheckTime:) forControlEvents:UIControlEventTouchUpInside];
    [sendActivityMessageImageView addSubview:endButton];
    
    
    UIImageView *endlineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20/2, 252/2, 600/2, 1)];
    endlineImageView.backgroundColor = [UIColor clearColor];
    [endlineImageView setImage:[UIImage imageNamed:@"xuxian@2x"]];
    [sendActivityMessageImageView addSubview:endlineImageView];
    
    //城市
    UILabel *markcityLabel = [[UILabel alloc]initWithFrame:CGRectMake(30/2, 256/2, 140/2, 44/2)];
    markcityLabel.backgroundColor = [UIColor clearColor];
    markcityLabel.textAlignment = NSTextAlignmentRight;
    markcityLabel.textColor = [UIColor blackColor];
    markcityLabel.font = [UIFont systemFontOfSize:16];
    markcityLabel.text = @"城市:";
    [sendActivityMessageImageView addSubview:markcityLabel];
    
    //城市选择按钮 CGRectMake(206/2, 306/2, 416/2, 34/2)
    
    checkCityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    checkCityButton.frame = CGRectMake(206/2, 256/2, 416/2, 44/2);
    [checkCityButton setBackgroundColor:[UIColor clearColor]];
    checkCityButton.titleLabel.font = [UIFont systemFontOfSize:16];
    checkCityButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    checkCityButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    checkCityButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft ;
    //    但问题又出来，此时文字会紧贴到做边框，我们可以设置
    checkCityButton.contentEdgeInsets = UIEdgeInsetsMake(0,2/2, 0, 5);
    [checkCityButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [checkCityButton setTitle:@"点击选择城市" forState:UIControlStateNormal];
    [checkCityButton addTarget:self action:@selector(clickCheckCity) forControlEvents:UIControlEventTouchUpInside];
    [sendActivityMessageImageView addSubview:checkCityButton];
    
    
    UIImageView *citylineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20/2, 300/2, 600/2, 1)];
    citylineImageView.backgroundColor = [UIColor clearColor];
    [citylineImageView setImage:[UIImage imageNamed:@"xuxian@2x"]];
    [sendActivityMessageImageView addSubview:citylineImageView];
    
    //地点
    UILabel *markplaceLabel = [[UILabel alloc]initWithFrame:CGRectMake(30/2, 304/2, 140/2, 44/2)];
    markplaceLabel.backgroundColor = [UIColor clearColor];
    markplaceLabel.textAlignment = NSTextAlignmentRight;
    markplaceLabel.textColor = [UIColor blackColor];
    markplaceLabel.font = [UIFont systemFontOfSize:16];
    markplaceLabel.text = @"地点:";
    [sendActivityMessageImageView addSubview:markplaceLabel];
    
    placeField = [[UITextField alloc]initWithFrame:CGRectMake(206/2, 304/2, 416/2, 44/2)];
    placeField.backgroundColor = [UIColor clearColor];
    placeField.font = [UIFont systemFontOfSize:16];
    placeField.textAlignment = NSTextAlignmentLeft;
    placeField.textColor = [UIColor blackColor];
    placeField.placeholder = @"请输入活动地点";
    [sendActivityMessageImageView addSubview:placeField];
    
    
    UIImageView *placelineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20/2, 348/2, 600/2, 1)];
    placelineImageView.backgroundColor = [UIColor clearColor];
    [placelineImageView setImage:[UIImage imageNamed:@"xuxian@2x"]];
    [sendActivityMessageImageView addSubview:placelineImageView];
    
    //费用
    UILabel *markCostLabel = [[UILabel alloc]initWithFrame:CGRectMake(30/2, 354/2, 140/2, 44/2)];
    markCostLabel.backgroundColor = [UIColor clearColor];
    markCostLabel.textAlignment = NSTextAlignmentRight;
    markCostLabel.textColor = [UIColor blackColor];
    markCostLabel.font = [UIFont systemFontOfSize:16];
    markCostLabel.text = @"费用:";
    [sendActivityMessageImageView addSubview:markCostLabel];
    
    costField = [[UITextField alloc]initWithFrame:CGRectMake(206/2, 354/2, 416/2, 44/2)];
    costField.backgroundColor = [UIColor clearColor];
    costField.font = [UIFont systemFontOfSize:16];
    costField.textAlignment = NSTextAlignmentLeft;
    costField.textColor = [UIColor blackColor];
    costField.placeholder = @"请输入活动费用";
    [sendActivityMessageImageView addSubview:costField];
    
    UIImageView *costlineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20/2, 398/2, 600/2, 1)];
    costlineImageView.backgroundColor = [UIColor clearColor];
    [costlineImageView setImage:[UIImage imageNamed:@"xuxian@2x"]];
    [sendActivityMessageImageView addSubview:costlineImageView];
    
    //活动说明
    explanLabel = [[UILabel alloc]initWithFrame:CGRectMake(18/2, sendActivityMessageImageView.frame.origin.y+sendActivityMessageImageView.frame.size.height+9, 140/2, 34/2)];
    explanLabel.backgroundColor = [UIColor clearColor];
    explanLabel.textAlignment = NSTextAlignmentRight;
    explanLabel.textColor = [UIColor lightGrayColor];
    explanLabel.font = [UIFont systemFontOfSize:16];
    explanLabel.text = @"活动说明";
    [backScrollView addSubview:explanLabel];
    
    //内容背景框
    UIImageView *contectImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, explanLabel.frame.origin.y+explanLabel.frame.size.height+9, 300, 300/2)];
    contectImageView.backgroundColor = [UIColor clearColor];
    [contectImageView setImage:[UIImage imageNamed:@"qiangneirong@2x"]];
    contectImageView.userInteractionEnabled = YES;
    [backScrollView addSubview:contectImageView];
    
    markContectLabel = [[UILabel alloc]initWithFrame:CGRectMake(4/2, 9, 130/2, 32/2)];
    markContectLabel.backgroundColor = [UIColor clearColor];
    markContectLabel.textAlignment = NSTextAlignmentLeft;
    markContectLabel.textColor = [UIColor blackColor];
    markContectLabel.font = [UIFont systemFontOfSize:15];
    
    [contectImageView addSubview:markContectLabel];
    
    contectView = [[UITextView alloc]initWithFrame:CGRectMake(66, 0, 454/2, 276/2)];
    contectView.backgroundColor = [UIColor clearColor];
    contectView.textAlignment = NSTextAlignmentLeft;
    contectView.textColor = [UIColor blackColor];
    contectView.font = [UIFont systemFontOfSize:15];
    contectView.editable = YES;
    
    [contectImageView addSubview:contectView];
    
    //点击背景取消键盘
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(handleBackgroundTap:)];
    tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapRecognizer];
}
//取消键盘
- (void) handleBackgroundTap:(UITapGestureRecognizer*)sender
{
    [activityNameField resignFirstResponder];
    [placeField resignFirstResponder];
    [costField resignFirstResponder];
    [contectView resignFirstResponder];
    
}

#pragma mark - 返回
- (void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 选择城市
- (void)clickCheckCity
{
    CheckActivityCityViewController *checkActivityCityVC = [[CheckActivityCityViewController alloc]init];
    checkActivityCityVC.delegate = self;
    [self.navigationController pushViewController:checkActivityCityVC animated:YES];

}
#pragma mark - 代理传值-选择城市
- (void)setActivityCityValueWith:(NSString *)cityDic
{
    
    [checkCityButton setTitle:cityDic forState:UIControlStateNormal];
   
}

#pragma mark - 发送
- (void)sendButtonClicked
{
    if ([activityNameField.text length]==0) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"活动名称不能为空"];
    }else if ([isStyleId length]==0)
    {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"活动类型不能为空"];
    }else if ([dateButton.titleLabel.text length]==0)
    {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"活动时间不能为空"];
    }else if ([startButton.titleLabel.text isEqualToString:@"点击选择活动开始时间"])
    {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"活动开始时间不能为空"];
    }else if ([endButton.titleLabel.text isEqualToString:@"点击选择活动结束时间"])
    {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"活动结束时间不能为空"];
    }else if ([placeField.text length]==0)
    {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"活动地点不能为空"];
    }else if ([costField.text length]==0)
    {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"活动费用不能为空"];
    }else if ([contectView.text length]==0)
    {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"活动说明不能为空"];
    }else
    {
        NSString *placeStr = [NSString stringWithFormat:@"%@%@",checkCityButton.titleLabel.text,placeField.text];
        [BCHTTPRequest PostTheSendActivityMessageWithTitle:activityNameField.text  WithStyleId:isStyleId WithStartTime:startButton.titleLabel.text WithTimeRangeID:dateButton.titleLabel.text WithEndTime:endButton.titleLabel.text WithAreaName:placeStr WithPaymentRange:costField.text WithContent:contectView.text UsingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}
#pragma mark - 选择活动类型
- (void)clickStyleButton
{
    CheckActivityStyleViewController *checkActivityStyleVC = [[CheckActivityStyleViewController alloc]init];
    checkActivityStyleVC.delegate = self;
    [self.navigationController pushViewController:checkActivityStyleVC animated:YES];
}
#pragma mark - 选择活动时间
- (void)clickDateButton
{
    CheckActivityDateViewController *checkActivityDateVC = [[CheckActivityDateViewController alloc]init];
    checkActivityDateVC.delegate = self;
    checkActivityDateVC.styleId = isStyleId;
    [self.navigationController pushViewController:checkActivityDateVC animated:YES];
}
//#pragma mark - 选择活动开始时间
//- (void)clickCheckTime:(UIButton *)
//{
//    
//    isStart = @"start";
//}
//#pragma mark - 选择活动结束时间
//- (void)clickEndButton
//{
//    isStart = @"end";
//}
#pragma mark - 代理传值 - 时间
- (void)setDateValueWith:(NSDictionary *)dateDictionary
{
    [dateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [dateButton setTitle:dateDictionary[@"time"] forState:UIControlStateNormal];
    timeRange = dateDictionary[@"id"];
}
#pragma mark - 代理传值 - 类型
- (void)setStyleValueWith:(NSDictionary *)StyleDictionary
{
    [styleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [styleButton setTitle:StyleDictionary[@"name"] forState:UIControlStateNormal];
    isStyleContent = StyleDictionary[@"content"];
    isStyleId = StyleDictionary[@"id"];
    markContectLabel.text = [NSString stringWithFormat:@"%@:",StyleDictionary[@"name"]];
    contectView.text = isStyleContent;
}
-(void)clickCheckTime:(UIButton *)button
{
    bgView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    bgView.backgroundColor = [UIColor colorWithRed:.0f/255.0f green:.0f/255.0f blue:.0f/255.0f alpha:0.8];
    [self.view addSubview:bgView];
    
    
    
    if (!datePicker) {
        //选择有效期 datePicker
        //datePicker上面的工具栏
        UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(clickCancelButton1)];
        UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(clickDeleteButton3)];
        //doneButtonItem.tag = button.tag;
        UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, 320, 44)];
        toolbar.barStyle = UIBarStyleBlackTranslucent;
        [toolbar setItems:[NSArray arrayWithObjects:cancelButtonItem,spaceButtonItem,doneButtonItem,nil]];
        [self.view addSubview:toolbar];
        datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, 320, 216)];
        datePicker.backgroundColor = [UIColor whiteColor];
        if (button.tag == 6006)
        {
            datePicker.datePickerMode = UIDatePickerModeDate;
        }else
        {
            
            datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
        }
        
        [datePicker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:datePicker];
    }else{
        if (button.tag == 6006)
        {
            datePicker.datePickerMode = UIDatePickerModeDate;
        }else
        {
            
            datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
        }

    }
    [self showDatePicker];
    [self.view bringSubviewToFront:toolbar];
    [self.view bringSubviewToFront:datePicker];
    
    if (button.tag == 3003) {
        isStart = @"start";
    }else if (button.tag == 3004)
    {
        isStart = @"end";
    }else if (button.tag == 6006)
    {
        isStart = @"time";
       
    }
    
}
//动画 选择有效期时间
- (void)showDatePicker
{
    
    [UIView animateWithDuration:0.3 animations:^{
        toolbar.frame = CGRectMake(0, self.view.frame.size.height-216-76/2, 320, 76/2);
        datePicker.frame = CGRectMake(0, self.view.frame.size.height-216, 320, 216);
    }];
    
}
- (void)hideDatePicker
{
    [UIView animateWithDuration:0.4 animations:^{
        toolbar.frame = CGRectMake(0, self.view.frame.size.height, 320, 76/2);
        datePicker.frame = CGRectMake(0, self.view.frame.size.height, 320, 216);
        [bgView removeFromSuperview];
    }];
    
}
//取出年月日
- (void)dateChanged
{
    
    NSDate *selectedDate = [datePicker date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    NSLog(@"%@",[formatter stringFromDate:selectedDate]);
    if ([isStart isEqualToString:@"start"]) {
        [formatter setDateFormat:@"HH:mm"];
        [startButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [startButton setTitle:[formatter stringFromDate:selectedDate] forState:UIControlStateNormal];
    }else if ([isStart isEqualToString:@"end"])
    {
        [formatter setDateFormat:@"HH:mm"];
        [endButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [endButton setTitle:[formatter stringFromDate:selectedDate] forState:UIControlStateNormal];
    }else if ([isStart isEqualToString:@"time"])
    {
        [formatter setDateFormat:@"yyyy-MM-dd"];
        [dateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [dateButton setTitle:[formatter stringFromDate:selectedDate] forState:UIControlStateNormal];
    }
    
    
}
-(void)clickCancelButton1
{
    [self hideDatePicker];
}
-(void)clickDeleteButton3
{
    [self hideDatePicker];
    
    
    [self dateChanged];
    
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
