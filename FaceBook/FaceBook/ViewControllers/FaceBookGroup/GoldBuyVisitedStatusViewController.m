//
//  GoldBuyVisitedStatusViewController.m
//  FaceBook
//
//  Created by fengshaohui on 14-7-1.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "GoldBuyVisitedStatusViewController.h"
#import "GoldBuyVisitedStatusCell.h"
#import "DMCAlertCenter.h"

@interface GoldBuyVisitedStatusViewController ()

@end

@implementation GoldBuyVisitedStatusViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        checkStr = @"";
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:246.0f/255.0f green:247.0f/255.0f blue:249.0f/255.0f alpha:1];
    
    if (IS_IOS_7) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios7"] forBarMetrics:UIBarMetricsDefault];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios6"] forBarMetrics:UIBarMetricsDefault];
    }
    self.title = @"金币购买访问资格";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 22, 40, 40);
    [backButton setBackgroundImage:[UIImage imageNamed:@"login_backButton@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;
    
    //选项
    checkTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height-64) style:UITableViewStylePlain];
    checkTableView.backgroundColor = [UIColor colorWithRed:246.0f/255.0f green:247.0f/255.0f blue:249.0f/255.0f alpha:1];
    checkTableView.delegate = self;
    checkTableView.dataSource = self;
    checkTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:checkTableView];
    
    checkTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 72)];
    checkTableView.tableFooterView.backgroundColor = [UIColor clearColor];
    
    //确认购买
    finishButton=[UIButton buttonWithType:UIButtonTypeCustom];
    finishButton.frame=CGRectMake(28/2, 36/2, 580/2, 72/2);
    [finishButton setBackgroundImage:[UIImage imageNamed:@"querengoumai@2x"] forState:UIControlStateNormal];
    [finishButton setTitle:@"确认购买" forState:UIControlStateNormal];
    [finishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    finishButton.titleLabel.font=[UIFont systemFontOfSize:16];
    finishButton.userInteractionEnabled=YES;
    [finishButton addTarget:self action:@selector(clickFinishButton) forControlEvents:UIControlEventTouchUpInside];
    [checkTableView.tableFooterView addSubview:finishButton];
    
    
}
- (void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 确认购买
- (void)clickFinishButton
{
    if ([checkStr isEqualToString:@""]) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"请先选择购买种类"];
    }else
    {
        [self.delegate setStyleValueWith:checkStr];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}
#pragma mark tableView 协议方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72/2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimepleNewsListcell = @"SimpleNewsListcells";
    GoldBuyVisitedStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:SimepleNewsListcell];
    if (cell == nil) {
        cell = [[GoldBuyVisitedStatusCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimepleNewsListcell];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //lastIndexPath = indexPath;
    
    if (indexPath.row == 0) {
        cell.contectLabel.text = [NSString stringWithFormat:@"%@金币       %@天",_diction[@"days_coins"],_diction[@"days"]];
    }else if (indexPath.row == 1)
    {
        cell.contectLabel.text = [NSString stringWithFormat:@"%@金币       %@月",_diction[@"month_one_coins"],_diction[@"month_one"]];
    }else if (indexPath.row == 2)
    {
        cell.contectLabel.text = [NSString stringWithFormat:@"%@金币       %@月",_diction[@"month_two_coins"],_diction[@"month_two"]];
    }

    
    [cell.lineImageView setImage:[UIImage imageNamed:@"xiahuaxian@2x"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    int newrow=[indexPath row];
    int oldrow=(lastIndexPath !=nil)?[lastIndexPath row] : -1;
    
    if(newrow !=oldrow)
    {
        
        
        UITableViewCell *newCell=[tableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType=UITableViewCellAccessoryCheckmark;
        
        UITableViewCell *oldCell=[tableView cellForRowAtIndexPath:lastIndexPath];
        oldCell.accessoryType=UITableViewCellAccessoryNone;
        lastIndexPath=indexPath;
        
    }

//    UITableViewCell *newCell=[tableView cellForRowAtIndexPath:indexPath];
//    newCell.accessoryType=UITableViewCellAccessoryCheckmark;
    checkStr = @"";
    
    NSString *str = [NSString stringWithFormat:@"%d",indexPath.row+1];
    checkStr = str;
    
    
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
