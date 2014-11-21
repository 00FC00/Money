//
//  FriendsCircleViewController.m
//  FaceBook
//
//  Created by HMN on 14-4-28.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "FriendsCircleViewController.h"
#import "AppDelegate.h"

#import "SettingViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AFNetworking.h"
#import "DMCAlertCenter.h"
#import "BCHTTPRequest.h"
#import "FriendsCircleCell.h"
#import "AttributedLabel.h"
#import "SendFriendCircleViewController.h"
#import "PictureDetialsViewController.h"
#import "OtherFriendsCircleViewController.h"
#import "OtherNotice.h"
#import "OtherNoticeObject.h"
#import "UIImageView+WebCache.h"
//#import "UIImageView+MJWebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "RTLabel.h"
#import "SUNViewController.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "MySweepViewController.h"
#import "LoadingIndicatorView.h"

@interface FriendsCircleViewController ()<RTLabelDelegate>
{
    LoadingIndicatorView * loadview;
    //朋友圈背景
    UIImageView *backImageView;
    //头像
    UIImageView *markheadImageView;
    UIImageView *headerImageView;
    //编辑
    UIButton *myEditButton;
    //名字
    UILabel *myNameLabel;
    
    //每条动态的图片数组
    NSMutableArray *pictureArray;
    //朋友圈
    NSMutableArray *friendArray;
    //评论数组
    int commentHeight;
    NSMutableArray *commentArray;
    ///赞数组
    NSMutableArray * praiseArray;
    
    //输入框
    UIImageView *replyImageView;
    UIButton *replyButton;
    UITextView *replyField;
    UILabel *placeHolderLabel;
    
    OtherNotice *otherNotice;
    OtherNoticeObject *otherObj;
    
    NSString *isPaim;
    
    OHAttributedLabel * test_label;
    RTLabel * test_rtlabel;
}
@end

