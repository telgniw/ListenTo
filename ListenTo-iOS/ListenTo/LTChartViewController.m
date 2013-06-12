//
//  LTChartViewController.m
//  ListenTo
//
//  Created by Johnny Bee on 13/6/10.
//  Copyright (c) 2013年 Rabbit Wears Pants. All rights reserved.
//

#import "LTChartViewController.h"
#import "LTDatabase.h"

@interface LTChartViewController ()

@end

@implementation LTChartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    LTDatabase *db = [LTDatabase instance];
    
    NSDictionary *card = [db cardForId:self.cid];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"review_cards_background.png"]]];
    UIImage *image = [UIImage imageNamed:card[@"image"]];
    [self.cardImage setImage:image];

}

#pragma mark - Utility Methods

- (void)fetchDataSetAfter:(NSDate *)date
{
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
        [self.tableViewController.tableView reloadData];
    });
}

- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
