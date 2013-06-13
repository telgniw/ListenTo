//
//  LTRecordViewController.m
//  ListenTo
//
//  Created by Yi Huang on 13/6/8.
//  Copyright (c) 2013年 Rabbit Wears Pants. All rights reserved.
//

#import "LTRecordViewController.h"
#import "LTDatabase.h"

@implementation LTRecordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTableViewController:self.childViewControllers[0]];
    [self changeRange:self.todayButton];
    
    [self.view setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"management-background.png"]]];
    [self.tableHeaderView setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"management-table-header.png"]]];
}

#pragma mark - IBActions

- (IBAction)home:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)changeRange:(id)sender
{
    if([sender isKindOfClass:[OBShapedButton class]]) {
        [self.selectedButton setSelected:NO];
        [self setSelectedButton:sender];
        
        NSDate *date;
        if(self.selectedButton == self.todayButton) {
            date = [NSDate today];
        }
        else if(self.selectedButton == self.thisweekButton) {
            date = [NSDate firstDayOfTheWeek];
        }
        else {
            date = [NSDate dateWithTimeIntervalSince1970:0];
        }
        
        [self.tableViewController setSelectedRange:date];
        [self fetchDataSetAfter:date];
        [self.selectedButton setSelected:YES];
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
        [self.tableViewController setErrorCards:[NSDictionary dictionaryWithDictionary:mappings]];
        [self.tableViewController setCardIds:[unsortedIds sortedArrayUsingComparator:^NSComparisonResult(id cid1, id cid2) {
            NSNumber *rate1 = errorRates[cid1], *rate2 = errorRates[cid2];
            
            // Sorted with descending order.
            return [rate2 compare:rate1];
        }]];
        
        [self.tableViewController.tableView reloadData];
    });
}

@end
