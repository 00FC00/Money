//
//  ChooseDepartmentViewController.m
//  FaceBook
//
//  Created by 虞海云 on 14-5-6.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "ChooseDepartmentViewController.h"
#import "BCHTTPRequest.h"

@interface ChooseDepartmentViewController ()
{
    UITableView *chooseDepartmentTableView;
    NSMutableArray *departmentArray;
}

@end

@implementation ChooseDepartmentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   // departmentArray = [[NSMutableArray alloc] initWithObjects:@"税务局",@"技术局",@"农业局", nil];
    self.view.backgroundColor = [UIColor whiteColor];
    if (IS_IOS_7) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios7"] forBarMetrics:UIBarMetricsDefault];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios6"] forBarMetrics:UIBarMetricsDefault];
    }
    self.title = @"部门条线选择";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 22, 40, 40);
    [backButton setBackgroundImage:[UIImage imageNamed:@"login_backButton@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
   // [self.navigationController.view addSubview:backButton];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;
    
    chooseDepartmentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, IS_IOS_7?0:0, 320,IS_IOS_7?self.view.frame.size.height-64:self.view.frame.size.height-44)];
    chooseDepartmentTableView.delegate = self;
    chooseDepartmentTableView.dataSource = self;
    [self.view addSubview:chooseDepartmentTableView];
    
    [BCHTTPRequest getDepartmentListWithID:[self.pid intValue] usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            departmentArray = resultDic[@"list"];
            if (departmentArray.count > 0) {
                [chooseDepartmentTableView reloadData];
            }
            
        }
    }];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [departmentArray count];
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
    cell.textLabel.text = departmentArray[indexPath.row][@"title"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:DepartmentNoti object:[departmentArray objectAtIndex:indexPath.row]];
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
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
