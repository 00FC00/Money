//
//  OtherFriendsCircleViewController.m
//  FaceBook
//
//  Created by fengshaohui on 14-6-23.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "OtherFriendsCircleViewController.h"
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

#import "SUNViewController.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"

#import "UIImageView+WebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@interface OtherFriendsCircleViewController ()
{
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
    
    //输入框
    UIImageView *replyImageView;
    UIButton *replyButton;
    UITextView *replyField;
    UILabel *placeHolderLabel;
    
}

@end

@implementation OtherFriendsCircleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        pageNumber = 1;
        pictureArray = [[NSMutableArray alloc]initWithCapacity:200];
        commentArray = [[NSMutableArray alloc]initWithCapacity:300];
        isReplyMe = @"other";
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
    [menuButton setBackgroundImage:[UIImage imageNamed:@"login_backButton@2x"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(menuButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //[self.navigationController.view addSubview:backButton];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:menuButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;
    
    //设置
    UIButton *setButton = [UIButton buttonWithType:UIButtonTypeCustom];
    setButton.frame = CGRectMake(526/2, 22, 80/2, 80/2);
    [setButton setBackgroundImage:[UIImage imageNamed:@"shezhianniu@2x"] forState:UIControlStateNormal];
    //[setButton setTitle:@"登录" forState:UIControlStateNormal];
    //setButton.titleLabel.font = [UIFont systemFontOfSize:15];
    //[setButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [setButton addTarget:self action:@selector(setButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:setButton];
    self.navigationItem.rightBarButtonItem=rightbuttonitem;
    
    //朋友圈列表
    friendsCircleTableView = [[UITableView alloc]initWithFrame:CGRectMake(6, 0, [[UIScreen mainScreen] bounds].size.width-12, [[UIScreen mainScreen] bounds].size.height-64) style:UITableViewStylePlain];
    friendsCircleTableView.backgroundColor = [UIColor clearColor];
    friendsCircleTableView.delegate = self;
    friendsCircleTableView.dataSource = self;
    friendsCircleTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width-12, 320/2)];
    friendsCircleTableView.tableHeaderView.backgroundColor = [UIColor clearColor];
    if (IS_IOS_7) {
        friendsCircleTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    [self.view addSubview:friendsCircleTableView];
    
    
    
    
    
    //获取数据
    [self getData:pageNumber];
    
    [self createHeaderView];
    [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.0f];
    
    
    
//    [[NSNotificationCenter defaultCenter] addObserverForName:@"FshFriendCircleList" object:nil queue:nil usingBlock:^(NSNotification *note) {
//        
//        //获取数据
//        [self getData:pageNumber];
//        
//    }];

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
        
        for (int w = 0; w< friendArray.count; w++) {
            
            FriendsCircleCell *cell = (FriendsCircleCell*)[friendsCircleTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:w inSection:0]];
            
            if (cell.operationBackImageView.hidden == NO) {
                [cell.operationButton setTitle:@"隐藏" forState:UIControlStateNormal];
                cell.operationBackImageView.hidden = YES;
            }
        }
        
    }
    
}

