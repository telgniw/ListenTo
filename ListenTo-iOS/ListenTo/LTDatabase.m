//
//  LTDatabase.m
//  ListenTo
//
//  Created by Yi Huang on 13/5/28.
//  Copyright (c) 2013年 Rabbit Wears Pants. All rights reserved.
//

#import "LTDatabase.h"

#import "NSDate+Beginning.h"

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
        
        // Insert fake records into database.
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
            @{@"id": recordId, @"cid_voice": @6,  @"cid_image": @8,  @"count": @2},
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

- (NSArray *)arrayWithRecordIdsAfterDate:(NSDate *)startDate
{
    NSMutableArray *result = [NSMutableArray array];
    if([self.database open]) {
        FMResultSet *s = [self.database executeQuery:@"SELECT id FROM Records WHERE timestamp >= DATETIME(?)", [startDate stringWithSqliteFormat]];
        while([s next]) {
            [result addObject:[NSNumber numberWithInt:[s intForColumnIndex:0]]];
        }
        
        [self.database close];
    }
    return [NSArray arrayWithArray:result];
}

@end
