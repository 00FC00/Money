//
//  MyPersonCenterViewController.m
//  FaceBook
//
//  Created by fengshaohui on 14-5-15.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "MyPersonCenterViewController.h"
#import "DMCAlertCenter.h"
#import "MypersonCenterDetialsViewController.h"
#import "BCHTTPRequest.h"
#import "AFNetworking.h"

#import "OtherNotice.h"
#import "OtherNoticeObject.h"

@interface MyPersonCenterViewController ()
{
    UIScrollView *backgroundScrollView; //背景
    
    UIImageView *headImageView;
    
    UITextField *nameTextField;         //真实姓名
    UITextField *phoneNumTextField;     //手机号
    
    UITextField *nickname1TextField;    //昵称1
    UITextField *nickname2TextField;    //昵称2
    
    UIButton *femaleButton;             //性别男
    UIButton *maleButton;               //性别女
    UIButton *secretButton;             //性别保密
    
    UIButton *workCityButton;           //工作城市-省
    UIButton *workAreaButton;           //工作城市-市
    
    UIButton *headButton;               //上传头像按钮
       
    NSString *phoneNumString;
    NSString *securityCodeString;
    NSString *genderString;            //性别参数1：男，2：女，0：保密
    NSString *logoStr;                 //上传头像后返回的头像id
    NSString *workCityString;          //工作城市-省
    NSString *workAreaString;          //工作城市-市
    
    OtherNotice *otherNotice;
    OtherNoticeObject *otherObj;
    
    NSString *isPaiz;
}

@property (strong, nonatomic) UIImagePickerController* picker;

@end

@implementation MyPersonCenterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
       
        isPaiz = [[NSString alloc]init];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
