//
//  BCHTTPRequest.m
//  ChangQu
//
//  Created by 牛 方健 on 13-4-13.
//  Copyright (c) 2013年 BC. All rights reserved.
//

#import "BCHTTPRequest.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "BCBaseObject.h"
#import "DMCAlertCenter.h"
#import "SVProgressHUD.h"


@implementation BCHTTPRequest


#pragma mark -
#pragma mark BaseRequest
//获取Dictionary数据
+ (void)getDictionaryWithStringURL:(NSString *)stringURL usingSuccessBlock:(void (^)(NSDictionary *resultDictionary))successBlock andFailureBlock:(void (^)(NSError *resultError))failureBlock
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:stringURL]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    __weak AFHTTPRequestOperation*weakOperation = operation;
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        successBlock([NSJSONSerialization JSONObjectWithData:weakOperation.responseData options:NSJSONReadingMutableContainers error:nil]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureBlock(error);
    }];
    [operation start];
}
#pragma mark - 测试
//测试
+ (void)getCeShiUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"http://taogu.bloveambition.com/test.php"];
    NSLog(@"首页获取广告图%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"首页获取广告图%@",resultDictionary);
        
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock(NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];
    
}
#pragma mark - 启动页接口
//启动页图片
+ (void)getTheLoadingImagesWithUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/start/index",kMainUrlString];
    NSLog(@"启动页图片%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"启动页图片%@",resultDictionary);
        
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
            //[[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock(NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

#pragma mark - 登录/注册
//登录
+ (void)loginTheFaceBookWithPhone:(NSString *)phone WithPassWord:(NSString *)password UsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@index.php?r=default/start/login/",kMainUrlString]]];
    
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:nil parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData)  {
        [formData appendPartWithFormData:[phone dataUsingEncoding:NSUTF8StringEncoding] name:@"phone"];
        [formData appendPartWithFormData:[password dataUsingEncoding:NSUTF8StringEncoding] name:@"password"];
        
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        [SVProgressHUD showProgress:totalBytesWritten/totalBytesExpectedToWrite status:@"登录中" maskType:SVProgressHUDMaskTypeBlack];
    }];
    [httpClient enqueueHTTPRequestOperation:operation];
    
    //上传完成
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"$$$%@",operation.responseString);
        
        [SVProgressHUD dismiss];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"图片%@",dict);
        
        if (1 == [dict[@"state"] integerValue]) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserInformation"];
            [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"UserInformation"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",[dict objectForKey:@"stype"]] forKey:@"STYPE"];
            successBlock(YES,dict);
        }else{
            if (dict!= nil) {
                [[DMCAlertCenter defaultCenter] postAlertWithMessage:[dict objectForKey:@"message"]];
            }
            successBlock(NO,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//用户忘记密码
+ (void)findMyPassWordWithPhone:(NSString *)phone WithCode:(NSString *)code WithNewPassWord:(NSString *)newPassWord UsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    [SVProgressHUD show];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@index.php?r=default/start/editPassword/",kMainUrlString]]];
    
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:nil parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData)  {
        [formData appendPartWithFormData:[phone dataUsingEncoding:NSUTF8StringEncoding] name:@"phone"];
        [formData appendPartWithFormData:[code dataUsingEncoding:NSUTF8StringEncoding] name:@"code"];
        [formData appendPartWithFormData:[newPassWord dataUsingEncoding:NSUTF8StringEncoding] name:@"password"];
        
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
//    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
//        
////        [SVProgressHUD showProgress:totalBytesWritten/totalBytesExpectedToWrite status:@"登录中" maskType:SVProgressHUDMaskTypeBlack];
//        
//    }];
    [httpClient enqueueHTTPRequestOperation:operation];
    
    //上传完成
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"$$$%@",operation.responseString);
        
        [SVProgressHUD dismiss];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"图片%@",dict);
        
        if (1 == [dict[@"state"] integerValue]) {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"找回成功"];
            successBlock(YES,dict);
        }else{
            successBlock(NO,nil);
            if (dict!= nil) {
                [[DMCAlertCenter defaultCenter] postAlertWithMessage:[dict objectForKey:@"message"]];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

#pragma mark - 登录后获取信息操作
//是否登录
+ (BOOL)isLogin
{
    if (nil != [[NSUserDefaults standardUserDefaults] objectForKey:@"UserInformation"]) {
        return YES;
    }else{
        return NO;
    }
    
}
//退出登录
+ (void)exitLogin
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserInformation"];
}
//获取用户id
+ (NSString *)getUserId
{
    if (nil != [[NSUserDefaults standardUserDefaults] objectForKey:@"UserInformation"]) {
        return [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInformation"] objectForKey:@"id"];
    }else
    {
        return @"";
    }
}

//获取用户手机号码
+ (NSString *)getUserPhone
{
    if (nil != [[NSUserDefaults standardUserDefaults] objectForKey:@"UserInformation"]) {
        return [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInformation"] objectForKey:@"phone"];
    }else
    {
        return @"";
    }
  
}

//获取用户token
+ (NSString *)getUserToken
{
    if (nil != [[NSUserDefaults standardUserDefaults] objectForKey:@"UserInformation"]) {
        return [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInformation"] objectForKey:@"token"];
    }else
    {
        return @"";
    }
}

//获取真实姓名
+ (NSString *)getUserName
{
    if (nil != [[NSUserDefaults standardUserDefaults] objectForKey:@"UserInformation"]) {
        return [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInformation"] objectForKey:@"name"];
    }else
    {
        return @"";
    }
}

//获取第一个昵称
+ (NSString *)getUserFirstNickName
{
    if (nil != [[NSUserDefaults standardUserDefaults] objectForKey:@"UserInformation"]) {
        return [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInformation"] objectForKey:@"nickname_first"];
    }else
    {
        return @"";
    }
}

//获取第二个昵称
+ (NSString *)getUserSecondNickName
{
    if (nil != [[NSUserDefaults standardUserDefaults] objectForKey:@"UserInformation"]) {
        return [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInformation"] objectForKey:@"nickname_second"];
    }else
    {
        return @"";
    }
}

//获取type资料是否完善类型
+ (BOOL)getUserType
{
    if (nil != [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInformation"] objectForKey:@"type"]) {
        if ([[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInformation"] objectForKey:@"type"] integerValue] == 1) {
            return YES;
        }else
        {
            return NO;
        }
    }
    
    return NO;
    
}

//判断出生地点，学校信息是否完善
+ (BOOL)getTheCicyType
{
    if (nil != [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInformation"] objectForKey:@"stype"]) {
        NSLog(@"11111111");
        if ([[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInformation"] objectForKey:@"stype"] integerValue] == 1) {
            NSLog(@"2222222222");
            return YES;
        }else
        {
            NSLog(@"33333333333");
            return NO;
        }
    }
    NSLog(@"44444444444");
    return NO;

}
//获取用户是否是VIP★★★
+ (BOOL)getUserVIP
{
    if (nil != [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInformation"] objectForKey:@"is_vip"]) {
        if ([[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInformation"] objectForKey:@"is_vip"] integerValue] == 1) {
            return YES;
        }else
        {
            return NO;
        }
    }
    
    return NO;
    
}

//获取脸谱号
+ (NSString *)getUserLPNumber
{
    if (nil != [[NSUserDefaults standardUserDefaults] objectForKey:@"UserInformation"]) {
        return [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInformation"] objectForKey:@"lp_sn"];
    }else
    {
        return @"";
    }
}

//获取用户的头像
+ (NSString *)getUserLogo
{
    if (nil != [[NSUserDefaults standardUserDefaults] objectForKey:@"UserInformation"]) {
        return [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInformation"] objectForKey:@"pic"];
    }else
    {
        return @"";
    }
    
}


/*
 **注册、找回密码
 */
//获取手机验证码
+ (void)GetTheRegisterCodeWithType:(int)type
                         WithPhone:(NSString *)phone
                 UsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/start/code&phone=%@&type=%d",kMainUrlString,phone,type];
    NSLog(@"获取手机验证码网址%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"获取手机验证码%@",resultDictionary);
        
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
            if (resultDictionary!= nil) {
                
                [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            }
            successBlock(NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//注册第一步
+ (void)RegisterTheFirstWithName:(NSString *)name WithPhone:(NSString *)phone WithCode:(NSString *)code WithPassWord:(NSString *)password WithGender:(NSString *)gender WithNickName_First:(NSString *)firstNickName WithNickName_Second:(NSString *)secondNickName WithWorkCicy:(NSString *)city WithWorkArea:(NSString *)workArea  WithPicture:(NSString *)pic WithClause:(NSString *)clause WithInvitation:(NSString *)invitation usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@index.php?r=default/start/register/",kMainUrlString]]];
    
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:nil parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData)  {
        [formData appendPartWithFormData:[name dataUsingEncoding:NSUTF8StringEncoding] name:@"name"];
        [formData appendPartWithFormData:[phone dataUsingEncoding:NSUTF8StringEncoding] name:@"phone"];
        [formData appendPartWithFormData:[code dataUsingEncoding:NSUTF8StringEncoding] name:@"code"];
        [formData appendPartWithFormData:[password dataUsingEncoding:NSUTF8StringEncoding] name:@"password"];
        [formData appendPartWithFormData:[gender dataUsingEncoding:NSUTF8StringEncoding] name:@"gender"];
        [formData appendPartWithFormData:[firstNickName dataUsingEncoding:NSUTF8StringEncoding] name:@"nickname_first"];
        [formData appendPartWithFormData:[secondNickName dataUsingEncoding:NSUTF8StringEncoding] name:@"nickname_second"];
        [formData appendPartWithFormData:[city dataUsingEncoding:NSUTF8StringEncoding] name:@"work_city"];
        [formData appendPartWithFormData:[workArea dataUsingEncoding:NSUTF8StringEncoding] name:@"work_area"];
        
        [formData appendPartWithFormData:[pic dataUsingEncoding:NSUTF8StringEncoding] name:@"pic"];
        [formData appendPartWithFormData:[clause dataUsingEncoding:NSUTF8StringEncoding] name:@"clause"];
        [formData appendPartWithFormData:[invitation dataUsingEncoding:NSUTF8StringEncoding] name:@"invitation"];
        
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        [SVProgressHUD showProgress:totalBytesWritten/totalBytesExpectedToWrite status:@"上传中" maskType:SVProgressHUDMaskTypeBlack];
    }];
    [httpClient enqueueHTTPRequestOperation:operation];
    
    //上传完成
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"$$$%@",operation.responseString);
        
        [SVProgressHUD dismiss];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"信息%@",dict);
        
        if (1 == [dict[@"state"] integerValue]) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserInformation"];
            [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"UserInformation"];
            //调取接口4.44
            
            [self sendTheUserTokenAndDriveTokenWithUsingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
                if (isSuccess == YES) {
                    NSLog(@"可以聊天");
                }
            }];
            
            successBlock(YES,dict);
        }else{
            
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:dict[@"message"]];
            successBlock(NO,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//注册第二部
+ (void)RegisterTheSecondWithInstitution_id:(NSString *)institutionID WithCompany:(NSString *)company WithDepartmentID:(NSString *)department_id WithInvestment_preference_id:(NSString *)investment_preference_id WithBirth_city:(NSString *)birth_city WithBirth_area:(NSString *)birth_area WithPrimary_school:(NSString *)primary_school WithJunior_middle_school:(NSString *)junior_middle_school WithHigh_school:(NSString *)high_school WithUniversity:(NSString *)university usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@index.php?r=default/start/userInfo/",kMainUrlString]]];
    
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:nil parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData)  {
        //[self getUserId]
        NSLog(@"背景-%@",institutionID);
         NSLog(@"公司-%@",company);
         NSLog(@"部门-%@",department_id);
         NSLog(@"投资-%@",investment_preference_id);
         NSLog(@"城市-%@",birth_city);
         NSLog(@"地区-%@",birth_area);
         NSLog(@"小学-%@",primary_school);
         NSLog(@"初中-%@",junior_middle_school);
         NSLog(@"高中-%@",high_school);
         NSLog(@"大学-%@",university);
        
        
        //NSString *str = @"14";
        [formData appendPartWithFormData:[[self getUserId] dataUsingEncoding:NSUTF8StringEncoding] name:@"uid"];
        [formData appendPartWithFormData:[institutionID dataUsingEncoding:NSUTF8StringEncoding] name:@"class_id"];//institution_id
        [formData appendPartWithFormData:[company dataUsingEncoding:NSUTF8StringEncoding] name:@"company"];
        [formData appendPartWithFormData:[department_id dataUsingEncoding:NSUTF8StringEncoding] name:@"department_id"];
        [formData appendPartWithFormData:[investment_preference_id dataUsingEncoding:NSUTF8StringEncoding] name:@"investment_preference_id"];
        [formData appendPartWithFormData:[birth_city dataUsingEncoding:NSUTF8StringEncoding] name:@"birth_city"];
        [formData appendPartWithFormData:[birth_area dataUsingEncoding:NSUTF8StringEncoding] name:@"birth_area"];
        [formData appendPartWithFormData:[primary_school dataUsingEncoding:NSUTF8StringEncoding] name:@"primary_school"];
        [formData appendPartWithFormData:[junior_middle_school dataUsingEncoding:NSUTF8StringEncoding] name:@"junior_middle_school"];
        
        [formData appendPartWithFormData:[high_school dataUsingEncoding:NSUTF8StringEncoding] name:@"high_school"];
        [formData appendPartWithFormData:[university dataUsingEncoding:NSUTF8StringEncoding] name:@"university"];
        
        
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        [SVProgressHUD showProgress:totalBytesWritten/totalBytesExpectedToWrite status:@"..." maskType:SVProgressHUDMaskTypeBlack];
    }];
    [httpClient enqueueHTTPRequestOperation:operation];
    
    //上传完成
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"$$$%@",operation.responseString);
        
        [SVProgressHUD dismiss];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"信息%@",dict);
        
        if (1 == [dict[@"state"] integerValue]) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserInformation"];
            [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"UserInformation"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",[dict objectForKey:@"stype"]] forKey:@"STYPE"];
            successBlock(YES,dict);
        }else{
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:dict[@"message"]];
            successBlock(NO,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//注册的时候上传头像接口
+ (void)postHeadImageWithImage:(UIImage *)image WithPhone:(NSString *)phone usingSuccessBlock:(void (^)(BOOL isSuccess,NSString *imageId))successBlock
{
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@index.php?r=default/start/headPic/",kMainUrlString]]];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.001);
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:nil parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData)  {
        [formData appendPartWithFormData:[phone dataUsingEncoding:NSUTF8StringEncoding] name:@"phone"];
//        [formData appendPartWithFormData:[[self getUserToken] dataUsingEncoding:NSUTF8StringEncoding] name:@"token"];
        [formData appendPartWithFileData:imageData name:@"pic" fileName:@"test.png" mimeType:@"image/png"];
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    NSLog(@"%@",operation);
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        [SVProgressHUD showProgress:totalBytesWritten/totalBytesExpectedToWrite status:@"上传中" maskType:SVProgressHUDMaskTypeBlack];
    }];
    [httpClient enqueueHTTPRequestOperation:operation];
    
    //上传完成
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"$$$%@",operation.responseString);
        
        [SVProgressHUD dismiss];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"图片%@",dict);
        
        if (1 == [dict[@"state"] integerValue]) {
            successBlock(YES,dict[@"id"]);
        }else{
            successBlock(NO,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//个人简历列表
+ (void)getMyPersonResumeListWithUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/start/resume&uid=%@",kMainUrlString,[self getUserId]];
    NSLog(@"个人简历列表网址%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"个人简历列表%@",resultDictionary);
        
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock(NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

///颜沛贤增加---查看其他人的个人简历接口
+ (void)getOtherPersonResumeListWithUserId:(NSString*)userid UsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/start/resume&uid=%@",kMainUrlString,userid];
    NSLog(@"查看其他人的个人简历列表网址%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"查看其他人的个人简历列表%@",resultDictionary);
        
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock(NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];
    
}

//增加项目经历
+ (void)addTheProjectItemWithCompanyName:(NSString *)company WithProjectPost:(NSString *)projectpost WithProjectName:(NSString *)projectname WithProjectIntro:(NSString *)projectIntro WithStartTime:(NSString *)s_time WithEndTime:(NSString *)e_time usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@index.php?r=default/start/projectsAdd/",kMainUrlString]]];
    
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:nil parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData)  {
        [formData appendPartWithFormData:[[self getUserId] dataUsingEncoding:NSUTF8StringEncoding] name:@"uid"];
        [formData appendPartWithFormData:[company dataUsingEncoding:NSUTF8StringEncoding] name:@"com_name"];
        [formData appendPartWithFormData:[projectpost dataUsingEncoding:NSUTF8StringEncoding] name:@"project_positions"];
        [formData appendPartWithFormData:[projectname dataUsingEncoding:NSUTF8StringEncoding] name:@"project_name"];
        [formData appendPartWithFormData:[projectIntro dataUsingEncoding:NSUTF8StringEncoding] name:@"project_intro"];
        [formData appendPartWithFormData:[s_time dataUsingEncoding:NSUTF8StringEncoding] name:@"start_time"];
        [formData appendPartWithFormData:[e_time dataUsingEncoding:NSUTF8StringEncoding] name:@"end_time"];
        
        
        
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        [SVProgressHUD showProgress:totalBytesWritten/totalBytesExpectedToWrite status:@"..." maskType:SVProgressHUDMaskTypeBlack];
    }];
    [httpClient enqueueHTTPRequestOperation:operation];
    
    //上传完成
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"$$$%@",operation.responseString);
        
        [SVProgressHUD dismiss];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"信息%@",dict);
        
        if (1 == [dict[@"state"] integerValue]) {
            
            successBlock(YES,dict);
        }else{
            successBlock(NO,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//增加职业经历
+ (void)addJobItemWithCompanyName:(NSString *)companyname WithDepartName:(NSString *)departName WithWorkField:(NSString *)workfield WithJobIntro:(NSString *)jobintro WithWorkPlace:(NSString *)workplace WithStartTime:(NSString *)s_time WithEndTime:(NSString *)e_time usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@index.php?r=default/start/professionalAdd/",kMainUrlString]]];
    
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:nil parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData)  {
        
        NSLog(@"uid:%@ ",[self getUserId]);
        NSLog(@"com_name:%@ ",companyname);
        NSLog(@"department_name:%@ ",departName);
        NSLog(@"work_field:%@ ",workfield);
        NSLog(@"job_description:%@ ",jobintro);
        NSLog(@"work_place:%@ ",workplace);
        NSLog(@"start_time:%@ ",s_time);
        NSLog(@"end_time:%@ ",e_time);
        
        
        [formData appendPartWithFormData:[[self getUserId] dataUsingEncoding:NSUTF8StringEncoding] name:@"uid"];
        [formData appendPartWithFormData:[companyname dataUsingEncoding:NSUTF8StringEncoding] name:@"com_name"];
        [formData appendPartWithFormData:[departName dataUsingEncoding:NSUTF8StringEncoding] name:@"department_name"];
        [formData appendPartWithFormData:[workfield dataUsingEncoding:NSUTF8StringEncoding] name:@"work_field"];
        [formData appendPartWithFormData:[jobintro dataUsingEncoding:NSUTF8StringEncoding] name:@"job_description"];
        [formData appendPartWithFormData:[workplace dataUsingEncoding:NSUTF8StringEncoding] name:@"work_place"];
        [formData appendPartWithFormData:[s_time dataUsingEncoding:NSUTF8StringEncoding] name:@"start_time"];
        [formData appendPartWithFormData:[e_time dataUsingEncoding:NSUTF8StringEncoding] name:@"end_time"];
        
        
        
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        [SVProgressHUD showProgress:totalBytesWritten/totalBytesExpectedToWrite status:@"..." maskType:SVProgressHUDMaskTypeBlack];
    }];
    [httpClient enqueueHTTPRequestOperation:operation];
    
    //上传完成
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"$$$%@",operation.responseString);
        
        [SVProgressHUD dismiss];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"信息%@",dict);
        
        if (1 == [dict[@"state"] integerValue]) {
            
            successBlock(YES,dict);
        }else{
            successBlock(NO,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//增加教育经历
+ (void)addEducationItemWithCollegeName:(NSString *)collegeName WithProfessional:(NSString *)professional WithDegree:(NSString *)degree WithStartTime:(NSString *)s_time WithEndTime:(NSString *)e_time usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@index.php?r=default/start/educationAdd/",kMainUrlString]]];
    
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:nil parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData)  {
        [formData appendPartWithFormData:[[self getUserId] dataUsingEncoding:NSUTF8StringEncoding] name:@"uid"];
        [formData appendPartWithFormData:[collegeName dataUsingEncoding:NSUTF8StringEncoding] name:@"graduate_institutions"];
        [formData appendPartWithFormData:[professional dataUsingEncoding:NSUTF8StringEncoding] name:@"professional"];
        [formData appendPartWithFormData:[degree dataUsingEncoding:NSUTF8StringEncoding] name:@"degree"];
        
        [formData appendPartWithFormData:[s_time dataUsingEncoding:NSUTF8StringEncoding] name:@"start_time"];
        [formData appendPartWithFormData:[e_time dataUsingEncoding:NSUTF8StringEncoding] name:@"end_time"];
        
        
        
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        [SVProgressHUD showProgress:totalBytesWritten/totalBytesExpectedToWrite status:@"..." maskType:SVProgressHUDMaskTypeBlack];
    }];
    [httpClient enqueueHTTPRequestOperation:operation];
    
    //上传完成
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"$$$%@",operation.responseString);
        
        [SVProgressHUD dismiss];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"信息%@",dict);
        
        if (1 == [dict[@"state"] integerValue]) {
            
            successBlock(YES,dict);
        }else{
            successBlock(NO,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//修改项目经历
+ (void)modifyTheProjectItemWithProjectID:(NSString *)p_id WithCompanyName:(NSString *)company WithProjectPost:(NSString *)projectpost WithProjectName:(NSString *)projectname WithProjectIntro:(NSString *)projectIntro WithStartTime:(NSString *)s_time WithEndTime:(NSString *)e_time usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@index.php?r=default/start/projectsEdit/",kMainUrlString]]];
    
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:nil parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData)  {
        [formData appendPartWithFormData:[p_id dataUsingEncoding:NSUTF8StringEncoding] name:@"id"];
               [formData appendPartWithFormData:[company dataUsingEncoding:NSUTF8StringEncoding] name:@"com_name"];
        [formData appendPartWithFormData:[projectpost dataUsingEncoding:NSUTF8StringEncoding] name:@"project_positions"];
        [formData appendPartWithFormData:[projectname dataUsingEncoding:NSUTF8StringEncoding] name:@"project_name"];
        [formData appendPartWithFormData:[projectIntro dataUsingEncoding:NSUTF8StringEncoding] name:@"project_intro"];
        
        [formData appendPartWithFormData:[s_time dataUsingEncoding:NSUTF8StringEncoding] name:@"start_time"];
        [formData appendPartWithFormData:[e_time dataUsingEncoding:NSUTF8StringEncoding] name:@"end_time"];
        
        
        
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        [SVProgressHUD showProgress:totalBytesWritten/totalBytesExpectedToWrite status:@"..." maskType:SVProgressHUDMaskTypeBlack];
    }];
    [httpClient enqueueHTTPRequestOperation:operation];
    
    //上传完成
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"$$$%@",operation.responseString);
        
        [SVProgressHUD dismiss];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"信息%@",dict);
        
        if (1 == [dict[@"state"] integerValue]) {
            
            successBlock(YES,dict);
        }else{
            successBlock(NO,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//修改职业经历
+ (void)modifyJobItemWithJobID:(NSString *)jid WithCompanyName:(NSString *)companyname WithDepartName:(NSString *)departName WithWorkField:(NSString *)workfield WithJobIntro:(NSString *)jobintro WithWorkPlace:(NSString *)workplace WithStartTime:(NSString *)s_time WithEndTime:(NSString *)e_time usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@index.php?r=default/start/professionalEdit/",kMainUrlString]]];
    
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:nil parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData)  {
        [formData appendPartWithFormData:[jid dataUsingEncoding:NSUTF8StringEncoding] name:@"id"];
        [formData appendPartWithFormData:[companyname dataUsingEncoding:NSUTF8StringEncoding] name:@"com_name"];
        [formData appendPartWithFormData:[departName dataUsingEncoding:NSUTF8StringEncoding] name:@"department_name"];
        [formData appendPartWithFormData:[workfield dataUsingEncoding:NSUTF8StringEncoding] name:@"work_field"];
        [formData appendPartWithFormData:[jobintro dataUsingEncoding:NSUTF8StringEncoding] name:@"job_description"];
        [formData appendPartWithFormData:[workplace dataUsingEncoding:NSUTF8StringEncoding] name:@"work_place"];
        
        [formData appendPartWithFormData:[s_time dataUsingEncoding:NSUTF8StringEncoding] name:@"start_time"];
        [formData appendPartWithFormData:[e_time dataUsingEncoding:NSUTF8StringEncoding] name:@"end_time"];
        
        
        
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        [SVProgressHUD showProgress:totalBytesWritten/totalBytesExpectedToWrite status:@"..." maskType:SVProgressHUDMaskTypeBlack];
    }];
    [httpClient enqueueHTTPRequestOperation:operation];
    
    //上传完成
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"$$$%@",operation.responseString);
        
        [SVProgressHUD dismiss];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"信息%@",dict);
        
        if (1 == [dict[@"state"] integerValue]) {
            
            successBlock(YES,dict);
        }else{
            successBlock(NO,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//修改教育经历
+ (void)modifyEducationItemWithEducationID:(NSString *)edu_id WithCollegeName:(NSString *)collegeName WithProfessional:(NSString *)professional WithDegree:(NSString *)degree WithStartTime:(NSString *)s_time WithEndTime:(NSString *)e_time usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@index.php?r=default/start/educationEdit/",kMainUrlString]]];
    
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:nil parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData)  {
        [formData appendPartWithFormData:[edu_id dataUsingEncoding:NSUTF8StringEncoding] name:@"id"];
        [formData appendPartWithFormData:[collegeName dataUsingEncoding:NSUTF8StringEncoding] name:@"graduate_institutions"];
        [formData appendPartWithFormData:[professional dataUsingEncoding:NSUTF8StringEncoding] name:@"professional"];
        [formData appendPartWithFormData:[degree dataUsingEncoding:NSUTF8StringEncoding] name:@"degree"];
        
        [formData appendPartWithFormData:[s_time dataUsingEncoding:NSUTF8StringEncoding] name:@"start_time"];
        [formData appendPartWithFormData:[e_time dataUsingEncoding:NSUTF8StringEncoding] name:@"end_time"];
        
        
        
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        [SVProgressHUD showProgress:totalBytesWritten/totalBytesExpectedToWrite status:@"..." maskType:SVProgressHUDMaskTypeBlack];
    }];
    [httpClient enqueueHTTPRequestOperation:operation];
    
    //上传完成
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"$$$%@",operation.responseString);
        
        [SVProgressHUD dismiss];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"信息%@",dict);
        
        if (1 == [dict[@"state"] integerValue]) {
            
            successBlock(YES,dict);
        }else{
            successBlock(NO,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//删除项目经历
+ (void)dellTheProjectItemWithProjectID:(NSString *)p_id usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/start/projectsDell&pid=%@",kMainUrlString,p_id];
    NSLog(@"删除项目经历网址%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"删除项目经历%@",resultDictionary);
        
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock(NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//删除职业经历
+ (void)dellTheJobItemWithJobID:(NSString *)j_id usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/start/professionalDell&id=%@",kMainUrlString,j_id];
    NSLog(@"删除职业经历网址%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"删除职业经历%@",resultDictionary);
        
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock(NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//删除教育经历
+ (void)dellTheEducationItemWithEducationID:(NSString *)edu_id usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/start/educationDell&pid=%@",kMainUrlString,edu_id];
    NSLog(@"删除教育经历网址%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"删除教育经历%@",resultDictionary);
        
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock(NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}


//注册投资偏好
+ (void)getinvestmentListWithUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/start/investment",kMainUrlString];
    NSLog(@"注册投资偏好网址%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"注册投资偏好%@",resultDictionary);
        
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock(NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//身份背景选择(下一层为机构)
+ (void)getMyPositionWithPID:(NSString *)pid usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/start/position&pid=%@",kMainUrlString,pid];
    NSLog(@"身份背景选择(下一层为机构)网址%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"身份背景选择(下一层为机构)%@",resultDictionary);
        
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock(NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//机构选择
+ (void)getInstitutionWithPID:(int)pid usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/start/institution&pid=%d",kMainUrlString,pid];
    NSLog(@"机构选择网址%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"机构选择%@",resultDictionary);
        
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock(NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//部门条线选择
+ (void)getDepartmentListWithID:(int)i_id usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/start/department&id=%d",kMainUrlString,i_id];
    NSLog(@"部门条线选择网址%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"部门条线选择%@",resultDictionary);
        
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock(NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//获取学位☆☆【绍辉6-27日新加接口】
+ (void)getTheEducationDegreeUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/start/degree",kMainUrlString];
    NSLog(@"获取学位☆☆网址%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"获取学位☆☆%@",resultDictionary);
        
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock(NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

////用户使用条款
//+ (void)getUserClauseWithUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
//{
//    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/start/user_clause",kMainUrlString];
//    NSLog(@"用户使用条款网址%@",stringURL);
//    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
//        NSLog(@"用户使用条款%@",resultDictionary);
//        
//        if ([resultDictionary[@"state"] integerValue] == 1) {
//            
//            successBlock(YES,resultDictionary);
//        }else
//        {
//            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
//            successBlock(NO,nil);
//        }
//        
//    } andFailureBlock:^(NSError *resultError) {
//        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
//    }];
//
//}

//个人主页
+ (void)getMyMainMessageWithUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/start/personage&uid=%@",kMainUrlString,[self getUserId]];
    NSLog(@"个人主页网址%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"个人主页%@",resultDictionary);
        
        if ([resultDictionary[@"state"] integerValue] == 1) {
        //***************
            [self sendTheUserTokenAndDriveTokenWithUsingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
                if (isSuccess == YES) {
                    NSLog(@"可以聊天");
                }
            }];

            //*********************
            successBlock(YES,resultDictionary);
        }else
        {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock(NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//修改头像
+ (void)modifyTheUserHeaderImagesWithImage:(UIImage *)image UsingSuccessBlock:(void (^)(BOOL isSuccess,NSString *imageId))successBlock
{
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@index.php?r=default/set/pic/",kMainUrlString]]];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.001);
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:nil parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData)  {
        [formData appendPartWithFormData:[[self getUserId] dataUsingEncoding:NSUTF8StringEncoding] name:@"id"];
        //        [formData appendPartWithFormData:[[self getUserToken] dataUsingEncoding:NSUTF8StringEncoding] name:@"token"];
        [formData appendPartWithFileData:imageData name:@"pic" fileName:@"test.png" mimeType:@"image/png"];
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        [SVProgressHUD showProgress:totalBytesWritten/totalBytesExpectedToWrite status:@"上传中" maskType:SVProgressHUDMaskTypeBlack];
    }];
    [httpClient enqueueHTTPRequestOperation:operation];
    
    //上传完成
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"$$$%@",operation.responseString);
        
        [SVProgressHUD dismiss];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"图片%@",dict);
        
        if (1 == [dict[@"state"] integerValue]) {
            successBlock(YES,dict[@"pic"]);
        }else{
            successBlock(NO,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//修改个人资料★★【6-27绍辉新加接口】
+ (void)ModifyThePersonMessageWithGender:(NSString *)gender FirstName:(NSString *)firstName WithSecondName:(NSString *)secondName WithWorkCity:(NSString *)workCity WithWorkArea:(NSString *)workArea usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/set/person&id=%@&gender=%@&nickname_first=%@&nickname_second=%@&work_city=%@&work_area=%@",kMainUrlString,[self getUserId],gender,firstName,secondName,workCity,workArea];
    NSLog(@"修改个人资料★★URL%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"修改个人资料★★%@",resultDictionary);
        
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserInformation"];
            [[NSUserDefaults standardUserDefaults] setObject:resultDictionary forKey:@"UserInformation"];

            successBlock(YES,resultDictionary);
        }else
        {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock(NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}
//读取详细信息的接口★★【6-27绍辉新加接口】
+ (void)GetThePersonDetialsMessageWithUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/set/detail&uid=%@",kMainUrlString,[self getUserId]];
    NSLog(@"读取详细信息的接口★★URL%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"读取详细信息的接口★★%@",resultDictionary);
        
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock(NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}
//删除菜单
+ (void)dellTheMenuWithMenuName:(NSString *)menuName usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/start/del&uid=%@&menu=%@",kMainUrlString,[self getUserId],menuName];
    NSLog(@"删除菜单网址%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"删除菜单%@",resultDictionary);
        
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock(NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//快捷访问页面
+ (void)getTheQuickAccessListWithUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/start/shortcutVisit&uid=%@&token=%@",kMainUrlString,[self getUserId],[self getUserToken]];
    NSLog(@"快捷访问页面网址%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"快捷访问页面%@",resultDictionary);
        
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock(NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//增加快捷访问
+ (void)AddTheMenuItemWithMenuName:(NSString *)menuName usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/start/addVisit&uid=%@&menu=%@&token=%@",kMainUrlString,[self getUserId],menuName,[self getUserToken]];
    NSLog(@"增加快捷访问网址%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"增加快捷访问%@",resultDictionary);
        
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock(NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

#pragma mark - 联系人模块
//新的好友
+ (void)getMyNewFriendsWithUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/start/newFriend&uid=%@",kMainUrlString,[self getUserId]];
    NSLog(@"新的好友网址%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"新的好友%@",resultDictionary);
        
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock(NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//拒绝增加好友
+ (void)RejectTheNewFriendsWithFriendsID:(NSString *)friendsid usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/start/decline&uid=%@&fid=%@",kMainUrlString,[self getUserId],friendsid];
    NSLog(@"拒绝增加好友网址%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"拒绝增加好友%@",resultDictionary);
        
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock(NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//同意增加好友
+ (void)AgreeTheNewFriendsWithNewFriensdID:(NSString *)friemdsid usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/start/friendAgree&uid=%@&fid=%@",kMainUrlString,[self getUserId],friemdsid];
    NSLog(@"同意增加好友%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"同意增加好友%@",resultDictionary);
        
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock(NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//我的联系人
+ (void)getMyLinkManWithUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/start/linkman&uid=%@",kMainUrlString,[self getUserId]];
    NSLog(@"我的联系人网址%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"我的联系人%@",resultDictionary);
        
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock(NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//加入黑名单
+ (void)addBlacklistWithFriendId:(NSString *)friendId usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/start/addlist&uid=%@&fid=%@",kMainUrlString,[self getUserId],friendId];
    NSLog(@"加入黑名单%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"加入黑名单%@",resultDictionary);
        
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"添加成功"];
            successBlock(YES,resultDictionary);
        }else
        {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock(NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];
}

//认可他的身份
+ (void)acceptRankWithFriendId:(NSString *)friendId usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/start/acceptRank&uid=%@&fid=%@",kMainUrlString,[self getUserId],friendId];
    NSLog(@"认可他的身份%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"认可他的身份%@",resultDictionary);
        
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock(NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];
}


//站内联系人
+ (void)getMyInstationManWithUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/start/instationMan&uid=%@",kMainUrlString,[self getUserId]];
    NSLog(@"站内联系人网址%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"站内联系人%@",resultDictionary);
        
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock(NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//赠送联系人
+ (void)getMypresentManWithUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/start/presentMan&uid=%@",kMainUrlString,[self getUserId]];
    NSLog(@"赠送联系人网址%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"赠送联系人%@",resultDictionary);
        
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock(NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//赠送联系人加为好友
+ (void)AddThePresentFriendsToInstationManWithFriendsID:(NSString *)friendsid usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/start/addPresent&uid=%@&fid=%@",kMainUrlString,[self getUserId],friendsid];
    NSLog(@"赠送联系人加为好友网址%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"赠送联系人加为好友%@",resultDictionary);
        
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock(NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

#pragma mark - 联系人模块--邀请好友
//手机通讯录
+ (void)postFriendFromAddressBookWithUsersArray:(NSArray *)usersArray usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *users = @"";
    if (usersArray.count>0) {
        users = [NSString stringWithFormat:@"%@,%@",usersArray[0][@"phone"],usersArray[0][@"name"]];
    }
    
    for (int i = 1; i< usersArray.count; i++) {
        users = [NSString stringWithFormat:@"%@=%@,%@",users,usersArray[i][@"phone"],usersArray[i][@"name"]];
    }
    
    NSLog(@"%@",users);
    
    [SVProgressHUD show];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@index.php?r=default/set/friend/",kMainUrlString]]];
    
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:nil parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData)  {
        
        [formData appendPartWithFormData:[[self getUserId] dataUsingEncoding:NSUTF8StringEncoding] name:@"id"];
        
        [formData appendPartWithFormData:[users dataUsingEncoding:NSUTF8StringEncoding] name:@"users"];
        
        
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    
    [httpClient enqueueHTTPRequestOperation:operation];
    
    //上传完成
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        
        NSLog(@"手机通讯录%@",operation.responseString);
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"手机通讯录%@",dict);
        
        if (1 == [dict[@"state"] integerValue]) {
            
            successBlock(YES,dict);
        }else{
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:dict[@"message"]];
            successBlock(NO,dict);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];
}

//搜索好友
+ (void)getSearchTheFriendsWithPhone:(NSString *)phone usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/start/search&uid=%@&phone=%@",kMainUrlString,[self getUserId],phone];
    NSLog(@"搜索好友网址%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"搜索好友%@",resultDictionary);
        
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock(NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//好友资料
+ (void)getMyFriendInformationWithFID:(NSString *)fid usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/start/friendInfo&uid=%@&fid=%@",kMainUrlString,[self getUserId],fid];
    NSLog(@"好友资料网址%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"好友资料%@",resultDictionary);
        
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock(NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//好友资料---根据脸谱号获取好友信息
+ (void)getMyFriendInformationWithLp_number:(NSString *)Lp_number usingSuccessBlock:(void (^)(BOOL isSuccess, NSDictionary *resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/start/searchCode&uid=%@&lp_sn=%@",kMainUrlString,[self getUserId],Lp_number];
    NSLog(@"根据脸谱号获取好友信息%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"根据脸谱号获取好友信息%@",resultDictionary);
        
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock(NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

#pragma mark - 朋友圈【绍辉6-23新加】
//朋友圈列表△
+ (void)getFriendsOpenListWithPages:(NSInteger)page UsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/start/friendpenList&uid=%@&page=%ld&token=%@",kMainUrlString,[self getUserId],(long)page,[self getUserToken]];
    NSLog(@"朋友圈列表网址%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"朋友圈列表%@",resultDictionary);
        
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock(NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];
    
}

//好友朋友圈△
+ (void)getMyFriendsOpenWithFid:(NSString *)fid WithPages:(NSInteger)page usingSuccessBlock:(void (^)(BOOL, NSDictionary *))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/start/Friendpen&uid=%@&fid=%@&page=%d",kMainUrlString,fid,[self getUserId],page];
    NSLog(@"好友朋友圈网址%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"好友朋友圈%@",resultDictionary);
        
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock(NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];
    
}

//发布朋友圈△
+ (void)PostSendFriendsCircleMessageWithPictureID:(NSString *)pictureid WithConten:(NSString *)content WithInstitution:(NSString *)institution WithDepartment:(NSString *)department usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@index.php?r=default/start/addFriendpen/",kMainUrlString]]];
    //NSData *imageData = UIImageJPEGRepresentation(pic, 0.001);
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:nil parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData)  {
        
        
        [formData appendPartWithFormData:[[self getUserId] dataUsingEncoding:NSUTF8StringEncoding] name:@"uid"];
        [formData appendPartWithFormData:[pictureid dataUsingEncoding:NSUTF8StringEncoding] name:@"pictures"];
        [formData appendPartWithFormData:[content dataUsingEncoding:NSUTF8StringEncoding] name:@"content"];
        [formData appendPartWithFormData:[institution dataUsingEncoding:NSUTF8StringEncoding] name:@"institution"];
        [formData appendPartWithFormData:[department dataUsingEncoding:NSUTF8StringEncoding] name:@"department"];
        
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        [SVProgressHUD showProgress:totalBytesWritten/totalBytesExpectedToWrite status:@"上传中" maskType:SVProgressHUDMaskTypeBlack];
    }];
    [httpClient enqueueHTTPRequestOperation:operation];
    
    //上传完成
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",operation.responseString);
        
        [SVProgressHUD dismiss];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"字典%@",dict);
        
        if (1 == [dict[@"state"] integerValue]) {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"发布成功"];
            successBlock(YES,dict);
        }else{
            successBlock(NO,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];
    
}

//发布前上传的图片△
+ (void)PostTheFriendCirclePicturesWithImage:(UIImage *)image usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@index.php?r=default/start/addFriendpenPic/",kMainUrlString]]];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.001);
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:nil parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData)  {
        
        [formData appendPartWithFileData:imageData name:@"picture" fileName:@"test.png" mimeType:@"image/png"];
        [formData appendPartWithFormData:[[self getUserId] dataUsingEncoding:NSUTF8StringEncoding] name:@"id"];
        
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        [SVProgressHUD showProgress:totalBytesWritten/totalBytesExpectedToWrite status:@"上传中" maskType:SVProgressHUDMaskTypeBlack];
    }];
    [httpClient enqueueHTTPRequestOperation:operation];
    
    //上传完成
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",operation.responseString);
        
        [SVProgressHUD dismiss];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"图片%@",dict);
        
        if (1 == [dict[@"state"] integerValue]) {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"上传成功"];
            successBlock(YES,dict);
        }else{
            successBlock(NO,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];
    
}

//朋友圈评论△
+ (void)postTheFriendCircleCommentsWithLogID:(NSString *)logid WithContent:(NSString *)content WithToID:(NSString *)toid usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@index.php?r=default/start/comment/",kMainUrlString]]];
    //NSData *imageData = UIImageJPEGRepresentation(pic, 0.001);
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:nil parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData)  {
        
        
        [formData appendPartWithFormData:[logid dataUsingEncoding:NSUTF8StringEncoding] name:@"log_id"];
        [formData appendPartWithFormData:[[self getUserId] dataUsingEncoding:NSUTF8StringEncoding] name:@"from_id"];
        [formData appendPartWithFormData:[content dataUsingEncoding:NSUTF8StringEncoding] name:@"content"];
        [formData appendPartWithFormData:[toid dataUsingEncoding:NSUTF8StringEncoding] name:@"to_id"];
        
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        [SVProgressHUD showProgress:totalBytesWritten/totalBytesExpectedToWrite status:@"上传中" maskType:SVProgressHUDMaskTypeBlack];
    }];
    [httpClient enqueueHTTPRequestOperation:operation];
    
    //上传完成
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",operation.responseString);
        
        [SVProgressHUD dismiss];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"字典%@",dict);
        
        if (1 == [dict[@"state"] integerValue]) {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"评论成功"];
            successBlock(YES,dict);
        }else{
            successBlock(NO,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];
    
}

//点赞或者取消赞△
+ (void)markTheFriendCircleLogWithLogID:(NSString *)logid WithStatus:(NSString *)status usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/start/praise&id=%@&uid=%@&status=%@",kMainUrlString,logid,[self getUserId],status];
    NSLog(@"商机点赞或取消赞%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"商机点赞或取消赞%@",resultDictionary);
        
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock(NO,nil);
        }
        
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];
    
}

//更换朋友圈背景△
+ (void)PostChangeTheFriendCircleBackPicturesWithImage:(UIImage *)image usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@index.php?r=default/start/background/",kMainUrlString]]];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.001);
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:nil parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData)  {
        
        [formData appendPartWithFileData:imageData name:@"background" fileName:@"test.png" mimeType:@"image/png"];
        [formData appendPartWithFormData:[[self getUserId] dataUsingEncoding:NSUTF8StringEncoding] name:@"uid"];
        
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        [SVProgressHUD showProgress:totalBytesWritten/totalBytesExpectedToWrite status:@"上传中" maskType:SVProgressHUDMaskTypeBlack];
    }];
    [httpClient enqueueHTTPRequestOperation:operation];
    
    //上传完成
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",operation.responseString);
        
        [SVProgressHUD dismiss];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"图片%@",dict);
        
        if (1 == [dict[@"state"] integerValue]) {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"上传成功"];
            successBlock(YES,dict);
        }else{
            successBlock(NO,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];
    
}

#pragma mark - 我的活动【绍辉6-24新加】
//活动列表
+ (void)getTheActivityListWithTypeID:(NSString *)typeId WithAreaName:(NSString *)areaName usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/activity/index&uid=%@&type_id=%@&area_name=%@",kMainUrlString,[self getUserId],typeId,areaName];
    NSLog(@"活动列表%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"活动列表%@",resultDictionary);
        
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock(NO,nil);
        }
        
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];
    
}
//活动详情
+ (void)getTheActivityDetialsWithActivityID:(NSString *)activityId usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/activity/details&uid=%@&id=%@",kMainUrlString,[self getUserId],activityId];
    NSLog(@"活动详情%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"活动详情%@",resultDictionary);
        
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock(NO,nil);
        }
        
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];
    
}

//发布活动-类型
+ (void)getTheActivityStyleWithUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/activity/add_type",kMainUrlString];
    NSLog(@"发布活动-类型%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"发布活动-类型%@",resultDictionary);
        
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock(NO,nil);
        }
        
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];
    
}
//发布活动-时间
+ (void)getTheActivityTimeWithStyleID:(NSString *)styleId UsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/activity/add_time&tid=%@",kMainUrlString,styleId];
    NSLog(@"发布活动-时间%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"发布活动-时间%@",resultDictionary);
        
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock(NO,nil);
        }
        
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];
    
}
//修改活动页面
+ (void)changeTheActivityViewWithActivityID:(NSString *)activityId UsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    
}

//我的活动列表
+ (void)getMyActivityListWithUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/activity/person&uid=%@",kMainUrlString,[self getUserId]];
    NSLog(@"我的活动列表%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"我的活动列表%@",resultDictionary);
        
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock(NO,nil);
        }
        
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];
    
}
//发布活动
+ (void)PostTheSendActivityMessageWithTitle:(NSString *)title WithStyleId:(NSString *)styleid WithStartTime:(NSString *)startTime WithTimeRangeID:(NSString *)rangeId WithEndTime:(NSString *)endTime WithAreaName:(NSString *)areaName WithPaymentRange:(NSString *)payRange WithContent:(NSString *)content UsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@index.php?r=default/activity/add/",kMainUrlString]]];
    //NSData *imageData = UIImageJPEGRepresentation(pic, 0.001);
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:nil parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData)  {
        
        NSLog(@"活动名称:%@ 类型id:%@ 开始时间%@ 时间区间id:%@ 结束时间:%@ 地点:%@ 费用:%@ 内容:%@",title,styleid,startTime,rangeId,endTime,areaName,payRange,content);
        
        [formData appendPartWithFormData:[[self getUserId] dataUsingEncoding:NSUTF8StringEncoding] name:@"user_id"];
        [formData appendPartWithFormData:[title dataUsingEncoding:NSUTF8StringEncoding] name:@"title"];
        [formData appendPartWithFormData:[styleid dataUsingEncoding:NSUTF8StringEncoding] name:@"type_id"];
        [formData appendPartWithFormData:[startTime dataUsingEncoding:NSUTF8StringEncoding] name:@"start_time"];
        
        [formData appendPartWithFormData:[rangeId dataUsingEncoding:NSUTF8StringEncoding] name:@"time_id"];
        [formData appendPartWithFormData:[endTime dataUsingEncoding:NSUTF8StringEncoding] name:@"end_time"];
        [formData appendPartWithFormData:[areaName dataUsingEncoding:NSUTF8StringEncoding] name:@"area_name"];
        [formData appendPartWithFormData:[payRange dataUsingEncoding:NSUTF8StringEncoding] name:@"payment_method"];
        
        [formData appendPartWithFormData:[content dataUsingEncoding:NSUTF8StringEncoding] name:@"content"];
        
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        [SVProgressHUD showProgress:totalBytesWritten/totalBytesExpectedToWrite status:@"上传中" maskType:SVProgressHUDMaskTypeBlack];
    }];
    [httpClient enqueueHTTPRequestOperation:operation];
    
    //上传完成
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",operation.responseString);
        
        [SVProgressHUD dismiss];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"字典%@",dict);
        
        if (1 == [dict[@"state"] integerValue]) {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"发布成功"];
            successBlock(YES,dict);
        }else{
            successBlock(NO,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];
    
}

//参加聚会
+ (void)joinTheActivityWithActivityID:(NSString *)activityid UsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/activity/join&activity_id=%@&user_id=%@",kMainUrlString,activityid,[self getUserId]];
    NSLog(@"参加聚会%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"参加聚会%@",resultDictionary);
        
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock(NO,nil);
        }
        
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];
    
}

//修改活动操作
+ (void)modifyTheActivityMessageWithTitle:(NSString *)title WithStyleId:(NSString *)styleid WithStartTime:(NSString *)startTime WithTimeRangeID:(NSString *)rangeId WithEndTime:(NSString *)endTime WithAreaName:(NSString *)areaName WithPaymentRange:(NSString *)payRange WithContent:(NSString *)content UsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    
}

//删除我的活动
+ (void)deleteTheActivityOfMeWithActivityID:(NSString *)activityId usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/activity/del&id=%@",kMainUrlString,activityId];
    NSLog(@"删除我的活动%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"删除我的活动%@",resultDictionary);
        
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock(NO,nil);
        }
        
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];
    
}

#pragma mark - 消息模块【绍辉6-26日新加】
//消息列表
+ (void)getTheMessageListWithUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/start/info&uid=%@",kMainUrlString,[self getUserId]];
    NSLog(@"消息列表网址%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"消息列表%@",resultDictionary);
        
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock(NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}
//①拒绝机构群认证
+ (void)RefusedTheConfirmationRelationshipsWithMessageID:(NSString *)messageId usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/groups/confirmationRefused&id=%@&token=%@&info_id=%@",kMainUrlString,[self getUserId],[self getUserToken],messageId];
    NSLog(@"①拒绝机构群认证URL%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"①拒绝机构群认证%@",resultDictionary);
        
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
            //[[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock(NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}
//②消息列表对机构关系进行确认
+ (void)PassTheConfirmationRelationshipsWithMessageID:(NSString *)messageId usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/groups/confirmationDo&id=%@&token=%@&info_id=%@",kMainUrlString,[self getUserId],[self getUserToken],messageId];
    NSLog(@"②消息列表对机构关系进行确认URL%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"②消息列表对机构关系进行确认%@",resultDictionary);
        
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
           // [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock(NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}
//③参加活动人同意参加聚会
+ (void)AgreeJoinThePartyWithFid:(NSString *)fid WithRelation:(NSString *)relation usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/start/agree&relation=%@&uid=%@&fid=%@",kMainUrlString,relation,[self getUserId],fid];
    NSLog(@"③参加活动人同意参加聚会URL%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"③参加活动人同意参加聚会%@",resultDictionary);
        
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
            //[[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock(NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}
//④参加活动人拒绝参加聚会
+ (void)RefusedJoinThePartyWithFid:(NSString *)fid WithRelation:(NSString *)relation usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/start/repulse_activities&relation=%@&uid=%@&fid=%@",kMainUrlString,relation,[self getUserId],fid];
    NSLog(@"④参加活动人拒绝参加聚会URL%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"④参加活动人拒绝参加聚会%@",resultDictionary);
        
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
          //  [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock(NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}
//⑤发布人同意参加聚会
+ (void)CreaterAgreeOtherPeopleJoinThePartyFid:(NSString *)fid WithRelation:(NSString *)relation usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/start/agreement&relation=%@&uid=%@&fid=%@",kMainUrlString,relation,[self getUserId],fid];
    NSLog(@"⑤发布人同意参加聚会URL%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"⑤发布人同意参加聚会%@",resultDictionary);
        
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
            //[[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock(NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//⑥发布人拒绝参加聚会
+ (void)CreaterRefusedOtherPeopleJoinThePartyFid:(NSString *)fid WithRelation:(NSString *)relation usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/start/repulse&relation=%@&uid=%@&fid=%@",kMainUrlString,relation,[self getUserId],fid];
    NSLog(@"⑥发布人拒绝参加聚会URL%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"⑥发布人拒绝参加聚会%@",resultDictionary);
        
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
        //    [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock(NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//⑦通过申请加入群接口
+ (void)PassTheJoinApplicationOfGroupWithMessageID:(NSString *)messageId usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/groups/agreeAddThemeGroup&id=%@&token=%@&info_id=%@",kMainUrlString,[self getUserId],[self getUserToken],messageId];
    NSLog(@"⑦通过申请加入群接口URL%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"⑦通过申请加入群接口%@",resultDictionary);
        
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
         //   [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock(NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//⑧拒绝申请加入群接口
+ (void)RefusedTheJoinApplicationOfGroupWithMessageID:(NSString *)messageId usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/groups/refuseAddThemeGroup&id=%@&token=%@&info_id=%@",kMainUrlString,[self getUserId],[self getUserToken],messageId];
    NSLog(@"⑧拒绝申请加入群接口URL%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"⑧拒绝申请加入群接口%@",resultDictionary);
        
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
         //   [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock(NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//⑨同意增加好友
+ (void)AgreeTheOthersAddMeFriendsWithFid:(NSString *)fid usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/start/friendAgree&uid=%@&fid=%@",kMainUrlString,[self getUserId],fid];
    NSLog(@"⑨同意增加好友URL%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"⑨同意增加好友%@",resultDictionary);
        
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
          //  [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock(NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//⑩拒绝增加好友
+ (void)RefusedTheOthersAddMeFriendsWithFid:(NSString *)fid usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/start/decline&uid=%@&fid=%@",kMainUrlString,[self getUserId],fid];
    NSLog(@"⑩拒绝增加好友URL%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"⑩拒绝增加好友%@",resultDictionary);
        
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
         //   [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock(NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//**********************
// 同乡校友
//**********************
#pragma mark - 同乡校友

//同乡列表
+ (void)GetTheSameCityListWithUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/alike/city&uid=%@",kMainUrlString,[self getUserId]];
    NSLog(@"同乡校友网址%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"同乡校友%@",resultDictionary);
        
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock(NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//同校列表
+ (void)GetTheSameSchoolListWithUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/alike/school&uid=%@",kMainUrlString,[self getUserId]];
    NSLog(@"同校列表网址%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"同校列表%@",resultDictionary);
        
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock(NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//增加好友
+ (void)AddTheNewFriendsWithFriendsID:(NSString *)friendsId WithFriendsType:(NSString *)fType WithGroupID:(NSString *)groupid WithGroupType:(NSString *)groupType WithInforString:(NSString *)inforString usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/start/addFriend&uid=%@&fid=%@&type=%@&gid=%@&gtype=%@&info=%@",kMainUrlString,[self getUserId],friendsId,fType,groupid,groupType,inforString];
    NSLog(@"增加好友网址%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"增加好友%@",resultDictionary);
        
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"发送成功"];
            successBlock(YES,resultDictionary);
        }else
        {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock(NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//*******************
// 我的群
//********************
#pragma mark - 我的群
//我的群
+ (void)getMyGroupListWithUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/groups/myGroupList&id=%@&token=%@",kMainUrlString,[self getUserId],[self getUserToken]];
    NSLog(@"我的群网址%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"我的群%@",resultDictionary);
        
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock(NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

/////////////////////
//测试
/////////////////////
//我的通讯录接口
+ (void)myAddressBookListWithUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"http://juju.bloveambition.com/index.php/Addresslist/getAllList?id=22&token=FC19C24D743E223D15A7E1028D959671"];
    NSLog(@"我的通讯录接口%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"我的通讯录%@",resultDictionary);
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
            //[[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock(NO,nil);
        }
        
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];
    
}







#pragma mark - 业务墙
//业务墙所有分类
+ (void)getBusinessTypeListWithUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/business/getTypeList&id=%@&token=%@",kMainUrlString,[self getUserId],[self getUserToken]];
    NSLog(@"业务墙所有分类%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"业务墙所有分类%@",resultDictionary);
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
            successBlock(NO,nil);
        }
        
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//根据类型获取动态
+ (void)getBusinessListByTypeWithTypeId:(NSString *)typeId WithPage:(NSInteger)page usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/business/getListByType&id=%@&token=%@&page=%d&type_id=%@",kMainUrlString,[self getUserId],[self getUserToken],page,typeId];
    NSLog(@"根据类型获取动态%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"根据类型获取动态%@",resultDictionary);
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
            successBlock(NO,nil);
        }
        
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//获取我的动态列表
+ (void)getMyBusinessListWithPage:(NSInteger)page usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/business/getMyList&id=%@&token=%@&page=%d",kMainUrlString,[self getUserId],[self getUserToken],page];
    NSLog(@"获取我的动态列表%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"获取我的动态列表%@",resultDictionary);
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
            successBlock(NO,nil);
        }
        
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];
}

//获取某动态详情
+ (void)getBusinessDetailWithWallId:(NSString *)wallId WithPage:(NSInteger)page usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/business/getDetail&id=%@&token=%@&page=%d&wall_id=%@",kMainUrlString,[self getUserId],[self getUserToken],page,wallId];
    NSLog(@"获取某动态详情%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"获取某动态详情%@",resultDictionary);
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
            successBlock(NO,nil);
        }
        
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//评论动态接口
+ (void)businessSetCommentWithWallId:(NSString *)wallId WithContent:(NSString *)content WithToID:(NSString *)toid usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/business/setComment&id=%@&token=%@&wall_id=%@&content=%@&to_id=%@",kMainUrlString,[self getUserId],[self getUserToken],wallId,content,toid];
    NSLog(@"评论动态接口%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"评论动态接口%@",resultDictionary);
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
            successBlock(NO,nil);
        }
        
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];
}

//发布动态前判断是否已经三条
+ (void)businessCheckNumsWithUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/business/checkNums&id=%@&token=%@",kMainUrlString,[self getUserId],[self getUserToken]];
    NSLog(@"发布动态前判断是否已经三条%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"发布动态前判断是否已经三条%@",resultDictionary);
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"今天已经发布了两条了"];
            successBlock(NO,nil);
        }
        
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];
}

//获取定向发布的条线列表
+ (void)getBusinessDepartmentListWithUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/business/getDepartmentList&id=%@&token=%@",kMainUrlString,[self getUserId],[self getUserToken]];
    NSLog(@"获取定向发布的条线列表%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"获取定向发布的条线列表%@",resultDictionary);
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
            successBlock(NO,nil);
        }
        
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//获取发布业务墙动态信息接口
+ (void)getBusinessGoldsWithUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/business/getGolds&id=%@&token=%@",kMainUrlString,[self getUserId],[self getUserToken]];
    NSLog(@"获取发布业务墙动态信息接口%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"获取发布业务墙动态信息接口%@",resultDictionary);
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
            successBlock(NO,nil);
        }
        
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//发布动态接口
+ (void)businessSetActionWithTitle:(NSString *)title WithContent:(NSString *)content WithDepartment_ids:(NSString *)department_ids WithType_id:(NSString *)type_id WithNick_name:(NSString *)nick_name WithIs_public:(NSString *)is_public usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    [SVProgressHUD show];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@index.php?r=default/business/setAction/",kMainUrlString]]];
    
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:nil parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData)  {
        
        [formData appendPartWithFormData:[[self getUserId] dataUsingEncoding:NSUTF8StringEncoding] name:@"id"];
        
        [formData appendPartWithFormData:[[self getUserToken] dataUsingEncoding:NSUTF8StringEncoding] name:@"token"];
        
        [formData appendPartWithFormData:[title dataUsingEncoding:NSUTF8StringEncoding] name:@"title"];
        
        [formData appendPartWithFormData:[content dataUsingEncoding:NSUTF8StringEncoding] name:@"content"];

        [formData appendPartWithFormData:[department_ids dataUsingEncoding:NSUTF8StringEncoding] name:@"department_ids"];

        [formData appendPartWithFormData:[type_id dataUsingEncoding:NSUTF8StringEncoding] name:@"type_id"];

        [formData appendPartWithFormData:[nick_name dataUsingEncoding:NSUTF8StringEncoding] name:@"nick_name"];

        [formData appendPartWithFormData:[is_public dataUsingEncoding:NSUTF8StringEncoding] name:@"is_public"];

        
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [httpClient enqueueHTTPRequestOperation:operation];
    
    //上传完成
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        
        NSLog(@"发布动态接口%@",operation.responseString);
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"发布动态接口%@",dict);
        
        if (1 == [dict[@"state"] integerValue]) {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"发布成功"];
            successBlock(YES,dict);
        }else if (2 == [dict[@"state"] integerValue])
        {
            //[[DMCAlertCenter defaultCenter] postAlertWithMessage:@"您的金币不足"];
            successBlock(YES,dict);
        }else{
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:dict[@"message"]];
            successBlock(NO,dict);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//修改动态接口
+ (void)businessEditActionWithTitle:(NSString *)title WithContent:(NSString *)content WithType_id:(NSString *)type_id WithAid:(NSString *)aid usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    [SVProgressHUD show];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@index.php?r=default/business/editAction/",kMainUrlString]]];
    
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:nil parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData)  {
        
        [formData appendPartWithFormData:[[self getUserId] dataUsingEncoding:NSUTF8StringEncoding] name:@"id"];
        
        [formData appendPartWithFormData:[[self getUserToken] dataUsingEncoding:NSUTF8StringEncoding] name:@"token"];
        
        [formData appendPartWithFormData:[title dataUsingEncoding:NSUTF8StringEncoding] name:@"title"];
        
        [formData appendPartWithFormData:[content dataUsingEncoding:NSUTF8StringEncoding] name:@"content"];
        
        [formData appendPartWithFormData:[type_id dataUsingEncoding:NSUTF8StringEncoding] name:@"type_id"];
        
        [formData appendPartWithFormData:[aid dataUsingEncoding:NSUTF8StringEncoding] name:@"aid"];
        
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [httpClient enqueueHTTPRequestOperation:operation];
    
    //上传完成
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        
        NSLog(@"修改动态接口%@",operation.responseString);
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"修改动态接口%@",dict);
        
        if (1 == [dict[@"state"] integerValue]) {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"修改成功"];
            successBlock(YES,dict);
        }else{
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:dict[@"message"]];
            successBlock(NO,dict);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}



#pragma mark - 部落资讯

//点赞或者取消赞△
+ (void)praiseInfomationWithInfoID:(NSString *)infoid WithStatus:(NSString *)status usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/informations/setPraise&id=%@&token=%@&aid=%@",kMainUrlString,[self getUserId],[self getUserToken],infoid];
    NSLog(@"部落资讯点赞%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {

        NSLog(@"部落资讯点赞%@",resultDictionary);
        
        if ([resultDictionary[@"state"] integerValue] == 1) {
            
            successBlock(YES,resultDictionary);
        }else
        {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock(NO,nil);
        }
        
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];
    
}

//所有资讯大分类列表
+ (void)getZXMainListWithUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/informations/getList&id=%@&token=%@",kMainUrlString,[self getUserId],[self getUserToken]];
    
    NSLog(@"所有资讯大分类列表%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"所有资讯大分类列表%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            successBlock (YES,resultDictionary);
        }else {
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];
    
}

// “我订阅”的资讯大分类
+ (void)getMyZXListWithUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/informations/getMyList&id=%@&token=%@",kMainUrlString,[self getUserId],[self getUserToken]];
    
    NSLog(@"“我订阅”的资讯大分类%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"“我订阅”的资讯大分类%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            successBlock (YES,resultDictionary);
        }else {
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];
    
}

// 订阅资讯
+ (void)dyueZXWithTypeId:(NSString*)type_id usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/informations/subscribeInformation&id=%@&token=%@&type_id=%@",kMainUrlString,[self getUserId],[self getUserToken],type_id];
    
    NSLog(@" 订阅资讯%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@" 订阅资讯%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            successBlock (YES,resultDictionary);
        }else {
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];
    
}

// 取消资讯订阅
+ (void)quxiaoDyueZXWithTypeId:(NSString*)type_id usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/informations/unSubscribeInformation&id=%@&token=%@&type_id=%@",kMainUrlString,[self getUserId],[self getUserToken],type_id];
    
    NSLog(@"取消资讯订阅%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"取消资讯订阅%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            successBlock (YES,resultDictionary);
        }else {
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];
    
}

//资讯详情带分享网页
+ (void)informationDetailWithInfo_id:(NSString *)info_id usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/informations/getInfo&id=%@&token=%@&info_id=%@",kMainUrlString,[self getUserId],[self getUserToken],info_id];
    
    NSLog(@"资讯详情带分享网页%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"资讯详情带分享网页%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            successBlock (YES,resultDictionary);
        }else {
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];
}

//资讯评论页
+ (void)informationCommentWithNews_id:(NSString *)news_id WithPage:(NSInteger)page usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/informations/getComments&id=%@&token=%@&page=%d&news_id=%@",kMainUrlString,[self getUserId],[self getUserToken],page,news_id];
    
    NSLog(@"资讯评论页%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"资讯评论页%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            successBlock (YES,resultDictionary);
        }else {
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];
}

//评论资讯
+ (void)CommentInformationWithNews_id:(NSString *)news_id WithContent:(NSString *)content usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/informations/setComment&id=%@&token=%@&content=%@&news_id=%@",kMainUrlString,[self getUserId],[self getUserToken],content,news_id];
    
    NSLog(@"评论资讯%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"评论资讯%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"发送成功"];
            successBlock (YES,resultDictionary);
        }else {
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];
}

