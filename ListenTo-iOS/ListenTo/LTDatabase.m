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
        // Insert fake records into database for today.
        [self newRecordWithType:0];
        [self insertRowWithVoiceCard:@11 andImageCard:@12];
        [self insertRowWithVoiceCard:@11 andImageCard:@12];
        [self insertRowWithVoiceCard:@11 andImageCard:@12];
        [self insertRowWithVoiceCard:@11 andImageCard:@11];
        [self insertRowWithVoiceCard:@19 andImageCard:@20];
        [self insertRowWithVoiceCard:@19 andImageCard:@21];
        [self insertRowWithVoiceCard:@19 andImageCard:@21];
        
        // Insert fake records into database for last week.
        [self newRecordWithType:0];
        [self insertRowWithVoiceCard:@15 andImageCard:@16 andTimestamp:[NSDate firstDayOfTheWeek]];
        [self insertRowWithVoiceCard:@15 andImageCard:@15 andTimestamp:[NSDate firstDayOfTheWeek]];
        [self insertRowWithVoiceCard:@22 andImageCard:@22 andTimestamp:[NSDate firstDayOfTheWeek]];
        [self insertRowWithVoiceCard:@9 andImageCard:@10 andTimestamp:[NSDate firstDayOfTheWeek]];
        [self insertRowWithVoiceCard:@9 andImageCard:@10 andTimestamp:[NSDate firstDayOfTheWeek]];
        [self insertRowWithVoiceCard:@9 andImageCard:@9 andTimestamp:[NSDate firstDayOfTheWeek]];
        [self insertRowWithVoiceCard:@4 andImageCard:@5 andTimestamp:[NSDate firstDayOfTheWeek]];
        [self insertRowWithVoiceCard:@4 andImageCard:@5 andTimestamp:[NSDate firstDayOfTheWeek]];
        [self insertRowWithVoiceCard:@4 andImageCard:@5 andTimestamp:[NSDate firstDayOfTheWeek]];
        [self insertRowWithVoiceCard:@4 andImageCard:@4 andTimestamp:[NSDate firstDayOfTheWeek]];
        
        // Insert fake records into database for two weeks ago.
        [self newRecordWithType:0];
        [self insertRowWithVoiceCard:@6 andImageCard:@8 andTimestamp:[[NSDate today] dateBySubtractingDays:14]];
        [self insertRowWithVoiceCard:@6 andImageCard:@8 andTimestamp:[[NSDate today] dateBySubtractingDays:14]];
        [self insertRowWithVoiceCard:@8 andImageCard:@8 andTimestamp:[[NSDate today] dateBySubtractingDays:14]];
        [self insertRowWithVoiceCard:@8 andImageCard:@6 andTimestamp:[[NSDate today] dateBySubtractingDays:14]];
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

- (void)newRecordWithType:(int)type
{
    if([self.database open]) {
        [self.database executeUpdate:@"INSERT INTO Records (type) VALUES (?)", [NSNumber numberWithInt:type]];
        self.currentRecordId = [NSNumber numberWithInt:[self.database lastInsertRowId]];
        [self.database close];
    }
}

- (void)insertRowWithVoiceCard:(NSNumber *)cid_voice andImageCard:(NSNumber *)cid_image
{
    if([self.database open]) {
        [self.database executeUpdate:@"INSERT INTO RecordDetails (id, cid_voice, cid_image) VALUES (:id, :cid_voice, :cid_image)"
             withParameterDictionary:@{@"id" : self.currentRecordId, @"cid_voice": cid_voice, @"cid_image": cid_image}];
        [self.database close];
    }
}

- (void)insertRowWithVoiceCard:(NSNumber *)cid_voice andImageCard:(NSNumber *)cid_image andTimestamp:(NSDate *)date
{
    if([self.database open]) {
        [self.database executeUpdate:@"INSERT INTO RecordDetails (id, cid_voice, cid_image, timestamp) VALUES (:id, :cid_voice, :cid_image, :timestamp)"
             withParameterDictionary:@{@"id" : self.currentRecordId, @"cid_voice": cid_voice, @"cid_image": cid_image, @"timestamp": [date stringWithSqliteFormat]}];
        [self.database close];
    }
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