//    self.navigationController.navigationBarHidden = YES;
    
    [super viewWillDisappear:animated];
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
    
    //完成
    UIButton *_Button = [UIButton buttonWithType:UIButtonTypeCustom];
    _Button.frame = CGRectMake(526/2, 22, 84/2, 42/2);
    [_Button setBackgroundImage:[UIImage imageNamed:@"login_RegistrationButton_03@2x"] forState:UIControlStateNormal];
    [_Button setTitle:@"完成" forState:UIControlStateNormal];
    _Button.titleLabel.font = [UIFont systemFontOfSize:15];
    [_Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_Button addTarget:self action:@selector(ButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:_Button];
    self.navigationItem.rightBarButtonItem=rightbuttonitem;
    
    otherNotice = [[OtherNotice alloc]init];
    [otherNotice createDataBase];
    
    otherObj = [otherNotice getAllOthersRemindStyleWithNumber:@"1"];
    
    //ScrollView背景
    backgroundScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.height, [UIScreen mainScreen].bounds.size.height-64)];
    backgroundScrollView.delegate = self;
    backgroundScrollView.contentSize = CGSizeMake(320, 1136/2);
    backgroundScrollView.backgroundColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:251/255.0 alpha:1];
    [self.view addSubview:backgroundScrollView];
    
    /*
     **头像部分
     */
    UIImageView *headBackImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 186/2)];
    headBackImageView.backgroundColor = [UIColor clearColor];
    headBackImageView.userInteractionEnabled = YES;
    [headBackImageView setImage:[UIImage imageNamed:@"gerenzhongxintouxiang@2x"]];
    [backgroundScrollView addSubview:headBackImageView];
    
    
    //头像
    headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(40/2, 22/2, 132/2, 132/2)];
    headImageView.backgroundColor = [UIColor clearColor];
    [headImageView setImageWithURL:[NSURL URLWithString:[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInformation"] objectForKey:@"pic"]] placeholderImage:[UIImage imageNamed:@"ceshi@2x"]];
    headImageView.userInteractionEnabled = YES;
    [headBackImageView addSubview:headImageView];
    
    headButton = [UIButton buttonWithType:UIButtonTypeCustom];
    headButton.frame = CGRectMake(0, 0, self.view.frame.size.width, 186/2);
    headButton.backgroundColor = [UIColor clearColor];
   // [headButton setBackgroundImage:[UIImage imageNamed:@"ceshi@2x"] forState:UIControlStateNormal];
    [headButton addTarget:self action:@selector(headButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [headBackImageView addSubview:headButton];
    
    /*
     **姓名、电话
     */
    UIView *nameView = [[UIView alloc] initWithFrame:CGRectMake(0, headBackImageView.frame.size.height, 320, 204/2)];
    nameView.backgroundColor = [UIColor colorWithRed:208/255.0 green:210/255.0 blue:215/255.0 alpha:1];
    nameView.userInteractionEnabled = YES;
    [backgroundScrollView addSubview:nameView];
    //姓名
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20/2, 160/2, 72/2)];
    nameLabel.text = @"真实姓名：";
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textAlignment = NSTextAlignmentRight;
    nameLabel.font = [UIFont systemFontOfSize:15];
    [nameView addSubview:nameLabel];
    
    UIImageView *nameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(164/2, 20/2, 443.0/2, 72/2)];
    [nameImageView setImage:[UIImage imageNamed:@"registration_textFieldBackground_03@2x"]];
    nameImageView.userInteractionEnabled = YES;
    [nameView addSubview:nameImageView];
    
    nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(16/2, 0, 410/2, 72/2)];
    nameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    nameTextField.textColor = [UIColor grayColor];
    nameTextField.placeholder = @"必填，注册成功后无法更改";
    nameTextField.font = [UIFont systemFontOfSize:14];
    [nameTextField setEnabled:NO];
    nameTextField.text = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInformation"] objectForKey:@"name"];
    //    nameTextField.keyboardType = UIKeyboardTypeDecimalPad;
    nameTextField.delegate = self;
    [nameImageView addSubview:nameTextField];
    
    //手机号
    UILabel *phoneNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, nameLabel.frame.origin.y+nameLabel.frame.size.height+20/2, 160/2, 72/2)];
    phoneNumLabel.text = @"手机号：";
    phoneNumLabel.backgroundColor = [UIColor clearColor];
    phoneNumLabel.textAlignment = NSTextAlignmentRight;
    phoneNumLabel.font = [UIFont systemFontOfSize:15];
    [nameView addSubview:phoneNumLabel];
    
    UIImageView *phoneNumImageView = [[UIImageView alloc] initWithFrame:CGRectMake(164/2, nameImageView.frame.origin.y+nameImageView.frame.size.height+20/2, 443/2, 72/2)];
    [phoneNumImageView setImage:[UIImage imageNamed:@"registration_textFieldBackground_03@2x"]];
    phoneNumImageView.userInteractionEnabled = YES;
    [nameView addSubview:phoneNumImageView];
    
    phoneNumTextField = [[UITextField alloc] initWithFrame:CGRectMake(16/2, 0, 410/2, 72/2)];
    phoneNumTextField.placeholder = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInformation"] objectForKey:@"phone"];
    [phoneNumTextField setEnabled:NO];
    phoneNumTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    phoneNumTextField.font = [UIFont systemFontOfSize:14];
    phoneNumTextField.keyboardType = UIKeyboardTypeDecimalPad;
    phoneNumTextField.delegate = self;
    [phoneNumImageView addSubview:phoneNumTextField];

    /*
     **性别
     */
    UIImageView *sexImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, headBackImageView.frame.size.height+nameView.frame.size.height+20/2, 320, 92/2)];
    [sexImageView setImage:[UIImage imageNamed:@"registration_sexBackground_06@2x"]];
    sexImageView.userInteractionEnabled = YES;
    [backgroundScrollView addSubview:sexImageView];
    
    UILabel *sexLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10/2, 160/2, 72/2)];
    sexLabel.text = @"性别：";
    sexLabel.backgroundColor = [UIColor clearColor];
    sexLabel.textAlignment = NSTextAlignmentRight;
    sexLabel.font = [UIFont systemFontOfSize:15];
    [sexImageView addSubview:sexLabel];
    
