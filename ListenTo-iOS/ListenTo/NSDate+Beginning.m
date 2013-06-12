//
//  NSDate+Beginning.m
//  ListenTo
//
//  Created by Yi Huang on 13/5/29.
//  Copyright (c) 2013年 Rabbit Wears Pants. All rights reserved.
//

#import "NSDate+Beginning.h"

@implementation NSDate (Beginning)

+ (NSDate *)today
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:now];
    return [calendar dateFromComponents:components];
}

+ (NSDate *)yesterday
{
    return [[NSDate today] dateBySubtractingDays:1];
}

+ (NSDate *)firstDayOfTheWeek
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSYearForWeekOfYearCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit) fromDate:now];
    
    // Set to Monday.
    [components setWeekday:2];
    return [calendar dateFromComponents:components];
}

+ (NSDate *)dateFromString:(NSString *)dateString WithFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter dateFromString:dateString];
}

- (NSString *)stringWithSqliteFormat
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:self];
}

- (NSString *)stringWithAbbrFormat
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/gdd"];
    return [formatter stringFromDate:self];
}

- (NSDate *)dateByAddingDays:(NSInteger)nDays
{
    NSDate *today = [NSDate today];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSDayCalendarUnit) fromDate:today];
    [components setDay:nDays];
    return [calendar dateByAddingComponents:components toDate:today options:0];
}

- (NSDate *)dateBySubtractingDays:(NSInteger)nDays
{
    return [self dateByAddingDays:-nDays];
}

@end
