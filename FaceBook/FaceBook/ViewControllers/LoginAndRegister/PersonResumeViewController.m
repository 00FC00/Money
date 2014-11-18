//
//  PersonResumeViewController.m
//  FaceBook
//
//  Created by fengshaohui on 14-5-6.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "PersonResumeViewController.h"
#import "BCHTTPRequest.h"
#import "AFNetworking.h"
#import "ProfessionExperienceViewController.h"
#import "ProjectExperienceViewController.h"
#import "EducationExperienceViewController.h"
//#import "MyFaceBookGroupViewController.h"

#import "AppDelegate.h"
@interface PersonResumeViewController ()
{
    //背景ScrollView
    UIScrollView *backScrollView;
    //头像
    UIImageView *headImageView;
    //姓名
    UILabel *nameLabel;
    //职位标签
    UILabel *markPositionLabel;
    //职位
    UILabel *positionLabel;
    //公司名字
    UILabel *companyNameLabel;
    //基本资料
    UIImageView *basicMessageImageView;
    UILabel *markBasicLabel;
    //性别
    UIImageView *genderImageView;
    UILabel *markGenderLabel;
    UILabel *genderLabel;
    
    //职业经历数组
    UIImageView *alljobBackImageView;
    UIImageView *jobBackImageView;
    NSMutableArray *jobArray;
    //教育经历数组
    UIImageView *allstudyBackImageView;
    UIImageView *studyBackImageView;
    NSMutableArray *studyArray;
    //项目经理数组
    UIImageView *allprojectBackImageView;
    UIImageView *projectBackImageView;
    NSMutableArray *projectArray;
    
    CGSize size;
    CGSize size1;
}
@end

