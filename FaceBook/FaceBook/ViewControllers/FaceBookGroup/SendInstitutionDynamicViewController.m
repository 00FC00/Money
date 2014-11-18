//
//  SendInstitutionDynamicViewController.m
//  FaceBook
//
//  Created by fengshaohui on 14-7-2.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "SendInstitutionDynamicViewController.h"
#import "BCHTTPRequest.h"
#import "AFNetworking.h"
#import "DMCAlertCenter.h"
#import "OtherNotice.h"
#import "OtherNoticeObject.h"
@interface SendInstitutionDynamicViewController ()
{
    //输入框★★★★★★★★★★★★★★★★★★★★★★
    //输入框背景
    UIImageView *contectBackImageView;
    //输入框
    UITextView *contectView;
    UILabel *placeHolderLabel;
    
    //照片墙★★★★★★★★★★★★★★★★★★★★★★
    UIImageView *pictureBackImageView;
    //照片
    UIImageView *pictureImageView;
    //删除照片按钮
    UIButton *deleteButton;
    NSString *myPictureStr;
    
    //筛选条件★★★★★★★★★★★★★★★★★★★★★★
    //发布条件选项
    UIImageView *conditionsBackImageView;
    
    //发布到 机构动态
    UIButton *sendInstitutionsButton;
    NSString *sendInstitutionStr;
    //发布到 条线动态
    UIButton *sendLineButton;
    NSString *sendLineStr;
    
    OtherNotice *otherNotice;
    OtherNoticeObject *otherObj;
    
    NSString *isPaids;
    

}
@end

