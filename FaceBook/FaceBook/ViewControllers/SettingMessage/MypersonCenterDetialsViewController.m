//
//  MypersonCenterDetialsViewController.m
//  FaceBook
//
//  Created by fengshaohui on 14-5-15.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "MypersonCenterDetialsViewController.h"
#import "ChooseIdentityViewController.h"
#import "WorkCityViewController.h"
#import "WorkAreaViewController.h"
#import "ChooseDepartmentViewController.h"
#import "PersonResumeViewController.h"
#import "DMCAlertCenter.h"
#import "BCHTTPRequest.h"
#import "AppDelegate.h"


#import "AutocompletionTableView.h"

@interface MypersonCenterDetialsViewController ()
{
    UIScrollView *backgroundScrollView;
    UITextField *companyTextField;
    UIButton *departmentButton;
    UIButton *workCityButton;
    UIButton *workAreaButton;
    
    UITextField *schoolTextField;
    UIView *finishView;
    
    NSMutableArray *filterArray;
    int filterNum;
    
    NSMutableArray *preferenceArray;
    NSMutableArray *schoolArray;
    UIButton *preferenceButton;
    
    NSString *institutionIdStr; //机构id
    NSString *departmentIdStr;  //条线ID
    NSString *investmentIdStr;  //投资偏好id
    NSString *workCityStr;      //城市
    NSString *workAreaStr;      //区域
    
    //学校背景
    UIView *educationView;//小学
    UIView *educationView2;//初中
    UIView *educationView3;//高中
    UIView *educationView4;//大学
    
    
    UIButton *educationOneButton;
    
    UIButton *educationTwoButton;
    UIView *birthView;
    UIButton *addButton;
    UITextField *primarySchoolTextField;
    UITextField *juniorSchoolTextField;
    UITextField *highSchoolTextField;
    UITextField *collegeSchoolTextField;
    
    UIButton *educationThreeButton;
    //UITextField *fourSchoolTextField;
    
    NSInteger schoolNumber;
    
    NSString *primaryschoolStr;     //小学
    NSString *juniorschoolStr;      //初中
    NSString *highSchoolStr;      //高中
    NSString *collegeStr;      //大学
//************************************************************
    //标记填写教育经历的个数
    int N;
    
//********************************************************
    //输入提醒数组
    NSArray *companyArray;        //公司名称数组
    NSMutableArray *primaryschoolArray;  //小学名称数组
    NSMutableArray *juniorschoolArray;   //初中名称数组
    NSMutableArray *highSchoolArray;     //高中名称数组
    NSMutableArray *collegeArray;        //大学名称数组
    
    NSMutableArray *downListArray;       //下拉框所用的数组
    AutocompletionTableView *autoCompleter;
    
    NSString *titleStr; //投资偏好名称
    
    
    
}

@end