#pragma mark - 脸谱群【6-30日绍辉新加接口】
//脸谱群机构列表
+ (void)getTheFaceBookGroupInstitutionListWithClassID:(NSString *)classid WithPages:(NSInteger)page usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/groups/getInstitutionScreeningByKey&id=%@&token=%@&page=%d&class_id=%@",kMainUrlString,[self getUserId],[self getUserToken],page,classid];
    
    NSLog(@"脸谱群机构列表URL%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
         [SVProgressHUD dismiss];
        NSLog(@"脸谱群机构列表%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            successBlock (YES,resultDictionary);
        }else {
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];
    
}

//脸谱群机构筛选标签列表
+ (void)checkTheFaceBookGroupInstitutionConditionWithClassID:(NSString *)classid usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/groups/getInstitutionKeys&id=%@&token=%@&class_id=%@",kMainUrlString,[self getUserId],[self getUserToken],classid];
    
    NSLog(@"脸谱群机构筛选标签列表URL%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"脸谱群机构筛选标签列表%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            successBlock (YES,resultDictionary);
        }else {
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];
    
}

//加入群所调用的接口
+ (void)AddTheGroupFromMeWithInstitutionID:(NSString *)institutionid WithType:(NSString *)type usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/groups/addInstitutionGroup&id=%@&token=%@&institution_id=%@&type=%@",kMainUrlString,[self getUserId],[self getUserToken],institutionid,type];
    
    NSLog(@"加入群所调用的接口URL%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"加入群所调用的接口%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            successBlock (YES,resultDictionary);
        }else {
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];
    
}

