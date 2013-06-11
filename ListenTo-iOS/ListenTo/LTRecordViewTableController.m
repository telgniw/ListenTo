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
#import "LTChartViewController.h"

static NSString *const SEGUE_DISPLAY_CARD_ID = @"displayCard";
static NSString *const SEGUE_DISPLAY_CHART_ID = @"displayChart";

@implementation LTRecordViewTableController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setOddRowBackground:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"management-odd-row-background.png"]]];
    [self setEvenRowBackground:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"management-even-row-background.png"]]];
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:SEGUE_DISPLAY_CARD_ID]) {
        if(self.selectedID == nil){
            return;
        }
        NSLog(@"selectedID: %@", _selectedID);
        LTCardViewController *detailPage = segue.destinationViewController;
        [detailPage setCid:self.selectedID];
        [self setSelectedID:nil];
        [self.navigationController pushViewController:detailPage animated:YES];
        
    }else if([segue.identifier isEqualToString:SEGUE_DISPLAY_CHART_ID]){
        if(self.selectedID == nil){
            return;
        }
        NSLog(@"selectedID: %@", _selectedID);
        LTChartViewController *chartPage = segue.destinationViewController;
        [chartPage setCid:self.selectedID];
        [self setSelectedID:nil];
        [self.navigationController pushViewController:chartPage animated:YES];
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
//    NSLog(@"%ld",(long)[cell.cardImage tag]);
    [cell.cardVoiceLabel setText:card[@"name"]];
    
    UITapGestureRecognizer *tapGestureOnCard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openChart:)];
    [cell.cardImage addGestureRecognizer:tapGestureOnCard];
    
    UIButton *reviewCards = [UIButton buttonWithType:UIButtonTypeCustom];
    reviewCards.frame = CGRectMake(cell.contentView.frame.size.width-80,cell.contentView.frame.size.height-120,70,70);
    [reviewCards setTitle:@"複習" forState:UIControlStateNormal];
    [reviewCards setTitleEdgeInsets:UIEdgeInsetsMake(-7, -6, 0, 0)];
    [reviewCards setBackgroundImage:[UIImage imageNamed:@"management_review_cards.png"] forState:UIControlStateNormal];
    [reviewCards setTag:[cid intValue]];
    [reviewCards addTarget:self action:@selector(openCard:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    NSLog(@"CID: %@, Button tag: %ld, Cell tag: %ld", cid, (long)[reviewCards tag], (long)[cell.cardImage tag]);
    [cell.contentView addSubview: reviewCards];
    
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

- (IBAction)openChart:(id)sender
{
    UIGestureRecognizer *gesture = (UIGestureRecognizer *)sender;
    [self setSelectedID:[NSNumber numberWithInt:[gesture.view tag]]];
    [self performSegueWithIdentifier:SEGUE_DISPLAY_CHART_ID sender:self];
}

- (IBAction)openCard:(UIButton *)sender
{
     NSLog(@"Tag: %d", [sender tag]);
    [self setSelectedID:[NSNumber numberWithInteger:sender.tag]];
    [self performSegueWithIdentifier:SEGUE_DISPLAY_CARD_ID sender:self];
}


#pragma mark - RecordCell Delegate

- (void)cellSelectedWithIdentity:(NSNumber*)cid
{
    [self setSelectedID:cid];
    [self performSegueWithIdentifier:SEGUE_DISPLAY_CHART_ID sender:self];

}


@end
