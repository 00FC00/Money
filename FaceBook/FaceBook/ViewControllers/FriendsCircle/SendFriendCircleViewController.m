//
//  SendFriendCircleViewController.m
//  FaceBook
//
//  Created by fengshaohui on 14-5-26.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "SendFriendCircleViewController.h"
#import "DMCAlertCenter.h"
#import "BCHTTPRequest.h"
#import "OtherNotice.h"
#import "OtherNoticeObject.h"
@interface SendFriendCircleViewController ()
{
    UIScrollView *backScrollView;
    //拍照按钮背景
    UIImageView *takePhotoBackImageView;
    //相册
    UIButton *photoAlbumButton;
    //拍照
    UIButton *cameraButton;
    NSMutableArray *pictureArray;
    NSMutableArray *pictureIdArray;
    NSMutableArray *pictureUrlArray;
    
    //照片墙
    UIImageView *pictureBackImageView;
    //照片
    UIImageView *pictureImageView;
    //删除照片按钮
    UIButton *deleteButton;
    UILabel *markcontectTitleLabel;
    
    //输入框背景
    UIImageView *contectBackImageView;
    //输入框
    UITextView *contectView;
    UILabel *placeHolderLabel;
    //取消编辑按钮
    UIButton *cancleButton;
    //完成编辑按钮
    UIButton *finishButton;
    
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
    
    NSString *isPaid;

    
}
@end