@implementation FriendsCircleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        pageNumber = 1;
        pictureArray = [[NSMutableArray alloc]initWithCapacity:200];
        commentArray = [[NSMutableArray alloc]initWithCapacity:300];
        praiseArray = [[NSMutableArray alloc] initWithCapacity:300];
        isReplyMe = @"other";
        isPaim = [[NSString alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:219.0f/255.0f green:219.0f/255.0f blue:219.0f/255.0f alpha:1.0];
    
    if (IS_IOS_7) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios7"] forBarMetrics:UIBarMetricsDefault];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios6"] forBarMetrics:UIBarMetricsDefault];
    }
    self.title = @"朋友圈";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame = CGRectMake(0, 22, 40, 40);
    [menuButton setBackgroundImage:[UIImage imageNamed:@"caidan@2x"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(menuButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //[self.navigationController.view addSubview:backButton];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:menuButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;
    
    
    UIBarButtonItem * space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = -10;
    
    //设置
    UIButton *setButton = [UIButton buttonWithType:UIButtonTypeCustom];
    setButton.frame = CGRectMake(526/2,0, 60/2,88/2);
    [setButton setImage:[UIImage imageNamed:@"barbuttonicon_Camera"] forState:UIControlStateNormal];
    //[setButton setTitle:@"登录" forState:UIControlStateNormal];
    //setButton.titleLabel.font = [UIFont systemFontOfSize:15];
    //[setButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [setButton addTarget:self action:@selector(clickMyEditButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:setButton];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:space,rightbuttonitem,nil];
    
    otherNotice = [[OtherNotice alloc]init];
    [otherNotice createDataBase];
    
    otherObj = [otherNotice getAllOthersRemindStyleWithNumber:@"1"];
    
    //朋友圈列表
    friendsCircleTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-64) style:UITableViewStylePlain];
    friendsCircleTableView.backgroundColor = [UIColor clearColor];
    friendsCircleTableView.delegate = self;
    friendsCircleTableView.dataSource = self;
    friendsCircleTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width,305)];
    friendsCircleTableView.tableHeaderView.backgroundColor = [UIColor whiteColor];
    if (IS_IOS_7) {
        friendsCircleTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    [self.view addSubview:friendsCircleTableView];
    
    loadview=[[LoadingIndicatorView alloc]initWithFrame:CGRectMake(0, 900, 320, 40)];
    friendsCircleTableView.tableFooterView = loadview;
    [loadview startLoading];
    //获取数据
    [self getData:pageNumber];
    
    [self createHeaderView];
//    [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.0f];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"FshFriendCircleList" object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        //获取数据
        [self getData:pageNumber];
        
    }];
    
    
    

}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_refreshHeaderView)
	{
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
	
	if (_refreshFooterView)
	{
        [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    }
    
    if (scrollView == friendsCircleTableView) {
        
        [replyField resignFirstResponder];
        [UIView animateWithDuration:0.3 animations:^{
            replyImageView.frame = CGRectMake(0, self.view.frame.size.height, [[UIScreen mainScreen] bounds].size.width, 49);
        }];
        
        [self reloadoperationButton];
        
    }

}

#pragma mark - 菜单
- (void)menuButtonClicked
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
#pragma mark - 设置
- (void)setButtonClicked
{
    SettingViewController *settingVC = [[SettingViewController alloc]init];
    [self.navigationController pushViewController:settingVC animated:YES];
}
#pragma mark - 发布朋友圈
- (void)clickMyEditButton
{
    NSLog(@"发布朋友圈");
    SendFriendCircleViewController *sendFriendCircleVC = [[SendFriendCircleViewController alloc]init];
    [self.navigationController pushViewController:sendFriendCircleVC animated:YES];
    
}
- (void) changeimage:(UITapGestureRecognizer*)sender
{
    photoActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    [photoActionSheet showInView:self.view];
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    UIImagePickerController * picker = [[UIImagePickerController alloc]init];
       picker.delegate = self;
    picker.allowsEditing = NO;  //是否可编辑
    
    if (buttonIndex == 0) {
        //拍照
        isPaim = @"1";
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:^{
        }];
    }else if (buttonIndex == 1) {
        //相册
        isPaim = @"0";
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:^{
        }];
    }
    
    
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //得到图片
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if ([otherObj.isSavePhoto isEqualToString:@"1"] && [isPaim isEqualToString:@"1"]) {
        SEL selectorToCall = @selector(imageWasSavedSuccessfully:didFinishSavingWithError:contextInfo:);
        UIImageWriteToSavedPhotosAlbum(image, self,selectorToCall, NULL);
    }

    [BCHTTPRequest PostChangeTheFriendCircleBackPicturesWithImage:image usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            [backImageView setImage:image];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return friendArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    pictureArray = friendArray[indexPath.row][@"pictures"];
    
    int K;
    if(pictureArray.count % 3 == 0)
    {
        K = pictureArray.count / 3;
    }else
    {
        K = 1+(pictureArray.count / 3);
    }
    
    
    
    CGFloat picHeight;
    picHeight = 84*K+26/2;
    
    //内容
    CGFloat contectHeight;
    NSString *str1 = friendArray[indexPath.row][@"content"];
    
    if (!test_label)
    {
        test_label = [[OHAttributedLabel alloc]initWithFrame:CGRectMake(60,40,492/2,0)];
        test_label.font = [UIFont systemFontOfSize:15];
        test_label.lineBreakMode = NSLineBreakByCharWrapping;
    }else
    {
        test_label.frame = CGRectMake(60,40,492/2,0);
    }
    if (str1.length != 0) {
        [OHLableHelper creatAttributedText:str1 Label:test_label OHDelegate:self WithWidht:18 WithHeight:18 WithLineBreak:NO];
    }
    
    contectHeight = test_label.frame.size.height+5;
    //评论按钮38/2
    //评论高度
    
    commentArray = friendArray[indexPath.row][@"comments"];
    CGFloat mycommentHeight = 13;
    if (commentArray.count > 0) {
        for (int h = 0; h<[commentArray count]; h++)
        {
            //名字
            NSString *commentString = [[NSString alloc]init];
            if ([commentArray[h][@"to_name"] isEqualToString:commentArray[h][@"from_name"]]) {
                commentString = [NSString stringWithFormat:@"%@:%@",commentArray[h][@"from_name"],commentArray[h][@"content"]];
            }else
            {
                commentString = [NSString stringWithFormat:@"%@回复%@:%@",commentArray[h][@"from_name"],commentArray[h][@"to_name"],commentArray[h][@"content"]];
            }
            
            CGSize commentSize;
            
            if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7)
            {
                NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
                commentSize = [commentString boundingRectWithSize:CGSizeMake(232, 1000000) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
            }else
            {
                //***********ios6的方法
                commentSize = [commentString sizeWithFont:[UIFont systemFontOfSize:14]constrainedToSize:CGSizeMake(232, 1000000) lineBreakMode:NSLineBreakByWordWrapping];
            }
            mycommentHeight += commentSize.height;
        }
        mycommentHeight += 19;
    }else
    {
        mycommentHeight = 0;
    }
    
    
    ///赞高度
    praiseArray = friendArray[indexPath.row][@"praises"];
    if (praiseArray.count > 0)
    {
        if (commentArray.count == 0)
        {
            mycommentHeight = 5;
        }else
        {
            mycommentHeight -= 19;
        }
        
        NSString * praise_string = [self returnZanStringWith:nil WithTotalNum:nil];
        
        if (!test_rtlabel) {
            test_rtlabel = [[RTLabel alloc] initWithFrame:CGRectMake(64,0,232,0)];
            test_rtlabel.font = [UIFont systemFontOfSize:14];
            test_rtlabel.lineBreakMode = NSLineBreakByCharWrapping;
            test_rtlabel.lineSpacing = 2;
            test_rtlabel.imageWidth = 15;
            test_rtlabel.imageHeight = 15;
            test_rtlabel.rt_color = @"#030303";
        }else
        {
            test_rtlabel.frame = CGRectMake(64,0,232,0);
        }
        test_rtlabel.text = praise_string;
        CGSize zanOptimusize = [test_rtlabel optimumSize];
        
        mycommentHeight += zanOptimusize.height+22;
    }
    
    if ([str1 length ]== 0) {
        
        return 49+picHeight+4+38/2+mycommentHeight+15;
    }
    return 49+picHeight+contectHeight+mycommentHeight+20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimepleNewsListcell = @"SimpleNewsListcells";
    FriendsCircleCell *cell = [tableView dequeueReusableCellWithIdentifier:SimepleNewsListcell];
    if (cell == nil) {
        cell = [[FriendsCircleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimepleNewsListcell];
    }
    [cell.messageLabel setAttString:[[NSAttributedString alloc] initWithString:@""] withImages:nil];
    cell.messageLabel.frame = CGRectMake(60,40,492/2,0);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //头像背景
    [cell.marksImageView setImage:[UIImage imageNamed:@"metouxiangbeijing@2x"]];
    //头像
    [cell.userImageView sd_setImageWithURL:[NSURL URLWithString:friendArray[indexPath.row][@"pic"]] placeholderImage:[UIImage imageNamed:@"ceshi@2x"]];
    //[cell.userImageView setImage:[UIImage imageNamed:@"ceshi@2x"]];
    [cell.userImageButton setTag:5000+indexPath.row];
    [cell.userImageButton addTarget:self action:@selector(clickUserImageButton:) forControlEvents:UIControlEventTouchUpInside];
    //名字
    cell.userNameLabel.text = friendArray[indexPath.row][@"name"];
    //日期
    cell.postDateTimeLabel.text = [OHLableHelper timestamp:friendArray[indexPath.row][@"add_time"]];
    
    //分割线
    [cell.horizontalLineImageView setImage:[UIImage imageNamed:@"xiahuaxian@2x"]];
//    //拨号按钮
//    [cell.callPhoneButton setBackgroundColor:[UIColor clearColor]];
//    [cell.callPhoneButton setBackgroundImage:[UIImage imageNamed:@"celldadianhua2@2x"] forState:UIControlStateNormal];
//    cell.callPhoneButton.tag =10000+indexPath.row;
//    [cell.callPhoneButton addTarget:self action:@selector(clickCallPhoneButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //说说内容
    cell.messageLabel.numberOfLines = 0;
    NSString *str1 = friendArray[indexPath.row][@"content"];
    CGSize size1;
    //***********ios7的方法
//    if (IS_IOS_7)
//    {
//        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:15]};
//        size1 = [str1 boundingRectWithSize:CGSizeMake(492/2, 1000) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
//    }else
//    {
//        //***********ios6的方法
//        size1 = [str1 sizeWithFont:[UIFont systemFontOfSize:15]constrainedToSize:CGSizeMake(492/2,1000) lineBreakMode:NSLineBreakByWordWrapping];
//    }
//
    
    NSLog(@"上面高度%f",cell.photoBackImageView.frame.origin.y+cell.photoBackImageView.frame.size.height);
    if ([str1 length]==0) {
        size1.height = 0;
    }else
    {
        [OHLableHelper creatAttributedText:str1 Label:cell.messageLabel OHDelegate:self WithWidht:18 WithHeight:18 WithLineBreak:NO];
    }
    
    //********************
//    cell.messageLabel.frame =CGRectMake(60,40,size1.width,size1.height);
//    cell.messageLabel.text = str1;

    //根据图片的数组加载图片
    for (UIView * sview in cell.photoBackImageView.subviews) {
        if (sview.tag >= 10000000) {
            [sview removeFromSuperview];
        }
    }
    
    //照片墙背景
    pictureArray = friendArray[indexPath.row][@"pictures"];
    if (pictureArray.count > 0) {
        for (NSInteger i = 0; i< pictureArray.count; i++) {
            UIImageView * commentsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(1+83*(i%3), 84*(i/3), 148/2, 148/2)];
            [commentsImageView sd_setImageWithURL:[NSURL URLWithString:[pictureArray objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"quantupianbeijing@2x"]];
            commentsImageView.tag = 10000000+i;
            //[commentsImageView setImage:[UIImage imageNamed:@"lizi@2x.png"]];
            commentsImageView.userInteractionEnabled = YES;
            commentsImageView.clipsToBounds = YES;
            
            commentsImageView.contentMode = UIViewContentModeScaleAspectFill;

            [cell.photoBackImageView addSubview:commentsImageView];
            
            
            UIButton *picturesButton = [UIButton buttonWithType:UIButtonTypeCustom];
            picturesButton .frame = CGRectMake(0, 0, 148/2, 148/2);
            picturesButton.tag = 300000+1000*indexPath.row+i;
            [picturesButton addTarget:self action:@selector(clickPicturesButton:) forControlEvents:UIControlEventTouchUpInside];
            [commentsImageView addSubview:picturesButton];

        }
    }else
    {
        for (UIView * sview in cell.photoBackImageView.subviews) {
            if (sview.tag >= 10000000) {
                [sview removeFromSuperview];
            }
        }
    }
    
    //发布内容
    
    int K;
    if(pictureArray.count % 3 == 0)
    {
        K = pictureArray.count / 3;
    }else
    {
        K = 1+(pictureArray.count / 3);
    }
    
    
    //图片背景
    cell.photoBackImageView.frame = CGRectMake(60, cell.messageLabel.frame.origin.y+cell.messageLabel.frame.size.height+5, 498/2, 84*K);
    
    
    
    
///****feng,sh_8-13_改朋友圈
    //操作按钮
    cell.operationButton.frame = CGRectMake(284, cell.photoBackImageView.frame.origin.y+ cell.photoBackImageView.frame.size.height+4, 50/2, 52/2);
    NSLog(@"阿牛的坐标%f",cell.photoBackImageView.frame.origin.y+ cell.photoBackImageView.frame.size.height+4);
    [cell.operationButton setTitle:@"隐藏" forState:UIControlStateNormal];
    [cell.operationButton setBackgroundImage:[UIImage imageNamed:@"AlbumOperateMore"] forState:UIControlStateNormal];
    [cell.operationButton setTag:2000+indexPath.row];
    [cell.operationButton addTarget:self action:@selector(clickOperationButton:) forControlEvents:UIControlEventTouchUpInside];
    
    ////操作框
    cell.operationBackImageView.frame = CGRectMake(280, cell.operationButton.frame.origin.y-7,0,40);
//    [cell.operationBackImageView setImage:[UIImage imageNamed:@"caozuokuang@2x"]];
    cell.operationBackImageView.tag = 5000+indexPath.row;
//    if ([cell.operationButton.titleLabel.text isEqualToString:@"显示"]) {
//        cell.operationBackImageView.hidden = NO;
//    }else
//    {
//        cell.operationBackImageView.hidden = YES;
//    }
    
    //评论
    cell.commentButton.tag = 7000+indexPath.row;
    [cell.commentButton setBackgroundImage:[UIImage imageNamed:@"pinglun_image"] forState:UIControlStateNormal];
    [cell.commentButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [cell.commentButton setTitle:@"隐" forState:UIControlStateNormal];
    [cell.commentButton addTarget:self action:@selector(clickCommentButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //赞
    cell.lovesButton.tag = 9000+indexPath.row;
    if ([friendArray[indexPath.row][@"love"] intValue]==0) {
        [cell.lovesButton setTitle:@"不赞" forState:UIControlStateNormal];
        [cell.lovesButton setBackgroundImage:[UIImage imageNamed:@"wei_zan_image"] forState:UIControlStateNormal];
    }else if ([friendArray[indexPath.row][@"love"] intValue]==1)
    {
        [cell.lovesButton setTitle:@"赞" forState:UIControlStateNormal];
        [cell.lovesButton setBackgroundImage:[UIImage imageNamed:@"yi_zan_image"] forState:UIControlStateNormal];
    }
    
    [cell.lovesButton addTarget:self action:@selector(clickLovesButtonButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //评论回复
//    AlbumInformationLikeHL@2x
    commentArray = friendArray[indexPath.row][@"comments"];
    commentHeight = 13;
    [cell.commentsBackImageView setImage:[[UIImage imageNamed:@"pinglunbeijing"]stretchableImageWithLeftCapWidth:100 topCapHeight:33]];
    
    for (UIView * sview in cell.commentsBackImageView.subviews) {
        if (sview.tag >= 20000000) {
            [sview removeFromSuperview];
        }
    }
    
    
    ///赞
    praiseArray = friendArray[indexPath.row][@"praises"];
    if (praiseArray.count > 0)
    {
        cell.commentsBackImageView.hidden = NO;
        NSString * praise_string = [self returnZanStringWith:nil WithTotalNum:nil];
        CGRect praiseFrame = CGRectMake(5,11,232,15);
        RTLabel * praise_label = [[RTLabel alloc] initWithFrame:praiseFrame];
        praise_label.font = [UIFont systemFontOfSize:14];
        praise_label.delegate = self;
        praise_label.lineBreakMode = NSLineBreakByCharWrapping;
        praise_label.lineSpacing = 2;
        praise_label.imageWidth = 14;
        praise_label.imageHeight = 14;
        praise_label.text = praise_string;
        praise_label.rt_color = @"#56689a";
        [cell.commentsBackImageView addSubview:praise_label];
        CGSize zanOptimusize = [praise_label optimumSize];
        praiseFrame.size.height = zanOptimusize.height+5;
        praise_label.frame = praiseFrame;
        commentHeight += praiseFrame.size.height;
        
        if (commentArray.count > 0)
        {
            UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0,11+praiseFrame.size.height+5,250,0.5)];
            lineView.backgroundColor = RGBCOLOR(221,222,223);
            [cell.commentsBackImageView addSubview:lineView];
        }
    }
    
    
    if (commentArray.count == 0) {
        
        if (praiseArray.count==0)
        {
            commentHeight = 0;
            cell.commentsBackImageView.hidden = YES;
        }
    }else
    {
        commentHeight += 5;
        cell.commentsBackImageView.hidden = NO;
        //评论内容
        for (int h = 0; h<[commentArray count]; h++) {
            //名字
            
            NSString *commentString = [[NSString alloc]init];
            if ([commentArray[h][@"to_name"] isEqualToString:commentArray[h][@"from_name"]]) {
                
                commentString = [NSString stringWithFormat:@"<a href=\"%@\">%@</a>:%@",commentArray[h][@"from_id"],commentArray[h][@"from_name"],commentArray[h][@"content"]];
                
            }else
            {
                commentString = [NSString stringWithFormat:@"<a href=\"%@\">%@</a>回复<a href=\"%@\">%@</a>:%@",commentArray[h][@"from_id"],commentArray[h][@"from_name"],commentArray[h][@"to_id"],commentArray[h][@"to_name"],commentArray[h][@"content"]];
            }
            
            CGRect labelFrame = CGRectMake(10,commentHeight,232,0);
            RTLabel * label = [[RTLabel alloc] initWithFrame:labelFrame];
            label.text = commentString;
            label.delegate = self;
            label.lineSpacing = 2;
            label.tag = 30000000+1000*(indexPath.row)+h;
            label.rt_color = @"#576a9a";
            label.textColor = RGBCOLOR(3,3,3);
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont systemFontOfSize:14];
            [cell.commentsBackImageView addSubview:label];
            
            CGSize optimuSize = [label optimumSize];
            labelFrame.size.height = optimuSize.height+3;
            label.frame = labelFrame;
            commentHeight += optimuSize.height+3;
            
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentLabelTap:)];
            [label addGestureRecognizer:tap];
            
            
            /*
            
            NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:commentString];
            // NSString *commentString = [NSString stringWithFormat:@"%@：%@",myArray[i][@"uname"],myArray[i][@"content"]];
            // NSLog(@"%d",[commentString length]);
            CGSize commentSize;
            UILabel *commentContentLabel = [[UILabel alloc]init];
            commentContentLabel.numberOfLines = 0;
            if (IS_IOS_7)
            {
                NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
                commentSize = [commentString boundingRectWithSize:CGSizeMake(232, 1000000) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
            }else
            {
                //***********ios6的方法
                commentSize = [commentString sizeWithFont:[UIFont systemFontOfSize:14]constrainedToSize:CGSizeMake(232, 1000000) lineBreakMode:NSLineBreakByWordWrapping];
            }
            
            
            commentContentLabel.frame = CGRectMake(10,commentHeight, commentSize.width, commentSize.height);
            
            
            [commentContentLabel setFont:[UIFont systemFontOfSize:14]];
            commentContentLabel.backgroundColor = [UIColor clearColor];
            //commentContentLabel.numberOfLines = 0;
            //            commentContentLabel.text = commentString;
            commentContentLabel.tag = 20000000+h;
            
            //NSLog(@"%@",commentString);
            
            if ([commentArray[h][@"to_name"] isEqualToString:commentArray[h][@"from_name"]]) {
                
                [attrTitle addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:86/255.0f green:104/255.0f blue:154/255.0f alpha:1] range:NSMakeRange(0, [commentArray[h][@"from_name"] length])];
            }else
            {
                
                
                [attrTitle addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:86/255.0f green:104/255.0f blue:154/255.0f alpha:1] range:NSMakeRange(0, [commentArray[h][@"from_name"] length])];
                [attrTitle addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:86/255.0f green:104/255.0f blue:154/255.0f alpha:1] range:NSMakeRange(([commentArray[h][@"from_name"] length])+2, [commentArray[h][@"to_name"] length])];
                
            }
            commentContentLabel.userInteractionEnabled = YES;
            //************************
            [commentContentLabel setAttributedText:attrTitle];
            [cell.commentsBackImageView addSubview:commentContentLabel];
            UIButton *mycommentsButton = [UIButton buttonWithType:UIButtonTypeCustom];
            mycommentsButton.frame = commentContentLabel.frame;
            mycommentsButton.backgroundColor = [UIColor clearColor];
            mycommentsButton.tag = 30000000+1000*(indexPath.row)+h;
            [mycommentsButton addTarget:self action:@selector(clickReplyCommentButton:) forControlEvents:UIControlEventTouchUpInside];
            [cell.commentsBackImageView addSubview:mycommentsButton];
            
            
            commentHeight += commentSize.height;
            */
        }
    }
    
    cell.commentsBackImageView.frame = CGRectMake(112/2, cell.operationButton.frame.origin.y+29,250, commentHeight+5);
    cell.postDateTimeLabel.frame = CGRectMake(60,cell.operationButton.frame.origin.y,cell.postDateTimeLabel.frame.size.width,cell.postDateTimeLabel.frame.size.height);
    //竖线
   // cell.verticalLineImageView.frame = CGRectMake(45, cell.marksImageView.frame.origin.y+cell.marksImageView.frame.size.height,2,49+cell.photoBackImageView.frame.size.height+13+cell.messageLabel.frame.size.height+29+commentHeight+10-12-cell.marksImageView.frame.size.height+5);
  //  [cell.verticalLineImageView setImage:[UIImage imageNamed:@"pengyouquanshuxian@2x"]];
    
    
    return cell;
}
#pragma mark - 回复别人评论
- (void)clickReplyCommentButton:(UIButton *)senders
{
    NSLog(@"------>%ld",senders.tag);
    isReplyMe = @"other";
    isCellNumber = (senders.tag-30000000)/1000;
    NSLog(@"%d",isCellNumber);
    NSLog(@"%@",friendArray[((senders.tag-30000000)/1000)][@"comments"][((senders.tag-30000000)%1000)]);
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = friendArray[((senders.tag-30000000)/1000)][@"comments"][((senders.tag-30000000)%1000)];
    NSLog(@"%@--%@",dic[@"from_id"],dic[@"from_name"]);
    //被评论人的id
    beReviewedID = dic[@"from_id"];
    //商机id
    businessID = friendArray[((senders.tag-30000000)/1000)][@"id"];
    if ([dic[@"from_id"] isEqualToString:[BCHTTPRequest getUserId]]) {
        NSLog(@"自己不能恢复自己");
    }else
    {
        [self showMyTextFieldKeyBoardWithRow:(senders.tag-30000000)/1000];
    }
}

-(void)commentLabelTap:(UITapGestureRecognizer *)senders
{
    NSLog(@"------>%d",senders.view.tag);
    isReplyMe = @"other";
    isCellNumber = (senders.view.tag-30000000)/1000;
    NSLog(@"%d",isCellNumber);
    NSLog(@"%@",friendArray[((senders.view.tag-30000000)/1000)][@"comments"][((senders.view.tag-30000000)%1000)]);
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = friendArray[((senders.view.tag-30000000)/1000)][@"comments"][((senders.view.tag-30000000)%1000)];
    NSLog(@"%@--%@",dic[@"from_id"],dic[@"from_name"]);
    //被评论人的id
    beReviewedID = dic[@"from_id"];
    //商机id
    businessID = friendArray[((senders.view.tag-30000000)/1000)][@"id"];
    if ([dic[@"from_id"] isEqualToString:[BCHTTPRequest getUserId]]) {
        NSLog(@"自己不能恢复自己");
    }else
    {
        [self showMyTextFieldKeyBoardWithRow:(senders.view.tag-30000000)/1000];
    }
}


#pragma mark - 点击头像
- (void)clickUserImageButton:(UIButton *)button
{
    /*
    //5000+indexPath.row]
    NSLog(@"--tag值----->%ld---------%@------",button.tag,friendArray[(button.tag-5000)][@"user_id"]);
    OtherFriendsCircleViewController *otherFriendsCircleVC = [[OtherFriendsCircleViewController alloc]init];
   NSString *toFid = friendArray[(button.tag-5000)][@"user_id"];
    NSString *myId = [BCHTTPRequest getUserId];
    NSLog(@"对方的id--->%@",toFid);
    NSLog(@"wo的id--->%@",myId);
//    if ([toFid isEqualToString:myId]) {
//        NSLog(@"不能点击自己头像");
//    }else
//    {
        otherFriendsCircleVC.fid = toFid;
        [self.navigationController pushViewController:otherFriendsCircleVC animated:YES];
//    }
    */
    
    
    MySweepViewController *mySweepVC = [[MySweepViewController alloc]init];
    mySweepVC.friendIdString = friendArray[(button.tag-5000)][@"user_id"];
    mySweepVC.groupIdString = @"0";
    mySweepVC.groupTypeString = @"4";
    [self.navigationController pushViewController:mySweepVC animated:YES];
    
}
#pragma mark - 评论按钮
- (void)clickCommentButton:(UIButton *)commentBtn
{
    [self reloadoperationButton];
    
    businessID = friendArray[commentBtn.tag - 7000][@"id"];
    isCellNumber = commentBtn.tag-7000;
    isReplyMe = @"me";
    [commentBtn setTitle:@"显" forState:UIControlStateNormal];
    [self showMyTextFieldKeyBoardWithRow:commentBtn.tag-7000];
//    if ([commentBtn.titleLabel.text isEqualToString:@"隐"]) {
//        [commentBtn setTitle:@"显" forState:UIControlStateNormal];
//        [self showMyTextFieldKeyBoardWithRow:commentBtn.tag-7000];
//        
//    }else if([commentBtn.titleLabel.text isEqualToString:@"显"]) {
//        [commentBtn setTitle:@"隐" forState:UIControlStateNormal];
//        [replyField resignFirstResponder];
//        [UIView animateWithDuration:0.3 animations:^{
//            replyImageView.frame = CGRectMake(0, self.view.frame.size.height, [[UIScreen mainScreen] bounds].size.width, 49);
//        }];
//    }
}

#pragma mark - 赞
- (void)clickLovesButtonButton:(UIButton *)lovesbutton
{
    [self reloadoperationButton];
    NSString *myMark = [[NSString alloc]init];
    if ([lovesbutton.titleLabel.text isEqualToString:@"不赞"]) {
        [lovesbutton setBackgroundImage:[UIImage imageNamed:@"yi_zan_image"] forState:UIControlStateNormal];
        [lovesbutton setTitle:@"赞" forState:UIControlStateNormal];
        myMark = @"1";
    }else
    {
        [lovesbutton setBackgroundImage:[UIImage imageNamed:@"wei_zan_image"] forState:UIControlStateNormal];
        [lovesbutton setTitle:@"不赞" forState:UIControlStateNormal];
        myMark = @"2";
    }
    
    [BCHTTPRequest markTheFriendCircleLogWithLogID:friendArray[lovesbutton.tag - 9000][@"id"] WithStatus:myMark usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            [self getData:pageNumber];
        }
    }];
}

