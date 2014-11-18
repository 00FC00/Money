//
//  InformationViewController.m
//  FaceBook
//
//  Created by HMN on 14-4-29.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "InformationViewController.h"
#import "BottomView.h"
#import "TopView.h"
#import "AppDelegate.h"


#import "InformationDetailViewController.h"
#import "SettingViewController.h"

#import "BCHTTPRequest.h"

#import "SUNViewController.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"

#define BottomViewWidth 246.0/2
#define BottomViewHeight 269.0/2

#define TopViewWidth self.view.frame.size.width-30

@interface InformationViewController ()<UIScrollViewDelegate,TopViewDelegate>
{
    UIScrollView * _topScrollView;
    UIScrollView * _bottomScrollView;
    
    NSMutableArray * _bottomDataArray;
    NSMutableArray * _topDataArray;
    
    CGFloat TopViewHeight;
    
}


@end

@implementation InformationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _bottomDataArray = [[NSMutableArray alloc] initWithCapacity:0];
        _topDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:248.0f/255.0f green:249.0f/255.0f blue:251.0f/255.0f alpha:1.0];
    CGFloat orgin_y =0.0;
    if (IS_IOS_7) {
        orgin_y =64.0;
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios7"] forBarMetrics:UIBarMetricsDefault];
    }else{
        orgin_y =44.0;
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios6"] forBarMetrics:UIBarMetricsDefault];
    }
    self.title = @"部落资讯";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame = CGRectMake(0, 22, 40, 40);
    [menuButton setBackgroundImage:[UIImage imageNamed:@"caidan@2x"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(menuButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:menuButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;
    
    //设置
    UIButton *setButton = [UIButton buttonWithType:UIButtonTypeCustom];
    setButton.frame = CGRectMake(526/2, 22, 80/2, 80/2);
    [setButton setBackgroundImage:[UIImage imageNamed:@"shezhianniu@2x"] forState:UIControlStateNormal];
    [setButton addTarget:self action:@selector(setButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:setButton];
    self.navigationItem.rightBarButtonItem=rightbuttonitem;
    

    TopViewHeight = self.view.frame.size.height-BottomViewHeight-orgin_y-45.0;
    
    //上面的滚动视图
    _topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-BottomViewHeight-orgin_y-20)];
    [_topScrollView setPagingEnabled:YES];
    _topScrollView.backgroundColor = [UIColor colorWithRed:246.0/255 green:247.0/255 blue:249.0/255 alpha:1.0];
    [self.view addSubview:_topScrollView];
    
    //获取我的分类，上面的滚动条
    [self reloadMyListData:NO];
    
    
    //下面的滚动视图
    _bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-BottomViewHeight-orgin_y-20, self.view.frame.size.width, BottomViewHeight+20)];
    _bottomScrollView.tag = 999;
    _bottomScrollView.delegate = self;
    _bottomScrollView.backgroundColor = [UIColor colorWithRed:211.0/255 green:211.0/255 blue:211.0/255 alpha:1.0];
    [self.view addSubview:_bottomScrollView];
    
    
    //获取所有分类--下面的滚动条
    [BCHTTPRequest getZXMainListWithUsingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            
            NSMutableArray *dataArray = [[NSMutableArray alloc] initWithArray:resultDic[@"list"]];
            
            for (NSInteger j = 0; j < dataArray.count; j++) {
                
                BottomView * b_view = [[BottomView alloc] initWithFrame:CGRectMake(15+(15+BottomViewWidth)*j, 9, BottomViewWidth, BottomViewHeight)];
                [b_view setDataWithDict:[dataArray objectAtIndex:j]];
                b_view.tag = 100+j;
                [_bottomScrollView addSubview:b_view];
                UISwipeGestureRecognizer * swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureClicked:)];
                swipeGesture.direction = UISwipeGestureRecognizerDirectionUp;
                [b_view addGestureRecognizer:swipeGesture];
            }
            
            [_bottomScrollView setContentSize:CGSizeMake(15+(15+BottomViewWidth)*dataArray.count, BottomViewHeight)];
            
            _bottomDataArray = dataArray;
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