@implementation SendFriendCircleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        pictureArray = [[NSMutableArray alloc]initWithCapacity:100];
        pictureIdArray = [[NSMutableArray alloc]initWithCapacity:100];
        pictureUrlArray = [[NSMutableArray alloc]initWithCapacity:100];
        
        sendInstitutionStr = @"2";
        sendLineStr = @"2";
        
        isPaid = [[NSString alloc]init];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //导航栏
    self.view.backgroundColor = [UIColor whiteColor];
    if (IS_IOS_7) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios7"] forBarMetrics:UIBarMetricsDefault];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios6"] forBarMetrics:UIBarMetricsDefault];
    }
    self.title = @"发布";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 22, 40, 40);
    [backButton setBackgroundImage:[UIImage imageNamed:@"login_backButton@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //[self.navigationController.view addSubview:backButton];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;
    
    otherNotice = [[OtherNotice alloc]init];
    [otherNotice createDataBase];
    
    otherObj = [otherNotice getAllOthersRemindStyleWithNumber:@"1"];
    
    //背景
    backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-64)];
    backScrollView.backgroundColor = [UIColor clearColor];
    backScrollView.delegate = self;
    backScrollView.showsHorizontalScrollIndicator = NO;
    [backScrollView setContentSize:CGSizeMake(0, [[UIScreen mainScreen] bounds].size.height)];
    backScrollView.userInteractionEnabled = YES;
    [self.view addSubview:backScrollView];
    
    //拍照
    UILabel *markPhotoTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(52/2, 28/2, 100, 38/2)];
    markPhotoTitleLabel.backgroundColor = [UIColor clearColor];
    markPhotoTitleLabel.textAlignment = NSTextAlignmentLeft;
    markPhotoTitleLabel.textColor = [UIColor blackColor];
    markPhotoTitleLabel.font = [UIFont systemFontOfSize:17];
    markPhotoTitleLabel.text = @"拍点什么";
    [backScrollView addSubview:markPhotoTitleLabel];
    
    //拍照按钮背景takePhotoBackImageView;
    takePhotoBackImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 40, 600/2, 140/2)];
    [takePhotoBackImageView setImage:[UIImage imageNamed:@"xiangjibeijing@2x"]];
    takePhotoBackImageView.userInteractionEnabled = YES;
    takePhotoBackImageView.backgroundColor = [UIColor clearColor];
    [backScrollView addSubview:takePhotoBackImageView];
    
    //相册photoAlbumButton;
    photoAlbumButton = [UIButton buttonWithType:UIButtonTypeCustom];
    photoAlbumButton.frame = CGRectMake(10, 9, 100/2, 104/2);
    photoAlbumButton.backgroundColor = [UIColor clearColor];
    [photoAlbumButton setBackgroundImage:[UIImage imageNamed:@"xiangce@2x"] forState:UIControlStateNormal];
    photoAlbumButton.tag = 3001;
    [photoAlbumButton addTarget:self action:@selector(clickPhotosButton:) forControlEvents:UIControlEventTouchUpInside];
    [takePhotoBackImageView addSubview:photoAlbumButton];
    
    //拍照cameraButton;
    cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cameraButton.frame = CGRectMake(140/2, 9, 100/2, 104/2);
    cameraButton.backgroundColor = [UIColor clearColor];
    [cameraButton setBackgroundImage:[UIImage imageNamed:@"paizhao@2x"] forState:UIControlStateNormal];
    cameraButton.tag = 3002;
    [cameraButton addTarget:self action:@selector(clickPhotosButton:) forControlEvents:UIControlEventTouchUpInside];
    [takePhotoBackImageView addSubview:cameraButton];
    
    //照片背景
    pictureBackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, takePhotoBackImageView.frame.origin.y+takePhotoBackImageView.frame.size.height+10, 600/2, 1)];
    pictureBackImageView.backgroundColor = [UIColor clearColor];
    pictureBackImageView.userInteractionEnabled = YES;
    [backScrollView addSubview:pictureBackImageView];
    
    markcontectTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(52/2, pictureBackImageView.frame.origin.y+pictureBackImageView.frame.size.height+5, 100, 38/2)];
    markcontectTitleLabel.backgroundColor = [UIColor clearColor];
    markcontectTitleLabel.textAlignment = NSTextAlignmentLeft;
    markcontectTitleLabel.textColor = [UIColor blackColor];
    markcontectTitleLabel.font = [UIFont systemFontOfSize:17];
    markcontectTitleLabel.text = @"写点什么";
    [backScrollView addSubview:markcontectTitleLabel];
    
    //输入框背景contectBackImageView;
    contectBackImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, markcontectTitleLabel.frame.origin.y+markcontectTitleLabel.frame.size.height+9, 600/2, 244/2)];
    [contectBackImageView setImage:[UIImage imageNamed:@"fabiaoshuoshuokuang@2x"]];
    contectBackImageView.userInteractionEnabled = YES;
    contectBackImageView.backgroundColor = [UIColor clearColor];
    [backScrollView addSubview:contectBackImageView];
    
    //输入框contectView; ////placeHolderLabel;
    contectView = [[UITextView alloc] initWithFrame:CGRectMake(8, 9, 568/2, 220/2)];
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

    //取消编辑按钮cancleButton;
    cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleButton.frame = CGRectMake(20/2, contectBackImageView.frame.origin.y+contectBackImageView.frame.size.height+20, 280/2, 72/2);
    cancleButton.backgroundColor = [UIColor clearColor];
    [cancleButton setBackgroundImage:[UIImage imageNamed:@"quxiaobianji@2x"] forState:UIControlStateNormal];
    [cancleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleButton addTarget:self action:@selector(clickcancleButton) forControlEvents:UIControlEventTouchUpInside];
    [backScrollView addSubview:cancleButton];
    
    //完成编辑按钮finishButton;
    finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    finishButton.frame = CGRectMake(340/2, contectBackImageView.frame.origin.y+contectBackImageView.frame.size.height+20, 280/2, 72/2);
    finishButton.backgroundColor = [UIColor clearColor];
    [finishButton setBackgroundImage:[UIImage imageNamed:@"wanchengbianji@2x"] forState:UIControlStateNormal];
    [finishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [finishButton setTitle:@"完成" forState:UIControlStateNormal];
    [finishButton addTarget:self action:@selector(clickfinishButton) forControlEvents:UIControlEventTouchUpInside];
    [backScrollView addSubview:finishButton];
    
    //发布条件选项conditionsBackImageView;
    conditionsBackImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, cancleButton.frame.origin.y+cancleButton.frame.size.height+20, 420/2, 140/2)];
    [conditionsBackImageView setImage:[UIImage imageNamed:@"fabuxuanxiangkuang@2x"]];
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
}
#pragma mark - 发布到机构动态
- (void)clicksendInstitutionsButton
{
    if ([sendInstitutionsButton.titleLabel.text isEqualToString:@"中"]) {
        [sendInstitutionsButton setBackgroundImage:[UIImage imageNamed:@"gouxuan1@2x"] forState:UIControlStateNormal];
        [sendInstitutionsButton setTitle:@"不中" forState:UIControlStateNormal];
        sendInstitutionStr = @"1";
    }else if ([sendInstitutionsButton.titleLabel.text isEqualToString:@"不中"])
    {
        [sendInstitutionsButton setBackgroundImage:[UIImage imageNamed:@"gouxuan2@2x"] forState:UIControlStateNormal];
        [sendInstitutionsButton setTitle:@"中" forState:UIControlStateNormal];
        sendInstitutionStr = @"2";
    }
    
    
}
#pragma mark - 发布到条线动态
- (void)clicksendLineButton
{
    if ([sendLineButton.titleLabel.text isEqualToString:@"中"]) {
        [sendLineButton setBackgroundImage:[UIImage imageNamed:@"gouxuan1@2x"] forState:UIControlStateNormal];
        [sendLineButton setTitle:@"不中" forState:UIControlStateNormal];
        sendLineStr = @"1";
    }else if ([sendLineButton.titleLabel.text isEqualToString:@"不中"])
    {
        [sendLineButton setBackgroundImage:[UIImage imageNamed:@"gouxuan2@2x"] forState:UIControlStateNormal];
        [sendLineButton setTitle:@"中" forState:UIControlStateNormal];
        sendLineStr = @"2";
    }
}
#pragma mark - 取消编辑
- (void)clickcancleButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 完成编辑
- (void)clickfinishButton
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
    
    //    if (pictureIdArray.count == 0) {
    //        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"请选择照片或填写内容"];
    //    }
    
    if (pictureIdArray.count>0) {
        NSString *picOne = pictureIdArray[0];
        picStr = [NSString stringWithFormat:@"%@",picOne];
        
    }
    
    for (int i = 1; i< pictureIdArray.count; i++) {
        NSString *picTwo = pictureIdArray[i];
        //        receivedChatStr = [NSString stringWithFormat:@"%@,%d",receivedChatStr,[NSString stringWithFormat:@"%d",receivefriends.friendId]];
        
        picStr = [NSString stringWithFormat:@"%@,%@",picStr,picTwo];
        
    }
    
    
    
    if ([picStr length]==0 && [contentStr length]==0) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"请选择照片或填写内容"];
    }else
    {
        [BCHTTPRequest PostSendFriendsCircleMessageWithPictureID:picStr WithConten:contentStr WithInstitution:sendInstitutionStr WithDepartment:sendLineStr usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
                [self.navigationController popViewControllerAnimated:YES];
                //创建通知，刷新朋友圈
                [[NSNotificationCenter defaultCenter] postNotificationName:@"FshFriendCircleList" object:nil];
                
                
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

- (void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 选择相册/拍照
- (void)clickPhotosButton:(UIButton *)sender
{
    
    if (pictureArray.count < 4) {
        
        UIImagePickerController * picker = [[UIImagePickerController alloc]init];
        
        picker.delegate = self;
        picker.allowsEditing = NO;  //是否可编辑
        
        if (sender.tag == 3001) {
            //相册
            isPaid = @"0";
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:^{
            }];
        }else if (sender.tag == 3002) {
            //拍照
            isPaid = @"1";
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:^{
            }];
        }
        
    }else
    {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"您最多能上传4张图片"];
    }
    
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //得到图片
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *mimage = [self fixOrientation:image];
    
    if ([otherObj.isSavePhoto isEqualToString:@"1"] && [isPaid isEqualToString:@"1"]) {
    SEL selectorToCall = @selector(imageWasSavedSuccessfully:didFinishSavingWithError:contextInfo:);
    UIImageWriteToSavedPhotosAlbum(mimage, self,selectorToCall, NULL);
    }
    [BCHTTPRequest PostTheFriendCirclePicturesWithImage:mimage usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
    
        if (isSuccess == YES) {
            
            [pictureArray addObject:mimage];
            
            [pictureUrlArray addObject:resultDic[@"path"]];
            
            [pictureIdArray addObject:resultDic[@"id"]];
            
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
- (void)addPictureToPictureWall
{
    [pictureBackImageView removeFromSuperview];
    //照片墙pictureBackImageView;
    
    pictureBackImageView = [[UIImageView alloc] init];
    pictureBackImageView.backgroundColor = [UIColor clearColor];
    
    pictureBackImageView.userInteractionEnabled = YES;
    [backScrollView addSubview:pictureBackImageView];
    
    
    NSLog(@"图片数量1111%d",pictureArray.count);
    //照片pictureImageView;
    //删除照片按钮deleteButton;
    //图片背景
    if (pictureArray.count > 0) {
        pictureBackImageView.frame = CGRectMake(10, takePhotoBackImageView.frame.origin.y+takePhotoBackImageView.frame.size.height+10, 600/2, 75);
        for (int i=0; i< pictureArray.count; i++) {
            
            
            pictureImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5+75*(i%4), 0, 70, 70)];
            UIImage * image = (UIImage*)[pictureArray objectAtIndex:i];
            [pictureImageView setImage:image];
            
            pictureImageView.userInteractionEnabled = YES;
            [pictureImageView.layer setMasksToBounds:YES];
            [pictureImageView.layer setCornerRadius:3.0f];
            [pictureBackImageView addSubview:pictureImageView];
            
            deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
            deleteButton.frame = CGRectMake(-10/2, 0, 50/2, 50/2);
            //deleteButton.backgroundColor = [UIColor greenColor];
            [deleteButton setBackgroundImage:[UIImage imageNamed:@"shanchutupian@2x"] forState:UIControlStateNormal];
            deleteButton.tag = 5000+i;
            [deleteButton addTarget:self action:@selector(deletePicture:) forControlEvents:UIControlEventTouchUpInside];
            [pictureImageView addSubview:deleteButton];
            
            
            
            
        }
        
    }else
    {
        NSLog(@"33333");
        pictureBackImageView.frame = CGRectMake(10, takePhotoBackImageView.frame.origin.y+takePhotoBackImageView.frame.size.height+10, 600/2, 1);
    }
    markcontectTitleLabel.frame = CGRectMake(52/2, pictureBackImageView.frame.origin.y+pictureBackImageView.frame.size.height+5, 100, 38/2);
    contectBackImageView.frame = CGRectMake(10, markcontectTitleLabel.frame.origin.y+markcontectTitleLabel.frame.size.height+9, 600/2, 244/2);
    cancleButton.frame = CGRectMake(20/2, contectBackImageView.frame.origin.y+contectBackImageView.frame.size.height+20, 280/2, 72/2);
    finishButton.frame = CGRectMake(340/2, contectBackImageView.frame.origin.y+contectBackImageView.frame.size.height+20, 280/2, 72/2);
    conditionsBackImageView.frame = CGRectMake(15, cancleButton.frame.origin.y+cancleButton.frame.size.height+20, 420/2, 140/2);
       
    
    //NSLog(@"picpath%@",pictureUrlArray);
    
}
#pragma mark - 删除图片
-(void)deletePicture:(UIButton *)button
{
    NSLog(@"删除");
    
    [pictureArray removeObjectAtIndex:button.tag-5000];
    [pictureUrlArray removeObjectAtIndex:button.tag-5000];
    [pictureIdArray removeObjectAtIndex:button.tag-5000];
    
    
    
    NSLog(@"图片数量%d",pictureArray.count);
    
    [self addPictureToPictureWall];

}
#pragma mark - 处理图片
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
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
