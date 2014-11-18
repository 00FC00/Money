//
//  AddressBookViewController.m
//  FaceBook
//
//  Created by HMN on 14-6-25.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "AddressBookViewController.h"
#import "BCHTTPRequest.h"
#import "AFNetworking.h"
#import "AddressBookCell.h"

@interface AddressBookViewController ()

@end

@implementation AddressBookViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        phoneArray = [[NSMutableArray alloc] initWithCapacity:100];
        phoneDic = [[NSMutableDictionary alloc] initWithCapacity:100];
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
    self.title = @"邀请好友";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 22, 40, 40);
    [backButton setBackgroundImage:[UIImage imageNamed:@"login_backButton@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //[self.navigationController.view addSubview:backButton];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;

    
    //messageCenterTableView
    searchAddressBookTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,IS_IOS_7?self.view.frame.size.height-64:self.view.frame.size.height) style:UITableViewStylePlain];
    searchAddressBookTableView.delegate = self ;
    searchAddressBookTableView.dataSource = self ;
    searchAddressBookTableView.backgroundView = nil ;
    searchAddressBookTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:searchAddressBookTableView];
    searchAddressBookTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self getPhoneContacts];
    
    NSLog(@"通讯录%@",phoneArray);
    
    
    [BCHTTPRequest postFriendFromAddressBookWithUsersArray:phoneArray usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            [phoneDic setValuesForKeysWithDictionary:resultDic];
            
            [searchAddressBookTableView reloadData];
        }
    }];

    
}

