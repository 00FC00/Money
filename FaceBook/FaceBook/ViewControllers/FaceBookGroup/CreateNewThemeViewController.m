//
//  CreateNewThemeViewController.m
//  FaceBook
//
//  Created by fengshaohui on 14-5-29.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "CreateNewThemeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "BCHTTPRequest.h"
#import "DMCAlertCenter.h"

#import "OtherNotice.h"
#import "OtherNoticeObject.h"
@interface CreateNewThemeViewController ()
{
    //名称输入框
    UITextField *titleField;
    
    //照片
    UIImageView *photoImageView;
    UIActionSheet *photoActionSheet;
    UIButton *addPhotoButton;
    
    OtherNotice *otherNotice;
    OtherNoticeObject *otherObj;
    
    NSString *isMPai;
}
@end

@implementation CreateNewThemeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        headImageUrl = @"";
        isMPai = [[NSString alloc]init];
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
    self.title = @"创建主题群";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 22, 40, 40);
    [backButton setBackgroundImage:[UIImage imageNamed:@"login_backButton@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //[self.navigationController.view addSubview:backButton];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;
    
    //创建
    UIButton *_Button = [UIButton buttonWithType:UIButtonTypeCustom];
    _Button.frame = CGRectMake(526/2, 22, 84/2, 42/2);
    [_Button setBackgroundImage:[UIImage imageNamed:@"login_RegistrationButton_03@2x"] forState:UIControlStateNormal];
    [_Button setTitle:@"创建" forState:UIControlStateNormal];
    _Button.titleLabel.font = [UIFont systemFontOfSize:15];
    [_Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_Button addTarget:self action:@selector(ButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:_Button];
    self.navigationItem.rightBarButtonItem=rightbuttonitem;
    
    otherNotice = [[OtherNotice alloc]init];
    [otherNotice createDataBase];
    
    otherObj = [otherNotice getAllOthersRemindStyleWithNumber:@"1"];
    
    //创建主题的背景
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(12/2, 22/2, 616/2, 320/2)];
    backImageView.backgroundColor = [UIColor clearColor];
    [backImageView setImage:[UIImage imageNamed:@"chuangjianzhutibeijing@2x"]];
    backImageView.userInteractionEnabled = YES;
    [self.view addSubview:backImageView];
    
    //名称
    UILabel *markTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20/2, 20/2, 100, 32/2)];
    markTitleLabel.backgroundColor = [UIColor clearColor];
    markTitleLabel.textAlignment = NSTextAlignmentLeft;
    markTitleLabel.textColor = [UIColor blackColor];
    markTitleLabel.font = [UIFont systemFontOfSize:16];
    markTitleLabel.text = @"名称:";
    [backImageView addSubview:markTitleLabel];
    
    //输入框
    UIImageView *fieldImageView = [[UIImageView alloc]initWithFrame:CGRectMake(16/2, 80/2, 582/2, 50/2)];
    fieldImageView.backgroundColor = [UIColor clearColor];
    [fieldImageView setImage:[UIImage imageNamed:@"zhutimingchengkuang@2x"]];
    fieldImageView.userInteractionEnabled = YES;
    [backImageView addSubview:fieldImageView];
    
    titleField = [[UITextField alloc]initWithFrame:CGRectMake(3, 0, 576/2, 50/2)];
    titleField.backgroundColor = [UIColor clearColor];
    titleField.delegate = self;
    titleField.textAlignment = NSTextAlignmentLeft;
    titleField.textColor = [UIColor blackColor];
    titleField.placeholder = @"请输入主题群名称";
    titleField.font = [UIFont systemFontOfSize:15];
    titleField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    titleField.returnKeyType =UIReturnKeyDone;
    [fieldImageView addSubview:titleField];
    
    //添加按钮
    photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(28/2, 170/2, 134/2, 134/2)];
    photoImageView.backgroundColor = [UIColor clearColor];
    [photoImageView setImage:[UIImage imageNamed:@""]];
    [photoImageView.layer setMasksToBounds:YES];
    [photoImageView.layer setCornerRadius:3.0f];
    
    photoImageView.userInteractionEnabled = YES;
    [backImageView addSubview:photoImageView];
    
    addPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addPhotoButton.frame = CGRectMake(0, 0 , 134/2, 134/2);
    addPhotoButton.backgroundColor = [UIColor clearColor];
    [addPhotoButton setBackgroundImage:[UIImage imageNamed:@"tianjiaren@2x"] forState:UIControlStateNormal];
    [addPhotoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addPhotoButton setTitle:@"" forState:UIControlStateNormal];
    [addPhotoButton addTarget:self action:@selector(clickAddPhotoButton) forControlEvents:UIControlEventTouchUpInside];
    [photoImageView addSubview:addPhotoButton];

    
}
#pragma mark - 返回
- (void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -创建
- (void)ButtonClicked
{
    if ([BCHTTPRequest getUserVIP] == NO) {
        UIAlertView *vipAlertView = [[UIAlertView alloc]initWithTitle:@"" message:@"只有VIP可以创建主题群,请先申请VIP" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil];
        [vipAlertView show];
    }else
    {
        if ([titleField.text length] < 1) {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"请输入标题"];
        }else if ([headImageUrl isEqualToString:@""]) {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"请上传群头像"];
        }else
        {
            [BCHTTPRequest createThemeGroupWithLogo_id:headImageUrl WithTitle:[titleField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
                if (isSuccess == YES) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"CreateThemeGroup" object:nil];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        }
    }
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        
        [titleField resignFirstResponder];
        
        return NO;
    }
    return YES;
    
}
#pragma mark - 添加图片
- (void)clickAddPhotoButton
{
    [titleField resignFirstResponder];
    photoActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    [photoActionSheet showInView:self.view];

}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    UIImagePickerController * picker = [[UIImagePickerController alloc]init];
    
    picker.delegate = self;
    picker.allowsEditing = YES;  //是否可编辑
    
    if (buttonIndex == 0) {
        //拍照
        isMPai = @"1";
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:^{
        }];
    }else if (buttonIndex == 1) {
        //相册
        isMPai = @"0";
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:^{
        }];
    }
    
    
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //得到图片
    UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
    if ([otherObj.isSavePhoto isEqualToString:@"1"] && [isMPai isEqualToString:@"1"]) {
        SEL selectorToCall = @selector(imageWasSavedSuccessfully:didFinishSavingWithError:contextInfo:);
        UIImageWriteToSavedPhotosAlbum(image, self,selectorToCall, NULL);
    }
    [BCHTTPRequest createThemeGroupUploadWithGroupImage:image usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            
            [addPhotoButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [photoImageView setImage:image];
            photoImageView.userInteractionEnabled = YES;
            
            headImageUrl = resultDic[@"id"];
            
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [titleField resignFirstResponder];
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
