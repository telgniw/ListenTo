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
    NSMutableArray *errorCardIds = [NSMutableArray array];
    for(NSDictionary *record in self.recordsByCardId[cid]) {
        if(![cid isEqualToNumber:record[@"cid_image"]]) {
            [errorCardIds addObject:record];
        }
    }
    
    LTRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    LTDatabase *db = [LTDatabase instance];
    NSDictionary *card = [db cardForId:[cid intValue]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [cell setCardIds:[NSArray arrayWithArray:errorCardIds]];
        [cell.cardVoiceLabel setText:card[@"name"]];
        
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
                date = nil;
                break;
        }
        
        [self fetchDataSetAfter:date];
    }
}

#pragma mark - Utility Methods

- (void)fetchDataSetAfter:(NSDate *)date {
    LTDatabase *db = [LTDatabase instance];
    NSArray *unsortedIds = [db arrayWithCardIdsAfterDate:date];
    
    NSMutableDictionary *mapping = [NSMutableDictionary dictionary];
    NSMutableDictionary *errorCounts = [NSMutableDictionary dictionary];
    NSMutableDictionary *correctCounts = [NSMutableDictionary dictionary];
    for(NSNumber *cid in unsortedIds) {
        NSArray *records = [db recordsForCardId:[cid intValue] afterDate:date];
        int correctCount = 0, errorCount = 0;
        for(NSDictionary *record in records) {
            int count = [record[@"count"] intValue];
            if([cid isEqualToNumber:record[@"cid_image"]]) {
                correctCount += count;
            }
            else {
                errorCount += count;
            }
        }
        [mapping setObject:records forKey:cid];
        [errorCounts setObject:[NSNumber numberWithInt:errorCount] forKey:cid];
        [correctCounts setObject:[NSNumber numberWithInt:correctCount] forKey:cid];
    }
    
    // Reload data immediately after data set is updated.
    dispatch_async(dispatch_get_main_queue(), ^{
        self.recordsByCardId = [NSDictionary dictionaryWithDictionary:mapping];
        self.cardIds = [unsortedIds sortedArrayUsingComparator:^NSComparisonResult(id cid1, id cid2) {
            int errorCount1 = [errorCounts[cid1] intValue], correctCount1 = [correctCounts[cid1] intValue],
            errorCount2 = [errorCounts[cid2] intValue], correctCount2 = [correctCounts[cid2] intValue];
            double rate1 = (double)errorCount1 / (errorCount1 + correctCount1),
            rate2 = (double)errorCount2 / (errorCount2 + correctCount2);
            
            // Sorted with descending order.
            return [[NSNumber numberWithDouble:rate2] compare:[NSNumber numberWithDouble:rate1]];
        }];
        
        [self.tableView reloadData];
    });
}

@end
