//
//  UpgradeVIPViewController.m
//  FaceBook
//
//  Created by HMN on 14-4-29.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "UpgradeVIPViewController.h"
#import "SUNViewController.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"

#import "AppDelegate.h"
#import "GoldcoinsViewController.h"

#import "BCHTTPRequest.h"
#import "OtherNotice.h"
#import "OtherNoticeObject.h"

@interface UpgradeVIPViewController ()
{
    CGSize size;
    CGSize size1;
    UIImageView *cardImageView;
    
    //半年
    UIButton *halfYearButton;
    //一年
    UIButton *oneYearButton;
    
    //确认购买
    UIButton *myBuyButton;
    
    OtherNotice *otherNotice;
    OtherNoticeObject *otherObj;
    
    NSString *isPaids;

}
@end

@implementation UpgradeVIPViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        cardIdString = @"";
        goldString = @"";
        isPaids = [[NSString alloc]init];
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
    self.title = @"升级为VIP";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 22, 40, 40);
    if ([self.isMenu isEqualToString:@"yes"]) {
        [backButton setBackgroundImage:[UIImage imageNamed:@"caidan@2x"] forState:UIControlStateNormal];
    }else{
        [backButton setBackgroundImage:[UIImage imageNamed:@"login_backButton@2x"] forState:UIControlStateNormal];
    }
    //if ([self.isSetting isEqualToString:@"yes"]) {
    