-(void)reloadoperationButton
{
    for (int w = 0; w< friendArray.count; w++) {
        
        FriendsCircleCell *cell = (FriendsCircleCell*)[friendsCircleTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:w inSection:0]];
        
        if (cell.operationBackImageView.frame.size.width == 180) {
            [cell.operationButton setTitle:@"隐藏" forState:UIControlStateNormal];
            //                cell.operationBackImageView.hidden = YES;
//            [UIView animateWithDuration:0.3 animations:^{
//                cell.operationBackImageView.frame = CGRectMake(280,cell.operationBackImageView.frame.origin.y,0,40);
//            } completion:^(BOOL finished) {
//                
//            }];
            cell.operationBackImageView.frame = CGRectMake(280,cell.operationBackImageView.frame.origin.y,0,40);
        }
    }
}

#pragma mark - 点击查看图片详情
- (void)clickPicturesButton:(UIButton *)mySender
{
    //300000+1000*indexPath.row+i;
//    PictureDetialsViewController *pictureDetialsVC = [[PictureDetialsViewController alloc]init];
//    pictureDetialsVC.allPicArray = friendArray[(mySender.tag-300000)/1000][@"pictures"];
//    pictureDetialsVC.myPage =[NSString stringWithFormat:@"%lu",mySender.tag%100];
//
//    [self.navigationController pushViewController:pictureDetialsVC animated:YES];
    
    // 1.封装图片数据
    NSMutableArray *allImageUrlArray = [[NSMutableArray alloc]initWithCapacity:200];
    allImageUrlArray = friendArray[(mySender.tag-300000)/1000][@"pictures"];
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity: [allImageUrlArray count] ];
    for (int i = 0; i < [allImageUrlArray count]; i++) {
        // 替换为中等尺寸图片
        
        NSString * getImageStrUrl = [NSString stringWithFormat:@"%@", [allImageUrlArray objectAtIndex:i] ];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString: getImageStrUrl ]; // 图片路径
        
         FriendsCircleCell *cell = (FriendsCircleCell*)[friendsCircleTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:(mySender.tag-300000)/1000 inSection:0]];
        //UIImageView * imageView = (UIImageView *)[cell.contentView viewWithTag:(100000+(mySender.tag-300000)/1000 )];
        photo.srcImageView = cell.photoBackImageView.subviews[i];
        [photos addObject:photo];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = mySender.tag%100; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];

}
#pragma mark - 操作按钮
- (void)clickOperationButton:(UIButton *)senderButton
{
    for (int q = 0; q< friendArray.count; q++) {
        
        FriendsCircleCell *cell = (FriendsCircleCell*)[friendsCircleTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:q inSection:0]];
        if (q == senderButton.tag-2000) {
            
            BOOL isShow;
            if (cell.operationBackImageView.frame.size.width == 180)
            {
                [cell.operationButton setTitle:@"隐藏" forState:UIControlStateNormal];
//                cell.operationBackImageView.hidden = YES;
                isShow = NO;
                
            }else{
                [cell.operationButton setTitle:@"显示" forState:UIControlStateNormal];
//                cell.operationBackImageView.hidden = NO;
                isShow = YES;
            }
            
            [UIView animateWithDuration:0.3 animations:^{
                cell.operationBackImageView.frame = CGRectMake(isShow?100:280,cell.operationBackImageView.frame.origin.y,isShow?180:0,40);
            } completion:^(BOOL finished) {
                
            }];
            
        }else
        {
            [cell.operationButton setTitle:@"隐藏" forState:UIControlStateNormal];
//            cell.operationBackImageView.hidden = YES;
            cell.operationBackImageView.frame = CGRectMake(280,cell.operationBackImageView.frame.origin.y,0,40);
            
        }
    }
