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
            @{@"id": recordId, @"cid_voice": @11, @"cid_image": @12},
            @{@"id": recordId, @"cid_voice": @11, @"cid_image": @11},
            @{@"id": recordId, @"cid_voice": @19, @"cid_image": @20},
            @{@"id": recordId, @"cid_voice": @19, @"cid_image": @21},
            @{@"id": recordId, @"cid_voice": @4,  @"cid_image": @5},
            @{@"id": recordId, @"cid_voice": @4,  @"cid_image": @4},
            @{@"id": recordId, @"cid_voice": @6,  @"cid_image": @8},
            @{@"id": recordId, @"cid_voice": @6,  @"cid_image": @6},
            @{@"id": recordId, @"cid_voice": @8,  @"cid_image": @6},
            @{@"id": recordId, @"cid_voice": @8,  @"cid_image": @8},
        ];
        for(NSDictionary *record in records) {
            [self.database executeUpdate:@"INSERT INTO RecordDetails (id, cid_voice, cid_image) VALUES (:id, :cid_voice, :cid_image)"
                 withParameterDictionary:record];
        }
        
        // Insert fake records into database for last week.
        [self.database executeUpdate:@"INSERT INTO Records (type) VALUES (?)", @0];
        
        recordId = [NSNumber numberWithInt:[self.database lastInsertRowId]];
        records = @[
            @{@"id": recordId, @"cid_voice": @15, @"cid_image": @16},
            @{@"id": recordId, @"cid_voice": @15, @"cid_image": @15},
            @{@"id": recordId, @"cid_voice": @22, @"cid_image": @22},
            @{@"id": recordId, @"cid_voice": @9, @"cid_image":  @10},
            @{@"id": recordId, @"cid_voice": @9,  @"cid_image": @9},
            @{@"id": recordId, @"cid_voice": @13, @"cid_image": @14},
            @{@"id": recordId, @"cid_voice": @13, @"cid_image": @13},
            @{@"id": recordId, @"cid_voice": @18, @"cid_image": @18},
            @{@"id": recordId, @"cid_voice": @3,  @"cid_image": @3},
            @{@"id": recordId, @"cid_voice": @4,  @"cid_image": @4},
        ];
        for(NSDictionary *record in records) {
            [self.database executeUpdate:@"INSERT INTO RecordDetails (id, cid_voice, cid_image) VALUES (:id, :cid_voice, :cid_image)"
                 withParameterDictionary:record];
        }
        
        [self.database close];
    }
    return self;
}

#pragma mark - Data Interface

- (NSDictionary *)cardForId:(NSNumber *)cid
{
    NSDictionary *result;
    if([self.database open]) {
        FMResultSet *s = [self.database executeQuery:@"SELECT * FROM Cards WHERE id = ?", cid];
        if([s next]) {
            result = [s resultDict];
        }
        
        [self.database close];
    }
    return result;
}

- (NSArray *)arrayWithCardAfterDate:(NSDate *)date
{
    NSMutableArray *result = [NSMutableArray array];
    if([self.database open]) {
        FMResultSet *s = [self.database executeQuery:@"SELECT DISTINCT cid_voice FROM RecordDetails WHERE timestamp >= DATETIME(?)", [date stringWithSqliteFormat]];
        while([s next]) {
            [result addObject:[NSNumber numberWithInt:[s intForColumnIndex:0]]];
        }
        
        [self.database close];
    }
    return [NSArray arrayWithArray:result];
}

- (NSArray *)arrayWithErrorCardsForCard:(NSNumber *)cid afterDate:(NSDate *)date
{
    NSMutableArray *result = [NSMutableArray array];
    if([self.database open]) {
        FMResultSet *s = [self.database executeQuery:@"SELECT DISTINCT cid_image AS count FROM RecordDetails WHERE cid_voice = ? AND cid_voice != cid_image AND timestamp >= DATETIME(?)", cid, [date stringWithSqliteFormat]];
        while([s next]) {
            [result addObject:[NSNumber numberWithInt:[s intForColumnIndex:0]]];
        }
        
        [self.database close];
    }
    return [NSArray arrayWithArray:result];
}

- (int)countForCard:(NSNumber *)cid afterDate:(NSDate *)date
{
    return [self queryWithStatement:@"SELECT COUNT(*) FROM RecordDetails WHERE cid_voice = ? AND timestamp >= DATETIME(?)" forCard:cid afterDate:date];
}

- (int)errorForCard:(NSNumber *)cid afterDate:(NSDate *)date
{
    return [self queryWithStatement:@"SELECT COUNT(*) FROM RecordDetails WHERE cid_voice = ? AND cid_voice != cid_image AND timestamp >= DATETIME(?)" forCard:cid afterDate:date];
}

- (int)errorForCard:(NSNumber *)cid withErrorCard:(NSNumber *)errorCid afterDate:(NSDate *)date
{
    int result;
    if([self.database open]) {
        FMResultSet *s = [self.database executeQuery:@"SELECT COUNT(*) FROM RecordDetails WHERE cid_voice = ? AND cid_image = ? AND timestamp >= DATETIME(?)", cid, errorCid, [date stringWithSqliteFormat]];
        if([s next]) {
            result = [s intForColumnIndex:0];
        }
        
        [self.database close];
    }
    return result;
}

#pragma mark - Utility Methods

- (int)queryWithStatement:(NSString *)stmt forCard:(NSNumber *)cid afterDate:(NSDate *)date
{
    int result;
    if([self.database open]) {
        FMResultSet *s = [self.database executeQuery:stmt, cid, [date stringWithSqliteFormat]];
        if([s next]) {
            result = [s intForColumnIndex:0];
        }
        
        [self.database close];
    }
    return result;
}

@end
