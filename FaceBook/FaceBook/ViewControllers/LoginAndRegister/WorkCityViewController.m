//
//  WorkCityViewController.m
//  FaceBook
//
//  Created by 虞海云 on 14-5-6.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "WorkCityViewController.h"
#import "CitiesManager.h"

@interface WorkCityViewController ()
{
    UITableView *cityTableView;
}

@property (strong, nonatomic) NSArray* ProvinceArray;
@property (strong, nonatomic) NSMutableArray* cityArray;

@end

@implementation WorkCityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.cityArray = [[NSMutableArray alloc] initWithCapacity:100];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //省份
    self.ProvinceArray = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]];
    [self getCityData];
    
    self.view.backgroundColor = [UIColor whiteColor];
    if (IS_IOS_7) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios7"] forBarMetrics:UIBarMetricsDefault];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios6"] forBarMetrics:UIBarMetricsDefault];
    }
    self.title = @"选择城市";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 22, 40, 40);
    [backButton setBackgroundImage:[UIImage imageNamed:@"login_backButton@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
   // [self.navigationController.view addSubview:backButton];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;
    
    cityTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height-20-44)];
    cityTableView.delegate = self;
    cityTableView.dataSource = self;
    [self.view addSubview:cityTableView];
    
    //
    _provinceDict = [CitiesManager getChinaCities];
    NSLog(@"city is %@",[CitiesManager getChinaCities]);
    if (IS_IOS_7) {
        if ([cityTableView respondsToSelector:@selector(setSectionIndexColor:)]) {
            cityTableView.sectionIndexBackgroundColor = [UIColor clearColor];
            cityTableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
        }

    }
    
}
-(void)getCityData
{
    for (int i = 0; i<self.ProvinceArray.count; i++) {
        [self.cityArray addObject:[[self.ProvinceArray objectAtIndex:i] objectForKey:@"state"]];
    }
}

#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[_provinceDict allKeys] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = [UIColor colorWithRed:155.0f/255.0f green:155.0f/255.0f blue:155.0f/255.0f alpha:0.7];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 200, 22)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    
    NSArray *allKeys = [[_provinceDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    titleLabel.text = [allKeys objectAtIndex:section];
    [header addSubview:titleLabel];
    return header;

}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *allKeys = [[_provinceDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    NSString *key = [allKeys objectAtIndex:section];
    NSArray *value = [_provinceDict valueForKey:key];
    return [value count];
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
    
    NSArray *allKeys = [[_provinceDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    NSString *key = [allKeys objectAtIndex:indexPath.section];
    NSArray *value = [_provinceDict valueForKey:key];
    
    //NSDictionary *studentInfo = [value objectAtIndex:indexPath.row];
    
    //cell.bgimageView.image =[UIImage imageNamed:@"elementLine"];
    
    //cell.headImageView.image = [UIImage imageNamed:@"defaulthead"];
    cell.textLabel.text = [[value objectAtIndex:indexPath.row] objectForKey:@"name"];

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *allKeys = [[_provinceDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    NSString *key = [allKeys objectAtIndex:indexPath.section];
    NSArray *value = [_provinceDict valueForKey:key];
    NSLog(@"province dict is %@",[value objectAtIndex:indexPath.row]);
    
    //代理传输地点
    [self.delegete getWorkCity:[value objectAtIndex:indexPath.row]];
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
        NSArray *allKeys = [[_provinceDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
        return allKeys;
        
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - 返回
-(void)backButtonClicked
{
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}

@end
