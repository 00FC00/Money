//
//  OtherPeopleMessageDetialsViewController.m
//  FaceBook
//
//  Created by fengshaohui on 14-7-31.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "OtherPeopleMessageDetialsViewController.h"
#import "BCHTTPRequest.h"
#import "AFNetworking.h"
#import "GlobalVariable.h"

#define ADDHEITH 83.0


@interface OtherPeopleMessageDetialsViewController ()

@property(nonatomic,strong)UIScrollView* myScrollView;

//设置头视图的属性
@property(nonatomic,strong)UIImageView* photoImgaeView;
@property(nonatomic,strong)UILabel* nickName;
@property(nonatomic,strong)UILabel* trueName;
@property(nonatomic,strong)UILabel* faceNumber;
@property(nonatomic,strong)UILabel* identifyLabel;

//设置信息视图的属性
@property(nonatomic,strong)UILabel* locationLabel;
@property(nonatomic,strong)UILabel* institutionLabel;
@property(nonatomic,strong)UILabel* departmentLabel;
@property(nonatomic,strong)UILabel* dutyLabel;

@property (strong, nonatomic) NSDictionary *otherResumeDictionary;//其他人的个人简历字典


@end

@implementation OtherPeopleMessageDetialsViewController

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
    self.title = @"个人资料";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 22, 40, 40);
    [backButton setBackgroundImage:[UIImage imageNamed:@"login_backButton@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //[self.navigationController.view addSubview:backButton];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;
    
    //设置scrollView
    self.myScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    self.myScrollView.backgroundColor=[UIColor colorWithRed:246/255.0 green:247/255.0 blue:250/255.0 alpha:1.0];
    [self.view addSubview:self.myScrollView];
    
    [BCHTTPRequest getMyFriendInformationWithFID:_friendIdString usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            _mySweepDictionary = resultDic;
            
            //设置头视图
            [self setHeadView];
            //设置信息视图
            [self setInformationView];
            if ([_isCircle isEqualToString:@"yes"]) {
                [self Relationship];
            }
            if ([_isInHere isEqualToString:@"yes"]) {
                [self addInstationView];
            }
        }
    }];
    
    [BCHTTPRequest getOtherPersonResumeListWithUserId:_friendIdString UsingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            
            _otherResumeDictionary = resultDic;
            //设置个人简历
            [self setPersonResumeInfomation];
        }
    }];

}
- (void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setHeadView{
    //设置头像
    self.photoImgaeView=[[UIImageView alloc]initWithFrame:CGRectMake(0, ADDHEITH, 105, 120)];
    self.photoImgaeView.backgroundColor=[UIColor lightGrayColor];
//    [self.photoImgaeView.layer setMasksToBounds:YES];
//    [self.photoImgaeView.layer setCornerRadius:3.0f];
    [self.photoImgaeView setImageWithURL:[NSURL URLWithString:_mySweepDictionary[@"pic"]] placeholderImage:[UIImage imageNamed:@"ceshi@2x"]];
    [self.myScrollView addSubview:self.photoImgaeView];
    
    //设置昵称
    self.nickName=[[UILabel alloc]initWithFrame:CGRectMake(115, 7+ADDHEITH, 180, 20)];
    self.nickName.backgroundColor=[UIColor clearColor];
    self.nickName.textColor=[UIColor colorWithRed:98.0/255 green:98.0/255 blue:98.0/255 alpha:1.0];
    self.nickName.font=[UIFont systemFontOfSize:16];
    [self.nickName setTextAlignment:NSTextAlignmentLeft];
    self.nickName.text=[NSString stringWithFormat:@"昵称:%@",_mySweepDictionary[@"nickname_first"]];
    [self.myScrollView addSubview:self.nickName];
    //设置姓名
    self.trueName=[[UILabel alloc]initWithFrame:CGRectMake(115, 27+10+ADDHEITH, 180, 20)];
    self.trueName.textColor=[UIColor colorWithRed:98.0/255 green:98.0/255 blue:98.0/255 alpha:1.0];
    self.trueName.font=[UIFont systemFontOfSize:16];
    self.trueName.backgroundColor=[UIColor clearColor];
    self.trueName.text=[NSString stringWithFormat:@"真实姓名: %@",_mySweepDictionary[@"name"]];
    [self.myScrollView addSubview:self.trueName];
    
    //设置脸谱号
    self.faceNumber=[[UILabel alloc]initWithFrame:CGRectMake(115, 27+15+2+20+ADDHEITH, 180, 20)];
    self.faceNumber.font=[UIFont systemFontOfSize:16];
    self.faceNumber.textColor=[UIColor colorWithRed:98.0/255 green:98.0/255 blue:98.0/255 alpha:1.0];
    self.faceNumber.backgroundColor=[UIColor clearColor];
    self.faceNumber.text=[NSString stringWithFormat:@"脸谱号: %@",_mySweepDictionary[@"lp_sn"]];
    [self.myScrollView addSubview:self.faceNumber];
    
    //设置认可身份
    self.identifyLabel=[[UILabel alloc]initWithFrame:CGRectMake(115, 57+2+35+ADDHEITH, 180, 20)];
    
    self.identifyLabel.font=[UIFont systemFontOfSize:15];
    self.identifyLabel.textColor=[UIColor colorWithRed:98.0/255 green:98.0/255 blue:98.0/255 alpha:1.0];
    self.identifyLabel.backgroundColor=[UIColor clearColor];
    self.identifyLabel.text=[NSString stringWithFormat:@"%@人已认可TA的身份",_mySweepDictionary[@"accept_number"]];
    [self.myScrollView addSubview:self.identifyLabel];
}
-(void)setInformationView{
    
    int i=0;
    //设置地区---更改为机构
    self.locationLabel=[[UILabel alloc]init];
    self.locationLabel.text=[NSString stringWithFormat:@"   %@",_mySweepDictionary[@"institution"]];;
    self.locationLabel.textColor = [UIColor whiteColor];
    if (self.locationLabel.text.length>0) {
        self.locationLabel.frame=CGRectMake(0, 0, self.view.frame.size.width, 33);
        self.locationLabel.font=[UIFont boldSystemFontOfSize:17];
        self.locationLabel.layer.borderColor=[UIColor colorWithRed:232.0f/255.0f green:233.0f/255.0f blue:232.0f/255.0f alpha:1.0].CGColor;
        self.locationLabel.layer.borderWidth=0.0f;
        self.locationLabel.backgroundColor=[UIColor colorWithRed:70.0/255 green:80.0/255 blue:94.0/255 alpha:1.0];
        [self.myScrollView addSubview:self.locationLabel];
        i++;
    }
    //设置机构
    self.institutionLabel=[[UILabel alloc]init];
    self.institutionLabel.text=[NSString stringWithFormat:@"   %@",_mySweepDictionary[@"department"]];
    self.institutionLabel.textColor = [UIColor whiteColor];
    if (self.institutionLabel.text.length>0) {
        self.institutionLabel.frame=CGRectMake(0, i*33, self.view.frame.size.width, 25);
        self.institutionLabel.font=[UIFont systemFontOfSize:15];
        self.institutionLabel.layer.borderColor=[UIColor colorWithRed:232.0f/255.0f green:233.0f/255.0f blue:232.0f/255.0f alpha:1.0].CGColor;
        self.institutionLabel.layer.borderWidth=0.0f;
        self.institutionLabel.backgroundColor=[UIColor colorWithRed:70.0/255 green:80.0/255 blue:94.0/255 alpha:1.0];
        [self.myScrollView addSubview:self.institutionLabel];
        i++;
    }
    //设置部门
    self.departmentLabel=[[UILabel alloc]init];
    self.departmentLabel.text=[NSString stringWithFormat:@"   %@ %@",_mySweepDictionary[@"work_city"],_mySweepDictionary[@"work_area"]];
    self.departmentLabel.textColor = [UIColor whiteColor];
    if (self.departmentLabel.text.length>0) {
        self.departmentLabel.frame=CGRectMake(0, 33+25, self.view.frame.size.width, 25);
        self.departmentLabel.font=[UIFont systemFontOfSize:15];
        self.departmentLabel.layer.borderColor=[UIColor colorWithRed:232.0f/255.0f green:233.0f/255.0f blue:232.0f/255.0f alpha:1.0].CGColor;
        self.departmentLabel.layer.borderWidth=0.0f;
        self.departmentLabel.backgroundColor=[UIColor colorWithRed:70.0/255 green:80.0/255 blue:94.0/255 alpha:1.0];
        [self.myScrollView addSubview:self.departmentLabel];
        i++;
    }
//    //设置职务
//    self.dutyLabel=[[UILabel alloc]init];
//    self.dutyLabel.text=[NSString stringWithFormat:@"  职务: %@",_mySweepDictionary[@"department"]];
//    if (self.dutyLabel.text.length>0) {
//        self.dutyLabel.frame=CGRectMake(10, 95+i*33, 300, 33);
//        self.dutyLabel.font=[UIFont systemFontOfSize:15];
//        self.dutyLabel.layer.borderColor=[UIColor colorWithRed:232.0f/255.0f green:233.0f/255.0f blue:232.0f/255.0f alpha:1.0].CGColor;
//        self.dutyLabel.layer.borderWidth=0.5f;
//        self.dutyLabel.backgroundColor=[UIColor whiteColor];
//        [self.myScrollView addSubview:self.dutyLabel];
//        i++;
//    }
}
- (void)Relationship
{
    ///标题
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 215, 100, 25)];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = [UIColor darkGrayColor];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.text = [NSString stringWithFormat:@"%@是我的:",_mySweepDictionary[@"name"]];
    [_myScrollView addSubview:_titleLabel];
    
    ///同事
    self.colleaguesButton=[[UIButton alloc]initWithFrame:CGRectMake(110, 215, 60, 25)];
    self.colleaguesButton.backgroundColor=[UIColor colorWithRed:21.0/255 green:96.0/255 blue:224.0/255 alpha:1.0];
    [self.colleaguesButton setTitle:@"同事" forState:UIControlStateNormal];
    self.colleaguesButton.titleLabel.font=[UIFont boldSystemFontOfSize:14];
    //[self.colleaguesButton setBackgroundImage:[UIImage imageNamed:@"tianjiadaoheimingdan@2x"] forState:UIControlStateNormal];
    [self.colleaguesButton.layer setMasksToBounds:YES];
    [self.colleaguesButton.layer setCornerRadius:4.0f];
    self.colleaguesButton.tag = 6000;
    [self.colleaguesButton addTarget:self action:@selector(clickRelationShipButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.myScrollView addSubview:self.colleaguesButton];
    
    ///领导
    self.leaderButton=[[UIButton alloc]initWithFrame:CGRectMake(110+65, 215, 60, 25)];
    self.leaderButton.backgroundColor=[UIColor colorWithRed:21.0/255 green:96.0/255 blue:224.0/255 alpha:1.0];
    [self.leaderButton setTitle:@"领导" forState:UIControlStateNormal];
    self.leaderButton.titleLabel.font=[UIFont boldSystemFontOfSize:14];
    //[self.leaderButton setBackgroundImage:[UIImage imageNamed:@"tianjiadaoheimingdan@2x"] forState:UIControlStateNormal];
    [self.leaderButton.layer setMasksToBounds:YES];
    [self.leaderButton.layer setCornerRadius:4.0f];
    self.leaderButton.tag = 7000;
    [self.leaderButton addTarget:self action:@selector(clickRelationShipButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.myScrollView addSubview:self.leaderButton];
    
    ///下属
    self.subordinatesButton=[[UIButton alloc]initWithFrame:CGRectMake(110+65*2, 215, 60, 25)];
    self.subordinatesButton.backgroundColor=[UIColor colorWithRed:21.0/255 green:96.0/255 blue:224.0/255 alpha:1.0];
    [self.subordinatesButton setTitle:@"下属" forState:UIControlStateNormal];
    self.subordinatesButton.titleLabel.font=[UIFont boldSystemFontOfSize:14];
    //[self.subordinatesButton setBackgroundImage:[UIImage imageNamed:@"tianjiadaoheimingdan@2x"] forState:UIControlStateNormal];
    [self.subordinatesButton.layer setMasksToBounds:YES];
    [self.subordinatesButton.layer setCornerRadius:4.0f];
    self.subordinatesButton.tag = 8000;
    [self.subordinatesButton addTarget:self action:@selector(clickRelationShipButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.myScrollView addSubview:self.subordinatesButton];
    
}
#pragma mark - 确认关系
- (void)clickRelationShipButton:(UIButton *)button
{
    
    if (button.tag == 6000) {
        _typeString = @"1";
    }else if (button.tag == 7000) {
        _typeString = @"2";
    }else if (button.tag == 8000) {
        _typeString = @"3";
    }
    
    GlobalVariable *globalVariable = [GlobalVariable sharedGlobalVariable];
    [BCHTTPRequest confirmationWithType:_typeString WithFriend_id:_mySweepDictionary[@"fid"] WithInstitution_id:globalVariable.institutionsIdString usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
        }
    }];

}

