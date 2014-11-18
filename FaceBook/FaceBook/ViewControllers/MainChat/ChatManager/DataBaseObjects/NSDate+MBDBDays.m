//
//  NSDate+MBDBDays.m
//  DMCMBdb
//
//  Created by NFJ on 13-1-25.
//  Copyright (c) 2013年 D Marketing Consultants (beijing) Limited. All rights reserved.
//

#import "NSDate+MBDBDays.h"

@implementation NSDate (MBDBDays)


- (NSDate *)currDay {
	return [self currDayInCalendar:[NSCalendar currentCalendar]];
}

- (NSDate *)currDayInCalendar:(NSCalendar *)calendar {
	const unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
	NSDateComponents *components = [[NSCalendar currentCalendar] components:unitFlags fromDate:self];
	if (!components) {
		return self;
	}
	[components setHour:kBADayHour];
	NSDate *day = [calendar dateFromComponents:components];
	if (!day) {
		return self;
	}
	return day;
}

- (NSDate *) dateByAddingDays:(NSUInteger)days {
	NSDateComponents *c = [[NSDateComponents alloc] init];
	c.day = days;
	return [[NSCalendar currentCalendar] dateByAddingComponents:c toDate:self options:0];
}

- (NSInteger)daysSinceNow {
	return [self daysSinceNowInCalendar:[NSCalendar currentCalendar]];
}

- (NSInteger)daysSinceNowInCalendar:(NSCalendar *)calendar {
	NSDateComponents *components = [calendar components:NSDayCalendarUnit fromDate:[NSDate date] toDate:self options:0];
	return [components day];
}

+ (NSDate *)getDateWithDateString:(NSString *)strDate formatString:(NSString *)strFormat
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:strFormat];
    NSDate *date=[formatter dateFromString:strDate];
    return date;
}

+ (NSString *)stringFromDate:(NSDate *)date
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
    
}

- (BOOL) isSameDay:(NSDate*)anotherDate{
	NSCalendar* calendar = [NSCalendar currentCalendar];
	NSDateComponents* components1 = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self];
	NSDateComponents* components2 = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:anotherDate];
	return ([components1 year] == [components2 year] && [components1 month] == [components2 month] && [components1 day] == [components2 day]);
}

+ (NSString *)stringFromDate:(NSDate *)date andFormat:(NSString *)format
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    
    [dateFormatter setDateFormat:format];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
    
}

- (NSInteger) daysBetweenDate:(NSDate*)date {
    NSTimeInterval time = [self timeIntervalSinceDate:date];
    return ((abs(time) / (60.0 * 60.0 * 24.0)) + 0.5);
}

- (BOOL) isEarlierThanDate: (NSDate *) aDate{
	return ([self earlierDate:aDate] == self);
}

@end