#pragma mark - 返回
-(void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) getPhoneContacts{
    
    ABAddressBookRef addressBook = nil;
    if([[UIDevice currentDevice].systemVersion doubleValue] >= 6.0)
    {
        addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    //    else
    //    {
    //        addressBook = ABAddressBookCreate();
    //    }
    
    NSArray *temPeoples = (__bridge NSArray *) ABAddressBookCopyArrayOfAllPeople(addressBook);
    for(id temPerson in temPeoples)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:2];
        
        NSString *tmpFirstName = (__bridge NSString *) ABRecordCopyValue((__bridge ABRecordRef)(temPerson), kABPersonFirstNameProperty);
        NSString *tmpLastName = (__bridge NSString *) ABRecordCopyValue((__bridge ABRecordRef)(temPerson), kABPersonLastNameProperty);
        
        ABMultiValueRef phone = ABRecordCopyValue((__bridge ABRecordRef)(temPerson), kABPersonPhoneProperty);
        
        if (tmpFirstName == nil) {
            tmpFirstName = @"";
        }
        
        if (tmpLastName == nil) {
            tmpLastName = @"";
        }
        
        NSString *nameString = [NSString stringWithFormat:@"%@%@", tmpLastName,tmpFirstName];
        
        [dic setValue:nameString forKey:@"name"];
        
        //电话号码
        NSString *personPhone = (__bridge NSString *) ABMultiValueCopyValueAtIndex(phone, 0);
        if (personPhone == nil) {
            personPhone = @"";
        }
        
        personPhone = [personPhone stringByReplacingOccurrencesOfString:@"+86" withString:@""];
        personPhone = [personPhone stringByReplacingOccurrencesOfString:@" " withString:@""];
        personPhone = [personPhone stringByReplacingOccurrencesOfString:@"-" withString:@""];
        personPhone = [personPhone stringByReplacingOccurrencesOfString:@"(" withString:@""];
        personPhone = [personPhone stringByReplacingOccurrencesOfString:@")" withString:@""];
        personPhone = [personPhone stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        [dic setValue:personPhone forKey:@"phone"];
        
        if ([nameString isEqualToString:@""] == NO && [personPhone isEqualToString:@""] == NO) {
            [phoneArray addObject:dic];
        }
        
    }
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([phoneDic[@"users"] count] < 1) {
        return 1;
    }else if ([phoneDic[@"list"] count] <1 && [phoneDic[@"users"] count] < 1)
    {
        return 0;
    }else
    {
        return 2;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([phoneDic[@"users"] count] < 1) {
        return [phoneDic[@"list"] count];
    }else
    {
        if (section == 0) {
            return [phoneDic[@"users"] count];
        }else
        {
            return [phoneDic[@"list"] count];
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 144/2;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = [UIColor colorWithRed:141.0f/255.0f green:141.0f/255.0f blue:141.0f/255.0f alpha:0.8];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 200, 22)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:14];
    titleLabel.backgroundColor = [UIColor clearColor];
    
    if ([phoneDic[@"users"] count] < 1) {
        titleLabel.text = @"通讯录";
    }else
    {
        if (section == 0) {
            titleLabel.text = @"脸谱用户";
        }else if (section == 1)
        {
            titleLabel.text = @"通讯录";
        }
        
    }
    
    [header addSubview:titleLabel];
    return header;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimepleNewsListcell = @"SimpleNewsListcells";
    AddressBookCell *cell = [tableView dequeueReusableCellWithIdentifier:SimepleNewsListcell];
    if (cell == nil) {
        cell = [[AddressBookCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimepleNewsListcell];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //pictureImageView;图片
    
    [cell.cellBackImageView setBackgroundColor:[UIColor clearColor]];
    
    NSDictionary *Dic = [[NSDictionary alloc] init];
    
    cell.myButton.tag = indexPath.row;
    cell.inviteButton.tag = indexPath.row;
    
    if ([phoneDic[@"users"] count] <1) {
        
        Dic = phoneDic[@"list"][indexPath.row];
        //        cell.myButton.tag = indexPath.row;
        //        [cell.myButton addTarget:self action:@selector(clickMyAttentionButton:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }else
    {
        if (indexPath.section == 0) {
            Dic = phoneDic[@"users"][indexPath.row];
            //            cell.myButton.tag = indexPath.row;
            //            [cell.myButton addTarget:self action:@selector(clickMyButton:) forControlEvents:UIControlEventTouchUpInside];
            
        }else
        {
            Dic = phoneDic[@"list"][indexPath.row];
            //            cell.myButton.tag = indexPath.row;
            //            [cell.myButton addTarget:self action:@selector(clickMyAttentionButton:) forControlEvents:UIControlEventTouchUpInside];
            
        }
    }
    
    [cell.pictureImageView setImageWithURL:[NSURL URLWithString:Dic[@"pic"]] placeholderImage:[UIImage imageNamed:@"morentouxiang@2x"]];
    cell.nameLabel.text = Dic[@"name"];
    
    [cell.lineImageView setImage:[UIImage imageNamed:@"shouyecellxian@2x"]];
    
    if ([Dic[@"type"] integerValue] == 1) {
        
        cell.inviteButton.hidden = YES;
        cell.myButton.hidden = NO;
        
        [cell.myButton setUserInteractionEnabled:YES];
        [cell.myButton setTitle:@"加为好友" forState:UIControlStateNormal];
        [cell.myButton setBackgroundImage:[UIImage imageNamed:@"tongguoyanzheng@2x"] forState:UIControlStateNormal];
        cell.myButton.tag = 100000+indexPath.row;
        [cell.myButton addTarget:self action:@selector(clickMyButton:) forControlEvents:UIControlEventTouchUpInside];
    }else
    {
        
        cell.inviteButton.hidden = NO;
        cell.myButton.hidden = YES;
        
        [cell.inviteButton setUserInteractionEnabled:YES];
        [cell.inviteButton setTitle:@"邀请" forState:UIControlStateNormal];
        [cell.inviteButton setBackgroundImage:[UIImage imageNamed:@"tongguoyanzheng@2x"] forState:UIControlStateNormal];
        [cell.inviteButton addTarget:self action:@selector(clickMyAttentionButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

//添加
- (void)clickMyButton:(UIButton *)button
{
    NSLog(@"tianjia");
    NSLog(@"%ld",(long)button.tag);
    
    //好友类型 1：找老乡找好友时添加的，扫一扫、搜手机号、脸谱号 2：app其他途径加的好友3：手机通讯录4：从群中加好友
    [BCHTTPRequest AddTheNewFriendsWithFriendsID:phoneDic[@"users"][button.tag-100000][@"id"] WithFriendsType:@"3" WithGroupID:@"" WithGroupType:@"" WithInforString:@"" usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            ;
        }
    }];
}

//邀请
- (void)clickMyAttentionButton:(UIButton *)button
{
    NSLog(@"yaoqing");
    
    NSLog(@"%ld",(long)button.tag);
    NSString *str = [NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInformation"] objectForKey:@"invitation"]];
    
    compose = [[MFMessageComposeViewController alloc] init];
    compose.messageComposeDelegate = self;
    compose.body = [NSString stringWithFormat:@"脸谱正式推出中国金融职场社交平台【金融部落】，目前只接受邀请码（%@）注册。下载请到苹果、安卓商店或 http://www.facebookchina.cn【脸谱科技】",str];
    
    NSArray *array = [NSArray arrayWithObjects:phoneDic[@"list"][button.tag][@"phone"],nil];
    compose.recipients = array;
    
    [self presentViewController:compose animated:YES completion:^{
        ;
    }];
    
}


//编辑完成后发送、关闭短信页面
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    
    [controller dismissViewControllerAnimated:YES completion:^{
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
