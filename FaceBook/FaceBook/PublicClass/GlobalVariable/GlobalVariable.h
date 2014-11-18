//
//  GlobalVariable.h
//  ForLove
//
//  Created by DMC on 12-8-23.
//  Copyright (c) 2012年 DMC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"

@interface GlobalVariable : NSObject

+ (id) sharedGlobalVariable;

@property (nonatomic, strong) NSMutableDictionary *meduleDic;


//公共墙所有分类
@property (nonatomic, strong) NSMutableArray *classificationArray;

//脸谱群--条线分类
@property (nonatomic, strong) NSMutableArray *lineClassArray;

///机构id
@property (nonatomic, strong) NSString *institutionsIdString;

//是否机构机构成员
@property (nonatomic, strong) NSString *institutionis_memberString;


//条线群id
@property (nonatomic, strong) NSString *departmentIdString;
//是否是条线机构成员
@property (nonatomic, strong) NSString *lineis_memberString;


//主题群id
@property (nonatomic, strong) NSString *themeIdString;
//是否是主题机构成员
@property (nonatomic, strong) NSString *themeis_memberString;


//存一下设备token
@property (strong, nonatomic) NSString *myPhonemark;

@end