/*
    businessID = friendArray[senderButton.tag - 2000][@"id"];
    isCellNumber = senderButton.tag-2000;
    isReplyMe = @"me";
    if ([senderButton.titleLabel.text isEqualToString:@"隐藏"]) {
        [senderButton setTitle:@"显示" forState:UIControlStateNormal];
        [self showMyTextFieldKeyBoard];
        
    }else if([senderButton.titleLabel.text isEqualToString:@"显示"]) {
        [senderButton setTitle:@"隐藏" forState:UIControlStateNormal];
        [replyField resignFirstResponder];
        [UIView animateWithDuration:0.3 animations:^{
            replyImageView.frame = CGRectMake(0, self.view.frame.size.height, [[UIScreen mainScreen] bounds].size.width, 49);
        }];
        
    }
*/
}
#pragma mark - 弹出键盘
- (void)showMyTextFieldKeyBoardWithRow:(int )button
{
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:button inSection:0];
    [friendsCircleTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    if (replyImageView) {
        [replyImageView removeFromSuperview];
    }
    //回复框背景replyImageView;
    replyImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-64-49, [[UIScreen mainScreen] bounds].size.width, 49)];
    replyImageView.backgroundColor = [UIColor clearColor];
    replyImageView.userInteractionEnabled = YES;
    [replyImageView setImage:[UIImage imageNamed:@"huifukuangbeijing@2x"]];
    //[self.view bringSubviewToFront:replyImageView];
    [self.view addSubview:replyImageView];
    
    //回复按钮replyButton;
    replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    replyButton.frame = CGRectMake(526/2, 0, 114/2, 49);
    replyButton.backgroundColor = [UIColor clearColor];
    [replyButton setBackgroundImage:[UIImage imageNamed:@"huifuanniu@2x"] forState:UIControlStateNormal];
    [replyButton addTarget:self action:@selector(clickReplyButton) forControlEvents:UIControlEventTouchUpInside];
    [replyImageView addSubview:replyButton];
    
    //回复框replyField;
    replyField = [[UITextView alloc]initWithFrame:CGRectMake(24, 8, 240, 25)];
    replyField.backgroundColor = [UIColor clearColor];
    replyField.delegate = self;
    replyField.font = [UIFont systemFontOfSize:14];
    replyField.returnKeyType = UIReturnKeySend;
    [replyImageView addSubview:replyField];
    
    //TextView占位符
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 3, 240, 25)];
    placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
    placeHolderLabel.font = [UIFont systemFontOfSize:14.0f];
    placeHolderLabel.textColor = [UIColor lightGrayColor];
    placeHolderLabel.backgroundColor = [UIColor clearColor];
    placeHolderLabel.alpha = 0;
    placeHolderLabel.tag = 999;
    placeHolderLabel.text = @"我也说两句";
    [replyField addSubview:placeHolderLabel];
    if ([[replyField text] length] == 0) {
        [[replyField viewWithTag:999] setAlpha:1];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
//    //点击背景取消键盘
//    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
//                                             initWithTarget:self action:@selector(handleBackgroundTap:)];
//    tapRecognizer.cancelsTouchesInView = NO;
//    [self.view addGestureRecognizer:tapRecognizer];

    [replyField becomeFirstResponder];
    
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;

{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
//        [UIView animateWithDuration:0.3 animations:^{
//            replyImageView.frame = CGRectMake(0, self.view.frame.size.height, [[UIScreen mainScreen] bounds].size.width, 49);
//        }];
//        
//        for (int w = 0; w< friendArray.count; w++) {
//            
//            FriendsCircleCell *cell = (FriendsCircleCell*)[friendsCircleTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:w inSection:0]];
//            
//            if([cell.commentButton.titleLabel.text isEqualToString:@"显"]) {
//                [cell.commentButton setTitle:@"隐" forState:UIControlStateNormal];
//            }
//            
//        }
        [self clickReplyButton];
        
        return NO;
    }
    return YES;

}