@implementation PersonResumeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        jobArray = [[NSMutableArray alloc]initWithCapacity:100];
        studyArray = [[NSMutableArray alloc]initWithCapacity:100];
        projectArray = [[NSMutableArray alloc]initWithCapacity:100];
        
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
    self.title = @"个人简历";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    //返回
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 22, 40, 40);
    [backButton setBackgroundImage:[UIImage imageNamed:@"login_backButton@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //[self.navigationController.view addSubview:backButton];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;
    
    
//    //完成
    //跳过
    UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    finishButton.frame = CGRectMake(526/2, 20+(44-42/2)/2, 84/2, 42/2);
    [finishButton setBackgroundImage:[UIImage imageNamed:@"login_RegistrationButton_03@2x"] forState:UIControlStateNormal];
    [finishButton setTitle:@"完成" forState:UIControlStateNormal];
    finishButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [finishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [finishButton addTarget:self action:@selector(finishButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //[self.navigationController.view addSubview:finishButton];
    UIBarButtonItem *rightbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:finishButton];
    self.navigationItem.rightBarButtonItem=rightbuttonitem;


    //背景
    backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-44)];
    backScrollView.showsHorizontalScrollIndicator = NO;
    backScrollView.delegate = self;
    backScrollView.backgroundColor = [UIColor clearColor];
    backScrollView.userInteractionEnabled = YES;

    [self.view addSubview:backScrollView];
    
    [self basicMessage];
    
    [self getTheData];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"refushPersonResume" object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        [alljobBackImageView  removeFromSuperview];
        [allprojectBackImageView removeFromSuperview];
        [allstudyBackImageView removeFromSuperview];
        [self getTheData];
    }];

 

}
#pragma mark - 基本资料
- (void)basicMessage
{
    //头像headImageView;
    headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(11, 9, 121/2, 121/2)];
    headImageView.backgroundColor = [UIColor clearColor];
    headImageView.userInteractionEnabled = YES;
    //setImage:[UIImage imageNamed:@"touxiangmoren@2x"]
    [headImageView setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInformation"][@"pic"]] placeholderImage:[UIImage imageNamed:@"touxiangmoren@2x"]];
    [backScrollView addSubview:headImageView];
    
    //姓名nameLabel;
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(172/2, 8, 448/2, 34/2)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = [UIFont systemFontOfSize:16];
    nameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserInformation"][@"name"];
    [backScrollView addSubview:nameLabel];
    
    //职位标签markPositionLabel;
    markPositionLabel = [[UILabel alloc]initWithFrame:CGRectMake(172/2, 80/2, 66/2, 30/2)];
    markPositionLabel.backgroundColor = [UIColor clearColor];
    markPositionLabel.textAlignment = NSTextAlignmentLeft;
    markPositionLabel.textColor = [UIColor grayColor];
    markPositionLabel.font = [UIFont systemFontOfSize:14];
    markPositionLabel.text = @"职位:";
    [backScrollView addSubview:markPositionLabel];
    
    //职位positionLabel;
    positionLabel = [[UILabel alloc]initWithFrame:CGRectMake(248/2, 80/2, 372/2, 30/2)];
    positionLabel.backgroundColor = [UIColor clearColor];
    positionLabel.textAlignment = NSTextAlignmentLeft;
    positionLabel.textColor = [UIColor grayColor];
    positionLabel.font = [UIFont systemFontOfSize:14];
    positionLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserInformation"][@"department"];
    [backScrollView addSubview:positionLabel];
    
    //公司名字companyNameLabel;
    companyNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(172/2, 117/2, 448/2, 30/2)];
    companyNameLabel.backgroundColor = [UIColor clearColor];
    companyNameLabel.textAlignment = NSTextAlignmentLeft;
    companyNameLabel.textColor = [UIColor grayColor];
    companyNameLabel.font = [UIFont systemFontOfSize:14];
    companyNameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserInformation"][@"company"];
    [backScrollView addSubview:companyNameLabel];
    
    //基本资料basicMessageImageView;markBasicLabel;
    basicMessageImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20/2, 88, 300, 21)];
    basicMessageImageView.backgroundColor = [UIColor clearColor];
    [basicMessageImageView setImage:[UIImage imageNamed:@"jibenziliao@2x"]];
    basicMessageImageView.userInteractionEnabled = YES;
    [backScrollView addSubview:basicMessageImageView];
    
    markBasicLabel = [[UILabel alloc]initWithFrame:CGRectMake(18/2, 3, 100, 15)];
    markBasicLabel.backgroundColor = [UIColor clearColor];
    markBasicLabel.textAlignment = NSTextAlignmentLeft;
    markBasicLabel.textColor = [UIColor whiteColor];
    markBasicLabel.font = [UIFont systemFontOfSize:14];
    markBasicLabel.text = @"基本资料";
    [basicMessageImageView addSubview:markBasicLabel];
    
    //性别genderImageView;markGenderLabel;genderLabel;
    genderImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20/2, 115, 300, 21)];
    genderImageView.backgroundColor = [UIColor clearColor];
    [genderImageView setImage:[UIImage imageNamed:@"xingbiebeijing@2x"]];
    genderImageView.userInteractionEnabled = YES;
    [backScrollView addSubview:genderImageView];
    
    markGenderLabel = [[UILabel alloc]initWithFrame:CGRectMake(18/2, 3, 74/2, 15)];
    markGenderLabel.backgroundColor = [UIColor clearColor];
    markGenderLabel.textAlignment = NSTextAlignmentLeft;
    markGenderLabel.textColor = [UIColor whiteColor];
    markGenderLabel.font = [UIFont systemFontOfSize:14];
    markGenderLabel.text = @"性别:";
    [genderImageView addSubview:markGenderLabel];
    
    genderLabel = [[UILabel alloc]initWithFrame:CGRectMake(94/2, 3, 74/2, 15)];
    genderLabel.backgroundColor = [UIColor clearColor];
    genderLabel.textAlignment = NSTextAlignmentLeft;
    genderLabel.textColor = [UIColor whiteColor];
    genderLabel.font = [UIFont systemFontOfSize:14];
    NSString *sexStr = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInformation"] objectForKey:@"gender"];
    if ([sexStr intValue] == 2) {
        genderLabel.text = @"女";
    }else if ([sexStr intValue] == 1)
    {
        genderLabel.text = @"男";
    }else
    {
        genderLabel.text = @"保密";
    }
    
    //genderLabel.text = @"男";
    [genderImageView addSubview:genderLabel];

}
#pragma mark - 获取数据
- (void)getTheData
{
    //简历信息
    [BCHTTPRequest getMyPersonResumeListWithUsingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            //有数据进行完善
            if ([resultDic[@"occupation"] count]>0 || [resultDic[@"education"] count]>0 || [resultDic[@"project"] count]>0) {
                
                [self CompleteThePersonResume];
            }else
            {
                //无数据第一次登陆
                
                [self TheFirstLoginView];
                
            }
        }
        
    }];

}
#pragma mark - 返回
- (void)backButtonClicked
{
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}
#pragma mark - 完成
- (void)finishButtonClicked
{
//     MyFaceBookGroupViewController *myFaceBookGroupViewController = [[MyFaceBookGroupViewController alloc] init];
//    [self.navigationController pushViewController:myFaceBookGroupViewController animated:YES];
    
    if ([self.isLogin isEqualToString:@"login"]) {
        [self dismissViewControllerAnimated:YES completion:^{
            ;
        }];
        //发通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"logfengback" object:nil];
    }else
    {
        DDMenuController * rootController = ((AppDelegate*)[UIApplication sharedApplication].delegate).menuController;
        [self presentViewController:rootController animated:NO completion:^{
            ;
        }];
 
    }
}
#pragma mark - 有数据进行完善
- (void)CompleteThePersonResume
{
    for (UIView *sview in backScrollView.subviews) {
        [sview removeFromSuperview];
    }
    [self basicMessage];
    //获得三个经历的数据
    [BCHTTPRequest getMyPersonResumeListWithUsingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            
            //if ([resultDic[@"occupation"] count]>0) {
                jobArray = resultDic[@"occupation"];
                //职业
                [self LoadingTheJobViewWithJobArray:jobArray];
           // }
            
            //if ([resultDic[@"education"] count]>0) {
                studyArray = resultDic[@"education"];
                //教育
                [self LoadingTheCollegeViewWithCollegeArray:studyArray];

          //  }
          //  if ([resultDic[@"project"] count]>0) {
                projectArray = resultDic[@"project"];
                //项目
                [self LoadingTheProjectViewWithProjectArray:projectArray];
          //  }
            
            
            [backScrollView setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width, 138+alljobBackImageView.frame.size.height+allstudyBackImageView.frame.size.height+allprojectBackImageView.frame.size.height+40)];
            
        }
    }];
    
    
}
#pragma mark - 有数据-职业加载
- (void)LoadingTheJobViewWithJobArray:(NSMutableArray *)jArray
{
    //职业经历大背景initWithFrame:CGRectMake(0, 276/2, 320, 370/2)
//    if (alljobBackImageView) {
//        [alljobBackImageView removeFromSuperview];
//    }else
//    {
    alljobBackImageView = [[UIImageView alloc]init];
    alljobBackImageView.backgroundColor = [UIColor clearColor];
    alljobBackImageView.userInteractionEnabled = YES;
    [backScrollView addSubview:alljobBackImageView];
//    }
     CGFloat myHeught = 43;
    
    
    //****职业经历的标题栏
    UIImageView *h_markTitleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 9, 320, 67/2)];
    h_markTitleImageView.backgroundColor = [UIColor clearColor];
    [h_markTitleImageView setImage:[UIImage imageNamed:@"xiangmubeijing@2x"]];
    h_markTitleImageView.userInteractionEnabled = YES;
    [alljobBackImageView addSubview:h_markTitleImageView];
    
    //****职业经历标题
    UILabel *h_markJobTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(9, 8, 100, 33/2)];
    h_markJobTitleLabel.backgroundColor = [UIColor clearColor];
    h_markJobTitleLabel.textAlignment = NSTextAlignmentLeft;
    h_markJobTitleLabel.textColor = [UIColor whiteColor];
    h_markJobTitleLabel.font = [UIFont systemFontOfSize:14];
    h_markJobTitleLabel.text = @"职业经历";
    [h_markTitleImageView addSubview:h_markJobTitleLabel];
    
    //****职业经历添加按钮
    UIButton *h_jobAddButton = [UIButton buttonWithType:UIButtonTypeCustom];
    h_jobAddButton.backgroundColor = [UIColor clearColor];
    h_jobAddButton.frame = CGRectMake(555/2, 0, 85/2, 33);
    [h_jobAddButton setBackgroundImage:[UIImage imageNamed:@"zengjia@2x"] forState:UIControlStateNormal];
    [h_jobAddButton addTarget:self action:@selector(clicknoJobButton) forControlEvents:UIControlEventTouchUpInside];
    [h_markTitleImageView addSubview:h_jobAddButton];

    for (int i = 0; i<jArray.count; i++) {
        //每一条信息的背景
        UIImageView *oneJobImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,43+145*i, 320, 145)];
        if (i%2 ==0 ) {
            oneJobImageView.backgroundColor = [UIColor whiteColor];
        }else if (i%2 == 1)
        {
            oneJobImageView.backgroundColor = [UIColor colorWithRed:242.0f/255.0f green:243.0f/255.0f blue:245.0f/255.0f alpha:1.0];
        }
        
        oneJobImageView.userInteractionEnabled = YES;
        [alljobBackImageView addSubview:oneJobImageView];
        
        //****经历详情的背景
        UIImageView *h_jobDetialsImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 152/2)];
       // h_jobDetialsImageView.backgroundColor = [UIColor colorWithRed:242.0f/255.0f green:243.0f/255.0f blue:245.0f/255.0f alpha:1.0];
        if (i%2 ==0 ) {
             h_jobDetialsImageView.backgroundColor = [UIColor whiteColor];
        }else if (i%2 == 1)
        {
             h_jobDetialsImageView.backgroundColor = [UIColor colorWithRed:242.0f/255.0f green:243.0f/255.0f blue:245.0f/255.0f alpha:1.0];
        }
       
        h_jobDetialsImageView.userInteractionEnabled = YES;
        [oneJobImageView addSubview:h_jobDetialsImageView];
        
        //****就职日期
        UILabel *h_jobDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, 8, 430/2, 30/2)];
        h_jobDateLabel.backgroundColor = [UIColor clearColor];
        h_jobDateLabel.textAlignment = NSTextAlignmentLeft;
        h_jobDateLabel.textColor = [UIColor lightGrayColor];
        h_jobDateLabel.font = [UIFont systemFontOfSize:14];
        h_jobDateLabel.text = [NSString stringWithFormat:@"%@~%@",jArray[i][@"start_time"],jArray[i][@"end_time"]];
        [h_jobDetialsImageView addSubview:h_jobDateLabel];
        
        //****就职地点
        UILabel *h_jobPlaceLabel = [[UILabel alloc]initWithFrame:CGRectMake(464/2, 8, 160/2, 30/2)];
        h_jobPlaceLabel.backgroundColor = [UIColor clearColor];
        h_jobPlaceLabel.textAlignment = NSTextAlignmentLeft;
        h_jobPlaceLabel.textColor = [UIColor lightGrayColor];
        h_jobPlaceLabel.font = [UIFont systemFontOfSize:14];
        h_jobPlaceLabel.text = jArray[i][@"work_place"];
        [h_jobDetialsImageView addSubview:h_jobPlaceLabel];
        
        //****就职公司
        UILabel *h_jobCompanyLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, 30, 586/2, 30/2)];
        h_jobCompanyLabel.backgroundColor = [UIColor clearColor];
        h_jobCompanyLabel.textAlignment = NSTextAlignmentLeft;
        h_jobCompanyLabel.textColor = [UIColor lightGrayColor];
        h_jobCompanyLabel.font = [UIFont systemFontOfSize:14];
        h_jobCompanyLabel.text = jArray[i][@"com_name"];
        [h_jobDetialsImageView addSubview:h_jobCompanyLabel];
        
        //****就职的职位
        UILabel *h_jobPositionLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, 106/2, 586/2, 30/2)];
        h_jobPositionLabel.backgroundColor = [UIColor clearColor];
        h_jobPositionLabel.textAlignment = NSTextAlignmentLeft;
        h_jobPositionLabel.textColor = [UIColor lightGrayColor];
        h_jobPositionLabel.font = [UIFont systemFontOfSize:14];
        h_jobPositionLabel.text = [NSString stringWithFormat:@"%@/%@",jArray[i][@"department_name"],jArray[i][@"work_field"] ];
        [h_jobDetialsImageView addSubview:h_jobPositionLabel];
        
