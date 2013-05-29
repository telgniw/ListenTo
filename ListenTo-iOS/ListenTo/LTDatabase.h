//
//  LTDatabase.h
//  ListenTo
//
//  Created by Yi Huang on 13/5/28.
//  Copyright (c) 2013年 Rabbit Wears Pants. All rights reserved.
//

#import "FMDatabase.h"
#import "NSDate+Beginning.h"

@interface LTDatabase: NSObject

@property (nonatomic, strong) FMDatabase *database;

+ (LTDatabase *)instance;

#pragma mark - Object Lifecycle

- (id)init;
- (id)initWithFakeRecords;

#pragma mark - Data Interface

- (NSDictionary *)cardForId:(int)cid;
- (NSDictionary *)recordForId:(int)rid;

- (NSArray *)arrayWithCardIdsAfterDate:(NSDate *)date;
- (NSArray *)arrayWithRecordIdsAfterDate:(NSDate *)date;

- (NSArray *)recordsForCardId:(int)cid afterDate:(NSDate *)date;

@end
