//
//  CitiesManager.m
//  FaceBook
//
//  Created by 颜沛贤 on 14-5-7.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "CitiesManager.h"

@implementation CitiesManager

//得到中国的城市列表
+ (NSDictionary*)getChinaDictWithFilePath
{
    //读取Json
    //==Json文件路径
//    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *path=[paths objectAtIndex:0];
//    NSString *Json_path=[path stringByAppendingPathComponent:@"get_city_china.json"];
    NSString * Json_path = [[NSBundle mainBundle] pathForResource:@"LLprovince.json" ofType:nil];
    //==Json数据
    NSData *data=[NSData dataWithContentsOfFile:Json_path];
    //==JsonObject
    
    NSDictionary * JsonObject=[NSJSONSerialization JSONObjectWithData:data
                                                              options:NSJSONReadingAllowFragments
                                                                error:nil];
    
    return JsonObject;
}




+ (BOOL)isExistThekey:(NSString*)key inDict:(NSMutableDictionary*)dict
{
    NSMutableArray * keyarray = (NSMutableArray*)[dict allKeys];
    for (NSString * k in keyarray) {
        if ([key isEqualToString:k]) {
            return YES;
        }
    }
    return NO;
}


//得到国内城市列表---列表为一系列的key为字母，value为地点数组
+ (NSMutableDictionary *)getChinaCities
{
    NSDictionary * citiesDict = [CitiesManager getChinaDictWithFilePath];
    NSLog(@"city dict is %@",citiesDict);
    NSArray * c_arr = [citiesDict objectForKey:@"list"];
    
    
    NSMutableDictionary * tempDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    
    if (c_arr.count > 0) {
        NSString * f_key = [[c_arr objectAtIndex:0] objectForKey:@"group"];
        NSMutableArray * f_arr = [[NSMutableArray alloc] initWithObjects:[c_arr objectAtIndex:0], nil];
        [tempDict setObject:f_arr forKey:f_key];
        
        
        for (NSInteger i = 1; i < c_arr.count; i ++) {
            NSString * key = [[c_arr objectAtIndex:i] objectForKey:@"group"];
            if ([CitiesManager isExistThekey:key inDict:tempDict] == YES) {
                NSMutableArray * t_arr = [tempDict objectForKey:key];
                [t_arr addObject:[c_arr objectAtIndex:i]];
                //NSLog(@"t_arr is %@",t_arr);
                [tempDict setObject:t_arr forKey:key];
            }else {
                //没有次key
                NSString * t_key = [[c_arr objectAtIndex:i] objectForKey:@"group"];
                NSMutableArray * t_arr = [[NSMutableArray alloc] initWithObjects:[c_arr objectAtIndex:i], nil];
                [tempDict setObject:t_arr forKey:t_key];
                
            }
        }
    }
    
    NSLog(@"dict is %@",tempDict);
    
    return tempDict;
}




@end
