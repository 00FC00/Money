//
//  InstitutionsMemberViewController.m
//  FaceBook
//
//  Created by fengshaohui on 14-8-1.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "InstitutionsMemberViewController.h"
#import "LineMainMemberCell.h"
#import "AFNetworking.h"
#import "OtherPeopleMessageDetialsViewController.h"
#import "GlobalVariable.h"

@interface InstitutionsMemberViewController ()

@end

@implementation InstitutionsMemberViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _InstitutionsArray = [[NSMutableArray alloc] initWithCapacity:100];
        
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
    self.title = @"确认关系";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 40, 40);
    [backButton setBackgroundImage:[UIImage imageNamed:@"login_backButton@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;
    
    
    _collectionView = [[PSCollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,IS_IOS_7?self.view.frame.size.height:self.view.frame.size.height-20)];
    _collectionView.collectionViewDelegate = self;
    _collectionView.collectionViewDataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _collectionView.numColsPortrait = 4;
    _collectionView.numColsLandscape = 4;
    [self.view addSubview:_collectionView];
    
    [_collectionView reloadData];
   
}
- (void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - PSCollectionViewDelegate and DataSource
- (NSInteger)numberOfViewsInCollectionView:(PSCollectionView *)collectionView {
    
    return [_InstitutionsArray count];
   // return 4;
}

- (PSCollectionViewCell *)collectionView:(PSCollectionView *)collectionView viewAtIndex:(NSInteger)index {
    
    LineMainMemberCell *cell = (LineMainMemberCell *)[self.collectionView dequeueReusableView];
    if (!cell) {
        cell = [[LineMainMemberCell alloc] initWithFrame:CGRectZero];
    }
    //int q = index % 4 ;
    cell.cellBackImageView.frame = CGRectMake(0, 0, 160/2, 203/2);
    NSDictionary *item = [_InstitutionsArray objectAtIndex:index];
    
    
    if (index % 4 ==0) {
        cell.headImageView.frame = CGRectMake(36/2, 37/2, 122/2, 122/2);
        
        cell.nameLabel.frame = CGRectMake(36/2, 170/2, 122/2, 30/2);
    }else if (index % 4 ==1)
    {
        cell.headImageView.frame = CGRectMake(28/2, 37/2, 122/2, 122/2);
        
        cell.nameLabel.frame = CGRectMake(28/2, 170/2, 122/2, 30/2);
    }else if (index % 4 ==2)
    {
        cell.headImageView.frame = CGRectMake(14/2, 37/2, 122/2, 122/2);
        cell.nameLabel.frame = CGRectMake(14/2, 170/2, 122/2, 30/2);
    }else if (index % 4 ==3)
    {
        cell.headImageView.frame = CGRectMake(0/2, 37/2, 122/2, 122/2);
        cell.nameLabel.frame = CGRectMake(0/2, 170/2, 122/2, 30/2);
    }
    [cell.headImageView setImageWithURL:[NSURL URLWithString:item[@"user_logo"]] placeholderImage:[UIImage imageNamed:@"touxiangmoren@2x"]];
    //[cell.headImageView setImage:[UIImage imageNamed:@"touxiangmoren@2x"]];
    cell.nameLabel.text = item[@"user_name"];
    //cell.nameLabel.text = [NSString stringWithFormat:@"%d",index];
    
    return cell;
}


- (CGFloat)heightForViewAtIndex:(NSInteger)index {
    return (136+37+30)/2;
}

- (void)collectionView:(PSCollectionView *)collectionView didSelectView:(PSCollectionViewCell *)view atIndex:(NSInteger)index {
       NSDictionary *item = [_InstitutionsArray objectAtIndex:index];
    GlobalVariable *globalVariable = [GlobalVariable sharedGlobalVariable];
    
    
    OtherPeopleMessageDetialsViewController *otherPeopleMessageDetialsVC = [[OtherPeopleMessageDetialsViewController alloc] init];
    otherPeopleMessageDetialsVC.friendIdString = item[@"user_id"];
    if ([globalVariable.institutionis_memberString integerValue]==0) {
        ///进入加站内联系人页面
        otherPeopleMessageDetialsVC.isInHere = @"yes";
    }else
    {
        otherPeopleMessageDetialsVC.isCircle = @"yes";
    }
    
    [self.navigationController pushViewController:otherPeopleMessageDetialsVC animated:YES];
    

//
//    MySweepViewController *mySweepVC = [[MySweepViewController alloc]init];
//    mySweepVC.fromString = @"群成员";
//    mySweepVC.friendIdString = item[@"user_id"];
//    mySweepVC.groupIdString = _departmentIdString;
//    mySweepVC.groupTypeString = @"2";
//    [self.navigationController pushViewController:mySweepVC animated:YES];
    
    
    
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
