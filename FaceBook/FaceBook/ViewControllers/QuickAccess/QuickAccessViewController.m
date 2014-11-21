//
//  QuickAccessViewController.m
//  FaceBook
//
//  Created by HMN on 14-4-25.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "QuickAccessViewController.h"
#import "AppDelegate.h"

#import "GlobalVariable.h"
#import "BCHTTPRequest.h"

#import "QuickAccessTableViewCell.h"
#import "SettingViewController.h"

#import "SUNViewController.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"

@interface QuickAccessViewController ()
{
    UITableView *quickAccessTableView;
}
@end

@implementation QuickAccessViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        moduleArray = [[NSMutableArray alloc] initWithCapacity:100];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:219.0f/255.0f green:219.0f/255.0f blue:219.0f/255.0f alpha:1.0];
    
    if (IS_IOS_7) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios7"] forBarMetrics:UIBarMetricsDefault];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios6"] forBarMetrics:UIBarMetricsDefault];
    }
    self.title = @"快捷访问";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame = CGRectMake(0, 22, 40, 40);
    [menuButton setBackgroundImage:[UIImage imageNamed:@"caidan@2x"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(menuButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //[self.navigationController.view addSubview:backButton];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:menuButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;
    
    //登录
    UIButton *setButton = [UIButton buttonWithType:UIButtonTypeCustom];
    setButton.frame = CGRectMake(526/2, 22, 80/2, 80/2);
    [setButton setBackgroundImage:[UIImage imageNamed:@"shezhianniu@2x"] forState:UIControlStateNormal];
    [setButton addTarget:self action:@selector(setButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:setButton];
    self.navigationItem.rightBarButtonItem=rightbuttonitem;

    
    quickAccessTableView = [[UITableView alloc] initWithFrame:CGRectMake(6, 4, self.view.frame.size.width-12,IS_IOS_7?self.view.frame.size.height-64-4:self.view.frame.size.height-44-4) style:UITableViewStylePlain];
    quickAccessTableView.delegate = self;
    quickAccessTableView.dataSource = self;
    [self.view addSubview:quickAccessTableView];
    quickAccessTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"ModuleUser"]);
    [self getMyData];
    
    //接收通知
    [[NSNotificationCenter defaultCenter] addObserverForName:@"moduleQuickAccess" object:nil queue:nil usingBlock:^(NSNotification *note) {
        [moduleArray removeAllObjects];
//        [moduleArray addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"ModuleUser"]];
//        
//        [quickAccessTableView reloadData];
        [self getMyData];
        
    }];
    
}
- (void)getMyData
{
    [BCHTTPRequest getTheQuickAccessListWithUsingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            
            
//            NSDictionary *dic = [resultDic objectForKey:@"list"];
//            
//            NSArray *moduleNameArray = [[NSArray alloc] init];
//            
//            if ([dic isKindOfClass:[NSDictionary class]]) {
//                
//                NSArray *values = [dic allValues];
//                
//                moduleNameArray = values;
//            }
            
            //=============================
            
        
            
            NSArray *moduleNameArray = [[NSArray alloc] init];
            moduleNameArray = resultDic[@"list"];
            
            NSMutableArray *moduleUserArray = [[NSMutableArray alloc] initWithCapacity:100];
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ModuleUser"] ) {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ModuleUser"];
            }
            
            for (int i = 0; i< moduleNameArray.count; i++) {
                
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:100];
                [dic setObject:moduleNameArray[i] forKey:@"moduleName"];
                
                if([moduleNameArray[i] isEqualToString:@"我的部落"])
                {
                    [dic setObject:@"wodelianpuqun@2x" forKey:@"moduleImage"];
                }else if([moduleNameArray[i] isEqualToString:@"聊天"])
                {
                    [dic setObject:@"liaotian@2x" forKey:@"moduleImage"];
                }else if([moduleNameArray[i] isEqualToString:@"联系人"])
                {
                    [dic setObject:@"lianxiren@2x" forKey:@"moduleImage"];
                }else if([moduleNameArray[i] isEqualToString:@"朋友圈"])
                {
                    [dic setObject:@"pengyouquan@2x" forKey:@"moduleImage"];
                }else if([moduleNameArray[i] isEqualToString:@"部落群"])
                {
                    [dic setObject:@"lianpuqun@2x" forKey:@"moduleImage"];
                }else if([moduleNameArray[i] isEqualToString:@"部落墙"])
                {
                    [dic setObject:@"yewuqiang@2x" forKey:@"moduleImage"];
                }else if([moduleNameArray[i] isEqualToString:@"部落资讯"])
                {
                    [dic setObject:@"zixun@2x" forKey:@"moduleImage"];
                    
                }else if([moduleNameArray[i] isEqualToString:@"部落活动"])
                {
                    [dic setObject:@"wodehuodong@2x" forKey:@"moduleImage"];
                }else if([moduleNameArray[i] isEqualToString:@"同乡校友"])
                {
                    [dic setObject:@"tongchenglaoxiang@2x" forKey:@"moduleImage"];
                }else if([moduleNameArray[i] isEqualToString:@"部落消息"])
                {
                    [dic setObject:@"xiaoxi@2x" forKey:@"moduleImage"];
                }else if([moduleNameArray[i] isEqualToString:@"升级为VIP"])
                {
                    [dic setObject:@"shengjiVip@2x" forKey:@"moduleImage"];
                }
                
                
                [moduleUserArray addObject:dic];
                
            }
            
            
            [[NSUserDefaults standardUserDefaults] setObject:moduleUserArray forKey:@"ModuleUser"];
            
            
            
            [moduleArray addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"ModuleUser"]];
            [quickAccessTableView reloadData];
        }
    }];

}