//脸谱群-机构-【动态7-1日】☆☆☆☆☆☆☆☆☆
+ (void)getTheFaceBookInstitutionActionListWithPages:(NSInteger)page WithInstitutionID:(NSString *)institutionId usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/groups/getInstitutionActionList&id=%@&token=%@&page=%d&iid=%@",kMainUrlString,[self getUserId],[self getUserToken],page,institutionId];
    
    NSLog(@"脸谱群-机构-【动态7-1日】URL%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"脸谱群-机构-【动态7-1日】%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            successBlock (YES,resultDictionary);
        }else {
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];
    
}

//脸谱群-机构-群聊【常用联系人7-1】☆☆☆☆☆☆☆☆☆
+ (void)GetTheFaceBookInstitutionGroupChatOftenConnectPeopleWithInstitutionID:(NSString *)institutionid usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/groups/getInstitutionTopContacts&id=%@&token=%@&institution_id=%@",kMainUrlString,[self getUserId],[self getUserToken],institutionid];
    
    NSLog(@"脸谱群-机构-群聊【常用联系人7-1】URL%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"脸谱群-机构-群聊【常用联系人7-1】%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            successBlock (YES,resultDictionary);
        }else {
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];
    
}

//脸谱群-机构-群聊【群聊列表7-1】☆☆☆☆☆☆☆☆☆
+ (void)GetTheFaceBookGroupChatListWithInstitutionID:(NSString *)institutionId usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/groups/getInstitutionGroupUsers&id=%@&institution_id=%@&token=%@",kMainUrlString,[self getUserId],institutionId,[self getUserToken]];
    
    NSLog(@"脸谱群-机构-群聊【群聊列表7-1】URL%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"脸谱群-机构-群聊【群聊列表7-1】%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            successBlock (YES,resultDictionary);
        }else {
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];
    
}

