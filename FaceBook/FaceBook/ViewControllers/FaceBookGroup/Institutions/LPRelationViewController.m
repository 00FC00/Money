//
//  LPRelationViewController.m
//  CircleTest
//
//  Created by 颜沛贤 on 14-7-10.
//  Copyright (c) 2014年 颜沛贤. All rights reserved.
//

#import "LPRelationViewController.h"
#import "BCHTTPRequest.h"
#import "GlobalVariable.h"

#define CirCleTopOrgin 340.0


@interface LPRelationViewController ()

@end

@implementation LPRelationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        Datadic = [[NSMutableDictionary alloc] initWithCapacity:100];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:248.0f/255.0f green:249.0f/255.0f blue:251.0f/255.0f alpha:1.0];
    if (IS_IOS_7) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios7"] forBarMetrics:UIBarMetricsDefault];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios6"] forBarMetrics:UIBarMetricsDefault];
    }
    self.title = @"确认关系页面";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 22, 40, 40);
    [backButton setBackgroundImage:[UIImage imageNamed:@"login_backButton@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //[self.navigationController.view addSubview:backButton];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;
    ////！！！！！！！这个页面的UI需要大幅度的修改
    
    NSLog(@"point is %f,%f",self.tapPoint.x,self.tapPoint.y);
    NSLog(@"array is %@",self.lpDataArray);
    
    for (NSDictionary * lpDict in self.lpDataArray) {
        //
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGFloat orgin_x = self.view.frame.size.width/2*[[lpDict objectForKey:@"coord_x"] floatValue]/self.tapPoint.x;
        CGFloat orgin_y = CirCleTopOrgin/2*[[lpDict objectForKey:@"coord_y"] floatValue]/self.tapPoint.y;
        button.frame = CGRectMake(orgin_x, orgin_y, 55/2, 33/2);
        //button.titleLabel.adjustsFontSizeToFitWidth = YES;
        [button setTitle:[lpDict objectForKey:@"user_name"] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:8]];
        [button setBackgroundImage:[UIImage imageNamed:@"quanquanyuan@2x"] forState:UIControlStateNormal];
        button.tag = [[lpDict objectForKey:@"id"] integerValue];
        
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
    
}

- (void)clickButton:(UIButton *)button
{
    for (NSDictionary * lpDict in self.lpDataArray) {
        if ([lpDict[@"id"] integerValue] == button.tag) {
           
            bgScrollView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            bgScrollView.backgroundColor = [UIColor colorWithRed:135.0f/255.0f green:137.0f/255.0f blue:140.0f/255.0f alpha:0.8];
            [self.view addSubview:bgScrollView];
            
            alertView = [[UIView alloc] initWithFrame:CGRectMake(110/2, (self.view.frame.size.height-729/2)/2+64/2, 420/2, 320/2)];
            alertView.backgroundColor = [UIColor colorWithRed:241.0f/255.0f green:241.0f/255.0f blue:241.0f/255.0f alpha:1];
            alertView.layer.cornerRadius = 3;
            [alertView.layer setMasksToBounds:YES];
            alertView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.7, 0.7);
            [bgScrollView addSubview:alertView];
            
            
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(18/2, 22/2, 300/2, 30/2)];
            nameLabel.text = [NSString stringWithFormat:@"%@是我的",lpDict[@"user_name"]];
            nameLabel.textColor = [UIColor colorWithRed:119.0f/255.0f green:153.0f/255.0f blue:208.0f/255.0f alpha:1];
            nameLabel.font = [UIFont systemFontOfSize:15];
            nameLabel.backgroundColor = [UIColor clearColor];
            [alertView addSubview:nameLabel];
            
            NSArray *titleArray = [[NSArray alloc] initWithObjects:@"同事",@"领导",@"下属", nil];
            
            int y = 30;
            for (int i = 0; i<4; i++) {
                UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, 420/2, 1)];
                lineImageView.image = [UIImage imageNamed:@"xiahuaxian@2x"];
                [alertView addSubview:lineImageView];
                

                if (i != 3) {
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                    button.frame = CGRectMake(0, y, 420/2, 70/2);
                    [button setTitle:titleArray[i] forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor colorWithRed:119.0f/255.0f green:153.0f/255.0f blue:208.0f/255.0f alpha:1] forState:UIControlStateNormal];
                    button.tag = i;
                    [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
                    [button addTarget:self action:@selector(clickTitleButton:) forControlEvents:UIControlEventTouchUpInside];
                    [alertView addSubview:button];
                    
                    Datadic = [lpDict mutableCopy];
                }
                
                
                y+=70/2;
            }
            
            
            
            
            
            [UIView animateWithDuration:0.2 animations:^{
                alertView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0f, 1.0f);
            } completion:^(BOOL finished) {
                
            }];
        }
    }
}

#pragma mark - 返回
- (void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickTitleButton:(UIButton *)button
{
    NSLog(@"----%@",Datadic[@"user_name"]);
    
    NSString *typeString;
    
    if (button.tag == 0) {
        typeString = @"1";
    }else if (button.tag == 1) {
        typeString = @"2";
    }else if (button.tag == 2) {
        typeString = @"3";
    }
    
    GlobalVariable *globalVariable = [GlobalVariable sharedGlobalVariable];
    
    [BCHTTPRequest confirmationWithType:typeString WithFriend_id:Datadic[@"user_id"] WithInstitution_id:globalVariable.institutionsIdString usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            alertView.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.7, 0.7);
            [bgScrollView removeFromSuperview];
        }
    }];
    
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    alertView.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.7, 0.7);
    [bgScrollView removeFromSuperview];
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
