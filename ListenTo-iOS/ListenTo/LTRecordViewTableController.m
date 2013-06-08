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

@implementation LTRecordViewTableController

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

- (IBAction)openCard:(id)sender
{
    UIGestureRecognizer *gesture = (UIGestureRecognizer *)sender;
    [self setSelectedID:[NSNumber numberWithInt:[gesture.view tag]]];
    [self performSegueWithIdentifier:@"displayCard" sender:self];
}


#pragma mark - LTRecordCell Delegate


- (void)onCellItemSelectedWithIdentity:(NSNumber*)theID
{
    // TODO: perform seque here
    [self setSelectedID:theID];
    [self performSegueWithIdentifier:@"displayCard" sender:self];
}



@end