//脸谱群-机构-新建群聊选人【7-2-feng.sh】☆☆☆☆☆☆☆☆☆
+ (void)GetTheFaceBookInstitutionMembersWithInstitutionID:(NSString *)institutionId WithPages:(NSInteger)page usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/groups/getInstitutionUsers&id=%@&token=%@&iid=%@&page=%d",kMainUrlString,[self getUserId],[self getUserToken],institutionId,page];
    
    NSLog(@"脸谱群-机构-新建群聊URL%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"脸谱群-机构-新建群聊%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            successBlock (YES,resultDictionary);
        }else {
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];
    
}

//脸谱群-机构-新建群聊【7-2-feng.sh】☆☆☆☆☆☆☆☆☆
+ (void)CreateTheFaceBookInstitutionGroupWithUserStr:(NSString *)userStr WithGroupName:(NSString *)groupName WithInstitutionId:(NSString *)institutionId usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/groups/createInstitutionChatGroup&id=%@&token=%@&users=%@&institution_id=%@&name=%@",kMainUrlString,[self getUserId],[self getUserToken],userStr,institutionId,groupName];
    
    NSLog(@"脸谱群-机构-新建群聊URL%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"脸谱群-机构-新建群聊%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"创建成功"];
            successBlock (YES,resultDictionary);
        }else {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];
    
}

