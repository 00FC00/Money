//
//  SendWallContectNextViewController.m
//  FaceBook
//
//  Created by fengshaohui on 14-5-20.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "SendWallContectNextViewController.h"
#import "BCHTTPRequest.h"
#import "DMCAlertCenter.h"
#import "CheckSendDirectionViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GoldcoinsViewController.h"

@interface SendWallContectNextViewController ()
{
    //公共墙
    UIButton *publicWallButton;
    //定向发布
    UIButton *orientationSendButton;
    //下一步
    UIButton *finishButton;
}
@end

@implementation SendWallContectNextViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _wallInformationDic = [[NSMutableDictionary alloc] initWithCapacity:100];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"发布的强内容字典%@",self.wallInformationDic);
    
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
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;

    //公共墙publicWallButton;
    publicWallButton = [UIButton buttonWithType:UIButtonTypeCustom];
    publicWallButton.frame = CGRectMake(52/2, 16/2, 550/2, 70/2);
    [publicWallButton setBackgroundColor:[UIColor clearColor]];
    
    [publicWallButton setBackgroundImage:[UIImage imageNamed:@"yewuqiang2@2x"] forState:UIControlStateNormal];
    
    [publicWallButton setBackgroundImage:[UIImage imageNamed:@"yewuqiang2@2x"] forState:UIControlStateHighlighted];
    publicWallButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [publicWallButton setTitleColor:[UIColor colorWithRed:119.0f/255.0f green:153.0f/255.0f blue:208.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [publicWallButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
    publicWallButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft ;
    [publicWallButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 21, 0, 0)];
    [publicWallButton setTitle:@"公共墙" forState:UIControlStateNormal];
    publicWallButton.tag = 100;
    [publicWallButton addTarget:self action:@selector(clickpublicWallButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:publicWallButton];

    //定向发布orientationSendButton;
    orientationSendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    orientationSendButton.frame = CGRectMake(52/2, 86/2, 550/2, 70/2);
    [orientationSendButton setBackgroundColor:[UIColor clearColor]];
    [orientationSendButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [orientationSendButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
    orientationSendButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [orientationSendButton setTitleColor:[UIColor colorWithRed:119.0f/255.0f green:153.0f/255.0f blue:208.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [orientationSendButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
    orientationSendButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft ;
    [orientationSendButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 21, 0, 0)];
    [orientationSendButton setTitle:@"定向发布" forState:UIControlStateNormal];
    orientationSendButton.tag = 200;
    [orientationSendButton addTarget:self action:@selector(clickOrientationSendButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:orientationSendButton];

    //下一步finishButton;
    finishButton=[UIButton buttonWithType:UIButtonTypeCustom];
    finishButton.frame=CGRectMake(28/2, 222/2, 580/2, 72/2);
    [finishButton setBackgroundImage:[UIImage imageNamed:@"querengoumai@2x"] forState:UIControlStateNormal];
    [finishButton setTitle:@"发布" forState:UIControlStateNormal];
    [finishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    finishButton.titleLabel.font=[UIFont systemFontOfSize:16];
    finishButton.userInteractionEnabled=YES;
    [finishButton addTarget:self action:@selector(clickFinishButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:finishButton];
    
}
- (void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 公共墙
- (void)clickpublicWallButton:(UIButton *)button
{
    if (button.tag == 100) {
        
        //yewuqiang1@2x
        [publicWallButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [publicWallButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
        publicWallButton.tag = 101;
        
        if (orientationSendButton.tag == 201) {
            [finishButton setTitle:@"下一步" forState:UIControlStateNormal];
        }else
        {
            [finishButton setTitle:@"发布" forState:UIControlStateNormal];
        }
        
    }else
    {
        [publicWallButton setBackgroundImage:[UIImage imageNamed:@"yewuqiang2@2x"] forState:UIControlStateNormal];
        [publicWallButton setBackgroundImage:[UIImage imageNamed:@"yewuqiang2@2x"] forState:UIControlStateHighlighted];
        publicWallButton.tag = 100;
        
        if (orientationSendButton.tag == 201) {
            [finishButton setTitle:@"下一步" forState:UIControlStateNormal];
        }else
        {
            [finishButton setTitle:@"发布" forState:UIControlStateNormal];
        }
    }
    
    
}
#pragma mark - 定向发布
- (void)clickOrientationSendButton:(UIButton *)button
{
    if (button.tag == 200) {
        [orientationSendButton setBackgroundImage:[UIImage imageNamed:@"yewuqiang2@2x"] forState:UIControlStateNormal];
        [orientationSendButton setBackgroundImage:[UIImage imageNamed:@"yewuqiang2@2x"] forState:UIControlStateHighlighted];
        [finishButton setTitle:@"下一步" forState:UIControlStateNormal];
        orientationSendButton.tag = 201;
    }else
    {
        //yewuqiang1@2x
        [orientationSendButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [orientationSendButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
        [finishButton setTitle:@"发布" forState:UIControlStateNormal];
        orientationSendButton.tag = 200;
    }
    
    
}
#pragma mark - 下一步
- (void)clickFinishButton
{
    if (publicWallButton.tag == 101 && orientationSendButton.tag == 200) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"请选择发布方式"];
    }else if ([finishButton.titleLabel.text isEqualToString:@"发布"]) {
        
//        bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//        bgScrollView.backgroundColor = [UIColor colorWithRed:.0f/255.0f green:.0f/255.0f blue:.0f/255.0f alpha:0.8];
//        [self.view addSubview:bgScrollView];
//        
//        alertView = [[UIView alloc] initWithFrame:CGRectMake(81/2, (self.view.frame.size.height-729/2)/2+64/2, 481/2, 320/2)];
//        alertView.backgroundColor = [UIColor colorWithRed:241.0f/255.0f green:241.0f/255.0f blue:241.0f/255.0f alpha:1];
//        alertView.layer.cornerRadius = 3;
//        [alertView.layer setMasksToBounds:YES];
//        alertView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.7, 0.7);
//        [bgScrollView addSubview:alertView];
//        
//        UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(30/2, 26/2, 424/2, 40/2)];
//        //totalLabel.text = @"发布该业务总需花费20000金币";
//        totalLabel.textColor = [UIColor colorWithRed:119.0f/255.0f green:153.0f/255.0f blue:208.0f/255.0f alpha:1];
//        totalLabel.font = [UIFont systemFontOfSize:15];
//        [alertView addSubview:totalLabel];
//        
//        UILabel *publicWallLabel = [[UILabel alloc] initWithFrame:CGRectMake(30/2, 26/2+40/2+16/2, 424/2, 40/2)];
//        //publicWallLabel.text = @"公共墙20000金币";
//        publicWallLabel.textColor = [UIColor colorWithRed:119.0f/255.0f green:153.0f/255.0f blue:208.0f/255.0f alpha:1];
//        publicWallLabel.font = [UIFont systemFontOfSize:15];
//        [alertView addSubview:publicWallLabel];
//        
////        UILabel *conditionWallLabel = [[UILabel alloc] initWithFrame:CGRectMake(30/2, 26/2+40/2+16/2+40/2+16/2, 424/2, 40/2)];
////        conditionWallLabel.text = @"定向发布20000金币";
////        conditionWallLabel.textColor = [UIColor colorWithRed:119.0f/255.0f green:153.0f/255.0f blue:208.0f/255.0f alpha:1];
////        conditionWallLabel.font = [UIFont systemFontOfSize:15];
////        [alertView addSubview:conditionWallLabel];
//        
//        UILabel *confirmLabel = [[UILabel alloc] initWithFrame:CGRectMake(30/2, 26/2+40/2+16/2+40/2+36/2, 424/2, 40/2)];
//        confirmLabel.text = @"请确认发布";
//        confirmLabel.textColor = [UIColor colorWithRed:119.0f/255.0f green:153.0f/255.0f blue:208.0f/255.0f alpha:1];
//        confirmLabel.font = [UIFont systemFontOfSize:15];
//        [alertView addSubview:confirmLabel];
//        
//        
//        //取消
//        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        cancelButton.frame = CGRectMake(30/2, 26/2+40/2+16/2+40/2+36/2+40/2+36/2, 165/2, 42/2);
//        [cancelButton setBackgroundImage:[UIImage imageNamed:@"yihouzaishuo@2x"] forState:UIControlStateNormal];
//        [cancelButton setTitle:@"以后再说" forState:UIControlStateNormal];
//        [cancelButton setTitleColor:[UIColor colorWithRed:135.0f/255.0f green:135.0f/255.0f blue:135.0f/255.0f alpha:1] forState:UIControlStateNormal];
//        [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
//        [cancelButton addTarget:self action:@selector(clickCancelButton) forControlEvents:UIControlEventTouchUpInside];
//        [alertView addSubview:cancelButton];
//        
//        //确定
//        UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        confirmButton.frame = CGRectMake(481/2-30/2-165/2, 26/2+40/2+16/2+40/2+36/2+40/2+36/2, 165/2, 42/2);
//        [confirmButton setBackgroundImage:[UIImage imageNamed:@"fabuqiangqueding@2x"] forState:UIControlStateNormal];
//        [confirmButton setTitle:@"确定发布" forState:UIControlStateNormal];
//        [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [confirmButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
//        [confirmButton addTarget:self action:@selector(clickConfirmButton) forControlEvents:UIControlEventTouchUpInside];
//        [alertView addSubview:confirmButton];
        
        
        [BCHTTPRequest getBusinessGoldsWithUsingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
//                publicWallLabel.text = [NSString stringWithFormat:@"公共墙%@金币",resultDic[@"public_gold"]];
//                totalLabel.text = [NSString stringWithFormat:@"发布该业务总需花费%@金币",resultDic[@"public_gold"]];
                NSString *payGold = [NSString stringWithFormat:@"发布该业务总需花费%@金币",resultDic[@"public_gold"]];
                UIAlertView *alertView = [[UIAlertView alloc ] initWithTitle:@"业务发布" message:payGold delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                alertView.tag = 6000;
                [alertView show];

            }
        }];
        
        
//        [UIView animateWithDuration:0.2 animations:^{
//            alertView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0f, 1.0f);
//        } completion:^(BOOL finished) {
//            
//        }];

        
    }else if ([finishButton.titleLabel.text isEqualToString:@"下一步"])
    {
        CheckSendDirectionViewController *checkSendDirectionViewController = [[CheckSendDirectionViewController alloc] init];
        
        if (publicWallButton.tag == 100) {
            [_wallInformationDic setValue:@"1" forKey:@"is_public"];
        }else
        {
            [_wallInformationDic setValue:@"1" forKey:@"is_public"];
        }
        
        checkSendDirectionViewController.wallInformationDic = _wallInformationDic;
        [self.navigationController pushViewController:checkSendDirectionViewController animated:YES];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        ;
    }else
    {
        if (alertView.tag == 6000) {
            [BCHTTPRequest businessSetActionWithTitle:_wallInformationDic[@"title"] WithContent:_wallInformationDic[@"content"] WithDepartment_ids:@"" WithType_id:_wallInformationDic[@"typeId"] WithNick_name:_wallInformationDic[@"identity"] WithIs_public:@"1" usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
                if (isSuccess == YES) {
                    if ([resultDic[@"state"] intValue] == 1) {
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }else if ([resultDic[@"state"] intValue] == 2) {
                        [self myAlert];
                    }

                }
            }];

        }else if (alertView.tag == 7000) {
            GoldcoinsViewController *goldcoinsViewController = [[GoldcoinsViewController alloc] init];
            [self.navigationController pushViewController:goldcoinsViewController animated:YES];
        }
        
    }
}
- (void)myAlert
{
    UIAlertView *calertView  = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的金币不足，是否前往充值？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    calertView.tag = 7000;
    [calertView show];
}

//#pragma mark - 取消按钮
//- (void)clickCancelButton
//{
//    alertView.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.7, 0.7);
//    [bgScrollView removeFromSuperview];
//}

//#pragma mark - 确定
//- (void)clickConfirmButton
//{
//    [BCHTTPRequest businessSetActionWithTitle:_wallInformationDic[@"title"] WithContent:_wallInformationDic[@"content"] WithDepartment_ids:@"" WithType_id:_wallInformationDic[@"typeId"] WithNick_name:_wallInformationDic[@"identity"] WithIs_public:@"1" usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
//        if (isSuccess == YES) {
//            [self.navigationController popToRootViewControllerAnimated:YES];
//        }
//    }];
//}

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