@implementation MypersonCenterDetialsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        preferenceArray = [[NSMutableArray alloc] initWithCapacity:100];
        schoolArray = [[NSMutableArray alloc] initWithCapacity:100];
        filterArray = [[NSMutableArray alloc] initWithCapacity:100];
        N = 0;
        
        companyArray  = [[NSArray alloc] init];
        primaryschoolArray  = [[NSMutableArray alloc] initWithCapacity:100];
        juniorschoolArray  = [[NSMutableArray alloc] initWithCapacity:100];
        highSchoolArray  = [[NSMutableArray alloc] initWithCapacity:100];
        collegeArray  = [[NSMutableArray alloc] initWithCapacity:100];
        downListArray = [[NSMutableArray alloc] initWithCapacity:100];
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
    self.title = @"详细信息";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 22, 40, 40);
    [backButton setBackgroundImage:[UIImage imageNamed:@"login_backButton@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //[self.navigationController.view addSubview:backButton];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;
    
    
    //跳过
    UIButton *skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    skipButton.frame = CGRectMake(526/2,22/2, 84/2, 42/2);
    [skipButton setBackgroundImage:[UIImage imageNamed:@"login_RegistrationButton_03@2x"] forState:UIControlStateNormal];
    [skipButton setTitle:@"完成" forState:UIControlStateNormal];
    skipButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [skipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [skipButton addTarget:self action:@selector(finishButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *righttbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:skipButton];
    self.navigationItem.rightBarButtonItem=righttbuttonitem;
    
    //ScrollView背景
    backgroundScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.height, [UIScreen mainScreen].bounds.size.height)];
    backgroundScrollView.delegate = self;
    backgroundScrollView.contentSize = CGSizeMake(320, 1300/2);
    backgroundScrollView.tag = 9999999;
    backgroundScrollView.backgroundColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:251/255.0 alpha:1];
    [self.view addSubview:backgroundScrollView];
    
    //身份背景、部门、公司
    UIView *identityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 368/2)];
    identityView.backgroundColor = [UIColor whiteColor];
    identityView.userInteractionEnabled = YES;
    [backgroundScrollView addSubview:identityView];
    //身份背景
    UILabel *identityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20/2, 160/2, 72/2)];
    identityLabel.text = @"身份背景:";
    identityLabel.backgroundColor = [UIColor clearColor];
    identityLabel.textAlignment = NSTextAlignmentRight;
    identityLabel.font = [UIFont systemFontOfSize:15];
    [identityView addSubview:identityLabel];
    
    UIButton *identityButton = [[UIButton alloc] initWithFrame:CGRectMake(164/2, 20/2, 443.0/2, 72/2)];
    [identityButton setBackgroundImage:[UIImage imageNamed:@"detailInfo_tableViewButtonBackground_03@2x"]forState:UIControlStateNormal];
    [identityButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    identityButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    identityButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft ;
    //    但问题又出来，此时文字会紧贴到做边框，我们可以设置
    identityButton.contentEdgeInsets = UIEdgeInsetsMake(0,8, 0, 5);

    identityButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [identityButton addTarget:self action:@selector(identityButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [identityView addSubview:identityButton];
    //部门/条线
    UILabel *departmentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, identityLabel.frame.origin.y+identityLabel.frame.size.height+44/2, 160/2, 72/2)];
    departmentLabel.text = @"部门/条线：";
    departmentLabel.backgroundColor = [UIColor clearColor];
    departmentLabel.textAlignment = NSTextAlignmentRight;
    departmentLabel.font = [UIFont systemFontOfSize:14];
    [identityView addSubview:departmentLabel];
    
    departmentButton = [[UIButton alloc] initWithFrame:CGRectMake(164/2, departmentLabel.frame.origin.y, 443.0/2, 72/2)];
    [departmentButton setBackgroundImage:[UIImage imageNamed:@"detailInfo_tableViewButtonBackground_03@2x"]forState:UIControlStateNormal];
    [departmentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    departmentButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    departmentButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft ;
    //    但问题又出来，此时文字会紧贴到做边框，我们可以设置
    departmentButton.contentEdgeInsets = UIEdgeInsetsMake(0,8, 0, 5);
    departmentButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [departmentButton addTarget:self action:@selector(departmentButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [identityView addSubview:departmentButton];
    
    //公司名称
    UILabel *companyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, departmentLabel.frame.origin.y+departmentLabel.frame.size.height+44/2, 160/2, 72/2)];
    companyLabel.text = @"公司名称：";
    companyLabel.backgroundColor = [UIColor clearColor];
    companyLabel.textAlignment = NSTextAlignmentRight;
    companyLabel.font = [UIFont systemFontOfSize:15];
    [identityView addSubview:companyLabel];
    
    UIImageView *companyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(164/2, companyLabel.frame.origin.y, 443.0/2, 72/2)];
    NSLog(@"======++++++=======%f",companyLabel.frame.origin.y);
    [companyImageView setImage:[UIImage imageNamed:@"detailInfo_companyBackground_06@2x"]];
    companyImageView.userInteractionEnabled = YES;
    [identityView addSubview:companyImageView];
    
    companyTextField = [[UITextField alloc] initWithFrame:CGRectMake(16/2, 0, 410/2, 72/2)];
    companyTextField.placeholder = @"填写公司名称";
    companyTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    companyTextField.font = [UIFont systemFontOfSize:14];
    //    nameTextField.keyboardType = UIKeyboardTypeDecimalPad;
    companyTextField.delegate = self;
    companyTextField.tag = 5000;
    

    [companyImageView addSubview:companyTextField];
    
    //投资偏好
    UIImageView *preferenceImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, identityView.frame.size.height, 320, 92/2)];
    [preferenceImageView setImage:[UIImage imageNamed:@"registration_cityBackground_16@2x"]];
    preferenceImageView.userInteractionEnabled = YES;
    [backgroundScrollView addSubview:preferenceImageView];
    //投资偏好
    UILabel *preferenceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15/2, 160/2, 72/2)];
    preferenceLabel.text = @"职务名称：";
    preferenceLabel.backgroundColor = [UIColor clearColor];
    preferenceLabel.textAlignment = NSTextAlignmentRight;
    preferenceLabel.font = [UIFont systemFontOfSize:15];
    [preferenceImageView addSubview:preferenceLabel];
    //按钮
    preferenceButton = [[UIButton alloc] initWithFrame:CGRectMake(164/2, (preferenceImageView.frame.size.height-72/2)/2, 442/2, 72/2)];
    [preferenceButton setBackgroundImage:[UIImage imageNamed:@"detailInfo_preference_07@2x"]forState:UIControlStateNormal];
    [preferenceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    preferenceButton.titleLabel.font = [UIFont systemFontOfSize:15];
    //    preferenceButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [preferenceButton addTarget:self action:@selector(preferenceButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [preferenceImageView addSubview:preferenceButton];
    
    //中部文案
    UIView *wordView = [[UIView alloc] initWithFrame:CGRectMake(0, preferenceImageView.frame.origin.y+preferenceImageView.frame.size.height, 320, 62/2)];
    wordView.backgroundColor = [UIColor whiteColor];
    wordView.userInteractionEnabled = YES;
    [backgroundScrollView addSubview:wordView];
    
    UILabel *wordLabel = [[UILabel alloc] initWithFrame:CGRectMake(20/2, 0, 500/2, 62/2)];
    wordLabel.text = @"填写出生地信息可以帮助您找到同乡\n填写教育背景能够帮助您找到同学";
    wordLabel.backgroundColor = [UIColor clearColor];
    wordLabel.textColor = [UIColor colorWithRed:143/255.0 green:167/255.0 blue:213/255.0 alpha:1];
    wordLabel.font = [UIFont systemFontOfSize:12];
    wordLabel.numberOfLines = 0;
    [wordView addSubview:wordLabel];
    
    //出生地
    birthView = [[UIView alloc] initWithFrame:CGRectMake(0, wordView.frame.origin.y+wordView.frame.size.height, 320, 110/2)];
    birthView.backgroundColor = [UIColor colorWithRed:208/255.0 green:210/255.0 blue:215/255.0 alpha:1];
    birthView.userInteractionEnabled = YES;
    [backgroundScrollView addSubview:birthView];
    
    //出生地
    UILabel *workCityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20/2, 160/2, 72/2)];
    workCityLabel.text = @"出生地：";
    workCityLabel.backgroundColor = [UIColor clearColor];
    workCityLabel.textAlignment = NSTextAlignmentRight;
    workCityLabel.font = [UIFont systemFontOfSize:15];
    [birthView addSubview:workCityLabel];
    
    workCityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    workCityButton.backgroundColor = [UIColor clearColor];
    workCityButton.frame = CGRectMake(164/2, 20/2, 212/2, 72/2);
    [workCityButton setBackgroundImage:[UIImage imageNamed:@"registration_cityCheckButton_19@2x"] forState:UIControlStateNormal];
    [workCityButton setTitle:@"北京" forState:UIControlStateNormal];
    workCityButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [workCityButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [workCityButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 50)];
    //    workCityButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [workCityButton addTarget:self action:@selector(workCityButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [birthView addSubview:workCityButton];
    
    workAreaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    workAreaButton.backgroundColor = [UIColor clearColor];
    workAreaButton.frame = CGRectMake(396/2, 20/2, 212/2, 72/2);
    [workAreaButton setBackgroundImage:[UIImage imageNamed:@"registration_cityCheckButton_19@2x"] forState:UIControlStateNormal];
    [workAreaButton setTitle:@"朝阳" forState:UIControlStateNormal];
    workAreaButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [workAreaButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [workAreaButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 50)];
    //    workAreaButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [workAreaButton addTarget:self action:@selector(workAreaButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [birthView addSubview:workAreaButton];
    