//        //****描述内容initWithFrame:CGRectMake(17, h_jobDetialsImageView.frame.size.height+43+10, 580/2, 32/2)
        
        UILabel *h_describeLabel = [[UILabel alloc]init];
        h_describeLabel.backgroundColor = [UIColor clearColor];
        h_describeLabel.textAlignment = NSTextAlignmentLeft;
        h_describeLabel.textColor = [UIColor lightGrayColor];
        h_describeLabel.font = [UIFont systemFontOfSize:14];
        
        h_describeLabel.numberOfLines = 0;
        NSString *str =jArray[i][@"job_description"];
        if (IS_IOS_7) {
            NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
            size = [str boundingRectWithSize:CGSizeMake(580/2, 60) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
            
        }else
        {
            size = [str sizeWithFont:[UIFont systemFontOfSize:15]constrainedToSize:CGSizeMake(180,60) lineBreakMode:NSLineBreakByWordWrapping];
        }
        
        h_describeLabel.frame = CGRectMake(17, 156/2, 580/2, size.height);

        h_describeLabel.text =str;
        [oneJobImageView addSubview:h_describeLabel];
        
//        //蓝线
//        UIImageView *xianImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, oneJobImageView.frame.size.height-1, 320, 1)];
//        if (i == jArray.count-1) {
//            xianImageView.backgroundColor = [UIColor clearColor];
//        }else
//        {
//            xianImageView.backgroundColor = [UIColor colorWithRed:185.0f/255.0f green:203.0f/255.0f blue:238.0f/255.0f alpha:1.0];
//        }
//        
//        [oneJobImageView addSubview:xianImageView];
        
        //****职业经历编辑按钮
        UIButton *h_jobEditButton = [UIButton buttonWithType:UIButtonTypeCustom];
        h_jobEditButton.backgroundColor = [UIColor clearColor];
        h_jobEditButton.frame = CGRectMake(0, 1, 320, oneJobImageView.frame.size.height);
        //[h_jobEditButton setBackgroundImage:[UIImage imageNamed:@"zengjia@2x"] forState:UIControlStateNormal];
        h_jobEditButton.tag = 10000+i;
        [h_jobEditButton addTarget:self action:@selector(clickJobEditButton:) forControlEvents:UIControlEventTouchUpInside];
        [oneJobImageView addSubview:h_jobEditButton];
        
       
        myHeught =myHeught+oneJobImageView.frame.size.height;

    }
    alljobBackImageView.frame = CGRectMake(0, 276/2, 320, myHeught);
}
#pragma mark - 有数据-教育加载
- (void)LoadingTheCollegeViewWithCollegeArray:(NSMutableArray *)cArray
{
    CGFloat collegeHeught = 43;
    //教育经历
    //****教育经历的背景
    allstudyBackImageView = [[UIImageView alloc]init];
    allstudyBackImageView.backgroundColor = [UIColor clearColor];
    allstudyBackImageView.userInteractionEnabled = YES;
    [backScrollView addSubview:allstudyBackImageView];
    
    //****教育经历的标题栏
    UIImageView *h_markstudyImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 9, 320, 67/2)];
    h_markstudyImageView.backgroundColor = [UIColor clearColor];
    [h_markstudyImageView setImage:[UIImage imageNamed:@"xiangmubeijing@2x"]];
    h_markstudyImageView.userInteractionEnabled = YES;
    [allstudyBackImageView addSubview:h_markstudyImageView];
    
    //****教育经历标题
    UILabel *h_markStudyTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(9, 8, 100, 33/2)];
    h_markStudyTitleLabel.backgroundColor = [UIColor clearColor];
    h_markStudyTitleLabel.textAlignment = NSTextAlignmentLeft;
    h_markStudyTitleLabel.textColor = [UIColor whiteColor];
    h_markStudyTitleLabel.font = [UIFont systemFontOfSize:14];
    h_markStudyTitleLabel.text = @"教育经历";
    [h_markstudyImageView addSubview:h_markStudyTitleLabel];
    
    //****教育经历添加按钮
    UIButton *h_studyAddButton = [UIButton buttonWithType:UIButtonTypeCustom];
    h_studyAddButton.backgroundColor = [UIColor clearColor];
    h_studyAddButton.frame = CGRectMake(555/2, 0, 85/2, 33);
    [h_studyAddButton setBackgroundImage:[UIImage imageNamed:@"zengjia@2x"] forState:UIControlStateNormal];
    [h_studyAddButton addTarget:self action:@selector(clicknostudyAddButton) forControlEvents:UIControlEventTouchUpInside];
    [h_markstudyImageView addSubview:h_studyAddButton];
    
    for (int j = 0; j< cArray.count; j++) {
        
    //****教育经历详情的背景
    UIImageView *h_studyDetialsImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 43+76*j, 320, 152/2)];
        if (j%2 == 0) {
            h_studyDetialsImageView.backgroundColor = [UIColor colorWithRed:242.0f/255.0f green:243.0f/255.0f blue:245.0f/255.0f alpha:1.0];
        }else
        {
            h_studyDetialsImageView.backgroundColor = [UIColor whiteColor ];
        }
    
    h_studyDetialsImageView.userInteractionEnabled = YES;
    [allstudyBackImageView addSubview:h_studyDetialsImageView];
    
    //****教育经历日期
    UILabel *studyDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(148/2, 8, 460/2, 30/2)];
    studyDateLabel.backgroundColor = [UIColor clearColor];
    studyDateLabel.textAlignment = NSTextAlignmentLeft;
    studyDateLabel.textColor = [UIColor lightGrayColor];
    studyDateLabel.font = [UIFont systemFontOfSize:14];
    studyDateLabel.text = [NSString stringWithFormat:@"%@~%@",cArray[j][@"start_time"],cArray[j][@"end_time"]];
    [h_studyDetialsImageView addSubview:studyDateLabel];
    
    UILabel *MarkStudyDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(16/2, 8, 130/2, 30/2)];
    MarkStudyDateLabel.backgroundColor = [UIColor clearColor];
    MarkStudyDateLabel.textAlignment = NSTextAlignmentRight;
    MarkStudyDateLabel.textColor = [UIColor lightGrayColor];
    MarkStudyDateLabel.font = [UIFont systemFontOfSize:14];
    MarkStudyDateLabel.text = @"时间:";
    [h_studyDetialsImageView addSubview:MarkStudyDateLabel];
    
    //****教育所在大学
    UILabel *markCollegeLabel = [[UILabel alloc]initWithFrame:CGRectMake(16/2, 30, 130/2, 30/2)];
    markCollegeLabel.backgroundColor = [UIColor clearColor];
    markCollegeLabel.textAlignment = NSTextAlignmentRight;
    markCollegeLabel.textColor = [UIColor lightGrayColor];
    markCollegeLabel.font = [UIFont systemFontOfSize:14];
    markCollegeLabel.text = @"毕业院校:";
    [h_studyDetialsImageView addSubview:markCollegeLabel];
    
    UILabel *collegeLabel = [[UILabel alloc]initWithFrame:CGRectMake(148/2, 30, 470/2, 30/2)];
    collegeLabel.backgroundColor = [UIColor clearColor];
    collegeLabel.textAlignment = NSTextAlignmentLeft;
    collegeLabel.textColor = [UIColor lightGrayColor];
    collegeLabel.font = [UIFont systemFontOfSize:14];
    collegeLabel.text = cArray[j][@"graduate_institutions"];
    [h_studyDetialsImageView addSubview:collegeLabel];
    
    //****学位
    UILabel *markDegreeLabel = [[UILabel alloc]initWithFrame:CGRectMake(16/2, 106/2, 130/2, 30/2)];
    markDegreeLabel.backgroundColor = [UIColor clearColor];
    markDegreeLabel.textAlignment = NSTextAlignmentRight;
    markDegreeLabel.textColor = [UIColor lightGrayColor];
    markDegreeLabel.font = [UIFont systemFontOfSize:14];
    markDegreeLabel.text = @"学位:";
    [h_studyDetialsImageView addSubview:markDegreeLabel];
    
    UILabel *degreeLabel = [[UILabel alloc]initWithFrame:CGRectMake(146/2, 106/2, 130/2, 30/2)];
    degreeLabel.backgroundColor = [UIColor clearColor];
    degreeLabel.textAlignment = NSTextAlignmentLeft;
    degreeLabel.textColor = [UIColor lightGrayColor];
    degreeLabel.font = [UIFont systemFontOfSize:14];
    degreeLabel.text = cArray[j][@"degree"];
    [h_studyDetialsImageView addSubview:degreeLabel];
    
    //****专业
    UILabel *markMajorLabel = [[UILabel alloc]initWithFrame:CGRectMake(306/2, 106/2, 78/2, 30/2)];
    markMajorLabel.backgroundColor = [UIColor clearColor];
    markMajorLabel.textAlignment = NSTextAlignmentLeft;
    markMajorLabel.textColor = [UIColor lightGrayColor];
    markMajorLabel.font = [UIFont systemFontOfSize:14];
    markMajorLabel.text = @"专业:";
    [h_studyDetialsImageView addSubview:markMajorLabel];
    
    UILabel *majorLabel = [[UILabel alloc]initWithFrame:CGRectMake(384/2, 106/2, 244/2, 30/2)];
    majorLabel.backgroundColor = [UIColor clearColor];
    majorLabel.textAlignment = NSTextAlignmentLeft;
    majorLabel.textColor = [UIColor lightGrayColor];
    majorLabel.font = [UIFont systemFontOfSize:14];
    majorLabel.text = cArray[j][@"professional"];
    [h_studyDetialsImageView addSubview:majorLabel];
    
    //教育经历编辑按钮
    UIButton *studyEditButton = [UIButton buttonWithType:UIButtonTypeCustom];
    studyEditButton.backgroundColor = [UIColor clearColor];
    studyEditButton.frame = CGRectMake(0, 0, 320, h_studyDetialsImageView.frame.size.height);
    //[studyEditButton setBackgroundImage:[UIImage imageNamed:@"zengjia@2x"] forState:UIControlStateNormal];
        studyEditButton.tag = 20000+j;
        [studyEditButton addTarget:self action:@selector(clickStudyEditButton:) forControlEvents:UIControlEventTouchUpInside];
    [h_studyDetialsImageView addSubview:studyEditButton];
        

        collegeHeught = collegeHeught+h_studyDetialsImageView.frame.size.height;
    }
    //initWithFrame:CGRectMake(0, 276/2+jobBackImageView.frame.size.height, 320, 238/2)
    allstudyBackImageView.frame = CGRectMake(0, 276/2+alljobBackImageView.frame.size.height, 320, collegeHeught);
}
#pragma mark - 有数据-项目加载
- (void)LoadingTheProjectViewWithProjectArray:(NSMutableArray *)pArray
{
    CGFloat pHeught = 43;
    //项目经历
    //****项目经历的背景
    allprojectBackImageView = [[UIImageView alloc]init];
    allprojectBackImageView.backgroundColor = [UIColor clearColor];
    allprojectBackImageView.userInteractionEnabled = YES;
    [backScrollView addSubview:allprojectBackImageView];
    
    //****项目经历的标题字段背景
    UIImageView *h_markProjectImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 9, 320, 67/2)];
    h_markProjectImageView.backgroundColor = [UIColor clearColor];
    [h_markProjectImageView setImage:[UIImage imageNamed:@"xiangmubeijing@2x"]];
    h_markProjectImageView.userInteractionEnabled = YES;
    [allprojectBackImageView addSubview:h_markProjectImageView];
    
    //****项目经历的标题字段
    UILabel *h_markProjectTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(9, 8, 100, 33/2)];
    h_markProjectTitleLabel.backgroundColor = [UIColor clearColor];
    h_markProjectTitleLabel.textAlignment = NSTextAlignmentLeft;
    h_markProjectTitleLabel.textColor = [UIColor whiteColor];
    h_markProjectTitleLabel.font = [UIFont systemFontOfSize:14];
    h_markProjectTitleLabel.text = @"项目经历";
    [h_markProjectImageView addSubview:h_markProjectTitleLabel];
    
    //****项目经历添加按钮
    UIButton *h_projectAddButton = [UIButton buttonWithType:UIButtonTypeCustom];
    h_projectAddButton.backgroundColor = [UIColor clearColor];
    h_projectAddButton.frame = CGRectMake(555/2, 0, 85/2, 33);
    [h_projectAddButton setBackgroundImage:[UIImage imageNamed:@"zengjia@2x"] forState:UIControlStateNormal];
    [h_projectAddButton addTarget:self action:@selector(clicknoprojectAddButton) forControlEvents:UIControlEventTouchUpInside];
    [h_markProjectImageView addSubview:h_projectAddButton];
    
    for (int k = 0; k<pArray.count; k++) {
        UIImageView *oneProjectBackImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44+180*k, 320, 180)];
        if (k%2 == 0) {
            oneProjectBackImageView.backgroundColor = [UIColor whiteColor];
        }else
        {
            oneProjectBackImageView.backgroundColor = [UIColor colorWithRed:242.0f/255.0f green:243.0f/255.0f blue:245.0f/255.0f alpha:1.0];
        }
        
        oneProjectBackImageView.userInteractionEnabled = YES;
        [allprojectBackImageView addSubview:oneProjectBackImageView];
        
        
        //****项目经历--时间
        UILabel *h_projectDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, 8, 460/2, 30/2)];
        h_projectDateLabel.backgroundColor = [UIColor clearColor];
        h_projectDateLabel.textAlignment = NSTextAlignmentLeft;
        h_projectDateLabel.textColor = [UIColor lightGrayColor];
        h_projectDateLabel.font = [UIFont systemFontOfSize:14];
        h_projectDateLabel.text = [NSString stringWithFormat:@"%@~%@",pArray[k][@"start_time"],pArray[k][@"end_time"]];
        [oneProjectBackImageView addSubview:h_projectDateLabel];
        
        //****项目经历--公司
        UILabel *h_projectCompanyLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, 58/2, 586/2, 30/2)];
        h_projectCompanyLabel.backgroundColor = [UIColor clearColor];
        h_projectCompanyLabel.textAlignment = NSTextAlignmentLeft;
        h_projectCompanyLabel.textColor = [UIColor lightGrayColor];
        h_projectCompanyLabel.font = [UIFont systemFontOfSize:14];
        h_projectCompanyLabel.text = pArray[k][@"com_name"];
        [oneProjectBackImageView addSubview:h_projectCompanyLabel];
        
        //****项目经历--职位
        UILabel *h_projectPositionLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, 106/2, 586/2, 30/2)];
        h_projectPositionLabel.backgroundColor = [UIColor clearColor];
        h_projectPositionLabel.textAlignment = NSTextAlignmentLeft;
        h_projectPositionLabel.textColor = [UIColor lightGrayColor];
        h_projectPositionLabel.font = [UIFont systemFontOfSize:14];
        h_projectPositionLabel.text = pArray[k][@"project_positions"];
        [oneProjectBackImageView addSubview:h_projectPositionLabel];
        
        //****项目经历--项目名称背景
        UIImageView *h_markPnameImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 154/2, 320, 67/2)];
        h_markPnameImageView.backgroundColor = [UIColor clearColor];
        //[h_markPnameImageView setImage:[UIImage imageNamed:@"xiangmubeijing@2x"]];
        h_markPnameImageView.userInteractionEnabled = YES;
        [oneProjectBackImageView addSubview:h_markPnameImageView];
        
        //****项目经历--项目名称标记字段
        UILabel *h_markPnameTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(18, 8, 134/2, 33/2)];
        h_markPnameTitleLabel.backgroundColor = [UIColor clearColor];
        h_markPnameTitleLabel.textAlignment = NSTextAlignmentLeft;
        h_markPnameTitleLabel.textColor = [UIColor blackColor];
        h_markPnameTitleLabel.font = [UIFont systemFontOfSize:14];
        h_markPnameTitleLabel.text = @"项目名称:";
        [h_markPnameImageView addSubview:h_markPnameTitleLabel];
        
        //****项目经历--项目名称
        UILabel *h_PnameTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(170/2, 8, 460/2, 36/2)];
        h_PnameTitleLabel.backgroundColor = [UIColor clearColor];
        h_PnameTitleLabel.textAlignment = NSTextAlignmentLeft;
        h_PnameTitleLabel.textColor = [UIColor blackColor];
        h_PnameTitleLabel.font = [UIFont systemFontOfSize:14];
        h_PnameTitleLabel.text = pArray[k][@"project_name"];
        [h_markPnameImageView addSubview:h_PnameTitleLabel];
        
        //****项目经历--项目描述内容
        UILabel *h_pdescribeLabel = [[UILabel alloc]init];
        h_pdescribeLabel.backgroundColor = [UIColor clearColor];
        h_pdescribeLabel.textAlignment = NSTextAlignmentLeft;
        h_pdescribeLabel.textColor = [UIColor lightGrayColor];
        h_pdescribeLabel.font = [UIFont systemFontOfSize:14];
        
        h_pdescribeLabel.numberOfLines = 0;
        NSString *str = pArray[k][@"project_intro"];
        if (IS_IOS_7) {
            NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
            size1 = [str boundingRectWithSize:CGSizeMake(580/2, 60) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        }else
        {
           size1 = [str sizeWithFont:[UIFont systemFontOfSize:15]constrainedToSize:CGSizeMake(180,60) lineBreakMode:NSLineBreakByWordWrapping];
        }
        
        h_pdescribeLabel.frame = CGRectMake(17, 112, 580/2, size1.height);
        h_pdescribeLabel.text = str;
        [oneProjectBackImageView addSubview:h_pdescribeLabel];
        
        //项目经历编辑按钮
        UIButton *h_projectEditButton = [UIButton buttonWithType:UIButtonTypeCustom];
        h_projectEditButton.backgroundColor = [UIColor clearColor];
        h_projectEditButton.frame = CGRectMake(0, 0, 320, oneProjectBackImageView.frame.size.height);
        //[h_projectEditButton setBackgroundImage:[UIImage imageNamed:@"zengjia@2x"] forState:UIControlStateNormal];
        h_projectEditButton.tag = 30000+k;
        [h_projectEditButton addTarget:self action:@selector(clickProjectEditButton:) forControlEvents:UIControlEventTouchUpInside];
        [oneProjectBackImageView addSubview:h_projectEditButton];
        
//        //蓝线
//        UIImageView *xianpImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, oneProjectBackImageView.frame.size.height-1, 320, 1)];
//        if (k == pArray.count-1) {
//            xianpImageView.backgroundColor = [UIColor clearColor];
//        }else
//        {
//            xianpImageView.backgroundColor = [UIColor colorWithRed:185.0f/255.0f green:203.0f/255.0f blue:238.0f/255.0f alpha:1.0];
//        }
//        
//        [oneProjectBackImageView addSubview:xianpImageView];
        
        pHeught = pHeught+oneProjectBackImageView.frame.size.height;
    }
    //initWithFrame:CGRectMake(0, 276/2+alljobBackImageView.frame.size.height+allstudyBackImageView.frame.size.height, 320, 444/2)
    allprojectBackImageView.frame = CGRectMake(0, 276/2+alljobBackImageView.frame.size.height+allstudyBackImageView.frame.size.height, 320, pHeught);

}
#pragma mark -无数据第一次登陆
-(void)TheFirstLoginView
{
    [backScrollView setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width, 1388/2)];
    //职业经历
    //****职业经历的背景
    jobBackImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 276/2, 320, 370/2)];
    jobBackImageView.backgroundColor = [UIColor clearColor];
    jobBackImageView.userInteractionEnabled = YES;
    [backScrollView addSubview:jobBackImageView];
    
    //****职业经历的标题栏
    UIImageView *markTitleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 9, 320, 67/2)];
    markTitleImageView.backgroundColor = [UIColor clearColor];
    [markTitleImageView setImage:[UIImage imageNamed:@"xiangmubeijing@2x"]];
    markTitleImageView.userInteractionEnabled = YES;
    [jobBackImageView addSubview:markTitleImageView];
    
    //****职业经历标题
    UILabel *markJobTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(9, 8, 100, 33/2)];
    markJobTitleLabel.backgroundColor = [UIColor clearColor];
    markJobTitleLabel.textAlignment = NSTextAlignmentLeft;
    markJobTitleLabel.textColor = [UIColor whiteColor];
    markJobTitleLabel.font = [UIFont systemFontOfSize:14];
    markJobTitleLabel.text = @"职业经历";
    [markTitleImageView addSubview:markJobTitleLabel];
    
    //****职业经历添加按钮
    UIButton *jobAddButton = [UIButton buttonWithType:UIButtonTypeCustom];
    jobAddButton.backgroundColor = [UIColor clearColor];
    jobAddButton.frame = CGRectMake(555/2, 0, 85/2, 33);
    [jobAddButton setBackgroundImage:[UIImage imageNamed:@"zengjia@2x"] forState:UIControlStateNormal];
    [jobAddButton addTarget:self action:@selector(clicknoJobButton) forControlEvents:UIControlEventTouchUpInside];
    [markTitleImageView addSubview:jobAddButton];
    
    //****经历详情的背景
    UIImageView *jobDetialsImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 43, 320, 152/2)];
    jobDetialsImageView.backgroundColor = [UIColor colorWithRed:242.0f/255.0f green:243.0f/255.0f blue:245.0f/255.0f alpha:1.0];
    jobDetialsImageView.userInteractionEnabled = YES;
    [jobBackImageView addSubview:jobDetialsImageView];
    
    //****就职日期
    UILabel *jobDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, 8, 430/2, 30/2)];
    jobDateLabel.backgroundColor = [UIColor clearColor];
    jobDateLabel.textAlignment = NSTextAlignmentLeft;
    jobDateLabel.textColor = [UIColor lightGrayColor];
    jobDateLabel.font = [UIFont systemFontOfSize:14];
    jobDateLabel.text = @"未填写就职日期";
    [jobDetialsImageView addSubview:jobDateLabel];
    
    //****就职地点
    UILabel *jobPlaceLabel = [[UILabel alloc]initWithFrame:CGRectMake(464/2, 8, 160/2, 30/2)];
    jobPlaceLabel.backgroundColor = [UIColor clearColor];
    jobPlaceLabel.textAlignment = NSTextAlignmentLeft;
    jobPlaceLabel.textColor = [UIColor lightGrayColor];
    jobPlaceLabel.font = [UIFont systemFontOfSize:14];
    jobPlaceLabel.text = @"就职地点未填写";
    [jobDetialsImageView addSubview:jobPlaceLabel];
    
    //****就职公司
    UILabel *jobCompanyLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, 30, 586/2, 30/2)];
    jobCompanyLabel.backgroundColor = [UIColor clearColor];
    jobCompanyLabel.textAlignment = NSTextAlignmentLeft;
    jobCompanyLabel.textColor = [UIColor lightGrayColor];
    jobCompanyLabel.font = [UIFont systemFontOfSize:14];
    jobCompanyLabel.text = @"就职公司未填写";
    [jobDetialsImageView addSubview:jobCompanyLabel];
    
    //****就职的职位
    UILabel *jobPositionLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, 106/2, 586/2, 30/2)];
    jobPositionLabel.backgroundColor = [UIColor clearColor];
    jobPositionLabel.textAlignment = NSTextAlignmentLeft;
    jobPositionLabel.textColor = [UIColor lightGrayColor];
    jobPositionLabel.font = [UIFont systemFontOfSize:14];
    jobPositionLabel.text = @"职位未填写";
    [jobDetialsImageView addSubview:jobPositionLabel];
    
    //****描述内容
    UILabel *describeLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, jobDetialsImageView.frame.size.height+43+10, 580/2, 32/2)];
    describeLabel.backgroundColor = [UIColor clearColor];
    describeLabel.textAlignment = NSTextAlignmentLeft;
    describeLabel.textColor = [UIColor lightGrayColor];
    describeLabel.font = [UIFont systemFontOfSize:14];
    describeLabel.text = @"描述未填写";
    [jobBackImageView addSubview:describeLabel];
    
    //****职业经历编辑按钮
    UIButton *jobEditButton = [UIButton buttonWithType:UIButtonTypeCustom];
    jobEditButton.backgroundColor = [UIColor clearColor];
    jobEditButton.frame = CGRectMake(0, 44, 320, jobBackImageView.frame.size.height-44);
    //[jobEditButton setBackgroundImage:[UIImage imageNamed:@"zengjia@2x"] forState:UIControlStateNormal];
    //[jobEditButton addTarget:self action:@selector(clickJobEditButton) forControlEvents:UIControlEventTouchUpInside];
    [jobBackImageView addSubview:jobEditButton];
    
    //教育经历
    //****教育经历的背景
    studyBackImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 276/2+jobBackImageView.frame.size.height, 320, 238/2)];
    studyBackImageView.backgroundColor = [UIColor clearColor];
    studyBackImageView.userInteractionEnabled = YES;
    [backScrollView addSubview:studyBackImageView];
    
    //****教育经历的标题栏
    UIImageView *markstudyImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 9, 320, 67/2)];
    markstudyImageView.backgroundColor = [UIColor clearColor];
    [markstudyImageView setImage:[UIImage imageNamed:@"xiangmubeijing@2x"]];
    markstudyImageView.userInteractionEnabled = YES;
    [studyBackImageView addSubview:markstudyImageView];
    
    //****教育经历标题
    UILabel *markStudyTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(9, 8, 100, 33/2)];
    markStudyTitleLabel.backgroundColor = [UIColor clearColor];
    markStudyTitleLabel.textAlignment = NSTextAlignmentLeft;
    markStudyTitleLabel.textColor = [UIColor whiteColor];
    markStudyTitleLabel.font = [UIFont systemFontOfSize:14];
    markStudyTitleLabel.text = @"教育经历";
    [markstudyImageView addSubview:markStudyTitleLabel];
    
    //****教育经历添加按钮
    UIButton *studyAddButton = [UIButton buttonWithType:UIButtonTypeCustom];
    studyAddButton.backgroundColor = [UIColor clearColor];
    studyAddButton.frame = CGRectMake(555/2, 0, 85/2, 33);
    [studyAddButton setBackgroundImage:[UIImage imageNamed:@"zengjia@2x"] forState:UIControlStateNormal];
    [studyAddButton addTarget:self action:@selector(clicknostudyAddButton) forControlEvents:UIControlEventTouchUpInside];
    [markstudyImageView addSubview:studyAddButton];
    
    //****教育经历详情的背景
    UIImageView *studyDetialsImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 43, 320, 152/2)];
    studyDetialsImageView.backgroundColor = [UIColor colorWithRed:242.0f/255.0f green:243.0f/255.0f blue:245.0f/255.0f alpha:1.0];
    studyDetialsImageView.userInteractionEnabled = YES;
    [studyBackImageView addSubview:studyDetialsImageView];
    
    //****教育经历日期
    UILabel *studyDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(148/2, 8, 460/2, 30/2)];
    studyDateLabel.backgroundColor = [UIColor clearColor];
    studyDateLabel.textAlignment = NSTextAlignmentLeft;
    studyDateLabel.textColor = [UIColor lightGrayColor];
    studyDateLabel.font = [UIFont systemFontOfSize:14];
    studyDateLabel.text = @"未填写就职日期";
    [studyDetialsImageView addSubview:studyDateLabel];
    
    UILabel *MarkStudyDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(16/2, 8, 130/2, 30/2)];
    MarkStudyDateLabel.backgroundColor = [UIColor clearColor];
    MarkStudyDateLabel.textAlignment = NSTextAlignmentRight;
    MarkStudyDateLabel.textColor = [UIColor lightGrayColor];
    MarkStudyDateLabel.font = [UIFont systemFontOfSize:14];
    MarkStudyDateLabel.text = @"时间:";
    [studyDetialsImageView addSubview:MarkStudyDateLabel];
    
    //****教育所在大学
    UILabel *markCollegeLabel = [[UILabel alloc]initWithFrame:CGRectMake(16/2, 30, 130/2, 30/2)];
    markCollegeLabel.backgroundColor = [UIColor clearColor];
    markCollegeLabel.textAlignment = NSTextAlignmentRight;
    markCollegeLabel.textColor = [UIColor lightGrayColor];
    markCollegeLabel.font = [UIFont systemFontOfSize:14];
    markCollegeLabel.text = @"毕业院校:";
    [studyDetialsImageView addSubview:markCollegeLabel];
    
    UILabel *collegeLabel = [[UILabel alloc]initWithFrame:CGRectMake(148/2, 30, 470/2, 30/2)];
    collegeLabel.backgroundColor = [UIColor clearColor];
    collegeLabel.textAlignment = NSTextAlignmentLeft;
    collegeLabel.textColor = [UIColor lightGrayColor];
    collegeLabel.font = [UIFont systemFontOfSize:14];
    collegeLabel.text = @"清华大学";
    [studyDetialsImageView addSubview:collegeLabel];
    
    //****学位
    UILabel *markDegreeLabel = [[UILabel alloc]initWithFrame:CGRectMake(16/2, 106/2, 130/2, 30/2)];
    markDegreeLabel.backgroundColor = [UIColor clearColor];
    markDegreeLabel.textAlignment = NSTextAlignmentRight;
    markDegreeLabel.textColor = [UIColor lightGrayColor];
    markDegreeLabel.font = [UIFont systemFontOfSize:14];
    markDegreeLabel.text = @"学位:";
    [studyDetialsImageView addSubview:markDegreeLabel];
    
    UILabel *degreeLabel = [[UILabel alloc]initWithFrame:CGRectMake(146/2, 106/2, 130/2, 30/2)];
    degreeLabel.backgroundColor = [UIColor clearColor];
    degreeLabel.textAlignment = NSTextAlignmentLeft;
    degreeLabel.textColor = [UIColor lightGrayColor];
    degreeLabel.font = [UIFont systemFontOfSize:14];
    degreeLabel.text = @"学士";
    [studyDetialsImageView addSubview:degreeLabel];
    
    //****专业
    UILabel *markMajorLabel = [[UILabel alloc]initWithFrame:CGRectMake(306/2, 106/2, 78/2, 30/2)];
    markMajorLabel.backgroundColor = [UIColor clearColor];
    markMajorLabel.textAlignment = NSTextAlignmentLeft;
    markMajorLabel.textColor = [UIColor lightGrayColor];
    markMajorLabel.font = [UIFont systemFontOfSize:14];
    markMajorLabel.text = @"专业:";
    [studyDetialsImageView addSubview:markMajorLabel];
    
    UILabel *majorLabel = [[UILabel alloc]initWithFrame:CGRectMake(384/2, 106/2, 244/2, 30/2)];
    majorLabel.backgroundColor = [UIColor clearColor];
    majorLabel.textAlignment = NSTextAlignmentLeft;
    majorLabel.textColor = [UIColor lightGrayColor];
    majorLabel.font = [UIFont systemFontOfSize:14];
    majorLabel.text = @"软件技术";
    [studyDetialsImageView addSubview:majorLabel];
    
    //教育经历编辑按钮
    UIButton *studyEditButton = [UIButton buttonWithType:UIButtonTypeCustom];
    studyEditButton.backgroundColor = [UIColor clearColor];
    studyEditButton.frame = CGRectMake(0, 44, 320, studyBackImageView.frame.size.height-44);
    //[studyEditButton setBackgroundImage:[UIImage imageNamed:@"zengjia@2x"] forState:UIControlStateNormal];
    //[studyEditButton addTarget:self action:@selector(clickStudyEditButton) forControlEvents:UIControlEventTouchUpInside];
    [studyBackImageView addSubview:studyEditButton];

    //项目经历
    //****项目经历的背景
    projectBackImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 276/2+jobBackImageView.frame.size.height+studyBackImageView.frame.size.height, 320, 444/2)];
    projectBackImageView.backgroundColor = [UIColor clearColor];
    projectBackImageView.userInteractionEnabled = YES;
    [backScrollView addSubview:projectBackImageView];
    
    //****项目经历的标题字段背景
    UIImageView *markProjectImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 9, 320, 67/2)];
    markProjectImageView.backgroundColor = [UIColor clearColor];
    [markProjectImageView setImage:[UIImage imageNamed:@"xiangmubeijing@2x"]];
    markProjectImageView.userInteractionEnabled = YES;
    [projectBackImageView addSubview:markProjectImageView];
    
    //****项目经历的标题字段
    UILabel *markProjectTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(9, 8, 100, 33/2)];
    markProjectTitleLabel.backgroundColor = [UIColor clearColor];
    markProjectTitleLabel.textAlignment = NSTextAlignmentLeft;
    markProjectTitleLabel.textColor = [UIColor whiteColor];
    markProjectTitleLabel.font = [UIFont systemFontOfSize:14];
    markProjectTitleLabel.text = @"项目经历";
    [markProjectImageView addSubview:markProjectTitleLabel];
    
    //****项目经历添加按钮
    UIButton *projectAddButton = [UIButton buttonWithType:UIButtonTypeCustom];
    projectAddButton.backgroundColor = [UIColor clearColor];
    projectAddButton.frame = CGRectMake(555/2, 0, 85/2, 33);
    [projectAddButton setBackgroundImage:[UIImage imageNamed:@"zengjia@2x"] forState:UIControlStateNormal];
    [projectAddButton addTarget:self action:@selector(clicknoprojectAddButton) forControlEvents:UIControlEventTouchUpInside];
    [markProjectImageView addSubview:projectAddButton];
    
    //****项目经历--时间
    UILabel *projectDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, 50, 460/2, 30/2)];
    projectDateLabel.backgroundColor = [UIColor clearColor];
    projectDateLabel.textAlignment = NSTextAlignmentLeft;
    projectDateLabel.textColor = [UIColor lightGrayColor];
    projectDateLabel.font = [UIFont systemFontOfSize:14];
    projectDateLabel.text = @"未填写项目日期";
    [projectBackImageView addSubview:projectDateLabel];
    
    //****项目经历--公司
    UILabel *projectCompanyLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, 144/2, 586/2, 30/2)];
    projectCompanyLabel.backgroundColor = [UIColor clearColor];
    projectCompanyLabel.textAlignment = NSTextAlignmentLeft;
    projectCompanyLabel.textColor = [UIColor lightGrayColor];
    projectCompanyLabel.font = [UIFont systemFontOfSize:14];
    projectCompanyLabel.text = @"项目所属公司未填写";
    [projectBackImageView addSubview:projectCompanyLabel];

    //****项目经历--职位
    UILabel *projectPositionLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, 192/2, 586/2, 30/2)];
    projectPositionLabel.backgroundColor = [UIColor clearColor];
    projectPositionLabel.textAlignment = NSTextAlignmentLeft;
    projectPositionLabel.textColor = [UIColor lightGrayColor];
    projectPositionLabel.font = [UIFont systemFontOfSize:14];
    projectPositionLabel.text = @"职位未填写";
    [projectBackImageView addSubview:projectPositionLabel];
    
    //****项目经历--项目名称背景
    UIImageView *markPnameImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 120, 320, 67/2)];
    markPnameImageView.backgroundColor = [UIColor clearColor];
    [markPnameImageView setImage:[UIImage imageNamed:@"xiangmubeijing@2x"]];
    markPnameImageView.userInteractionEnabled = YES;
    [projectBackImageView addSubview:markPnameImageView];
    
    //****项目经历--项目名称标记字段
    UILabel *markPnameTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(18, 8, 134/2, 33/2)];
    markPnameTitleLabel.backgroundColor = [UIColor clearColor];
    markPnameTitleLabel.textAlignment = NSTextAlignmentLeft;
    markPnameTitleLabel.textColor = [UIColor blackColor];
    markPnameTitleLabel.font = [UIFont systemFontOfSize:14];
    markPnameTitleLabel.text = @"项目经历:";
    [markPnameImageView addSubview:markPnameTitleLabel];
    
    //****项目经历--项目名称
    UILabel *PnameTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(170/2, 8, 460/2, 36/2)];
    PnameTitleLabel.backgroundColor = [UIColor clearColor];
    PnameTitleLabel.textAlignment = NSTextAlignmentLeft;
    PnameTitleLabel.textColor = [UIColor blackColor];
    PnameTitleLabel.font = [UIFont systemFontOfSize:14];
    PnameTitleLabel.text = @"脸谱网";
    [markPnameImageView addSubview:PnameTitleLabel];
    
    //****项目经历--项目描述内容
    UILabel *pdescribeLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, 310/2, 580/2, 32/2)];
    pdescribeLabel.backgroundColor = [UIColor clearColor];
    pdescribeLabel.textAlignment = NSTextAlignmentLeft;
    pdescribeLabel.textColor = [UIColor lightGrayColor];
    pdescribeLabel.font = [UIFont systemFontOfSize:14];
    pdescribeLabel.text = @"描述未填写,点击进行编辑";
    [projectBackImageView addSubview:pdescribeLabel];
    
    //项目经历编辑按钮
    UIButton *projectEditButton = [UIButton buttonWithType:UIButtonTypeCustom];
    projectEditButton.backgroundColor = [UIColor clearColor];
    projectEditButton.frame = CGRectMake(0, 44, 320, projectBackImageView.frame.size.height-44);
    //[projectEditButton setBackgroundImage:[UIImage imageNamed:@"zengjia@2x"] forState:UIControlStateNormal];
   // [projectEditButton addTarget:self action:@selector(clickProjectEditButton) forControlEvents:UIControlEventTouchUpInside];
    [projectBackImageView addSubview:projectEditButton];
    
}
#pragma mark - 职业经历编辑按钮事件
- (void)clickJobEditButton:(UIButton *)button
{
    NSLog(@"职业经历编辑按钮事件");
    ProfessionExperienceViewController *professionExperienceVC = [[ProfessionExperienceViewController alloc]init];
    professionExperienceVC.editStyle = @"edit";
    professionExperienceVC.jobDiction = jobArray[button.tag-10000];
    [self.navigationController pushViewController:professionExperienceVC animated:YES];
}
#pragma mark -教育经历编辑按钮事件
- (void)clickStudyEditButton:(UIButton *)button
{
    NSLog(@"教育经历编辑按钮事件");
    EducationExperienceViewController *educationExperienceVC = [[EducationExperienceViewController alloc]init];
     educationExperienceVC.editStyle = @"edit";
    educationExperienceVC.eduDiction = studyArray[button.tag-20000];
    
    [self.navigationController pushViewController:educationExperienceVC animated:YES];

}
#pragma mark - 项目经历编辑按钮
- (void)clickProjectEditButton:(UIButton *)button
{
    NSLog(@"项目经历编辑按钮");
    ProjectExperienceViewController *projectExperienceVC =[[ProjectExperienceViewController alloc]init];
    projectExperienceVC.editStyle = @"edit";
    projectExperienceVC.projectDiction = projectArray[button.tag-30000];
    
    [self.navigationController pushViewController:projectExperienceVC animated:YES];
}

#pragma mark - 无数据时添加职业经历
- (void)clicknoJobButton
{
    ProfessionExperienceViewController *professionExperienceVC = [[ProfessionExperienceViewController alloc]init];
    professionExperienceVC.editStyle = @"newAdd";
    [self.navigationController pushViewController:professionExperienceVC animated:YES];
}
#pragma mark - 无数据时添加教育经历
- (void)clicknostudyAddButton
{
    EducationExperienceViewController *educationExperienceVC = [[EducationExperienceViewController alloc]init];
    educationExperienceVC.editStyle = @"newAdd";
    [self.navigationController pushViewController:educationExperienceVC animated:YES];
}
#pragma mark - 无数据时添加项目经历
- (void)clicknoprojectAddButton
{
    ProjectExperienceViewController *projectExperienceVC =[[ProjectExperienceViewController alloc]init];
    projectExperienceVC.editStyle = @"newAdd";
    [self.navigationController pushViewController:projectExperienceVC animated:YES];
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
