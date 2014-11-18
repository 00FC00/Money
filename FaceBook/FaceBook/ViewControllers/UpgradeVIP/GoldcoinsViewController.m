//
//  GoldcoinsViewController.m
//  FaceBook
//
//  Created by HMN on 14-7-10.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "GoldcoinsViewController.h"
#import "GoldcoinsTableViewCell.h"
#import "BCHTTPRequest.h"
#import "DMCAlertCenter.h"


#import "AppDelegate.h"

#import "PartnerConfig.h"
#import "DataSigner.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"
#import "AlixPayOrder.h"

@implementation GoldcoinsItem

+ (GoldcoinsItem *) goldcoinsItem
{
	return [[self alloc] init];
}
@end

@interface GoldcoinsViewController ()

@end

@implementation GoldcoinsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        goldcoinsArray = [[NSMutableArray alloc] initWithCapacity:100];
        selectArray = [[NSMutableArray alloc] initWithCapacity:100];
        
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
    self.title = @"金币充值";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 40, 40);
    [backButton setBackgroundImage:[UIImage imageNamed:@"login_backButton@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;
    
    goldcoinsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, IS_IOS_7?self.view.frame.size.height-64:self.view.frame.size.height-44)];
    goldcoinsTableView.delegate = self;
    goldcoinsTableView.dataSource = self;
    [self.view addSubview:goldcoinsTableView];
    goldcoinsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [goldcoinsTableView setBackgroundColor:[UIColor colorWithRed:248.0f/255.0f green:249.0f/255.0f blue:251.0f/255.0f alpha:1.0]];
    
    goldcoinsTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 280/2)];
    
    ///方式一
    UILabel *methods1Label = [[UILabel alloc] initWithFrame:CGRectMake(40/2, 20/2, 580/2, 70/2)];
    methods1Label.text = @"方式一：通过邀请好友获得金币(个人主页－联系人－邀请好友)";
    methods1Label.numberOfLines = 2;
    methods1Label.textColor = [UIColor colorWithRed:53.0f/255.0f green:53.0f/255.0f blue:53.0f/255.0f alpha:1];
    methods1Label.font = [UIFont systemFontOfSize:14.5f];
    methods1Label.backgroundColor = [UIColor clearColor];
    [goldcoinsTableView.tableHeaderView addSubview:methods1Label];
    
    UIImageView *line1ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 105/2, self.view.frame.size.width, 1)];
    line1ImageView.image = [UIImage imageNamed:@"xiahuaxian@2x"];
    [goldcoinsTableView.tableHeaderView addSubview:line1ImageView];
    
    ///方式二
    UILabel *methods2Label = [[UILabel alloc] initWithFrame:CGRectMake(40/2, 45+20/2, 580/2, 80/2)];
    methods2Label.text = @"方式二:分享资讯到朋友圈获得金币（个人主页－部落资讯－分享）";
    methods2Label.textColor = [UIColor colorWithRed:53.0f/255.0f green:53.0f/255.0f blue:53.0f/255.0f alpha:1];
    methods2Label.font = [UIFont systemFontOfSize:14.5f];
    methods2Label.backgroundColor = [UIColor clearColor];
    [methods2Label setNumberOfLines:2];
    [goldcoinsTableView.tableHeaderView addSubview:methods2Label];
    
    UIImageView *line2ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 80+20, self.view.frame.size.width, 1)];
    line2ImageView.image = [UIImage imageNamed:@"xiahuaxian@2x"];
    [goldcoinsTableView.tableHeaderView addSubview:line2ImageView];
    
    ///方式三
    UILabel *methods3Label = [[UILabel alloc] initWithFrame:CGRectMake(40/2, 100+20/2, 580/2, 40/2)];
    methods3Label.text = @"方式三：充值获取金币";
    methods3Label.textColor = [UIColor colorWithRed:53.0f/255.0f green:53.0f/255.0f blue:53.0f/255.0f alpha:1];
    methods3Label.font = [UIFont systemFontOfSize:14.5f];
    methods3Label.backgroundColor = [UIColor clearColor];
    [goldcoinsTableView.tableHeaderView addSubview:methods3Label];
    
    UIImageView *line3ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100+80/2, self.view.frame.size.width, 1)];
    line3ImageView.image = [UIImage imageNamed:@"xiahuaxian@2x"];
    [goldcoinsTableView.tableHeaderView addSubview:line3ImageView];
    
    goldcoinsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 260/2)];
    //确认购买
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.frame = CGRectMake(30/2, 135/2, 580/2, 72/2);
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"querengoumai@2x"] forState:UIControlStateNormal];
    [confirmButton setTitle:@"确认购买" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [confirmButton addTarget:self action:@selector(clickConfirmButton) forControlEvents:UIControlEventTouchUpInside];
    [goldcoinsTableView.tableFooterView addSubview:confirmButton];
    
    
    [BCHTTPRequest goldcoinsListWithUsingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            
            for (int i = 0; i< [resultDic[@"list"] count]; i++) {
                GoldcoinsItem* goldcoinsItem = [GoldcoinsItem goldcoinsItem];
                goldcoinsItem.goldcoins = resultDic[@"list"][i][@"gold"];
                goldcoinsItem.price = resultDic[@"list"][i][@"title"];
                goldcoinsItem.goldcoinsId = [resultDic[@"list"][i][@"id"] intValue];
                [goldcoinsArray addObject:goldcoinsItem];
            }

            
            [goldcoinsTableView reloadData];
        }
    }];
    
    
    [self setEditing:YES animated:YES];
    
    
    
    
    _result = @selector(paymentResult:);
    
    [[NSNotificationCenter defaultCenter] addObserverForName:ALIPAYRESULT object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        NSLog(@"客户端成功之后调用接口");
        NSLog(@"%@",note.object);
        
        AlixPayResult* result = note.object;
        if (result)
        {
            
            if (result.statusCode == 9000)
            {
                /*
                 *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
                 */
                
                [BCHTTPRequest addGoldCoinsWithCoins:[NSString stringWithFormat:@"%d",goldcoins] usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
                    if (isSuccess == YES) {
                        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"支付成功！"];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }];
                
                //交易成功
                //            NSString* key = @"签约帐户后获取到的支付宝公钥";
                //			id<DataVerifier> verifier;
                //            verifier = CreateRSADataVerifier(key);
                //
                //			if ([verifier verifyString:result.resultString withSign:result.signString])
                //            {
                //                //验证签名成功，交易结果无篡改
                //			}
                
            }
            else
            {
                //交易失败
                [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"支付失败，请稍后再试"];
            }
        }
        else
        {
            //失败
            //交易失败
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"支付失败，请稍后再试"];
        }
        
        
        
    }];
    
