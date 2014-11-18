//
//  MessageListDetialsViewController.m
//  FaceBook
//
//  Created by fengshaohui on 14-8-4.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "MessageListDetialsViewController.h"
#import "BCHTTPRequest.h"
#import "AFNetworking.h"
#import "GlobalVariable.h"
#import "DMCAlertCenter.h"

@interface MessageListDetialsViewController ()
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

@end

@implementation MessageListDetialsViewController

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
    self.title = @"详细资料";
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
            
                [self justDoit];
            
        }
    }];

}
- (void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setHeadView{
    //设置头像
    self.photoImgaeView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 65, 65)];
    self.photoImgaeView.backgroundColor=[UIColor lightGrayColor];
    [self.photoImgaeView.layer setMasksToBounds:YES];
    [self.photoImgaeView.layer setCornerRadius:3.0f];
    [self.photoImgaeView setImageWithURL:[NSURL URLWithString:_mySweepDictionary[@"pic"]] placeholderImage:[UIImage imageNamed:@"ceshi@2x"]];
    [self.myScrollView addSubview:self.photoImgaeView];
    
    //设置昵称
    self.nickName=[[UILabel alloc]initWithFrame:CGRectMake(85, 7, 180, 20)];
    self.nickName.backgroundColor=[UIColor clearColor];
    self.nickName.font=[UIFont systemFontOfSize:16];
    [self.nickName setTextAlignment:NSTextAlignmentLeft];
    self.nickName.text=[NSString stringWithFormat:@"昵称:%@",_mySweepDictionary[@"nickname_first"]];
    [self.myScrollView addSubview:self.nickName];
    //设置姓名
    self.trueName=[[UILabel alloc]initWithFrame:CGRectMake(85, 27, 180, 15)];
    self.trueName.font=[UIFont systemFontOfSize:14];
    self.trueName.textColor=[UIColor lightGrayColor];
    self.trueName.backgroundColor=[UIColor clearColor];
    self.trueName.text=[NSString stringWithFormat:@"真实姓名: %@",_mySweepDictionary[@"name"]];
    [self.myScrollView addSubview:self.trueName];
    
    //设置脸谱号
    self.faceNumber=[[UILabel alloc]initWithFrame:CGRectMake(85, 27+15+2, 180, 15)];
    self.faceNumber.font=[UIFont systemFontOfSize:14];
    self.faceNumber.textColor=[UIColor lightGrayColor];
    self.faceNumber.backgroundColor=[UIColor clearColor];
    self.faceNumber.text=[NSString stringWithFormat:@"脸谱号: %@",_mySweepDictionary[@"lp_sn"]];
    [self.myScrollView addSubview:self.faceNumber];
    
    //设置认可身份
    self.identifyLabel=[[UILabel alloc]initWithFrame:CGRectMake(85, 57+2+2, 180, 15)];
    
    self.identifyLabel.font=[UIFont systemFontOfSize:14];
    self.identifyLabel.textColor=[UIColor lightGrayColor];
    self.identifyLabel.backgroundColor=[UIColor clearColor];
    self.identifyLabel.text=[NSString stringWithFormat:@"%@人已认可TA的身份",_mySweepDictionary[@"accept_number"]];
    [self.myScrollView addSubview:self.identifyLabel];
}
-(void)setInformationView{
    
    int i=0;
    //设置地区
    self.locationLabel=[[UILabel alloc]init];
    self.locationLabel.text=[NSString stringWithFormat:@"  地区: %@ %@",_mySweepDictionary[@"work_city"],_mySweepDictionary[@"work_area"]];
    
    if (self.locationLabel.text.length>0) {
        self.locationLabel.frame=CGRectMake(10, 95, 300, 33);
        self.locationLabel.font=[UIFont systemFontOfSize:15];
        self.locationLabel.layer.borderColor=[UIColor colorWithRed:232.0f/255.0f green:233.0f/255.0f blue:232.0f/255.0f alpha:1.0].CGColor;
        self.locationLabel.layer.borderWidth=0.5f;
        self.locationLabel.backgroundColor=[UIColor whiteColor];
        [self.myScrollView addSubview:self.locationLabel];
        i++;
    }
    //设置机构
    self.institutionLabel=[[UILabel alloc]init];
    self.institutionLabel.text=[NSString stringWithFormat:@"  机构: %@",_mySweepDictionary[@"institution"]];
    if (self.institutionLabel.text.length>0) {
        self.institutionLabel.frame=CGRectMake(10, 95+i*33, 300, 33);
        self.institutionLabel.font=[UIFont systemFontOfSize:15];
        self.institutionLabel.layer.borderColor=[UIColor colorWithRed:232.0f/255.0f green:233.0f/255.0f blue:232.0f/255.0f alpha:1.0].CGColor;
        self.institutionLabel.layer.borderWidth=0.5f;
        self.institutionLabel.backgroundColor=[UIColor whiteColor];
        [self.myScrollView addSubview:self.institutionLabel];
        i++;
    }
    //设置部门
    self.departmentLabel=[[UILabel alloc]init];
    self.departmentLabel.text=[NSString stringWithFormat:@"  部门: %@",_mySweepDictionary[@"department"]];
    if (self.departmentLabel.text.length>0) {
        self.departmentLabel.frame=CGRectMake(10, 95+i*33, 300, 33);
        self.departmentLabel.font=[UIFont systemFontOfSize:15];
        self.departmentLabel.layer.borderColor=[UIColor colorWithRed:232.0f/255.0f green:233.0f/255.0f blue:232.0f/255.0f alpha:1.0].CGColor;
        self.departmentLabel.layer.borderWidth=0.5f;
        self.departmentLabel.backgroundColor=[UIColor whiteColor];
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
- (void)justDoit
{
    ///标题
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 470/2, 300, 33)];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.textColor = [UIColor darkGrayColor];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.text = @"验证信息:";
    [_myScrollView addSubview:_titleLabel];
    
    ///验证信息
    _commentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _commentLabel.backgroundColor = [UIColor clearColor];
    _commentLabel.font = [UIFont systemFontOfSize:15];
    _commentLabel.textAlignment = NSTextAlignmentLeft;
    _commentLabel.textColor = [UIColor blackColor];
    _commentLabel.numberOfLines = 0;
    NSString *str1 = self.isComment;
    CGSize size1;
    //***********ios7的方法
    if (IS_IOS_7)
    {
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:15]};
        size1 = [str1 boundingRectWithSize:CGSizeMake(600/2, 1000) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    }else
    {
        //***********ios6的方法
        size1 = [str1 sizeWithFont:[UIFont systemFontOfSize:15]constrainedToSize:CGSizeMake(492/2,1000) lineBreakMode:NSLineBreakByWordWrapping];
    }
    _commentLabel.frame = CGRectMake(10, 536/2, 600/2, size1.height);
    _commentLabel.text = str1;
    [_myScrollView addSubview:_commentLabel];
    
    ///同事
    self.sureButton=[[UIButton alloc]initWithFrame:CGRectMake(20,_commentLabel.frame.origin.y+_commentLabel.frame.size.height+5, 280, 36)];
    self.sureButton.backgroundColor=[UIColor clearColor];
    [self.sureButton setTitle:@"同意" forState:UIControlStateNormal];
    self.sureButton.titleLabel.font=[UIFont systemFontOfSize:17];
    [self.sureButton setBackgroundImage:[UIImage imageNamed:@"querengoumai@2x"] forState:UIControlStateNormal];
    self.sureButton.tag = 6000;
    [self.sureButton addTarget:self action:@selector(clickSureButton) forControlEvents:UIControlEventTouchUpInside];
    [self.myScrollView addSubview:self.sureButton];
    
    ///领导
    self.cancleButton=[[UIButton alloc]initWithFrame:CGRectMake(20, _sureButton.frame.origin.y+_sureButton.frame.size.height+5, 280, 36)];
    self.cancleButton.backgroundColor=[UIColor clearColor];
    [self.cancleButton setTitle:@"拒绝" forState:UIControlStateNormal];
    self.cancleButton.titleLabel.font=[UIFont systemFontOfSize:17];
    [self.cancleButton setBackgroundImage:[UIImage imageNamed:@"tianjiadaoheimingdan@2x"] forState:UIControlStateNormal];
    self.cancleButton.tag = 7000;
    [self.cancleButton addTarget:self action:@selector(clickCancleButton) forControlEvents:UIControlEventTouchUpInside];
    [self.myScrollView addSubview:self.cancleButton];
    
}
#pragma mark - 确认关系
- (void)clickSureButton
{
    
    if ([_dic[@"type"] integerValue]==1) {
        NSLog(@"确认关系 ");
        [BCHTTPRequest PassTheConfirmationRelationshipsWithMessageID:_dic[@"id"] usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
               [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"添加成功"];
            }
        }];
    }else if ([_dic[@"type"] integerValue]==2)
    {
        NSLog(@"发布人批准参加活动，是否参加");
        //1.74接口
        [BCHTTPRequest AgreeJoinThePartyWithFid:_dic[@"fid"] WithRelation:_dic[@"relation"] usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
                ;
            }
        }];
        
    }else if ([_dic[@"type"] integerValue]==3)
    {
        NSLog(@"发布人收到活动申请");
        //1.73
        [BCHTTPRequest CreaterAgreeOtherPeopleJoinThePartyFid:_dic[@"fid"] WithRelation:_dic[@"relation"] usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
                ;
            }
        }];
    }else if ([_dic[@"type"] integerValue]==4)
    {
        NSLog(@"申请创建的主题群");
        //4.32
        [BCHTTPRequest PassTheJoinApplicationOfGroupWithMessageID:_dic[@"id"] usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
                ;
            }
        }];
    }else if ([_dic[@"type"] integerValue]==5)
    {
        NSLog(@"参加活动人确认参加活动");
    }else if ([_dic[@"type"] integerValue]==6)
    {
        NSLog(@"发布人拒绝活动申请");
    }else if ([_dic[@"type"] integerValue]==7)
    {
        NSLog(@"拒绝好友申请");
    }else if ([_dic[@"type"] integerValue]==8)
    {
        NSLog(@"成为好友");
    }else if ([_dic[@"type"] integerValue]==9)
    {
        NSLog(@"xx申请加好友");
        //1.77
        [BCHTTPRequest AgreeTheOthersAddMeFriendsWithFid:_dic[@"fid"] usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
                ;
            }
        }];
    }else if ([_dic[@"type"] integerValue]==10)
    {
        NSLog(@"参加活动人拒绝活动申请");
    }else if ([_dic[@"type"] integerValue]==11)
    {
        NSLog(@"活动人删除活动");
    }else if ([_dic[@"type"] integerValue]==12)
    {
        NSLog(@"VIP申请失败");
    }else if ([_dic[@"type"] integerValue]==13)
    {
        NSLog(@"VIP申请成功");
    }

}
#pragma mark - 拒绝关系
- (void)clickCancleButton
{
    if ([_dic[@"type"] integerValue]==1) {
        NSLog(@"拒绝关系 ");
        [BCHTTPRequest RefusedTheConfirmationRelationshipsWithMessageID:_dic[@"id"] usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
                ;
            }
        }];
    }else if ([_dic[@"type"] integerValue]==2)
    {
        NSLog(@"发布人批准参加活动，是否参加");
        //1.76接口
        [BCHTTPRequest RefusedJoinThePartyWithFid:_dic[@"fid"] WithRelation:_dic[@"ralation"] usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
                ;
            }
        }];
        
    }else if ([_dic[@"type"] integerValue]==3)
    {
        NSLog(@"发布人收到活动申请");
        //1.75
        [BCHTTPRequest CreaterRefusedOtherPeopleJoinThePartyFid:_dic[@"fid"] WithRelation:_dic[@"ralation"] usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
                ;
            }
        }];
    }else if ([_dic[@"type"] integerValue]==4)
    {
        NSLog(@"申请创建的主题群");
        //4.42
        [BCHTTPRequest RefusedTheJoinApplicationOfGroupWithMessageID:_dic[@"id"] usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
                ;
            }
        }];
    }else if ([_dic[@"type"] integerValue]==5)
    {
        NSLog(@"参加活动人确认参加活动");
    }else if ([_dic[@"type"] integerValue]==6)
    {
        NSLog(@"发布人拒绝活动申请");
    }else if ([_dic[@"type"] integerValue]==7)
    {
        NSLog(@"拒绝好友申请");
    }else if ([_dic[@"type"] integerValue]==8)
    {
        NSLog(@"成为好友");
    }else if ([_dic[@"type"] integerValue]==9)
    {
        NSLog(@"xx申请加好友");
        //1.72
        [BCHTTPRequest RefusedTheOthersAddMeFriendsWithFid:_dic[@"fid"] usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
                ;
            }
        }];
    }else if ([_dic[@"type"] integerValue]==10)
    {
        NSLog(@"参加活动人拒绝活动申请");
    }else if ([_dic[@"type"] integerValue]==11)
    {
        NSLog(@"活动人删除活动");
    }else if ([_dic[@"type"] integerValue]==12)
    {
        NSLog(@"VIP申请失败");
    }else if ([_dic[@"type"] integerValue]==13)
    {
        NSLog(@"VIP申请成功");
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
