//
//  MineTimeUtil.m
//  Mine
//
//  Created by Zhi Li on 10/5/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import "MineTimeUtil.h"

@implementation MineTimeUtil

+ (NSString *)getMonthStr:(NSInteger)month
{
    NSString *monthStr = @"";
    if (month == 1)
        monthStr = @"January";
    else if (month == 2)
        monthStr = @"Febrary";
    else if (month == 3)
        monthStr = @"March";
    else if (month == 4)
        monthStr = @"April";
    else if (month == 5)
        monthStr = @"May";
    else if (month == 6)
        monthStr = @"June";
    else if (month == 7)
        monthStr = @"July";
    else if (month == 8)
        monthStr = @"August";
    else if (month == 9)
        monthStr = @"September";
    else if (month == 10)
        monthStr = @"Octorber";
    else if (month == 11)
        monthStr = @"November";
    else if (month == 12)
        monthStr = @"December";
    else
        monthStr = nil;
    return monthStr;
}

+ (NSString *)getShortMonthStr:(NSInteger)month
{
    return [[self getMonthStr:month] substringToIndex:3];
}

+ (NSInteger)getCurrentDay
{
    return [[self getCurrentDateComponents] day];
}

+ (NSInteger)getCurrentMonth
{
    return [[self getCurrentDateComponents] month];
}

+ (NSInteger)getCurrentYear
{
    return [[self getCurrentDateComponents] year];
}

+ (NSInteger)getDayForUnixtime:(NSInteger)unixtime
{
    return [[self getDateComponentsForUnixtime:unixtime] day];
}

+ (NSInteger)getMonthForUnixtime:(NSInteger)unixtime
{
    return [[self getDateComponentsForUnixtime:unixtime] month];
}

+ (NSInteger)getYearForUnixtime:(NSInteger)unixtime
{
    return [[self getDateComponentsForUnixtime:unixtime] year];
}

+ (NSInteger)getDay:(NSDate *)date
{
    return [[self getDateComponentsForDate:date] day];
}

+ (NSInteger)getMonth:(NSDate *)date
{
    return [[self getDateComponentsForDate:date] month];
}

+ (NSInteger)getYear:(NSDate *)date
{
    return [[self getDateComponentsForDate:date] year];
}

+ (NSDate *)unixtimeToNSDate:(NSInteger)unixtime
{
    return [NSDate dateWithTimeIntervalSince1970:unixtime];
}

+ (NSDateComponents *)getCurrentDateComponents
{
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    return components;
}

+ (NSDateComponents *)getDateComponentsForUnixtime:(NSInteger)unixtime
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:unixtime];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    return components;
}

+ (NSDateComponents *)getDateComponentsForDate:(NSDate *)date
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    return components;
}

+ (NSDate *)getDateForYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:day];
    [comps setMonth:month];
    [comps setYear:year];
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}

@end
