//
//  ChooseIdentityViewController.m
//  FaceBook
//
//  Created by 虞海云 on 14-5-6.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "ChooseIdentityViewController.h"
#import "BCHTTPRequest.h"
@interface ChooseIdentityViewController ()
{
    UITableView *chooseIdentityTableView;
    NSMutableArray *identityArray;
    
    NSString *isEnd;
}

@end

@implementation ChooseIdentityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        identityArray = [[NSMutableArray alloc] initWithCapacity:100];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    if (IS_IOS_7) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios7"] forBarMetrics:UIBarMetricsDefault];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios6"] forBarMetrics:UIBarMetricsDefault];
    }
    self.title = @"身份选择";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 22, 40, 40);
    [backButton setBackgroundImage:[UIImage imageNamed:@"login_backButton@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
   // [self.navigationController.view addSubview:backButton];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;
    
    
    chooseIdentityTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, IS_IOS_7?0:0, 320,IS_IOS_7?self.view.frame.size.height-64:self.view.frame.size.height-44)];
    chooseIdentityTableView.delegate = self;
    chooseIdentityTableView.dataSource = self;
    [self.view addSubview:chooseIdentityTableView];
    
    NSString *pid = @"0.1";
    [BCHTTPRequest getMyPositionWithPID:pid usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            identityArray = resultDic[@"list"];
            [chooseIdentityTableView reloadData];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [identityArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        [cell.textLabel setTextColor:[UIColor blackColor]];
        cell.textLabel.font = [UIFont systemFontOfSize:18];
    }
    cell.textLabel.text = identityArray[indexPath.row][@"name"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([isEnd isEqualToString:@"yes"]) {
        NSDictionary *dic = [[NSDictionary alloc]init];
        dic = identityArray[indexPath.row];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"showidentity" object:dic];
        [self dismissViewControllerAnimated:YES completion:^{
            ;
        }];

    }else
    {
    
    //有下一级
    if ([identityArray[indexPath.row][@"is_last"] isEqualToString:@"0"]) {
        
        [BCHTTPRequest getMyPositionWithPID:identityArray[indexPath.row][@"id"] usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
                identityArray = resultDic[@"list"];
                isEnd = @"no";
                [chooseIdentityTableView reloadData];
            }
        }];

    }else if ([identityArray[indexPath.row][@"is_last"] isEqualToString:@"1"])
    {
        
        isEnd = @"yes";
        [chooseIdentityTableView reloadData];
        
        //没有下一级调1.35接口
        
//        [BCHTTPRequest getInstitutionWithPID:[identityArray[indexPath.row][@"id"]intValue] usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
//            if (isSuccess == YES) {
//                identityArray = resultDic[@"list"];
//                isEnd = @"yes";
//                [chooseIdentityTableView reloadData];
//                
//            }
//        }];
        
    }
    
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 返回
-(void)backButtonClicked
{
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}

@end
