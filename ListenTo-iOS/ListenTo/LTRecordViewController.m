//
//  LTRecordViewController.m
//  ListenTo
//
//  Created by Yi Huang on 13/5/21.
//  Copyright (c) 2013年 Rabbit Wears Pants. All rights reserved.
//

#import "LTRecordViewController.h"
#import "LTRecordCell.h"
#import "LTDatabase.h"

@implementation LTRecordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDate *today = [NSDate today];
    [self fetchDataSetAfter:today];
}

#pragma mark - Data Source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"LTRecordCell";
    
    NSNumber *cid = self.cardIds[indexPath.row];
    NSDictionary *errorCards = self.errorCards[cid];
    
    LTDatabase *db = [LTDatabase instance];
    
    LTRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSDictionary *card = [db cardForId:cid];
    
    // Reload data immediately after data set is updated.
    dispatch_async(dispatch_get_main_queue(), ^{
        [cell.cardVoiceLabel setText:card[@"name"]];
        
        [cell setCardIds:errorCards[@"ids"]];
        [cell setCardErrors:errorCards[@"errors"]];
        
        [cell.collectionView reloadData];
    });
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.cardIds count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}

#pragma mark - IBActions

- (IBAction)changeRange:(id)sender
{
    if([sender isKindOfClass:[UISegmentedControl class]]) {
        NSDate *date;
        
        UISegmentedControl *control = sender;
        switch([control selectedSegmentIndex]) {
            case 0:
                date = [NSDate today];
                break;
            case 1:
                date = [NSDate firstDayOfTheWeek];
                break;
            default:
                date = [NSDate dateWithTimeIntervalSince1970:0];
                break;
        }
        
        [self fetchDataSetAfter:date];
    }
}

#pragma mark - Utility Methods

- (void)fetchDataSetAfter:(NSDate *)date {
    LTDatabase *db = [LTDatabase instance];
    NSArray *unsortedIds = [db arrayWithCardAfterDate:date];
    
    int nCards = [unsortedIds count];
    NSMutableDictionary *mappings = [NSMutableDictionary dictionaryWithCapacity:nCards];
    NSMutableDictionary *errorRates = [NSMutableDictionary dictionaryWithCapacity:nCards];
    
    for(NSNumber *cid in unsortedIds) {
        NSArray *ids = [db arrayWithErrorCardsForCard:cid afterDate:date];
        NSMutableArray *errors = [NSMutableArray arrayWithCapacity:[ids count]];
        for(NSNumber *errorCid in ids) {
            [errors addObject:[NSNumber numberWithInt:[db errorForCard:cid withErrorCard:errorCid afterDate:date]]];
        }
        
        [mappings setObject:@{@"ids": ids, @"errors": [NSArray arrayWithArray:errors]} forKey:cid];
        
        int count = [db errorForCard:cid afterDate:date],
            error = [db errorForCard:cid afterDate:date];
        [errorRates setObject:[NSNumber numberWithDouble:((double)error / count)] forKey:cid];
    }
    
    // Reload data immediately after data set is updated.
    dispatch_async(dispatch_get_main_queue(), ^{
        self.errorCards = [NSDictionary dictionaryWithDictionary:mappings];
        self.cardIds = [unsortedIds sortedArrayUsingComparator:^NSComparisonResult(id cid1, id cid2) {
            NSNumber *rate1 = errorRates[cid1], *rate2 = errorRates[cid2];
                        
            // Sorted with descending order.
            return [rate2 compare:rate1];
        }];
        
        [self.tableView reloadData];
    });
}

@end
