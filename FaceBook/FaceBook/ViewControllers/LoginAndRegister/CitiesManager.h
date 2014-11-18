//
//  CitiesManager.h
//  FaceBook
//
//  Created by 颜沛贤 on 14-5-7.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CitiesManager : NSObject


//得到国内城市列表---列表为一系列的key为字母，value为地点数组
+ (NSMutableDictionary *)getChinaCities;


@end
