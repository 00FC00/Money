//
//  MySweepViewController.m
//  ContactGroup
//
//  Created by 蓝凌 on 14-5-13.
//  Copyright (c) 2014年 蓝凌. All rights reserved.
//

#import "MySweepViewController.h"
#import "MyIdentityAuthenticationViewController.h"

#import "AFNetworking.h"
#import "BCHTTPRequest.h"
#import "DMCAlertCenter.h"

#import "CMChatMainViewController.h"

#define ADDHEITH 83.0

@interface MySweepViewController ()
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

//加好友button
@property(nonatomic,strong)UIButton* addFriendButton;

//处理好友button
@property(nonatomic,strong)UIButton* blackListButton;
@property(nonatomic,strong)UIButton* chatButton;
@property(nonatomic,strong)UIButton* whiteListButton;




@end

@implementation MySweepViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    
    
    NSLog(@"--------friendid %@",_friendIdString);
    
    if ([_fromString isEqualToString:@"搜索"] || [_fromString isEqualToString:@"扫一扫"]) {
        //设置头视图
        [self setHeadView];
        //设置信息视图
        [self setInformationView];
    }else
    {
        [BCHTTPRequest getMyFriendInformationWithFID:_friendIdString usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
                _mySweepDictionary = resultDic;
                
                //设置头视图
                [self setHeadView];
                //设置信息视图
                [self setInformationView];
            }
        }];
        
        
        
        
    }
    
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
    self.nickName.text=[NSString stringWithFormat:@"昵称: %@",_mySweepDictionary[@"nickname_first"]];
    [self.myScrollView addSubview:self.nickName];
    //设置姓名
    self.trueName=[[UILabel alloc]initWithFrame:CGRectMake(115, 27+10+ADDHEITH, 180, 20)];
    self.trueName.font=[UIFont systemFontOfSize:16];
    self.trueName.textColor=[UIColor colorWithRed:98.0/255 green:98.0/255 blue:98.0/255 alpha:1.0];
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
    self.locationLabel.text=[NSString stringWithFormat:@"   %@",_mySweepDictionary[@"institution"]];
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
    //设置机构---更改为条线部门
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
    //设置部门---更改为地区
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
    
    
    //判断是否注册好友
    if ([_mySweepDictionary[@"type"] integerValue] == 1 ) {
        
        //添加到黑名单button的设置
        self.blackListButton=[[UIButton alloc]initWithFrame:CGRectMake(5, 215, 100, 25)];
        self.blackListButton.backgroundColor=[UIColor colorWithRed:21.0/255 green:96.0/255 blue:224.0/255 alpha:1.0];
        [self.blackListButton setTitle:@"添加到黑名单" forState:UIControlStateNormal];
        self.blackListButton.titleLabel.font=[UIFont boldSystemFontOfSize:14];
        //[self.blackListButton setBackgroundImage:[UIImage imageNamed:@"tianjiadaoheimingdan@2x"] forState:UIControlStateNormal];
        [self.blackListButton.layer setMasksToBounds:YES];
        [self.blackListButton.layer setCornerRadius:4.0f];
        [self.blackListButton addTarget:self action:@selector(addBlackList) forControlEvents:UIControlEventTouchUpInside];
        [self.myScrollView addSubview:self.blackListButton];
        
        //聊天button的设置
        self.chatButton=[[UIButton alloc]initWithFrame:CGRectMake(110, 215, 100, 25)];
        self.chatButton.backgroundColor=[UIColor colorWithRed:21.0/255 green:96.0/255 blue:224.0/255 alpha:1.0];
        [self.chatButton setTitle:@"聊天" forState:UIControlStateNormal];
        self.chatButton.titleLabel.font=[UIFont boldSystemFontOfSize:14];
        //[self.chatButton setBackgroundImage:[UIImage imageNamed:@"tianjiadaoheimingdan@2x"] forState:UIControlStateNormal];
        [self.chatButton.layer setMasksToBounds:YES];
        [self.chatButton.layer setCornerRadius:4.0f];
        [self.chatButton addTarget:self action:@selector(chat) forControlEvents:UIControlEventTouchUpInside];
        [self.myScrollView addSubview:self.chatButton];
        
        //认可身份button的设置
        self.whiteListButton=[[UIButton alloc]initWithFrame:CGRectMake(215, 215, 100, 25)];
        self.whiteListButton.backgroundColor=[UIColor colorWithRed:21.0/255 green:96.0/255 blue:224.0/255 alpha:1.0];
        //querengoumai@2x
        //[self.whiteListButton setBackgroundImage:[UIImage imageNamed:@"querengoumai@2x"] forState:UIControlStateNormal];
        [self.whiteListButton setTitle:@"我认可TA的身份" forState:UIControlStateNormal];
        self.whiteListButton.titleLabel.font=[UIFont boldSystemFontOfSize:13];
        [self.whiteListButton.layer setMasksToBounds:YES];
        [self.whiteListButton.layer setCornerRadius:4.0f];
        [self.whiteListButton addTarget:self action:@selector(addWhiteList) forControlEvents:UIControlEventTouchUpInside];
        [self.myScrollView addSubview:self.whiteListButton];
        
        
        if ([_mySweepDictionary[@"is_auth"] integerValue] == 1 ) {
            [self.whiteListButton setTitle:@"已认可TA的身份" forState:UIControlStateNormal];
            self.whiteListButton.userInteractionEnabled = NO;
        }
        
        self.myScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.whiteListButton.frame.origin.y+36+50+64/2);
        
        
        if ([_fromString isEqualToString:@"搜索"] || [_fromString isEqualToString:@"扫一扫"]) {
            self.blackListButton.hidden = YES;
            self.chatButton.hidden = YES;
            self.whiteListButton.hidden = YES;
            
            self.myScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
        }
        
        
        
    }else if ([_mySweepDictionary[@"type"] integerValue] == 2) {
        
        self.blackListButton.hidden = YES;
        self.chatButton.hidden = YES;
        self.whiteListButton.hidden = YES;
        
        self.myScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    }
    else{
       
        //添加好友button的设置
        self.addFriendButton=[[UIButton alloc]initWithFrame:CGRectMake(5, 215, 100, 25)];
        self.addFriendButton.backgroundColor=[UIColor colorWithRed:21.0/255 green:96.0/255 blue:224.0/255 alpha:1.0];
        [self.addFriendButton setTitle:@"加为好友" forState:UIControlStateNormal];
        self.addFriendButton.titleLabel.font=[UIFont boldSystemFontOfSize:14];
        //[self.addFriendButton setBackgroundImage:[UIImage imageNamed:@"querengoumai@2x"] forState:UIControlStateNormal];
        [self.myScrollView addSubview:self.addFriendButton];
        [self.addFriendButton.layer setMasksToBounds:YES];
        [self.addFriendButton.layer setCornerRadius:4.0f];
        [self.addFriendButton addTarget:self action:@selector(addFriend) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        if (i<4) {
            self.addFriendButton.frame=CGRectMake(5, 215, 100, 25);
            
            self.myScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.addFriendButton.frame.origin.y+36+30+64/2);
        }

    }
    
    
}


