//
//  SendWallContectViewController.m
//  FaceBook
//
//  Created by fengshaohui on 14-5-20.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "SendWallContectViewController.h"
#import "CheckPostConditionViewController.h"
#import "SendWallContectNextViewController.h"

#import "BCHTTPRequest.h"
#import "DMCAlertCenter.h"


@interface SendWallContectViewController ()
{
    //背景
    UIScrollView *backScrollView;
    //标题
    UITextField *titleField;
    //内容
    UITextView *contectView;
    //类型
    UIButton *styleButton;
    //身份
    UIButton *identityButton;
    //下一步
    UIButton *nextButton;
    
    NSMutableDictionary *wallInformationDic;
    
    NSString *typeIdString;
}
@end

@implementation SendWallContectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        wallInformationDic = [[NSMutableDictionary alloc] initWithCapacity:100];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:246.0f/255.0f green:247.0f/255.0f blue:249.0f/255.0f alpha:1];
    
    if (IS_IOS_7) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios7"] forBarMetrics:UIBarMetricsDefault];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios6"] forBarMetrics:UIBarMetricsDefault];
    }
    self.title = @"发布业务墙";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 22, 40, 40);
    [backButton setBackgroundImage:[UIImage imageNamed:@"login_backButton@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //[self.navigationController.view addSubview:backButton];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;
    
    //背景
    backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-64)];
    backScrollView.backgroundColor = [UIColor clearColor];
    backScrollView.delegate = self;
    backScrollView.showsHorizontalScrollIndicator = NO;
    [backScrollView setContentSize:CGSizeMake(0, [[UIScreen mainScreen] bounds].size.height)];
    backScrollView.userInteractionEnabled = YES;
    [self.view addSubview:backScrollView];
    
    //标题titleField;
    UILabel *markTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 30, 44, 36/2)];
    markTitleLabel.backgroundColor = [UIColor clearColor];
    markTitleLabel.textAlignment = NSTextAlignmentLeft;
    markTitleLabel.textColor = [UIColor blackColor];
    markTitleLabel.font = [UIFont systemFontOfSize:15];
    markTitleLabel.text = @"标题:";
    [backScrollView addSubview:markTitleLabel];
    
    titleField = [[UITextField alloc]initWithFrame:CGRectMake(64, 30, 486/2, 36/2)];
    titleField.backgroundColor = [UIColor clearColor];
    titleField.textColor = [UIColor blackColor];
    titleField.font = [UIFont systemFontOfSize:15];
    titleField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [backScrollView addSubview:titleField];
    
    UIImageView *_lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 106/2, 600/2, 1)];
    _lineImageView.backgroundColor = [UIColor clearColor];
    [_lineImageView setImage:[UIImage imageNamed:@"xiahuaxian@2x"]];
    [backScrollView addSubview:_lineImageView];

    //内容contectView;
    UILabel *markContectLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 75, 44, 36/2)];
    markContectLabel.backgroundColor = [UIColor clearColor];
    markContectLabel.textAlignment = NSTextAlignmentLeft;
    markContectLabel.textColor = [UIColor grayColor];
    markContectLabel.font = [UIFont systemFontOfSize:15];
    markContectLabel.text = @"内容:";
    [backScrollView addSubview:markContectLabel];
    
    UIImageView *contectImageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 100, 591/2, 300/2)];
    contectImageView.backgroundColor = [UIColor clearColor];
    [contectImageView setImage:[UIImage imageNamed:@"qiangneirong@2x"]];
    contectImageView.userInteractionEnabled = YES;
    [backScrollView addSubview:contectImageView];
    
    contectView = [[UITextView alloc]initWithFrame:CGRectMake(5, 0, 581/2, 300/2)];
    contectView.backgroundColor = [UIColor clearColor];
    contectView.textAlignment = NSTextAlignmentLeft;
    contectView.textColor = [UIColor blackColor];
    contectView.font = [UIFont systemFontOfSize:16];
    [contectImageView addSubview:contectView];
    
    //类型styleButton;
    UILabel *markStyleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 534/2, 44, 36/2)];
    markStyleLabel.backgroundColor = [UIColor clearColor];
    markStyleLabel.textAlignment = NSTextAlignmentLeft;
    markStyleLabel.textColor = [UIColor grayColor];
    markStyleLabel.font = [UIFont systemFontOfSize:15];
    markStyleLabel.text = @"类型:";
    [backScrollView addSubview:markStyleLabel];

    UIImageView *lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 580/2, 600/2, 1)];
    lineImageView.backgroundColor = [UIColor clearColor];
    [lineImageView setImage:[UIImage imageNamed:@"xiahuaxian@2x"]];
    [backScrollView addSubview:lineImageView];
    
    styleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    styleButton.frame = CGRectMake(124/2, 514/2, 492/2, 64/2);
    [styleButton setBackgroundColor:[UIColor clearColor]];
    [styleButton setBackgroundImage:[UIImage imageNamed:@"anniujiantou@2x"] forState:UIControlStateNormal];
    styleButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [styleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [styleButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
    styleButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft ;
    [styleButton setTitleEdgeInsets:UIEdgeInsetsMake(7, 5, 0, 0)];
    [styleButton addTarget:self action:@selector(clickStyleButton) forControlEvents:UIControlEventTouchUpInside];
    [backScrollView addSubview:styleButton];
    
    //身份identityButton;
    UILabel *markIdentityLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 636/2, 44, 36/2)];
    markIdentityLabel.backgroundColor = [UIColor clearColor];
    markIdentityLabel.textAlignment = NSTextAlignmentLeft;
    markIdentityLabel.textColor = [UIColor grayColor];
    markIdentityLabel.font = [UIFont systemFontOfSize:15];
    markIdentityLabel.text = @"身份:";
    [backScrollView addSubview:markIdentityLabel];
    
    UIImageView *linesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 678/2, 600/2, 1)];
    linesImageView.backgroundColor = [UIColor clearColor];
    [linesImageView setImage:[UIImage imageNamed:@"xiahuaxian@2x"]];
    [backScrollView addSubview:linesImageView];

    identityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    identityButton.frame = CGRectMake(124/2, 612/2, 492/2, 64/2);
    [identityButton setBackgroundColor:[UIColor clearColor]];
    [identityButton setBackgroundImage:[UIImage imageNamed:@"anniujiantou@2x"] forState:UIControlStateNormal];
    identityButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [identityButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [identityButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
    identityButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft ;
    [identityButton setTitleEdgeInsets:UIEdgeInsetsMake(10, 5, 0, 0)];
    [identityButton addTarget:self action:@selector(clickidentityButton) forControlEvents:UIControlEventTouchUpInside];
    [backScrollView addSubview:identityButton];
    
    //下一步nextButton;
    nextButton=[UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame=CGRectMake(28/2, 744/2, 580/2, 72/2);
    [nextButton setBackgroundImage:[UIImage imageNamed:@"querengoumai@2x"] forState:UIControlStateNormal];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextButton.titleLabel.font=[UIFont systemFontOfSize:16];
    //nextButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    //[myBuyButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 130)];
    nextButton.userInteractionEnabled=YES;
    [nextButton addTarget:self action:@selector(clicknextButton) forControlEvents:UIControlEventTouchUpInside];
    [backScrollView addSubview:nextButton];

    if ([_titleString isEqualToString:@"修改"]) {
        self.title = @"修改业务墙";
        markIdentityLabel.hidden = YES;
        linesImageView.hidden = YES;
        identityButton.hidden = YES;
        
        
        titleField.text = _wallDetailDic[@"title"];
        contectView.text = _wallDetailDic[@"content"];
        [styleButton setTitle:_wallDetailDic[@"type"] forState:UIControlStateNormal];
        typeIdString = _wallDetailDic[@"type_id"];
        
        
        
        [nextButton setFrame:CGRectMake(28/2, 664/2, 580/2, 72/2)];
        [nextButton setTitle:@"完成" forState:UIControlStateNormal];
    }
    
    
    //点击背景取消键盘
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(handleBackgroundTap:)];
    tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapRecognizer];
}
#pragma mark- 返回
- (void)backButtonClicked
{
//    [self dismissViewControllerAnimated:YES completion:^{
//        ;
//    }];
    
    [titleField resignFirstResponder];
    [contectView resignFirstResponder];

    if ([_titleString isEqualToString:@"修改"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}
//取消键盘
- (void) handleBackgroundTap:(UITapGestureRecognizer*)sender
{
    [titleField resignFirstResponder];
    [contectView resignFirstResponder];
    
}
#pragma mark - 选择类型
- (void)clickStyleButton
{
    NSLog(@"类型");
    CheckPostConditionViewController *checkPostConditionVC = [[CheckPostConditionViewController alloc]init];
    checkPostConditionVC.checkStr = @"style";
    checkPostConditionVC.delegate = self;
    checkPostConditionVC.mycellCheck = styleButton.titleLabel.text;
    [self.navigationController pushViewController:checkPostConditionVC animated:YES];
}
#pragma mark - 选择身份
- (void)clickidentityButton
{
    CheckPostConditionViewController *wcheckPostConditionVC = [[CheckPostConditionViewController alloc]init];
    wcheckPostConditionVC.checkStr = @"identity";
    wcheckPostConditionVC.delegate = self;
    wcheckPostConditionVC.mycellCheck = identityButton.titleLabel.text;
    [self.navigationController pushViewController:wcheckPostConditionVC animated:YES];
}
#pragma mark - 代理传值
- (void)setStyleValueWith:(NSDictionary *)styleDic
{
    typeIdString = styleDic[@"id"];
    [styleButton setTitle:styleDic[@"name"] forState:UIControlStateNormal];
}
- (void)setIdentityValueWith:(NSString *)identityStr
{
    [identityButton setTitle:identityStr forState:UIControlStateNormal];
}
- (void)clicknextButton
{
    
    if ([_titleString isEqualToString:@"修改"]) {
        if ([titleField.text length] < 1) {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"请输入标题"];
        }else if ([contectView.text length] < 1) {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"请输入内容"];
        }else if ([styleButton.titleLabel.text isEqual:@""] || styleButton.titleLabel.text == nil) {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"请选择类型"];
        }else
        {
           
            [BCHTTPRequest businessEditActionWithTitle:titleField.text WithContent:contectView.text WithType_id:typeIdString WithAid:_wallDetailDic[@"id"] usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
                if (isSuccess == YES) {
                    [self.navigationController popViewControllerAnimated:YES];
                    
//                    SendWallContectNextViewController *sendWallContectNextVC = [[SendWallContectNextViewController alloc]init];
//                    sendWallContectNextVC.wallInformationDic = wallInformationDic;
//                    [self.navigationController pushViewController:sendWallContectNextVC animated:YES];
                }
            }];
        }
    }else
    {
        if ([titleField.text length] < 1) {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"请输入标题"];
        }else if ([contectView.text length] < 1) {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"请输入内容"];
        }else if ([styleButton.titleLabel.text isEqual:@""] || styleButton.titleLabel.text == nil) {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"请选择类型"];
        }else if ([identityButton.titleLabel.text isEqual:@""] || identityButton.titleLabel.text == nil) {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"请选择身份"];
        }else
        {
            
            [wallInformationDic setValue:titleField.text forKey:@"title"];
            [wallInformationDic setValue:contectView.text forKey:@"content"];
            [wallInformationDic setValue:typeIdString forKey:@"typeId"];
            [wallInformationDic setValue:identityButton.titleLabel.text forKey:@"identity"];
            
            [BCHTTPRequest businessCheckNumsWithUsingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
                if (isSuccess == YES) {
                    SendWallContectNextViewController *sendWallContectNextVC = [[SendWallContectNextViewController alloc]init];
                    sendWallContectNextVC.wallInformationDic = wallInformationDic;
                    [self.navigationController pushViewController:sendWallContectNextVC animated:YES];
                }
            }];
        }
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
