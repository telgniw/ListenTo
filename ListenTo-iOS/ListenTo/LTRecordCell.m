//
//  LTRecordCell.m
//  ListenTo
//
//  Created by Yi Huang on 13/5/28.
//  Copyright (c) 2013年 Rabbit Wears Pants. All rights reserved.
//

#import "LTRecordCell.h"
#import "LTRecordErrorImageCell.h"
#import "LTDatabase.h"
#import "LTCardViewController.h"

@implementation LTRecordCell

#pragma mark - Data Source

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"LTErrorCell";
    
    NSNumber *cid = self.cardIds[indexPath.row];
    
    LTDatabase *db = [LTDatabase instance];
    self.card = [db cardForId:cid];
    
    LTRecordErrorImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell.imageView setImage:[UIImage imageNamed:_card[@"image"]]];
    [cell.countLabel setText:[self.cardErrors[indexPath.row] stringValue]];
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
//    NSUInteger row = indexPath.row;

    if (self.delegate){
        NSNumber *cid = self.cardIds[indexPath.row];
        [self.delegate onCellItemSelectedWithIdentity: cid];
    }
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.cardIds count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    
//    NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];    
//    if ([segue.identifier isEqualToString:@"showCard"]) {
//        
//        UITabBarController  *tabBarController = segue.destinationViewController;
//        
//        LTCardViewController *detailPage = (LTCardViewController *)[[tabBarController customizableViewControllers] objectAtIndex:0];
//        detailPage.cid = [NSNumber numberWithInt:self.cardIds[indexPath.row]];
//    }
//    
//}

@end