- (void)keyboardWillShown:(NSNotification*)aNotification{
    // 键盘信息字典
    NSValue *keyboardBoundsValue = [[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardBounds;
    [keyboardBoundsValue getValue:&keyboardBounds];
    NSLog(@"height = %f",keyboardBounds.size.height);
    
    [UIView animateWithDuration:0.3 animations:^{
        replyImageView.frame = CGRectMake(0, self.view.frame.size.height-keyboardBounds.size.height-49, [[UIScreen mainScreen] bounds].size.width, 49);
    }];
}
- (void)keyboardWillHide:(NSNotification*)aNotification{
    
    [replyField resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        replyImageView.frame = CGRectMake(0, self.view.frame.size.height, [[UIScreen mainScreen] bounds].size.width, 49);
    }];

}
//输入框要编辑的时候
- (void)textChanged:(NSNotification *)notification
{
    if ([[replyField text] length] == 0) {
        [[replyField viewWithTag:999] setAlpha:1];
    }
    else {
        [[replyField viewWithTag:999] setAlpha:0];
    }
    //    [UIView animateWithDuration:0.3 animations:^{
    //        replyImageView.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-49-, [[UIScreen mainScreen] bounds].size.width, 49);
    //    }];
    
    
}

#pragma mark - 回复
- (void)clickReplyButton
{
    if ([isReplyMe isEqualToString:@"other"]) {
        
        
    }else if ([isReplyMe isEqualToString:@"me"])
    {
        beReviewedID = [BCHTTPRequest getUserId];
    }
    reviewContent = replyField.text;
    [BCHTTPRequest postTheFriendCircleCommentsWithLogID:businessID WithContent:reviewContent WithToID:beReviewedID usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        
        if (isSuccess == YES) {
            businessID = @"";
            beReviewedID = @"";
            reviewContent = @"";
            isReplyMe = @"other";
            
            [replyField resignFirstResponder];
            [UIView animateWithDuration:0.3 animations:^{
                replyImageView.frame = CGRectMake(0, self.view.frame.size.height, [[UIScreen mainScreen] bounds].size.width, 49);
            }];
            NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:resultDic[@"content"], @"content",resultDic[@"add_time"],@"add_time",resultDic[@"from_id"],@"from_id",resultDic[@"to_id"],@"to_id",resultDic[@"from_name"],@"from_name",resultDic[@"to_name"],@"to_name", nil];
            if ([isReplyMe isEqualToString:@"other"]) {
                
                [friendArray[isCellNumber][@"comments"] addObject:dic];
                for (int w = 0; w< friendArray.count; w++) {
                    
                    FriendsCircleCell *cell = (FriendsCircleCell*)[friendsCircleTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:w inSection:0]];
                    
                    if([cell.commentButton.titleLabel.text isEqualToString:@"显"]) {
                        [cell.commentButton setTitle:@"隐" forState:UIControlStateNormal];
                    }
                }
                
            }else
            {
                for (int w = 0; w< friendArray.count; w++) {
                    
                    FriendsCircleCell *cell = (FriendsCircleCell*)[friendsCircleTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:w inSection:0]];
                    
                    if([cell.commentButton.titleLabel.text isEqualToString:@"显"]) {
                        [cell.commentButton setTitle:@"隐" forState:UIControlStateNormal];
                        
                        [friendArray[w][@"comments"] addObject:dic];
                    }
                    
                }
                
            }
            [friendsCircleTableView reloadData];
            
        }
    }];

}
#pragma mark - 获取数据
- (void)getData:(int)num
{
    //获取数据
    [BCHTTPRequest getFriendsOpenListWithPages:num UsingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        [loadview stopLoading:1];
            if (isSuccess == YES) {
                
                //朋友圈背景backImageView;
                backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width,256)];
                backImageView.backgroundColor = [UIColor clearColor];
                [backImageView sd_setImageWithURL:[NSURL URLWithString:resultDic[@"background"]] placeholderImage:[UIImage imageNamed:@"ceshibeijing@2x"]];
                backImageView.userInteractionEnabled = YES;
                [backImageView setContentMode:UIViewContentModeScaleAspectFill];
                backImageView.clipsToBounds = YES;
                
                [friendsCircleTableView.tableHeaderView addSubview:backImageView];
                
                //图片背景的手势事件
                UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                                         initWithTarget:self action:@selector(changeimage:)];
                tapRecognizer.cancelsTouchesInView = YES;
                [backImageView addGestureRecognizer:tapRecognizer];
                