//**********************
// 获取数据的接口
//**************************
    [BCHTTPRequest GetThePersonDetialsMessageWithUsingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
           
                [identityButton setTitle:resultDic[@"institution"][@"title"] forState:UIControlStateNormal];
            institutionIdStr = resultDic[@"institution"][@"id"];
            
            [departmentButton setTitle:resultDic[@"department"][@"title"] forState:UIControlStateNormal];
            companyTextField.text = resultDic[@"company"];
             if ([resultDic[@"investment"] count]>0) {
                 
                 for (int k = 0; k<[resultDic[@"investment"] count]; k++) {
                     if (k == 0) {
                         NSString *nstr = resultDic[@"investment"][0][@"name"];
                         dtitleStr = [NSString stringWithFormat:@"%@",nstr];
                         
                         NSString *idMStr = resultDic[@"investment"][0][@"id"];
                         investmentIdStr = [NSString stringWithFormat:@"%@",idMStr];  //投资偏好id
                         
                     }else
                     {
                         NSString *nstr = resultDic[@"investment"][k][@"name"];
                         dtitleStr = [NSString stringWithFormat:@"%@,%@",dtitleStr,nstr];
                         
                         
                         NSString *idMStr = resultDic[@"investment"][k][@"id"];
                         investmentIdStr = [NSString stringWithFormat:@"%@",idMStr];  //投资偏好id
                     }
                 }
            [preferenceButton setTitle:dtitleStr forState:UIControlStateNormal];
                 

             }else
             {
                 investmentIdStr = @"";  //投资偏好id

             }
            [workCityButton setTitle:resultDic[@"birth_city"] forState:UIControlStateNormal];
            [workAreaButton setTitle:resultDic[@"birth_area"] forState:UIControlStateNormal];
            
            institutionIdStr =resultDic[@"institution"][@"id"]; //机构id
            departmentIdStr = resultDic[@"department"][@"id"];  //条线ID
            
            if ([resultDic[@"primary_school"] length]>0) {
                N = N+1;
            }
            if ([resultDic[@"junior_middle_school"] length]>0) {
                 N = N+1;
            }
            if ([resultDic[@"high_school"] length]>0) {
                N = N+1;
            }
            if ([resultDic[@"university"] length]>0) {
                N = N+1;
            }

            if (N == 0) {
                [self myPrimarySchool];
                
            }else if (N == 1) {
                
                [self myPrimarySchool];
                primarySchoolTextField.text = resultDic[@"primary_school"];
                
            }else if (N == 2)
            {
                [self myPrimarySchool];
                [self getMyjuniorSchool];
                primarySchoolTextField.text = resultDic[@"primary_school"];
                juniorSchoolTextField.text = resultDic[@"junior_middle_school"];
                
            }else if (N == 3)
            {
                [self myPrimarySchool];
                [self getMyjuniorSchool];
                [self myhighSchool];
                
                primarySchoolTextField.text = resultDic[@"primary_school"];
                juniorSchoolTextField.text = resultDic[@"junior_middle_school"];
                highSchoolTextField.text = resultDic[@"high_school"];
                
            }else if (N == 4)
            {
                [self myPrimarySchool];
                [self getMyjuniorSchool];
                [self myhighSchool];
                [self mycollegeSchool];
                
                primarySchoolTextField.text = resultDic[@"primary_school"];
                juniorSchoolTextField.text = resultDic[@"junior_middle_school"];
                highSchoolTextField.text = resultDic[@"high_school"];
                collegeSchoolTextField.text = resultDic[@"university"];
            }
            
        }
    }];

    
    
    //增加教育背景
    addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [addButton setImage:[UIImage imageNamed:@"detailInfo_addButton_07@2x"] forState:UIControlStateNormal];
    if (N == 0) {
        addButton.tag = 100+N+1;
    }else
    {
        addButton.tag = 100+N;
    }
    
    [addButton addTarget:self action:@selector(addButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundScrollView addSubview:addButton];
    
    
    //两个按钮
    finishView = [[UIView alloc] init];
     finishView.frame = CGRectMake(0, birthView.frame.origin.y+birthView.frame.size.height+66/2+100, 320, 140/2);
    finishView.userInteractionEnabled = YES;
    [backgroundScrollView addSubview:finishView];
    
//    UIButton *writeResumeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    writeResumeButton.frame = CGRectMake(28/2, 0, 282/2, 74/2);
//    [writeResumeButton setBackgroundImage:[UIImage imageNamed:@"detailInfo_writeResumeButton@2x"] forState:UIControlStateNormal];
//    [writeResumeButton setTitle:@"填写个人简历" forState:UIControlStateNormal];
//    [writeResumeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    writeResumeButton.titleLabel.font = [UIFont systemFontOfSize:15];
//    [writeResumeButton addTarget:self action:@selector(writeResumeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
//    [finishView addSubview:writeResumeButton];
    
    UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    finishButton.frame = CGRectMake(15, 0, 580/2, 74/2);
    [finishButton setBackgroundImage:[UIImage imageNamed:@"detailInfo_finishButton_13@2x"] forState:UIControlStateNormal];
    [finishButton setTitle:@"完善个人简历" forState:UIControlStateNormal];
    [finishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    finishButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [finishButton addTarget:self action:@selector(finishButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [finishView addSubview:finishButton];
    
//*************************
//     输入提醒所需数据
//****************************
        //小学名称数组
    [BCHTTPRequest GetTheWeKnowPrimarySchoolNameUsingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            primaryschoolArray = resultDic[@"list"];
            
        }
    }];
    NSLog(@"----------+++++++++->%@",primaryschoolArray);
    //初中名称数组juniorschoolArray
    [BCHTTPRequest GetTheWeKnowJuniorSchoolNameUsingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            juniorschoolArray = resultDic[@"list"];
        }
    }];
    //高中名称数组highSchoolArray
    [BCHTTPRequest GetTheWeKnowHighSchoolNameUsingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            highSchoolArray = resultDic[@"list"];
        }
    }];
    //大学名称数组collegeArray
    [BCHTTPRequest GetTheWeKnowUniversityNameUsingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            collegeArray = resultDic[@"list"];
        }
    }];
    
