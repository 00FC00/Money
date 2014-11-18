//
//  NSDate+MBDBDays.h
//  DMCMBdb
//
//  Created by NFJ on 13-1-25.
//  Copyright (c) 2013年 D Marketing Consultants (beijing) Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kBADayHour 12

@interface NSDate (MBDBDays)

/*
 *  返回当前日期
 */
- (NSDate *)currDay;

/*
 *  返回指定日期之后的某一天
 */
- (NSDate *) dateByAddingDays:(NSUInteger)days;

/*
 *  从现在开始到指定日期多少天
 */
- (NSInteger)daysSinceNow;

/*
 *  两者相差多少天
 */
- (NSInteger) daysBetweenDate:(NSDate*)date;

/*
 *  NSString转成NSDate
 */
+ (NSDate *)getDateWithDateString:(NSString *)strDate formatString:(NSString *)strFormat;

/*
 *  NSString格式化转成NSDate
 */
+ (NSString *)stringFromDate:(NSDate *)date andFormat:(NSString *)format;

/*
 *  NSDate转成NSString
 */
+ (NSString *)stringFromDate:(NSDate *)date;

/*
 *  是否同一天
 */
- (BOOL) isSameDay:(NSDate*)anotherDate;

/*
 *  是否比另一个时间早
 */
- (BOOL) isEarlierThanDate: (NSDate *) aDate;

@end
