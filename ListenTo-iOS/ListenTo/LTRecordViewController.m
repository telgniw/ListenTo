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
#import "LTCardViewController.h"

@implementation LTRecordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    [self.myTableView setBackgroundView:background];
    [self.tableHeaderView setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"management-table-header.png"]]];
    
    [self changeRange:self.todayButton];
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
    
    cell.delegate = self;
    
    // Reload data immediately after data set is updated.
    dispatch_async(dispatch_get_main_queue(), ^{
        [cell.cardVoiceLabel setText:card[@"name"]];
        UIImage *image = [UIImage imageNamed:card[@"image"]];
        cell.cardImage.image = image;
        [cell setCardIds:errorCards[@"ids"]];
        [cell setCardErrors:errorCards[@"errors"]];
        cell.cardImage.tag = [cid intValue];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openCard:)];
        [cell.cardImage addGestureRecognizer:tapGesture];

        [cell.collectionView reloadData];
    });
    
    return cell;
}

- (IBAction)openCard:(id)sender
{
    UIGestureRecognizer *gesture = (UIGestureRecognizer *)sender;
    [self setSelectedID:[NSNumber numberWithInt:[gesture.view tag]]];
    [self performSegueWithIdentifier:@"displayCard" sender:self];
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
    return 188;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"displayCard"]) {

        if (sender != self) return;
        LTCardViewController *detailPage = segue.destinationViewController;
        detailPage.cid = self.selectedID;
        [self.navigationController pushViewController:detailPage animated:YES];
    }
    
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
        self.errorCards = [NSDictionary dictionaryWithDictionary:mappings];
        self.cardIds = [unsortedIds sortedArrayUsingComparator:^NSComparisonResult(id cid1, id cid2) {
            NSNumber *rate1 = errorRates[cid1], *rate2 = errorRates[cid2];
                        
            // Sorted with descending order.
            return [rate2 compare:rate1];
        }];
        
        [self.myTableView reloadData];
    });
}


#pragma mark - LTRecordCell Delegate


- (void)onCellItemSelectedWithIdentity:(NSNumber*)theID
{
    // TODO: perform seque here
    [self setSelectedID:theID];
    [self performSegueWithIdentifier:@"displayCard" sender:self];
}



@end