//脸谱群-机构===条线===主题===发布动态前上传的照片【7-2-feng.sh】☆☆☆☆☆☆☆☆☆
+ (void)PostWithFromDynamicPhoto:(NSString *)fromDynamic WithPicture:(UIImage *)picture usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    if ([fromDynamic isEqualToString:@"机构发布动态"]) {
        fromDynamic = @"uploadInstitutionActionPic";
    }else if ([fromDynamic isEqualToString:@"条线发布动态"]) {
        fromDynamic = @"uploadDepartmentActionPic";
    }else if ([fromDynamic isEqualToString:@"主题发布动态"]) {
        fromDynamic = @"uploadThemeActionPic";
    }
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@index.php?r=default/groups/%@",kMainUrlString,fromDynamic]]];
    NSData *imageData = UIImageJPEGRepresentation(picture, 0.001);
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:nil parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData)  {
        
        [formData appendPartWithFileData:imageData name:@"picture" fileName:@"test.png" mimeType:@"image/png"];
        [formData appendPartWithFormData:[[self getUserId] dataUsingEncoding:NSUTF8StringEncoding] name:@"id"];
        [formData appendPartWithFormData:[[self getUserToken] dataUsingEncoding:NSUTF8StringEncoding] name:@"token"];
        
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        [SVProgressHUD showProgress:totalBytesWritten/totalBytesExpectedToWrite status:@"上传中" maskType:SVProgressHUDMaskTypeBlack];
    }];
    [httpClient enqueueHTTPRequestOperation:operation];
    
    //上传完成
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",operation.responseString);
        
        [SVProgressHUD dismiss];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"图片%@",dict);
        
        if (1 == [dict[@"state"] integerValue]) {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"上传成功"];
            successBlock(YES,dict);
        }else{
            successBlock(NO,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];
    
}