//    NSString *genderStr = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInformation"] objectForKey:@"gender"];
//    if ([genderStr isEqualToString:@"男"]) {
//        genderString = @"1";//默认性别为男
//    }else if ([genderStr isEqualToString:@"女"])
//    {
//         genderString = @"2";//默认性别为nv
//    }else
//    {
//        genderString = @"0";//默认性别为baomi
//    }
    genderString = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInformation"] objectForKey:@"gender"];
    NSLog(@"的性别：%@",genderString);
    maleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    maleButton.backgroundColor = [UIColor clearColor];
    maleButton.frame = CGRectMake(166/2, 22/2, 110/2, 42/2);
    if ([genderString isEqualToString:@"1"]) {
        [maleButton setImage:[UIImage imageNamed:@"registration_sexChecked_10@2x"] forState:UIControlStateNormal];
    }else
    {
        [maleButton setImage:[UIImage imageNamed:@"registration_sexUnchecked_12@2x"] forState:UIControlStateNormal];
    }
    
    [maleButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 33)];
    [maleButton setTitle:@"男" forState:UIControlStateNormal];
    [maleButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [maleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    maleButton.titleLabel.font = [UIFont systemFontOfSize:15];
    maleButton.tag = 101;
    [maleButton addTarget:self action:@selector(sexButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [sexImageView addSubview:maleButton];
    
    femaleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    femaleButton.backgroundColor = [UIColor clearColor];
    femaleButton.frame = CGRectMake(300/2, 22/2, 110/2, 42/2);
    if ([genderString isEqualToString:@"2"]) {
        
        [femaleButton setImage:[UIImage imageNamed:@"registration_sexChecked_10@2x"] forState:UIControlStateNormal];
    }else
    {
        [femaleButton setImage:[UIImage imageNamed:@"registration_sexUnchecked_12@2x"] forState:UIControlStateNormal];
    }

    
    [femaleButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 33)];
    [femaleButton setTitle:@"女" forState:UIControlStateNormal];
    [femaleButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [femaleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    femaleButton.titleLabel.font = [UIFont systemFontOfSize:15];
    femaleButton.tag = 102;
    [femaleButton addTarget:self action:@selector(sexButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [sexImageView addSubview:femaleButton];
    
    secretButton = [UIButton buttonWithType:UIButtonTypeCustom];
    secretButton.backgroundColor = [UIColor clearColor];
    secretButton.frame = CGRectMake(436/2, 22/2, 140/2, 42/2);
    if ([genderString isEqualToString:@"0"]) {
        
        [secretButton setImage:[UIImage imageNamed:@"registration_sexChecked_10@2x"] forState:UIControlStateNormal];
    }else
    {
        
        [secretButton setImage:[UIImage imageNamed:@"registration_sexUnchecked_12@2x"] forState:UIControlStateNormal];
    }

    [secretButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 48)];
    [secretButton setTitle:@"保密" forState:UIControlStateNormal];
    [secretButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [secretButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    secretButton.titleLabel.font = [UIFont systemFontOfSize:15];
    secretButton.tag = 103;
    [secretButton addTarget:self action:@selector(sexButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [sexImageView addSubview:secretButton];
    
    /*
     **昵称
     */
    UIView *nicknameView = [[UIView alloc] initWithFrame:CGRectMake(0, sexImageView.frame.size.height+sexImageView.frame.origin.y+20/2, 320, 200/2)];
    nicknameView.backgroundColor = [UIColor colorWithRed:208/255.0 green:210/255.0 blue:215/255.0 alpha:1];
    nicknameView.userInteractionEnabled = YES;
    [backgroundScrollView addSubview:nicknameView];
    //昵称1
    UILabel *nickname1Label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20/2, 160/2, 72/2)];
    nickname1Label.text = @"昵称1：";
    nickname1Label.backgroundColor = [UIColor clearColor];
    nickname1Label.textAlignment = NSTextAlignmentRight;
    nickname1Label.font = [UIFont systemFontOfSize:15];
    [nicknameView addSubview:nickname1Label];
    
    UIImageView *nickname1ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(164/2, 20/2, 443.0/2, 72/2)];
    [nickname1ImageView setImage:[UIImage imageNamed:@"registration_textFieldBackground_03@2x"]];
    nickname1ImageView.userInteractionEnabled = YES;
    [nicknameView addSubview:nickname1ImageView];
    
    nickname1TextField = [[UITextField alloc] initWithFrame:CGRectMake(16/2, 0, 410/2, 72/2)];
    nickname1TextField.placeholder = @"请输入昵称1";
    nickname1TextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    nickname1TextField.font = [UIFont systemFontOfSize:14];
    //    passwordTextField.keyboardType = UIKeyboardTypeDecimalPad;
    nickname1TextField.delegate = self;
    nickname1TextField.text = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInformation"] objectForKey:@"nickname_first"];
    [nickname1ImageView addSubview:nickname1TextField];
    //昵称2
    UILabel *nickname2Label = [[UILabel alloc] initWithFrame:CGRectMake(0, nickname1Label.frame.origin.y+nickname1Label.frame.size.height+20/2, 160/2, 72/2)];
    nickname2Label.text = @"昵称2：";
    nickname2Label.backgroundColor = [UIColor clearColor];
    nickname2Label.textAlignment = NSTextAlignmentRight;
    nickname2Label.font = [UIFont systemFontOfSize:15];
    [nicknameView addSubview:nickname2Label];
    
    UIImageView *nickname2ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(164/2, nickname2Label.frame.origin.y, 443.0/2, 72/2)];
    [nickname2ImageView setImage:[UIImage imageNamed:@"registration_textFieldBackground_03@2x"]];
    nickname2ImageView.userInteractionEnabled = YES;
    [nicknameView addSubview:nickname2ImageView];
    
    nickname2TextField = [[UITextField alloc] initWithFrame:CGRectMake(16/2, 0, 410/2, 72/2)];
    nickname2TextField.placeholder = @"请输入昵称2";
    nickname2TextField.text = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInformation"] objectForKey:@"nickname_second"];
    nickname2TextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    nickname2TextField.font = [UIFont systemFontOfSize:14];
    nickname2TextField.delegate = self;
    [nickname2ImageView addSubview:nickname2TextField];

    /*
     **工作城市
     */
    UIImageView *workCityImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, nicknameView.frame.size.height+nicknameView.frame.origin.y+20/2, 320, 112/2)];
    [workCityImageView setImage:[UIImage imageNamed:@"registration_cityBackground_16@2x"]];
    workCityImageView.userInteractionEnabled = YES;
    [backgroundScrollView addSubview:workCityImageView];
    
    //工作城市
    UILabel *workCityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20/2, 160/2, 72/2)];
    workCityLabel.text = @"工作城市：";
    workCityLabel.backgroundColor = [UIColor clearColor];
    workCityLabel.textAlignment = NSTextAlignmentRight;
    workCityLabel.font = [UIFont systemFontOfSize:15];
    [workCityImageView addSubview:workCityLabel];
    
    workCityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    workCityButton.backgroundColor = [UIColor clearColor];
    workCityButton.frame = CGRectMake(164/2, 20/2, 212/2, 72/2);
    [workCityButton setBackgroundImage:[UIImage imageNamed:@"registration_cityCheckButton_19@2x"] forState:UIControlStateNormal];
    NSString *cityStr = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInformation"] objectForKey:@"work_city"];
    workCityString = cityStr;
    [workCityButton setTitle:cityStr forState:UIControlStateNormal];
    [workCityButton setTitleColor:[UIColor colorWithRed:203/255.0 green:205/255.0 blue:211/255.0 alpha:1] forState:UIControlStateNormal];
    [workCityButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 50)];
    workCityButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [workCityButton addTarget:self action:@selector(workCityButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [workCityImageView addSubview:workCityButton];
    
    workAreaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    workAreaButton.backgroundColor = [UIColor clearColor];
    workAreaButton.frame = CGRectMake(396/2, 20/2, 212/2, 72/2);
    [workAreaButton setBackgroundImage:[UIImage imageNamed:@"registration_cityCheckButton_19@2x"] forState:UIControlStateNormal];
    NSString *areaStr = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInformation"] objectForKey:@"work_area"];
    workAreaString = areaStr;
    [workAreaButton setTitle:areaStr forState:UIControlStateNormal];
    [workAreaButton setTitleColor:[UIColor colorWithRed:203/255.0 green:205/255.0 blue:211/255.0 alpha:1] forState:UIControlStateNormal];
    [workAreaButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 50)];
    workAreaButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [workAreaButton addTarget:self action:@selector(workAreaButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [workCityImageView addSubview:workAreaButton];
    
    /*
     **下一步
     */
    //下一步
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(30/2, workCityImageView.frame.origin.y+workCityImageView.frame.size.height+35,  580/2, 75.0/2);
    [nextButton setBackgroundImage:[UIImage imageNamed:@"forgetPassword_finishButtonBackground_03@2x"] forState:UIControlStateNormal];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [backgroundScrollView addSubview:nextButton];

    
}
#pragma mark - 下一步
- (void)nextButtonClicked
{
    MypersonCenterDetialsViewController *mypersonCenterDetialsVC = [[MypersonCenterDetialsViewController alloc]init];
    //完成修改资料
    [BCHTTPRequest ModifyThePersonMessageWithGender:genderString FirstName:[nickname1TextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] WithSecondName:[nickname2TextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] WithWorkCity:[workCityButton.titleLabel.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] WithWorkArea:[workAreaButton.titleLabel.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            
            
        }
    }];
    [self.navigationController pushViewController:mypersonCenterDetialsVC animated:YES];
   
}
#pragma mark - 返回
- (void)backButtonClicked
{
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
    self.navigationController.navigationBarHidden = YES;
}
#pragma mark - 点击修改头像
- (void)headButtonClicked
{
    [nickname1TextField resignFirstResponder];
    [nickname2TextField resignFirstResponder];
    
    photoActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从手机相册选择",@"拍照", nil];
    [photoActionSheet showInView:self.view];

}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
//    UIImagePickerController * picker = [[UIImagePickerController alloc]init];
//    
//    picker.delegate = self;
//    picker.allowsEditing = YES;  //是否可编辑
//    
//    if (buttonIndex == 0) {
//        //拍照
//        isPaiz = @"1";
//        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//        [self presentViewController:picker animated:YES completion:^{
//        }];
//    }else if (buttonIndex == 1) {
//        //相册
//        isPaiz = @"0";
//        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        [self presentViewController:picker animated:YES completion:^{
//        }];
//    }
    
    UIImagePickerController * picker = [[UIImagePickerController alloc]init];
    
    picker.delegate = self;
    picker.allowsEditing = YES;  //是否可编辑
    
    if (buttonIndex == 0) {
        //相册
        isPaiz = @"0";
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:^{
        }];
    }else if (buttonIndex == 1) {
        //拍照
        isPaiz = @"1";
        //判断是否可以打开相机，模拟器此功能无法使用
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            picker.delegate = self;
            //_picker.allowsEditing = YES;  //是否可编辑
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
    UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
    if ([otherObj.isSavePhoto isEqualToString:@"1"] && [isPaiz isEqualToString:@"1"]) {
        SEL selectorToCall = @selector(imageWasSavedSuccessfully:didFinishSavingWithError:contextInfo:);
        UIImageWriteToSavedPhotosAlbum(image, self,selectorToCall, NULL);
    }
    [BCHTTPRequest modifyTheUserHeaderImagesWithImage:image UsingSuccessBlock:^(BOOL isSuccess, NSString *imageId) {
        if (isSuccess == YES) {
            [headImageView setImage:image];
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"上传成功"];
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

#pragma mark - 完成
- (void)ButtonClicked
{
   
    //完成修改资料
    [BCHTTPRequest ModifyThePersonMessageWithGender:genderString FirstName:[nickname1TextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] WithSecondName:[nickname2TextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] WithWorkCity:[workCityButton.titleLabel.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] WithWorkArea:[workAreaButton.titleLabel.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];

}
#pragma mark - 键盘隐藏
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return [textField resignFirstResponder];
}

#pragma mark - 选择性别
-(void)sexButtonClicked:(UIButton *)sender
{
    if (sender.tag == 101) {
        genderString = @"1";
        [maleButton setImage:[UIImage imageNamed:@"registration_sexChecked_10@2x"] forState:UIControlStateNormal];
        [femaleButton setImage:[UIImage imageNamed:@"registration_sexUnchecked_12@2x"] forState:UIControlStateNormal];
        [secretButton setImage:[UIImage imageNamed:@"registration_sexUnchecked_12@2x"] forState:UIControlStateNormal];
    }else if (sender.tag == 102) {
        genderString = @"2";
        [maleButton setImage:[UIImage imageNamed:@"registration_sexUnchecked_12@2x"] forState:UIControlStateNormal];
        [femaleButton setImage:[UIImage imageNamed:@"registration_sexChecked_10@2x"] forState:UIControlStateNormal];
        [secretButton setImage:[UIImage imageNamed:@"registration_sexUnchecked_12@2x"] forState:UIControlStateNormal];
    }else if (sender.tag == 103) {
        genderString = @"0";
        [maleButton setImage:[UIImage imageNamed:@"registration_sexUnchecked_12@2x"] forState:UIControlStateNormal];
        [femaleButton setImage:[UIImage imageNamed:@"registration_sexUnchecked_12@2x"] forState:UIControlStateNormal];
        [secretButton setImage:[UIImage imageNamed:@"registration_sexChecked_10@2x"] forState:UIControlStateNormal];
    }
}
#pragma mark - 选择城市区域
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
    if (workCityString == nil || [workCityString isEqualToString:@""]) {
        //
        //[[DMCAlertCenter defaultCenter] postAlertWithMessage:@"请先选择省份"];
        workCityString = workCityButton.titleLabel.text;
    }else {
        WorkAreaViewController *WorkAreaVC = [[WorkAreaViewController alloc] init];
        WorkAreaVC.delegate = self;
        WorkAreaVC.workCity = workCityString;
        UINavigationController *WorkAreaNav = [[UINavigationController alloc] initWithRootViewController:WorkAreaVC];
        [self presentViewController:WorkAreaNav animated:YES completion:^{
            ;
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - WorkCityDelegate
- (void)getWorkCity:(NSDictionary *)cityDict
{
    workCityString = [cityDict objectForKey:@"name"];
    [workCityButton setTitle:workCityString forState:UIControlStateNormal];
    
    NSArray *m_cityArray = [[NSArray alloc]init];
    NSArray *m_array = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]];
    
    for (NSDictionary * itemDict in m_array) {
        if ([[itemDict objectForKey:@"state"] isEqualToString:workCityString]) {
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
    workAreaString = [areaDict objectForKey:@"city"];
    [workAreaButton setTitle:workAreaString forState:UIControlStateNormal];
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