//    [self.view addSubview:[[[UIApplication sharedApplication] windows] objectAtIndex:0]];
//    NSLog(@"-----%@",[[[UIApplication sharedApplication] windows] objectAtIndex:0]);
    
}


#pragma mark - 返回
-(void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 确认购买
- (void)clickConfirmButton
{
    
    if (selectArray.count<1) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"请选择要充值的金币"];
    }else
    {
        
        float n;
        for (int i = 0; i< selectArray.count; i++) {
            GoldcoinsItem* goldcoinsItem = selectArray[i];
            n +=[goldcoinsItem.price floatValue];
            
            goldcoins +=[goldcoinsItem.goldcoins integerValue];
        }
        NSLog(@"%f",n);
        
        _moneyString = [NSString stringWithFormat:@"%.2f",n];
        
        NSLog(@"%@",_moneyString);
        
        /*
         *生成订单信息及签名
         *由于demo的局限性，采用了将私钥放在本地签名的方法，商户可以根据自身情况选择签名方法
         */
        
        NSString *appScheme = @"FaceBook";
        NSString* orderInfo = [self getOrderInfo];
        NSString* signedStr = [self doRsa:orderInfo];
        
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                                 orderInfo, signedStr, @"RSA"];
        
       
        [AlixLibService payOrder:orderString AndScheme:appScheme seletor:_result target:self];
        
        
        
        
    }
    
    
}


-(void)paymentResultDelegate:(NSString *)result
{
    NSLog(@"result%@",result);
}
#pragma mark tableView 协议方法