//*******************************************
    _filterTableView = [[TableViewWithBlock alloc] initWithFrame:CGRectMake(176/2, 452/2, 438/2, 200)];
    _filterTableView.backgroundColor = [UIColor whiteColor];
    _filterTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_filterTableView  bringSubviewToFront:backgroundScrollView];
    [backgroundScrollView addSubview:_filterTableView];
    _filterTableView.hidden = YES;
    [BCHTTPRequest getinvestmentListWithUsingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            preferenceArray  = resultDic[@"list"];
            filterArray = preferenceArray;
            [_filterTableView reloadData];
        }
    }];
    
    
    [_filterTableView initTableViewDataSourceAndDelegate:^(UITableView *tableView,NSInteger section)
     {
         return (NSInteger)filterArray.count;
         
     }setCellForIndexPathBlock:^(UITableView *tableView,NSIndexPath *indexPath){
         SelectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
         if (!cell) {
             cell=[[SelectionCell alloc] init];
             [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
         }
         UIImageView *cellXian = [[UIImageView alloc]initWithFrame:CGRectMake(0, 68/2, 438/2, 1)];
         cellXian.backgroundColor = [UIColor colorWithRed:208/255.0 green:210/255.0 blue:205/255.0 alpha:1];
         [cell.contentView addSubview:cellXian];
         cell.lb.textAlignment = NSTextAlignmentLeft;
         
         cell.lb.textColor = [UIColor colorWithRed:208/255.0 green:210/255.0 blue:205/255.0 alpha:1];
         cell.lb.font = [UIFont systemFontOfSize:15];
         [cell.lb setText:[filterArray objectAtIndex:indexPath.row][@"name"]];
         return cell;
     } setDidSelectRowBlock:^(UITableView *tableView,NSIndexPath *indexPath){
         SelectionCell *cell=(SelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
         switch (filterNum) {
             case 10:
             {
                 NSString *str = [[NSString alloc] init];
                 
                 
                 if ([titleStr length] == 0) {
                     str = cell.lb.text;
                     titleStr = [NSString stringWithFormat:@"%@",str];
                 }else
                 {
                     NSRange searchRange = [titleStr rangeOfString:cell.lb.text];
                     if (searchRange.location == NSNotFound ) {
                         str = cell.lb.text;
                         titleStr = [NSString stringWithFormat:@"%@,%@",titleStr,str];
                     }
                     
                 }
                 [preferenceButton setTitle:titleStr forState:UIControlStateNormal];
                // investmentIdStr = [filterArray objectAtIndex:indexPath.row][@"id"];
                 
                 NSString *idStr = [[NSString alloc] init];
                 if ([investmentIdStr length] == 0) {
                     idStr = [filterArray objectAtIndex:indexPath.row][@"id"];
                     investmentIdStr = [NSString stringWithFormat:@"%@",idStr];
                 }else
                 {
                      NSRange searchRange = [investmentIdStr rangeOfString:idStr];
                     if (searchRange.location == NSNotFound ) {
                         idStr = [filterArray objectAtIndex:indexPath.row][@"id"];
                         investmentIdStr = [NSString stringWithFormat:@"%@,%@",investmentIdStr,idStr];
                     }
                 }
                 
                // [preferenceButton sendActionsForControlEvents:UIControlEventTouchUpInside];

             }
                 
                 
            break;
             default:
                 break;
         }
     }];
    
    [[NSNotificationCenter defaultCenter]addObserverForName:@"showidentity" object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSDictionary *dic = [note object];
        institutionIdStr = dic[@"id"];
        [identityButton setTitle:dic[@"name"] forState:UIControlStateNormal];
        
        
        [BCHTTPRequest getInstitutionWithPID:[institutionIdStr intValue] usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
                companyArray = resultDic[@"list"];
                
                
                
            }
        }];

        //公司名称数组
        [BCHTTPRequest GetTheWeKnowCompanyNameWithClass_id:institutionIdStr  UsingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            
            //    }]
            //    [BCHTTPRequest GetTheWeKnowCompanyNameUsingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
                companyArray = resultDic[@"list"];
            }
        }];

    
    }];
    
    [[NSNotificationCenter defaultCenter]addObserverForName:DepartmentNoti object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSDictionary *dics = [note object];
        departmentIdStr = dics[@"id"];
        [departmentButton setTitle:dics[@"title"] forState:UIControlStateNormal];
    }];

    if ([institutionIdStr length]>0) {
        [BCHTTPRequest getInstitutionWithPID:[institutionIdStr intValue] usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
                companyArray = resultDic[@"list"];
                
                
                
            }
        }];

    }
    
    
    //接受返回通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backMain) name:@"logfengback" object:nil];
    
}