//                //头像markheadImageView; //headerImageView;
//                markheadImageView = [[UIImageView alloc]initWithFrame:CGRectMake(248/2,206,75,75)];
//                markheadImageView.backgroundColor = [UIColor clearColor];
//                [markheadImageView setImage:[UIImage imageNamed:@"pengyouquantouxiang@2x"]];
//                markheadImageView.userInteractionEnabled = YES;
//                [markheadImageView.layer setMasksToBounds:YES];
////                [markheadImageView.layer setCornerRadius:36.5f];
//                markheadImageView.layer.borderColor = [UIColor whiteColor].CGColor;
//                markheadImageView.layer.borderWidth = 1.0f;
//                [friendsCircleTableView.tableHeaderView addSubview:markheadImageView];
                
                headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(230,206,75,75)];
                headerImageView.backgroundColor = [UIColor cyanColor];
                [headerImageView sd_setImageWithURL:[NSURL URLWithString:resultDic[@"pic"]] placeholderImage:[UIImage imageNamed:@"ceshi@2x"]];
                headerImageView.userInteractionEnabled = YES;
                [headerImageView.layer setMasksToBounds:YES];
                headerImageView.layer.borderColor = [UIColor whiteColor].CGColor;
                headerImageView.layer.borderWidth = 1.0f;
