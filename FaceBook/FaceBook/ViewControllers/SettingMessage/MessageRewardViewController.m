//
//  MessageRewardViewController.m
//  FaceBook
//
//  Created by fengshaohui on 14-5-11.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "MessageRewardViewController.h"
#import "GroupNotice.h"
#import "GroupNoticeObject.h"
@interface MessageRewardViewController ()
{
    //背景
    UIImageView *backImageView;
    //群消息
    UILabel *groupLabel;
    UISwitch *groupSwitch;
    //消息
    UILabel *messageLabel;
    UISwitch *messageSwitch;
    
    GroupNoticeObject *obj;
    GroupNotice * groupNotice;
    NSString *noticeId;
}
@end

@implementation MessageRewardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        noticeId = @"1";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    groupNotice = [[GroupNotice alloc] init];
    [groupNotice createDataBase];
    obj = [groupNotice getAllRemindStyleWithGid:noticeId];
    
    self.view.backgroundColor = [UIColor colorWithRed:248.0f/255.0f green:249.0f/255.0f blue:251.0f/255.0f alpha:1.0];
    if (IS_IOS_7) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios7"] forBarMetrics:UIBarMetricsDefault];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios6"] forBarMetrics:UIBarMetricsDefault];
    }
    self.title = @"设置";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 22, 40, 40);
    [backButton setBackgroundImage:[UIImage imageNamed:@"login_backButton@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //[self.navigationController.view addSubview:backButton];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;
    

    //背景backImageView;
    backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 580/2, 176/2)];
    backImageView.backgroundColor = [UIColor clearColor];
    [backImageView setImage:[UIImage imageNamed:@"xiaoxitixing@2x"]];
    backImageView.userInteractionEnabled = YES;
    [self.view addSubview:backImageView];

    //群消息groupLabel;groupSwitch;
    groupLabel = [[UILabel alloc]initWithFrame:CGRectMake(30/2, 14, 346/2, 16)];
    groupLabel.backgroundColor =[UIColor clearColor];
    groupLabel.font = [UIFont systemFontOfSize:15];
    groupLabel.textAlignment = NSTextAlignmentLeft;
    groupLabel.textColor = [UIColor blackColor];
    groupLabel.text = @"群消息设置";
    [backImageView addSubview:groupLabel];
    
    groupSwitch = [[ UISwitch alloc]initWithFrame:CGRectMake(446/2,12/2,104/2,31)];
    //[newMessageSwitch setOnImage:[UIImage imageNamed:@"dakai.png"]];
    //[newMessageSwitch setOffImage:[UIImage imageNamed:@"guanbi_05.png"]];
    
//    groupSwitch.thumbTintColor = [UIColor whiteColor];
//    groupSwitch.tintColor = [UIColor lightGrayColor];
//    groupSwitch.onTintColor = [UIColor colorWithRed:135.0f/255.0f green:216.0f/255.0f blue:105.0f/255.0f alpha:1.0f];
    //newMessageSwitch.on = YES;
    
    if ([obj.isNewMessageRemind isEqualToString:@"1"]) {
        [ groupSwitch setOn:YES animated:YES];
    }else
    {
        [ groupSwitch setOn:NO animated:YES];
    }

    
    
    [ groupSwitch addTarget: self action:@selector(groupSwitchValueChanged) forControlEvents:UIControlEventValueChanged];
    [backImageView addSubview:groupSwitch];
    
    //消息messageLabel;messageSwitch;
    messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(30/2, 58, 346/2, 16)];
    messageLabel.backgroundColor =[UIColor clearColor];
    messageLabel.font = [UIFont systemFontOfSize:15];
    messageLabel.textAlignment = NSTextAlignmentLeft;
    messageLabel.textColor = [UIColor blackColor];
    messageLabel.text = @"消息设置";
    [backImageView addSubview:messageLabel];

    messageSwitch = [[ UISwitch alloc]initWithFrame:CGRectMake(446/2,98/2,104/2,31)];
    //[newMessageSwitch setOnImage:[UIImage imageNamed:@"dakai.png"]];
    //[newMessageSwitch setOffImage:[UIImage imageNamed:@"guanbi_05.png"]];
//    messageSwitch.thumbTintColor = [UIColor whiteColor];
//    messageSwitch.tintColor = [UIColor lightGrayColor];
//    messageSwitch.onTintColor = [UIColor colorWithRed:135.0f/255.0f green:216.0f/255.0f blue:105.0f/255.0f alpha:1.0f];
    //messageSwitch.on = YES;
    
    if ([obj.showGroupName isEqualToString:@"1"]) {
        [ messageSwitch setOn:YES animated:YES];
    }else
    {
        [ messageSwitch setOn:NO animated:YES];
    }

    
    
    [ messageSwitch addTarget: self action:@selector(messageSwitchValueChanged) forControlEvents:UIControlEventValueChanged];
    [backImageView addSubview:messageSwitch];
   
    
}
#pragma mark - 返回
- (void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 群消息
- (void)groupSwitchValueChanged
{
    if (groupSwitch.on == YES) {
        
        
        
        [groupNotice UpdateTheRemindStyleWith:@"N_newMsgRemind" WithValues:@"1" WithGroupID:noticeId];
    }else if (groupSwitch.on == NO){
        NSLog(@"2222222");
        [groupNotice UpdateTheRemindStyleWith:@"N_newMsgRemind" WithValues:@"2" WithGroupID:noticeId];
    }

}
#pragma mark - 消息
- (void)messageSwitchValueChanged
{
    if (messageSwitch.on == YES) {
        NSLog(@"111111");
        
        [groupNotice UpdateTheRemindStyleWith:@"showNikeName" WithValues:@"1" WithGroupID:noticeId];
        
    }else if (messageSwitch.on == NO){
        NSLog(@"2222222");
        [groupNotice UpdateTheRemindStyleWith:@"showNikeName" WithValues:@"2" WithGroupID:noticeId];
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