#pragma mark -加站内联系人
- (void)addInstationView
{
    self.instationButton=[[UIButton alloc]initWithFrame:CGRectMake(5, 215, 100, 25)];
    self.instationButton.backgroundColor=[UIColor colorWithRed:21.0/255 green:96.0/255 blue:224.0/255 alpha:1.0];
    [self.instationButton setTitle:@"加为站内联系人" forState:UIControlStateNormal];
    self.instationButton.titleLabel.font=[UIFont boldSystemFontOfSize:14];
    //[self.instationButton setBackgroundImage:[UIImage imageNamed:@"querengoumai@2x"] forState:UIControlStateNormal];
    [self.instationButton.layer setMasksToBounds:YES];
    [self.instationButton.layer setCornerRadius:4.0f];
    self.instationButton.tag = 6000;
    [self.instationButton addTarget:self action:@selector(clickinstationButton) forControlEvents:UIControlEventTouchUpInside];
    [self.myScrollView addSubview:self.instationButton];
}


///设置个人简历
- (void)setPersonResumeInfomation
{
    //判断是否注册好友
        //有按钮
        //个人信息字样lable
        UILabel * personLabel =[[UILabel alloc]init];
        personLabel.text=@"  个人信息";
        personLabel.textColor = [UIColor blackColor];
        personLabel.frame=CGRectMake(0, 253, self.view.frame.size.width, 50);
        personLabel.font=[UIFont boldSystemFontOfSize:17];
        personLabel.layer.borderColor=[UIColor blackColor].CGColor;
        personLabel.layer.borderWidth=0.0f;
        personLabel.backgroundColor=[UIColor colorWithRed:201.0f/255.0f green:209.0f/255.0f blue:222.0f/255.0f alpha:1.0];
        [self.myScrollView addSubview:personLabel];
        
        //************职业经历**********************
        UILabel * occupationLabel =[[UILabel alloc]init];
        occupationLabel.text=@"  职业经历";
        occupationLabel.textColor = [UIColor colorWithRed:67.0f/255.0f green:67.0f/255.0f blue:67.0f/255.0f alpha:1.0];
        occupationLabel.frame=CGRectMake(0, 253+personLabel.frame.size.height, self.view.frame.size.width, 23);
        occupationLabel.font=[UIFont systemFontOfSize:15.5];
        occupationLabel.backgroundColor=[UIColor clearColor];
        [self.myScrollView addSubview:occupationLabel];
        //先判断职业经历有几个
        if ([[[_otherResumeDictionary objectForKey:@"occupation"] class] isSubclassOfClass:[NSArray class]] == YES) {
            //如果是数组就好了说明有内容
            for (NSInteger i = 0; i < [[_otherResumeDictionary objectForKey:@"occupation"] count]; i++) {
                //时间的label
                UILabel * occupationTimeLabel =[[UILabel alloc]init];
                occupationTimeLabel.text=[NSString stringWithFormat:@"  %@至%@",[[[_otherResumeDictionary objectForKey:@"occupation"] objectAtIndex:i] objectForKey:@"start_time"],[[[_otherResumeDictionary objectForKey:@"occupation"] objectAtIndex:i] objectForKey:@"end_time"]];
                occupationTimeLabel.textColor = [UIColor colorWithRed:67.0f/255.0f green:67.0f/255.0f blue:67.0f/255.0f alpha:1.0];
                occupationTimeLabel.frame=CGRectMake(0, 142*i+occupationLabel.frame.origin.y+occupationLabel.frame.size.height, self.view.frame.size.width, 20);
                occupationTimeLabel.font=[UIFont systemFontOfSize:14];
                occupationTimeLabel.backgroundColor=[UIColor clearColor];
                [self.myScrollView addSubview:occupationTimeLabel];
                //名称的lable
                UILabel * occupationNameLabel =[[UILabel alloc]init];
                occupationNameLabel.text=[NSString stringWithFormat:@"  %@",[[[_otherResumeDictionary objectForKey:@"occupation"] objectAtIndex:i] objectForKey:@"com_name"]];
                occupationNameLabel.textColor = [UIColor colorWithRed:67.0f/255.0f green:67.0f/255.0f blue:67.0f/255.0f alpha:1.0];
                occupationNameLabel.frame=CGRectMake(0, occupationTimeLabel.frame.origin.y+occupationTimeLabel.frame.size.height, self.view.frame.size.width, 20);
                occupationNameLabel.font=[UIFont systemFontOfSize:14];
                occupationNameLabel.backgroundColor=[UIColor clearColor];
                [self.myScrollView addSubview:occupationNameLabel];
                //部门的lable
                UILabel * occupationBumenLabel =[[UILabel alloc]init];
                occupationBumenLabel.text=[NSString stringWithFormat:@"  %@",[[[_otherResumeDictionary objectForKey:@"occupation"] objectAtIndex:i] objectForKey:@"department_name"]];
                occupationBumenLabel.textColor = [UIColor colorWithRed:67.0f/255.0f green:67.0f/255.0f blue:67.0f/255.0f alpha:1.0];
                occupationBumenLabel.frame=CGRectMake(0, occupationNameLabel.frame.origin.y+occupationNameLabel.frame.size.height, self.view.frame.size.width, 20);
                occupationBumenLabel.font=[UIFont systemFontOfSize:14];
                occupationBumenLabel.backgroundColor=[UIColor clearColor];
                [self.myScrollView addSubview:occupationBumenLabel];
                //职务的lable
                UILabel * occupationZhiwuLabel =[[UILabel alloc]init];
                occupationZhiwuLabel.text=[NSString stringWithFormat:@"  %@",[[[_otherResumeDictionary objectForKey:@"occupation"] objectAtIndex:i] objectForKey:@"work_field"]];
                occupationZhiwuLabel.textColor = [UIColor colorWithRed:67.0f/255.0f green:67.0f/255.0f blue:67.0f/255.0f alpha:1.0];
                occupationZhiwuLabel.frame=CGRectMake(0, occupationBumenLabel.frame.origin.y+occupationBumenLabel.frame.size.height, self.view.frame.size.width, 20);
                occupationZhiwuLabel.font=[UIFont systemFontOfSize:14];
                occupationZhiwuLabel.backgroundColor=[UIColor clearColor];
                [self.myScrollView addSubview:occupationZhiwuLabel];
                //岗位介绍字段的lable
                UILabel * occupationStationLabel =[[UILabel alloc]init];
                occupationStationLabel.text=[NSString stringWithFormat:@"  %@",@"岗位介绍："];
                occupationStationLabel.textColor = [UIColor colorWithRed:67.0f/255.0f green:67.0f/255.0f blue:67.0f/255.0f alpha:1.0];
                occupationStationLabel.frame=CGRectMake(0, occupationZhiwuLabel.frame.origin.y+occupationZhiwuLabel.frame.size.height, self.view.frame.size.width, 20);
                occupationStationLabel.font=[UIFont systemFontOfSize:14];
                occupationStationLabel.backgroundColor=[UIColor clearColor];
                [self.myScrollView addSubview:occupationStationLabel];
                //岗位介绍描述字段的lable
                UILabel * occupationStationDesLabel =[[UILabel alloc]init];
                occupationStationDesLabel.text=[NSString stringWithFormat:@"  %@\n ",[[[_otherResumeDictionary objectForKey:@"occupation"] objectAtIndex:i] objectForKey:@"job_description"]];
                occupationStationDesLabel.textColor = [UIColor colorWithRed:67.0f/255.0f green:67.0f/255.0f blue:67.0f/255.0f alpha:1.0];
                occupationStationDesLabel.numberOfLines = 0;
                occupationStationDesLabel.frame=CGRectMake(15, +occupationStationLabel.frame.origin.y+occupationStationLabel.frame.size.height, self.view.frame.size.width-30, 40);
                occupationStationDesLabel.font=[UIFont systemFontOfSize:12.5];
                occupationStationDesLabel.backgroundColor=[UIColor clearColor];
                [self.myScrollView addSubview:occupationStationDesLabel];
            }
        }
        
        //线的的View
        UIView * lineoneView =[[UIView alloc]initWithFrame:CGRectMake(0, occupationLabel.frame.origin.y+occupationLabel.frame.size.height+142*[[_otherResumeDictionary objectForKey:@"occupation"] count], self.view.frame.size.width, 1)];
        lineoneView.backgroundColor = [UIColor colorWithRed:188.0f/255.0f green:192.0f/255.0f blue:199.0f/255.0f alpha:1.0];
        [self.myScrollView addSubview:lineoneView];
        
        //************教育经历**********************
        
        CGFloat heightNumber = occupationLabel.frame.origin.y+occupationLabel.frame.size.height+142*[[_otherResumeDictionary objectForKey:@"occupation"] count]+7;
        
        UILabel * educationLabel =[[UILabel alloc]init];
        educationLabel.text=@"  教育经历";
        educationLabel.textColor = [UIColor colorWithRed:67.0f/255.0f green:67.0f/255.0f blue:67.0f/255.0f alpha:1.0];
        educationLabel.frame=CGRectMake(0, heightNumber, self.view.frame.size.width, 23);
        educationLabel.font=[UIFont systemFontOfSize:15.5];
        educationLabel.backgroundColor=[UIColor clearColor];
        [self.myScrollView addSubview:educationLabel];
        //先判断教育经历有几个
        if ([[[_otherResumeDictionary objectForKey:@"education"] class] isSubclassOfClass:[NSArray class]] == YES) {
            //如果是数组就好了说明有内容
            for (NSInteger i = 0; i < [[_otherResumeDictionary objectForKey:@"education"] count]; i++) {
                //时间的label
                UILabel * educationTimeLabel =[[UILabel alloc]init];
                educationTimeLabel.text=[NSString stringWithFormat:@"  %@至%@",[[[_otherResumeDictionary objectForKey:@"education"] objectAtIndex:i] objectForKey:@"start_time"],[[[_otherResumeDictionary objectForKey:@"education"] objectAtIndex:i] objectForKey:@"end_time"]];
                educationTimeLabel.textColor = [UIColor colorWithRed:67.0f/255.0f green:67.0f/255.0f blue:67.0f/255.0f alpha:1.0];
                educationTimeLabel.frame=CGRectMake(0, 83*i+educationLabel.frame.origin.y+educationLabel.frame.size.height, self.view.frame.size.width, 20);
                educationTimeLabel.font=[UIFont systemFontOfSize:14];
                educationTimeLabel.backgroundColor=[UIColor clearColor];
                [self.myScrollView addSubview:educationTimeLabel];
                //毕业院校名字的lable
                UILabel * educationNameLabel =[[UILabel alloc]init];
                educationNameLabel.text=[NSString stringWithFormat:@"  毕业院校：%@",[[[_otherResumeDictionary objectForKey:@"education"] objectAtIndex:i] objectForKey:@"graduate_institutions"]];
                educationNameLabel.textColor = [UIColor colorWithRed:67.0f/255.0f green:67.0f/255.0f blue:67.0f/255.0f alpha:1.0];
                educationNameLabel.frame=CGRectMake(0, educationTimeLabel.frame.origin.y+educationTimeLabel.frame.size.height, self.view.frame.size.width, 20);
                educationNameLabel.font=[UIFont systemFontOfSize:14];
                educationNameLabel.backgroundColor=[UIColor clearColor];
                [self.myScrollView addSubview:educationNameLabel];
                //专业的lable
                UILabel * educationProfessionBumenLabel =[[UILabel alloc]init];
                educationProfessionBumenLabel.text=[NSString stringWithFormat:@"  专业：%@",[[[_otherResumeDictionary objectForKey:@"education"] objectAtIndex:i] objectForKey:@"professional"]];
                educationProfessionBumenLabel.textColor = [UIColor colorWithRed:67.0f/255.0f green:67.0f/255.0f blue:67.0f/255.0f alpha:1.0];
                educationProfessionBumenLabel.frame=CGRectMake(0, educationNameLabel.frame.origin.y+educationNameLabel.frame.size.height, self.view.frame.size.width, 20);
                educationProfessionBumenLabel.font=[UIFont systemFontOfSize:14];
                educationProfessionBumenLabel.backgroundColor=[UIColor clearColor];
                [self.myScrollView addSubview:educationProfessionBumenLabel];
                //学位的lable
                UILabel * educationDegreeLabel =[[UILabel alloc]init];
                educationDegreeLabel.text=[NSString stringWithFormat:@"  学位：%@",[[[_otherResumeDictionary objectForKey:@"education"] objectAtIndex:i] objectForKey:@"degree"]];
                educationDegreeLabel.textColor = [UIColor colorWithRed:67.0f/255.0f green:67.0f/255.0f blue:67.0f/255.0f alpha:1.0];
                educationDegreeLabel.frame=CGRectMake(0, educationProfessionBumenLabel.frame.origin.y+educationProfessionBumenLabel.frame.size.height, self.view.frame.size.width, 20);
                educationDegreeLabel.font=[UIFont systemFontOfSize:14];
                educationDegreeLabel.backgroundColor=[UIColor clearColor];
                [self.myScrollView addSubview:educationDegreeLabel];
                
            }
        }
        
        //线的的View
        UIView * lineTwoView =[[UIView alloc]initWithFrame:CGRectMake(0, educationLabel.frame.origin.y+educationLabel.frame.size.height+83*[[_otherResumeDictionary objectForKey:@"education"] count], self.view.frame.size.width, 1)];
        lineTwoView.backgroundColor = [UIColor colorWithRed:188.0f/255.0f green:192.0f/255.0f blue:199.0f/255.0f alpha:1.0];
        [self.myScrollView addSubview:lineTwoView];
        
        //************项目经历**********************
        
        CGFloat heightProject = educationLabel.frame.origin.y+educationLabel.frame.size.height+83*[[_otherResumeDictionary objectForKey:@"education"] count]+7;
        
        UILabel * projectLabel =[[UILabel alloc]init];
        projectLabel.text=@"  项目经历";
        projectLabel.textColor = [UIColor colorWithRed:67.0f/255.0f green:67.0f/255.0f blue:67.0f/255.0f alpha:1.0];
        projectLabel.frame=CGRectMake(0, heightProject, self.view.frame.size.width, 23);
        projectLabel.font=[UIFont systemFontOfSize:15.5];
        projectLabel.backgroundColor=[UIColor clearColor];
        [self.myScrollView addSubview:projectLabel];
        //先判断职业经历有几个
        if ([[[_otherResumeDictionary objectForKey:@"project"] class] isSubclassOfClass:[NSArray class]] == YES) {
            //如果是数组就好了说明有内容
            for (NSInteger i = 0; i < [[_otherResumeDictionary objectForKey:@"project"] count]; i++) {
                //时间的label
                UILabel * projectTimeLabel =[[UILabel alloc]init];
                projectTimeLabel.text=[NSString stringWithFormat:@"  %@至%@",[[[_otherResumeDictionary objectForKey:@"project"] objectAtIndex:i] objectForKey:@"start_time"],[[[_otherResumeDictionary objectForKey:@"project"] objectAtIndex:i] objectForKey:@"end_time"]];
                projectTimeLabel.textColor = [UIColor colorWithRed:67.0f/255.0f green:67.0f/255.0f blue:67.0f/255.0f alpha:1.0];
                projectTimeLabel.frame=CGRectMake(0, 142*i+projectLabel.frame.origin.y+projectLabel.frame.size.height, self.view.frame.size.width, 20);
                projectTimeLabel.font=[UIFont systemFontOfSize:14];
                projectTimeLabel.backgroundColor=[UIColor clearColor];
                [self.myScrollView addSubview:projectTimeLabel];
                //公司名称的lable
                UILabel * companyNameLabel =[[UILabel alloc]init];
                companyNameLabel.text=[NSString stringWithFormat:@"  公司名称：%@",[[[_otherResumeDictionary objectForKey:@"project"] objectAtIndex:i] objectForKey:@"com_name"]];
                companyNameLabel.textColor = [UIColor colorWithRed:67.0f/255.0f green:67.0f/255.0f blue:67.0f/255.0f alpha:1.0];
                companyNameLabel.frame=CGRectMake(0, projectTimeLabel.frame.origin.y+projectTimeLabel.frame.size.height, self.view.frame.size.width, 20);
                companyNameLabel.font=[UIFont systemFontOfSize:14];
                companyNameLabel.backgroundColor=[UIColor clearColor];
                [self.myScrollView addSubview:companyNameLabel];
                //职位的lable
                UILabel * positionLabel =[[UILabel alloc]init];
                positionLabel.text=[NSString stringWithFormat:@"  职位：%@",[[[_otherResumeDictionary objectForKey:@"project"] objectAtIndex:i] objectForKey:@"project_positions"]];
                positionLabel.textColor = [UIColor colorWithRed:67.0f/255.0f green:67.0f/255.0f blue:67.0f/255.0f alpha:1.0];
                positionLabel.frame=CGRectMake(0, companyNameLabel.frame.origin.y+companyNameLabel.frame.size.height, self.view.frame.size.width, 20);
                positionLabel.font=[UIFont systemFontOfSize:14];
                positionLabel.backgroundColor=[UIColor clearColor];
                [self.myScrollView addSubview:positionLabel];
                //项目名称的lable
                UILabel * projectNameLabel =[[UILabel alloc]init];
                projectNameLabel.text=[NSString stringWithFormat:@"  项目名称：%@",[[[_otherResumeDictionary objectForKey:@"project"] objectAtIndex:i] objectForKey:@"project_name"]];
                projectNameLabel.textColor = [UIColor colorWithRed:67.0f/255.0f green:67.0f/255.0f blue:67.0f/255.0f alpha:1.0];
                projectNameLabel.frame=CGRectMake(0, positionLabel.frame.origin.y+positionLabel.frame.size.height, self.view.frame.size.width, 20);
                projectNameLabel.font=[UIFont systemFontOfSize:14];
                projectNameLabel.backgroundColor=[UIColor clearColor];
                [self.myScrollView addSubview:projectNameLabel];
                //岗位介绍字段的lable
                UILabel * projectStationLabel =[[UILabel alloc]init];
                projectStationLabel.text=[NSString stringWithFormat:@"  %@",@"项目介绍："];
                projectStationLabel.textColor = [UIColor colorWithRed:67.0f/255.0f green:67.0f/255.0f blue:67.0f/255.0f alpha:1.0];
                projectStationLabel.frame=CGRectMake(0, projectNameLabel.frame.origin.y+projectNameLabel.frame.size.height, self.view.frame.size.width, 20);
                projectStationLabel.font=[UIFont systemFontOfSize:14];
                projectStationLabel.backgroundColor=[UIColor clearColor];
                [self.myScrollView addSubview:projectStationLabel];
                //岗位介绍描述字段的lable
                UILabel * projectStationDesLabel =[[UILabel alloc]init];
                projectStationDesLabel.text=[NSString stringWithFormat:@"  %@\n ",[[[_otherResumeDictionary objectForKey:@"project"] objectAtIndex:i] objectForKey:@"project_intro"]];
                projectStationDesLabel.textColor = [UIColor colorWithRed:67.0f/255.0f green:67.0f/255.0f blue:67.0f/255.0f alpha:1.0];
                projectStationDesLabel.numberOfLines = 0;
                projectStationDesLabel.frame=CGRectMake(15, projectStationLabel.frame.origin.y+projectStationLabel.frame.size.height, self.view.frame.size.width-30, 40);
                projectStationDesLabel.font=[UIFont systemFontOfSize:12.5];
                projectStationDesLabel.backgroundColor=[UIColor clearColor];
                [self.myScrollView addSubview:projectStationDesLabel];
            }
        }
        
        
        
        //************项目经历end**********************
        
        self.myScrollView.contentSize = CGSizeMake(self.view.frame.size.width, occupationLabel.frame.origin.y+occupationLabel.frame.size.height+142*[[_otherResumeDictionary objectForKey:@"occupation"] count]+83*[[_otherResumeDictionary objectForKey:@"education"] count]+142*[[_otherResumeDictionary objectForKey:@"project"] count]+65+64);
        
}


- (void)clickinstationButton
{
    
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