- (void)backMain
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 小学
- (void)myPrimarySchool
{
    //教育背景
    educationView = [[UIView alloc] initWithFrame:CGRectMake(0, birthView.frame.origin.y+birthView.frame.size.height+20/2, 320, 200/2)];
    NSLog(@"^^^^^^^^^%f",birthView.frame.origin.y+birthView.frame.size.height+20/2+92);
    educationView.backgroundColor = [UIColor colorWithRed:208/255.0 green:210/255.0 blue:215/255.0 alpha:1];
    educationView.userInteractionEnabled = YES;
    [backgroundScrollView addSubview:educationView];
    
    //教育背景
    UILabel *educationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20/2, 160/2, 72/2)];
    educationLabel.text = @"教育背景：";
    educationLabel.backgroundColor = [UIColor clearColor];
    educationLabel.textAlignment = NSTextAlignmentRight;
    educationLabel.font = [UIFont systemFontOfSize:15];
    [educationView addSubview:educationLabel];
    
    educationOneButton = [[UIButton alloc] initWithFrame:CGRectMake(164/2, 20/2, 443.0/2, 72/2)];
    [educationOneButton setBackgroundImage:[UIImage imageNamed:@"detailInfo_tableViewButtonBackground_f@2x"]forState:UIControlStateNormal];
    educationOneButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [educationOneButton setTitle:@"小学" forState:UIControlStateNormal];
    [educationOneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    educationOneButton.tag = 1100;
    // [educationOneButton addTarget:self action:@selector(educationButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [educationView addSubview:educationOneButton];
    
    //毕业学校
    UILabel *schoolLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, educationLabel.frame.origin.y+educationLabel.frame.size.height+20/2, 160/2, 72/2)];
    schoolLabel.text = @"毕业学校：";
    schoolLabel.backgroundColor = [UIColor clearColor];
    schoolLabel.textAlignment = NSTextAlignmentRight;
    schoolLabel.font = [UIFont systemFontOfSize:15];
    [educationView addSubview:schoolLabel];
    
    UIImageView *schoolImageView = [[UIImageView alloc] initWithFrame:CGRectMake(164/2, schoolLabel.frame.origin.y, 443.0/2, 72/2)];
    
    [schoolImageView setImage:[UIImage imageNamed:@"detailInfo_companyBackground_06@2x"]];
    schoolImageView.userInteractionEnabled = YES;
    [educationView addSubview:schoolImageView];
    
    primarySchoolTextField = [[UITextField alloc] initWithFrame:CGRectMake(16/2, 0, 410/2, 72/2)];
    primarySchoolTextField.placeholder = @"";
    primarySchoolTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    schoolTextField.font = [UIFont systemFontOfSize:14];
    primarySchoolTextField.tag = 10001;
    //    primarySchoolTextField.keyboardType = UIKeyboardTypeDecimalPad;
    primarySchoolTextField.delegate = self;
    [schoolImageView addSubview:primarySchoolTextField];

    
    
    addButton.frame = CGRectMake(24/2, educationView.frame.origin.y+educationView.frame.size.height+20/2, 61.0/2, 61.0/2);
    finishView.frame = CGRectMake(0, addButton.frame.origin.y+addButton.frame.size.height+66/2, 320, 140/2);
}
#pragma mark - 初中
- (void)getMyjuniorSchool
{
    educationView2 = [[UIView alloc] initWithFrame:CGRectMake(0, educationView.frame.origin.y+educationView.frame.size.height+10, 320, 200/2)];
     NSLog(@"初中%f",educationView.frame.origin.y+educationView.frame.size.height+10+92);
    educationView2.backgroundColor = [UIColor colorWithRed:208/255.0 green:210/255.0 blue:215/255.0 alpha:1];
    educationView2.userInteractionEnabled = YES;
    [backgroundScrollView addSubview:educationView2];
    
    //教育背景
    UILabel *educationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20/2, 160/2, 72/2)];
    educationLabel.text = @"教育背景：";
    educationLabel.backgroundColor = [UIColor clearColor];
    educationLabel.textAlignment = NSTextAlignmentRight;
    educationLabel.font = [UIFont systemFontOfSize:15];
    [educationView2 addSubview:educationLabel];
    
    educationTwoButton = [[UIButton alloc] initWithFrame:CGRectMake(164/2, 20/2, 443.0/2, 72/2)];
    [educationTwoButton setBackgroundImage:[UIImage imageNamed:@"detailInfo_tableViewButtonBackground_f@2x"]forState:UIControlStateNormal];
    educationTwoButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [educationTwoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [educationTwoButton setTitle:@"初中" forState:UIControlStateNormal];
    //educationTwoButton.tag = sender.tag+1000;
    //[educationTwoButton addTarget:self action:@selector(educationButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [educationView2 addSubview:educationTwoButton];
    
    //毕业学校
    UILabel *schoolLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, educationLabel.frame.origin.y+educationLabel.frame.size.height+20/2, 160/2, 72/2)];
    schoolLabel.text = @"毕业学校：";
    schoolLabel.backgroundColor = [UIColor clearColor];
    schoolLabel.textAlignment = NSTextAlignmentRight;
    schoolLabel.font = [UIFont systemFontOfSize:15];
    [educationView2 addSubview:schoolLabel];
    
    UIImageView *schoolImageView = [[UIImageView alloc] initWithFrame:CGRectMake(164/2, schoolLabel.frame.origin.y, 443.0/2, 72/2)];
    
    [schoolImageView setImage:[UIImage imageNamed:@"detailInfo_companyBackground_06@2x"]];
    schoolImageView.userInteractionEnabled = YES;
    [educationView2 addSubview:schoolImageView];
    
    juniorSchoolTextField = [[UITextField alloc] initWithFrame:CGRectMake(16/2, 0, 410/2, 72/2)];
    juniorSchoolTextField.placeholder = @"";
    juniorSchoolTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    juniorSchoolTextField.font = [UIFont systemFontOfSize:14];
    //    nameTextField.keyboardType = UIKeyboardTypeDecimalPad;
    juniorSchoolTextField.delegate = self;
    juniorSchoolTextField.tag = 10002;
    [schoolImageView addSubview:juniorSchoolTextField];
    
    addButton.frame = CGRectMake(24/2, educationView2.frame.origin.y+educationView2.frame.size.height+20/2, 61.0/2, 61.0/2);
    backgroundScrollView.contentSize = CGSizeMake(320, 1300/2+2*200/2);
    finishView.frame = CGRectMake(0, addButton.frame.origin.y+addButton.frame.size.height+66/2, 320, 140/2);

}
#pragma mark - 高中
- (void)myhighSchool
{
    educationView3 = [[UIView alloc] initWithFrame:CGRectMake(0, educationView2.frame.origin.y+educationView2.frame.size.height+10, 320, 200/2)];
    NSLog(@"高中%f",educationView2.frame.origin.y+educationView2.frame.size.height+10+92);
    educationView3.backgroundColor = [UIColor colorWithRed:208/255.0 green:210/255.0 blue:215/255.0 alpha:1];
    educationView3.userInteractionEnabled = YES;
    [backgroundScrollView addSubview:educationView3];
    
    //教育背景
    UILabel *educationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20/2, 160/2, 72/2)];
    educationLabel.text = @"教育背景：";
    educationLabel.backgroundColor = [UIColor clearColor];
    educationLabel.textAlignment = NSTextAlignmentRight;
    educationLabel.font = [UIFont systemFontOfSize:15];
    [educationView3 addSubview:educationLabel];
    
    UIButton *educationHighButton = [[UIButton alloc] initWithFrame:CGRectMake(164/2, 20/2, 443.0/2, 72/2)];
    [educationHighButton setBackgroundImage:[UIImage imageNamed:@"detailInfo_tableViewButtonBackground_f@2x"]forState:UIControlStateNormal];
    educationHighButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [educationHighButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [educationHighButton setTitle:@"高中" forState:UIControlStateNormal];
    //educationHighButton.tag = sender.tag+1000;
    //[educationHighButton addTarget:self action:@selector(educationButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [educationView3 addSubview:educationHighButton];
    
    //毕业学校
    UILabel *schoolLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, educationLabel.frame.origin.y+educationLabel.frame.size.height+20/2, 160/2, 72/2)];
    schoolLabel.text = @"毕业学校：";
    schoolLabel.backgroundColor = [UIColor clearColor];
    schoolLabel.textAlignment = NSTextAlignmentRight;
    schoolLabel.font = [UIFont systemFontOfSize:15];
    [educationView3 addSubview:schoolLabel];
    
    UIImageView *schoolImageView = [[UIImageView alloc] initWithFrame:CGRectMake(164/2, schoolLabel.frame.origin.y, 443.0/2, 72/2)];
    
    [schoolImageView setImage:[UIImage imageNamed:@"detailInfo_companyBackground_06@2x"]];
    schoolImageView.userInteractionEnabled = YES;
    [educationView3 addSubview:schoolImageView];
    
    highSchoolTextField = [[UITextField alloc] initWithFrame:CGRectMake(16/2, 0, 410/2, 72/2)];
    highSchoolTextField.placeholder = @"";
    highSchoolTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    highSchoolTextField.font = [UIFont systemFontOfSize:14];
    //    highSchoolTextField.keyboardType = UIKeyboardTypeDecimalPad;
    highSchoolTextField.delegate = self;
    highSchoolTextField.tag =10003;
    [schoolImageView addSubview:highSchoolTextField];
    
    addButton.frame = CGRectMake(24/2, educationView3.frame.origin.y+educationView3.frame.size.height+20/2, 61.0/2, 61.0/2);
    backgroundScrollView.contentSize = CGSizeMake(320, 1300/2+3*200/2);
    finishView.frame = CGRectMake(0, addButton.frame.origin.y+addButton.frame.size.height+66/2, 320, 140/2);

}
#pragma mark - 大学
- (void)mycollegeSchool
{
    //教育背景
    educationView4 = [[UIView alloc] initWithFrame:CGRectMake(0, educationView3.frame.origin.y+educationView3.frame.size.height+10, 320, 200/2)];
    NSLog(@"大学%f",educationView3.frame.origin.y+educationView3.frame.size.height+10+92);
    educationView4.backgroundColor = [UIColor colorWithRed:208/255.0 green:210/255.0 blue:215/255.0 alpha:1];
    educationView4.userInteractionEnabled = YES;
    [backgroundScrollView addSubview:educationView4];
    
    //教育背景
    UILabel *educationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20/2, 160/2, 72/2)];
    educationLabel.text = @"教育背景：";
    educationLabel.backgroundColor = [UIColor clearColor];
    educationLabel.textAlignment = NSTextAlignmentRight;
    educationLabel.font = [UIFont systemFontOfSize:15];
    [educationView4 addSubview:educationLabel];
    
    educationThreeButton = [[UIButton alloc] initWithFrame:CGRectMake(164/2, 20/2, 443.0/2, 72/2)];
    [educationThreeButton setBackgroundImage:[UIImage imageNamed:@"detailInfo_tableViewButtonBackground_f@2x"]forState:UIControlStateNormal];
    educationThreeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [educationThreeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [educationThreeButton setTitle:@"大学" forState:UIControlStateNormal];
    //educationThreeButton.tag = sender.tag+1000;
    //[educationThreeButton addTarget:self action:@selector(educationButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [educationView4 addSubview:educationThreeButton];
    
    //毕业学校
    UILabel *schoolLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, educationLabel.frame.origin.y+educationLabel.frame.size.height+20/2, 160/2, 72/2)];
    schoolLabel.text = @"毕业学校：";
    schoolLabel.backgroundColor = [UIColor clearColor];
    schoolLabel.textAlignment = NSTextAlignmentRight;
    schoolLabel.font = [UIFont systemFontOfSize:15];
    [educationView4 addSubview:schoolLabel];
    
    UIImageView *schoolImageView = [[UIImageView alloc] initWithFrame:CGRectMake(164/2, schoolLabel.frame.origin.y, 443.0/2, 72/2)];
    
    [schoolImageView setImage:[UIImage imageNamed:@"detailInfo_companyBackground_06@2x"]];
    schoolImageView.userInteractionEnabled = YES;
    [educationView4 addSubview:schoolImageView];
    
    collegeSchoolTextField = [[UITextField alloc] initWithFrame:CGRectMake(16/2, 0, 410/2, 72/2)];
    collegeSchoolTextField.placeholder = @"";
    collegeSchoolTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    collegeSchoolTextField.font = [UIFont systemFontOfSize:14];
    //    collegeSchoolTextField.keyboardType = UIKeyboardTypeDecimalPad;
    collegeSchoolTextField.delegate = self;
    collegeSchoolTextField.tag =10004;
    [schoolImageView addSubview:collegeSchoolTextField];
    
    addButton.frame = CGRectMake(24/2, educationView.frame.origin.y+educationView.frame.size.height+20/2, 61.0/2, 61.0/2);
    backgroundScrollView.contentSize = CGSizeMake(320, 1300/2+4*200/2);
    finishView.frame = CGRectMake(0, educationView4.frame.origin.y+educationView4.frame.size.height+66/2, 320, 140/2);
    
    addButton.hidden = YES;

}

