//
//  CheckPostConditionViewController.m
//  FaceBook
//
//  Created by fengshaohui on 14-5-20.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "CheckPostConditionViewController.h"
#import "CheckPostConditionCell.h"
#import "BCHTTPRequest.h"
#import "GlobalVariable.h"

@interface CheckPostConditionViewController ()
{
    UITableView *checkTableView;
    NSMutableArray *checkArray;
    NSIndexPath *lastIndexPath;
}
@end

@implementation CheckPostConditionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        checkArray = [[NSMutableArray alloc] initWithCapacity:100];
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
    self.title = @"发布业务墙";
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
    
    if ([self.checkStr isEqualToString:@"style"]) {
        
        //请求分类
        GlobalVariable *globalVariable = [GlobalVariable sharedGlobalVariable];
        if (globalVariable.classificationArray == nil) {
            [BCHTTPRequest getBusinessTypeListWithUsingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
                if (isSuccess == YES) {
                    checkArray = resultDic[@"list"];
                    globalVariable.classificationArray = checkArray;
                    
                    [checkTableView reloadData];
                    
                }
            }];
        }else
        {
            checkArray = globalVariable.classificationArray;
        }
    }else if ([self.checkStr isEqualToString:@"identity"])
    {
        
        
        [checkArray addObject:[BCHTTPRequest getUserName]];
        
        if ([[BCHTTPRequest getUserName] isEqualToString:[BCHTTPRequest getUserFirstNickName]] == NO && [[BCHTTPRequest getUserFirstNickName] isEqualToString:[BCHTTPRequest getUserSecondNickName]] == NO) {
            [checkArray addObject:[BCHTTPRequest getUserFirstNickName]];
        }
        if ([[BCHTTPRequest getUserName] isEqualToString:[BCHTTPRequest getUserSecondNickName]] == NO) {
            [checkArray addObject:[BCHTTPRequest getUserSecondNickName]];
        }
        
        
        
        [checkTableView reloadData];
    }

    
}
- (void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark tableView 协议方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90/2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return checkArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimepleNewsListcell = @"SimpleNewsListcells";
    CheckPostConditionCell *cell = [tableView dequeueReusableCellWithIdentifier:SimepleNewsListcell];
    if (cell == nil) {
        cell = [[CheckPostConditionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimepleNewsListcell];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([self.checkStr isEqualToString:@"style"]) {
        
        if ([_mycellCheck isEqualToString:checkArray[indexPath.row][@"name"]] ) {
            cell.accessoryType =UITableViewCellAccessoryCheckmark;
            lastIndexPath = indexPath;
        }else
        {
            cell.accessoryType =UITableViewCellAccessoryNone;
        }

        cell.wcontectLabel.text = checkArray[indexPath.row][@"name"];
    }else if ([self.checkStr isEqualToString:@"identity"])
    {
        if ([_mycellCheck isEqualToString:checkArray[indexPath.row]] ) {
            cell.accessoryType =UITableViewCellAccessoryCheckmark;
            lastIndexPath = indexPath;
        }else
        {
            cell.accessoryType =UITableViewCellAccessoryNone;
        }

        cell.wcontectLabel.text = checkArray[indexPath.row];
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
    
    if ([self.checkStr isEqualToString:@"style"]) {
        
        [self.delegate setStyleValueWith:checkArray[indexPath.row]];
        
    }else if ([self.checkStr isEqualToString:@"identity"])
    {
        [self.delegate setIdentityValueWith:checkArray[indexPath.row]];
    }
    
    [self.navigationController popViewControllerAnimated:YES];

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