#pragma mark - 菜单
- (void)menuButtonClicked
{
//    SUNViewController *drawerController = (SUNViewController *)self.navigationController.mm_drawerController;
//    
//    if (drawerController.openSide == MMDrawerSideNone) {
//        [drawerController openDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
//            
//        }];
//    }else if  (drawerController.openSide == MMDrawerSideLeft) {
//        [drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
//            
//        }];
//    }
    [self.navigationController popViewControllerAnimated:YES];

}
#pragma mark - 设置
- (void)setButtonClicked
{
    SettingViewController *settingVC = [[SettingViewController alloc]init];
    [self.navigationController pushViewController:settingVC animated:YES];
}
//#pragma mark - 发布朋友圈
//- (void)clickMyEditButton
//{
//    NSLog(@"发布朋友圈");
//    SendFriendCircleViewController *sendFriendCircleVC = [[SendFriendCircleViewController alloc]init];
//    [self.navigationController pushViewController:sendFriendCircleVC animated:YES];
//    
//}
//- (void) changeimage:(UITapGestureRecognizer*)sender
//{
//    photoActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
//    [photoActionSheet showInView:self.view];
//}
//#pragma mark - UIActionSheetDelegate
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    
//    UIImagePickerController * picker = [[UIImagePickerController alloc]init];
//    
//    picker.delegate = self;
//    picker.allowsEditing = NO;  //是否可编辑
//    
//    if (buttonIndex == 0) {
//        //拍照
//        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//        [self presentViewController:picker animated:YES completion:^{
//        }];
//    }else if (buttonIndex == 1) {
//        //相册
//        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        [self presentViewController:picker animated:YES completion:^{
//        }];
//    }
//    
//    
//}
//
//
//#pragma mark - UIImagePickerControllerDelegate
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    //得到图片
//    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
//    [BCHTTPRequest PostChangeTheFriendCircleBackPicturesWithImage:image usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
//        if (isSuccess == YES) {
//            [backImageView setImage:image];
//            [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"上传成功"];
//            
//        }
//    }];
//    
//    [picker dismissViewControllerAnimated:YES completion:^{
//        ;
//    }];
//}
////取消返回
//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
//{
//    [picker dismissViewControllerAnimated:YES completion:^{
//        ;
//    }];
//}
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
    
    CGSize size1;
    //***********ios7的方法
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7)
    {
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:15]};
        size1 = [str1 boundingRectWithSize:CGSizeMake(492/2, 1000) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    }else
    {
        //***********ios6的方法
        size1 = [str1 sizeWithFont:[UIFont systemFontOfSize:15]constrainedToSize:CGSizeMake(492/2,1000) lineBreakMode:NSLineBreakByWordWrapping];
    }
    contectHeight = size1.height+8/2;
    //评论按钮38/2
    //评论高度
    
    commentArray = friendArray[indexPath.row][@"comments"];
    CGFloat mycommentHeight = 13;
    if (commentArray.count > 0) {
        
        for (int h = 0; h<[commentArray count]; h++) {
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
                commentSize = [commentString boundingRectWithSize:CGSizeMake(440/2, 1000000) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
            }else
            {
                //***********ios6的方法
                commentSize = [commentString sizeWithFont:[UIFont systemFontOfSize:14]constrainedToSize:CGSizeMake(440/2, 1000000) lineBreakMode:NSLineBreakByWordWrapping];
            }
            mycommentHeight += commentSize.height;
        }
    }else
    {
        mycommentHeight = 0;
    }
    if ([str1 length ]== 0) {
        
        return 49+picHeight+4+38/2+mycommentHeight+15;
    }
    return 49+picHeight+contectHeight+38/2+mycommentHeight+15;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimepleNewsListcell = @"SimpleNewsListcells";
    FriendsCircleCell *cell = [tableView dequeueReusableCellWithIdentifier:SimepleNewsListcell];
    if (cell == nil) {
        cell = [[FriendsCircleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimepleNewsListcell];
        
        
    }
    //    else
    //    {
    //        while([cell.commentsBackImageView.subviews lastObject]!=nil){
    //            [[cell.commentsBackImageView.subviews lastObject]removeFromSuperview];
    //
    //        }
    //
    //    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //头像背景
    [cell.marksImageView setImage:[UIImage imageNamed:@"metouxiangbeijing@2x"]];
    
    //头像
    [cell.userImageView setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:[UIImage imageNamed:@"ceshi@2x"] ];
    
    //[cell.userImageView setImage:[UIImage imageNamed:@"ceshi@2x"]];
    [cell.userImageButton setTag:5000+indexPath.row];
    [cell.userImageButton addTarget:self action:@selector(clickUserImageButton:) forControlEvents:UIControlEventTouchUpInside];
    //名字
    cell.userNameLabel.text = friendArray[indexPath.row][@"name"];
    //日期
    cell.postDateTimeLabel.text = friendArray[indexPath.row][@"add_time"];
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
    if (IS_IOS_7)
    {
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:15]};
        size1 = [str1 boundingRectWithSize:CGSizeMake(492/2, 1000) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    }else
    {
        //***********ios6的方法
        size1 = [str1 sizeWithFont:[UIFont systemFontOfSize:15]constrainedToSize:CGSizeMake(492/2,1000) lineBreakMode:NSLineBreakByWordWrapping];
    }
    NSLog(@"上面高度%f",cell.photoBackImageView.frame.origin.y+cell.photoBackImageView.frame.size.height);
    if ([str1 length]==0) {
        size1.height = 0;
    }
    
    //********************
    cell.messageLabel.frame =CGRectMake(114/2, 44, size1.width, size1.height);
    cell.messageLabel.text = str1;
    
    
    
    
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
            [commentsImageView setImageWithURL:[NSURL URLWithString:[pictureArray objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"quantupianbeijing@2x"]];
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
    cell.photoBackImageView.frame = CGRectMake(118/2, cell.messageLabel.frame.origin.y+cell.messageLabel.frame.size.height, 498/2, 84*K);
    
    
    
    
    
    //操作按钮
    cell.operationButton.frame = CGRectMake(548/2, cell.photoBackImageView.frame.origin.y+ cell.photoBackImageView.frame.size.height+4, 50/2, 52/2);
    NSLog(@"阿牛的坐标%f",cell.photoBackImageView.frame.origin.y+ cell.photoBackImageView.frame.size.height+4);
    [cell.operationButton setTitle:@"隐藏" forState:UIControlStateNormal];
    [cell.operationButton setBackgroundImage:[UIImage imageNamed:@"caozuoanniu@2x"] forState:UIControlStateNormal];
    [cell.operationButton setTag:2000+indexPath.row];
    [cell.operationButton addTarget:self action:@selector(clickOperationButton:) forControlEvents:UIControlEventTouchUpInside];
    
//    ////操作框
//    cell.operationBackImageView.frame = CGRectMake(338/2, cell.operationButton.frame.origin.y+2,204/2, 50/2);
//    [cell.operationBackImageView setImage:[UIImage imageNamed:@"caozuokuang@2x"]];
//    cell.operationBackImageView.tag = 5000+indexPath.row;
//    if ([cell.operationButton.titleLabel.text isEqualToString:@"显示"]) {
//        cell.operationBackImageView.hidden = NO;
//    }else
//    {
//        cell.operationBackImageView.hidden = YES;
//    }
//    
//    //评论
//    cell.commentButton.tag = 7000+indexPath.row;
//    [cell.commentButton setBackgroundImage:[UIImage imageNamed:@"pinglun1@2x"] forState:UIControlStateNormal];
//    [cell.commentButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
//    [cell.commentButton setTitle:@"隐" forState:UIControlStateNormal];
//    [cell.commentButton addTarget:self action:@selector(clickCommentButton:) forControlEvents:UIControlEventTouchUpInside];
//    
//    //赞
//    cell.lovesButton.tag = 9000+indexPath.row;
//    if ([friendArray[indexPath.row][@"love"] intValue]==0) {
//        [cell.lovesButton setTitle:@"不赞" forState:UIControlStateNormal];
//        [cell.lovesButton setBackgroundImage:[UIImage imageNamed:@"dianzan1@2x"] forState:UIControlStateNormal];
//    }else if ([friendArray[indexPath.row][@"love"] intValue]==1)
//    {
//        [cell.lovesButton setTitle:@"赞" forState:UIControlStateNormal];
//        [cell.lovesButton setBackgroundImage:[UIImage imageNamed:@"dianzan2@2x"] forState:UIControlStateNormal];
//    }
//    
//    [cell.lovesButton addTarget:self action:@selector(clickLovesButtonButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //评论回复
    
    commentArray = friendArray[indexPath.row][@"comments"];
    CGFloat commentHeight = 13;
    [cell.commentsBackImageView setImage:[[UIImage imageNamed:@"pinglunbeijing"]stretchableImageWithLeftCapWidth:100 topCapHeight:33]];
    
    for (UIView * sview in cell.commentsBackImageView.subviews) {
        if (sview.tag >= 20000000) {
            [sview removeFromSuperview];
        }
    }
    
    if (commentArray.count == 0) {
        commentHeight = 0;
        cell.commentsBackImageView.hidden = YES;
    }else
    {
        cell.commentsBackImageView.hidden = NO;
        //评论内容
        for (int h = 0; h<[commentArray count]; h++) {
            //名字
            NSString *commentString = [[NSString alloc]init];
            if ([commentArray[h][@"to_name"] isEqualToString:commentArray[h][@"from_name"]]) {
                
                commentString = [NSString stringWithFormat:@"%@:%@",commentArray[h][@"from_name"],commentArray[h][@"content"]];
                
            }else
            {
                
                commentString = [NSString stringWithFormat:@"%@回复%@:%@",commentArray[h][@"from_name"],commentArray[h][@"to_name"],commentArray[h][@"content"]];
            }
            
            NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:commentString];
            // NSString *commentString = [NSString stringWithFormat:@"%@：%@",myArray[i][@"uname"],myArray[i][@"content"]];
            // NSLog(@"%d",[commentString length]);
            CGSize commentSize;
            UILabel *commentContentLabel = [[UILabel alloc]init];
            commentContentLabel.numberOfLines = 0;
            if (IS_IOS_7)
            {
                NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
                commentSize = [commentString boundingRectWithSize:CGSizeMake(440/2, 1000000) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
            }else
            {
                //***********ios6的方法
                commentSize = [commentString sizeWithFont:[UIFont systemFontOfSize:14]constrainedToSize:CGSizeMake(440/2, 1000000) lineBreakMode:NSLineBreakByWordWrapping];
            }
            
            
            commentContentLabel.frame = CGRectMake(10,commentHeight, commentSize.width, commentSize.height);
            
            
            [commentContentLabel setFont:[UIFont systemFontOfSize:14]];
            commentContentLabel.backgroundColor = [UIColor clearColor];
            //commentContentLabel.numberOfLines = 0;
            //            commentContentLabel.text = commentString;
            commentContentLabel.tag = 20000000+h;
            
            //NSLog(@"%@",commentString);
            
            if ([commentArray[h][@"to_name"] isEqualToString:commentArray[h][@"from_name"]]) {
                
                [attrTitle addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, [commentArray[h][@"from_name"] length])];
            }else
            {
                
                
                [attrTitle addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, [commentArray[h][@"from_name"] length])];
                [attrTitle addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(([commentArray[h][@"from_name"] length])+2, [commentArray[h][@"to_name"] length])];
                
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
            
        }
        
        
    }
    
    
    cell.commentsBackImageView.frame = CGRectMake(112/2, cell.operationButton.frame.origin.y+29, 476/2, commentHeight+10);
    
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
        [self showMyTextFieldKeyBoard];
    }
    
    
}