- (void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 身份背景
-(void)identityButtonClicked
{
    ChooseIdentityViewController *chooseIdentityVC = [[ChooseIdentityViewController alloc] init];
    departmentIdStr = @"";
    [departmentButton setTitle:@"" forState:UIControlStateNormal];
    UINavigationController *chooseIdentityNav = [[UINavigationController alloc] initWithRootViewController:chooseIdentityVC];
    [self presentViewController:chooseIdentityNav animated:YES completion:^{
        ;
    }];
}
#pragma mark - 部门
-(void)departmentButtonClicked
{
    ChooseDepartmentViewController *chooseDepartmentVC = [[ChooseDepartmentViewController alloc] init];
    chooseDepartmentVC.pid = institutionIdStr;
    UINavigationController *chooseDepartmentNav = [[UINavigationController alloc] initWithRootViewController:chooseDepartmentVC];
    [self presentViewController:chooseDepartmentNav animated:YES completion:^{
        ;
    }];
}
#pragma mark - 投资偏好
-(void)preferenceButtonClicked
{
    // preferenceArray = [[NSMutableArray alloc] initWithObjects:@"基金1",@"基金2",@"基金3",@"基金4", nil];
    if (isShowDList == NO) {
        [BCHTTPRequest getinvestmentListWithUsingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
                preferenceArray  = resultDic[@"list"];
                filterArray = preferenceArray;
                [_filterTableView reloadData];
            }
        }];
        
        
        [_filterTableView setContentOffset:CGPointMake(0,0) animated:NO];
        _filterTableView.frame = CGRectMake(168/2, 452/2, 438/2, 100);
        //    if (filterNum == 10) {
        //        [UIView animateWithDuration:0.3 animations:^{
        //
        //            CGRect frame=_filterTableView.frame;
        //            frame.size.height=0;
        //            [_filterTableView setFrame:frame];
        //        } completion:^(BOOL finished){
        //            filterNum = 0;
        //        }];
        //    }else{
        [UIView animateWithDuration:0.3 animations:^{
            filterNum = 10;
            
            
            CGRect frame=_filterTableView.frame;
            frame.size.height= 100;
            
            [_filterTableView setFrame:frame];
            _filterTableView.hidden = NO;
            [_filterTableView reloadData];
        } completion:^(BOOL finished){
            filterNum = 10;
        }];
        isShowDList = YES;

    }else if (isShowDList == YES)
    {
        [_filterTableView setContentOffset:CGPointMake(0,0) animated:NO];
        _filterTableView.frame = CGRectMake(168/2, 452/2, 438/2,0);
        [UIView animateWithDuration:0.3 animations:^{
            filterNum = 10;
            
            
            CGRect frame=_filterTableView.frame;
            frame.size.height= 0;
            
            [_filterTableView setFrame:frame];
            _filterTableView.hidden = NO;
            [_filterTableView reloadData];
        } completion:^(BOOL finished){
            filterNum = 10;
        }];
        
        
    isShowDList = NO;
    }
   
    
    
}
#pragma mark - 出生地
-(void)workCityButtonClicked
{
    WorkCityViewController *WorkCityVC = [[WorkCityViewController alloc] init];
    WorkCityVC.delegete = self;
    UINavigationController *WorkCityNav = [[UINavigationController alloc] initWithRootViewController:WorkCityVC];
    [self presentViewController:WorkCityNav animated:YES completion:^{
        ;
    }];
}