//                [headerImageView.layer setCornerRadius:34.0f];
                [friendsCircleTableView.tableHeaderView addSubview:headerImageView];
                
                //名字
                myNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(34,224,180,36/2)];
                myNameLabel.backgroundColor = [UIColor clearColor];
                myNameLabel.textAlignment = NSTextAlignmentRight;
                myNameLabel.textColor = [UIColor whiteColor];
                myNameLabel.font = [UIFont systemFontOfSize:18];
                myNameLabel.text = resultDic[@"name"];
                [backImageView addSubview:myNameLabel];
                
//                //编辑myEditButton;
//                myEditButton = [UIButton buttonWithType:UIButtonTypeCustom];
//                myEditButton.frame = CGRectMake(542/2, 234/2, 40, 40);
//                myEditButton.backgroundColor = [UIColor clearColor];
//                [myEditButton setBackgroundImage:[UIImage imageNamed:@"qianbi@2x"] forState:UIControlStateNormal];
//                [myEditButton addTarget:self action:@selector(clickMyEditButton) forControlEvents:UIControlEventTouchUpInside];
//                [backImageView addSubview:myEditButton];

            if ([(NSArray *)resultDic[@"friend"] count] > 0) {
                if (num == 1) {
                    friendArray = [[NSMutableArray alloc] initWithCapacity:100];
                }
                
                [friendArray addObjectsFromArray:resultDic[@"friend"]];
               
            }else
            {
                if (pageNumber != 1) {
                    pageNumber--;
                }
                loadview.normalLabel.text = @"没有更多数据了";
            }
            
            [friendsCircleTableView reloadData];
            [self testFinishedLoadData];
        }
    }];
    
}
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
//初始化刷新视图
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#pragma mark
#pragma methods for creating and removing the header view