//脸谱群-机构===条线===主题===发布动态【7-2-feng.sh】☆☆☆☆☆☆☆☆☆
+ (void)PostWithFromDynamicMessage:(NSString *)fromDynamic WithPicture:(NSString *)picStr WithInstitutionID:(NSString *)institutionID WithContent:(NSString *)content WithIsFriendsCircle:(NSString *)isFC WithIsDepartment:(NSString *)isDp usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *fromString = @"";
    if ([fromDynamic isEqualToString:@"机构发布动态"]) {
        fromString = @"setInstitutionAction";
    }else if ([fromDynamic isEqualToString:@"条线发布动态"]) {
        fromString = @"setDepartmentAction";
    }else if ([fromDynamic isEqualToString:@"主题发布动态"]) {
        fromString = @"setThemeAction";
    }
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@index.php?r=default/groups/%@",kMainUrlString,fromString]]];
    
    
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:nil parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData)  {
        
        NSLog(@"uid: %@---token: %@---pictures: %@----iid: %@---content: %@----is_fc: %@--is_dep: %@",[self getUserId],[self getUserToken],picStr,institutionID,content,isFC,isDp);
        
        
        [formData appendPartWithFormData:[[self getUserId] dataUsingEncoding:NSUTF8StringEncoding] name:@"id"];
        [formData appendPartWithFormData:[[self getUserToken] dataUsingEncoding:NSUTF8StringEncoding] name:@"token"];
        
        [formData appendPartWithFormData:[picStr dataUsingEncoding:NSUTF8StringEncoding] name:@"pictures"];
        
        
        [formData appendPartWithFormData:[content dataUsingEncoding:NSUTF8StringEncoding] name:@"content"];
        
        
        
        if ([fromDynamic isEqualToString:@"机构发布动态"]) {
            //iid
            [formData appendPartWithFormData:[institutionID dataUsingEncoding:NSUTF8StringEncoding] name:@"iid"];
            [formData appendPartWithFormData:[isFC dataUsingEncoding:NSUTF8StringEncoding] name:@"is_fc"];
            [formData appendPartWithFormData:[isDp dataUsingEncoding:NSUTF8StringEncoding] name:@"is_dep"];
        }else if ([fromDynamic isEqualToString:@"条线发布动态"]) {
            //did
            [formData appendPartWithFormData:[institutionID dataUsingEncoding:NSUTF8StringEncoding] name:@"did"];
            [formData appendPartWithFormData:[isFC dataUsingEncoding:NSUTF8StringEncoding] name:@"is_fc"];
            [formData appendPartWithFormData:[isDp dataUsingEncoding:NSUTF8StringEncoding] name:@"is_ins"];
        }else if ([fromDynamic isEqualToString:@"主题发布动态"]) {
            //tid
            [formData appendPartWithFormData:[institutionID dataUsingEncoding:NSUTF8StringEncoding] name:@"tid"];
            
        }
        
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        [SVProgressHUD showProgress:totalBytesWritten/totalBytesExpectedToWrite status:@"发布中" maskType:SVProgressHUDMaskTypeBlack];
    }];
    [httpClient enqueueHTTPRequestOperation:operation];
    
    //上传完成
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",operation.responseString);
        
        [SVProgressHUD dismiss];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"字典%@",dict);
        
        if (1 == [dict[@"state"] integerValue]) {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"发布成功"];
            successBlock(YES,dict);
        }else{
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:dict[@"message"]];
            successBlock(NO,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];
    
}

#pragma mark - 脸谱群---条线
//脸谱群条线列表
//脸谱群条线列表---根据标签获取条线列表
+ (void)getGroupDepartmentScreeningByKeyWithClass_id:(NSString *)class_id WithPage:(NSInteger)page usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/groups/getDepartmentScreeningByKey&id=%@&token=%@&page=%d&class_id=%@",kMainUrlString,[self getUserId],[self getUserToken],page,class_id];
    
    NSLog(@"脸谱群条线列表%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"脸谱群条线列表%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            successBlock (YES,resultDictionary);
        }else {
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//脸谱群条线筛选标签列表
+ (void)getGroupDepartmentKeysWithUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/groups/getDepartmentKeys&id=%@&token=%@",kMainUrlString,[self getUserId],[self getUserToken]];
    
    NSLog(@"脸谱群条线筛选标签列表%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"脸谱群条线筛选标签列表%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            successBlock (YES,resultDictionary);
        }else {
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];
}