-(void)workAreaButtonClicked
{
    if (workCityStr == nil || [workCityStr isEqualToString:@""]) {
        //
        //[[DMCAlertCenter defaultCenter] postAlertWithMessage:@"请先选择省份"];
        workCityStr = workCityButton.titleLabel.text;
    }else {
        WorkAreaViewController *WorkAreaVC = [[WorkAreaViewController alloc] init];
        WorkAreaVC.delegate = self;
        WorkAreaVC.workCity = workCityStr;
        UINavigationController *WorkAreaNav = [[UINavigationController alloc] initWithRootViewController:WorkAreaVC];
        [self presentViewController:WorkAreaNav animated:YES completion:^{
            ;
        }];
    }
}

//#pragma mark - 教育背景
//-(void)educationButtonClicked:(UIButton *)sender
//{
//    [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    
//    [_filterTableView removeFromSuperview];
//    _filterTableView = [[TableViewWithBlock alloc] initWithFrame:CGRectMake(176/2, 452/2, 438/2, 200)];
//    _filterTableView.backgroundColor = [UIColor whiteColor];
//    _filterTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [backgroundScrollView addSubview:_filterTableView];
//    _filterTableView.hidden = YES;
//    
//    [_filterTableView initTableViewDataSourceAndDelegate:^(UITableView *tableView,NSInteger section)
//     {
//         return (NSInteger)filterArray.count;
//         
//     }setCellForIndexPathBlock:^(UITableView *tableView,NSIndexPath *indexPath){
//         SelectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
//         if (!cell) {
//             cell=[[SelectionCell alloc] init];
//             [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//         }
//         UIImageView *cellXian = [[UIImageView alloc]initWithFrame:CGRectMake(0, 68/2, 438/2, 1)];
//         cellXian.backgroundColor = [UIColor colorWithRed:208/255.0 green:210/255.0 blue:205/255.0 alpha:1];
//         [cell.contentView addSubview:cellXian];
//         cell.lb.textAlignment = NSTextAlignmentLeft;
//         
//         cell.lb.textColor = [UIColor colorWithRed:208/255.0 green:210/255.0 blue:205/255.0 alpha:1];
//         cell.lb.font = [UIFont systemFontOfSize:15];
//         [cell.lb setText:[filterArray objectAtIndex:indexPath.row]];
//         return cell;
//     } setDidSelectRowBlock:^(UITableView *tableView,NSIndexPath *indexPath){
//         SelectionCell *cell=(SelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
//         if (filterNum == 10) {
//             [preferenceButton setTitle:cell.lb.text forState:UIControlStateNormal];
//             [preferenceButton sendActionsForControlEvents:UIControlEventTouchUpInside];
//         }else{
//             [sender setTitle:cell.lb.text forState:UIControlStateNormal];
//             [sender sendActionsForControlEvents:UIControlEventTouchUpInside];
//         }
//     }];
//    
//    schoolArray = [[NSMutableArray alloc] initWithObjects:@"小学",@"初中",@"高中",@"大学", nil];
//    filterArray = schoolArray;
//    [_filterTableView setContentOffset:CGPointMake(0,0) animated:NO];
//    _filterTableView.frame = CGRectMake(168/2, 746/2+(sender.tag-1100)*220/2, 438/2, 200);
//    if (filterNum == sender.tag) {
//        [UIView animateWithDuration:0.3 animations:^{
//            
//            CGRect frame=_filterTableView.frame;
//            frame.size.height=0;
//            [_filterTableView setFrame:frame];
//        } completion:^(BOOL finished){
//            filterNum = 0;
//        }];
//    }else{
//        [UIView animateWithDuration:0.3 animations:^{
//            filterNum = sender.tag;
//            
//            
//            CGRect frame=_filterTableView.frame;
//            frame.size.height= 70/2*filterArray.count;
//            
//            [_filterTableView setFrame:frame];
//            _filterTableView.hidden = NO;
//            [_filterTableView reloadData];
//        } completion:^(BOOL finished){
//            filterNum = sender.tag;
//        }];
//    }
//}
#pragma mark - 增加教育背景
-(void)addButtonClicked:(UIButton *)sender
{
    NSLog(@"泰格值%i",sender.tag);
    
    
    
    //    if (sender.tag-100 < 3) {
    //        //教育背景
    //           }
    //    else if(sender.tag-100 == 3)
    //    {
    //            }
    sender.tag++;
    schoolNumber = sender.tag;
    //    NSLog(@"添加按钮%ld",sender.tag);
    if (sender.tag == 102) {
        //primaryschoolStr = primarySchoolTextField.text;
        [self getMyjuniorSchool];
        
    }else if (sender.tag == 103)
    {
        //juniorschoolStr = juniorSchoolTextField.text;
        [self myhighSchool];
        
    }else if(sender.tag == 104)
    {
        //highSchoolStr = highSchoolTextField.text;
        [self mycollegeSchool];
        
    }
}

