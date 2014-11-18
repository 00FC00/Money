//
//  ChatImageScrollViewController.m
//  ChuMian
//
//  Created by 颜 沛贤 on 13-10-29.
//
//

#import "ChatImageScrollViewController.h"

#import "NSData+Base64.h"
@interface ChatImageScrollViewController ()

@end

@implementation ChatImageScrollViewController

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
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:248.0f/255.0f green:249.0f/255.0f blue:251.0f/255.0f alpha:1.0];
    if (IS_IOS_7) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios7"] forBarMetrics:UIBarMetricsDefault];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios6"] forBarMetrics:UIBarMetricsDefault];
    }
    self.title = @"图片";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

    
    //返回
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 22, 40, 40);
    [backButton setBackgroundImage:[UIImage imageNamed:@"login_backButton@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //[self.navigationController.view addSubview:backButton];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;
    
    
    // 初始化 scrollview
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320,self.view.frame.size.height )];
    self.mainScrollView.bounces = YES;
    self.mainScrollView.pagingEnabled = YES;
    self.mainScrollView.delegate = self;
    self.mainScrollView.userInteractionEnabled = YES;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.mainScrollView];
    
    if (self.imagesArray.count > 0) {
        for (int i = 0;i<[self.imagesArray count];i++)
        {
            UIImage * t_image = [UIImage imageWithData:[NSData dataFromBase64String:self.imagesArray[i]]];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:t_image];
            imageView.frame = CGRectMake((320 * i), 0, 320, [UIScreen mainScreen].bounds.size.height - 20-44);
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            //[imageView setClipsToBounds:YES];
            [self.mainScrollView addSubview:imageView]; //
        }
        
        [self.mainScrollView setContentSize:CGSizeMake(320 * [self.imagesArray count] , [UIScreen mainScreen].bounds.size.height - 20-44)];
        
        [self.mainScrollView setContentOffset:CGPointMake(320*_indexrow, 0) animated:YES];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ButtonClicked
//返回
- (void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
    
    
}




@end