#pragma mark - 菜单
- (void)menuButtonClicked
{
    SUNViewController *drawerController = (SUNViewController *)self.navigationController.mm_drawerController;
    
    if (drawerController.openSide == MMDrawerSideNone) {
        [drawerController openDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
            
        }];
    }else if  (drawerController.openSide == MMDrawerSideLeft) {
        [drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
            
        }];
    }

}
#pragma mark - 设置
- (void)setButtonClicked
{
    SettingViewController *settingVC = [[SettingViewController alloc]init];
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return moduleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    QuickAccessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[QuickAccessTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSLog(@"%@",moduleArray);
    
    cell.titleLabel.text = moduleArray[indexPath.row][@"moduleName"];
    cell.headImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",moduleArray[indexPath.row][@"moduleImage"]]];
    cell.lineImageView.image = [UIImage imageNamed:@"xiahuaxian@2x"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    

//    GlobalVariable *globalVariable = [GlobalVariable sharedGlobalVariable];
//    globalVariable.meduleDic = moduleArray[indexPath.row];
    [BCHTTPRequest AddTheMenuItemWithMenuName:[moduleArray[indexPath.row][@"moduleName"]  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            //添加本地模块
            NSMutableArray *menuArray = [[NSMutableArray alloc] initWithCapacity:100];
            [menuArray addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"ModuleMenu"]];
            [menuArray addObject:moduleArray[indexPath.row]];
            
            //重新存储
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ModuleMenu"];
            [[NSUserDefaults standardUserDefaults] setObject:menuArray forKey:@"ModuleMenu"];
            
            
            //去除快捷访问模块
            [moduleArray removeObjectAtIndex:indexPath.row];
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ModuleUser"];
            [[NSUserDefaults standardUserDefaults] setObject:moduleArray forKey:@"ModuleUser"];
            
            //通知模块刷新
            [[NSNotificationCenter defaultCenter] postNotificationName:@"moduleAdd" object:nil];
            
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
//            DDMenuController * rootController = ((AppDelegate*)[UIApplication sharedApplication].delegate).menuController;
//            [rootController showLeftController:YES];

        }
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