//申请加入脸谱条线群
+ (void)addDepartmentGroupWithDepartment_id:(NSString *)department_id WithType:(NSString *)type usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/groups/addDepartmentGroup&id=%@&token=%@&department_id=%@&type=%@",kMainUrlString,[self getUserId],[self getUserToken],department_id,type];
    
    NSLog(@"申请加入脸谱条线群%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"申请加入脸谱条线群%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            successBlock (YES,resultDictionary);
        }else {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"金币不足"];
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//脸谱群条线群用户列表
+ (void)getGroupsDepartmentUsersWithDid:(NSString *)did WithPage:(NSInteger)page usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/groups/getDepartmentUsers&id=%@&token=%@&did=%@&page=%d",kMainUrlString,[self getUserId],[self getUserToken],did,page];
    
    NSLog(@"脸谱群条线群用户列表%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"脸谱群条线群用户列表%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            successBlock (YES,resultDictionary);
        }else {
            
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//脸谱群条线群动态列表
+ (void)getGroupsDepartmentActionListWithDid:(NSString *)did WithPage:(NSInteger)page usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/groups/getDepartmentActionList&id=%@&token=%@&did=%@&page=%d",kMainUrlString,[self getUserId],[self getUserToken],did,page];
    
    NSLog(@"脸谱群条线群动态列表%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"脸谱群条线群动态列表%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            successBlock (YES,resultDictionary);
        }else {
            
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//脸谱群条线动态详情====机构动态详情====主题动态详情
+ (void)getGroupsWithFromDetail:(NSString *)fromDetail WithAid:(NSString *)aid WithPage:(NSInteger)page usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    if ([fromDetail isEqualToString:@"机构动态"]) {
        fromDetail = @"getInstitutionActionDetail";
    }else if ([fromDetail isEqualToString:@"条线动态"]) {
        fromDetail = @"getDepartmentActionDetail";
    }else if ([fromDetail isEqualToString:@"主题动态"]) {
        fromDetail = @"getThemeActionDetail";
    }
    
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/groups/%@&id=%@&token=%@&aid=%@&page=%d",kMainUrlString,fromDetail,[self getUserId],[self getUserToken],aid,page];
    
    NSLog(@"脸谱群动态详情%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"脸谱群动态详情%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            successBlock (YES,resultDictionary);
        }else {
            
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];
    
}

//脸谱群条线动态评论====机构动态评论====主题动态评论
+ (void)GetGroupsWithFromComment:(NSString *)fromComment WithIid:(NSString *)iid WithAid:(NSString *)aid WithContent:(NSString *)content usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    if ([fromComment isEqualToString:@"机构动态"]) {
        fromComment = @"setInstitutionActionComment&iid";
    }else if ([fromComment isEqualToString:@"条线动态"]) {
        fromComment = @"setDepartmentActionComment&did";
    }else if ([fromComment isEqualToString:@"主题动态"]) {
        fromComment = @"setThemeActionComment&tid";
    }
    
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/groups/%@=%@&aid=%@&id=%@&token=%@&content=%@",kMainUrlString,fromComment,iid,aid,[self getUserId],[self getUserToken],content];
    
    NSLog(@"脸谱群动态评论%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"脸谱群动态评论%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"发送成功"];
            successBlock (YES,resultDictionary);
        }else {
            
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];
 
}

//条线群群聊--常用联系人
+ (void)getDepartmentTopContactsWithDepartment_id:(NSString *)department_id usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/groups/getDepartmentTopContacts&id=%@&token=%@&department_id=%@",kMainUrlString,[self getUserId],[self getUserToken],department_id];
    
    NSLog(@"条线群群聊--常用联系人%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"条线群群聊--常用联系人%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            successBlock (YES,resultDictionary);
        }else {
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//条线群群聊--群聊列表 --条线群某用户的群聊列表
+ (void)getDepartmentGroupUsersWithDepartment_id:(NSString *)department_id usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/groups/getDepartmentGroupUsers&id=%@&token=%@&department_id=%@",kMainUrlString,[self getUserId],[self getUserToken],department_id];
    
    NSLog(@"条线群群聊--群聊列表%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"条线群群聊--群聊列表%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            successBlock (YES,resultDictionary);
        }else {
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//条线群创建聊天群
+ (void)createDepartmentChatGroupWithUserStr:(NSString *)userStr WithGroupName:(NSString *)groupName WithDepartment_id:(NSString *)department_id usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/groups/createDepartmentChatGroup&id=%@&token=%@&users=%@&department_id=%@&name=%@",kMainUrlString,[self getUserId],[self getUserToken],userStr,department_id,groupName];
    
    NSLog(@"条线群创建聊天群%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"条线群创建聊天群%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"创建成功"];
            successBlock (YES,resultDictionary);
        }else {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];
}

#pragma mark - 脸谱群---主题
//脸谱群主题列表---根据关键字搜索主题
+ (void)getGroupsThemeListWithKeys:(NSString *)keys WithPage:(NSInteger)page usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/groups/getThemeList&id=%@&token=%@&keys=%@&page=%d",kMainUrlString,[self getUserId],[self getUserToken],keys,page];
    
    NSLog(@"脸谱群主题列表%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"脸谱群主题列表%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            successBlock (YES,resultDictionary);
        }else {
            
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//申请加入脸谱主题群
+ (void)addThemeGroupWithTheme_id:(NSString *)theme_id WithType:(NSString *)type usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/groups/addThemeGroup&id=%@&token=%@&theme_id=%@&type=%@",kMainUrlString,[self getUserId],[self getUserToken],theme_id,type];
    
    NSLog(@"申请加入脸谱主题群%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"申请加入脸谱主题群%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            successBlock (YES,resultDictionary);
        }else {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//创建主题群前上传主题头像接口
+ (void)createThemeGroupUploadWithGroupImage:(UIImage *)groupImage usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@index.php?r=default/groups/createThemeGroupUpload/",kMainUrlString]]];
    NSData *imageData = UIImageJPEGRepresentation(groupImage, 0.001);
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:nil parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData)  {
        
        [formData appendPartWithFileData:imageData name:@"picture" fileName:@"test.png" mimeType:@"image/png"];
        [formData appendPartWithFormData:[[self getUserId] dataUsingEncoding:NSUTF8StringEncoding] name:@"id"];
        [formData appendPartWithFormData:[[self getUserToken] dataUsingEncoding:NSUTF8StringEncoding] name:@"token"];
        
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        [SVProgressHUD showProgress:totalBytesWritten/totalBytesExpectedToWrite status:@"上传中" maskType:SVProgressHUDMaskTypeBlack];
    }];
    [httpClient enqueueHTTPRequestOperation:operation];
    
    //上传完成
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",operation.responseString);
        
        [SVProgressHUD dismiss];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"图片%@",dict);
        
        if (1 == [dict[@"state"] integerValue]) {
            //[[DMCAlertCenter defaultCenter] postAlertWithMessage:@"上传成功"];
            successBlock(YES,dict);
        }else{
            successBlock(NO,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//创建脸谱群主题群
+ (void)createThemeGroupWithLogo_id:(NSString *)logo_id WithTitle:(NSString *)title usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/groups/createThemeGroup&id=%@&token=%@&logo_id=%@&title=%@",kMainUrlString,[self getUserId],[self getUserToken],logo_id,title];
    
    NSLog(@"创建脸谱群主题群%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"创建脸谱群主题群%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"创建成功"];
            successBlock (YES,resultDictionary);
        }else {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];
}

//脸谱群主题群用户列表
+ (void)getGroupsThemeUsersWithTid:(NSString *)tid WithPage:(NSInteger)page usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/groups/getThemeUsers&id=%@&token=%@&tid=%@&page=%d",kMainUrlString,[self getUserId],[self getUserToken],tid,page];
    
    NSLog(@"脸谱群主题群用户列表%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"脸谱群主题群用户列表%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            successBlock (YES,resultDictionary);
        }else {

            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//脸谱群主题群动态列表
+ (void)getGroupsThemeActionListWithTid:(NSString *)tid WithPage:(NSInteger)page usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/groups/getThemeActionList&id=%@&token=%@&page=%d&tid=%@",kMainUrlString,[self getUserId],[self getUserToken],page,tid];
    
    NSLog(@"脸谱群主题群动态列表%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"脸谱群主题群动态列表%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            successBlock (YES,resultDictionary);
        }else {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];
}

//主题群群聊--常用联系人
+ (void)getThemeTopContactsWithTheme_id:(NSString *)theme_id usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/groups/getThemeTopContacts&id=%@&token=%@&theme_id=%@",kMainUrlString,[self getUserId],[self getUserToken],theme_id];
    
    NSLog(@"主题群群聊--常用联系人%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"主题群群聊--常用联系人%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            successBlock (YES,resultDictionary);
        }else {
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//主题群群聊--群聊列表 --条线群某用户的群聊列表
+ (void)getThemeGroupUsersWithTheme_id:(NSString *)theme_id usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/groups/getThemeGroupUsers&id=%@&token=%@&theme_id=%@",kMainUrlString,[self getUserId],[self getUserToken],theme_id];
    
    NSLog(@"主题群群聊--群聊列表%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"主题群群聊--群聊列表%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            successBlock (YES,resultDictionary);
        }else {
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//主题群创建聊天群
+ (void)createThemeChatGroupWithUserStr:(NSString *)userStr WithGroupName:(NSString *)groupName WithTheme_id:(NSString *)theme_id usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/groups/createThemeChatGroup&id=%@&token=%@&users=%@&theme_id=%@&name=%@",kMainUrlString,[self getUserId],[self getUserToken],userStr,theme_id,groupName];
    
    NSLog(@"主题群创建聊天群%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"主题群创建聊天群%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"创建成功"];
            successBlock (YES,resultDictionary);
        }else {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];
}

//********群成员接口********
//机构的每一个群的所有成员
+ (void)GetTheInstitutionGroupMembersListWithInstitutionID:(NSString *)institutionId usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/groups/institutionGroupUsers&id=%@&institution_id=%@&token=%@",kMainUrlString,[self getUserId],institutionId,[self getUserToken]];
    
    NSLog(@"机构的每一个群的所有成员URL%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"机构的每一个群的所有成员%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            
            successBlock (YES,resultDictionary);
        }else {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//条线的每一个群的所有成员
+ (void)GetTheDepartmentGroupMembersListWithDepartmentID:(NSString *)departmentId usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/groups/departmentGroupUsers&id=%@&department_id=%@&token=%@",kMainUrlString,[self getUserId],departmentId,[self getUserToken]];
    
    NSLog(@"条线的每一个群的所有成员URL%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"条线的每一个群的所有成员%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            
            successBlock (YES,resultDictionary);
        }else {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//主题的每一个群的所有成员
+ (void)GetTheThemeGroupMembersListWithThemeID:(NSString *)themeId usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/groups/themeGroupUsers&id=%@&theme_id=%@&token=%@",kMainUrlString,[self getUserId],themeId,[self getUserToken]];
    
    NSLog(@"主题的每一个群的所有成员URL%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"主题的每一个群的所有成员%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            
            successBlock (YES,resultDictionary);
        }else {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//***********退出群接口*************
//机构的群成员主动退群
+ (void)exitTheInstitutionGroupWithGroupID:(NSString *)groupId WithTypeID:(NSString *)typeId   WithUserId:(NSString *)userid usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/groups/institutionChatGroupUserBye&id=%@&token=%@&institution_id=%@&group_id=%@&uid=%@",kMainUrlString,[self getUserId],[self getUserToken],typeId,groupId,[self getUserId]];
    
    NSLog(@"机构的群成员主动退群URL%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"机构的群成员主动退群%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            
            successBlock (YES,resultDictionary);
        }else {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//条线的群成员主动退群
+ (void)exitTheDepartmentGroupWithGroupID:(NSString *)groupId WithTypeID:(NSString *)typeId   WithUserId:(NSString *)userid usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/groups/departmentChatGroupUserBye&id=%@&token=%@&department_id=%@&group_id=%@&uid=%@",kMainUrlString,[self getUserId],[self getUserToken],typeId,groupId,[self getUserId]];
    
    NSLog(@"条线的群成员主动退群URL%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"条线的群成员主动退群%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            
            successBlock (YES,resultDictionary);
        }else {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//主题的群成员主动退群
+ (void)exitTheThemeGroupWithGroupID:(NSString *)groupId WithTypeID:(NSString *)typeId   WithUserId:(NSString *)userid usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/groups/themeChatGroupUserBye&id=%@&token=%@&theme_id=%@&group_id=%@&uid=%@",kMainUrlString,[self getUserId],[self getUserToken],typeId,groupId,[self getUserId]];
    
    NSLog(@"主题的群成员主动退群URL%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"主题的群成员主动退群%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            
            successBlock (YES,resultDictionary);
        }else {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}


//**********脸谱群私聊前调用的接口***************
//机构私聊前调用
+ (void)BeforeTheInstitutionPrivateChatWithInstitutionID:(NSString *)institutionid WithFriendID:(NSString *)friendId usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/groups/beforeInstitutionPrivateChat&id=%@&token=%@&institution_id=%@&friend_id=%@",kMainUrlString,[self getUserId],[self getUserToken],institutionid,friendId];
    
    NSLog(@"机构私聊前调用URL%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"机构私聊前调用%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            
            successBlock (YES,resultDictionary);
        }else {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//条线私聊前调用
+ (void)BeforeTheDepartmentPrivateChatWithDepartmentID:(NSString *)departmentid WithFriendID:(NSString *)friendId usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/groups/beforeDepartmentPrivateChat&id=%@&token=%@&department_id=%@&friend_id=%@",kMainUrlString,[self getUserId],[self getUserToken],departmentid,friendId];
    
    NSLog(@"条线私聊前调用URL%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"条线私聊前调用%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            
            successBlock (YES,resultDictionary);
        }else {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//主题私聊前调用
+ (void)BeforeTheThemePrivateChatWithThemeID:(NSString *)themeid WithFriendID:(NSString *)friendId usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/groups/beforeThemePrivateChat&id=%@&token=%@&theme_id=%@&friend_id=%@",kMainUrlString,[self getUserId],[self getUserToken],themeid,friendId];
    
    NSLog(@"主题私聊前调用URL%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"主题私聊前调用%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            
            successBlock (YES,resultDictionary);
        }else {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}





#pragma mark - 升级VIP
//上传名片
+ (void)uploadCardWithCardImage:(UIImage *)cardImage usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@index.php?r=default/set/uploadCard/",kMainUrlString]]];
    NSData *imageData = UIImageJPEGRepresentation(cardImage, 0.001);
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:nil parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData)  {
        
        [formData appendPartWithFileData:imageData name:@"card" fileName:@"test.png" mimeType:@"image/png"];
        [formData appendPartWithFormData:[[self getUserId] dataUsingEncoding:NSUTF8StringEncoding] name:@"uid"];
        
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        [SVProgressHUD showProgress:totalBytesWritten/totalBytesExpectedToWrite status:@"上传中" maskType:SVProgressHUDMaskTypeBlack];
    }];
    [httpClient enqueueHTTPRequestOperation:operation];
    
    //上传完成
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",operation.responseString);
        
        [SVProgressHUD dismiss];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"图片%@",dict);
        
        if (1 == [dict[@"state"] integerValue]) {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"上传成功"];
            successBlock(YES,dict);
        }else{
            successBlock(NO,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];
    
}

//升级VIP
+ (void)updateVIPWithCardId:(NSString *)card WithGold:(NSString *)gold usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    [SVProgressHUD show];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@index.php?r=default/set/update/",kMainUrlString]]];
    
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:nil parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData)  {
        
        [formData appendPartWithFormData:[[self getUserId] dataUsingEncoding:NSUTF8StringEncoding] name:@"uid"];
        [formData appendPartWithFormData:[card dataUsingEncoding:NSUTF8StringEncoding] name:@"card"];
        [formData appendPartWithFormData:[gold dataUsingEncoding:NSUTF8StringEncoding] name:@"gold"];
        
        
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [httpClient enqueueHTTPRequestOperation:operation];
    
    //上传完成
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        
        NSLog(@"升级VIP%@",operation.responseString);
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"升级VIP%@",dict);
        
        if (1 == [dict[@"state"] integerValue]) {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"购买成功"];
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            dic = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInformation"] mutableCopy];
            [dic setValue:@"1" forKey:@"is_vip"];
            
            NSLog(@"%@",dic);
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserInformation"];
            [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"UserInformation"];
            
            successBlock(YES,dict);
        }else if (2 == [dict[@"state"] integerValue])
        {
            successBlock(YES,dict);
        }
        else{
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:dict[@"message"]];
            successBlock(NO,dict);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];
    
}

