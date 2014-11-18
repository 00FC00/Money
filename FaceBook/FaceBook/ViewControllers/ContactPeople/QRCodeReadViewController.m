//
//  QRCodeReadViewController.m
//  LifeTogether
//
//  Created by fengshaohui on 14-2-27.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "QRCodeReadViewController.h"
#import "PublicObject.h"

#import "DMCAlertCenter.h"
#import "BCBaseObject.h"
#import "QRCodeDetialsViewController.h"
#import "BCHTTPRequest.h"
#import "MySweepViewController.h"

@interface QRCodeReadViewController ()
{
    CGRect readLineViewRect;
    UIImage *hbImage;
}

@end

@implementation QRCodeReadViewController

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
    if (IS_IOS_7) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios7"] forBarMetrics:UIBarMetricsDefault];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios6"] forBarMetrics:UIBarMetricsDefault];
    }
    self.title = @"扫一扫";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 22, 40, 40);
    [backButton setBackgroundImage:[UIImage imageNamed:@"login_backButton@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(clickbackButton) forControlEvents:UIControlEventTouchUpInside];
    //[self.navigationController.view addSubview:backButton];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;

    [self loopDrawLine];
}

- (void)clickbackButton
{
    [readview stop];
    [readLineView stopAnimating];
    readLineView.hidden = YES;
    [readview removeFromSuperview];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loopDrawLine
{
    if (self.view.frame.size.height>480) {
        readLineViewRect = CGRectMake(106/2, 180/2, 428/2, 4/2);
        hbImage=[UIImage imageNamed:@"saoyisao5@2x"];
        
    }else
    {
        readLineViewRect = CGRectMake(106/2, IS_IOS_7?180/2:180/2, 428/2, 4/2);
        hbImage=[UIImage imageNamed:@"saoyisao4@2x"];
    }
    
    if (readLineView) {
        [readLineView removeFromSuperview];
    }
    readLineView = [[UIImageView alloc] initWithFrame:readLineViewRect];
    readLineView.image = [UIImage imageNamed:@"line@2x"];
    //readLineView.backgroundColor = [UIColor blueColor];
    [UIView animateWithDuration:3.0
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         //修改frame的代码写在这里
                         readLineView.frame =CGRectMake(110/2, readLineViewRect.origin.y+180, 420/2, 4/2);
                         [readLineView setAnimationRepeatCount:0];
                         
                     }
                     completion:^(BOOL finished){
                         if (!is_Anmotion) {
                             [self loopDrawLine];
                         }
                         
                     }];
    
    if (!is_have) {
        
        //添加一个背景图片
        
        UIImageView *hbImageview=[[UIImageView alloc] initWithImage:hbImage];
        
        CGRect hbImagerect=CGRectMake(0, IS_IOS_7?-44:-44, 320, self.view.frame.size.height);
        [hbImageview setFrame:hbImagerect];
        
        readview = [ZBarReaderView new];
        readview.backgroundColor = [UIColor redColor];
        readview.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
        readview.torchMode = 0;
        readview.readerDelegate = self;
        readview.allowsPinchZoom = NO;//使用手势变焦
        readview.trackingColor = [UIColor clearColor];
        readview.showsFPS = NO;// 显示帧率  YES 显示  NO 不显示
        readview.scanCrop = CGRectMake(0, 0, 1, 1);//将被扫描的图像的区域
        //        CGRect scanMaskRect = CGRectMake(60, CGRectGetMidY(readview.frame) - 126, 200, 200);
        //        readview.scanCrop = [self getScanCrop:scanMaskRect readerViewBounds:readview.bounds];
        [readview addSubview:hbImageview];
        [hbImageview addSubview:readLineView];
        
        [self.view addSubview:readview];
        [readview start];
        is_have = YES;
    }
    [self.view addSubview:readLineView];
}
//根据实际情况 自己设置参数  ，需要注意的是 扫描到数据后一定要记得：
//[readerView stop];
//[readerView removeFromSuperview];

//-(CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
//{
//    CGFloat x,y,width,height;
//
//    x = rect.origin.x / readerViewBounds.size.width;
//    y = rect.origin.y / readerViewBounds.size.height;
//    width = rect.size.width / readerViewBounds.size.width;
//    height = rect.size.height / readerViewBounds.size.height;
//
//    return CGRectMake(x, y, width, height);
//}

- (void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    
    const zbar_symbol_t *symbol = zbar_symbol_set_first_symbol(symbols.zbarSymbolSet);
    
    NSString *symbolStr = [NSString stringWithUTF8String: zbar_symbol_get_data(symbol)];
    //NSLog(@"rrrrr%u",zbar_symbol_get_type(symbol));
    NSLog(@"----->%@",symbolStr);
    
    if (zbar_symbol_get_type(symbol) == ZBAR_QRCODE)
    {  // 是否QR二维码 http:
        
        NSString *str1 = [symbolStr substringToIndex:5];
        //好友
        if ([str1 isEqualToString:@"lp_sn"]) {
            
            [BCHTTPRequest getMyFriendInformationWithLp_number:[symbolStr substringFromIndex:5] usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
                if (isSuccess == YES) {
                    //如果搜出结果跳转页面
                    MySweepViewController *mySweepVC = [[MySweepViewController alloc]init];
                    mySweepVC.mySweepDictionary = resultDic;
                    mySweepVC.friendIdString = resultDic[@"id"];
                    mySweepVC.fromString = @"扫一扫";
                    [self.navigationController pushViewController:mySweepVC animated:YES];
                }
            }]; 
            
        }else
        {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:[NSString stringWithFormat:@"此二维码内容为：%@",symbolStr]];
        }
        
    }
    else
    {
        NSLog(@"错误错误错误");
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"未发现二维码"];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
