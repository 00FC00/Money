//
//  MBDBManager.h
//  DMCMBdb
//
//  Created by NFJ on 13-1-25.
//  Copyright (c) 2013年 D Marketing Consultants (beijing) Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabaseAdditions.h"

@class FMDatabase;

/**
 * 对数据链接进行管理，包括连接，关闭连接
 * 可以建立长连接
 */
@interface MBDBManager : NSObject

// 数据库操作对象
@property (nonatomic, readonly) FMDatabase * dataBase;
// 单例模式
+(MBDBManager *) defaultMBDBManager;
// 关闭数据库
- (void) close;

@end