@implementation SendInstitutionDynamicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        sendInstitutionStr = @"1";//上
        sendLineStr = @"1";//下
        
        isPaids = [[NSString alloc]init];
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
    self.title = @"发表动态";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 22, 40, 40);
    [backButton setBackgroundImage:[UIImage imageNamed:@"login_backButton@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //[self.navigationController.view addSubview:backButton];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;
    
    //发送
    UIButton *_Button = [UIButton buttonWithType:UIButtonTypeCustom];
    _Button.frame = CGRectMake(526/2, 22, 84/2, 42/2);
    [_Button setBackgroundImage:[UIImage imageNamed:@"login_RegistrationButton_03@2x"] forState:UIControlStateNormal];
    [_Button setTitle:@"发送" forState:UIControlStateNormal];
    _Button.titleLabel.font = [UIFont systemFontOfSize:15];
    [_Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_Button addTarget:self action:@selector(ButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:_Button];
    self.navigationItem.rightBarButtonItem=rightbuttonitem;
    
    otherNotice = [[OtherNotice alloc]init];
    [otherNotice createDataBase];
    
    otherObj = [otherNotice getAllOthersRemindStyleWithNumber:@"1"];
    
    //背景
    backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    backScrollView.backgroundColor = [UIColor clearColor];
    backScrollView.delegate = self;
    backScrollView.showsHorizontalScrollIndicator = NO;
    [backScrollView setContentSize:CGSizeMake(0, [[UIScreen mainScreen] bounds].size.height)];
    backScrollView.userInteractionEnabled = YES;
    [self.view addSubview:backScrollView];
    
    //输入框背景contectBackImageView;
    contectBackImageView = [[UIImageView alloc]initWithFrame:CGRectMake(12/2,10, 616/2, 244/2)];
    [contectBackImageView setImage:[UIImage imageNamed:@"chuangjianzhutibeijing@2x"]];
    contectBackImageView.userInteractionEnabled = YES;
    contectBackImageView.backgroundColor = [UIColor clearColor];
    [backScrollView addSubview:contectBackImageView];
    
    //输入框contectView; ////placeHolderLabel;
    contectView = [[UITextView alloc] initWithFrame:CGRectMake(8, 4, 584/2, 230/2)];
    contectView.backgroundColor = [UIColor clearColor];
    contectView.delegate=self;
    
    contectView.font = [UIFont systemFontOfSize:14];
    [contectBackImageView addSubview:contectView];
    
    //TextView占位符
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 6, 297, 20)];
    placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
    placeHolderLabel.font = [UIFont systemFontOfSize:14.0f];
    placeHolderLabel.textColor = [UIColor lightGrayColor];
    placeHolderLabel.backgroundColor = [UIColor clearColor];
    placeHolderLabel.alpha = 0;
    placeHolderLabel.tag = 999;
    placeHolderLabel.text = @"最多输入120个字";
    [contectView addSubview:placeHolderLabel];
    if ([[contectView text] length] == 0) {
        [[contectView viewWithTag:999] setAlpha:1];
    }
    
    //点击背景取消键盘
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(handleBackgroundTap:)];
    tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapRecognizer];

    
    pictureArray = [[NSMutableArray alloc] initWithCapacity:100];
    pictureUrlArray = [[NSMutableArray alloc] initWithCapacity:100];
    [self addPictureToPictureWall];


    //发布条件选项conditionsBackImageView;
    conditionsBackImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 458/2, 420/2, 140/2)];
    conditionsBackImageView.userInteractionEnabled = YES;
    conditionsBackImageView.backgroundColor = [UIColor clearColor];
    [backScrollView addSubview:conditionsBackImageView];
    
    
    
    //发布到 机构动态sendInstitutionsButton;
    sendInstitutionsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendInstitutionsButton.frame = CGRectMake(0, 20/2, 64/2, 42/2);
    sendInstitutionsButton.backgroundColor = [UIColor clearColor];
    [sendInstitutionsButton setBackgroundImage:[UIImage imageNamed:@"gouxuan2@2x"] forState:UIControlStateNormal];
    [sendInstitutionsButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [sendInstitutionsButton setTitle:@"中" forState:UIControlStateNormal];
    [sendInstitutionsButton addTarget:self action:@selector(clicksendInstitutionsButton) forControlEvents:UIControlEventTouchUpInside];
    [conditionsBackImageView addSubview:sendInstitutionsButton];
    
    //发布到 条线动态sendLineButton;
    sendLineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendLineButton.frame = CGRectMake(0, 80/2, 64/2, 42/2);
    sendLineButton.backgroundColor = [UIColor clearColor];
    [sendLineButton setBackgroundImage:[UIImage imageNamed:@"gouxuan2@2x"] forState:UIControlStateNormal];
    [sendLineButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [sendLineButton setTitle:@"中" forState:UIControlStateNormal];
    [sendLineButton addTarget:self action:@selector(clicksendLineButton) forControlEvents:UIControlEventTouchUpInside];
    [conditionsBackImageView addSubview:sendLineButton];


    if ([_fromString isEqualToString:@"机构发布动态"]) {
        [conditionsBackImageView setImage:[UIImage imageNamed:@"jigoufabiaodongtai@2x"]];
    }else if ([_fromString isEqualToString:@"条线发布动态"]) {
        [conditionsBackImageView setImage:[UIImage imageNamed:@"tiaoxianfabudongtai@2x"]];
    }else if ([_fromString isEqualToString:@"主题发布动态"]) {
        conditionsBackImageView.hidden = YES;
    }
}
#pragma mark - 发布到机构动态
- (void)clicksendInstitutionsButton
{
    if ([sendInstitutionsButton.titleLabel.text isEqualToString:@"中"]) {
        [sendInstitutionsButton setBackgroundImage:[UIImage imageNamed:@"gouxuan1@2x"] forState:UIControlStateNormal];
        [sendInstitutionsButton setTitle:@"不中" forState:UIControlStateNormal];
        sendInstitutionStr = @"0";
    }else if ([sendInstitutionsButton.titleLabel.text isEqualToString:@"不中"])
    {
        [sendInstitutionsButton setBackgroundImage:[UIImage imageNamed:@"gouxuan2@2x"] forState:UIControlStateNormal];
        [sendInstitutionsButton setTitle:@"中" forState:UIControlStateNormal];
        sendInstitutionStr = @"1";
    }
    
    
}
#pragma mark - 发布到条线动态
- (void)clicksendLineButton
{
    if ([sendLineButton.titleLabel.text isEqualToString:@"中"]) {
        [sendLineButton setBackgroundImage:[UIImage imageNamed:@"gouxuan1@2x"] forState:UIControlStateNormal];
        [sendLineButton setTitle:@"不中" forState:UIControlStateNormal];
        sendLineStr = @"0";
    }else if ([sendLineButton.titleLabel.text isEqualToString:@"不中"])
    {
        [sendLineButton setBackgroundImage:[UIImage imageNamed:@"gouxuan2@2x"] forState:UIControlStateNormal];
        [sendLineButton setTitle:@"中" forState:UIControlStateNormal];
        sendLineStr = @"1";
    }
}

#pragma mark - 返回
- (void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 发送
- (void)ButtonClicked
{
    
    
    NSString *picStr = @"";
    NSString *contentStr = @"";
    if ([contectView.text length]>0) {
        contentStr = contectView.text;
    }
    else
    {
        contentStr = @"";
    }
    
    if (pictureUrlArray.count>0) {
        NSString *picOne = pictureUrlArray[0];
        picStr = [NSString stringWithFormat:@"%@",picOne];
        
    }
    
    for (int i = 1; i< pictureUrlArray.count; i++) {
        NSString *picTwo = pictureUrlArray[i];
        
        picStr = [NSString stringWithFormat:@"%@,%@",picStr,picTwo];
        
    }
    
    
    
    if ([contentStr length]==0) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"请填写内容"];
    }else
    {
        
        //发表动态
        [BCHTTPRequest PostWithFromDynamicMessage:_fromString WithPicture:picStr WithInstitutionID:self.myInstitutionID WithContent:contectView.text WithIsFriendsCircle:sendInstitutionStr WithIsDepartment:sendLineStr usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
                if (isSuccess == YES) {
                    
                    if ([_fromString isEqualToString:@"机构发布动态"]) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"InstitutionReload" object:nil];
                    }else if ([_fromString isEqualToString:@"条线发布动态"]) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"LineReload" object:nil];
                    }else if ([_fromString isEqualToString:@"主题发布动态"]) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"ThemeReload" object:nil];
                    }
                    
                   [self.navigationController popViewControllerAnimated:YES];
                    
                }
            }];

        
    }

    
}
//取消键盘
- (void) handleBackgroundTap:(UITapGestureRecognizer*)sender
{
    [contectView resignFirstResponder];
    
}

