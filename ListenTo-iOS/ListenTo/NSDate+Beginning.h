//
//  NSDate+Beginning.h
//  ListenTo
//
//  Created by Yi Huang on 13/5/29.
//  Copyright (c) 2013年 Rabbit Wears Pants. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Beginning)

+ (NSDate *)today;
+ (NSDate *)yesterday;
+ (NSDate *)firstDayOfTheWeek;

+ (NSDate *)dateFromString:(NSString *)dateString WithFormat:(NSString *)format;
- (NSString *)stringWithSqliteFormat;
- (NSString *)stringWithAbbrFormat;

- (NSDate *)dateByAddingDays:(NSInteger)nDays;
- (NSDate *)dateBySubtractingDays:(NSInteger)nDays;

@end
