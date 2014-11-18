//
//  InstitutionsFaceBookViewController.m
//  FaceBook
//
//  Created by fengshaohui on 14-5-27.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "InstitutionsFaceBookViewController.h"
#import "BCHTTPRequest.h"
#import "LPRelationViewController.h"
#import "GlobalVariable.h"
#import "AFNetworking.h"
#import "InstitutionsMemberViewController.h"
@interface InstitutionsFaceBookViewController ()

@end

@implementation InstitutionsFaceBookViewController

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
    self.view.backgroundColor = [UIColor whiteColor];
        
    /////下面的时主题部分
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:_mainScrollView];
    //_mainScrollView.userInteractionEnabled = YES;
    [_mainScrollView setMaximumZoomScale:4.5];
    [_mainScrollView setMinimumZoomScale:1.0];
    
    _mainScrollView.delegate = self;
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.width)];
    imageView.userInteractionEnabled = YES;
    
    GlobalVariable *globalVariable = [GlobalVariable sharedGlobalVariable];

    ///获得圈圈图片的接口
    [BCHTTPRequest getLPImageWithInstitutionId:globalVariable.institutionsIdString SuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            //HTTP://lianpu.bloveambition.com/images/11.pngHTTP://lianpu.bloveambition.com/images/11.png
            [imageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[resultDic objectForKey:@"url"]]]]];
            //[imageView setImageWithURL:[NSURL URLWithString:@"http://lianpu.bloveambition.com/images/11.png"] placeholderImage:nil];
            finSize = CGSizeMake(imageView.frame.size.width, imageView.frame.size.height);
            [_mainScrollView addSubview:imageView];
            
            coord_x = [[resultDic objectForKey:@"cx"] floatValue];
            coord_y = [[resultDic objectForKey:@"cy"] floatValue];
            
            ///增加手势
            imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imtap:)];
            [imageView addGestureRecognizer:imageTap];//给哪个对象增加一个手势事件
            
        }
    }];
    
    
}

- (void)imtap:(UITapGestureRecognizer*)tap
{
    //tap.numberOfTapsRequired点击次数，tap.numberOfTouchesRequired几个手指点击（多指）
    CGPoint tapPoint = [imageTap locationInView:tap.view];
    NSLog(@"2222--%f,%f",tapPoint.x,tapPoint.y);
    NSString * o_x = [NSString stringWithFormat:@"%f",coord_x*2*tapPoint.x/self.view.frame.size.width];
    NSString * o_y = [NSString stringWithFormat:@"%f",coord_y*2*tapPoint.y/self.view.frame.size.width];
    
    GlobalVariable *globalVariable = [GlobalVariable sharedGlobalVariable];
    
    [BCHTTPRequest getPointsWithOrginX:o_x OrginY:o_y Distance:@"2000" InstitutionId:globalVariable.institutionsIdString successBlock:^(NSMutableArray *dataArray) {
        
//        LPRelationViewController * lpRelationVC = [[LPRelationViewController alloc] init];
//        lpRelationVC.lpDataArray = dataArray;
//        lpRelationVC.tapPoint = CGPointMake([o_x floatValue], [o_y floatValue]);
//        [self.navigationController pushViewController:lpRelationVC animated:YES];
        if (dataArray.count > 0) {
            InstitutionsMemberViewController *institutionsMemberVC = [[InstitutionsMemberViewController alloc] init];
            institutionsMemberVC.InstitutionsArray = dataArray;
            [self.navigationController pushViewController:institutionsMemberVC animated:YES];
        }else
        {
            ;
        }
        
    }];
}



//设置放大缩小的视图，要是uiscrollview的subview
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView;
{
    NSLog(@"viewForZoomingInScrollView");
    return imageView;
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