//进入编辑状态
- (void) setEditing:(BOOL)editting animated:(BOOL)animated
{
    [super setEditing:editting animated:animated];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70/2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return goldcoinsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimepleNewsListcell = @"SimpleNewsListcells";
    GoldcoinsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimepleNewsListcell];
    if (cell == nil) {
        cell = [[GoldcoinsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimepleNewsListcell];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    GoldcoinsItem* goldcoinsItem = goldcoinsArray[indexPath.row];
    
    cell.goldcoinsLabel.text = [NSString stringWithFormat:@"%@金币",goldcoinsItem.goldcoins];
    
    cell.priceLabel.text = [NSString stringWithFormat:@"￥%@",goldcoinsItem.price];
    cell.lineImageView.image = [UIImage imageNamed:@"xiahuaxian@2x"];
    
    [cell setChecked:goldcoinsItem.checked];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GoldcoinsItem* goldcoinsItem = goldcoinsArray[indexPath.row];
    //根据对象被不被选中对选中数组进行增加和删除
    if (goldcoinsItem.checked) {
        [selectArray removeObject:goldcoinsItem];
        
    }else {
        [selectArray addObject:goldcoinsItem];
        
    }
    
    //cell选中和未选中的效果
    if (self.editing)
    {
        GoldcoinsTableViewCell *cell = (GoldcoinsTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        goldcoinsItem.checked = !goldcoinsItem.checked;
        [cell setChecked:goldcoinsItem.checked];
    }

}


-(NSString*)getOrderInfo
{
    /*
	 *点击获取prodcut实例并初始化订单信息
	 */
    
    //    NSMutableString * discription = [NSMutableString string] ;
    //	[discription appendFormat:@"partner=\"%@\"", PartnerID];
    //	[discription appendFormat:@"&seller_id=\"%@\"", SellerID];
    //	[discription appendFormat:@"&out_trade_no=\"%@\"", [self generateTradeNO]];
    //	[discription appendFormat:@"&subject=\"%@\"", @"美国留学"];
    //	[discription appendFormat:@"&body=\"%@\"", @"留学费用"];
    //	[discription appendFormat:@"&total_fee=\"%@\"", @"0.01"];
    //	[discription appendFormat:@"&notify_url=\"%@\"", @"m.alipay.com"];
    //    [discription appendFormat:@"&service=\"%@\"", @"mobile.securitypay.pay"];
    //    [discription appendFormat:@"&payment_type=\"%@\"",@"1"];
    //	[discription appendFormat:@"&_input_charset=\"%@\"", @"utf-8"];
    //    [discription appendFormat:@"&it_b_pay=\"%@\"", @"30m"];
    //	[discription appendFormat:@"&show_url=\"%@\"",@"m.alipay.com"];
    //    [discription appendFormat:@"&return_url=\"%@\"", @"m.alipay.com"];
    //    return discription;
    
    /*
	 *点击获取prodcut实例并初始化订单信息
	 */
	
    AlixPayOrder *order = [[AlixPayOrder alloc] init];
    order.partner = PartnerID;
    order.seller = SellerID;
    
    order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
	order.productName = @"购买金币"; //商品标题
	order.productDescription = @"购买金币"; //商品描述
	order.amount = [NSString stringWithFormat:@"%@",_moneyString]; //商品价格
	order.notifyURL =  @"http://www.facebookChina.cn"; //回调URL
	
	return [order description];
    
    
	
}

- (NSString *)generateTradeNO
{
	const int N = 15;
	
	NSString *sourceString = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	NSMutableString *result = [[NSMutableString alloc] init] ;
	srand(time(0));
	for (int i = 0; i < N; i++)
	{
		unsigned index = rand() % [sourceString length];
		NSString *s = [sourceString substringWithRange:NSMakeRange(index, 1)];
		[result appendString:s];
	}
	return result;
}


-(NSString*)doRsa:(NSString*)orderInfo
{
    id<DataSigner> signer;
    signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderInfo];
    return signedString;
}

//wap回调函数
-(void)paymentResult:(NSString *)resultd
{
    //结果处理
#if __has_feature(objc_arc)
    AlixPayResult* result = [[AlixPayResult alloc] initWithString:resultd];
#else
    AlixPayResult* result = [[[AlixPayResult alloc] initWithString:resultd] autorelease];
#endif
	if (result)
    {
		
        
		if (result.statusCode == 9000)
        {
			/*
			 *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
			 */
            
            NSLog(@"网页成功之后调用接口");
            
//            [BCHTTPRequest paySuccessUsingSuccessBlock:^(BOOL isSuccess) {
//                if (isSuccess == YES) {
                    [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"支付成功！"];
//                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
//                }
//            }];
            
            
            
            //交易成功
            //            NSString* key = @"签约帐户后获取到的支付宝公钥";
            //			id<DataVerifier> verifier;
            //            verifier = CreateRSADataVerifier(key);
            //
            //			if ([verifier verifyString:result.resultString withSign:result.signString])
            //            {
            //                //验证签名成功，交易结果无篡改
            //			}
        }
        else
        {
            //交易失败
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"支付失败，请稍后再试"];
        }
    }
    else
    {
        //失败
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"支付失败，请稍后再试"];
    }
    
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