//输入框要编辑的时候
- (void)textChanged:(NSNotification *)notification
{
    if ([[contectView text] length] == 0) {
        [[contectView viewWithTag:999] setAlpha:1];
    }
    else {
        [[contectView viewWithTag:999] setAlpha:0];
    }
    
}
#pragma marks - pictureWall
-(void)addPictureToPictureWall
{
    //图片背景
    photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 288/2, 640/2, 142/2)];
    photoImageView.userInteractionEnabled = YES;
    photoImageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:photoImageView];
    
    
    for (int i=0; i<(pictureArray.count + 1); i++) {
        
        if (i==pictureArray.count) {
            //选择图片的按钮
            if (i == 4) {
                pictureButton.hidden = YES;
            }else
            {
                pictureButton.hidden = NO;
                pictureButton = [UIButton buttonWithType:UIButtonTypeCustom];
                pictureButton.frame = CGRectMake(10+(142/2)*(i%4), 0, 132/2, 132/2);
                [pictureButton.layer setMasksToBounds:YES];
                [pictureButton.layer setCornerRadius:5.0f];
                [pictureButton setBackgroundImage:[UIImage imageNamed:@"tianjiaqunliao@2x"] forState:UIControlStateNormal];
                [pictureButton addTarget:self action:@selector(clickPictureButton) forControlEvents:UIControlEventTouchUpInside];
                [photoImageView addSubview:pictureButton];
            }
           
        }else
        {
            imagesView = [[UIImageView alloc]initWithFrame:CGRectMake(10+(142/2)*(i%4), 0, 132/2, 132/2)];
            UIImage * image = (UIImage*)[pictureArray objectAtIndex:i];
            [imagesView setImage:image];
            
            imagesView.userInteractionEnabled = YES;
            [imagesView.layer setMasksToBounds:YES];
            [imagesView.layer setCornerRadius:3.0f];
            [photoImageView addSubview:imagesView];
            
            deleagtePictureButton = [UIButton buttonWithType:UIButtonTypeCustom];
            deleagtePictureButton.frame = CGRectMake(-10/2, 0, 50/2, 50/2);
            //deleagtePictureButton.backgroundColor = [UIColor greenColor];
            [deleagtePictureButton setBackgroundImage:[UIImage imageNamed:@"shanchutupian@2x"] forState:UIControlStateNormal];
            deleagtePictureButton.tag = 3000+i;
            [deleagtePictureButton addTarget:self action:@selector(delegatePicture:) forControlEvents:UIControlEventTouchUpInside];
            [imagesView addSubview:deleagtePictureButton];
            
        }
        
       
        
        
    }
    
    NSLog(@"picpath%@",pictureUrlArray);
    
}
#pragma mark - 删除图片
-(void)delegatePicture:(UIButton *)button
{
    NSLog(@"删除");
    
    [pictureArray removeObjectAtIndex:button.tag-3000];
    [pictureUrlArray removeObjectAtIndex:button.tag-3000];
    
    [photoImageView removeFromSuperview];
    NSLog(@"图片数量%d",pictureArray.count);
    [self addPictureToPictureWall];
}


-(void)clickPictureButton
{
    [contectView resignFirstResponder];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择",@"拍照", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [actionSheet showInView:self.view];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [contectView resignFirstResponder];
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
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:^{
        }];
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
    
    [BCHTTPRequest PostWithFromDynamicPhoto:_fromString WithPicture:image usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            [pictureArray addObject:image];
            
            [pictureUrlArray addObject:resultDic[@"id"]];
            
            [photoImageView removeFromSuperview];
            
            [self addPictureToPictureWall];
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