///设置个人简历
- (void)setPersonResumeInfomation
{
    NSLog(@"**********%@",_mySweepDictionary[@"type"]);
    
    //判断是否注册好友
    if ([_mySweepDictionary[@"type"] integerValue] == 1) {
        
        if ([_fromString isEqualToString:@"搜索"] || [_fromString isEqualToString:@"扫一扫"]) {
            [self setMainInfomationypx:ADDHEITH+120];
        }else {
            [self setMainInfomationypx:253.0];
        }
        
    }else if ([_mySweepDictionary[@"type"] integerValue] == 2){
        //没有按钮
        [self setMainInfomationypx:ADDHEITH+120];
    }
    else {
        [self setMainInfomationypx:253.0];
    }
}


- (void)setMainInfomationypx:(CGFloat)baseHeith
{
    
    NSLog(@"yyyyyyyyyyyyyyyyyyyy");
    //有按钮
    //个人信息字样lable
    UILabel * personLabel =[[UILabel alloc]init];
    personLabel.text=@"  个人信息";
    personLabel.textColor = [UIColor blackColor];
    personLabel.frame=CGRectMake(0, baseHeith, self.view.frame.size.width, 50);
    personLabel.font=[UIFont boldSystemFontOfSize:17];
    personLabel.layer.borderColor=[UIColor blackColor].CGColor;
    personLabel.layer.borderWidth=0.0f;
    personLabel.backgroundColor=[UIColor colorWithRed:201.0f/255.0f green:209.0f/255.0f blue:222.0f/255.0f alpha:1.0];
    [self.myScrollView addSubview:personLabel];
    
    //************职业经历**********************
    UILabel * occupationLabel =[[UILabel alloc]init];
    occupationLabel.text=@"  职业经历";
    occupationLabel.textColor = [UIColor colorWithRed:67.0f/255.0f green:67.0f/255.0f blue:67.0f/255.0f alpha:1.0];
    occupationLabel.frame=CGRectMake(0, baseHeith+personLabel.frame.size.height, self.view.frame.size.width, 23);
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

#pragma mark 添加好友事件
-(void)addFriend{
    
    if ([_fromString isEqualToString:@"新的好友"]) {
        //通过验证
        
        [BCHTTPRequest AgreeTheNewFriendsWithNewFriensdID:_friendIdString usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
                [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"添加成功"];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];

        
    }else if ([_fromString isEqualToString:@"赠送联系人"]) {
        //赠送联系人加为好友
        [BCHTTPRequest AddThePresentFriendsToInstationManWithFriendsID:_friendIdString usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
                
                [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"发送成功"];
                
            }
        }];

    }else if ([_fromString isEqualToString:@"群成员"]) {
        //好友类型 1：找老乡找好友时添加的，扫一扫、搜手机号、脸谱号 2：app其他途径加的好友3：手机通讯录4：从群中加好友------>[后来把4这个类型归2]
        [BCHTTPRequest AddTheNewFriendsWithFriendsID:_friendIdString WithFriendsType:@"2" WithGroupID:_groupIdString WithGroupType:_groupTypeString WithInforString:@"" usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
            }
        }];
         }else if ([_fromString isEqualToString:@"扫一扫"]) {
        //好友类型 1：找老乡找好友时添加的，扫一扫、搜手机号、脸谱号 2：app其他途径加的好友3：手机通讯录4：从群中加好友------>[后来把4这个类型归2]
        [BCHTTPRequest AddTheNewFriendsWithFriendsID:_friendIdString WithFriendsType:@"1" WithGroupID:@"" WithGroupType:@"" WithInforString:@"" usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
            }
        }];
    }
    else
    {
        //搜索里添加好友
        MyIdentityAuthenticationViewController *myIdentityAuthenticationVC = [[MyIdentityAuthenticationViewController alloc]init];
        myIdentityAuthenticationVC.friendIdString = _mySweepDictionary[@"id"];
        [self.navigationController pushViewController:myIdentityAuthenticationVC animated:YES];
    }
}
#pragma mark 添加到黑名单事件
-(void)addBlackList{
    [BCHTTPRequest addBlacklistWithFriendId:_friendIdString usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            self.blackListButton.userInteractionEnabled = NO;
        }
    }];
}
#pragma mark 聊天事件
-(void)chat{
    NSLog(@"chat");
    
    if ([self.fromString isEqualToString:@"聊天"] == YES) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
       
        NSString *myWhereType = [[NSString alloc]init];
        if ([self.groupTypeString isEqualToString:@"1"]) {
            myWhereType = @"3";
            [BCHTTPRequest BeforeTheInstitutionPrivateChatWithInstitutionID:self.groupIdString WithFriendID:_mySweepDictionary[@"fid"] usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
                if (isSuccess == YES) {
                    ;
                }
            }];
        }else if ([self.groupTypeString isEqualToString:@"2"]) {
            myWhereType = @"3";
            [BCHTTPRequest BeforeTheDepartmentPrivateChatWithDepartmentID:self.groupIdString WithFriendID:_mySweepDictionary[@"fid"] usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
                if (isSuccess == YES) {
                    ;
                }
            }];
        }else if ([self.groupTypeString isEqualToString:@"3"])
        {
            myWhereType = @"3";
            [BCHTTPRequest BeforeTheThemePrivateChatWithThemeID:self.groupIdString WithFriendID:_mySweepDictionary[@"fid"] usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
                if (isSuccess == YES) {
                    ;
                }
            }];
        }else if ([self.groupTypeString isEqualToString:@"4"])
        {
            myWhereType = @"3";
        }
        
        CMChatMainViewController *cMChatMainVC = [[CMChatMainViewController alloc]init];
        cMChatMainVC.toUserID = _mySweepDictionary[@"fid"];
        cMChatMainVC.toUserName = _mySweepDictionary[@"name"];
        cMChatMainVC.messageWhereTypes = myWhereType;
        cMChatMainVC.messageWhereIds = @"0";
        cMChatMainVC.toUserHeadLogo = _mySweepDictionary[@"pic"];
        cMChatMainVC.isGroupChat = NO;
        [self.navigationController pushViewController:cMChatMainVC animated:YES];
    }

}
#pragma mark 认可身份事件
-(void)addWhiteList{
    [BCHTTPRequest acceptRankWithFriendId:_friendIdString usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            [self.whiteListButton setTitle:@"已认可TA的身份" forState:UIControlStateNormal];
            self.whiteListButton.userInteractionEnabled = NO;
        }
    }];
    
}

@end