//    }else
//    {
//        [backButton setBackgroundImage:[UIImage imageNamed:@"caidan@2x"] forState:UIControlStateNormal];
//    }
    
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //[self.navigationController.view addSubview:backButton];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;
    
    //充值
    UIButton *_Button = [UIButton buttonWithType:UIButtonTypeCustom];
    _Button.frame = CGRectMake(526/2, 22, 84/2, 42/2);
    [_Button setBackgroundImage:[UIImage imageNamed:@"login_RegistrationButton_03@2x"] forState:UIControlStateNormal];
    [_Button setTitle:@"充值" forState:UIControlStateNormal];
    _Button.titleLabel.font = [UIFont systemFontOfSize:15];
    [_Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_Button addTarget:self action:@selector(ButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:_Button];
    self.navigationItem.rightBarButtonItem=rightbuttonitem;

    otherNotice = [[OtherNotice alloc]init];
    [otherNotice createDataBase];
    
    otherObj = [otherNotice getAllOthersRemindStyleWithNumber:@"1"];
    //文案
    UILabel *addressLabel = [[UILabel alloc]init];
    addressLabel.backgroundColor = [UIColor clearColor];
    addressLabel.font = [UIFont systemFontOfSize:14];
    addressLabel.textAlignment = NSTextAlignmentLeft;
    addressLabel.textColor = [UIColor colorWithRed:181.0f/255.0f green:201.0f/255.0f blue:237.0f/255.0f alpha:1.0];
    addressLabel.numberOfLines = 0;
    NSString *str = @"金融部落提供VIP申请服务，您可以上传名片申请VIP，金融部落运营团队具有最终审核权";
    
    //***********ios7的方法
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7)
    {
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
        size = [str boundingRectWithSize:CGSizeMake(302, 36) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    }else
    {
        //***********ios6的方法
        size = [str sizeWithFont:[UIFont systemFontOfSize:14]constrainedToSize:CGSizeMake(302,36) lineBreakMode:NSLineBreakByWordWrapping];
    }
    //********************
    addressLabel.frame =CGRectMake(7,9, 302, size.height);
    addressLabel.text = str;
    [self.view addSubview:addressLabel];
    
    //上传名片
    UILabel *marksLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 98/2, 104, 17)];
    marksLabel.backgroundColor = [UIColor clearColor];
    marksLabel.font = [UIFont systemFontOfSize:16];
    marksLabel.textAlignment = NSTextAlignmentLeft;
    marksLabel.textColor = [UIColor blackColor];
    marksLabel.text = @"上传名片";
    [self.view addSubview:marksLabel];
    
    //名片
    cardImageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 74, 591/2, 300/2)];
    [cardImageView setImage:[UIImage imageNamed:@"mingpianbeijing@2x"]];
    cardImageView.userInteractionEnabled = YES;
   // cardImageView.contentMode = UIViewContentModeScaleAspectFit;
    [cardImageView setContentMode:UIViewContentModeScaleAspectFill];
    cardImageView.clipsToBounds = YES;
    [self.view addSubview:cardImageView];
    
    //上传名片按钮
    UIButton *cardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cardButton.backgroundColor = [UIColor clearColor];
    cardButton.frame = CGRectMake(0, 0, 591/2, 300/2);
    [cardButton addTarget:self action:@selector(clickCardButton) forControlEvents:UIControlEventTouchUpInside];
    [cardImageView addSubview:cardButton];
    
    //文案2
    UIImageView *lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 458/2, 300, 2/2)];
    lineImageView.backgroundColor = [UIColor clearColor];
    lineImageView.userInteractionEnabled = YES;
    [lineImageView setImage:[UIImage imageNamed:@"xiahuaxian@2x"]];
    [self.view addSubview:lineImageView];
    
    UILabel *addressMessageLabel = [[UILabel alloc]init];
    addressMessageLabel.backgroundColor = [UIColor clearColor];
    addressMessageLabel.font = [UIFont systemFontOfSize:14];
    addressMessageLabel.textAlignment = NSTextAlignmentLeft;
    addressMessageLabel.textColor = [UIColor colorWithRed:181.0f/255.0f green:201.0f/255.0f blue:237.0f/255.0f alpha:1.0];
    addressMessageLabel.numberOfLines = 0;
    NSString *str1 = @"您也可以通过金币兑换方式获取VIP资格";
    
    //***********ios7的方法
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7)
    {
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
        size1 = [str1 boundingRectWithSize:CGSizeMake(302, 36) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    }else
    {
        //***********ios6的方法
        size1 = [str1 sizeWithFont:[UIFont systemFontOfSize:14]constrainedToSize:CGSizeMake(302,36) lineBreakMode:NSLineBreakByWordWrapping];
    }
    //********************
    addressMessageLabel.frame =CGRectMake(7,468/2, 302, size1.height);
    addressMessageLabel.text = str1;
    [self.view addSubview:addressMessageLabel];


    /*
     **购买金币
     */

    //购买金币背景
    UIImageView *buyImageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 550/2, 591/2, 72/2)];
    buyImageView.backgroundColor = [UIColor clearColor];
    buyImageView.userInteractionEnabled = YES;
    [buyImageView setImage:[UIImage imageNamed:@"buyimages@2x"]];
    [self.view addSubview:buyImageView];
    
    //购买金币标记字段
    UILabel *marksBuyLabel = [[UILabel alloc]initWithFrame:CGRectMake(9, 20/2, 122/2, 17)];
    marksBuyLabel.backgroundColor = [UIColor clearColor];
    marksBuyLabel.font = [UIFont systemFontOfSize:15];
    marksBuyLabel.textAlignment = NSTextAlignmentLeft;
    marksBuyLabel.textColor = [UIColor whiteColor];
    marksBuyLabel.text = @"金币购买";
    [buyImageView addSubview:marksBuyLabel];
    
    //半年
    halfYearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    halfYearButton.frame = CGRectMake(172/2, 9, 124/2, 42/2);
    halfYearButton.backgroundColor= [UIColor clearColor];
    [halfYearButton setImage:[UIImage imageNamed:@"registration_sexUnchecked_12@2x"] forState:UIControlStateNormal];
    [halfYearButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 41)];
    [halfYearButton setTitle:@"半年" forState:UIControlStateNormal];
    [halfYearButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [halfYearButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    halfYearButton.titleLabel.font = [UIFont systemFontOfSize:14];
    halfYearButton.tag = 100;
    [halfYearButton addTarget:self action:@selector(halfYearButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [buyImageView addSubview:halfYearButton];

    //一年
    oneYearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    oneYearButton.frame = CGRectMake(350/2, 9, 124/2, 42/2);
    oneYearButton.backgroundColor= [UIColor clearColor];
    [oneYearButton setImage:[UIImage imageNamed:@"registration_sexUnchecked_12@2x"] forState:UIControlStateNormal];
    [oneYearButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 41)];
    [oneYearButton setTitle:@"一年" forState:UIControlStateNormal];
    [oneYearButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [oneYearButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    oneYearButton.titleLabel.font = [UIFont systemFontOfSize:14];
    oneYearButton.tag = 1000;
    [oneYearButton addTarget:self action:@selector(oneYearButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [buyImageView addSubview:oneYearButton];
    
    myBuyButton=[UIButton buttonWithType:UIButtonTypeCustom];
    myBuyButton.frame=CGRectMake(28/2, 686/2, 580/2, 72/2);
    [myBuyButton setBackgroundImage:[UIImage imageNamed:@"querengoumai@2x"] forState:UIControlStateNormal];
    [myBuyButton setTitle:@"确认" forState:UIControlStateNormal];
    [myBuyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    myBuyButton.titleLabel.font=[UIFont systemFontOfSize:16];
    myBuyButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    //[myBuyButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 130)];
    myBuyButton.userInteractionEnabled=YES;
    [myBuyButton addTarget:self action:@selector(clickmyBuyButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myBuyButton];

}
#pragma mark - 返回
-(void)backButtonClicked
{
   // if ([self.isSetting isEqualToString:@"yes"]) {
    
//    }else
//    {
//        SUNViewController *drawerController = (SUNViewController *)self.navigationController.mm_drawerController;
//        
//        if (drawerController.openSide == MMDrawerSideNone) {
//            [drawerController openDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
//                
//            }];
//        }else if  (drawerController.openSide == MMDrawerSideLeft) {
//            [drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
//                
//            }];
//        }
//    }
    
    if ([self.isMenu isEqualToString:@"yes"]) {
        SUNViewController *drawerController = (SUNViewController *)self.navigationController.mm_drawerController;
        
        if (drawerController.openSide == MMDrawerSideNone) {
            [drawerController openDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
                
            }];
        }else if  (drawerController.openSide == MMDrawerSideLeft) {
            [drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
                
            }];
        }

    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
#pragma mark - 充值
- (void)ButtonClicked
{
    GoldcoinsViewController *goldcoinsViewController = [[GoldcoinsViewController alloc] init];
    [self.navigationController pushViewController:goldcoinsViewController animated:YES];
}
#pragma mark - 确认购买
- (void)clickmyBuyButton
{
    if (halfYearButton.tag == 101) {
        goldString = @"1";
    }else if (oneYearButton.tag == 1001)
    {
        goldString = @"2";
    }
    
    if ([cardIdString isEqualToString:@""] == NO || [goldString isEqualToString:@""] == NO) {
        [BCHTTPRequest updateVIPWithCardId:cardIdString WithGold:goldString usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
//                if ([self.isSetting isEqualToString:@"yes"]) {
//                    [self.navigationController popViewControllerAnimated:YES];
//                }else
//                {
//                    DDMenuController * rootController = ((AppDelegate*)[UIApplication sharedApplication].delegate).menuController;
//                    [rootController showLeftController:YES];
//                }
                if ([resultDic[@"state"] integerValue] == 2) {
                    alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"您的金币数量不足，请充值" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    [alertView show];
                    
                }else if ([resultDic[@"state"] integerValue] == 1)
                {
                    //发通知刷新VIP标记
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowVIP" object:nil];
                        if ([self.isSetting isEqualToString:@"yes"]) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }else
                    {
                        SUNViewController *drawerController = (SUNViewController *)self.navigationController.mm_drawerController;
                        
                        if (drawerController.openSide == MMDrawerSideNone) {
                            [drawerController openDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
                                
                            }];
                        }else if  (drawerController.openSide == MMDrawerSideLeft) {
                            [drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
                                
                            }];
                        }

                        }

                }
            }
        }];

    }
    
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        ;
    }else
    {
        GoldcoinsViewController *goldcoinsViewController = [[GoldcoinsViewController alloc] init];
        [self.navigationController pushViewController:goldcoinsViewController animated:YES];
    }
}
#pragma mark - 半年
- (void)halfYearButtonClicked
{
    if (halfYearButton.tag == 100) {
        [halfYearButton setImage:[UIImage imageNamed:@"registration_sexChecked_10@2x"] forState:UIControlStateNormal];
        [oneYearButton setImage:[UIImage imageNamed:@"registration_sexUnchecked_12@2x"] forState:UIControlStateNormal];
        halfYearButton.tag = 101;
        oneYearButton.tag = 1000;
    }else
    {
        [halfYearButton setImage:[UIImage imageNamed:@"registration_sexUnchecked_12@2x"] forState:UIControlStateNormal];
        halfYearButton.tag = 100;
    }
    
}
#pragma mark - 一年
- (void)oneYearButtonClicked
{
    if (oneYearButton.tag == 1000) {
        [halfYearButton setImage:[UIImage imageNamed:@"registration_sexUnchecked_12@2x"] forState:UIControlStateNormal];
        [oneYearButton setImage:[UIImage imageNamed:@"registration_sexChecked_10@2x"] forState:UIControlStateNormal];
        oneYearButton.tag = 1001;
        halfYearButton.tag = 100;
    }else
    {
        [oneYearButton setImage:[UIImage imageNamed:@"registration_sexUnchecked_12@2x"] forState:UIControlStateNormal];
        oneYearButton.tag = 1000;
    }
    
    
}
#pragma mark - 上传名片
- (void)clickCardButton
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择",@"拍照", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [actionSheet showInView:self.view];
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController * picker = [[UIImagePickerController alloc]init];
    
    picker.delegate = self;
    picker.allowsEditing = NO;  //是否可编辑
    
    if (buttonIndex == 0) {
        //相册
        isPaids = @"0";
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:^{
        }];
    }else if (buttonIndex == 1) {
        //拍照
        isPaids = @"1";
        //判断是否可以打开相机，模拟器此功能无法使用
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            picker.delegate = self;
            //            _picker.allowsEditing = YES;  //是否可编辑
            //摄像头
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:nil];
        }else{
            //            //如果没有提示用户
            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"你没有摄像头" delegate:nil cancelButtonTitle:@"好的!" otherButtonTitles:nil];
            //            [alert show];
        }
        
    }
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //得到图片
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if ([otherObj.isSavePhoto isEqualToString:@"1"] && [isPaids isEqualToString:@"1"]) {
    SEL selectorToCall = @selector(imageWasSavedSuccessfully:didFinishSavingWithError:contextInfo:);
    UIImageWriteToSavedPhotosAlbum(image, self,selectorToCall, NULL);
    }
    [BCHTTPRequest uploadCardWithCardImage:image usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
             [cardImageView setImage:image];
            cardIdString = [NSString stringWithFormat:@"%@",resultDic[@"id"]];
        }
    }];
    
    
    [picker dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}
- (void) imageWasSavedSuccessfully:(UIImage *)paramImage didFinishSavingWithError:(NSError *)paramError contextInfo:(void *)paramContextInfo{
    if (paramError == nil){
        NSLog(@"Image was saved successfully.");
    } else {
        NSLog(@"An error happened while saving the image.");
        NSLog(@"Error = %@", paramError);
    }
}

//取消返回
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        ;
    }];
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
