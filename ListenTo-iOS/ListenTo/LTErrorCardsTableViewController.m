//
//  LTErrorCardsTableViewController.m
//  ListenTo
//
//  Created by Yi Huang on 13/6/14.
//  Copyright (c) 2013年 Rabbit Wears Pants. All rights reserved.
//

#import "LTErrorCardsTableViewController.h"
#import "LTCardCell.h"
#import "LTDatabase.h"

@implementation LTErrorCardsTableViewController

#pragma mark - Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.errorCards count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdendifier = @"LTCardCell";
    
    LTCardCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdendifier];
    NSNumber *cid = self.errorCards[indexPath.row];
    
    NSDictionary *currentCard = [[LTDatabase instance] cardForId:cid];
    [cell.cardImageView setImage:[UIImage imageNamed:[currentCard objectForKey:LT_DB_KEY_CARD_IMAGE]]];
    [cell.cardImageView setTag:[cid integerValue]];
    [cell.cardLabel setText:[currentCard objectForKey:LT_DB_KEY_CARD_NAME]];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.delegate action:@selector(reloadCards:)];
    [cell.cardImageView addGestureRecognizer:tapGesture];
    
    return cell;
}

#pragma mark - Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}

@end
