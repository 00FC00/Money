//
//  WorkAreaViewController.m
//  FaceBook
//
//  Created by 虞海云 on 14-5-6.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "WorkAreaViewController.h"
#import "DMCAlertCenter.h"
@interface WorkAreaViewController ()


@property (strong, nonatomic) NSArray* ProvinceArray;
@property (strong, nonatomic) NSMutableArray* CityArray;
@property (strong, nonatomic) NSMutableArray *areaArray;
@end

@implementation WorkAreaViewController

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
    //省份
    self.ProvinceArray = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]];
    
    NSLog(@"cityarray is %@",self.ProvinceArray);
    if ([self.workCity length] > 0) {
    
        for (NSDictionary * itemDict in self.ProvinceArray) {
            if ([[itemDict objectForKey:@"state"] isEqualToString:self.workCity]) {
                //找到了选择的省
                self.CityArray = [itemDict objectForKey:@"cities"];//这个数组里面是字典
                break;
            }
        }

    }else
    {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"请先选择城市"];
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    if (IS_IOS_7) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios7"] forBarMetrics:UIBarMetricsDefault];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios6"] forBarMetrics:UIBarMetricsDefault];
    }
    self.title = @"选择区域";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 22, 40, 40);
    [backButton setBackgroundImage:[UIImage imageNamed:@"login_backButton@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //[self.navigationController.view addSubview:backButton];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;
    
    
    _areaTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height-20-44)];
    _areaTableView.delegate = self;
    _areaTableView.dataSource = self;
    [self.view addSubview:_areaTableView];
}

#pragma mark - tableView



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.CityArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        //选中颜色
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:198.0f/255.0f green:220.0f/255.0f blue:238.0f/255.0f alpha:1.0f];
        
        [cell.textLabel setTextColor:[UIColor blackColor]];
        cell.textLabel.font = [UIFont systemFontOfSize:18];
    }
    
    
    //cell.headImageView.image = [UIImage imageNamed:@"defaulthead"];
    cell.textLabel.text = [[self.CityArray objectAtIndex:indexPath.row] objectForKey:@"city"];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.delegate getWorkArea:[self.CityArray objectAtIndex:indexPath.row]];
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