#pragma mark - 填写个人简历
-(void)finishButtonClicked
{
    if (juniorSchoolTextField) {
        juniorschoolStr = juniorSchoolTextField.text;
    }else
    {
        juniorschoolStr = @"";
    }
    
    if (highSchoolTextField) {
        highSchoolStr = highSchoolTextField.text;
    }else
    {
        highSchoolStr = @"";
    }
    
    if (collegeSchoolTextField) {
        collegeStr = collegeSchoolTextField.text;
    }else
    {
        collegeStr = @"";
    }
    
    if ([primarySchoolTextField.text length] == 0)
    {
        primaryschoolStr = @"";
    }else
    {
        primaryschoolStr = primarySchoolTextField.text;
    }
    
    
    
    
    if ([institutionIdStr length] == 0) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"请选择背景机构"];
    }else if ([companyTextField.text length]==0)
    {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"请填写公司名称"];
    }else if ([departmentIdStr length]==0)
    {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"请选择部门/条线"];
    }else if ([investmentIdStr length] == 0)
    {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"请选择投资偏好"];
    }else if ([workCityButton.titleLabel.text length]==0)
    {
        workCityStr = @"";
    }else if ([workAreaButton.titleLabel.text length]==0)
    {
        workAreaStr = @"";
    } //    else if ([juniorschoolStr length] == 0)
    //    {
    //        juniorschoolStr = @"";
    //    }else if ([highSchoolStr length] == 0)
    //    {
    //        highSchoolStr = @"";
    //    }else if ([collegeStr length] == 0)
    //    {
    //        collegeStr = @"";
    //    }
    
    
    [BCHTTPRequest RegisterTheSecondWithInstitution_id:institutionIdStr WithCompany:companyTextField.text WithDepartmentID:departmentIdStr WithInvestment_preference_id:investmentIdStr WithBirth_city:workCityButton.titleLabel.text WithBirth_area:workAreaButton.titleLabel.text WithPrimary_school:primaryschoolStr WithJunior_middle_school:juniorschoolStr WithHigh_school:highSchoolStr WithUniversity:collegeStr usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            
            
        }
    }];
  
    
    //修改详细信息
    PersonResumeViewController *personResumeVC = [[PersonResumeViewController alloc] init];
    personResumeVC.isLogin = @"login";
    UINavigationController *personResumeNav = [[UINavigationController alloc] initWithRootViewController:personResumeVC];
    [self presentViewController:personResumeNav animated:YES completion:^{
        ;
    }];

    
    
}

#pragma mark - 跳过
-(void)skipButtonClicked
{
    //修改详细信息
    PersonResumeViewController *personResumeVC = [[PersonResumeViewController alloc] init];
    personResumeVC.isLogin = @"login";
    UINavigationController *personResumeNav = [[UINavigationController alloc] initWithRootViewController:personResumeVC];
    [self presentViewController:personResumeNav animated:YES completion:^{
        ;
    }];
}

#pragma mark - 键盘隐藏
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return [textField resignFirstResponder];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [companyTextField resignFirstResponder];
    [primarySchoolTextField resignFirstResponder];
    [juniorSchoolTextField resignFirstResponder];
    [highSchoolTextField resignFirstResponder];
    [collegeSchoolTextField resignFirstResponder];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [companyTextField resignFirstResponder];
    [primarySchoolTextField resignFirstResponder];
    [juniorSchoolTextField resignFirstResponder];
    [highSchoolTextField resignFirstResponder];
    [collegeSchoolTextField resignFirstResponder];
}
#pragma mark - 移动视图
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
//    if (!_autoCompleter)
//    {
        NSMutableDictionary *options = [NSMutableDictionary dictionaryWithCapacity:200];
        [options setValue:[NSNumber numberWithBool:YES] forKey:ACOCaseSensitive];
        [options setValue:nil forKey:ACOUseSourceFont];
        
        
        if (textField == companyTextField) {
            //autoCompleter.isStyle = @"yes";
            autoCompleter = [[AutocompletionTableView alloc] initWithTextField:companyTextField inViewController:self withOptions:options];
            autoCompleter.suggestionsDictionary = [NSArray arrayWithArray:companyArray];
            [companyTextField addTarget:autoCompleter action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
            
        }else if (textField  == primarySchoolTextField) {
            [backgroundScrollView setContentOffset:CGPointMake(0,700/2) animated:YES];
            autoCompleter = [[AutocompletionTableView alloc] initWithTextField:primarySchoolTextField inViewController:self withOptions:options];
            autoCompleter.suggestionsDictionary = [NSArray arrayWithArray:primaryschoolArray];
            [primarySchoolTextField addTarget:autoCompleter action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
            
        }else if (textField == juniorSchoolTextField) {
            [backgroundScrollView setContentOffset:CGPointMake(0,700/2) animated:YES];
            autoCompleter = [[AutocompletionTableView alloc] initWithTextField:juniorSchoolTextField inViewController:self withOptions:options];
            
            autoCompleter.suggestionsDictionary = [NSArray arrayWithArray:juniorschoolArray];
            
            [juniorSchoolTextField addTarget:autoCompleter action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
            
        }else if(textField == highSchoolTextField){
            [backgroundScrollView setContentOffset:CGPointMake(0,950/2) animated:YES];
            autoCompleter = [[AutocompletionTableView alloc] initWithTextField:highSchoolTextField inViewController:self withOptions:options];
            
            autoCompleter.suggestionsDictionary = [NSArray arrayWithArray:highSchoolArray];
            
            [highSchoolTextField addTarget:autoCompleter action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
        }else if(textField == collegeSchoolTextField){
            [backgroundScrollView setContentOffset:CGPointMake(0,1100/2) animated:YES];
            
            autoCompleter = [[AutocompletionTableView alloc] initWithTextField:collegeSchoolTextField inViewController:self withOptions:options];
            
            autoCompleter.suggestionsDictionary = [NSArray arrayWithArray:collegeArray];
            
            [collegeSchoolTextField addTarget:autoCompleter action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
        }

//    }


    
   }

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField.tag == 5000) {
        
     
    }
    
    
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - WorkCityDelegate
- (void)getWorkCity:(NSDictionary *)cityDict
{
    NSLog(@"------城市------%@",cityDict);
    workCityStr = [cityDict objectForKey:@"name"];
    [workCityButton setTitle:workCityStr forState:UIControlStateNormal];
    
    NSArray *m_cityArray = [[NSArray alloc]init];
    NSArray *m_array = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]];
    
    for (NSDictionary * itemDict in m_array) {
        if ([[itemDict objectForKey:@"state"] isEqualToString:workCityStr]) {
            //找到了选择的省
            m_cityArray = [itemDict objectForKey:@"cities"];//这个数组里面是字典
            break;
        }
    }
    [workAreaButton setTitle:m_cityArray[0][@"city"] forState:UIControlStateNormal];
   

}

#pragma mark - WorkAreaDelegate
- (void)getWorkArea:(NSDictionary *)areaDict
{
     NSLog(@"------区域------%@",areaDict);
    workAreaStr = [areaDict objectForKey:@"city"];
    [workAreaButton setTitle:workAreaStr forState:UIControlStateNormal];
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
