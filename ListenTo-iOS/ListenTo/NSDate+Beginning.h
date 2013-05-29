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

- (NSString *)stringWithSqliteFormat;

- (NSDate *)dateByAddingDays:(NSInteger)nDays;
- (NSDate *)dateBySubtractingDays:(NSInteger)nDays;

@end
