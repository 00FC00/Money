//
//  PictureDetialsViewController.m
//  FaceBook
//
//  Created by fengshaohui on 14-5-26.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "PictureDetialsViewController.h"

@interface PictureDetialsViewController ()

@end

@implementation PictureDetialsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        moreimageArray = [[NSMutableArray alloc]initWithCapacity:100];
        myCompanyDiction = [[NSMutableDictionary alloc]initWithCapacity:200];
        //buttonImageArray = [[NSArray alloc]initWithObjects:@"ceshi@2x",@"zhongxianwenying@2x",@"changxianjuejin@2x",@"huapandianjing@2x", nil];
  

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //界面部分
    //导航栏
    self.view.backgroundColor = [UIColor whiteColor];
    if (IS_IOS_7) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios7"] forBarMetrics:UIBarMetricsDefault];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios6"] forBarMetrics:UIBarMetricsDefault];
    }
    self.title = @"";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 22, 40, 40);
    [backButton setBackgroundImage:[UIImage imageNamed:@"login_backButton@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //[self.navigationController.view addSubview:backButton];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;
    //整体背景
    backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-64)];
    backImageView.backgroundColor = [UIColor clearColor];
    backImageView.userInteractionEnabled = YES;
    [backImageView setImage:[UIImage imageNamed:@"dabeijing@2x"]];
    [self.view addSubview:backImageView];
    
    imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-64)];
    imageScrollView.backgroundColor = [UIColor lightGrayColor];
    imageScrollView.pagingEnabled = YES;
    imageScrollView.showsHorizontalScrollIndicator = NO;
    imageScrollView.showsVerticalScrollIndicator = NO;
    imageScrollView.delegate = self;
    [self.view addSubview:imageScrollView];
    //显示pageController的view
    pageview=[[UIView alloc]initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-64-20, 320, 30/2)];
    [pageview setBackgroundColor:[UIColor clearColor]];
    [pageview setAlpha:0.90];
    [self.view addSubview:pageview];
    //小点
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(120,0, 154/2, 23/2)];
    pageControl.numberOfPages = 4;
    pageControl.currentPage = [self.myPage integerValue];
    [pageview addSubview:pageControl];
    [pageControl bringSubviewToFront:imageScrollView];
    //*************轮播图获取图片***********************
    moreimageArray = self.allPicArray;
    [self AdImg:moreimageArray];
    
    [imageScrollView setContentOffset:CGPointMake(320*pageControl.currentPage, 0)];
    [self setCurrentPage:pageControl.currentPage];

}
- (void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    pageControl.currentPage=scrollView.contentOffset.x/320;
    [self setCurrentPage:pageControl.currentPage];
    
}
#pragma mark - 下载图片
void STockImageFromURL( NSURL * URL, void (^imageBlock)(UIImage * image), void (^errorBlock)(void) )
{
    dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^(void)
                   {
                       NSData * data = [[NSData alloc] initWithContentsOfURL:URL] ;
                       UIImage * image = [[UIImage alloc] initWithData:data];
                       dispatch_async( dispatch_get_main_queue(), ^(void){
                           if( image != nil )
                           {
                               imageBlock( image );
                           } else {
                               errorBlock();
                           }
                       });
                   });
}
- (void) setCurrentPage:(NSInteger)secondPage {
    
    for (NSUInteger subviewIndex = 0; subviewIndex < [pageControl.subviews count]; subviewIndex++) {
        UIImageView* pagePointview = [pageControl.subviews objectAtIndex:subviewIndex];
        //NSLog(@"❤❤%@",pagePointview);
        CGSize size;
        size.height = 16/2;
        size.width = 16/2;
        [pagePointview.layer setMasksToBounds:YES];
        [pagePointview.layer setCornerRadius:16/4];
        [pagePointview setFrame:CGRectMake(pagePointview.frame.origin.x, pagePointview.frame.origin.y,size.width,size.height)];
        if (subviewIndex == secondPage)
        {
            //pagePointview.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pagepoint1@2x.png"]];
            //ios7可以用这个方法
            pagePointview.layer.contents = (id)[UIImage imageNamed:@"pagepoint1@2x.png"].CGImage;
            
        }else
        {
            //pagePointview.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pagepoint2@2x.png"]];
            //ios7可以用这个方法
            pagePointview.layer.contents = (id)[UIImage imageNamed:@"pagepoint2@2x.png"].CGImage;
            
        }
    }
}
-(void)AdImg:(NSMutableArray *)arr{
    
    NSLog(@"%@",arr);
    [imageScrollView setContentSize:CGSizeMake(320*[moreimageArray count],[[UIScreen mainScreen] bounds].size.height-64)];
    pageControl.numberOfPages=[arr count];
    
    for ( int i=0; i<[arr count]; i++) {
        NSString *url=arr[i];
        
//        UIButton *img=[[UIButton alloc]initWithFrame:CGRectMake(320*i, 0, 320, [[UIScreen mainScreen] bounds].size.height-64)];
//        [img addTarget:self action:@selector(Action) forControlEvents:UIControlEventTouchUpInside];
//        [imageScrollView addSubview:img];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(320*i, 0, 320, [[UIScreen mainScreen] bounds].size.height-64)];
        [imageScrollView addSubview:imageView];
        
        
        
        STockImageFromURL( [NSURL URLWithString:url], ^( UIImage * image )
                          {
                              
                              //[img setBackgroundImage:image forState:UIControlStateNormal];
                              [imageView setImage:image];
                             //imageView.contentMode = UIViewContentModeScaleAspectFit;
                              //[img setBackgroundImage:image forState:UIControlStateHighlighted];
                          }, ^(void){
                          });
    }
    
}
-(void)Action
{
    
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
