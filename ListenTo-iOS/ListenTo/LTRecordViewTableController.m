//
//  LTRecordViewController.m
//  ListenTo
//
//  Created by Yi Huang on 13/5/21.
//  Copyright (c) 2013年 Rabbit Wears Pants. All rights reserved.
//

#import "LTRecordViewTableController.h"
#import "LTRecordCell.h"
#import "LTDatabase.h"
#import "LTCardViewController.h"

static NSString *const SEGUE_DISPLAY_CARD_ID = @"displayCard";

@implementation LTRecordViewTableController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setOddRowBackground:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"management-odd-row-background.png"]]];
    [self setEvenRowBackground:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"management-even-row-background.png"]]];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if([identifier isEqualToString:SEGUE_DISPLAY_CARD_ID]) {
        return self.selectedID != nil;
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:SEGUE_DISPLAY_CARD_ID]) {
        if(self.selectedID == nil)
            return;
        
        LTCardViewController *detailPage = segue.destinationViewController;
        [detailPage setCid:self.selectedID];
        [self setSelectedID:nil];
        [self.navigationController pushViewController:detailPage animated:YES];
    }
    
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
    
    [cell setDelegate:self];
    
    UIImage *image = [UIImage imageNamed:card[@"image"]];
    [cell.cardImage setImage:image];
    [cell.cardImage setTag:[cid intValue]];
    [cell.cardVoiceLabel setText:card[@"name"]];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openCard:)];
    [cell.cardImage addGestureRecognizer:tapGesture];
    
    if(indexPath.row % 2 != 0)
        [cell.contentView setBackgroundColor:self.oddRowBackground];
    else
        [cell.contentView setBackgroundColor:self.evenRowBackground];
    
    // Reload data immediately after data set is updated.
    dispatch_async(dispatch_get_main_queue(), ^{
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
    return 188;
}

#pragma mark - IBActions

- (IBAction)openCard:(id)sender
{
    UIGestureRecognizer *gesture = (UIGestureRecognizer *)sender;
    [self setSelectedID:[NSNumber numberWithInt:[gesture.view tag]]];
    [self performSegueWithIdentifier:SEGUE_DISPLAY_CARD_ID sender:self];
}


#pragma mark - RecordCell Delegate

- (void)cellSelectedWithIdentity:(NSNumber*)cid
{
    [self setSelectedID:cid];
    [self performSegueWithIdentifier:SEGUE_DISPLAY_CARD_ID sender:self];
}


@end
