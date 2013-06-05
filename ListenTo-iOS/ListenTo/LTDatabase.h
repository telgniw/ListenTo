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
@property (nonatomic, strong) NSNumber *currentRecordId;

+ (LTDatabase *)instance;

#pragma mark - Object Lifecycle

- (id)init;
- (id)initWithFakeRecords;

#pragma mark - Data Interface

- (NSDictionary *)cardForId:(NSNumber *)cid;

- (NSArray *)arrayWithCardAfterDate:(NSDate *)date;
- (NSArray *)arrayWithErrorCardsForCard:(NSNumber *)cid afterDate:(NSDate *)date;

- (int)countForCard:(NSNumber *)cid afterDate:(NSDate *)date;
- (int)errorForCard:(NSNumber *)cid afterDate:(NSDate *)date;
- (int)errorForCard:(NSNumber *)cid withErrorCard:(NSNumber *)errorCid afterDate:(NSDate *)date;

- (void)newRecordWithType:(int)type;
- (void)insertRowWithVoiceCard:(NSNumber *)cid_voice andImageCard:(NSNumber *)cid_image;

@end
