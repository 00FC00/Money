//
//  MBDBManager.m
//  DMCMBdb
//
//  Created by NFJ on 13-1-25.
//  Copyright (c) 2013年 D Marketing Consultants (beijing) Limited. All rights reserved.
//

#import "MBDBManager.h"
#import "FMDatabase.h"

#define kDefaultDBName @"chuMianChatDB.sqlite"

@implementation MBDBManager
{
    NSString *dbPath;
}

static MBDBManager * sharedMBDBManager;

+(MBDBManager *) defaultMBDBManager {
	if (!sharedMBDBManager) {
		sharedMBDBManager = [[MBDBManager alloc] init];
	}
	return sharedMBDBManager;
}

- (id) init {
    self = [super init];
    if (self) {
        int state = [self initializeDBWithName:kDefaultDBName];
        if (state == -1) {
            NSLog(@"数据库初始化失败");
        } else {
            NSLog(@"数据库初始化成功");
        }
    }
    return self;
}

/**
 * 初始化数据库操作
 * name 数据库名称
 * 返回数据库初始化状态， 0 为 已经存在，1 为创建成功，-1 为创建失败
 */
- (int) initializeDBWithName:(NSString *) name
{
    if (!name) {
		return -1;  // 返回 数据库创建失败
	}
    // 沙盒Document目录
    NSString * docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)[0];
	dbPath = [docPath stringByAppendingString:[NSString stringWithFormat:@"/%@",name]];
	NSFileManager * fileManager = [NSFileManager defaultManager];
    BOOL exist = [fileManager fileExistsAtPath:dbPath];
    [self connect];
    if (!exist) {
        return 0;  // 返回 数据库已经存在
    } else {
        return 1;
	}
}

// 连接数据库
- (void) connect {
	if (!self.dataBase) {
		_dataBase = [[FMDatabase alloc] initWithPath:dbPath];
        NSLog(@"%@",dbPath);
	}
	if (![self.dataBase open]) {
		NSLog(@"不能打开数据库");
	}
}
// 关闭连接
- (void) close {
	[_dataBase close];
    sharedMBDBManager = nil;
}




@end