#pragma mark - 上划手势订阅资讯
//上划手势
- (void)swipeGestureClicked:(UISwipeGestureRecognizer*)swipeGesture
{
    NSLog(@"6666666666--%d",swipeGesture.view.tag);
    NSLog(@"%f,%f",swipeGesture.view.frame.origin.x,swipeGesture.view.frame.origin.y);
    
    NSLog(@"~~~~~~%f",swipeGesture.view.frame.origin.x-_bottomScrollView.contentOffset.x);
    
    BottomView * b_view = [[BottomView alloc] initWithFrame:CGRectMake(swipeGesture.view.frame.origin.x-_bottomScrollView.contentOffset.x, _topScrollView.frame.origin.y+_topScrollView.frame.size.height+10, BottomViewWidth, BottomViewHeight)];
    [b_view setDataWithDict:[_bottomDataArray objectAtIndex:swipeGesture.view.tag-100]];
    [self.view addSubview:b_view];
    [self.view bringSubviewToFront:b_view];
    
    [UIView animateWithDuration:1.3 animations:^{
        [b_view setFrame:CGRectMake((self.view.frame.size.width-246.0/2)/2, 90, BottomViewWidth, BottomViewHeight)];
    } completion:^(BOOL finished) {
        [b_view removeFromSuperview];
        //在此处调用:5.7 订阅资讯接口
        [BCHTTPRequest dyueZXWithTypeId:[[_bottomDataArray objectAtIndex:swipeGesture.view.tag-100] objectForKey:@"id"] usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
                NSLog(@"成功");
                [self reloadMyListData:YES];
            }else
            {
                NSLog(@"失败");
            }
        }];
        
    }];
    
}

#pragma mark - 刷新订阅视图
//刷新上面的scrollview的视图
- (void)reloadMyListData:(BOOL)isScroll
{
    //获取我的分类，上面的滚动条
    [BCHTTPRequest getMyZXListWithUsingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        NSMutableArray *dataArray = [[NSMutableArray alloc] initWithArray:resultDic[@"list"]];
        if (dataArray.count > 0) {
            //
            _topDataArray = dataArray;
            
            for (NSInteger i = 0; i < dataArray.count; i++) {
                
                TopView * t_view = [[TopView alloc] initWithFrame:CGRectMake(15+self.view.frame.size.width*i, 9, TopViewWidth, TopViewHeight)];
                t_view.delegate = self;
                [t_view setDataWithDict:[dataArray objectAtIndex:i]];
                t_view.backgroundColor = [UIColor orangeColor];
                [_topScrollView addSubview:t_view];
            }
            
            [_topScrollView setContentSize:CGSizeMake(self.view.frame.size.width*dataArray.count, TopViewHeight)];
            
            if (isScroll == YES) {
                [_topScrollView setContentOffset:CGPointMake(self.view.frame.size.width*(dataArray.count-1), 0)];
            }
            
        }else {
            //没有数据
            for (UIView * subView in _topScrollView.subviews) {
                [subView removeFromSuperview];
            }
        }

    }];
    
    
}


//上面的视图，根据id滑动到相应的视图
- (void)sortScrollViewWithZXId:(NSString*)zxid
{
    NSInteger index = 0;
    for (NSInteger i= 0; i < _topDataArray.count; i++) {
        //
        if ([[[_topDataArray objectAtIndex:i] objectForKey:@"id"] integerValue] == [zxid integerValue]) {
            //确定了是第几个
            index = i;
            
            break;
        }
    }
    
    
    
}


#pragma mark - TopViewDelegate
- (void)getTopDetailViewWith:(NSDictionary *)dict
{
    //点击进入详情页
   // NSLog(@"hello--%@",dict);
    InformationDetailViewController *informationDetailViewController = [[InformationDetailViewController alloc] init];
    informationDetailViewController.informationId = dict[@"id"];
    informationDetailViewController.informationTitle = dict[@"title"];
    informationDetailViewController.informationAddTime = dict[@"add_time"];
    [self.navigationController pushViewController:informationDetailViewController animated:YES];
    
}

- (void)deleteDetailViewWith:(NSDictionary *)dict
{
    //点击删除-此处调用5.8 取消资讯订阅接口，删除成功之后调用
    //NSLog(@"delete--%@",dict);
    
    [BCHTTPRequest quxiaoDyueZXWithTypeId:[dict objectForKey:@"id"] usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            [self reloadMyListData:NO];
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