//金币充值列表
+ (void)goldcoinsListWithUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/set/gold",kMainUrlString];
    
    NSLog(@"金币充值列表%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"金币充值列表%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            successBlock (YES,resultDictionary);
        }else {
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];
    
}
//充值完成后调用接口
+ (void)addGoldCoinsWithCoins:(NSString *)coins usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/groups/addGoldCoins&id=%@&token=%@&coins=%@",kMainUrlString,[self getUserId],[self getUserToken],coins];
    
    NSLog(@"充值完成后调用接口%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"充值完成后调用接口%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            successBlock (YES,resultDictionary);
        }else {
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];
    
}

//分享成功后加金币
+ (void)inviteWithType:(NSString *)type usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/set/invite&id=%@&type=%@",kMainUrlString,[self getUserId],type];
    
    NSLog(@"分享成功后加金币%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"分享成功后加金币%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            successBlock (YES,resultDictionary);
        }else {
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        //[[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];
}


#pragma mark - 圈圈页面
///1，得到圈圈的图片的接口
+ (void)getLPImageWithInstitutionId:(NSString*)institution_id       // 机构id
                       SuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/draw/getXYPic&id=%@&token=%@&institution_id=%@",kMainUrlString,[self getUserId],[self getUserToken],institution_id];
    
    NSLog(@"得到圈圈的图片的接口%@",stringURL);
    
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        
        NSLog(@"得到圈圈的图片的接口%@",resultDictionary);
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            
            successBlock (YES,resultDictionary);
        }else {
            successBlock (NO, nil);
        }
    } andFailureBlock:^(NSError *resultError) {
        
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
        successBlock (NO, nil);
    }];
    
}

///2、获取某坐标某范围内的其他坐标
+ (void)getPointsWithOrginX:(NSString*)orgin_x OrginY:(NSString*)orgin_y Distance:(NSString*)distance InstitutionId:(NSString*)institution_id successBlock:(void (^)(NSMutableArray* dataArray))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/draw/getXYUsers&id=%@&token=%@&x=%@&y=%@&distance=%@&institution_id=%@",kMainUrlString,[self getUserId],[self getUserToken],orgin_x,orgin_y,distance,institution_id];
    
    NSLog(@"获取某坐标某范围内的其他坐标%@",stringURL);
    
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        
        NSLog(@"获取某坐标某范围内的其他坐标%@",resultDictionary);
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            successBlock ([resultDictionary objectForKey:@"list"]);
        }else {
            successBlock (nil);
        }
    } andFailureBlock:^(NSError *resultError) {
        
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
        successBlock (nil);
    }];
    
}

///机构确认关系
+ (void)confirmationWithType:(NSString *)type WithFriend_id:(NSString *)friend_id WithInstitution_id:(NSString *)institution_id usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/groups/confirmation&id=%@&token=%@&friend_id=%@&institution_id=%@&type=%@",kMainUrlString,[self getUserId],[self getUserToken],friend_id,institution_id,type];
    
    NSLog(@"机构确认关系%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"机构确认关系%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"确认成功"];
            successBlock (YES,resultDictionary);
        }else {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];
}


#pragma mark - 输入提醒
//获取已知公司的名称

+ (void)GetTheWeKnowCompanyNameWithClass_id:(NSString *)classids UsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
//+ (void)GetTheWeKnowCompanyNameUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/start/company&class_id=%@",kMainUrlString,classids];
    
    NSLog(@"获取已知公司的名称URL%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"获取已知公司的名称%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            
            successBlock (YES,resultDictionary);
        }else {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}
//获取已知小学名称
+ (void)GetTheWeKnowPrimarySchoolNameUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/start/primary_school",kMainUrlString];
    
    NSLog(@"获取已知小学名称URL%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"获取已知小学名称%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            
            successBlock (YES,resultDictionary);
        }else {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}
//获取已知初中名称
+ (void)GetTheWeKnowJuniorSchoolNameUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/start/junior_middle_school",kMainUrlString];
    
    NSLog(@"获取已知初中名称URL%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"获取已知初中名称%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            
            successBlock (YES,resultDictionary);
        }else {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}
//获取已知高中名称
+ (void)GetTheWeKnowHighSchoolNameUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/start/high_school",kMainUrlString];
    
    NSLog(@"获取已知高中名称URL%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"获取已知高中名称%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            
            successBlock (YES,resultDictionary);
        }else {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}
//获取已知大学名称
+ (void)GetTheWeKnowUniversityNameUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/start/university",kMainUrlString];
    
    NSLog(@"获取已知大学名称URL%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"获取已知大学名称%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            
            successBlock (YES,resultDictionary);
        }else {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}
//*********添加群成员****************
//机构群添加成员
+ (void)InstitutionChatGroupAddNewMemberWithMembers:(NSString *)members WithGroupID:(NSString *)groupid WithInstitutionID:(NSString *)institutionId usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/groups/institutionChatGroupAddUser&id=%@&token=%@&users=%@&institution_id=%@&group_id=%@",kMainUrlString,[self getUserId],[self getUserToken],members,institutionId,groupid];
    
    NSLog(@"机构群添加成员URL%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"机构群添加成员%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            
            successBlock (YES,resultDictionary);
        }else {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//条线群添加成员
+ (void)DepartmentChatGroupAddNewMemberWithMembers:(NSString *)members WithGroupID:(NSString *)groupid WithDepartmentID:(NSString *)departmentId usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/groups/departmentChatGroupAddUser&id=%@&token=%@&users=%@&department_id=%@&group_id=%@",kMainUrlString,[self getUserId],[self getUserToken],members,departmentId,groupid];
    
    NSLog(@"条线群添加成员URL%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"条线群添加成员%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            
            successBlock (YES,resultDictionary);
        }else {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//主题群添加成员
+ (void)ThemeChatGroupAddNewMemberWithMembers:(NSString *)members WithGroupID:(NSString *)groupid WithThemeID:(NSString *)themeId usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/groups/themeChatGroupAddUser&id=%@&token=%@&users=%@&theme_id=%@&group_id=%@",kMainUrlString,[self getUserId],[self getUserToken],members,themeId,groupid];
    
    NSLog(@"主题群添加成员URL%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"主题群添加成员%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            
            successBlock (YES,resultDictionary);
        }else {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

//*********************************
//删除部落消息
+ (void)deleteTheRemindMessageWithMessageID:(NSString *)messageId usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/set/delInfo&id=%@&token=%@&info_id=%@",kMainUrlString,[self getUserId],[self getUserToken],messageId];
    
    NSLog(@"删除部落消息URL%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"删除部落消息%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            
            successBlock (YES,resultDictionary);
        }else {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

///检测是否有部落消息
+ (void)CheckTheNewRemindMessageUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/set/noReadLog&id=%@&token=%@",kMainUrlString,[self getUserId],[self getUserToken]];
    
    NSLog(@"检测是否有部落消息URL%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
//        NSLog(@"检测是否有部落消息%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            
            successBlock (YES,resultDictionary);
        }else {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}


///咨询接口新加
//新闻分类列表
+ (void)GetTheNewsClassListsUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/informations/getTypeList&id=%@&token=%@",kMainUrlString,[self getUserId],[self getUserToken]];
    
    NSLog(@"新闻分类列表URL%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"新闻分类列表%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            
            successBlock (YES,resultDictionary);
        }else {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}
//新闻列表
+ (void)GetTheNewsListsWithPages:(NSInteger)pages WithTypeID:(NSString *)typeId usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/informations/getNewListByType&id=%@&token=%@&page=%d&type_id=%@",kMainUrlString,[self getUserId],[self getUserToken],pages,typeId];
    
    NSLog(@"新闻列表URL%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"新闻列表%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            
            successBlock (YES,resultDictionary);
        }else {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}
//广告
+ (void)GetTheAdvertisementListWithUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/ads/adsList&id=%@&token=%@",kMainUrlString,[self getUserId],[self getUserToken]];
    
    NSLog(@"广告URL%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"广告列表%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            
            successBlock (YES,resultDictionary);
        }else {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

///我的联系人创建群
+ (void)CreateGroupOnMyContactPeopleWithUsers:(NSString *)users WithGroupName:(NSString *)name usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/set/createChatGroup&id=%@&token=%@&users=%@&name=%@",kMainUrlString,[self getUserId],[self getUserToken],users,name];
    
    NSLog(@"我的联系人创建群URL%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"我的联系人创建群%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            
            successBlock (YES,resultDictionary);
        }else {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}
///我的联系人群-成员
+ (void)TheMemberOfContactGroupPeopleWithGroupID:(NSString *)groupId usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/set/groupUsers&id=%@&gid=%@&token=%@",kMainUrlString,[self getUserId],groupId,[self getUserToken]];
    
    NSLog(@"我的联系人群-成员URL%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"我的联系人群-成员%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            
            successBlock (YES,resultDictionary);
        }else {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}
///我的连立人退群
+ (void)ExitTheContactPeopleGroupWithGroupID:(NSString *)groupId WithUserID:(NSString *)userid usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/set/groupUserBye&id=%@&token=%@&group_id=%@&uid=%@",kMainUrlString,[self getUserId],[self getUserToken],groupId,userid];
    
    NSLog(@"我的连立人退群URL%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"我的连立人退群%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            
            successBlock (YES,resultDictionary);
        }else {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

///我的联系人群添加成员
+ (void)AddMemberOfContactPeopleGroupWithUsers:(NSString *)users WithGroupId:(NSString *)groupid usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/set/groupAddUser&id=%@&token=%@&users=%@&group_id=%@",kMainUrlString,[self getUserId],[self getUserToken],users,groupid];
    
    NSLog(@"我的联系人群添加成员URL%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"我的联系人群添加成员%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            
            successBlock (YES,resultDictionary);
        }else {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:resultDictionary[@"message"]];
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}
///分享咨询得金币
+ (void)getTheGoldAfterShareInformationWithType:(NSString *)type usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/set/compare&id=%@&type=%@",kMainUrlString,[self getUserId],type];
    
    NSLog(@"分享成功后加金币%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"分享成功后加金币%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            successBlock (YES,resultDictionary);
        }else {
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}

///4.44注册成功后调取的接口，用于聊天和推送
+ (void)sendTheUserTokenAndDriveTokenWithUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock
{
    NSString *stringURL = [NSString stringWithFormat:@"%@index.php?r=default/groups/getDeviceToken&id=%@&token=%@&device_token=%@",kMainUrlString,[self getUserId],[self getUserToken],[[NSUserDefaults standardUserDefaults] objectForKey:@"UserDeviceToken"]];
    
    NSLog(@"注册成功后调取的接口，用于聊天和推送%@",stringURL);
    [self getDictionaryWithStringURL:stringURL usingSuccessBlock:^(NSDictionary *resultDictionary) {
        NSLog(@"注册成功后调取的接口，用于聊天和推送%@",resultDictionary);
        
        if ([[resultDictionary objectForKey:@"state"] integerValue] == 1) {
            
            successBlock (YES,resultDictionary);
        }else {
            successBlock (NO,nil);
        }
        
    } andFailureBlock:^(NSError *resultError) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"网络未连接"];
    }];

}
@end