-(void)createHeaderView{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
	_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                     self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    
	[friendsCircleTableView addSubview:_refreshHeaderView];
    
    [_refreshHeaderView refreshLastUpdatedDate];
}

-(void)testFinishedLoadData{
	
    [self finishReloadingData];
//    [self setFooterView];
}

#pragma mark -
#pragma mark method that should be called when the refreshing is finished
- (void)finishReloadingData{
	
	//  model should call this when its done loading
	_reloading = NO;
    
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:friendsCircleTableView];
    }
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

-(void)setFooterView{
	//    UIEdgeInsets test = self.aoView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(friendsCircleTableView.contentSize.height, friendsCircleTableView.frame.size.height);
    
    if (_refreshFooterView && [_refreshFooterView superview])
	{
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              friendsCircleTableView.frame.size.width,
                                              self.view.bounds.size.height);
    }else
	{
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         friendsCircleTableView.frame.size.width, self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [friendsCircleTableView addSubview:_refreshFooterView];
    }
    
    if (_refreshFooterView)
	{
        [_refreshFooterView refreshLastUpdatedDate];
    }
}


-(void)removeFooterView
{
    if (_refreshFooterView && [_refreshFooterView superview])
	{
        [_refreshFooterView removeFromSuperview];
    }
    _refreshFooterView = nil;
}

//===============
//刷新delegate
#pragma mark -
#pragma mark data reloading methods that must be overide by the subclass

-(void)beginToReloadData:(EGORefreshPos)aRefreshPos{
	
	//  should be calling your tableviews data source model to reload
	_reloading = YES;
    
    if (aRefreshPos == EGORefreshHeader)
	{
        // pull down to refresh data
        [self performSelector:@selector(refreshView) withObject:nil afterDelay:2.0];
    }else if(aRefreshPos == EGORefreshFooter)
	{
        // pull up to load more data
        [self performSelector:@selector(getNextPageView) withObject:nil afterDelay:2.0];
    }
	
	// overide, the actual loading data operation is done in the subclass
}

//刷新调用的方法
-(void)refreshView
{
	NSLog(@"刷新完成");
    
    pageNumber = 1;
    
    
    [self getData:pageNumber];
    
    
    //[self testFinishedLoadData];
	
}
//加载调用的方法
-(void)getNextPageView
{
    pageNumber += 1;
    
    [self getData:pageNumber];
    
//    [self removeFooterView];
//    [self testFinishedLoadData];
    
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//
//
//    pageControl.currentPage=scrollView.contentOffset.x/320;
//    [self setCurrentPage:pageControl.currentPage];
//}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if (_refreshHeaderView)
	{
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
	
//	if (_refreshFooterView)
//	{
//        [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
//    }
    
    
    
    if(scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height+40) && scrollView.contentOffset.y > 0)
    {
        if (loadview.normalLabel.hidden || [loadview.normalLabel.text isEqualToString:@"没有更多数据了"])
        {
            return;
        }
        
        [loadview startLoading];
        
        pageNumber++;
        
        [self getData:pageNumber];
    }
    
}


#pragma mark -
#pragma mark EGORefreshTableDelegate Methods

- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos
{
	
	[self beginToReloadData:aRefreshPos];
	
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}


// if we don't realize this method, it won't display the refresh timestamp
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view
{
	
	return [NSDate date]; // should return date data source was last changed
	
}


#pragma mark - OHLabelDelegate
-(BOOL)attributedLabel:(OHAttributedLabel*)attributedLabel shouldFollowLink:(NSTextCheckingResult*)linkInfo
{
    return YES;
}
-(UIColor*)colorForLink:(NSTextCheckingResult*)linkInfo underlineStyle:(int32_t*)underlineStyle
{
    return [UIColor colorWithRed:86/255.0f green:104/255.0f blue:154/255.0f alpha:1];
}

#pragma  mark - RTLabelDelegate
-(void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL *)url
{
    MySweepViewController *mySweepVC = [[MySweepViewController alloc]init];
    mySweepVC.friendIdString = [url absoluteString];
    mySweepVC.groupIdString = @"0";
    mySweepVC.groupTypeString = @"4";
    [self.navigationController pushViewController:mySweepVC animated:YES];
}

#pragma mark - 获取到点赞人的字符串
-(NSString *)returnZanStringWith:(NSMutableArray *)array WithTotalNum:(NSString *)theCount
{
    NSString * zanString = [NSString stringWithFormat:@"<img src=\"AlbumInformationLikeHL.png\">     </img> "];
    
    for (int h = 0;h < praiseArray.count;h++)
    {
        if (h == 0) {
            zanString = [zanString stringByAppendingFormat:@"<a href=\"%@\">%@</a>",praiseArray[h][@"uid"],praiseArray[h][@"nickname"]];
        }else
        {
            zanString = [zanString stringByAppendingFormat:@"，<a href=\"%@\">%@</a>",praiseArray[h][@"uid"],praiseArray[h][@"nickname"]];
        }
    }
    
    return zanString;
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
