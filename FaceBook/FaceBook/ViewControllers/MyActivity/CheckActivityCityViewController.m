//
//  CheckActivityCityViewController.m
//  FaceBook
//
//  Created by fengshaohui on 14-5-21.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "CheckActivityCityViewController.h"
#import "CitiesManager.h"
@interface CheckActivityCityViewController ()
{
    NSArray *allKeysArray;
    NSMutableDictionary *cityData;
    
    NSArray* ProvinceArray;
    NSMutableArray* cityArray;
    NSMutableDictionary * _provinceDict;
}
@end

@implementation CheckActivityCityViewController




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        cityArray = [[NSMutableArray alloc]initWithCapacity:100];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    //省份
//    ProvinceArray = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]];
//    [self getCityData];

    
    self.view.backgroundColor = [UIColor colorWithRed:248.0f/255.0f green:249.0f/255.0f blue:251.0f/255.0f alpha:1.0];
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
    //[self.navigationController.view addSubview:backButton];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;
    
    //获取数据
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"citydict" ofType:@"plist"];
    cityData = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
   // NSLog(@"%@",cityData);
    allKeysArray = [[cityData allKeys] sortedArrayUsingSelector:@selector(compare:)] ;

    NSLog(@"%@",allKeysArray);
    
    //城市表
    myCityTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-64) style:UITableViewStylePlain];
    myCityTableView.backgroundColor = [UIColor clearColor];
    myCityTableView.delegate = self;
    myCityTableView.dataSource = self;
    [self.view addSubview:myCityTableView];
    
    
  //  _provinceDict = [CitiesManager getChinaCities];
    NSLog(@"city is %@",[CitiesManager getChinaCities]);
    if (IS_IOS_7) {
        if ([myCityTableView respondsToSelector:@selector(setSectionIndexColor:)]) {
            myCityTableView.sectionIndexBackgroundColor = [UIColor clearColor];
            myCityTableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
        }
        
    }

    myCityTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44*3)];
    myCityTableView.tableHeaderView.backgroundColor = [UIColor clearColor];
    
    for (int y= 0; y<3; y++) {
        UIImageView *xianImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30/2, (87/2)*y, 582/2, 2/2)];
        xianImageView.backgroundColor = [UIColor colorWithRed:198.0f/255.0f green:198.0f/255.0f blue:203.0f/255.0f alpha:1.0];
        [myCityTableView.tableHeaderView addSubview:xianImageView];
        
        UIButton *topButton = [UIButton buttonWithType:UIButtonTypeCustom];
        topButton.frame = CGRectMake(0, 44*y, self.view.frame.size.width,44);
        [topButton setBackgroundColor:[UIColor clearColor]];
        [topButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        topButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        topButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft ;
        //    但问题又出来，此时文字会紧贴到做边框，我们可以设置
        topButton.contentEdgeInsets = UIEdgeInsetsMake(0,30/2, 0, 5);
        topButton.titleLabel.font = [UIFont systemFontOfSize:18];
        if (y == 0) {
            [topButton setTitle:@"北京" forState:UIControlStateNormal];
        }else if (y == 1)
        {
            [topButton setTitle:@"上海" forState:UIControlStateNormal];
        }else if (y == 2)
        {
            [topButton setTitle:@"广州" forState:UIControlStateNormal];
        }
        [topButton addTarget:self action:@selector(clickTopButton:) forControlEvents:UIControlEventTouchUpInside];
        [myCityTableView.tableHeaderView addSubview:topButton];
    }
    
    
}
- (void)clickTopButton:(UIButton *)sender
{
    [self.delegate setActivityCityValueWith:sender.titleLabel.text];
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)getCityData
{
    for (int i = 0; i<ProvinceArray.count; i++) {
        [cityArray addObject:[[ProvinceArray objectAtIndex:i] objectForKey:@"state"]];
    }
}

#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [allKeysArray count];
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
    
    //NSArray *allKeys = [[_provinceDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    titleLabel.text = [allKeysArray objectAtIndex:section];
    [header addSubview:titleLabel];
    return header;
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
   // NSArray *allKeys = [[_provinceDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    NSString *key = [allKeysArray objectAtIndex:section];
    NSArray *value = [cityData valueForKey:key];
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
    
   // NSArray *allKeys = [[_provinceDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    NSString *key = [allKeysArray objectAtIndex:indexPath.section];
    NSArray *value = [cityData valueForKey:key];
    
    //NSDictionary *studentInfo = [value objectAtIndex:indexPath.row];
    
    //cell.bgimageView.image =[UIImage imageNamed:@"elementLine"];
    
    //cell.headImageView.image = [UIImage imageNamed:@"defaulthead"];
    cell.textLabel.text = [value objectAtIndex:indexPath.row];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   // NSArray *allKeys = [[_provinceDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    NSString *key = [allKeysArray objectAtIndex:indexPath.section];
    NSArray *value = [cityData valueForKey:key];
    NSLog(@"province dict is %@",[value objectAtIndex:indexPath.row]);


    [self.delegate setActivityCityValueWith:value[indexPath.row]];

    [self.navigationController popViewControllerAnimated:YES];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
   
   // NSArray *allKeys = [[_provinceDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    return allKeysArray;

    
    
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
