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

@implementation LTRecordCell

#pragma mark - Data Source

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"LTErrorCell";
    LTRecordErrorImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if(cell == nil) {
        // TODO: handle cell nil.
    }
    
    NSDictionary *errorCard = self.cardIds[indexPath.row];
    NSNumber *cid = errorCard[@"cid_image"];
    
    LTDatabase *db = [LTDatabase instance];
    NSDictionary *card = [db cardForId:[cid intValue]];
    [cell.imageView setImage:[UIImage imageNamed:card[@"image"]]];
    
    [cell.countLabel setText:[errorCard[@"count"] stringValue]];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.cardIds count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

@end
