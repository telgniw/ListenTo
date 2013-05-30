//
//  LTDatabase.m
//  ListenTo
//
//  Created by Yi Huang on 13/5/28.
//  Copyright (c) 2013年 Rabbit Wears Pants. All rights reserved.
//

#import "LTDatabase.h"

@implementation LTDatabase

+ (LTDatabase *)instance
{
    static LTDatabase *instance;
    
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[LTDatabase alloc] initWithFakeRecords];
    });
    
    return instance;
}

#pragma mark - Object Lifecycle

- (id)init
{
    if(self = [super init]) {
        BOOL success;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *dirPath = [path objectAtIndex:0];
        
        // Library path does not exist.
        if(![fileManager fileExistsAtPath:dirPath]) {
            success = [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
            
            // Failed to create directory.
            if(!success) {
                return nil;
            }
        }
        
        NSString *dbPath = [dirPath stringByAppendingPathComponent:@"lt-user.sqlite3"];
        
        // DEBUG: remove after finished.
        if([fileManager fileExistsAtPath:dbPath]) {
            success = [fileManager removeItemAtPath:dbPath error:nil];
            
            // Failed to remove existing database file.
            if(!success) {
                return nil;
            }
        }
        
        // Copy only if database does not exist.
        if(![fileManager fileExistsAtPath:dbPath]) {
            NSString *defaultPath = [[NSBundle mainBundle] pathForResource:@"default" ofType:@"sqlite3"];
            success = [fileManager copyItemAtPath:defaultPath toPath:dbPath error:nil];
            
            // Failed to copy the database file.
            if(!success) {
                return nil;
            }
        }
        
        self.database = [[FMDatabase alloc] initWithPath:dbPath];
    }
    
    return self;
}

- (id)initWithFakeRecords
{
    if(self = [self init]) {
        // Failed to open database.
        if(![self.database open]) {
            return nil;
        }
        
        // Insert fake records into database for today.
        [self.database executeUpdate:@"INSERT INTO Records (type) VALUES (?)", @0];
        
        NSNumber *recordId = [NSNumber numberWithInt:[self.database lastInsertRowId]];
        NSArray *records = @[
            @{@"id": recordId, @"cid_voice": @11, @"cid_image": @12, @"count": @2},
            @{@"id": recordId, @"cid_voice": @11, @"cid_image": @11, @"count": @2},
            @{@"id": recordId, @"cid_voice": @19, @"cid_image": @20, @"count": @1},
            @{@"id": recordId, @"cid_voice": @19, @"cid_image": @21, @"count": @3},
            @{@"id": recordId, @"cid_voice": @4,  @"cid_image": @5,  @"count": @3},
            @{@"id": recordId, @"cid_voice": @4,  @"cid_image": @4,  @"count": @1},
            @{@"id": recordId, @"cid_voice": @6,  @"cid_image": @8,  @"count": @1},
            @{@"id": recordId, @"cid_voice": @6,  @"cid_image": @6,  @"count": @3},
            @{@"id": recordId, @"cid_voice": @8,  @"cid_image": @6,  @"count": @2},
            @{@"id": recordId, @"cid_voice": @8,  @"cid_image": @8,  @"count": @2},
        ];
        for(NSDictionary *record in records) {
            [self.database executeUpdate:@"INSERT INTO RecordDetails (id, cid_voice, cid_image, count) VALUES (:id, :cid_voice, :cid_image, :count)"
                 withParameterDictionary:record];
        }
        
        // Insert fake records into database for last week.
        [self.database executeUpdate:@"INSERT INTO Records (type, timestamp) VALUES (?, ?)", @0, [[[NSDate today] dateBySubtractingDays:2] stringWithSqliteFormat]];
        
        recordId = [NSNumber numberWithInt:[self.database lastInsertRowId]];
        records = @[
            @{@"id": recordId, @"cid_voice": @15, @"cid_image": @16, @"count": @2},
            @{@"id": recordId, @"cid_voice": @15, @"cid_image": @15, @"count": @2},
            @{@"id": recordId, @"cid_voice": @22, @"cid_image": @22, @"count": @4},
            @{@"id": recordId, @"cid_voice": @9, @"cid_image":  @10, @"count": @3},
            @{@"id": recordId, @"cid_voice": @9,  @"cid_image": @9,  @"count": @1},
            @{@"id": recordId, @"cid_voice": @13, @"cid_image": @14, @"count": @2},
            @{@"id": recordId, @"cid_voice": @13, @"cid_image": @13, @"count": @2},
            @{@"id": recordId, @"cid_voice": @18, @"cid_image": @18, @"count": @4},
            @{@"id": recordId, @"cid_voice": @3,  @"cid_image": @3,  @"count": @4},
            @{@"id": recordId, @"cid_voice": @4,  @"cid_image": @4,  @"count": @4},
        ];
        for(NSDictionary *record in records) {
            [self.database executeUpdate:@"INSERT INTO RecordDetails (id, cid_voice, cid_image, count) VALUES (:id, :cid_voice, :cid_image, :count)"
                 withParameterDictionary:record];
        }
        
        [self.database close];
    }
    return self;
}

#pragma mark - Data Interface

- (NSDictionary *)cardForId:(int)cid
{
    NSDictionary *result;
    if([self.database open]) {
        FMResultSet *s = [self.database executeQuery:@"SELECT * FROM Cards WHERE id = ?", [NSNumber numberWithInt:cid]];
        if([s next]) {
            result = [s resultDict];
        }
        
        [self.database close];
    }
    return result;
}

- (NSDictionary *)recordForId:(int)rid
{
    NSMutableDictionary *result;
    if([self.database open]) {
        FMResultSet *s = [self.database executeQuery:@"SELECT * FROM Records WHERE id = ?", [NSNumber numberWithInt:rid]];
        if([s next]) {
            result = [[s resultDict] mutableCopy];
        }
        
        NSMutableArray *records = [NSMutableArray array];
        s = [self.database executeQuery:@"SELECT * FROM RecordDetails WHERE id = ?", [NSNumber numberWithInt:rid]];
        while([s next]) {
            [records addObject:[s resultDict]];
        }
        [result setObject:[NSArray arrayWithArray:records] forKey:@"details"];

        [self.database close];
    }
    return [NSDictionary dictionaryWithDictionary:result];
}

- (NSArray *)arrayWithCardIdsAfterDate:(NSDate *)date
{
    NSString *statement;
    
    if(date == nil)
        statement = @"SELECT DISTINCT cid_voice FROM RecordDetails";
    else
        statement = @"SELECT DISTINCT cid_voice FROM RecordDetails WHERE id IN (SELECT id FROM Records WHERE timestamp >= DATETIME(?))";
    
    return [self arrayWithIdsForStatement:statement afterDate:date];
}

- (NSArray *)arrayWithRecordIdsAfterDate:(NSDate *)date
{
    return [self arrayWithIdsForStatement:@"SELECT id FROM Records WHERE timestamp >= DATETIME(?)" afterDate:date];
}

- (NSArray *)recordsForCardId:(int)cid afterDate:(NSDate *)date
{
    NSMutableArray *result = [NSMutableArray array];
    if([self.database open]) {
        FMResultSet *s;
        
        if(date == nil)
            s = [self.database executeQuery:@"SELECT cid_image, count FROM RecordDetails WHERE cid_voice = ?", [NSNumber numberWithInt:cid]];
        else
            s = [self.database executeQuery:@"SELECT cid_image, count FROM RecordDetails WHERE cid_voice = ? AND id IN (SELECT id FROM Records WHERE timestamp >= DATETIME(?))", [NSNumber numberWithInt:cid], [date stringWithSqliteFormat]];
        
        while([s next]) {
            [result addObject:[s resultDict]];
        }
        
        [self.database close];
    }
    return [NSArray arrayWithArray:result];
}

#pragma mark - Utility Methods

- (NSArray *)arrayWithIdsForStatement:(NSString *)statement afterDate:(NSDate *)date
{
    NSMutableArray *result = [NSMutableArray array];
    if([self.database open]) {
        FMResultSet *s;
        
        if(date == nil)
            s = [self.database executeQuery:statement];
        else
            s = [self.database executeQuery:statement, [date stringWithSqliteFormat]];
        
        while([s next]) {
            [result addObject:[NSNumber numberWithInt:[s intForColumnIndex:0]]];
        }
        
        [self.database close];
    }
    return [NSArray arrayWithArray:result];
}

@end