#pragma mark - 点击头像
- (void)clickUserImageButton:(UIButton *)button
{
    NSLog(@"%ld",button.tag);
    
}
#pragma mark - 评论按钮
- (void)clickCommentButton:(UIButton *)commentBtn
{
    businessID = friendArray[commentBtn.tag - 7000][@"id"];
    isCellNumber = commentBtn.tag-7000;
    isReplyMe = @"me";
    if ([commentBtn.titleLabel.text isEqualToString:@"隐"]) {
        [commentBtn setTitle:@"显" forState:UIControlStateNormal];
        [self showMyTextFieldKeyBoard];
        
    }else if([commentBtn.titleLabel.text isEqualToString:@"显"]) {
        [commentBtn setTitle:@"隐" forState:UIControlStateNormal];
        [UIView animateWithDuration:0.3 animations:^{
            replyImageView.frame = CGRectMake(0, self.view.frame.size.height, [[UIScreen mainScreen] bounds].size.width, 49);
        }];
        
    }
    
    
}
#pragma mark - 赞
- (void)clickLovesButtonButton:(UIButton *)lovesbutton
{
    NSString *myMark = [[NSString alloc]init];
    if ([lovesbutton.titleLabel.text isEqualToString:@"不赞"]) {
        [lovesbutton setBackgroundImage:[UIImage imageNamed:@"dianzan2@2x"] forState:UIControlStateNormal];
        [lovesbutton setTitle:@"赞" forState:UIControlStateNormal];
        myMark = @"1";
    }else
    {
        [lovesbutton setBackgroundImage:[UIImage imageNamed:@"dianzan1@2x"] forState:UIControlStateNormal];
        [lovesbutton setTitle:@"不赞" forState:UIControlStateNormal];
        myMark = @"2";
    }
    
    [BCHTTPRequest markTheFriendCircleLogWithLogID:friendArray[lovesbutton.tag - 9000][@"id"] WithStatus:myMark usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            ;
        }
    }];
    
    
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
//    for (int q = 0; q< friendArray.count; q++) {
//        
//        FriendsCircleCell *cell = (FriendsCircleCell*)[friendsCircleTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:q inSection:0]];
//        if (q == senderButton.tag-2000) {
//            if (cell.operationBackImageView.hidden == NO) {
//                [cell.operationButton setTitle:@"隐藏" forState:UIControlStateNormal];
//                cell.operationBackImageView.hidden = YES;
//            }else{
//                [cell.operationButton setTitle:@"显示" forState:UIControlStateNormal];
//                cell.operationBackImageView.hidden = NO;
//                
//            }
//        }else
//        {
//            [cell.operationButton setTitle:@"隐藏" forState:UIControlStateNormal];
//            cell.operationBackImageView.hidden = YES;
//            
//        }
//    }
    
    businessID = friendArray[senderButton.tag - 2000][@"id"];
    isCellNumber = senderButton.tag-2000;
    isReplyMe = @"me";
    if ([senderButton.titleLabel.text isEqualToString:@"隐藏"]) {
        [senderButton setTitle:@"显示" forState:UIControlStateNormal];
        [self showMyTextFieldKeyBoard];
        
    }else if([senderButton.titleLabel.text isEqualToString:@"显示"]) {
        [senderButton setTitle:@"隐藏" forState:UIControlStateNormal];
        [UIView animateWithDuration:0.3 animations:^{
            replyImageView.frame = CGRectMake(0, self.view.frame.size.height, [[UIScreen mainScreen] bounds].size.width, 49);
        }];
        
    }

    
}
#pragma mark - 弹出键盘
- (void)showMyTextFieldKeyBoard
{
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
    replyField = [[UITextView alloc]initWithFrame:CGRectMake(24, 12, 240, 25)];
    replyField.backgroundColor = [UIColor clearColor];
    replyField.delegate = self;
    replyField.font = [UIFont systemFontOfSize:14];
    replyField.returnKeyType = UIReturnKeyDone;
    [replyImageView addSubview:replyField];
    
    //TextView占位符
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 240, 25)];
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
    //    //点击背景取消键盘
    //    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
    //                                             initWithTarget:self action:@selector(handleBackgroundTap:)];
    //    tapRecognizer.cancelsTouchesInView = NO;
    //    [self.view addGestureRecognizer:tapRecognizer];
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;

