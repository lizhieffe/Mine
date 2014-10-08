//
//  MineTimeUtil.h
//  Mine
//
//  Created by Zhi Li on 10/5/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MineTimeUtil : NSObject

+ (NSString *)getMonthStr:(NSInteger)month;
+ (NSString *)getShortMonthStr:(NSInteger)month;

+ (NSInteger)getCurrentDay;
+ (NSInteger)getCurrentMonth;
+ (NSInteger)getCurrentYear;
+ (NSInteger)getDayForUnixtime:(NSInteger)unixtime;
+ (NSInteger)getMonthForUnixtime:(NSInteger)unixtime;
+ (NSInteger)getYearForUnixtime:(NSInteger)unixtime;
+ (NSInteger)getDay:(NSDate *)date;
+ (NSInteger)getMonth:(NSDate *)date;
+ (NSInteger)getYear:(NSDate *)date;

+ (NSDate *)unixtimeToNSDate:(NSInteger)unixtime;

@end
