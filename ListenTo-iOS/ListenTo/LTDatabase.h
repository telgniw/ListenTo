//
//  LTDatabase.h
//  ListenTo
//
//  Created by Yi Huang on 13/5/28.
//  Copyright (c) 2013年 Rabbit Wears Pants. All rights reserved.
//

#import "FMDatabase.h"
#import "NSDate+Beginning.h"

static NSString *const LT_DB_KEY_CARD_NAME = @"name";
static NSString *const LT_DB_KEY_CARD_IMAGE = @"image";
static NSString *const LT_DB_KEY_CARD_VOICE = @"voice";

static NSString *const LT_DB_STAT_KEY_COUNT = @"count";
static NSString *const LT_DB_STAT_KEY_ERROR = @"error";
static NSString *const LT_DB_STAT_KEY_DATE = @"date";

@interface LTDatabase: NSObject

@property (nonatomic, strong) FMDatabase *database;
@property (nonatomic, strong) NSNumber *currentRecordId;

+ (LTDatabase *)instance;

#pragma mark - Object Lifecycle

- (id)init;
- (id)initWithFakeRecords;

#pragma mark - Data Interface

- (NSArray *)arrayWithAllCards;
- (NSDictionary *)cardForId:(NSNumber *)cid;
- (NSString *)cardNameForId:(NSNumber *)cid;

- (NSArray *)arrayWithCardAfterDate:(NSDate *)date;
- (NSArray *)arrayWithErrorCardsForCard:(NSNumber *)cid afterDate:(NSDate *)date;

- (int)countForCard:(NSNumber *)cid afterDate:(NSDate *)date;
- (int)errorForCard:(NSNumber *)cid afterDate:(NSDate *)date;
- (int)errorForCard:(NSNumber *)cid withErrorCard:(NSNumber *)errorCid afterDate:(NSDate *)date;

- (NSArray *)statisticsForCard:(NSNumber *)cid withNumberOfDays:(int)nDays;

- (void)newRecordWithType:(int)type;
- (void)insertRowWithVoiceCard:(NSNumber *)cid_voice andImageCard:(NSNumber *)cid_image;

@end