{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        [UIView animateWithDuration:0.3 animations:^{
            replyImageView.frame = CGRectMake(0, self.view.frame.size.height, [[UIScreen mainScreen] bounds].size.width, 49);
        }];
        
        for (int w = 0; w< friendArray.count; w++) {
            
            FriendsCircleCell *cell = (FriendsCircleCell*)[friendsCircleTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:w inSection:0]];
            
            if([cell.commentButton.titleLabel.text isEqualToString:@"显"]) {
                [cell.commentButton setTitle:@"隐" forState:UIControlStateNormal];
            }
            
        }
        
        
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
    [BCHTTPRequest getMyFriendsOpenWithFid:self.fid WithPages:num usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
       
        if (isSuccess == YES) {
            if ([(NSArray *)resultDic[@"friend"] count] > 0) {
                if (num == 1) {
                    friendArray = [[NSMutableArray alloc] initWithCapacity:100];
                }
                
                [friendArray addObjectsFromArray:resultDic[@"friend"]];
                //朋友圈背景backImageView;
                backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 320/2)];
                backImageView.backgroundColor = [UIColor clearColor];
                [backImageView setImageWithURL:[NSURL URLWithString:resultDic[@"background"]] placeholderImage:[UIImage imageNamed:@"ceshibeijing@2x"]];
                backImageView.userInteractionEnabled = YES;
                [backImageView setContentMode:UIViewContentModeScaleAspectFill];
                backImageView.clipsToBounds = YES;
                
                [friendsCircleTableView.tableHeaderView addSubview:backImageView];
                
//                //图片背景的手势事件
//                UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
//                                                         initWithTarget:self action:@selector(changeimage:)];
//                tapRecognizer.cancelsTouchesInView = YES;
//                [backImageView addGestureRecognizer:tapRecognizer];
                
                //头像markheadImageView; //headerImageView;
                markheadImageView = [[UIImageView alloc]initWithFrame:CGRectMake(248/2, 88/2, 146/2, 146/2)];
                markheadImageView.backgroundColor = [UIColor clearColor];
                [markheadImageView setImage:[UIImage imageNamed:@"pengyouquantouxiang@2x"]];
                markheadImageView.userInteractionEnabled = YES;
                [markheadImageView.layer setMasksToBounds:YES];
                [markheadImageView.layer setCornerRadius:36.5f];
                [backImageView addSubview:markheadImageView];
                
                headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5/2,5/2, 136/2, 136/2)];
                headerImageView.backgroundColor = [UIColor cyanColor];
                headUrl = resultDic[@"pic"];
                [headerImageView setImageWithURL:[NSURL URLWithString:resultDic[@"pic"]] placeholderImage:[UIImage imageNamed:@"ceshi@2x"]];
                headerImageView.userInteractionEnabled = YES;
                [headerImageView.layer setMasksToBounds:YES];
                [headerImageView.layer setCornerRadius:34.0f];
                [markheadImageView addSubview:headerImageView];
                
                //名字
                myNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(152/2, 242/2, 334/2, 36/2)];
                myNameLabel.backgroundColor = [UIColor clearColor];
                myNameLabel.textAlignment = NSTextAlignmentCenter;
                myNameLabel.textColor = [UIColor whiteColor];
                myNameLabel.font = [UIFont systemFontOfSize:17];
                myNameLabel.text = resultDic[@"name"];
                nameStr = resultDic[@"name"];
                [backImageView addSubview:myNameLabel];
                
//                //编辑myEditButton;
//                myEditButton = [UIButton buttonWithType:UIButtonTypeCustom];
//                myEditButton.frame = CGRectMake(552/2, 234/2, 40, 40);
//                myEditButton.backgroundColor = [UIColor clearColor];
//                [myEditButton setBackgroundImage:[UIImage imageNamed:@"qianbi@2x"] forState:UIControlStateNormal];
//                [myEditButton addTarget:self action:@selector(clickMyEditButton) forControlEvents:UIControlEventTouchUpInside];
//                [backImageView addSubview:myEditButton];
                
            }
            
            [friendsCircleTableView reloadData];
            [self removeFooterView];
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
    [self setFooterView];
}

#pragma mark -
#pragma mark method that should be called when the refreshing is finished
- (void)finishReloadingData{
	
	//  model should call this when its done loading
	_reloading = NO;
    
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:friendsCircleTableView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:friendsCircleTableView];
        [self setFooterView];
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
    
    [self removeFooterView];
    [self testFinishedLoadData];
    
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
	
	if (_refreshFooterView)
	{
        [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
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
